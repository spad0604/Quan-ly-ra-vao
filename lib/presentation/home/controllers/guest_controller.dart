import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart' show Value;
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/app/database/time_management_table.dart';
import 'package:quanly/core/authentication/authentication_service.dart';
import 'package:quanly/core/base/base_controller.dart';
import 'package:quanly/core/qr_reader/native_serial_reader.dart';
import 'package:quanly/core/qr_reader/qr_reader_controller.dart';
import 'package:quanly/extension/indentity_parse_extension.dart';
import 'package:quanly/presentation/home/widgets/qr_data_dialog.dart';
import 'package:uuid/uuid.dart';

class GuestController extends BaseController {
  bool _scanInProgress = false;

  /// 0: QR (check-in/out), 1: CCCD/Guest form
  final scanMode = 0.obs;

  final lastScanTitle = RxnString();
  final lastScanMessage = RxnString();
  final lastScanName = RxnString(); // Store name separately for display
  final lastScanIsSuccess = false.obs;

  // last generated guest QR (after check-in)
  final lastGuestId = RxnString();
  final lastGuestName = RxnString();

  // Text Controllers
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final addressController = TextEditingController();
  final reasonController = TextEditingController(); // Lý do vào
  final dateOfBirthController =
      TextEditingController(); // Ngày sinh để hiển thị

  final _sex = ''.obs;
  String get sex => _sex.value;

  // QrReader reference
  QrReaderController get qrReaderController => Get.find<QrReaderController>();

  // Database
  final _db = AppDatabase.instance;
  final _authenticationService = AuthenticationService();

  @override
  void onClose() {
    nameController.dispose();
    idController.dispose();
    addressController.dispose();
    reasonController.dispose();
    dateOfBirthController.dispose();
    super.onClose();
  }

  void setMode(int mode) {
    scanMode.value = mode;
  }

  Future<void> scanQrOrCccd() async {
    if (_scanInProgress) return;
    _scanInProgress = true;

    showLoading(message: 'qr_scan_loading'.tr);

    try {
      final port =
          qrReaderController.selectedPort.value ?? 'COM34'; // Default fallback

      final rawData = await Future(() async {
        return await NativeSerialReader.readLine(
          port: port,
          baudRate: 9600,
          timeout: const Duration(seconds: 20),
        );
      });

      hideLoading();

      if (rawData != null && rawData.isNotEmpty) {
        final data = rawData.trim();

        // Heuristic: CCCD payload usually contains separators and can be parsed.
        final isCccdPayload = data.contains('|');
        if (isCccdPayload) {
          try {
            final model = data.toIndentityCardModel();
            
            // Check if this CCCD belongs to a staff member
            // Note: getMemberByIdentityNumber will encode the identityNumber before comparing with database
            final member = await _db.getMemberByIdentityNumber(model.indentityNumber);
            if (member != null) {
              // This is a staff member - auto check-in/out
              final newStatus = await _db.toggleEntryExit(
                memberId: member.id,
                role: Role.member.value,
              );

              final isEntry = newStatus == Status.entry.value;
              lastScanTitle.value =
                  isEntry ? 'qr_checkin_title'.tr : 'qr_checkout_title'.tr;
              lastScanName.value = member.name;
              lastScanMessage.value = isEntry
                  ? 'qr_checkin_success'.trParams({'name': member.name})
                  : 'qr_checkout_success'.trParams({'name': member.name});
              lastScanIsSuccess.value = true;

              showSuccess(lastScanMessage.value!);
              return;
            }
            
            // Not a staff member - treat as guest, switch to guest form mode and fill fields
            scanMode.value = 1;

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

            lastScanTitle.value = 'guest_scan_success_title'.tr;
            lastScanMessage.value = 'guest_scan_success_message'
                .trParams({'name': model.fullName});
            lastScanIsSuccess.value = true;

            showSuccess(lastScanMessage.value!);
            return;
          } catch (_) {
            // fallthrough: treat as QR payload
          }
        }

        // Treat as QR id
        scanMode.value = 0;
        await _handleQrId(data);
      } else {
        showError('qr_scan_no_data'.tr);
      }
    } catch (e) {
      hideLoading();
      showError('qr_scan_error'.trParams({'error': e.toString()}));
    } finally {
      _scanInProgress = false;
    }
  }

