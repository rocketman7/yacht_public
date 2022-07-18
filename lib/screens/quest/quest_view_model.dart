import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/league_address_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/corporation_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/stock_info/chart/chart_view_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../locator.dart';

class QuestViewModel extends GetxController {
  final QuestModel questModel;
  QuestViewModel(this.questModel);

  FirestoreService _firestoreService = locator<FirestoreService>();
  FirebaseStorageService _storageService = FirebaseStorageService();

  // quest의 선택 종목 중에서 몇 번째 인덱스인지
  RxInt stockInfoIndex = 0.obs;
  // 타이머 1초마다 작동
  Timer? _everySecond;
  // 남은 시간 보여줌
  RxString timeToEnd = "".obs;
  DateTime now = DateTime.now();

  String? imageUrl;
  RxList logoImage = [].obs;
  String? uid;
  RxBool isLoading = false.obs;

  // 예측 최종 확정 중일 때 true로
  RxBool isSelectingSheetShowing = false.obs;

  // 예측 확정 작업 중
  RxBool isSelectingWorking = false.obs;
  // init(QuestModel model) {
  //   questModel = model;
  //   // update();
  // }
  // 이 위젯에 해당하는 userQuestModel을 확인하고 userQuestModel에 넣어준다
  final Rxn<UserQuestModel> thisUserQuestModel = Rxn<UserQuestModel>();

  // toggle에 쓰일 bool list
  RxList<bool> toggleList = <bool>[].obs;
  RxList<int> orderList = <int>[].obs;
  RxList<int> updownManyList = <int>[].obs;

  @override
  void onClose() {
    // 컨트롤러 없어질 때 타이머 끄기

    _everySecond!.cancel();
    super.onClose();
  }

  @override
  void onInit() async {
    // print(
    // 'userquestmodel selectDatetime value check: ${userQuestModel.value!.selectDateTime}');
    isLoading(true);
    _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {
      now = DateTime.now();
      timeLeft();
    });

    // 뷰모델의 Local userQuestModel에 userQuestModel Rx value를 받아오는데
    // 이 퀘스트의 선택만 가져온다
    if (userQuestModelRx.length > 0) {
      if (userQuestModelRx.where((element) => element.questId == questModel.questId).length > 0) {
        thisUserQuestModel(userQuestModelRx.where((element) => element.questId == questModel.questId).first);
      }
      thisUserQuestModel.value == null
          ? orderList.addAll(List.generate(questModel.investAddresses!.length, (index) => index))
          : orderList(thisUserQuestModel.value!.selection);
    }

    userQuestModelRx.listen((value) {
      // print('userQuestModel changed');
      if (value.length > 0) {
        if (userQuestModelRx.where((element) => element.questId == questModel.questId).length > 0) {
          thisUserQuestModel(userQuestModelRx.where((element) => element.questId == questModel.questId).first);
        }
        thisUserQuestModel.value == null
            ? orderList.addAll(List.generate(questModel.investAddresses!.length, (index) => index))
            : orderList(thisUserQuestModel.value!.selection);
      }
    });
    print('userquestmodel value check: ${thisUserQuestModel.value}');
    // order 타입의 selectMode Quest를 위한 리스트
    thisUserQuestModel.value == null
        ? orderList.addAll(List.generate(questModel.investAddresses!.length, (index) => index))
        : orderList(thisUserQuestModel.value!.selection);

    syncUserSelect();

    // logo 이미지 가져오기
    await getImages();

    print('locally' + thisUserQuestModel.toString());
    print('globally' + userQuestModelRx.toString());
    if (questModel.selectMode == 'updown_many') {
      questModel.investAddresses!.forEach((element) {
        updownManyList.add(-1);
      });
    }
    isLoading(false);
    update();
    super.onInit();
    // return
  }

  bool checkIfUserSelectedAny() {
    bool checking = false;
    toggleList.forEach((element) {
      // print(element);
      checking = checking || element;
    });
    // print('check $checking');
    return checking;
  }

  void syncUserSelect() {
    toggleList = questModel.selectMode == 'updown'
        ? List.generate(
            questModel.choices!.length,
            (index) => (thisUserQuestModel.value == null || thisUserQuestModel.value!.selection == null)
                ? false
                : thisUserQuestModel.value!.selection![0] == index).obs
        : List.generate(
            questModel.investAddresses!.length,
            (index) => (thisUserQuestModel.value == null || thisUserQuestModel.value!.selection == null)
                ? false
                : thisUserQuestModel.value!.selection![0] == index).obs;
  }

  void changeIndex(int index) {
    stockInfoIndex(index);
  }
  // Future<void> getQuest() async {
  //   tempQuestModel = await _firestoreService.getQuest();
  //   // update();
  // }

  Future getImages() async {
    for (int i = 0; i < questModel.investAddresses!.length; i++) {
      // imageUrl = await _storageService.downloadImageURL(questModel.investAddresses![i].logoUrl!);
      logoImage.add(Image.network(
        "https://storage.googleapis.com/ggook-5fb08.appspot.com/${questModel.investAddresses![i].logoUrl!}",
        fit: BoxFit.cover,
      ));
    }
  }

  Future<String> getLogoByIssueCode(String issueCode) async {
    return await _storageService.downloadImageURL('logo/$issueCode.png');
  }

  // toggle user 선택
  // selectMode에 따라 토글/다수선택/순위선정 함수가 필요
  toggleUserSelect(int index) {
    for (int i = 0; i < toggleList.length; i++) {
      toggleList[i] = false;
    }
    toggleList[index] = true;
  }

  reorderUserSelect(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      int temp = orderList[oldIndex];
      orderList.removeAt(oldIndex);
      orderList.insert(newIndex - 1, temp);
      print('new OrderList: $orderList');
    } else {
      int temp = orderList[oldIndex];
      orderList.removeAt(oldIndex);
      orderList.insert(newIndex, temp);
      print('new OrderList: $orderList');
    }
  }

  // userQuest에 user가 선택한 정답 업데이트하는 함수
  Future updateUserQuest() async {
    print('updating');
    // 조가비 체크

    // [2], [2,3], 이런식으로 넣게 됨.
    List<int> answers = [];
    for (int i = 0; i < toggleList.length; i++) {
      if (toggleList[i] == true) answers.add(i);
    }

    switch (questModel.selectMode) {
      case 'order':
        await _firestoreService.updateUserQuest(questModel, orderList);
        break;
      case 'updown_many':
        await _firestoreService.updateUserQuest(questModel, updownManyList);
        break;
      default:
        await _firestoreService.updateUserQuest(questModel, answers);
    }
    // questModel.selectMode == 'order'
    //     ? await _firestoreService.updateUserQuest(questModel, orderList)
    //     : await _firestoreService.updateUserQuest(questModel, answers);
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
}
