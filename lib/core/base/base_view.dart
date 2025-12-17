import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_controller.dart';

abstract class BaseView<T extends BaseController> extends GetView<T> {
  const BaseView({super.key});
  
  Widget buildBody(BuildContext context);
  
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  
  Widget? buildFloatingActionButton(BuildContext context) => null;
  
  Widget? buildBottomNavigationBar(BuildContext context) => null;
  
  Widget? buildDrawer(BuildContext context) => null;
  
  /// Background color
  Color? get backgroundColor => null;
  
  /// Safe area
  bool get useSafeArea => true;
  
  /// Resize to avoid bottom inset (keyboard)
  bool get resizeToAvoidBottomInset => true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _buildBodyWithSafeArea(context),
      floatingActionButton: buildFloatingActionButton(context),
      bottomNavigationBar: buildBottomNavigationBar(context),
      drawer: buildDrawer(context),
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
  
  Widget _buildBodyWithSafeArea(BuildContext context) {
    final body = buildBody(context);
    
    if (useSafeArea) {
      return SafeArea(child: body);
    }
    
    return body;
  }
  
  /// Helper method: Loading overlay
  Widget buildLoadingOverlay({
    required Widget child,
    String? loadingText,
  }) {
    return Obx(() {
      return Stack(
        children: [
          child,
          if (controller.isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        if (loadingText != null) ...[
                          const SizedBox(height: 16),
                          Text(loadingText),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
  
  /// Helper method: Empty state
  Widget buildEmptyState({
    String? message,
    IconData? icon,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.inbox_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message ?? 'Không có dữ liệu',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text('retry'.tr),
            ),
          ],
        ],
      ),
    );
  }
  
  /// Helper method: Error state
  Widget buildErrorState({
    String? message,
    VoidCallback? onRetry,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'error_general'.tr,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text('retry'.tr),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
