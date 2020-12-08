import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:yachtOne/views/constants/size.dart';

import '../view_models/survey_view_model.dart';

class SurveyView extends StatelessWidget {
  final List<Color> colorList = [
    Color(0xFFFF74D5),
    Color(0xFF5BC2FD),
    Color(0xFFFF402B),
    Color(0xFFAE01FF),
    Color(0xFFFFA001),
    Color(0xFF069B75),
    Color(0xFF31B2F4),
    Color(0xFF5E5BFD),
    Color(0xFFFF0101),
    Color(0xFF0702FF),
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    deviceHeight = size.height;
    deviceWidth = size.width;
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
                            // cro: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: deviceHeight * .07,
                              ),
                              !(model.didBubbleSurvey)
                                  ? bubbleSurvey(model)
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
      mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // color: Colors.blue,
          // height: double.infinity,
          child: Text(
            '알고 있는 주식을 선택해주세요',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 28,
              color: Color(0xFF4F4F4F),
              fontFamily: 'AppleSDM',
              letterSpacing: -1.5,
            ),
          ),
        ),
        SizedBox(
          height: deviceHeight * .03,
        ),
        Container(
          width: deviceWidth,
          height: deviceHeight * .68,
          child: makeBubbleChoices(model),
        ),
        GestureDetector(
          onTap: () {
            model.bubbleSurveyRandomPick();
            // model.test();
          },
          child: Container(
              height: deviceHeight * .068,
              // width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF4CCF1E),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    // height: double.infinity,
                    // width: double.infinity,
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
      ],
    );
  }

  Widget makeBubbleChoices(SurveyViewModel model) {
    return Stack(
      children: [
        Positioned(
          top: deviceHeight * .11,
          left: 0,
          child: bubbleItem(model, 0),
        ),
        Positioned(
          top: deviceHeight * .05,
          left: deviceWidth * .3,
          child: bubbleItem(model, 1),
        ),
        Positioned(
          top: deviceHeight * .12,
          left: deviceWidth * .6,
          child: bubbleItem(model, 2),
        ),
        Positioned(
          top: deviceHeight * .33,
          child: bubbleItem(model, 3),
        ),
        Positioned(
          top: deviceHeight * .26,
          left: deviceWidth * .31,
          child: bubbleItem(model, 4),
        ),
        Positioned(
          top: deviceHeight * .46,
          left: deviceWidth * .51,
          child: bubbleItem(model, 5),
        ),
        Positioned(
          top: deviceHeight * .48,
          left: deviceWidth * .20,
          child: bubbleItem(model, 6),
        ),
        Positioned(
          top: deviceHeight * .3,
          left: deviceWidth * .6,
          child: bubbleItem(model, 7),
        ),
      ],
    );
  }

  Widget bubbleItem(SurveyViewModel model, int index) {
    double size = 100;
    return
        // child: GestureDetector(
        //   onTap: model.itemsChoiced[index]
        //       ? null
        //       : () {
        //           model.bubbleChoice(index);
        //         },
        //   child: model.itemsChoiced[index]
        //       ? Container()
        //       :
        InkResponse(
      onTap: model.itemsChoiced[index]
          ? null
          : () {
              model.bubbleChoice(index);
            },
      child: model.itemsChoiced[index]
          ? Container()
          : Container(
              width: deviceWidth * .28,
              height: deviceWidth * .28,
              decoration: BoxDecoration(
                color: colorList[index],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: deviceWidth * .25,
                  child: AutoSizeText(
                    model.randomStocks[index],
                    // "매우긴종목의테스트를",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: deviceWidth / 22,
                      color: Colors.white,
                      fontFamily: 'AppleSDM',
                    ),
                    maxLines: 2,
                  ),
                ),
              ),
            ),
    );

    // Container(
    //     height: 80,
    //     width: double.infinity,
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Container(
    //           alignment: Alignment.center,
    //           decoration: BoxDecoration(
    //             color: Color(0xFF979797),
    //             borderRadius: BorderRadius.all(Radius.circular(10)),
    //           ),
    //           height: double.infinity,
    //           width: double.infinity,
    //           child: Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: AutoSizeText(
    //               model.randomStocks[index],
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                 fontSize: 16,
    //                 color: Colors.white,
    //                 fontFamily: 'AppleSDM',
    //               ),
    //             ),
    //           )),
    //     )),
    // ));
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
                fontSize: 28,
                color: Color(0xFF4F4F4F),
                fontFamily: 'AppleSDM',
                letterSpacing: -1.5,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 32,
        ),
        Flexible(flex: 7, child: makeChoices(model)),
        Flexible(flex: 1, child: SizedBox())
      ],
    );
  }

  //Flexible 등 위해서 위 아래처럼 잘게 쪼개놓음..
  Widget makeChoices(SurveyViewModel model) {
    return Container(
      // color: Colors.blue,
      height: deviceHeight * .8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: choices(model),
      ),
    );
  }

  List<Widget> choices(SurveyViewModel model) {
    List<Widget> result = [];

    for (int i = 0;
        i < model.basicSurveys['choices'][model.surveyCurrentStep].length;
        i++) {
      result.add(Flexible(
          flex: 1,
          child: InkResponse(
            onTap: () {
              model.surveyStepPlus(i);
            },
            child: Container(
                height: deviceHeight * .15,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: colorList[Random().nextInt(8)].withOpacity(.95),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      // height: double.infinity,
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
