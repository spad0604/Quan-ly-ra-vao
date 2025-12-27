# Quản Lý - Clean Architecture Base với GetX

Base project hoàn chỉnh sử dụng **Clean Architecture** + **GetX** + **Dio** cho Flutter.

## 📋 Tính năng

- ✅ **Clean Architecture** (Domain, Data, Presentation layers)
- ✅ **GetX** cho state management và navigation
- ✅ **Dio** cho network requests
- ✅ **Đa ngôn ngữ** (Tiếng Việt & English)
- ✅ **Base classes** (BaseController, BaseView)
- ✅ **Error handling** tự động
- ✅ **Loading states** tích hợp
- ✅ **Dependency injection** với GetX Bindings

## 🏗️ Cấu trúc thư mục

```
lib/
├── app/
│   ├── app.dart                 # App configuration với GetMaterialApp
│   └── routes/
│       ├── app_pages.dart       # Định nghĩa các pages
│       └── app_routes.dart      # Định nghĩa các routes
├── core/
│   ├── base/
│   │   ├── base_controller.dart # Base controller với loading, error handling
│   │   └── base_view.dart       # Base view với helper methods
│   ├── network/
│   │   ├── api_endpoints.dart   # API endpoints
│   │   ├── dio_client.dart      # Dio client singleton
│   │   └── network_exceptions.dart # Network error handling
│   ├── translations/
│   │   ├── app_translations.dart # Translations configuration
│   │   ├── en_us.dart           # English translations
│   │   └── vi_vn.dart           # Vietnamese translations
│   ├── utils/
│   │   └── app_constants.dart   # App constants
│   └── values/
│       ├── app_colors.dart      # App colors
│       └── app_strings.dart     # String keys
├── data/
│   ├── models/
│   │   └── user_model.dart      # User model với JSON serialization
│   └── repositories/
│       └── user_repository_impl.dart # Repository implementation
├── domain/
│   ├── entities/
│   │   ├── entity.dart          # Base entity
│   │   └── user.dart            # User entity
│   ├── repositories/
│   │   ├── repository.dart      # Base repository
│   │   └── user_repository.dart # User repository interface
│   └── usecases/
│       ├── get_users_usecase.dart # Get users use case
│       └── usecase.dart         # Base use case
└── presentation/
    └── home/
        ├── home_binding.dart    # Dependency injection
        ├── home_controller.dart # Home controller
        └── home_view.dart       # Home view
```

## 🚀 Cách sử dụng

### 1. Tạo một feature mới

#### Bước 1: Tạo Entity (Domain Layer)

```dart
// lib/domain/entities/product.dart
import 'entity.dart';

class Product extends Entity {
  final int id;
  final String name;
  final double price;
  
  const Product({
    required this.id,
    required this.name,
    required this.price,
  });
}
```

#### Bước 2: Tạo Repository Interface (Domain Layer)

```dart
// lib/domain/repositories/product_repository.dart
import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<Product> getProductById(int id);
}
```

#### Bước 3: Tạo UseCase (Domain Layer)

```dart
// lib/domain/usecases/get_products_usecase.dart
import '../entities/product.dart';
import '../repositories/product_repository.dart';
import 'usecase.dart';

class GetProductsUseCase implements UseCase<List<Product>, NoParams> {
  final ProductRepository repository;
  
  GetProductsUseCase(this.repository);
  
  @override
  Future<List<Product>> call(NoParams params) async {
    return await repository.getProducts();
  }
}
```

#### Bước 4: Tạo Model (Data Layer)

```dart
// lib/data/models/product_model.dart
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
```

#### Bước 5: Tạo Repository Implementation (Data Layer)

```dart
// lib/data/repositories/product_repository_impl.dart
import '../../core/network/dio_client.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DioClient _dioClient;
  
  ProductRepositoryImpl(this._dioClient);
  
  @override
  Future<List<Product>> getProducts() async {
    final response = await _dioClient.get<List<dynamic>>(
      path: '/products',
    );
    
    return response.map((json) => ProductModel.fromJson(json)).toList();
  }
  
  @override
  Future<Product> getProductById(int id) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      path: '/products/$id',
    );
    
    return ProductModel.fromJson(response);
  }
}
```

