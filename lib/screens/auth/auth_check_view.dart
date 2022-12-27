import 'dart:async';

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
import 'kakao_firebase_auth_api.dart';
import 'login_view.dart';

class AuthCheckView extends StatelessWidget {
  AuthCheckView({Key? key}) : super(key: key);

  @override
  // TODO: implement controller
  final AuthCheckViewModel controller = Get.put(AuthCheckViewModel());
  final KakaoFirebaseAuthApi _kakaoApi = KakaoFirebaseAuthApi();
  UserRepository _userRepository = UserRepository();
  // final AuthService authService = locator<AuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    print('auth view start');
    // Get.lazyPut(() => CommunityViewModel());
    // Get.put(AuthCheckViewModel());
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: controller.authService.auth.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                controller.getUser(snapshot.data!.uid);
                return Obx(() {
                  // print('obx division start');
                  print(
                      'time to isGettingUser: ${controller.isGettingUser.value} ${-time.difference(DateTime.now()).inMilliseconds}');
                  print(
                      'time to isInitiating: ${controller.isInitiating.value} ${-time.difference(DateTime.now()).inMilliseconds}');
                  if (controller.isGettingUser.value || controller.isInitiating.value) {
                    return LoadingView();
                  } else {
                    print("time to going Startup: ${-time.difference(DateTime.now()).inSeconds}");
                    return StartupView();
                  }
                });
              } else {
                print("all clear: ${-time.difference(DateTime.now()).inMilliseconds}");
                return LoginView();
              }
            })
        // body: Obx(() {
        //   bool isUserNull = currentUser.value == null;
        //   bool isUserModelReady = userModelRx.value != null;
        //   print('isUserNull? : $isUserNull');
        //   print('isUserModelReady? : $isUserModelReady');
        //   print('current UserModel: ${userModelRx.value}');
        //   if (!isUserNull && userModelRx.value == null) {
        //     // print('wrong user');
        //     controller.authCheck();
        //   }

        //   if (currentUser.value == null) {
        //     return LoginView();
        //   } else if (userModelRx.value == null) {
        //     // if (controller.authService.auth.currentUser!.uid == "pgw3LFd36CcUGzhuFOmvbyudpTu1") {
        //          //     Timer(Duration(seconds: 10), () async {
        //       print('7 sec passed');
        //          if (userModelRx.value == null) await controller.signOut();
        //     });
        //     // }
        //     return LoadingView();
        //   } else {
        //     return StartupView();
        //     // Get.offNamed('startup');
        //   }

        //   // // currentUser는 authStateChange와 관련.
        //   // if (isUserNull) {
        //   //   return LoginView();
        //   //   // userModelRx가 없을 때
        //   // } else if (!isUserModelReady) {
        //   //   return Container(
        //   //     color: Colors.blue,
        //   //   );
        //   // } else if (leagueRx.value == "") {
        //   //   return LoadingView();
        //   // } else {
        //   //   return StartupView();
        //   // }

        //   // (isUserNull)
        //   //     ? LoginView()
        //   //     : !isUserModelReady
        //   //         ? LoadingView()
        //   //         : StartupView();
        // }),
        );
  }
}
