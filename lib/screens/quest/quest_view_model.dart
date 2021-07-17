import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/stock_model.dart';
import 'package:yachtOne/screens/chart/chart_view_model.dart';
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
  int stockInfoIndex = 0;
  // 타이머 1초마다 작동
  Timer? _everySecond;
  // 남은 시간 보여줌
  RxString timeToEnd = "".obs;
  DateTime now = DateTime.now();

  String? imageUrl;
  List logoImage = [];
  StockModel? stockModel;
  RxBool isLoading = false.obs;

  // init(QuestModel model) {
  //   questModel = model;
  //   // update();
  // }

  @override
  void onClose() {
    // 컨트롤러 없어질 때 타이머 끄기

    _everySecond!.cancel();
    super.onClose();
  }

  @override
  void onInit() async {
    isLoading(true);
    _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {
      print("questTimerTicking");
      now = DateTime.now();
      timeLeft();
    });

    // logo 이미지 가져오기
    await getImages();

    isLoading(false);
    update();
    super.onInit();
    // return
  }

  void changeIndex(int index) {
    stockInfoIndex = index;
    update();
  }
  // Future<void> getQuest() async {
  //   tempQuestModel = await _firestoreService.getQuest();
  //   // update();
  // }

  Future getImages() async {
    for (int i = 0; i < questModel.stockAddress.length; i++) {
      imageUrl = await _storageService
          .downloadImageURL(questModel.stockAddress[i].logoUrl);
      logoImage.add(Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        height: reactiveHeight(60),
        width: reactiveHeight(60),
      ));
    }
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
    Duration timeLeft = questModel.endDateTime.toDate().difference(now);
    timeToEnd(countDown(timeLeft));
    // return countDown(timeLeft);
  }
}
