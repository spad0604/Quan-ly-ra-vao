import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/core/base/base_controller.dart';
import 'package:quanly/core/qr_reader/native_serial_reader.dart';
import 'package:quanly/core/qr_reader/qr_reader_controller.dart';
import 'package:quanly/extension/indentity_parse_extension.dart';
import 'package:quanly/presentation/personal/widget/add_personal_popup.dart';

class PersonalController extends BaseController{
  bool _scanInProgress = false;
  final TextEditingController nameController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController dateOfBirthController = TextEditingController();

  // IMPORTANT: don't keep a potentially-stale reference if GetX recreates controllers.
  QrReaderController get qrReaderController => Get.find<QrReaderController>();

  RxString sex = ''.obs;
  void showAddPersonalPopup() {
    showDialog(
      context: Get.context!,
      builder: (context) => const AddPersonalPopup(),
    );
  }

  void scanQrCode() async {
    if (_scanInProgress) return;
    _scanInProgress = true;
    print('scanQrCode: Starting native serial scan');

    // Show loading indicator
    showLoading(message: 'Đang đọc CCCD...');

    // Clear previous values
    qrReaderController.parsedCard.value = null;
    qrReaderController.lastData.value = null;

    try {
      final port = qrReaderController.selectedPort.value ?? 'COM34';
      print('scanQrCode: Reading from $port...');
      
      // Run on isolate/background to avoid blocking UI
      // Read line with timeout - this blocks until data arrives or timeout
      final rawData = await Future(() async {
        return await NativeSerialReader.readLine(
          port: port,
          baudRate: 9600,
          timeout: const Duration(seconds: 20),
        );
      });

      // Hide loading
      hideLoading();

      if (rawData != null && rawData.isNotEmpty) {
        print('scanQrCode: Received data: $rawData');
        final model = rawData.toIndentityCardModel();
        
        idController.text = model.indentityNumber;
        nameController.text = model.fullName;
        addressController.text = model.address;

        final rawDate = model.createAt;
        if (rawDate.length == 8) {
          final day = rawDate.substring(0, 2);
          final month = rawDate.substring(2, 4);
          final year = rawDate.substring(4);
          dateOfBirthController.text = '$day/$month/$year';
        } else {
          dateOfBirthController.text = model.createAt;
        }

        sex.value = model.sex;
        print('scanQrCode: Filled fields: ${model.fullName}');
        showSuccess('Đã đọc CCCD thành công!');
      } else {
        print('scanQrCode: Timeout or no data received');
        showError('Không nhận được dữ liệu. Vui lòng thử lại.');
      }
    } catch (e) {
      hideLoading();
      print('scanQrCode: error: $e');
      showError('Lỗi khi đọc CCCD: $e');
    } finally {
      _scanInProgress = false;
    }
  }
}