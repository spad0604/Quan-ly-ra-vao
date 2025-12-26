import 'dart:ui';

import 'package:get/get.dart';

import '../../core/base/base_controller.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/usecase.dart';

class HomeController extends BaseController {
  
  Rx<int> selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }
  
  @override
  void onReady() {
    super.onReady();
  }
  
  @override
  void onClose() {
    super.onClose();
  }
  
  void changeSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
