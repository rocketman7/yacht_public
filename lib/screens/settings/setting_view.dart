import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:yachtOne/repositories/repository.dart';

import '../../styles/yacht_design_system.dart';

import 'account_view.dart';
import 'friends_code_controller.dart';
import 'push_notification_view.dart';

class SettingView extends StatelessWidget {
  final FriendsCodeController _friendsCodeController =
      Get.put(FriendsCodeController());
  final TextEditingController _keyController = TextEditingController();

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
            color: yachtLineColor,
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
            color: yachtLineColor,
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
            color: yachtLineColor,
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
            color: yachtLineColor,
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 14.w, right: 14.w),
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: correctHeight(24.w, 0.w,
                                  settingFriendsCodeDialogTitle.fontSize),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 14.w,
                                ),
                                SizedBox(
                                    height: 15.w,
                                    width: 15.w,
                                    child: Image.asset('assets/icons/exit.png',
                                        color: Colors.transparent)),
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
                                      child: Image.asset(
                                          'assets/icons/exit.png',
                                          color: yachtBlack)),
                                ),
                                SizedBox(
                                  width: 14.w,
                                ),
                              ],
                            ),
                            SizedBox(
                                height: correctHeight(
                                    34.w,
                                    settingFriendsCodeDialogTitle.fontSize,
                                    settingFriendsCodeDialogContent.fontSize)),
                            Text(
                              "친구에게 추천 링크를 공유해보세요!",
                              textAlign: TextAlign.center,
                              style: settingFriendsCodeDialogContent,
                            ),
                            SizedBox(
                              height: correctHeight(
                                  25.w,
                                  settingFriendsCodeDialogContent.fontSize,
                                  0.w),
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
                                  padding: EdgeInsets.only(
                                      left: 12.w, top: 14.w, bottom: 11.w),
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
                                      bool installed =
                                          await isKakaoTalkInstalled();
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
                                          backgroundColor:
                                              white.withOpacity(.5),
                                          barBlur: 2,
                                          duration: const Duration(
                                              seconds: 1, milliseconds: 100),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 44.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(70.0),
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
                                      Clipboard.setData(ClipboardData(
                                          text:
                                              '${_friendsCodeController.uiFriendsCode}'));

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
                                        duration: const Duration(
                                            seconds: 1, milliseconds: 100),
                                      );
                                    },
                                    child: Container(
                                      height: 44.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(70.0),
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
            color: yachtLineColor,
          ),
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, settingContent.fontSize),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (userModelRx.value!.friendsCodeDone == null ||
                userModelRx.value!.friendsCodeDone == false) {
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 14.w, right: 14.w),
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: correctHeight(24.w, 0.w,
                                      settingFriendsCodeDialogTitle.fontSize),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 14.w,
                                    ),
                                    SizedBox(
                                        height: 15.w,
                                        width: 15.w,
                                        child: Image.asset(
                                            'assets/icons/exit.png',
                                            color: Colors.transparent)),
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
                                          child: Image.asset(
                                              'assets/icons/exit.png',
                                              color: yachtBlack)),
                                    ),
                                    SizedBox(
                                      width: 14.w,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height: correctHeight(
                                        34.w,
                                        settingFriendsCodeDialogTitle.fontSize,
                                        settingFriendsCodeDialogContent
                                            .fontSize)),
                                Text(
                                  "친구에게 받은 추천 코드를 입력해주세요!",
                                  textAlign: TextAlign.center,
                                  style: settingFriendsCodeDialogContent,
                                ),
                                SizedBox(
                                  height: correctHeight(
                                      25.w,
                                      settingFriendsCodeDialogContent.fontSize,
                                      0.w),
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
                                    padding: EdgeInsets.only(
                                        left: 12.w, top: 14.w, bottom: 11.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 316.w - 12.w - 22.w - 14.w,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              _friendsCodeController
                                                  .dialogError = false;
                                              _friendsCodeController.update();
                                            },
                                            controller: _keyController,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            textAlign: TextAlign.left,
                                            style: _friendsCodeController
                                                    .dialogError
                                                ? settingFriendsCodeStyle
                                                    .copyWith(color: yachtRed)
                                                : settingFriendsCodeStyle,
                                            cursorColor: yachtViolet,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(0.w),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                            'assets/icons/ic_warning.png',
                                            width: 22.w,
                                            height: 22.w,
                                            color: _friendsCodeController
                                                    .dialogError
                                                ? yachtRed
                                                : Colors.transparent),
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
                                              await _friendsCodeController
                                                  .friendsCodeYacht(
                                                      _keyController.text);

                                          if (result) {
                                            Navigator.of(context).pop();
                                            Get.rawSnackbar(
                                              messageText: Center(
                                                child: Text(
                                                  '친구 추천 코드 입력을 완료하였습니다.',
                                                  style: snackBarStyle,
                                                ),
                                              ),
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor:
                                                  white.withOpacity(.5),
                                              barBlur: 2,
                                              duration: const Duration(
                                                  seconds: 1,
                                                  milliseconds: 100),
                                            );
                                          } else {}
                                        },
                                        child: Container(
                                          height: 44.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(70.0),
                                            color:
                                                _friendsCodeController.checking
                                                    ? buttonDisabled
                                                    : yachtViolet,
                                          ),
                                          child: Center(
                                            child: Text(
                                              '코드 확인하기',
                                              style: _friendsCodeController
                                                      .checking
                                                  ? settingFriendsCodeButton1
                                                      .copyWith(
                                                          color: yachtGrey)
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
                                            borderRadius:
                                                BorderRadius.circular(70.0),
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
            color: yachtLineColor,
          ),
        ),
      ]),
    );
  }
}
