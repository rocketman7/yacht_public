import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ntp/ntp.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/repositories/user_repository.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';

import '../../locator.dart';

class AuthCheckViewModel extends GetxController {
  AuthService authService = locator<AuthService>();
  FirestoreService _firestoreService = locator<FirestoreService>();

  UserRepository _userRepository = UserRepository();
  // User currentUser;
  Rxn<User>? currentUser = Rxn<User>();
  RxBool isLoadingData = true.obs;
  User? user;

  Future checkTime() async {
    DateTime serverNowUtc = await NTP.now();
    DateTime deviceNowUtc = DateTime.now().toUtc();

    if (serverNowUtc.difference(deviceNowUtc).abs() > Duration(minutes: 5)) {
      Get.dialog(
        Dialog(child: Text("기기의 시간을 임의로 변경하면 요트를 이용할 수 없습니다.")),
        barrierDismissible: false,
      );
    }
  }

  @override
  void onInit() async {
    // await _firestoreService.getServerTime();

    await checkTime();

    isLoadingData(true);
    // TODO: implement onInit

    user = authService.auth.currentUser;
    tierSystemModelRx(await _firestoreService.getTierSystem());
    currentUser!.bindStream(authService.auth.authStateChanges());
    leagueRx.bindStream(_firestoreService.getOpenLeague());
    // _authService.auth.signOut();
    update();
    currentUser!.listen((user) async {
      print('listening $user');

      if (user != null) {
        userModelRx.bindStream(_userRepository.getUserStream(user.uid));

        leagueRx.listen((value) {
          if (value != "") {
            print('userquest binding');
            userQuestModelRx.bindStream(_userRepository.getUserQuestStream(user.uid));
          }
        });

        // print('this user: ${userModelRx.value}.');
        // userModelRx.listen((user) {
        //   print('this user: $user');
        // });
      } else {
        userModelRx.value = null;
        print('when user is  null');
      }
    });

    isLoadingData(false);
    // _authService.auth.signOut();
    // _authService.auth.authStateChanges().listen((event) {
    //   print(event == null);
    //   print('event : ${event.toString()}');
    //   if (event == null) {
    //     print("event is null now");
    //     currentUser!(event);
    //   } else {
    //     currentUser!(event);
    //   }
    //   print('currentUser value: ${currentUser!.value}');
    // });
    super.onInit();
  }
}
