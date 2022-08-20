import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../handlers/date_time_handler.dart';
import '../../models/quest_model.dart';
import '../../styles/yacht_design_system.dart';

class TimeCounterWidget extends StatefulWidget {
  final QuestModel questModel;
  TimeCounterWidget({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  @override
  State<TimeCounterWidget> createState() => _TimeCounterWidgetState();
}

class _TimeCounterWidgetState extends State<TimeCounterWidget> {
  // 타이머 1초마다 작동
  Timer? _everySecond;
  // 남은 시간 보여줌
  RxString timeToEnd = "".obs;
  DateTime now = DateTime.now();

  @override
  void initState() {
    _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {
      now = DateTime.now();
      timeLeft();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (_everySecond != null && _everySecond!.isActive) _everySecond!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void timeLeft() {
    if (widget.questModel.questEndDateTime == null) {
      timeToEnd("마감시한 없음");
    } else {
      Duration timeLeft = widget.questModel.questEndDateTime.toDate().difference(now);
      if (timeLeft.inSeconds > 0) {
        timeToEnd('${shorterCountDown(timeLeft)}');
      } else {
        {
          timeToEnd('마감되었습니다');
        }
      }
    }
    // return countDown(timeLeft);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
          timeToEnd.value, // temp
          style: TextStyle(
            color: yachtWhite,
            height: 1.3.w,
          ),
        ));
  }
}

class LiveTimeCounterWidget extends StatefulWidget {
  final QuestModel questModel;
  LiveTimeCounterWidget({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  @override
  State<LiveTimeCounterWidget> createState() => _LiveTimeCounterWidgetState();
}

class _LiveTimeCounterWidgetState extends State<LiveTimeCounterWidget> {
  // 타이머 1초마다 작동
  Timer? _everySecond;
  // 남은 시간 보여줌
  RxString timeToEnd = "".obs;
  DateTime now = DateTime.now();

  @override
  void initState() {
    _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {
      now = DateTime.now();
      timeLeft();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (_everySecond != null && _everySecond!.isActive) _everySecond!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void timeLeft() {
    if (widget.questModel.liveEndDateTime == null) {
      timeToEnd("마감시한 없음");
    } else {
      Duration timeLeft = widget.questModel.liveEndDateTime.toDate().difference(now);
      if (timeLeft.inSeconds > 0) {
        timeToEnd('결과까지 ${shorterCountDown(timeLeft)}');
      } else {
        {
          timeToEnd('LIVE 종료!');
        }
      }
    }
    // return countDown(timeLeft);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
          timeToEnd.value, // temp
          style: TextStyle(
            color: yachtWhite,
          ),
        ));
  }
}
