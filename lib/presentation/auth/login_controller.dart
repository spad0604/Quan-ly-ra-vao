import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/app/database/app_database.dart';
import 'package:quanly/core/base/base_controller.dart';
import 'package:quanly/app/routes/app_routes.dart';
import 'package:quanly/core/services/auth_service.dart';

class LoginController extends BaseController {
  final usernameController = TextEditingController(text: 'admin');
  final passwordController = TextEditingController(text: 'admin');

  final _db = AppDatabase.instance;

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      showError('error_required_field'.tr);
      return;
    }

    try {
      showLoading(message: 'loading'.tr);
      // Đảm bảo admin mặc định tồn tại trước khi đăng nhập
      await _db.ensureDefaultAdmin();
      final admin = await _db.loginAdmin(username, password);
      hideLoading();

      if (admin == null) {
        showError('Sai tài khoản hoặc mật khẩu');
        return;
      }

      // Lưu thông tin admin đã đăng nhập
      try {
        Get.put(AuthService(), permanent: true);
        AuthService.instance.setCurrentAdmin(admin);
      } catch (_) {
        // AuthService đã tồn tại, chỉ cần update
        AuthService.instance.setCurrentAdmin(admin);
      }

      showSuccess('login_success'.tr);
      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      hideLoading();
      showError('error_general'.tr);
    }
  }
}


