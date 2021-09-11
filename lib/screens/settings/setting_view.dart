import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/link.dart';

import '../../styles/yacht_design_system.dart';

import 'account_view.dart';
import 'friends_code_controller.dart';
import 'push_notification_view.dart';

class SettingView extends StatelessWidget {
  final FriendsCodeController _friendsCodeController =
      Get.put(FriendsCodeController());

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
            Get.dialog(myFriendCodeDialog());
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
        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () {},
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 14.w, right: 14.w),
        //     child: Text(
        //       '친구의 추천 코드 입력하기',
        //       style: settingContent,
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: correctHeight(17.w, settingContent.fontSize, 0.w),
        // ),
      ]),
    );
  }
}

Widget myFriendCodeDialog() {
  final FriendsCodeController _friendsCodeController =
      Get.put(FriendsCodeController());

  return Dialog(
    backgroundColor: primaryBackgroundColor,
    insetPadding: EdgeInsets.only(top: 24.w, left: 14.w, right: 14.w),
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Padding(
      padding: EdgeInsets.only(left: 14.w, right: 14.w),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: correctHeight(
                  14.w, 0.w, settingFriendsCodeDialogTitle.fontSize),
            ),
            Text(
              '친구에게 추천하기',
              style: settingFriendsCodeDialogTitle,
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
                  25.w, settingFriendsCodeDialogContent.fontSize, 0.w),
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
                        // Get.back();
                        Get.rawSnackbar(
                          messageText: Center(
                            child: Text(
                              '카카오톡이 설치되어 있지 않습니다.',
                              style: snackBarStyle,
                            ),
                          ),
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: white.withOpacity(.5),
                          barBlur: 2,
                          margin: EdgeInsets.only(top: 60.w),
                          duration:
                              const Duration(seconds: 1, milliseconds: 100),
                        );
                      }
                    },
                    child: Container(
                      height: 44.w,
                      // width: double.infinity,
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
                      Clipboard.setData(ClipboardData(
                          text: '${_friendsCodeController.uiFriendsCode}'));
                      // Get.back();
                      Get.rawSnackbar(
                        messageText: Center(
                          child: Text(
                            '나의 추천인 코드가 복사되었습니다.',
                            style: snackBarStyle,
                          ),
                        ),
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: white.withOpacity(.5),
                        barBlur: 2,
                        margin: EdgeInsets.only(top: 60.w),
                        duration: const Duration(seconds: 1, milliseconds: 100),
                      );
                    },
                    child: Container(
                      height: 44.w,
                      // width: double.infinity,
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
            // Padding(
            //   padding: EdgeInsets.only(left: 14.w, right: 14.w),
            //   child: GestureDetector(
            //     onTap: () {
            //       Get.back();
            //     },
            //     child: Container(
            //       height: 44.w,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(70.0),
            //           color: Color(0xFF6073B4)),
            //       width: double.infinity,
            //       child: Center(
            //         child: Text(
            //           '확인',
            //           style: adsWarningButton,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    ),
  );
}
