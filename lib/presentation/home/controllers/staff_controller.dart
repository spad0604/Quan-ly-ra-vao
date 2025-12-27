import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart' show Value;
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/core/authentication/authentication_service.dart';
import 'package:quanly/core/base/base_controller.dart';
import 'package:quanly/presentation/home/widgets/add_department_popup.dart';
import 'package:quanly/presentation/home/widgets/delete_confirmation_dialog.dart';
import 'package:quanly/presentation/home/widgets/edit_member_popup.dart';
import 'package:quanly/presentation/home/widgets/qr_code_dialog.dart';
import 'package:quanly/presentation/personal/personal_controller.dart';
import 'dashboard_controller.dart';
import 'history_controller.dart';

class StaffController extends BaseController {
  final searchController = TextEditingController();

  Rx<List<MemberTableData>> members = Rx<List<MemberTableData>>([]);
  RxList<DepartmentTableData> departments = <DepartmentTableData>[].obs;

  // Pagination
  final currentPage = 1.obs;
  final pageSize = 10.obs;
  final totalCount = 0.obs;
  final selectedDepartmentId = Rxn<String>();

  // Stats
  final totalStaff = 0.obs;
  final maleStaff = 0.obs;
  final femaleStaff = 0.obs;

  final _db = AppDatabase.instance;
  final _authenticationService = AuthenticationService();

