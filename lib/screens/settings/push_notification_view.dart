import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yachtOne/screens/settings/push_notification_view_model.dart';

import 'package:yachtOne/styles/yacht_design_system.dart';
import 'push_notification_view_model.dart';

class PushNotificationView extends StatelessWidget {
  final PushNotificationViewModel _pushNotificationViewModel = Get.put(PushNotificationViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: primaryAppBar('푸시 알림 설정'),
      body: ListView(
        children: List.generate(_pushNotificationViewModel.getPushAlarmLength(), (i) {
          return Column(
            children: [
              i == 0 ? SizedBox(height: 20.w) : Container(),
              i == 0
                  ? Padding(
                      padding: EdgeInsets.only(left: 14.w, right: 14.w),
                      child: Container(
                        height: 1.w,
                        width: double.infinity,
                        color: yachtLineColor,
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 11.w,
              ),
              // SizedBox(
              //   height: correctHeight(18.w, 0.w, settingContent.fontSize),
              // ),
              SizedBox(
                height: 27.w,
                child: Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    Text(
                      '${_pushNotificationViewModel.getPushAlarmTitle(i)}',
                      style: settingContent,
                    ),
                    Spacer(),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GetBuilder<PushNotificationViewModel>(
                            id: 'pushAlarmValue',
                            builder: (controller) {
                              return Platform.isIOS
                                  ? CupertinoSwitch(
                                      activeColor: primaryButtonBackground,
                                      trackColor: buttonNormal,
                                      value: _pushNotificationViewModel.getPushAlarmValue(i),
                                      onChanged: (value) {
                                        _pushNotificationViewModel.setPushAlarmValue(i, !value);
                                      },
                                    )
                                  : Switch(
                                      activeColor: primaryButtonBackground,
                                      // trackColor: buttonNormal,
                                      value: true,
                                      onChanged: (value) {},
                                      // value: !model.pushAlarm[pushAlarmIndex],
                                      // onChanged: (bool value) {
                                      //   model.setSharedPreference(pushAlarmIndex, !value);
                                      // },
                                    );
                            }),
                      ],
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: correctHeight(17.w, settingContent.fontSize, 0.w),
              // ),
              SizedBox(
                height: 11.w,
              ),
              Padding(
                padding: EdgeInsets.only(left: 14.w, right: 14.w),
                child: Container(
                  height: 1.w,
                  width: double.infinity,
                  color: yachtLineColor,
                ),
              ),
            ],
          );
        }),
        // children: [
        // SizedBox(
        //   height: correctHeight(20.w, 0.w, settingTitle.fontSize),
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
        // Padding(
        //   padding: EdgeInsets.only(left: 14.w, right: 14.w),
        //   child: Text(
        //     '푸시 알림 설정',
        //     style: settingContent,
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
        // ]
      ),
    );
  }
}
