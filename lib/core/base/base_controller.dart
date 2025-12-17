import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
  
  final _errorMessage = Rxn<String>();
  String? get errorMessage => _errorMessage.value;
  set errorMessage(String? value) => _errorMessage.value = value;
  
  void showLoading({String? message}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(message),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
  
  /// Hide loading dialog
  void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
  
  /// Show success snackbar
  void showSuccess(String message) {
    Get.snackbar(
      'success'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
  
  /// Show error snackbar
  void showError(String message) {
    Get.snackbar(
      'error'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
  
  /// Show info snackbar
  void showInfo(String message) {
    Get.snackbar(
      'info'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
  
  /// Show warning snackbar
  void showWarning(String message) {
    Get.snackbar(
      'warning'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
    );
  }
  
  /// Show confirm dialog
  Future<bool> showConfirmDialog({
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText ?? 'cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: Text(confirmText ?? 'confirm'.tr),
          ),
        ],
      ),
    );
    return result ?? false;
  }
  
  /// Execute async function với error handling
  Future<T?> executeWithErrorHandling<T>({
    required Future<T> Function() function,
    bool showLoadingDialog = false,
    String? loadingMessage,
    bool showErrorSnackbar = true,
    Function(T data)? onSuccess,
    Function(String error)? onError,
  }) async {
    try {
      if (showLoadingDialog) {
        showLoading(message: loadingMessage);
      } else {
        isLoading = true;
      }
      
      errorMessage = null;
      
      final result = await function();
      
      if (onSuccess != null) {
        onSuccess(result);
      }
      
      return result;
    } catch (e) {
      final errorMsg = e.toString();
      errorMessage = errorMsg;
      
      if (showErrorSnackbar) {
        showError(errorMsg);
      }
      
      if (onError != null) {
        onError(errorMsg);
      }
      
      return null;
    } finally {
      if (showLoadingDialog) {
        hideLoading();
      } else {
        isLoading = false;
      }
    }
  }
}
