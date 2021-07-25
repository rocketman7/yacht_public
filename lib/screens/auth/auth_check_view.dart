import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/auth/auth_check_view_model.dart';
import 'package:yachtOne/screens/startup/startup_view.dart';
import 'package:yachtOne/screens/startup/startup_view_model.dart';
import '../../services/auth_service.dart';
import 'login_view.dart';

class AuthCheckView extends GetWidget<AuthCheckViewModel> {
  const AuthCheckView({Key? key}) : super(key: key);

  @override
  // TODO: implement controller
  AuthCheckViewModel get controller => Get.put(AuthCheckViewModel());

  @override
  Widget build(BuildContext context) {
    Get.put(AuthCheckViewModel());
    return Scaffold(
      body: Obx(() {
        bool isUserNull = controller.currentUser!.value == null;
        print('isUserNull? : $isUserNull');
        return isUserNull == true ? LoginView() : StartupView();
      }),
    );
  }
}
