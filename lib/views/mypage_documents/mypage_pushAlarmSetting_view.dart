import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/cupertino.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../../view_models/mypage_pushAlarmSetting_view_model.dart';
import '../loading_view.dart';

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
                      ? FlareActor(
                          'assets/images/Loading.flr',
                          animation: 'loading',
                        )
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
            CupertinoSwitch(
              activeColor: Color(0xFF1EC8CF),
              value: model.pushAlarm[pushAlarmIndex],
              onChanged: (bool value) {
                model.pushAlarm[pushAlarmIndex] = value;
                model.setSharedPreferencesAll();
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
