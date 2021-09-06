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
  List logoImage = [];
  String? uid;
  RxBool isLoading = false.obs;

  // 예측 최종 확정 중일 때 true로
  RxBool isSelectingSheetShowing = false.obs;
  // init(QuestModel model) {
  //   questModel = model;
  //   // update();
  // }
  // 이 위젯에 해당하는 userQuestModel을 확인하고 userQuestModel에 넣어준다
  final Rxn<UserQuestModel> userQuestModel = Rxn<UserQuestModel>();

  // toggle에 쓰일 bool list
  RxList<bool> toggleList = <bool>[].obs;

  @override
  void onClose() {
    // 컨트롤러 없어질 때 타이머 끄기

    _everySecond!.cancel();
    super.onClose();
  }

  @override
  void onInit() async {
    print('userquestmodel value check: ${userQuestModel.value}');
    // print(
    // 'userquestmodel selectDatetime value check: ${userQuestModel.value!.selectDateTime}');
    isLoading(true);
    _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {
      now = DateTime.now();
      timeLeft();
    });
    print('userquestmodelrx: $userQuestModelRx');
    if (userQuestModel.value == null) {
      userQuestModel((userQuestModelRx.where((i) => i.questId == questModel.questId)).first);
      print('userquest ${userQuestModel.value}');
    }
    userQuestModelRx.listen((value) {
      print('userQuestModel changed');
      print(value);
      if (value.isNotEmpty) {
        UserQuestModel thisUserQuestModel = value.where((i) => i.questId == questModel.questId).first;
        userQuestModel(thisUserQuestModel);
      }
    });
    syncUserSelect();

    // logo 이미지 가져오기
    await getImages();

    isLoading(false);
    update();
    super.onInit();
    // return
  }

  void syncUserSelect() {
    toggleList = questModel.selectMode == 'updown'
        ? List.generate(
            questModel.choices!.length,
            (index) => (userQuestModel.value == null || userQuestModel.value!.selection == null)
                ? false
                : userQuestModel.value!.selection![0] == index).obs
        : List.generate(
            questModel.investAddresses.length,
            (index) => (userQuestModel.value == null || userQuestModel.value!.selection == null)
                ? false
                : userQuestModel.value!.selection![0] == index).obs;
  }

  void changeIndex(int index) {
    stockInfoIndex(index);
  }
  // Future<void> getQuest() async {
  //   tempQuestModel = await _firestoreService.getQuest();
  //   // update();
  // }

  Future getImages() async {
    for (int i = 0; i < questModel.investAddresses.length; i++) {
      imageUrl = await _storageService.downloadImageURL(questModel.investAddresses[i].logoUrl!);
      logoImage.add(Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        height: reactiveHeight(60),
        width: reactiveHeight(60),
      ));
    }
  }

  // toggle user 선택
  // selectMode에 따라 토글/다수선택/순위선정 함수가 필요
  toggleUserSelect(int index) {
    for (int i = 0; i < toggleList.length; i++) {
      toggleList[i] = false;
    }
    toggleList[index] = true;
  }

  // userQuest에 user가 선택한 정답 업데이트하는 함수
  Future updateUserQuest() async {
    // [2], [2,3], 이런식으로 넣게 됨.
    List<num> answers = [];
    for (int i = 0; i < toggleList.length; i++) {
      if (toggleList[i] == true) answers.add(i);
    }
    print(answers);
    await _firestoreService.updateUserQuest(questModel, answers);
  }

  // Future<Image> getLogoImage(String imageName) async {
  //   imageUrl = await _storageService.downloadImageURL(imageName);
  //   logoImage = Image.network(
  //     imageUrl!,
  //     fit: BoxFit.cover,
  //     height: getProportionateScreenHeight(60),
  //     width: getProportionateScreenHeight(60),
  //   );
  //   print("logoimage is " + logoImage.toString());
  //   // precacheImage(logoImage.image, context);
  //   return logoImage;
  //   // update();
  // }

  // final QuestModel tempQuestModel = QuestModel(
  //     category: "one",
  //     title: "7월 1일 수익률이 더 높을 종목은?",
  //     subtitle: "7월 1일 수익률 대결",
  //     country: "KR",
  //     pointReward: 3,
  //     cashReward: 50000,
  //     exp: 300,
  //     candidates: [
  //       {"stocks": "005930"},
  //       {"stocks": "326030"}
  //     ],
  //     counts: [300, 450],
  //     results: [1, 0],
  //     startDateTime: DateTime(2021, 6, 12, 08, 50, 00),
  //     endDateTime: DateTime(2021, 6, 20, 08, 50),
  //     resultDateTime: DateTime(2021, 6, 14, 16, 00));

  // final DateTime now = DateTime.now();
  // Duration? timeLeft;

  void timeLeft() {
    Duration timeLeft = questModel.questEndDateTime.toDate().difference(now);
    timeToEnd(countDown(timeLeft));
    // return countDown(timeLeft);
  }
}
