import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:quanly/core/base/base_controller.dart';
import 'package:quanly/data/models/indentity_card_model.dart';
import 'package:quanly/extension/indentity_parse_extension.dart';

class QrReaderController extends BaseController{
  final availablePorts = <String>[].obs;

  final selectedPort = Rxn<String>();
  SerialPort? _port;
  SerialPortReader? _reader;
  ChunkedConversionSink<List<int>>? _decoderSink;
  StringBuffer? _textBuffer;

  // Reactive flags exposed for UI
  final isListening = false.obs;
  final lastData = Rxn<String>();
  final parsedCard = Rxn<IndentityCardModel>();
  // Stream for immediate consumption when a full raw card string is parsed
  // Use sync:true so listeners receive data immediately (avoids delayed delivery under heavy IO).
  final _cardStreamController = StreamController<String>.broadcast(sync: true);

  Stream<String> get onCard => _cardStreamController.stream;

  @override
  void onInit() {
    super.onInit();

    fetchPorts();
  }

  @override
  void onClose() {
    stopListening();
    try {
      _cardStreamController.close();
    } catch (_) {}
    super.onClose();
  }

  Future<void> fetchPorts() async {
    final ports = SerialPort.availablePorts;
    availablePorts.assignAll(ports);

    try {
      if (availablePorts.contains('COM34')) {
        selectedPort.value = 'COM34';
      } else {
        selectedPort.value = availablePorts.isNotEmpty ? availablePorts.first : null;
      }
    } catch (_) {
      selectedPort.value = availablePorts.isNotEmpty ? availablePorts.first : null;
    }
  }

  void selectPort(String port) {
    if (isListening.value) {
      showError("Vui lòng dừng đọc trước khi đổi cổng COM");
      return;
    }
    selectedPort.value = port;
  }

  Future<void> closePort() async {
    if(_port == null) {
      showError("Chưa có cổng nào được mở");
      return;
    }

    try {
      _port!.close();
      _port = null;
      showSuccess("Đã đóng cổng thành công");
    } catch (e) {
      showError("Lỗi khi đóng cổng: $e");
    }
  }

  /// Start listening in a loop. Call `stopListening` to end.
  void startListening() async {
    if (isListening.value) return;
    isListening.value = true;

    if (selectedPort.value == null) {
      await fetchPorts();
    }
    if (selectedPort.value == null) {
      showError('Không tìm thấy cổng COM nào');
      isListening.value = false;
      return;
    }

    try {
      _port = SerialPort(selectedPort.value!);
      final config = SerialPortConfig()
        ..baudRate = 9600
        ..bits = 8
        ..stopBits = 1
        ..parity = SerialPortParity.none;
      
      _port!.config = config;
      
      if (!_port!.openReadWrite()) {
        showError('Không thể mở cổng ${selectedPort.value}: ${SerialPort.lastError?.message}');
        isListening.value = false;
        return;
      }
      
      showSuccess('Đã bắt đầu đọc từ cổng ${selectedPort.value}');
      
      _reader = SerialPortReader(_port!);

      // Setup chunked UTF-8 decoder to assemble multi-byte characters (Vietnamese)
      _textBuffer = StringBuffer();
      final stringSink = StringConversionSink.withCallback((decoded) {
        if (decoded.isEmpty) return;
        _textBuffer!.write(decoded);

        // IMPORTANT: parse by LINE terminator (CR or LF) like Python's readline().
        // CCCD scanners typically send: 042204001446||Nguyễn Văn Giáp|...|31032021\r
        // Note: Some devices send only \r (0x0d), not \r\n
        final current = _textBuffer!.toString();
        // Split on CR or LF (handles both \r, \n, and \r\n)
        final lines = current.split(RegExp(r"[\r\n]+"));
        // Check if buffer ends with line terminator (CR or LF)
        final endsWithLineTerminator = current.isNotEmpty && 
            (current.endsWith('\r') || current.endsWith('\n'));
        final completeCount = endsWithLineTerminator ? lines.length : lines.length - 1;

        for (var i = 0; i < completeCount; i++) {
          final line = lines[i].trim();
          if (line.isEmpty) continue;

          // Normalize double pipes (empty field) while keeping overall ordering predictable.
          final rawData = line.replaceAll('||', '|');

          lastData.value = rawData;
          parsedCard.value = rawData.toIndentityCardModel();

          // Emit raw data immediately for any listeners
          try {
            _cardStreamController.add(rawData);
          } catch (e) {
            // If this happens, the stream was likely closed/disposed.
            print('⚠ onCard stream add failed: $e');
          }

          print(
            '✓ Parsed card: ${parsedCard.value?.fullName} | ${parsedCard.value?.indentityNumber} | ${parsedCard.value?.sex} | ${parsedCard.value?.createAt} | ${parsedCard.value?.address}',
          );
          print('✓ lastData.value = $rawData');
        }

        // keep remainder (incomplete line that doesn't end with terminator yet)
        _textBuffer!.clear();
        if (!endsWithLineTerminator && lines.isNotEmpty) {
          _textBuffer!.write(lines.last);
        }
      });

      _decoderSink = utf8.decoder.startChunkedConversion(stringSink);

      _reader!.stream.listen((data) {
        try {
          _decoderSink?.add(data);
        } catch (_) {}
      }, onError: (error) {
        if (isListening.value) showError('Lỗi đọc dữ liệu: $error');
      }, onDone: () {
        if (isListening.value) stopListening();
      });
    } catch (e) {
      showError('Lỗi khi mở cổng: $e');
      isListening.value = false;
      return;
    }
  }

