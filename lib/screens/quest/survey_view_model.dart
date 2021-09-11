import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:yachtOne/models/survey_model.dart';

class SurveyViewModel extends GetxController {
  final List<SurveyQuestionPageModel> surveyQuestionPageModel;

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
}
