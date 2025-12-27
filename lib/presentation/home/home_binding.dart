import 'package:get/get.dart';
import 'package:quanly/presentation/home/controllers/dashboard_controller.dart';
import 'package:quanly/presentation/home/controllers/guest_controller.dart';
import 'package:quanly/presentation/home/controllers/history_controller.dart';
import 'package:quanly/presentation/home/controllers/staff_controller.dart';
import 'package:quanly/presentation/personal/personal_controller.dart';

import '../../core/network/dio_client.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'home_controller.dart';
import '../../core/qr_reader/qr_reader_controller.dart';

/// Binding để inject dependencies cho HomeController
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Inject DioClient (singleton)
    Get.lazyPut(() => DioClient(), fenix: true);
    
    // Inject Repository
    Get.lazyPut(() => UserRepositoryImpl(Get.find<DioClient>()));
    
    // Inject UseCase
    Get.lazyPut(() => GetUsersUseCase(Get.find<UserRepositoryImpl>()));
    
    // Inject Controller
    Get.lazyPut(() => HomeController());
    // Inject QrReader controller for HID
    Get.lazyPut(() => QrReaderController());
    // Inject PersonalController
    Get.lazyPut(() => PersonalController());

    // Inject Tab Controllers
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => StaffController());
    Get.lazyPut(() => GuestController());
    Get.lazyPut(() => HistoryController());
  }
}
