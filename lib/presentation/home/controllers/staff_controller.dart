import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/core/base/base_controller.dart';
import 'package:quanly/presentation/home/widgets/add_department_popup.dart';
import 'package:quanly/presentation/personal/personal_controller.dart';

class StaffController extends BaseController {
  final searchController = TextEditingController();

  Rx<List<MemberTableData>> members = Rx<List<MemberTableData>>([]);
  // Stats
  final totalStaff = 150.obs;
  final maleStaff = 85.obs;
  final femaleStaff = 65.obs;

  final _db = AppDatabase.instance;

  @override
  void onInit() {
    super.onInit();
    getMembers();
  }
  
  Future<void> getMembers() async {
    try {
      final lastestList = <MemberTableData>[];

      final list = await _db.getAllMember(1, 100);

      for (var element in list) {
        final department = await _db.getDepartmentById(element.departmentId);
        lastestList.add(element.copyWith(departmentId: department?.name ?? ''));
      }
      totalStaff.value = lastestList.length;
      maleStaff.value = lastestList.where((element) => element.sex == 'Nam').length;
      femaleStaff.value = lastestList.where((element) => element.sex == 'Nữ').length;
      members.value = lastestList;
    } catch (e) {
      showError('Lỗi khi lấy danh sách cán bộ: $e');
    }
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
  }

  void openAddDepartmentPopup() {
    Get.dialog(
      const AddDepartmentPopup(),
      barrierDismissible: true,
    );
  }

  Future<void> addDepartment(String name) async {
    try {
      await _db.createDepartment(name);
      showSuccess('Thêm phòng ban thành công');
      // Optionally refresh department list if needed
    } catch (e) {
      showError('Lỗi khi thêm phòng ban: ${e.toString()}');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}



