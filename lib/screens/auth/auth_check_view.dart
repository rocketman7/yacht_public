import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/repositories/user_repository.dart';
import 'package:yachtOne/screens/auth/auth_check_view_model.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/screens/startup/loading_view.dart';
import 'package:yachtOne/screens/startup/startup_view.dart';
import 'package:yachtOne/screens/startup/startup_view_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import '../../locator.dart';
import '../../services/auth_service.dart';
import 'login_view.dart';

class AuthCheckView extends GetView<AuthCheckViewModel> {
  AuthCheckView({Key? key}) : super(key: key);

  @override
  // TODO: implement controller
  AuthCheckViewModel get controller => Get.put(AuthCheckViewModel());
  UserRepository _userRepository = UserRepository();
  final AuthService authService = locator<AuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
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
        print('current UserModel: ${userModelRx.value}');
        print('authcheckworking');
        if (!isUserNull && userModelRx.value == null) {
          // print('wrong user');
          controller.authCheck();
        }

        if (controller.authService.auth.currentUser == null) {
          return LoginView();
        } else if (isUserNull || !isUserModelReady) {
          return LoadingView();
        } else {
          return StartupView();
          // Get.offNamed('startup');
        }

        // // currentUser는 authStateChange와 관련.
        // if (isUserNull) {
        //   return LoginView();
        //   // userModelRx가 없을 때
        // } else if (!isUserModelReady) {
        //   return Container(
        //     color: Colors.blue,
        //   );
        // } else if (leagueRx.value == "") {
        //   return LoadingView();
        // } else {
        //   return StartupView();
        // }

        // (isUserNull)
        //     ? LoginView()
        //     : !isUserModelReady
        //         ? LoadingView()
        //         : StartupView();
      }),
    );
  }
}
