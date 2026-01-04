import 'package:get/get.dart';
import 'package:quanly/app/database/app_database.dart';

class AuthService extends GetxService {
  static AuthService get instance => Get.find<AuthService>();
  
  final _currentAdmin = Rx<AdminTableData?>(null);
  
  AdminTableData? get currentAdmin => _currentAdmin.value;
  
  String get adminName => _currentAdmin.value?.name ?? 'admin';
  
  String get adminUsername => _currentAdmin.value?.indentityNumber ?? 'admin';
  
  void setCurrentAdmin(AdminTableData? admin) {
    _currentAdmin.value = admin;
  }
  
  void clear() {
    _currentAdmin.value = null;
  }
}