  /// Start a one-shot QR/CCCD scan: opens port, waits for the next
  /// `parsedCard` value, then stops and returns it.
  /// Returns `null` on timeout or error.
  Future<String?> startQrScan({Duration timeout = const Duration(seconds: 30)}) async {
    if (isListening.value) {
      showError('Đang đọc dữ liệu. Vui lòng dừng trước khi bắt đầu quét mới');
      return null;
    }

    final completer = Completer<String?>();
    
    // Clear previous data to detect new scan
    parsedCard.value = null;
    lastData.value = null;

    // Setup worker BEFORE starting listener and use debounce to ensure full data
    late final Worker worker;
    Timer? debounceTimer;
    worker = ever(parsedCard, (data) {
      if (data != null && !completer.isCompleted) {
        // debounce 150ms to allow additional chunks to arrive
        debounceTimer?.cancel();
        debounceTimer = Timer(const Duration(milliseconds: 150), () {
          if (!completer.isCompleted) {
            print('startQrScan: [WORKER] Debounced received card data');
            completer.complete(lastData.value);
          }
        });
      }
    });

    // Start polling in parallel (every 100ms) to catch data immediately as a backup
    Timer? pollTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (parsedCard.value != null && !completer.isCompleted) {
        debounceTimer?.cancel();
        debounceTimer = Timer(const Duration(milliseconds: 150), () {
          if (!completer.isCompleted) {
            print('startQrScan: [POLLING] Debounced detected card data');
            completer.complete(lastData.value);
          }
        });
      }
    });

    try {
      print('startQrScan: Starting listener...');
      startListening();

      final result = await Future.any([
        completer.future,
        Future.delayed(timeout, () {
          print('startQrScan: Timeout reached');
          return null;
        }),
      ]);

      // Cleanup
      pollTimer.cancel();
      debounceTimer?.cancel();
      worker.dispose();
      stopListening();

      print('startQrScan: Returning result: ${result != null ? "DATA_RECEIVED" : "NULL"}');
      return result;
    } catch (e) {
      pollTimer.cancel();
      worker.dispose();
      stopListening();
      showError('Lỗi khi quét: $e');
      return null;
    }
  }

  void stopListening() async {
    if (!isListening.value) return;
    isListening.value = false;
    try {
      _reader?.close();
      _reader = null;
      // Close decoder sink to flush any remaining decoded chars
      _decoderSink?.close();
      _decoderSink = null;
      _textBuffer = null;
      _port?.close();
      _port = null;
      showSuccess('Đã dừng đọc');
    } catch (e) {
      showError('Lỗi khi đóng cổng: $e');
    }
  }
}