  @override
  void onInit() {
    super.onInit();
    getDepartments();
    
    // Delay getMembers to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMembers(showLoading: false);
    });

    // Listen to search changes with debounce
    searchController.addListener(() {
      _debounceSearch();
    });
  }

  Timer? _searchDebounceTimer;
  void _debounceSearch() {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      currentPage.value = 1; // Reset to first page when searching
      getMembers();
    });
  }

  Future<void> getDepartments() async {
    try {
      final list = await _db.getAllDepartments();
      departments.assignAll(list);
    } catch (e) {
      // Delay error show to avoid calling during build
      Future.microtask(() {
        showError('Lỗi khi lấy danh sách phòng ban: $e');
      });
    }
  }

  Future<void> getMembers({bool showLoading = true}) async {
    try {
      if (showLoading) {
        this.showLoading();
      }

      final searchQuery = searchController.text.trim().isEmpty
          ? null
          : searchController.text.trim();
      final departmentId = selectedDepartmentId.value;

      // Get members with search and filter
      final list = await _db.searchMembers(
        page: currentPage.value,
        pageSize: pageSize.value,
        searchQuery: searchQuery,
        departmentId: departmentId,
      );

      // Get total count for pagination
      totalCount.value = await _db.getTotalMembersCount(
        searchQuery: searchQuery,
        departmentId: departmentId,
      );

      // Map department IDs to names
      final lastestList = <MemberTableData>[];
      for (var element in list) {
        try {
          String departmentName = '';
          if (element.departmentId.isNotEmpty) {
            final department = await _db.getDepartmentById(element.departmentId);
            departmentName = department?.name ?? '';
          }
          lastestList.add(element.copyWith(departmentId: departmentName));
        } catch (e) {
          // If mapping fails, use original data with empty department name
          print('Error mapping department for member ${element.id}: $e');
          lastestList.add(element.copyWith(departmentId: ''));
        }
      }

      members.value = lastestList;

      // Update stats (get all members for stats)
      await _updateStats();

      if (showLoading) {
        hideLoading();
      }
    } catch (e) {
      if (showLoading) {
        hideLoading();
      }
      // Delay error show to avoid calling during build
      Future.microtask(() {
        showError('Lỗi khi lấy danh sách cán bộ: $e');
      });
    }
  }

  Future<void> _updateStats() async {
    try {
      final allMembers = await _db.getAllMember(1, 10000); // Get all for stats
      totalStaff.value = allMembers.length;
      maleStaff.value = allMembers
          .where((element) => element.sex == 'Nam')
          .length;
      femaleStaff.value = allMembers
          .where((element) => element.sex == 'Nữ')
          .length;
    } catch (e) {
      // Ignore stats error
    }
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPages) {
      currentPage.value = page;
      getMembers();
    }
  }

  void nextPage() {
    if (currentPage.value < totalPages) {
      currentPage.value++;
      getMembers();
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      getMembers();
    }
  }

  int get totalPages {
    if (totalCount.value == 0) return 1;
    return (totalCount.value / pageSize.value).ceil();
  }

  int get currentPageValue => currentPage.value;
  int get pageSizeValue => pageSize.value;

  void filterByDepartment(String? departmentId) {
    selectedDepartmentId.value = departmentId;
    currentPage.value = 1;
    getMembers();
  }

  void clearDepartmentFilter() {
    selectedDepartmentId.value = null;
    currentPage.value = 1;
    getMembers();
  }

  void openAddStaffPopup() {
    // Assuming PersonalController is alive or we find it
    if (Get.isRegistered<PersonalController>()) {
      Get.find<PersonalController>().showAddPersonalPopup();
    } else {
      // Lazy put if not exists, though HomeBinding handles this
      Get.put(PersonalController());
      Get.find<PersonalController>().showAddPersonalPopup();
    }
    // Note: PersonalController.addPersonal() will refresh this controller after adding
  }

  void openAddDepartmentPopup() {
    Get.dialog(const AddDepartmentPopup(), barrierDismissible: true);
  }

  Future<void> addDepartment(String name) async {
    try {
      await _db.createDepartment(name);
      showSuccess('Thêm phòng ban thành công');
      getDepartments(); // Refresh department list
    } catch (e) {
      showError('Lỗi khi thêm phòng ban: ${e.toString()}');
    }
  }

  void openEditMemberPopup(MemberTableData member) {
    Get.dialog(EditMemberPopup(member: member), barrierDismissible: true);
  }

  Future<void> updateMember(
    String memberId,
    String name,
    String identityNumber,
    String address,
    String dateOfBirth,
    String position,
    String phoneNumber,
    String departmentId,
    String sex,
  ) async {
    try {
      final member = MemberTableCompanion(
        name: Value(name),
        identityNumber: Value(
          _authenticationService.encodeIndentityNumber(identityNumber),
        ),
        address: Value(address),
        dateOfBirth: Value(dateOfBirth),
        position: Value(position),
        phoneNumber: Value(phoneNumber),
        departmentId: Value(departmentId),
        sex: Value(sex),
      );

      await _db.updateMember(memberId, member);
      showSuccess('Cập nhật cán bộ thành công!');
      Get.back(); // Close edit popup
      getMembers(); // Refresh member list
      // Refresh dashboard and history
      _refreshOtherControllers();
    } catch (e) {
      showError('Lỗi khi cập nhật cán bộ: $e');
    }
  }

  Future<void> showDeleteConfirmation(MemberTableData member) async {
    final confirmed = await Get.dialog<bool>(
      DeleteConfirmationDialog(member: member),
      barrierDismissible: true,
    );
    if (confirmed == true) {
      await deleteMember(member.id);
    }
  }

  Future<void> deleteMember(String memberId) async {
    try {
      showLoading(message: 'Đang xóa cán bộ...');
      await _db.deleteMember(memberId);
      hideLoading();
      showSuccess('Xóa cán bộ thành công!');
      getMembers(showLoading: false); // Refresh member list without showing loading again
      // Refresh dashboard and history
      _refreshOtherControllers();
    } catch (e) {
      hideLoading();
      showError('Lỗi khi xóa cán bộ: $e');
    }
  }
  
  void _refreshOtherControllers() {
    // Refresh dashboard
    try {
      final dashboardController = Get.find<DashboardController>();
      dashboardController.refreshAllData();
    } catch (e) {
      // Controller not found, ignore
    }
    // Refresh history
    try {
      final historyController = Get.find<HistoryController>();
      historyController.fetchHistory();
    } catch (e) {
      // Controller not found, ignore
    }
  }

  void showQRCode(MemberTableData member) {
    Get.dialog(QRCodeDialog(member: member), barrierDismissible: true);
  }

  @override
  void onClose() {
    _searchDebounceTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
