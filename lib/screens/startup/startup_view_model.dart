import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/league_address_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/push_notification_service.dart';

import '../../locator.dart';

class StartupViewModel extends GetxController {
  AuthService _authService = locator<AuthService>();
  PushNotificationService _pushNotificationService = locator<PushNotificationService>();
  RxInt selectedPage = 0.obs;
  late User currentUser;
  bool isNameUpdated = true;
  @override
  void onInit() {
    currentUser = _authService.auth.currentUser!;
    selectedPage = 0.obs;
    checkUserNameConfirm();
    // selectedPage = 0.obs;
    // get league Address

    _pushNotificationService.initialise();
    super.onInit();
  }

  void checkUserNameConfirm() {
    // 한번도 업뎃 한 적 없으면 null일 수도 있으니 false로 처리
    isNameUpdated = userModelRx.value!.isNameUpdated ?? false;
    print('isNameUpdated: $isNameUpdated');
  }
}
