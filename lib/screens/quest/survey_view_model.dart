import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';

import 'package:yachtOne/models/survey_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';

import '../../locator.dart';

class SurveyViewModel extends GetxController {
  final List<SurveyQuestionModel> surveyQuestionPageModel;
  final FirebaseStorageService _storageService = locator<FirebaseStorageService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  SurveyViewModel({
    required this.surveyQuestionPageModel,
  });

  RxList answerList = [].obs;
  RxList userAnswerList = [].obs;

  RxBool isUpdating = false.obs;

  @override
  void onInit() {
    isUpdating.listen((value) {
      print(value);
    });
    // TODO: implement onInit
    makeAnswerList();

    super.onInit();
  }

  void makeAnswerList() {
    surveyQuestionPageModel.forEach((element) {
      if (element.answersId != null) {
        // List thisQuestionAnswer = List.generate(element.answers!.length, (index) {
        switch (element.answerType) {
          case "pickOne":
            answerList.add(null);
            break;
          case "pickMany":
            answerList.add([]);
            break;

          case "sentence":
            answerList.add("");
            break;

          case "pickManyCircles":
            answerList.add([]);
            break;

          default:
            answerList.add(null);
        }
        // }
        // );
        // answerList.add(thisQuestionAnswer);
        // userAnswerList.add(0);
      }
    });
    print(answerList);
  }

  Future<String> getResultImageAddress(String resultMapping) async {
    return await _storageService.downloadImageURL(resultMapping);
  }

  Future updateUserSurvey(QuestModel questModel) async {
    Map<String, dynamic> surveyUserAnswers = {};
    for (int i = 0; i < answerList.length; i++) {
      surveyUserAnswers[i.toString()] = answerList[i];
    }

    await _firestoreService.updateUserSurvey(questModel, surveyUserAnswers);
  }

  Future updateQuestParticipationReward(QuestModel questModel) async {
    await _firestoreService.updateQuestParticipationReward(questModel);
  }
}
