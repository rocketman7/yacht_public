import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../view_models/survey_view_model.dart';

class SurveyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
    return ViewModelBuilder<SurveyViewModel>.reactive(
      viewModelBuilder: () => SurveyViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: model.hasError
              ? Container(
                  child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                )
              : model.isBusy
                  ? Container()
                  : WillPopScope(
                      onWillPop: () async {
                        _navigatorKey.currentState.maybePop();
                        return false;
                      },
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              !(model.didBubbleSurvey)
                                  ? Flexible(
                                      flex: 1,
                                      child: bubbleSurvey(model),
                                    )
                                  : Flexible(
                                      flex: 1,
                                      child: model.surveyCurrentStep <=
                                              model.surveyTotalStep
                                          ? makeSurvey(model)
                                          : Container(),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
        );
      },
    );
  }

  //주식 고르기 서베이
  Widget bubbleSurvey(SurveyViewModel model) {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            height: double.infinity,
            child: AutoSizeText('알고 있는 주식을 선택해주세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 40,
                    color: Color(0xFFFFA001),
                    fontFamily: 'AppleSDB')),
          ),
        ),
        SizedBox(
          height: 64,
        ),
        Flexible(
          flex: 5,
          child: makeBubbleChoices(model),
        )
      ],
    );
  }

  Widget makeBubbleChoices(SurveyViewModel model) {
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Row(
            children: [bubbleItem(model, 0), bubbleItem(model, 1)],
          ),
        ),
        Flexible(
          flex: 2,
          child: Row(
            children: [bubbleItem(model, 2), bubbleItem(model, 3)],
          ),
        ),
        Flexible(
          flex: 2,
          child: Row(
            children: [bubbleItem(model, 4), bubbleItem(model, 5)],
          ),
        ),
        Flexible(
          flex: 2,
          child: Row(
            children: [bubbleItem(model, 6), bubbleItem(model, 7)],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              model.bubbleSurveyRandomPick();
              // model.test();
            },
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CCF1E),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      height: double.infinity,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          model.allChoice ? '다음' : '더 이상 모르겠어요',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'AppleSDM',
                          ),
                        ),
                      )),
                )),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }

  Widget bubbleItem(SurveyViewModel model, int index) {
    return Flexible(
        flex: 1,
        child: GestureDetector(
          onTap: model.itemsChoiced[index]
              ? null
              : () {
                  model.bubbleChoice(index);
                },
          child: model.itemsChoiced[index]
              ? Container()
              : Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Color(0xFF979797),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        height: double.infinity,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            model.randomStocks[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'AppleSDM',
                            ),
                          ),
                        )),
                  )),
        ));
  }

  //basic 서베이
  Widget makeSurvey(SurveyViewModel model) {
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: Container(
            //이렇게 최대 height로 해야 Text크기에 구애받지않고, flex를 제대로 활용
            height: double.infinity,
            child: AutoSizeText(
              model.basicSurveys['title'][model.surveyCurrentStep],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Color(0xFFFFA001),
                fontFamily: 'AppleSDB',
              ),
            ),
          ),
        ),
        SizedBox(
          height: 64,
        ),
        Flexible(flex: 5, child: makeChoices(model)),
      ],
    );
  }

  //Flexible 등 위해서 위 아래처럼 잘게 쪼개놓음..
  Widget makeChoices(SurveyViewModel model) {
    return Column(children: choices(model));
  }

  List<Widget> choices(SurveyViewModel model) {
    List<Widget> result = [];

    for (int i = 0;
        i < model.basicSurveys['choices'][model.surveyCurrentStep].length;
        i++) {
      result.add(Flexible(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              model.surveyStepPlus(i);
            },
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFF979797),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      height: double.infinity,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AutoSizeText(
                          model.basicSurveys['choices'][model.surveyCurrentStep]
                              [i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'AppleSDM',
                          ),
                        ),
                      )),
                )),
          )));
    }

    return result;
  }
}
