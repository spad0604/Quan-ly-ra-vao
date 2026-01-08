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
import 'package:quanly/presentation/home/widgets/member_detail_dialog.dart';
import 'package:quanly/presentation/personal/personal_controller.dart';
import 'package:quanly/core/services/excel_export_service.dart';
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
  final _excelExportService = ExcelExportService();

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

  Future<void> getMembers({bool showLoading = false}) async {
    try {
      // Use isLoading state instead of dialog
      if (showLoading) {
        isLoading = true;
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

      // Update stats (get all members for stats) - don't block on this
      _updateStats().catchError((e) {
        // Ignore stats error
        print('Error updating stats: $e');
      });

      // Hide loading
      if (showLoading) {
        isLoading = false;
      }
    } catch (e) {
      if (showLoading) {
        isLoading = false;
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
      getDepartments(); // Refresh department list in StaffController
      
      // Also refresh departments in PersonalController if it exists
      if (Get.isRegistered<PersonalController>()) {
        try {
          Get.find<PersonalController>().getDepartments();
        } catch (_) {
          // PersonalController not found, ignore
        }
      }
    } catch (e) {
      showError('Lỗi khi thêm phòng ban: ${e.toString()}');
    }
  }

  void openEditMemberPopup(MemberTableData member) {
    Get.dialog(EditMemberPopup(member: member), barrierDismissible: true);
  }

  Future<bool> updateMember(
    String memberId,
    String name,
    String identityNumber,
    String address,
    String dateOfBirth,
    String position,
    String phoneNumber,
    String departmentId,
    String sex,
    String? officerNumber,
    String? rank,
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
        officerNumber: Value(officerNumber ?? ''),
        rank: Value(rank ?? ''),
      );

      await _db.updateMember(memberId, member);
      showSuccess('Cập nhật cán bộ thành công!');
      getMembers(); // Refresh member list
      // Refresh dashboard and history
      _refreshOtherControllers();
      return true;
    } catch (e) {
      showError('Lỗi khi cập nhật cán bộ: $e');
      return false;
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

  Future<void> exportStaffListToExcel() async {
    try {
      showLoading(message: 'Đang xuất Excel...');
      
      // Get all members (not just current page)
      final allMembers = await _db.getAllMember(1, 10000);
      
      // Map department IDs to names
      final membersWithDept = <MemberTableData>[];
      for (var member in allMembers) {
        try {
          String departmentName = '';
          if (member.departmentId.isNotEmpty) {
            final department = await _db.getDepartmentById(member.departmentId);
            departmentName = department?.name ?? '';
          }
          membersWithDept.add(member.copyWith(departmentId: departmentName));
        } catch (e) {
          membersWithDept.add(member.copyWith(departmentId: ''));
        }
      }

      final filePath = await _excelExportService.exportStaffList(membersWithDept);
      hideLoading();

      if (filePath != null) {
        final fileName = filePath.split(RegExp(r'[\\\\/]')).last;
        Get.showSnackbar(
          GetSnackBar(
            titleText: const Text('Xuất Excel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            messageText: Text('Đã xuất: $fileName', style: const TextStyle(color: Colors.white)),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black87,
            margin: EdgeInsets.only(
              right: 16,
              bottom: 16,
              left: Get.width * 0.55,
            ),
            borderRadius: 10,
            duration: const Duration(seconds: 6),
            mainButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async {
                    final ok = await _excelExportService.openFile(filePath);
                    if (!ok) {
                      await _excelExportService.revealInFolder(filePath);
                    }
                  },
                  child: const Text(
                    'Mở file',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    await _excelExportService.revealInFolder(filePath);
                  },
                  child: const Text(
                    'Mở thư mục',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        showError('Lỗi khi xuất Excel');
      }
    } catch (e) {
      hideLoading();
      showError('Lỗi khi xuất Excel: $e');
    }
  }

  void viewMemberDetails(MemberTableData member) {
    Get.dialog(MemberDetailDialog(member: member), barrierDismissible: true);
  }

  Future<void> showDeleteDepartmentConfirmation(DepartmentTableData department) async {
    // Check if department has members
    final members = await _db.searchMembers(
      page: 1,
      pageSize: 1,
      searchQuery: null,
      departmentId: department.id,
    );
    
    if (members.isNotEmpty) {
      showError('Không thể xóa phòng ban này vì còn cán bộ trong phòng ban');
      return;
    }

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa phòng ban "${department.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
      barrierDismissible: true,
    );
    
    if (confirmed == true) {
      await deleteDepartment(department.id);
    }
  }

  Future<void> deleteDepartment(String departmentId) async {
    try {
      await _db.deleteDepartment(departmentId);
      showSuccess('Xóa phòng ban thành công');
      getDepartments(); // Refresh department list
      getMembers(); // Refresh member list
    } catch (e) {
      showError('Lỗi khi xóa phòng ban: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    _searchDebounceTimer?.cancel();
    searchController.dispose();
    super.onClose();
  }
}
