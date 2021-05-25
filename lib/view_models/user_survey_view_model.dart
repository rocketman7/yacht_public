import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/sharedPreferences_const.dart';

import 'package:yachtOne/models/user_survey_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import 'package:yachtOne/services/stateManage_service.dart';

import '../locator.dart';

class UserSurveyViewModel extends FutureViewModel {
  final DatabaseService? _databaseService = locator<DatabaseService>();
  final AuthService? _authService = locator<AuthService>();
  final StateManageService? _stateManageService = locator<StateManageService>();
  final SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();
  // tempModel 작업
  // UserSurveyModel tempModel;

  String? uid;
  BuildContext? context;
  UserSurveyViewModel(BuildContext context) {
    uid = _authService!.auth.currentUser!.uid;
    context = context;
  }

  // model에서 가져올 서베이 정보들
  int totalStep = 8;
  int currentStep = 0;
  bool proceed = false;
  List<String> steps = [];
  bool? firstSurvey;
  bool? hasDone;

  // String introTitle = "도와줘요 꾸욱 피플! \n2분 20초만요 :)";
  // String introDescription =
  //     "꾸욱은 더 재미있는 예측게임과 투자 정보를 제공하기 위해 대대적인 리뉴얼을 준비 중입니다. 오픈 베타에 참여해주신 꾸욱 유저분들의 소중한 의견이 필요해요.";
  // final UserSurveyModel tempModel =
  //     UserSurveyModel("title", "desp", tempQuestions);
  // static List<SurveyQuestionModel> tempQuestions = [
  //   SurveyQuestionModel(
  //       "Q1",
  //       [
  //         "긴 선지를 테스트해봅시다긴 선지를 테스트해봅시다긴 선지를 테스트해봅시다긴 선지를 테스트해봅시다긴 선지를 테스트해봅시다",
  //         "B",
  //         "C",
  //         "D"
  //       ],
  //       false,
  //       "기타의견"),
  //   SurveyQuestionModel("Q2", ["A", "B", "C"], true, "short"),
  //   SurveyQuestionModel("Q3", ["A", "B", "C", "D", "E"], true, "short"),
  //   SurveyQuestionModel("Q4", ["A", "B", "C", "D"], false, null),
  //   SurveyQuestionModel("Q5", [], false, "short"),
  // ];

  late UserSurveyModel userSurveyModel;

  // 페이지 로딩하면서 서베이 모델 가져오기
  Future getUserSurveyModel() async {
    setBusy(true);
    userSurveyModel = await (_databaseService!.getUserSurveyModel()
        as FutureOr<UserSurveyModel>);
    hasDone =
        await (_databaseService!.checkUserSurveyDone(uid) as FutureOr<bool?>);
    print(userSurveyModel.surveyQuestions);
    firstSurvey = await (_sharedPreferencesService!
        .getSharedPreferencesValue(firstSurveyKey, bool) as FutureOr<bool?>);
    print("hasDOne" + hasDone.toString());

    setBusy(false);
  }
  // List<Object> answers = List.generate(tempQuestions.length, (index) {
  //   if (tempQuestions[index].multipleChoice == true) {
  //     return List.generate(
  //         tempQuestions[index].answers.length, (answers) => false);
  //   } else {
  //     return 0;
  //   }
  // });

  // String question;
  // List<String> answers;
  // bool multipleChoice;
  // String shortAnswer;

  List<bool> multipleChoices = [];
  int? singleChoice;
  List<Map<String, dynamic>> userFinalAnswers = [];
  List<Map<String, dynamic>> shortAnswers = [];
  List<bool> selected = [];
  String? shortAnswer;

  toggleChoice(int questionNumber) {
    int i = 0;
    multipleChoices[questionNumber] = !multipleChoices[questionNumber];
    // selected[questionNumber] = !selected[questionNumber];
    multipleChoices.forEach((element) {
      if (element == true) {
        i += 1;
      }
      if (i > 0) {
        proceed = true;
      } else {
        proceed = false;
      }
      ;
    });
    print(multipleChoices);
    notifyListeners();
  }

  // 다음 버튼 눌렀을 때 step 이동
  toNextStep(int step) {
    // notifyListeners();
    // 다음 스텝 응답을 위한 empty data 자리를 만들어놓음
    generateNextAnswers(step);
    print(userFinalAnswers);
    notifyListeners();
  }

  // List<bool> 에서 true인 인덱스 추출해서 List로 만들기
  List<int> extractMultipleAnswer(List<bool> multi) {
    List<int> multiAnswerList = [];
    int i = 0;
    multi.forEach((element) {
      if (element == true) {
        multiAnswerList.add(i);
      }
      i += 1;
    });
    return multiAnswerList;
  }

  changeRadioValue(int? val) {
    singleChoice = val;
    notifyListeners();
  }

  generateNextAnswers(int step) {
    print(currentStep);
    // 주관식 있으면 추가
    if (shortAnswer != null) {
      shortAnswers.add({(currentStep - 1).toString(): shortAnswer});
      shortAnswer = null;
    }

    print(shortAnswers);
    if (currentStep >= 1 &&
        userSurveyModel.surveyQuestions[currentStep - 1].answers.length > 0) {
      if (userSurveyModel.surveyQuestions[currentStep - 1].multipleChoice ==
          true) {
        userFinalAnswers.add({
          (currentStep - 1).toString(): extractMultipleAnswer(multipleChoices)
        });
      } else {
        userFinalAnswers.add({(currentStep - 1).toString(): singleChoice});
        singleChoice = null;
      }
    }

    currentStep += step;
    print(currentStep);

    // 중복 선택 가능하면 List<bool> 생성
    if (currentStep <= userSurveyModel.surveyQuestions.length) {
      userSurveyModel.surveyQuestions[currentStep - 1].multipleChoice == true
          ? multipleChoices = List.generate(
              userSurveyModel.surveyQuestions[currentStep - 1].answers.length,
              (index) => false)
          : singleChoice = null;
    }
    // notifyListeners();
  }

  bool finalizingSurvey = false;
  Future finalizeSurvey(
    String? uid,
  ) async {
    finalizingSurvey = true;
    notifyListeners();
    print(uid);
    _sharedPreferencesService!.setSharedPreferencesValue(firstSurveyKey, true);
    await _databaseService!.updateUserItem(uid, 20);
    await _databaseService!
        .updateUserSurvey(uid, 'survey001', userFinalAnswers, shortAnswers);
    await _stateManageService!.userModelUpdate();
    // notifyListeners();
    // await notifyHomeView();
    finalizingSurvey = false;
    notifyListeners();
  }

  @override
  Future futureToRun() {
    return getUserSurveyModel();
    // TODO: implement futureToRun
    // throw UnimplementedError();
  }
}
