import 'dart:async';
import 'package:flutter/services.dart';

/// Native Windows serial port reader using platform channel
class NativeSerialReader {
  static const MethodChannel _channel = MethodChannel('com.quanly/serial_port');

  /// Read one line from serial port (blocks until CR received or timeout)
  /// Returns null on timeout or error
  static Future<String?> readLine({
    required String port,
    int baudRate = 9600,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    try {
      final result = await _channel.invokeMethod<String>(
        'readLine',
        {
          'port': port,
          'baudRate': baudRate,
          'timeoutMs': timeout.inMilliseconds,
        },
      );
      return result;
    } on PlatformException catch (e) {
      print('NativeSerialReader error: ${e.message}');
      return null;
    }
  }

  /// Get available COM ports
  static Future<List<String>> getAvailablePorts() async {
    try {
      final result = await _channel.invokeMethod<List<dynamic>>('getAvailablePorts');
      return result?.map((e) => e.toString()).toList() ?? [];
    } on PlatformException catch (e) {
      print('NativeSerialReader getAvailablePorts error: ${e.message}');
      return [];
    }
  }
}

