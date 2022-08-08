import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:restart_app/restart_app.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/auth/auth_check_view.dart';
import 'package:yachtOne/screens/auth/auth_check_view_model.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/profile/profile_my_view_model.dart';
import 'package:yachtOne/screens/profile/profile_others_view.dart';
import 'package:yachtOne/screens/auth/kakao_firebase_auth_api.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:restart_app/restart_app.dart';
import '../../locator.dart';
import '../../styles/yacht_design_system.dart';

import 'account_view.dart';
import 'admin_mode_view.dart';
import 'friends_code_controller.dart';
import 'one_on_one_list_view.dart';
import 'one_on_one_view.dart';
import 'push_notification_view.dart';

class SettingView extends StatelessWidget {
  final FriendsCodeController _friendsCodeController = Get.put(FriendsCodeController());
  final TextEditingController _keyController = TextEditingController();
  final AuthService _authService = locator<AuthService>();
  final KakaoFirebaseAuthApi _kakaoApi = KakaoFirebaseAuthApi();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: yachtLightGrey,
      appBar: primaryAppBar('설정'),
      body: ListView(children: [
        SizedBox(
          height: correctHeight(20.w, 0.w, settingTitle.fontSize),
        ),
        Padding(
          padding: EdgeInsets.only(left: 13.w, right: 13.w),
          child: Text(
            '내 계정 설정',
            style: settingTitle,
          ),
        ),
        SizedBox(
          height: correctHeight(10.w, settingTitle.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _mixpanelService.mixpanel.track('Account Info');
            Get.to(() => AccountView());
          },
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '계좌 정보',
              style: settingContent,
            ),
          ),
        ),
        SizedBox(
          height: correctHeight(17.w, settingContent.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _mixpanelService.mixpanel.track('Push Notification Setting');
            Get.to(() => PushNotificationView());
          },
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '푸시 알림 설정',
              style: settingContent,
            ),
          ),
        ),
        SizedBox(
          height: correctHeight(17.w, settingContent.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(20.w, 0.w, settingTitle.fontSize),
        ),
        Padding(
          padding: EdgeInsets.only(left: 13.w, right: 13.w),
          child: Text(
            '추천하기',
            style: settingTitle,
          ),
        ),
        SizedBox(
          height: correctHeight(10.w, settingTitle.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _mixpanelService.mixpanel.track('Friend Recommend');
            showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    backgroundColor: primaryBackgroundColor,
                    insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 14.w, right: 14.w),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: correctHeight(24.w, 0.w, settingFriendsCodeDialogTitle.fontSize),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 14.w,
                                ),
                                SizedBox(
                                    height: 15.w,
                                    width: 15.w,
                                    child: Image.asset('assets/icons/exit.png', color: Colors.transparent)),
                                Spacer(),
                                Text(
                                  '친구에게 추천하기',
                                  style: settingFriendsCodeDialogTitle,
                                ),
                                Spacer(),
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: SizedBox(
                                      height: 15.w,
                                      width: 15.w,
                                      child: Image.asset('assets/icons/exit.png', color: yachtBlack)),
                                ),
                                SizedBox(
                                  width: 14.w,
                                ),
                              ],
                            ),
                            SizedBox(
                                height: correctHeight(34.w, settingFriendsCodeDialogTitle.fontSize,
                                    settingFriendsCodeDialogContent.fontSize)),
                            Text(
                              "친구에게 추천 링크를 공유해보세요!",
                              textAlign: TextAlign.center,
                              style: settingFriendsCodeDialogContent,
                            ),
                            SizedBox(
                              height: correctHeight(25.w, settingFriendsCodeDialogContent.fontSize, 0.w),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.w),
                                  boxShadow: [
                                    BoxShadow(
                                      color: yachtShadow,
                                      blurRadius: 8.w,
                                      spreadRadius: 1.w,
                                    )
                                  ]),
                              child: Padding(
                                  padding: EdgeInsets.only(left: 12.w, top: 14.w, bottom: 11.w),
                                  child: GetBuilder<FriendsCodeController>(
                                    id: 'friendsCode',
                                    builder: (controller) {
                                      return Text(
                                        '${controller.uiFriendsCode}',
                                        style: settingFriendsCodeStyle,
                                      );
                                    },
                                  )),
                            ),
                            SizedBox(
                              height: 30.w,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () async {
                                      _mixpanelService.mixpanel.track('Share Yacht Link');
                                      bool installed = await isKakaoTalkInstalled();
                                      if (installed)
                                        _friendsCodeController.shareMyCode();
                                      else {
                                        Navigator.of(context).pop();
                                        Get.rawSnackbar(
                                          messageText: Center(
                                            child: Text(
                                              '카카오톡이 설치되어 있지 않습니다.',
                                              style: snackBarStyle,
                                            ),
                                          ),
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: white.withOpacity(.5),
                                          barBlur: 2,
                                          duration: const Duration(seconds: 1, milliseconds: 100),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 44.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(70.0),
                                        color: yachtViolet,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '링크 공유하기',
                                          style: settingFriendsCodeButton1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Flexible(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _mixpanelService.mixpanel.track('My Referral Code Copy');
                                      Clipboard.setData(ClipboardData(text: '${_friendsCodeController.uiFriendsCode}'));

                                      Navigator.of(context).pop();
                                      Get.rawSnackbar(
                                        messageText: Center(
                                          child: Text(
                                            '나의 추천인 코드가 복사되었습니다.',
                                            style: snackBarStyle,
                                          ),
                                        ),
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: white.withOpacity(.5),
                                        barBlur: 2,
                                        duration: const Duration(seconds: 1, milliseconds: 100),
                                      );
                                    },
                                    child: Container(
                                      height: 44.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(70.0),
                                        color: buttonNormal,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '코드 복사하기',
                                          style: settingFriendsCodeButton2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          },
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '친구에게 추천하기',
              style: settingContent,
            ),
          ),
        ),
        SizedBox(
          height: correctHeight(17.w, settingContent.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _mixpanelService.mixpanel.track('Referral Code Insert');
            if (userModelRx.value!.friendsCodeDone == null || userModelRx.value!.friendsCodeDone == false) {
              _friendsCodeController.resetFriendsCodeVar();
              _keyController.text = '';

              showDialog(
                  context: context,
                  builder: (context) {
                    return GetBuilder<FriendsCodeController>(builder: (_) {
                      return Dialog(
                        backgroundColor: primaryBackgroundColor,
                        insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 14.w, right: 14.w),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: correctHeight(24.w, 0.w, settingFriendsCodeDialogTitle.fontSize),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 14.w,
                                    ),
                                    SizedBox(
                                        height: 15.w,
                                        width: 15.w,
                                        child: Image.asset('assets/icons/exit.png', color: Colors.transparent)),
                                    Spacer(),
                                    Text(
                                      '친구의 추천 코드 입력하기',
                                      style: settingFriendsCodeDialogTitle,
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: SizedBox(
                                          height: 15.w,
                                          width: 15.w,
                                          child: Image.asset('assets/icons/exit.png', color: yachtBlack)),
                                    ),
                                    SizedBox(
                                      width: 14.w,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: correctHeight(34.w, settingFriendsCodeDialogTitle.fontSize,
                                        settingFriendsCodeDialogContent.fontSize)),
                                Text(
                                  "친구에게 받은 추천 코드를 입력해주세요!",
                                  textAlign: TextAlign.center,
                                  style: settingFriendsCodeDialogContent,
                                ),
                                SizedBox(
                                  height: correctHeight(25.w, settingFriendsCodeDialogContent.fontSize, 0.w),
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color: yachtShadow,
                                          blurRadius: 8.w,
                                          spreadRadius: 1.w,
                                        )
                                      ]),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.w, top: 14.w, bottom: 11.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 316.w - 12.w - 22.w - 14.w,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              _friendsCodeController.dialogError = false;
                                              _friendsCodeController.update();
                                            },
                                            controller: _keyController,
                                            textAlignVertical: TextAlignVertical.center,
                                            textAlign: TextAlign.left,
                                            style: _friendsCodeController.dialogError
                                                ? settingFriendsCodeStyle.copyWith(color: yachtRed)
                                                : settingFriendsCodeStyle,
                                            cursorColor: yachtViolet,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding: EdgeInsets.all(0.w),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                            ),
                                          ),
                                        ),
                                        Image.asset('assets/icons/ic_warning.png',
                                            width: 22.w,
                                            height: 22.w,
                                            color: _friendsCodeController.dialogError ? yachtRed : Colors.transparent),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.w,
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () async {
                                          bool result =
                                              await _friendsCodeController.friendsCodeYacht(_keyController.text);

                                          if (result) {
                                            _mixpanelService.mixpanel.track('Referral Code Insert Done');
                                            Navigator.of(context).pop();
                                            Get.rawSnackbar(
                                              messageText: Center(
                                                child: Text(
                                                  '친구 추천 코드 입력을 완료하였습니다.',
                                                  style: snackBarStyle,
                                                ),
                                              ),
                                              snackPosition: SnackPosition.BOTTOM,
                                              backgroundColor: white.withOpacity(.5),
                                              barBlur: 2,
                                              duration: const Duration(seconds: 1, milliseconds: 100),
                                            );
                                          } else {}
                                        },
                                        child: Container(
                                          height: 44.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(70.0),
                                            color: _friendsCodeController.checking ? buttonDisabled : yachtViolet,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '코드 확인하기',
                                              style: _friendsCodeController.checking
                                                  ? settingFriendsCodeButton1.copyWith(color: yachtGrey)
                                                  : settingFriendsCodeButton1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Flexible(
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          height: 44.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(70.0),
                                            color: buttonNormal,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '취소하기',
                                              style: settingFriendsCodeButton2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 14.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  });
            } else {
              Get.rawSnackbar(
                messageText: Center(
                  child: Text(
                    '이미 친구 추천 코드 입력을 완료하였습니다.',
                    style: snackBarStyle,
                  ),
                ),
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: white.withOpacity(.5),
                barBlur: 2,
                duration: const Duration(seconds: 1, milliseconds: 100),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '친구의 추천 코드 입력하기',
              style: settingContent,
            ),
          ),
        ),
        SizedBox(
          height: correctHeight(17.w, settingContent.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _mixpanelService.mixpanel.track('Friends Who Recommended Me');
            Get.to(() => RecommendedMeListView());
          },
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '나를 추천한 친구들 보기',
              style: settingContent,
            ),
          ),
        ),
        SizedBox(
          height: correctHeight(17.w, settingContent.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(20.w, 0.w, settingTitle.fontSize),
        ),
        Padding(
          padding: EdgeInsets.only(left: 13.w, right: 13.w),
          child: Text(
            '고객센터',
            style: settingTitle,
          ),
        ),
        SizedBox(
          height: correctHeight(10.w, settingTitle.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        // SizedBox(
        //   height: correctHeight(18.w, 0.w, settingContent.fontSize),
        // ),
        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () {},
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 14.w, right: 14.w),
        //     child: Text(
        //       '공지사항',
        //       style: settingContent,
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: correctHeight(17.w, settingContent.fontSize, 0.w),
        // ),
        // Padding(
        //   padding: EdgeInsets.only(left: 14.w, right: 14.w),
        //   child: Container(
        //     height: 1.w,
        //     width: double.infinity,
        //     color: yachtLine,
        //   ),
        // ),
        // SizedBox(
        //   height: correctHeight(18.w, 0.w, settingContent.fontSize),
        // ),
        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () {},
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 14.w, right: 14.w),
        //     child: Text(
        //       '자주 묻는 질문 (FAQ)',
        //       style: settingContent,
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: correctHeight(17.w, settingContent.fontSize, 0.w),
        // ),
        // Padding(
        //   padding: EdgeInsets.only(left: 14.w, right: 14.w),
        //   child: Container(
        //     height: 1.w,
        //     width: double.infinity,
        //     color: yachtLine,
        //   ),
        // ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _mixpanelService.mixpanel.track('One On One Request');
            Get.to(() => OneOnOneView());
          },
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '1:1 문의하기',
              style: settingContent,
            ),
          ),
        ),
        SizedBox(
          height: correctHeight(17.w, settingContent.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _mixpanelService.mixpanel.track('My Request');
            Get.to(() => OneOnOneListView());
          },
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '나의 1:1 문의내역',
              style: settingContent,
            ),
          ),
        ),
        SizedBox(
          height: correctHeight(17.w, settingContent.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(20.w, 0.w, settingTitle.fontSize),
        ),
        Padding(
          padding: EdgeInsets.only(left: 13.w, right: 13.w),
          child: Text(
            '약관 및 정보',
            style: settingTitle,
          ),
        ),
        SizedBox(
          height: correctHeight(10.w, settingTitle.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _mixpanelService.mixpanel.track('Company Info');
            Get.to(() => PrimaryWebView(
                title: '회사 소개', url: 'https://brave-cinnamon-fa9.notion.site/ded059174d1743568632e83579012fcd'));
          },
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '회사 소개',
              style: settingContent,
            ),
          ),
        ),

        SizedBox(
          height: correctHeight(17.w, settingContent.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _mixpanelService.mixpanel.track('Privacy Policy');
            Get.to(() => PrimaryWebView(
                title: '개인정보처리방침', url: 'https://brave-cinnamon-fa9.notion.site/32727c42249b45a289b191d39ac66fa9'));
          },
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '개인정보처리방침',
              style: settingContent,
            ),
          ),
        ),
        SizedBox(
          height: correctHeight(17.w, settingContent.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _mixpanelService.mixpanel.track('Service Contract');
            Get.to(() => PrimaryWebView(
                title: '이용 약관', url: 'https://brave-cinnamon-fa9.notion.site/2b350b53e71d47eebe88f66b4bc462a7'));
          },
          child: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '이용 약관',
              style: settingContent,
            ),
          ),
        ),
        SizedBox(
          height: correctHeight(17.w, settingContent.fontSize, 0.w),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            height: 1.w,
            width: double.infinity,
            color: yachtLine,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w - 8.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          onTap: () {
            //kakao:1513684681
            //kakao:1518231402
            //kakao:1518411965
            //kakao:1531290810
            if (userModelRx.value!.uid == 'kakao:1513684681' ||
                userModelRx.value!.uid == 'kakao:1518231402' ||
                userModelRx.value!.uid == 'kakao:1518411965' ||
                userModelRx.value!.uid == 'kakao:1531290810') {
              print('운영진모드');
              Get.to(() => AdminModeView());
            }
          },
          child: Container(
            height: 8.w,
            color: userModelRx.value!.uid == 'kakao:1513684681' ||
                    userModelRx.value!.uid == 'kakao:1518231402' ||
                    userModelRx.value!.uid == 'kakao:1518411965' ||
                    userModelRx.value!.uid == 'kakao:1531290810'
                ? Colors.grey.withOpacity(0.1)
                : Colors.transparent,
          ),
        ),
        SizedBox(
          height: correctHeight(20.w, 0.w, settingTitle.fontSize),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _mixpanelService.mixpanel.track('Unregister');
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        backgroundColor: yachtDarkGrey,
                        insetPadding: primaryHorizontalPadding,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(
                                    14.w, correctHeight(14.w, 0.0, dialogTitle.fontSize), 14.w, 14.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.w),
                                  // color: yachtDarkGrey,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("알림", style: dialogTitle),
                                    SizedBox(height: correctHeight(14.w, 0.0, dialogTitle.fontSize)),
                                    Text("정말 탈퇴하시겠습니까?", style: dialogContent),
                                    SizedBox(height: correctHeight(14.w, 0.0, dialogTitle.fontSize)),
                                    Center(
                                      child: Text(
                                        "탈퇴 시 모든 데이터가 삭제되며 \n되돌릴 수 없습니다.",
                                        style: dialogWarning,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                              onTap: () async {
                                                _mixpanelService.mixpanel.track('Unregister Confirm');
                                                _authService.deleteAccount();

                                                _kakaoApi.signOut();
                                                userModelRx(null);
                                                userQuestModelRx.value = [];
                                                leagueRx("");

                                                // _kakaoApi.
                                                print("signout");
                                                Navigator.of(context).pop();
                                                await Get.offAll(() => AuthCheckView());
                                                Get.find<AuthCheckViewModel>().onInit();
                                              },
                                              child: textContainerButtonWithOptions(
                                                text: "예",
                                                isDarkBackground: false,
                                                height: 44.w,
                                              )),
                                        ),
                                        SizedBox(width: 8.w),
                                        Expanded(
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                // Get.back(closeOverlays: true);
                                              },
                                              child: textContainerButtonWithOptions(
                                                  text: "아니오", isDarkBackground: true, height: 44.w)),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          ],
                        )));
              },
              child: Center(
                child: Text(
                  '회원탈퇴',
                  style: settingLogout,
                ),
              ),
            ),
            SizedBox(width: 30.w),
            Container(
              height: settingLogout.fontSize,
              width: 1.w,
              color: settingLogout.color,
            ),
            SizedBox(width: 30.w),
            InkWell(
              onTap: () {
                _mixpanelService.mixpanel.track('Sign Out');
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        backgroundColor: yachtDarkGrey,
                        insetPadding: primaryHorizontalPadding,
                        child: Container(
                            padding:
                                EdgeInsets.fromLTRB(14.w, correctHeight(14.w, 0.0, dialogTitle.fontSize), 14.w, 14.w),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("알림", style: dialogTitle),
                                SizedBox(height: correctHeight(14.w, 0.0, dialogTitle.fontSize)),
                                SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                Text("정말 로그아웃 하시겠습니까?", style: dialogContent),
                                SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                          onTap: () async {
                                            _mixpanelService.mixpanel.track('Sign Out Confirm');
                                            HapticFeedback.lightImpact();
                                            leagueRx("");
                                            userModelRx.value = null;
                                            userQuestModelRx.value = [];
                                            todayQuests = null;
                                            // _kakaoApi.signOut();
                                            await _authService.auth.signOut();

                                            // print("signout");
                                            Navigator.of(context).pop();
                                            // Restart.restartApp();
                                            // leagueRx.close();
                                            // userModelRx.close();
                                            // userQuestModelRx.close();

                                            // Get.find<HomeViewModel>().refreshController.dispose();
                                            await Get.offAll(() => AuthCheckView());
                                            Get.find<AuthCheckViewModel>().onInit();
                                          },
                                          child: textContainerButtonWithOptions(
                                            text: "예",
                                            isDarkBackground: false,
                                            height: 44.w,
                                          )),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                            // Get.back(closeOverlays: true);
                                          },
                                          child: textContainerButtonWithOptions(
                                              text: "아니오", isDarkBackground: true, height: 44.w)),
                                    )
                                  ],
                                )
                              ],
                            ))));
                // _authService.auth.signOut();
                // Get.back();
                // userModelRx(null);
                // userQuestModelRx.value = [];
                // leagueRx("");
                // _kakaoApi.signOut();
                // print("signout");
              },
              child: Center(
                child: Text(
                  '로그아웃',
                  style: settingLogout,
                ),
              ),
            ),
          ],
        ),

        SizedBox(
          height: correctHeight(20.w, settingLogout.fontSize, 0.w),
        ),
      ]),
    );
  }
}