  Future<void> _handleQrId(String qrId) async {
    try {
      // 1) Try staff
      final member = await _db.getMemberById(qrId);
      if (member != null) {
        final newStatus = await _db.toggleEntryExit(
          memberId: member.id,
          role: Role.member.value,
        );

        final isEntry = newStatus == Status.entry.value;
        lastScanTitle.value =
            isEntry ? 'qr_checkin_title'.tr : 'qr_checkout_title'.tr;
        lastScanName.value = member.name;
        lastScanMessage.value = isEntry
            ? 'qr_checkin_success'.trParams({'name': member.name})
            : 'qr_checkout_success'.trParams({'name': member.name});
        lastScanIsSuccess.value = true;

        showSuccess(lastScanMessage.value!);
        return;
      }

      // 2) Try guest
      final guest = await _db.getGuestById(qrId);
      if (guest != null) {
        final newStatus = await _db.toggleEntryExit(
          memberId: guest.id,
          role: Role.anonymus.value,
          note: guest.reason,
        );
        final isEntry = newStatus == Status.entry.value;
        lastScanTitle.value =
            isEntry ? 'qr_checkin_title'.tr : 'qr_checkout_title'.tr;
        lastScanName.value = guest.name;
        lastScanMessage.value = isEntry
            ? 'qr_checkin_success'.trParams({'name': guest.name})
            : 'qr_checkout_success'.trParams({'name': guest.name});
        lastScanIsSuccess.value = true;

        showSuccess(lastScanMessage.value!);
        return;
      }

      lastScanTitle.value = 'qr_invalid_title'.tr;
      lastScanMessage.value = 'qr_invalid_message'.tr;
      lastScanName.value = null;
      lastScanIsSuccess.value = false;
      showError(lastScanMessage.value!);
    } catch (e) {
      lastScanTitle.value = 'qr_scan_error_title'.tr;
      lastScanMessage.value = 'qr_scan_error'
          .trParams({'error': e.toString()});
      lastScanName.value = null;
      lastScanIsSuccess.value = false;
      showError(lastScanMessage.value!);
    }
  }

  Future<void> checkIn() async {
    if (nameController.text.isEmpty || idController.text.isEmpty) {
      showError('guest_validation_required'.tr);
      return;
    }

    try {
      showLoading(message: 'guest_checkin_loading'.tr);

      // 1. Create/Update AnonymusTable
      // Check if guest exists by ID card? For simplicity, we just insert or ignore conflict (if ID is unique)
      // Or select first.

      // Let's generate a consistent ID for the guest based on IdentityNumber to reuse records?
      // Or just a new UUID every time? Ideally unique by IdentityNumber.
      // Database definition for AnonymusTable primary key is 'id' (UUID usually).

      // Encode identityNumber before saving
      final encodedIdentityNumber = _authenticationService.encodeIndentityNumber(idController.text.trim());
      
      // Check existing guest by encoded identityNumber
      final existingGuest = await _db.getGuestByIdentityNumber(idController.text.trim());

      String guestId;

      if (existingGuest != null) {
        guestId = existingGuest.id;
        await (_db.update(
          _db.anonymusTable,
        )..where((tbl) => tbl.id.equals(guestId))).write(
          AnonymusTableCompanion(
            name: Value(nameController.text.trim()),
            address: Value(addressController.text.trim()),
            dateOfBirth: Value(dateOfBirthController.text.trim()),
            reason: Value(reasonController.text.trim()),
          ),
        );
      } else {
        guestId = const Uuid().v4();
        await _db
            .into(_db.anonymusTable)
            .insert(
              AnonymusTableCompanion(
                id: Value(guestId),
                name: Value(nameController.text.trim()),
                identityNumber: Value(encodedIdentityNumber),
                address: Value(addressController.text.trim()),
                dateOfBirth: Value(dateOfBirthController.text.trim()),
                reason: Value(reasonController.text.trim()),
              ),
            );
      }

      // 2. Toggle entry/exit (usually will create ENTRY)
      await _db.toggleEntryExit(
        memberId: guestId,
        role: Role.anonymus.value,
        note: reasonController.text.trim(),
      );

      hideLoading();
      showSuccess(
        'guest_checkin_success'.trParams({'name': nameController.text.trim()}),
      );

      // Save last guest QR and show it
      lastGuestId.value = guestId;
      lastGuestName.value = nameController.text.trim();
      Get.dialog(
        QrDataDialog(
          title: 'guest_qr_title'.tr,
          name: lastGuestName.value ?? '',
          subtitle: 'guest_qr_subtitle'.tr,
          qrData: guestId,
        ),
        barrierDismissible: true,
      );

      clearForm();
    } catch (e) {
      hideLoading();
      showError('guest_checkin_error'.trParams({'error': e.toString()}));
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