#### Bước 6: Tạo Controller (Presentation Layer)

```dart
// lib/presentation/products/products_controller.dart
import 'package:get/get.dart';
import '../../core/base/base_controller.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/usecase.dart';

class ProductsController extends BaseController {
  final GetProductsUseCase _getProductsUseCase;
  
  ProductsController(this._getProductsUseCase);
  
  final _products = <Product>[].obs;
  List<Product> get products => _products;
  
  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }
  
  Future<void> loadProducts() async {
    await executeWithErrorHandling(
      function: () async {
        final products = await _getProductsUseCase.call(const NoParams());
        _products.value = products;
        return products;
      },
      showErrorSnackbar: true,
      onSuccess: (data) {
        showSuccess('Đã tải ${data.length} sản phẩm');
      },
    );
  }
}
```

#### Bước 7: Tạo View (Presentation Layer)

```dart
// lib/presentation/products/products_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/base/base_view.dart';
import 'products_controller.dart';

class ProductsView extends BaseView<ProductsController> {
  const ProductsView({super.key});
  
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Sản phẩm'),
    );
  }
  
  @override
  Widget buildBody(BuildContext context) {
    return buildLoadingOverlay(
      child: Obx(() {
        if (controller.products.isEmpty) {
          return buildEmptyState(
            message: 'Không có sản phẩm',
            onRetry: controller.loadProducts,
          );
        }
        
        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final product = controller.products[index];
            return ListTile(
              title: Text(product.name),
              subtitle: Text('\$${product.price}'),
            );
          },
        );
      }),
    );
  }
}
```

#### Bước 8: Tạo Binding (Presentation Layer)

```dart
// lib/presentation/products/products_binding.dart
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'products_controller.dart';

class ProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DioClient(), fenix: true);
    Get.lazyPut(() => ProductRepositoryImpl(Get.find()));
    Get.lazyPut(() => GetProductsUseCase(Get.find()));
    Get.lazyPut(() => ProductsController(Get.find()));
  }
}
```

#### Bước 9: Thêm Route

```dart
// lib/app/routes/app_routes.dart
abstract class AppRoutes {
  static const HOME = '/home';
  static const PRODUCTS = '/products'; // Thêm route mới
}

// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import '../../presentation/products/products_binding.dart';
import '../../presentation/products/products_view.dart';

static final routes = [
  // ... existing routes
  GetPage(
    name: AppRoutes.PRODUCTS,
    page: () => const ProductsView(),
    binding: ProductsBinding(),
  ),
];
```

### 2. Sử dụng Base Controller

`BaseController` cung cấp các methods tiện ích:

```dart
class MyController extends BaseController {
  // Loading state (tự động có sẵn)
  void doSomething() {
    isLoading = true;
    // ... do work
    isLoading = false;
  }
  
  // Show messages
  void showMessages() {
    showSuccess('Thành công!');
    showError('Có lỗi xảy ra!');
    showInfo('Thông tin');
    showWarning('Cảnh báo');
  }
  
  // Show dialogs
  void showDialogs() async {
    // Loading dialog
    showLoading(message: 'Đang xử lý...');
    await Future.delayed(Duration(seconds: 2));
    hideLoading();
    
    // Confirm dialog
    final confirmed = await showConfirmDialog(
      title: 'Xác nhận',
      message: 'Bạn có chắc chắn?',
    );
  }
  
  // Execute with error handling
  void fetchData() async {
    await executeWithErrorHandling(
      function: () async {
        // Your async code here
        return await someApiCall();
      },
      showLoadingDialog: true,
      showErrorSnackbar: true,
      onSuccess: (data) {
        showSuccess('Success!');
      },
      onError: (error) {
        print('Error: $error');
      },
    );
  }
}
```

### 3. Sử dụng Base View

`BaseView` cung cấp các helper methods:

