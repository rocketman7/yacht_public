import 'dart:async';

import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/user_tier_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';

class QuestResultsViewModel extends GetxController {
  final QuestModel questModel;
  final UserQuestModel? otherUserQuestModel;
  final int? otherUserExp;
  QuestResultsViewModel({
    required this.questModel,
    this.otherUserQuestModel,
    this.otherUserExp,
  });

  final Rxn<UserQuestModel> thisUserQuestModel = Rxn<UserQuestModel>();
  Timer? _everySecond;
  // 남은 시간 보여줌
  final RxString timeToEnd = "".obs;
  DateTime now = DateTime.now();

  RxInt expBarStart = 0.obs;
  RxInt expBarEnd = 0.obs;
  RxInt expBarBeforeReward = 0.obs;
  RxInt expBarAfterReward = 0.obs;

  // final RxBool hasUserJoinedThisQuest = false.obs;
  // final RxBool hasUserSucceededThisQuest = false.obs;

  @override
  void onInit() {
    // _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {
    //   now = DateTime.now();
    //   timeLeft();
    // });

// 뷰모델의 Local userQuestModel에 userQuestModel Rx value를 받아오는데
    // 이 퀘스트의 선택만 가져온다
    if (otherUserQuestModel != null) {
      thisUserQuestModel(otherUserQuestModel);
      expBarStart(getBeforeTierExp(otherUserExp ?? 0));
      expBarEnd(getNextTierExp(otherUserExp ?? 0));
      expBarBeforeReward((otherUserExp ?? 0) -
          ((otherUserQuestModel!.expSuccessRewarded ?? 0) + (otherUserQuestModel!.expParticipationRewarded ?? 0)));
      expBarAfterReward(otherUserExp ?? 0);

      print(expBarStart.value);
      print(expBarEnd.value);
      print(expBarBeforeReward.value);
      print(expBarAfterReward.value);
    } else {
      if (userQuestModelRx.length > 0) {
        print('questModel');
        print(questModel.questId);
        if (userQuestModelRx.where((element) => element.questId == questModel.questId).length > 0) {
          thisUserQuestModel(userQuestModelRx.where((element) => element.questId == questModel.questId).first);
        }
        // thisUserQuestModel.value == null
        //     ? orderList.addAll(List.generate(questModel.investAddresses!.length, (index) => index))
        //     : orderList(thisUserQuestModel.value!.selection);
      }

      userQuestModelRx.listen((value) {
        // print('userQuestModel changed');
        if (value.length > 0) {
          if (userQuestModelRx.where((element) => element.questId == questModel.questId).length > 0) {
            thisUserQuestModel(userQuestModelRx.where((element) => element.questId == questModel.questId).first);
          }
          // thisUserQuestModel.value == null
          //     ? orderList.addAll(List.generate(questModel.investAddresses!.length, (index) => index))
          //     : orderList(thisUserQuestModel.value!.selection);
        }
      });
      // thisUserQuestModel.refresh();
      // print('userquestmodel at result' + thisUserQuestModel.toString());

      if (thisUserQuestModel.value != null) {
        expBarStart(getBeforeTierExp(userModelRx.value!.exp));
        expBarEnd(getNextTierExp(userModelRx.value!.exp));
        expBarBeforeReward(userModelRx.value!.exp -
            ((thisUserQuestModel.value!.expSuccessRewarded ?? 0) +
                (thisUserQuestModel.value!.expParticipationRewarded ?? 0)));
        expBarAfterReward(userModelRx.value!.exp);
      }
    }
    super.onInit();
  }

  void timeLeft() {
    if (questModel.questEndDateTime == null) {
      timeToEnd("마감시한 없음");
    } else {
      Duration timeLeft = questModel.questEndDateTime.toDate().difference(now);
      timeToEnd('${countDown(timeLeft)} 뒤 마감');
    }
    // return countDown(timeLeft);
  }

  String showUserSelection(UserQuestModel userQuestModel, QuestModel questModel) {
    if (userQuestModel.selection == null) {
      return "퀘스트에 참여하지 않았습니다.";
    } else {
      List<String> resultArray = userQuestModel.selection!.map((e) => questModel.choices![e]).toList();
      // print(userQuestModel.selection);

      String temp = "";

      if (questModel.selectMode == "order") {
        for (int i = 0; i < resultArray.length; i++) {
          if (i != resultArray.length - 1) {
            temp += "${resultArray[i]}-";
          } else {
            temp += "${resultArray[i]}";
          }
        }
      } else {
        for (int i = 0; i < resultArray.length; i++) {
          if (i != resultArray.length - 1) {
            temp += "${resultArray[i]}, ";
          } else {
            temp += "${resultArray[i]}";
          }
        }
      }
      return temp;
    }
  }
}
