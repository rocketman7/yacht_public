import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/auth/auth_check_view.dart';
import 'package:yachtOne/screens/auth/auth_check_view_model.dart';
import 'package:yachtOne/screens/profile/profile_my_view_model.dart';
import 'package:yachtOne/screens/profile/profile_others_view.dart';
import 'package:yachtOne/screens/auth/kakao_firebase_auth_api.dart';
import 'package:yachtOne/services/auth_service.dart';

import '../../locator.dart';
import '../../styles/yacht_design_system.dart';

import 'account_view.dart';
import 'friends_code_controller.dart';
import 'one_on_one_view.dart';
import 'push_notification_view.dart';

class SettingView extends StatelessWidget {
  final FriendsCodeController _friendsCodeController = Get.put(FriendsCodeController());
  final TextEditingController _keyController = TextEditingController();
  final AuthService _authService = locator<AuthService>();
  final KakaoFirebaseAuthApi _kakaoApi = KakaoFirebaseAuthApi();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
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
        // SizedBox(
        //   height: correctHeight(20.w, 0.w, settingTitle.fontSize),
        // ),
        // Padding(
        //   padding: EdgeInsets.only(left: 13.w, right: 13.w),
        //   child: Text(
        //     '고객센터',
        //     style: settingTitle,
        //   ),
        // ),
        // SizedBox(
        //   height: correctHeight(10.w, settingTitle.fontSize, 0.w),
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
        //     color: yachtLineColor,
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
        //     color: yachtLineColor,
        //   ),
        // ),
        // SizedBox(
        //   height: correctHeight(18.w, 0.w, settingContent.fontSize),
        // ),
        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () {
        //     Get.to(() => OneOnOneView());
        //   },
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 14.w, right: 14.w),
        //     child: Text(
        //       '1:1 문의하기',
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
        //   height: correctHeight(20.w, 0.w, settingTitle.fontSize),
        // ),
        // Padding(
        //   padding: EdgeInsets.only(left: 13.w, right: 13.w),
        //   child: Text(
        //     '약관 및 정보',
        //     style: settingTitle,
        //   ),
        // ),
        // SizedBox(
        //   height: correctHeight(10.w, settingTitle.fontSize, 0.w),
        // ),
        // Padding(
        //   padding: EdgeInsets.only(left: 14.w, right: 14.w),
        //   child: Container(
        //     height: 1.w,
        //     width: double.infinity,
        //     color: yachtLineColor,
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
        //       '이용약관',
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
        //     color: yachtLineColor,
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
        //       '개인정보 취급 방침',
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
        //     color: yachtLineColor,
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
        //       '사업자 정보',
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
        //     color: yachtLineColor,
        //   ),
        // ),
        SizedBox(
          height: correctHeight(20.w, 0.w, settingTitle.fontSize),
        ),
        Padding(
          padding: EdgeInsets.only(left: 13.w, right: 13.w),
          child: Text(
            '정보',
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
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        SizedBox(
          height: correctHeight(20.w, 0.w, settingTitle.fontSize),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        insetPadding: primaryHorizontalPadding,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(
                                    14.w, correctHeight(14.w, 0.0, dialogTitle.fontSize), 14.w, 14.w),
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
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
                                                _authService.deleteAccount();

                                                userModelRx(null);
                                                userQuestModelRx.value = [];
                                                leagueRx("");

                                                // _kakaoApi.
                                                _kakaoApi.signOut();
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
                showDialog(
                    context: context,
                    builder: (context) => Dialog(
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
                                            HapticFeedback.lightImpact();
                                            _authService.auth.signOut();
                                            userModelRx(null);
                                            userQuestModelRx.value = [];
                                            leagueRx("");
                                            _kakaoApi.signOut();
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
        appBar: AppBar(
          backgroundColor: white,
          toolbarHeight: 60.w,
          title: Text('나를 추천한 친구들', style: appBarTitle),
        ),
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
                                                  ? FutureBuilder<String>(
                                                      future: Get.find<ProfileMyViewModel>().getImageUrlFromStorage(
                                                          'avatars/${snapshot.data!.avatarImage}.png'),
                                                      builder: (__, snapshotForImageURL) {
                                                        return snapshotForImageURL.hasData
                                                            ? Image.network(snapshotForImageURL.data.toString())
                                                            : Container();
                                                      },
                                                    )
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
