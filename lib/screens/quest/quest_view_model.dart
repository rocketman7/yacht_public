import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/quest_model.dart';

class QuestViewModel extends GetxController {
  RxString timeToEnd = "".obs;
  DateTime now = DateTime.now();
  @override
  void onInit() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      now = DateTime.now();
      timeLeft();
    });

    // getThisQuest();
    // update();
    super.onInit();
  }

  final QuestModel tempQuestModel = QuestModel(
      category: "one",
      title: "수익률이 더 높을 종목은?",
      country: "KR",
      pointReward: 3,
      cashReward: 50000,
      exp: 300,
      candidates: [
        {"stocks": "005930"},
        {"stocks": "326030"}
      ],
      result: [1, 0],
      startDateTime: DateTime(2021, 6, 12, 08, 50, 00),
      endDateTime: DateTime(2021, 6, 20, 08, 50),
      resultDateTime: DateTime(2021, 6, 14, 16, 00));

  // final DateTime now = DateTime.now();
  // Duration? timeLeft;

  void timeLeft() {
    Duration timeLeft = tempQuestModel.endDateTime.difference(now);
    timeToEnd(countDown(timeLeft));
    // return countDown(timeLeft);
  }
}
