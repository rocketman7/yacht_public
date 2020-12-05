import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';

import '../../models/sharedPreferences_const.dart';
import '../../view_models/mypage_pushAlarmSetting_view_model.dart';

class MypagePushAlarmSettingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypagePushAlarmSettingViewModel>.reactive(
        viewModelBuilder: () => MypagePushAlarmSettingViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  '푸쉬알림 설정',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                elevation: 1,
              ),
              backgroundColor: Colors.white,
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? Container()
                      : SafeArea(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: ListView.builder(
                            itemCount: model.numOfPushAlarm,
                            itemBuilder: (context, index) =>
                                makePushAlarmItem(model, index),
                          ),
                        )));
        });
  }

  Widget makePushAlarmItem(
      MypagePushAlarmSettingViewModel model, int pushAlarmIndex) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${model.pushAlarmTitles[pushAlarmIndex]}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                Text(
                  '${model.pushAlarmSubTitles[pushAlarmIndex]}',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB9B9B9)),
                )
              ],
            ),
            Spacer(),
            Platform.isIOS
                // value를 !인채로 써주어야함. notification service 제대로 쓰기 위해.(sharedpreferences의해 최초값 알림설정하게 해주기 위해)
                ? CupertinoSwitch(
                    activeColor: Color(0xFF1EC8CF),
                    value: !model.pushAlarm[pushAlarmIndex],
                    onChanged: (bool value) {
                      model.setSharedPreference(pushAlarmIndex, !value);
                    },
                  )
                : Switch(
                    activeColor: Color(0xFF1EC8CF),
                    value: !model.pushAlarm[pushAlarmIndex],
                    onChanged: (bool value) {
                      model.setSharedPreference(pushAlarmIndex, !value);
                    },
                  )
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          height: 1,
          color: Color(0xFFE3E3E3),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }
}
