import 'dart:ui';

import 'package:get/get.dart';

import '../../core/base/base_controller.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/usecase.dart';

class HomeController extends BaseController {
  final GetUsersUseCase _getUsersUseCase;
  
  HomeController(this._getUsersUseCase);
  
  final _counter = 0.obs;
  int get counter => _counter.value;
  
  final _users = <User>[].obs;
  List<User> get users => _users;
  
  @override
  void onInit() {
    super.onInit();
    print('HomeController initialized');
  }
  
  @override
  void onReady() {
    super.onReady();
    print('HomeController ready');
  }
  
  @override
  void onClose() {
    print('HomeController closed');
    super.onClose();
  }
  
  void incrementCounter() {
    _counter.value++;
    
    if (counter % 5 == 0) {
      showSuccess('Bạn đã nhấn $counter lần!');
    }
  }
  
  void changeLanguage() async {
    final currentLocale = Get.locale;
    
    if (currentLocale?.languageCode == 'vi') {
      await Get.updateLocale(const Locale('en', 'US'));
      showInfo('Language changed to English');
    } else {
      await Get.updateLocale(const Locale('vi', 'VN'));
      showInfo('Đã chuyển sang Tiếng Việt');
    }
  }
  
  /// Fetch users from API (example)
  Future<void> fetchUsers() async {
    await executeWithErrorHandling(
      function: () async {
        // Simulate API call
        // Trong thực tế, uncomment dòng dưới để gọi API thật
        // final users = await _getUsersUseCase.call(const NoParams());
        
        // Mock data for demo
        await Future.delayed(const Duration(seconds: 2));
        final mockUsers = [
          const User(
            id: 1,
            name: 'Nguyễn Văn A',
            email: 'nguyenvana@example.com',
          ),
          const User(
            id: 2,
            name: 'Trần Thị B',
            email: 'tranthib@example.com',
          ),
          const User(
            id: 3,
            name: 'Lê Văn C',
            email: 'levanc@example.com',
          ),
        ];
        
        _users.value = mockUsers;
        return mockUsers;
      },
      showLoadingDialog: false, // Use overlay loading instead
      showErrorSnackbar: true,
      onSuccess: (data) {
        showSuccess('home_data_loaded'.tr);
      },
    );
  }
  
  /// Example: Show confirm dialog
  Future<void> showConfirmExample() async {
    final confirmed = await showConfirmDialog(
      title: 'confirm'.tr,
      message: 'Bạn có chắc chắn muốn thực hiện hành động này?',
    );
    
    if (confirmed) {
      showSuccess('Đã xác nhận!');
    }
  }
}
