import 'package:get/get.dart';

import '../../core/network/dio_client.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/get_users_usecase.dart';
import 'home_controller.dart';

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
    Get.lazyPut(() => HomeController(Get.find<GetUsersUseCase>()));
  }
}
