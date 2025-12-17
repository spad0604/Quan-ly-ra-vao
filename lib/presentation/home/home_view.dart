import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/base/base_view.dart';
import 'home_controller.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({super.key});
  
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('home_title'.tr),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.language),
          onPressed: controller.changeLanguage,
          tooltip: 'language'.tr,
        ),
      ],
    );
  }
  
  @override
  Widget buildBody(BuildContext context) {
    return buildLoadingOverlay(
      loadingText: 'loading'.tr,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome text
              Text(
                'home_welcome'.tr,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Counter
              Obx(() => Text(
                'home_counter'.trParams({'count': '${controller.counter}'}),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              )),
              const SizedBox(height: 20),
              
              // Increment button
              ElevatedButton.icon(
                onPressed: controller.incrementCounter,
                icon: const Icon(Icons.add),
                label: Text('home_increment'.tr),
              ),
              
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),
              
              // Example API call button
              ElevatedButton.icon(
                onPressed: controller.fetchUsers,
                icon: const Icon(Icons.cloud_download),
                label: Text('home_fetch_data'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Display users
              Obx(() {
                final users = controller.users;
                
                if (users.isEmpty) {
                  return Text(
                    'no_data'.tr,
                    style: const TextStyle(color: Colors.grey),
                  );
                }
                
                return Expanded(
                  child: Card(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(user.name[0].toUpperCase()),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                        );
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Widget? buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        controller.showSuccess('success'.tr);
      },
      tooltip: 'info'.tr,
      child: const Icon(Icons.info),
    );
  }
}
