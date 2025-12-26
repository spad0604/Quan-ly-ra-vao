import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanly/core/values/app_colors.dart';
import 'package:quanly/presentation/home/navigator_bar.dart';
import 'package:quanly/presentation/personal/personal_view.dart';

import '../../core/base/base_view.dart';
import 'home_controller.dart';

part 'navigator_bar_item.dart';

class HomeView extends BaseView<HomeController> {
  const HomeView({super.key});
  
  @override
  Widget buildBody(BuildContext context) {
    return buildLoadingOverlay(
      loadingText: 'loading'.tr,
      child: Scaffold(
        body: Row(
          children: [
            const NavigatorBar(),
            Expanded(
              child: PersonalView()
            ),
          ],
        ),
      )
    );
  }
}
