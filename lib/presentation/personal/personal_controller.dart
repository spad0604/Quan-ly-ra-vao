import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart' show Value;
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/core/authentication/authentication_service.dart';
import 'package:quanly/core/base/base_controller.dart';
import 'package:quanly/core/qr_reader/native_serial_reader.dart';
import 'package:quanly/core/qr_reader/qr_reader_controller.dart';
import 'package:quanly/extension/indentity_parse_extension.dart';
import 'package:quanly/presentation/personal/widget/add_personal_popup.dart';
import 'package:quanly/presentation/home/controllers/staff_controller.dart';
import 'package:quanly/presentation/home/controllers/dashboard_controller.dart';
import 'package:uuid/uuid.dart';

class PersonalController extends BaseController{
  bool _scanInProgress = false;

  final AuthenticationService authenticationService = AuthenticationService();
  
  final TextEditingController nameController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController dateOfBirthController = TextEditingController();

  final TextEditingController positionController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController officerNumberController = TextEditingController();

  final TextEditingController rankController = TextEditingController();

  RxString departmentId = ''.obs;

  // IMPORTANT: don't keep a potentially-stale reference if GetX recreates controllers.
  QrReaderController get qrReaderController => Get.find<QrReaderController>();

  RxList<DepartmentTableData> departments = <DepartmentTableData>[].obs;

  Rx<List<MemberTableData>> members = Rx<List<MemberTableData>>([]);

  RxString sex = ''.obs;

  RxString imageUrl = ''.obs; // Relative path to image stored in AppData

  @override
  void onInit() {
    super.onInit();
    getDepartments();
  }

  void showAddPersonalPopup() {
    // Refresh departments before showing popup
    getDepartments();
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) => const AddPersonalPopup(),
    );
  }

  Future<void> getDepartments() async {
    try {
      final list = await AppDatabase.instance.getAllDepartments();
      departments.assignAll(list);
    } catch (e) {
      showError('Lỗi khi lấy danh sách phòng ban: $e');
    }
  }

  void scanQrCode() async {
    if (_scanInProgress) return;
    _scanInProgress = true;
    debugPrint('scanQrCode: Starting native serial scan');

    // Show loading indicator
    showLoading(message: 'Đang đọc CCCD...');

    // Clear previous values
    qrReaderController.parsedCard.value = null;
    qrReaderController.lastData.value = null;

    try {
      final port = qrReaderController.selectedPort.value ?? 'COM34';
      debugPrint('scanQrCode: Reading from $port...');
      
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
        debugPrint('scanQrCode: Received data: $rawData');
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
        debugPrint('scanQrCode: Filled fields: ${model.fullName}');
        showSuccess('Đã đọc CCCD thành công!');
      } else {
        debugPrint('scanQrCode: Timeout or no data received');
        showError('Không nhận được dữ liệu. Vui lòng thử lại.');
      }
    } catch (e) {
      hideLoading();
      debugPrint('scanQrCode: error: $e');
      showError('Lỗi khi đọc CCCD: $e');
    } finally {
      _scanInProgress = false;
    }
  }

  Future<void> addPersonal() async {
    try {
      showLoading(message: 'Đang thêm cán bộ...');
      
      final MemberTableCompanion member = MemberTableCompanion(
        id: Value(Uuid().v4()),
        name: Value(nameController.text.trim()),
        phoneNumber: Value(phoneNumberController.text.trim()),
        identityNumber: Value(authenticationService.encodeIndentityNumber(idController.text.trim())),
        imageUrl: Value(imageUrl.value),
        address: Value(addressController.text.trim()),
        dateOfBirth: Value(dateOfBirthController.text.trim()),
        departmentId: Value(departmentId.value),
        position: Value(positionController.text.trim()),
        sex: Value(sex.value),
        officerNumber: Value(officerNumberController.text.trim()),
        rank: Value(rankController.text.trim()),
      );

      await AppDatabase.instance.createMemeber(member);
      
      // Hide loading FIRST before closing popup
      hideLoading();
      
      // Wait a bit to ensure loading is closed
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Clear form
      _clearForm();
      
      // Close popup (AddPersonalPopup dialog)
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      
      // Show success and refresh after popup is closed
      Future.microtask(() {
        showSuccess('Thêm cán bộ thành công!');
        _refreshStaffController();
      });
    } catch (e) {
      // Ensure loading is hidden on error
      hideLoading();
      showError('Lỗi khi thêm cán bộ: $e');
    }
  }

  void _clearForm() {
    nameController.clear();
    idController.clear();
    addressController.clear();
    dateOfBirthController.clear();
    positionController.clear();
    phoneNumberController.clear();
    officerNumberController.clear();
    rankController.clear();
    departmentId.value = '';
    sex.value = '';
    imageUrl.value = '';
  }

  /// Check if all required fields are filled (except avatar)
  bool get isFormValid {
    return nameController.text.trim().isNotEmpty &&
        idController.text.trim().isNotEmpty &&
        addressController.text.trim().isNotEmpty &&
        dateOfBirthController.text.trim().isNotEmpty &&
        sex.value.isNotEmpty &&
        departmentId.value.isNotEmpty &&
        positionController.text.trim().isNotEmpty &&
        officerNumberController.text.trim().isNotEmpty &&
        rankController.text.trim().isNotEmpty &&
        phoneNumberController.text.trim().isNotEmpty;
  }
  
  void _refreshStaffController() {
    try {
      // Import needed controllers here if not already imported
      // For now, we'll use Get.find to refresh StaffController
      if (Get.isRegistered<StaffController>()) {
        final staffController = Get.find<StaffController>();
        staffController.getMembers(showLoading: false); // Don't show loading when refreshing
      }
      // Also refresh dashboard
      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        dashboardController.refreshAllData();
      }
    } catch (e) {
      // Controllers not found, ignore
    }
  }
}