class RecommendedMeListView extends StatelessWidget {
  // RecommendedMeListView({});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: primaryAppBar('나를 추천한 친구들'),
        body: userModelRx.value!.friendsUidRecommededMe != null
            ? ListView(children: [
                Column(
                  children: userModelRx.value!.friendsUidRecommededMe!
                      .toList()
                      .asMap()
                      .map((i, element) => MapEntry(
                          i,
                          Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => ProfileOthersView(uid: userModelRx.value!.friendsUidRecommededMe![i]));
                              },
                              child: Column(
                                children: [
                                  SizedBox(height: 14.w),
                                  FutureBuilder<UserModel>(
                                      future: Get.find<ProfileMyViewModel>()
                                          .getOtherUserModel(userModelRx.value!.friendsUidRecommededMe![i]),
                                      builder: (_, snapshot) {
                                        return Row(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey,
                                              ),
                                              height: 36.w,
                                              width: 36.w,
                                              child: snapshot.hasData
                                                  ? snapshot.data!.avatarImage != null
                                                      ? Image.network(
                                                          "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${snapshot.data!.avatarImage}.png")
                                                      : Container()
                                                  : Container(),
                                            ),
                                            SizedBox(
                                              width: 8.w,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.hasData ? '${snapshot.data!.userName}' : '',
                                                  style: profileFollowNickNameStyle,
                                                ),
                                                SizedBox(
                                                  height: correctHeight(4.w, profileFollowNickNameStyle.fontSize, 0.w),
                                                ),
                                                simpleTierRRectBox(
                                                  exp: snapshot.hasData ? snapshot.data!.exp : 0,
                                                )
                                              ],
                                            ),
                                            Spacer(),
                                          ],
                                        );
                                      }),
                                  SizedBox(
                                    height: 14.w,
                                  ),
                                  Container(
                                    height: 1.w,
                                    width: double.infinity,
                                    color: yachtLine,
                                  )
                                ],
                              ),
                            ),
                          )))
                      .values
                      .toList(),
                )
              ])
            : Column(
                children: [
                  SizedBox(
                    height: 50.w,
                  ),
                  Container(
                    width: 375.w,
                    child: Stack(
                      children: [
                        Center(
                            child: Container(
                          width: 265.w,
                          height: 86.w,
                          child: Image.asset('assets/illusts/not_exists/no_general_words.png'),
                        )),
                        Positioned(
                          top: 21.w,
                          child: Container(
                            width: 375.w,
                            child: Center(
                              child: Text(
                                '아직 나를 추천한 친구가 없어요.',
                                style: notExistsText,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  Center(
                      child: Container(
                    width: 71.w,
                    height: 56.w,
                    child: Image.asset('assets/illusts/not_exists/no_general_illust.png'),
                  ))
                ],
              ));
  }
}
