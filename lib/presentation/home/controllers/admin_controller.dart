import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/core/authentication/authentication_service.dart';
import 'package:quanly/core/base/base_controller.dart';
import 'package:quanly/core/services/auth_service.dart';

class AdminUiItem {
  final String id;
  final String name;
  final String username;
  final String status; // ACTIVE / LOCKED
  final DateTime? createdAt;

  AdminUiItem({
    required this.id,
    required this.name,
    required this.username,
    required this.status,
    required this.createdAt,
  });
}

class AdminController extends BaseController {
  final _db = AppDatabase.instance;
  final _auth = AuthenticationService();

  // List state
  final admins = <AdminUiItem>[].obs;
  final isTableLoading = false.obs;
  final currentPage = 1.obs;
  final pageSize = 10;
  final totalCount = 0.obs;

  // Search
  final searchController = TextEditingController();
  Timer? _debounce;

  // Create form
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAdmins(showLoading: false);
    searchController.addListener(() {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        currentPage.value = 1;
        fetchAdmins(showLoading: false);
      });
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    fullNameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  int get totalPages {
    final tc = totalCount.value;
    if (tc <= 0) return 1;
    return (tc / pageSize).ceil();
  }

  bool get canManageAdmins {
    try {
      final authService = Get.find<AuthService>();
      // Only the admin account with username 'admin' is allowed to manage admins
      return authService.adminUsername == 'admin';
    } catch (_) {
      return false;
    }
  }

  Future<void> fetchAdmins({bool showLoading = true}) async {
    try {
      isTableLoading.value = true;
      final q = searchController.text.trim();
      totalCount.value = await _db.getTotalAdminsCount(searchQuery: q);
      final rows = await _db.searchAdmins(
        searchQuery: q,
        page: currentPage.value,
        pageSize: pageSize,
      );
      final mapped = <AdminUiItem>[];
      for (final row in rows) {
        final admin = row['admin'] as AdminTableData;
        final username = (row['username'] as String?) ?? '';
        mapped.add(
          AdminUiItem(
            id: admin.id,
            name: admin.name,
            username: username,
            status: (admin.status).toUpperCase(),
            createdAt: admin.createdAt,
          ),
        );
      }
      admins.assignAll(mapped);
    } catch (_) {
      admins.clear();
    } finally {
      isTableLoading.value = false;
    }
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    currentPage.value = page;
    fetchAdmins(showLoading: false);
  }

  Future<void> createAdmin() async {
    if (!canManageAdmins) {
      showError('Bạn không có quyền quản lý admin');
      return;
    }

    final name = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      showError('Vui lòng nhập đầy đủ thông tin');
      return;
    }
    if (password != confirm) {
      showError('Mật khẩu xác nhận không khớp');
      return;
    }
    if (password.length < 6) {
      showError('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    try {
      showLoading(message: 'Đang tạo tài khoản...');
      final admin = AdminTableCompanion(
        id: Value(const Uuid().v4()),
        name: Value(name),
        phoneNumber: Value(phone),
        // Store username as plaintext in indentityNumber for admins.
        indentityNumber: Value(username),
        // Store hashed password
        password: Value(_auth.hashPassword(password)),
        // Explicitly set imageUrl to empty string to avoid NOT NULL constraint error
        imageUrl: const Value(''),
        // status/createdAt have defaults
      );
      await _db.createAdmin(admin);
      hideLoading();
      showSuccess('Tạo tài khoản admin thành công');
      _clearForm();
      currentPage.value = 1;
      await fetchAdmins(showLoading: false);
    } catch (e) {
      hideLoading();
      showError('Lỗi khi tạo admin: $e');
    }
  }

  Future<void> toggleStatus(AdminUiItem item) async {
    if (!canManageAdmins) {
      showError('Bạn không có quyền quản lý admin');
      return;
    }

    try {
      final next = item.status == 'ACTIVE' ? 'LOCKED' : 'ACTIVE';
      await _db.updateAdminStatus(item.id, next);
      await fetchAdmins(showLoading: false);
    } catch (e) {
      showError('Lỗi khi cập nhật trạng thái: $e');
    }
  }

  void showDeleteConfirmation(AdminUiItem admin) {
    if (!canManageAdmins) {
      showError('Bạn không có quyền quản lý admin');
      return;
    }

    // Prevent self-deletion
    try {
      final currentAdminId = Get.find<AuthService>().currentAdmin?.id;
      if (currentAdminId == admin.id) {
        showError('Không thể xóa tài khoản admin đang đăng nhập');
        return;
      }
    } catch (_) {}

    Get.dialog(
      AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa admin "${admin.name}" (${admin.username})?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _deleteAdminById(admin.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAdminById(String adminId) async {
    try {
      showLoading(message: 'Đang xoá...');
      await _db.deleteAdmin(adminId);
      hideLoading();
      // Add small delay to ensure loading dialog closes
      await Future.delayed(const Duration(milliseconds: 100));
      showSuccess('Đã xoá admin');
      await fetchAdmins(showLoading: false);
    } catch (e) {
      hideLoading();
      // Force close any remaining dialogs
      await Future.delayed(const Duration(milliseconds: 100));
      if (Get.isDialogOpen == true) {
        try {
          Get.back();
        } catch (_) {}
      }
      showError('Lỗi khi xoá admin: $e');
    }
  }

  void _clearForm() {
    fullNameController.clear();
    usernameController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}


