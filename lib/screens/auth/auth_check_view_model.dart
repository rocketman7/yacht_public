import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ntp/ntp.dart';
import 'package:package_info/package_info.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/repositories/user_repository.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/mixpanel_service.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

import '../../locator.dart';

class AuthCheckViewModel extends GetxController {
  final AuthService authService = locator<AuthService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final MixpanelService mixpanelService = locator<MixpanelService>();

  UserRepository _userRepository = UserRepository();
  // User currentUser;
  // Rxn<User>? currentUser = Rxn<User>();
  // RxBool isLoadingData = true.obs;
  User? user;

  String app_store_url = "";
  String play_store_url = "https://play.google.com/store/apps/details?id=com.team_yacht.ggook";
  bool isUrgentNotice = false;
  String urgentMessage = "";
  RxBool isGettingUser = true.obs;
  RxBool isInitiating = true.obs;
  // RxBool everTest = false.obs;

  @override
  void onInit() async {
    isInitiating(true);

    // 현재 league 정보 가져오기
    await getLeagueInfo();
    // 휴일 리스트 가져오기
    await getHolidayList();
    // App 버전 체크
    await checkVersion();
    // 티어 분류 (to be deleted)
    tierSystemModelRx(await _firestoreService.getTierSystem());

    isInitiating(false);
    // isInitiating.refresh();
    print('auth check init end');
    super.onInit();
  }

  Future getUser(String uid) async {
    // uid = "kakao:1993448477";
    // isGettingUser(true);
    // userModelRx(await _firestoreService.getUserModel(uid));
    userModelRx.bindStream(_userRepository.getUserStream(uid));
    // userQuestModelRx.bindStream(_userRepository.getUserQuestStream(uid));
    // userModelRx.bindStream(_userRepository.getUserStream("kakao:1531290810"));
    // String leagueId = await _firestoreService.getLeagueInfo().then((value) => value.leagueName);
    // userQuestModelRx(await _firestoreService.getUserQuestModels(uid, leagueId));

    if (leagueRx.value != "") {
      userQuestModelRx.bindStream(_userRepository.getUserQuestStream(uid));
    }

    ever(leagueRx, (_) {
      if (leagueRx.value != "") {
        DateTime time = DateTime.now();
        print('userquest binding to $uid');
        userQuestModelRx.bindStream(_userRepository.getUserQuestStream(uid));
      }
    });

    if (userModelRx.value != null) {
      print('usermodel ever #1 triggered');
      isGettingUser(false);
    }
    // leagueRx.listen((value) {
    //   print('leagueRx listening: $value');
    // });
    ever(userModelRx, (_) {
      if (userModelRx.value != null) {
        print('usermodel ever #2 triggered');
        isGettingUser(false);
      }
    });
    // userModelRx.listen((val) {
    // });
    // isGettingUser.refresh();
  }

  Future signOut() async {
    await authService.auth.signOut();
  }

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

  Future getLeagueInfo() async {
    leagueModel(await _firestoreService.getLeagueInfo());
    leagueRx(leagueModel.value!.openLeague);
    leagueRx.refresh();
  }

  Future getHolidayList() async {
    holidayListKR.clear();
    holidayListKR.addAll(await _firestoreService.getHolidayList());
    print(holidayListKR);
  }

  authCheck() async {
    String uid = authService.auth.currentUser!.uid;
    bool isUserModelExists = await _firestoreService.checkIfUserDocumentExists(uid);
    if (!isUserModelExists) {
      authService.auth.signOut();
      // authService.auth.currentUser!.delete();
      // print(authService.auth.currentUser!.uid);
    }
  }

  Future checkVersion() async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(seconds: 1),
    ));
    // print(info.version.trim().replaceAll(".", ""));

    double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));
    // print(currentVersion);
    double newVersion = double.parse(remoteConfig.getString('force_update_current_version').trim().replaceAll(".", ""));
    // print("CURRENT VERSION IS " + currentVersion.toString());
    // print("newVersion VERSION IS " + newVersion.toString());

    //Get Latest version info from firebase config
    app_store_url = remoteConfig.getString('app_store_url');
    play_store_url = remoteConfig.getString('play_store_url');
    isUrgentNotice = remoteConfig.getBool('is_urgent_notice');
    urgentMessage = remoteConfig.getString('urgent_message');

    if (newVersion > currentVersion) {
      Get.dialog(
          Dialog(
            backgroundColor: primaryBackgroundColor,
            insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: defaultHorizontalPadding,
                  // height: 210.w,
                  width: 347.w,
                  child: Column(
                    children: [
                      SizedBox(height: 14.w),
                      Text('알림', style: yachtBadgesDialogTitle.copyWith(fontSize: 16.w)),
                      SizedBox(
                        height: correctHeight(
                            20.w, yachtBadgesDialogTitle.fontSize, yachtBadgesDescriptionDialogTitle.fontSize),
                      ),
                      Center(
                        child: Text(
                          '요트 새 버전이 출시되었습니다\n원활한 서비스 이용을 위하여 \n업데이트를 부탁드려요.',
                          textAlign: TextAlign.center,
                          style: yachtBadgesDescriptionDialogTitle,
                        ),
                      ),
                      SizedBox(
                        height: correctHeight(20.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Platform.isIOS ? _launchURL(app_store_url) : _launchURL(play_store_url);
                        },
                        child: Container(
                          height: 44.w,
                          // width: 154.5.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70.0),
                            color: yachtViolet,
                          ),
                          child: Center(
                            child: Text(
                              '업데이트하기',
                              style: yachtDeliveryDialogButtonText,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 14.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          barrierDismissible: false);
    }

    if (isUrgentNotice) {
      Get.dialog(
          Dialog(
            backgroundColor: primaryBackgroundColor,
            insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: defaultHorizontalPadding,
                  // height: 210.w,
                  width: 347.w,
                  child: Column(
                    children: [
                      SizedBox(height: 14.w),
                      Text('알림', style: yachtBadgesDialogTitle.copyWith(fontSize: 16.w)),
                      SizedBox(
                        height: correctHeight(
                            20.w, yachtBadgesDialogTitle.fontSize, yachtBadgesDescriptionDialogTitle.fontSize),
                      ),
                      Center(
                        child: Text(
                          urgentMessage,
                          textAlign: TextAlign.center,
                          style: yachtBadgesDescriptionDialogTitle,
                        ),
                      ),
                      SizedBox(
                        height: correctHeight(20.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          exit(0);
                        },
                        child: Container(
                          height: 44.w,
                          // width: 154.5.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70.0),
                            color: yachtViolet,
                          ),
                          child: Center(
                            child: Text(
                              '확인',
                              style: yachtDeliveryDialogButtonText,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 14.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          barrierDismissible: false);
    }
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
