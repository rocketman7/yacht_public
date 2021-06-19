import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/size_config.dart';

class QuestViewModel extends GetxController {
  RxString timeToEnd = "".obs;
  DateTime now = DateTime.now();
  FirestoreService _firestoreService = FirestoreService();
  FirebaseStorageService _storageService = FirebaseStorageService();
  QuestModel? tempQuestModel;
  String? imageUrl;
  List logoImage = [];
  late bool isLoading;

  @override
  void onInit() async {
    isLoading = true;

    // getThisQuest();
    // update();

    await getQuest();
    Timer.periodic(Duration(seconds: 1), (timer) {
      now = DateTime.now();
      timeLeft();
    });
    await getImages();
    // getLogoImage(tempQuestModel!.logoUrl[0]);
    isLoading = false;
    update();
    super.onInit();
    // return
  }

  Future<void> getQuest() async {
    tempQuestModel = await _firestoreService.getQuest();
    // update();
  }

  Future getImages() async {
    for (int i = 0; i < tempQuestModel!.logoUrl!.length; i++) {
      imageUrl =
          await _storageService.downloadImageURL(tempQuestModel!.logoUrl![i]);
      logoImage.add(Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        height: getProportionateScreenHeight(60),
        width: getProportionateScreenHeight(60),
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
    Duration timeLeft = tempQuestModel!.endDateTime.toDate().difference(now);
    timeToEnd(countDown(timeLeft));
    // return countDown(timeLeft);
  }
}
