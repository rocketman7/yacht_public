import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/repositories/user_repository.dart';
import 'package:yachtOne/screens/auth/auth_check_view_model.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/screens/startup/startup_view.dart';
import 'package:yachtOne/screens/startup/startup_view_model.dart';
import '../../services/auth_service.dart';
import 'login_view.dart';

class AuthCheckView extends GetView<AuthCheckViewModel> {
  AuthCheckView({Key? key}) : super(key: key);

  @override
  // TODO: implement controller
  AuthCheckViewModel get controller => Get.put(AuthCheckViewModel());
  UserRepository _userRepository = UserRepository();
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CommunityViewModel());
    // Get.put(AuthCheckViewModel());
    return Scaffold(
      body: Obx(() {
        bool isUserNull = controller.currentUser == null ? true : controller.currentUser!.value == null;
        bool isUserModelReady = userModelRx.value != null;
        print('isUserNull? : $isUserNull');
        print('isUserModelReady? : $isUserModelReady');
        print('current User: ${userModelRx.value}');
        return (isUserNull && leagueRx.value != "")
            ? LoginView()
            : !isUserModelReady
                ? Container()
                : StartupView();
      }),
    );
  }
}