```dart
class MyView extends BaseView<MyController> {
  @override
  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        // Loading overlay
        buildLoadingOverlay(
          child: YourContentWidget(),
          loadingText: 'Đang tải...',
        ),
        
        // Empty state
        buildEmptyState(
          message: 'Không có dữ liệu',
          icon: Icons.inbox,
          onRetry: controller.reload,
        ),
        
        // Error state
        buildErrorState(
          message: 'Có lỗi xảy ra',
          onRetry: controller.reload,
        ),
      ],
    );
  }
}
```

### 4. Network Requests với Dio

```dart
final dioClient = DioClient();

// GET request
final users = await dioClient.get<List<dynamic>>(
  path: '/users',
  queryParameters: {'page': 1},
);

// POST request
final newUser = await dioClient.post<Map<String, dynamic>>(
  path: '/users',
  data: {
    'name': 'John',
    'email': 'john@example.com',
  },
);

// PUT request
await dioClient.put(
  path: '/users/1',
  data: {'name': 'John Updated'},
);

// DELETE request
await dioClient.delete(path: '/users/1');
```

### 5. Đa ngôn ngữ

```dart
// Trong view
Text('home_title'.tr)  // Tự động dịch theo ngôn ngữ hiện tại

// Với parameters
Text('home_counter'.trParams({'count': '5'}))

// Thay đổi ngôn ngữ
Get.updateLocale(const Locale('en', 'US'));
Get.updateLocale(const Locale('vi', 'VN'));

// Thêm translation mới trong vi_vn.dart hoặc en_us.dart
const Map<String, String> viVN = {
  'your_key': 'Giá trị của bạn',
  // ...
};
```

## ⚙️ Configuration

### Cấu hình API Base URL

Chỉnh sửa file `lib/core/utils/app_constants.dart`:

```dart
class AppConstants {
  static const String baseUrl = 'https://your-api.com'; // Đổi URL của bạn
  static const String apiVersion = '/api/v1';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

### Thêm API Endpoints

Chỉnh sửa file `lib/core/network/api_endpoints.dart`:

```dart
class ApiEndpoints {
  static const String login = '/auth/login';
  static const String products = '/products';
  // Thêm endpoints của bạn
}
```

### Thêm Colors

Chỉnh sửa file `lib/core/values/app_colors.dart`:

```dart
class AppColors {
  static const Color primary = Color(0xFF6200EE);
  // Thêm màu của bạn
}
```

## 📱 Chạy ứng dụng

```bash
# Get dependencies
flutter pub get

# Run app
flutter run

# Build APK
flutter build apk

# Build iOS
flutter build ios
```

## 🔧 Dependencies chính

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6          # State management & navigation
  dio: ^5.7.0          # HTTP client
  cupertino_icons: ^1.0.8
```

## 📝 Notes

- **Clean Architecture**: Tách biệt rõ ràng giữa Domain, Data và Presentation layers
- **Dependency Injection**: Sử dụng GetX Bindings để inject dependencies
- **Error Handling**: Tự động xử lý lỗi network và hiển thị thông báo
- **Type Safety**: Sử dụng generics cho network requests
- **Reusable**: Chỉ cần extend BaseController và BaseView để sử dụng tất cả tính năng

## 🎯 Best Practices

1. **Luôn sử dụng Entity** trong Domain layer (không phụ thuộc vào implementation)
2. **Model** chỉ nên ở Data layer và kế thừa từ Entity
3. **UseCase** chỉ nên có 1 method `call()` và làm 1 nhiệm vụ duy nhất
4. **Controller** không nên gọi Repository trực tiếp, phải thông qua UseCase
5. **View** chỉ quan sát Controller, không chứa business logic
6. **Binding** để inject tất cả dependencies cho một feature

## 🚀 Mở rộng

Base này có thể dễ dàng mở rộng với:
- SharedPreferences / Secure Storage
- Firebase Authentication
- Push Notifications
- Local Database (Hive, SQLite)
- Image caching
- Forms validation
- và nhiều hơn nữa...

## 📄 License

MIT License - Free to use and modify.

'''dart run build_runner build --delete-conflicting-outputs'''

---

**Developed with ❤️ using Flutter & GetX**
