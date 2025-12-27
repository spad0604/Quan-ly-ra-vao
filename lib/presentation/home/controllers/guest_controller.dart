import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart' show Value;
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/app/database/time_management_table.dart';
import 'package:quanly/core/base/base_controller.dart';
import 'package:quanly/core/qr_reader/native_serial_reader.dart';
import 'package:quanly/core/qr_reader/qr_reader_controller.dart';
import 'package:quanly/extension/indentity_parse_extension.dart';
import 'package:uuid/uuid.dart';

class GuestController extends BaseController {
  bool _scanInProgress = false;
  
  // Text Controllers
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final addressController = TextEditingController();
  final reasonController = TextEditingController(); // Lý do vào
  final dateOfBirthController = TextEditingController(); // Ngày sinh để hiển thị
  
  final _sex = ''.obs;
  String get sex => _sex.value;

  // QrReader reference
  QrReaderController get qrReaderController => Get.find<QrReaderController>();

  // Database
  final _db = AppDatabase.instance;

  @override
  void onClose() {
    nameController.dispose();
    idController.dispose();
    addressController.dispose();
    reasonController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }

  void scanQrCode() async {
    if (_scanInProgress) return;
    _scanInProgress = true;
    
    showLoading(message: 'Đang đọc thẻ CCCD...');
    
    try {
      final port = qrReaderController.selectedPort.value ?? 'COM34'; // Default fallback
      
      final rawData = await Future(() async {
        return await NativeSerialReader.readLine(
          port: port,
          baudRate: 9600,
          timeout: const Duration(seconds: 20),
        );
      });

      hideLoading();

      if (rawData != null && rawData.isNotEmpty) {
        final model = rawData.toIndentityCardModel();
        
        idController.text = model.indentityNumber;
        nameController.text = model.fullName;
        addressController.text = model.address;
        
        // Format DOB
        final rawDate = model.createAt;
        if (rawDate.length == 8) {
          final day = rawDate.substring(0, 2);
          final month = rawDate.substring(2, 4);
          final year = rawDate.substring(4);
          dateOfBirthController.text = '$day/$month/$year';
        } else {
          dateOfBirthController.text = model.createAt;
        }

        _sex.value = model.sex;
        
        showSuccess('Đọc thẻ thành công: ${model.fullName}');
      } else {
        showError('Không nhận được dữ liệu hoặc hết thời gian.');
      }
    } catch (e) {
      hideLoading();
      showError('Lỗi khi quét: $e');
    } finally {
      _scanInProgress = false;
    }
  }

  Future<void> checkIn() async {
    if (nameController.text.isEmpty || idController.text.isEmpty) {
      showError('Vui lòng quét thẻ hoặc nhập thông tin khách');
      return;
    }

    try {
      showLoading(message: 'Đang xử lý check-in...');

      // 1. Create/Update AnonymusTable
      // Check if guest exists by ID card? For simplicity, we just insert or ignore conflict (if ID is unique)
      // Or select first.
      
      // Let's generate a consistent ID for the guest based on IdentityNumber to reuse records?
      // Or just a new UUID every time? Ideally unique by IdentityNumber.
      // Database definition for AnonymusTable primary key is 'id' (UUID usually).
      
      // Check existing guest by identityNumber
      final existingGuest = await (_db.select(_db.anonymusTable)
        ..where((tbl) => tbl.identityNumber.equals(idController.text.trim())))
        .getSingleOrNull();

      String guestId;

      if (existingGuest != null) {
        guestId = existingGuest.id;
        // Update info if needed
        await (_db.update(_db.anonymusTable)..where((tbl) => tbl.id.equals(guestId))).write(
          AnonymusTableCompanion(
            name: Value(nameController.text.trim()),
            address: Value(addressController.text.trim()),
            dateOfBirth: Value(dateOfBirthController.text.trim()),
            reason: Value(reasonController.text.trim()),
          ),
        );
      } else {
        guestId = const Uuid().v4();
        await _db.into(_db.anonymusTable).insert(
          AnonymusTableCompanion(
            id: Value(guestId),
            name: Value(nameController.text.trim()),
            identityNumber: Value(idController.text.trim()),
            address: Value(addressController.text.trim()),
            dateOfBirth: Value(dateOfBirthController.text.trim()),
            reason: Value(reasonController.text.trim()),
          ),
        );
      }

      // 2. Create TimeManagement check-in record
      final timeId = const Uuid().v4();
      await _db.into(_db.timeManagementTable).insert(
        TimeManagementTableCompanion(
          id: Value(timeId),
          memberId: Value(guestId),
          checkInTime: Value(DateTime.now()),
          note: Value(reasonController.text.trim()), // Save reason here
          status: const Value('IN'),
          role: const Value('anonymus'), // Enum string value
        ),
      );

      hideLoading();
      showSuccess('Check-in thành công cho khách: ${nameController.text}');
      clearForm();

    } catch (e) {
      hideLoading();
      showError('Lỗi check-in: $e');
    }
  }

  void clearForm() {
    nameController.clear();
    idController.clear();
    addressController.clear();
    reasonController.clear();
    dateOfBirthController.clear();
    _sex.value = '';
  }
}

