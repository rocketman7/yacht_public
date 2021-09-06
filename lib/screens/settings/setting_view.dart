import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/settings/push_notification_view.dart';

import 'package:yachtOne/styles/yacht_design_system.dart';

import 'account_view.dart';

class SettingView extends StatelessWidget {
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
      ]),
    );
  }
}
