import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/presentation/home/home_controller.dart';
import 'package:quanly/presentation/home/home_view.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({super.key});

  @override
  State<NavigatorBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  final homeController = Get.find<HomeController>();

  List<NavigatorBarItemDetails> items = [
    NavigatorBarItemDetails(
      title: 'overview'.tr,
      icon: Icons.dashboard,
    ),
    NavigatorBarItemDetails(
      title: 'personal_management'.tr,
      icon: Icons.manage_accounts,
    ),
    NavigatorBarItemDetails(
      title: 'anoymus_qr_reader'.tr,
      icon: Icons.qr_code_scanner,
    ),
    NavigatorBarItemDetails(
      title: 'history'.tr,
      icon: Icons.history,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      height: Get.height,
      width: 300,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          itemCount: items.length,
          itemBuilder: (_, index) {
          return Column(
            children: [
              Obx(
                () => NavigatorBarItem(
                  title: items[index].title,
                  icon: items[index].icon,
                  isChoose: homeController.selectedIndex.value == index,
                  onTap: () {
                    homeController.changeSelectedIndex(index);
                  },
                ),
              ),
              const SizedBox(height: 12,),
            ],
          );
        }),
    );
  }
}

class NavigatorBarItemDetails {
  NavigatorBarItemDetails({ 
    required this.title,
    required this.icon,
  });

  final String title;

  final IconData icon;

}