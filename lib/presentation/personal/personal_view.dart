import 'package:flutter/material.dart';
import 'package:quanly/core/base/base_view.dart';
import 'package:quanly/presentation/personal/personal_controller.dart';

class PersonalView extends BaseView<PersonalController>{
  const PersonalView({super.key});

  @override
  Widget buildBody(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            controller.showAddPersonalPopup();
          },
          child: Text(
            'Personal View Content',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}