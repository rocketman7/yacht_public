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
import 'login_view.dart';

class AuthCheckView extends GetView<AuthCheckViewModel> {
  AuthCheckView({Key? key}) : super(key: key);

  @override
  // TODO: implement controller
  AuthCheckViewModel get controller => Get.put(AuthCheckViewModel());
  UserRepository _userRepository = UserRepository();
  // final AuthService authService = locator<AuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  @override
  Widget build(BuildContext context) {
    print('auth view start');
    Get.lazyPut(() => CommunityViewModel());
    // Get.put(AuthCheckViewModel());
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: controller.authService.auth.userChanges(),
            builder: (context, snapshot) {
              print('snapshot: ${snapshot.data}');
              print('snapshot.hasData: ${snapshot.hasData}');

              if (snapshot.hasData) {
                print('auth check viewmodel getuser start');
                // if (userModelRx.value == null) {
                controller.getUser(snapshot.data!.uid);
                // } else {
                //   controller.isGettingUser(false);
                // }
                return Obx(() {
                  print('obx division start');
                  return (controller.isGettingUser.value || controller.isInitiating.value)
                      ? LoadingView()
                      : StartupView();
                });
              } else {
                return LoginView();
              }

              // return Obx(() {
              //   print(userModelRx.value);
              //   if (snapshot.hasData) {
              //     if (userModelRx.value == null)
              //     // if (controller.authService.auth.currentUser!.uid == "pgw3LFd36CcUGzhuFOmvbyudpTu1") {
              //     {
              //       print('userModelRx: ${userModelRx.value}');
              //       controller.mixpanelService.mixpanel
              //           .track('App Start', properties: {'uid': controller.authService.auth.currentUser!.uid});
              //       Timer(Duration(seconds: 10), () async {
              //         print('7 sec passed');
              //         controller.mixpanelService.mixpanel
              //             .track('Forced Signout', properties: {'uid': controller.authService.auth.currentUser!.uid});
              //         if (userModelRx.value == null) await controller.signOut();
              //       });
              //       // }
              //       return LoadingView();
              //     } else {
              //       return StartupView();
              //     }
              //   } else {
              //     return LoginView();
              //   }
              // });
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
        //     controller.mixpanelService.mixpanel
        //         .track('App Start', properties: {'uid': controller.authService.auth.currentUser!.uid});
        //     Timer(Duration(seconds: 10), () async {
        //       print('7 sec passed');
        //       controller.mixpanelService.mixpanel
        //           .track('Forced Signout', properties: {'uid': controller.authService.auth.currentUser!.uid});
        //       if (userModelRx.value == null) await controller.signOut();
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
