import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/view_models/user_survey_view_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserSurveyView extends StatefulWidget {
  // final Function notifyHomeView;
  // UserSurveyView(this.notifyHomeView);
  @override
  _UserSurveyViewState createState() => _UserSurveyViewState();
}

class _UserSurveyViewState extends State<UserSurveyView> {
  final TextEditingController _controller = TextEditingController();
  DateTime? currentBackPressTime;
  Future<bool> _onWillPop() async {
    if (currentBackPressTime == null ||
        DateTime.now().difference(currentBackPressTime!) >
            Duration(seconds: 2)) {
      currentBackPressTime = DateTime.now();
      Fluttertoast.showToast(msg: "뒤로 가기를 다시 누르면 앱이 종료됩니다");
      return Future.value(false);
      // return null;
    } else {
      print("TURN OFF");
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserSurveyViewModel>.reactive(
        viewModelBuilder: () => UserSurveyViewModel(context),
        builder: (context, model, child) {
          // Function notifyHomeView = widget.notifyHomeView;
          return model.isBusy
              ? Container(
                  color: Color(0xFF292929),
                )
              : model.hasDone == true
                  ? Scaffold(
                      backgroundColor: Color(0xFF292929),
                      body: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 40),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: Text("이미 설문에 참여했습니다. 감사합니다.",
                                    style: TextStyle(
                                        color: Color(0xFF1EC8CF),
                                        fontSize: 30,
                                        fontFamily: 'AppleSDEB')),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);

                                  // model.toNextStep(1);
                                  // model.generateNextAnswers();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  minimumSize: Size(
                                      double.maxFinite, double.minPositive),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  primary: Color(0xFFcf4d1e),
                                  onPrimary: Color(0xFF1EC8CF),
                                ),
                                child: Text("나가기",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontFamily: 'AppleSDB',
                                        height: 1)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Scaffold(
                      // resizeToAvoidBottomInset: false,
                      backgroundColor: Color(0xFF292929),
                      body: WillPopScope(
                        onWillPop: _onWillPop,
                        child: SafeArea(
                          child: Padding(
                            padding:
                                // EdgeInsets.symmetric(
                                //     vertical: 48.0, horizontal: 32.0),
                                EdgeInsets.fromLTRB(36, 0, 36, 32),
                            // Step이 0이면 intro 화면먼저
                            child: model.currentStep == 0
                                ? buildSurveyIntro(model)
                                : model.currentStep ==
                                        model.userSurveyModel.surveyQuestions
                                                .length +
                                            1
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                            SizedBox(
                                              height: 120,
                                            ),
                                            Text(model.userSurveyModel.thank!,
                                                style: TextStyle(
                                                    color: Color(0xFF1EC8CF),
                                                    fontSize: 30,
                                                    fontFamily: 'AppleSDEB')),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                                model.userSurveyModel
                                                    .endingStatement!,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontFamily: 'AppleSDM')),
                                            SizedBox(
                                              height: 80,
                                            ),
                                            Row(
                                              children: [
                                                // Flexible(
                                                //   flex: 1,
                                                //   child: ElevatedButton(
                                                //     onPressed: () {
                                                //       print(model.currentStep);
                                                //       model.toNextStep(-1);
                                                //     },
                                                //     style: ElevatedButton.styleFrom(
                                                //       padding:
                                                //           EdgeInsets.symmetric(vertical: 12),
                                                //       minimumSize: Size(
                                                //           double.maxFinite, double.minPositive),
                                                //       shape: RoundedRectangleBorder(
                                                //         borderRadius:
                                                //             BorderRadius.circular(30.0),
                                                //       ),
                                                //       primary: Color(0xFFcf4d1e),
                                                //       onPrimary: Color(0xFF1EC8CF),
                                                //     ),
                                                //     child: Text("이전",
                                                //         style: TextStyle(
                                                //             fontSize: 22,
                                                //             fontFamily: 'AppleSDB',
                                                //             height: 1)),
                                                //   ),
                                                // ),
                                                // SizedBox(
                                                //   width: 20,
                                                // ),
                                                Flexible(
                                                  flex: 2,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      print(model
                                                          .finalizingSurvey);
                                                      if (model
                                                              .finalizingSurvey ==
                                                          true) {
                                                      } else {
                                                        await model
                                                            .finalizeSurvey(
                                                          model.uid,
                                                        );

                                                        Navigator.pop(context);
                                                      }
                                                      // model.toNextStep(1);
                                                      // model.generateNextAnswers();
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12),
                                                      minimumSize: Size(
                                                          double.maxFinite,
                                                          double.minPositive),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                      primary:
                                                          Color(0xFFcf4d1e),
                                                      onPrimary:
                                                          Color(0xFF1EC8CF),
                                                    ),
                                                    child: model
                                                            .finalizingSurvey
                                                        ? Container(
                                                            height: 22,
                                                            width: 22,
                                                            child:
                                                                CircularProgressIndicator(
                                                              backgroundColor:
                                                                  Color(
                                                                      0xFF1EC8CF),
                                                            ))
                                                        : Text("나가기",
                                                            style: TextStyle(
                                                                fontSize: 22,
                                                                fontFamily:
                                                                    'AppleSDB',
                                                                height: 1)),
                                                  ),
                                                )
                                              ],
                                            )
                                          ])
                                    // 서베이 시작
                                    : LayoutBuilder(
                                        builder: (context, constraint) {
                                        // bool exit = false;
                                        BuildContext dialogContext;
                                        return SingleChildScrollView(
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minHeight:
                                                    constraint.maxHeight),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: TextButton(
                                                        onPressed: () async {
                                                          var result =
                                                              await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    dialogContext =
                                                                        context;
                                                                    return MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            textScaleFactor:
                                                                                1.0),
                                                                        child:
                                                                            Dialog(
                                                                          shape:
                                                                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                          child: Container(
                                                                              height: 160,
                                                                              color: Color(0xFF292929),
                                                                              //     .blue,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(12.0),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    Text("설문이 진행 중입니다. 꾸욱 아이템 20개와 상금 주식 보상 기회를 포기하시겠습니까?", style: TextStyle(fontSize: 20, fontFamily: 'AppleSDM', color: Colors.white), textAlign: TextAlign.center),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                      children: [
                                                                                        TextButton(
                                                                                          onPressed: () async {
                                                                                            // int count = 0;
                                                                                            // dispose();
                                                                                            // Navigator.of(dialogContext).pop();
                                                                                            Navigator.of(dialogContext, rootNavigator: true).pop(true);
                                                                                            // context = context;

                                                                                            // await Future.delayed(Duration(seconds: 1));
                                                                                            // Navigator.of(dialogContext).pop();
                                                                                            // Navigator.of(context).pop();
                                                                                            // exit = true;
                                                                                            // model.notifyListeners();
                                                                                            // Navigator.popUntil(context, ModalRoute.withName('voteComment'));
                                                                                          },
                                                                                          child: Text(
                                                                                            "설문 나가기",
                                                                                            style: TextStyle(color: Colors.grey, fontFamily: 'AppleSDM', fontSize: 16),
                                                                                          ),
                                                                                        ),
                                                                                        TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(context).pop();
                                                                                          },
                                                                                          child: Text(
                                                                                            "설문 계속 하기",
                                                                                            style: TextStyle(color: Colors.blue, fontFamily: 'AppleSDM', fontSize: 16),
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              )),
                                                                        ));
                                                                  });
                                                          if (result == true)
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          // Navigator.of(context)
                                                          //     .pop();
                                                        },
                                                        child: Text("나가기",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blueGrey)),
                                                      ),
                                                      height: 32,
                                                    ),
                                                    Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: List.generate(
                                                          model
                                                              .userSurveyModel
                                                              .surveyQuestions
                                                              .length,
                                                          (index) => Flexible(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            10)),
                                                                    color: index >=
                                                                            model
                                                                                .currentStep
                                                                        ? Colors
                                                                            .white
                                                                        : Color(
                                                                            0xFFcf4d1e)),
                                                                // constraints: BoxConstraints.expand(),

                                                                height: 10,
                                                                // width: 10,
                                                                // child: Text(
                                                                //   "ProgressBAR",
                                                                //   style: TextStyle(color: Colors.white),
                                                                // ),
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                        model
                                                            .userSurveyModel
                                                            .surveyQuestions[
                                                                model.currentStep -
                                                                    1]
                                                            .question
                                                            .toString()
                                                            .replaceAll(
                                                                "\\n", "\n"),
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xFF1EC8CF),
                                                            fontSize: 26,
                                                            fontFamily:
                                                                'AppleSDEB')),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Column(
                                                        children: List.generate(
                                                            model
                                                                .userSurveyModel
                                                                .surveyQuestions[
                                                                    model.currentStep -
                                                                        1]
                                                                .answers
                                                                .length,
                                                            (index) {
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10),
                                                        child: Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                    minHeight:
                                                                        50),
                                                            decoration: model.userSurveyModel.surveyQuestions[model.currentStep - 1].multipleChoice == false
                                                                ? BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            40)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white,
                                                                        width:
                                                                            0.2))
                                                                : BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white,
                                                                        width:
                                                                            0.2)),
                                                            child:
                                                                model.userSurveyModel.surveyQuestions[model.currentStep - 1]
                                                                            .multipleChoice ==
                                                                        false
                                                                    ? ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(40)),
                                                                        child:
                                                                            RadioListTile(
                                                                          selectedTileColor:
                                                                              Colors.red,
                                                                          activeColor:
                                                                              Color(0xFF1EC8CF),
                                                                          value:
                                                                              index,
                                                                          selected: index == model.singleChoice
                                                                              ? true
                                                                              : false,
                                                                          groupValue:
                                                                              model.singleChoice,
                                                                          onChanged:
                                                                              (dynamic val) {
                                                                            model.changeRadioValue(val);
                                                                            setState(() {
                                                                              model.proceed = true;
                                                                            });
                                                                          },
                                                                          title: AutoSizeText(
                                                                              model.userSurveyModel.surveyQuestions[model.currentStep - 1].answers[index].toString(),
                                                                              maxLines: 3,
                                                                              minFontSize: 14,
                                                                              style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'AppleSDM')),
                                                                        ),
                                                                      )
                                                                    : Theme(
                                                                        data:
                                                                            ThemeData(
                                                                          unselectedWidgetColor:
                                                                              Colors.grey, // Your color
                                                                        ),
                                                                        child:
                                                                            CheckboxListTile(
                                                                          contentPadding:
                                                                              EdgeInsets.all(0),
                                                                          selectedTileColor:
                                                                              Colors.red,
                                                                          // Color(0xff1ec8cf),
                                                                          // tileColor: Colors.red,
                                                                          activeColor:
                                                                              Color(0xFF1EC8CF),
                                                                          controlAffinity:
                                                                              ListTileControlAffinity.leading,
                                                                          selected:
                                                                              model.multipleChoices[index],
                                                                          value:
                                                                              model.multipleChoices[index],
                                                                          onChanged:
                                                                              (bool? val) {
                                                                            model.toggleChoice(index);
                                                                          },
                                                                          title: AutoSizeText(
                                                                              model.userSurveyModel.surveyQuestions[model.currentStep - 1].answers[index].toString(),
                                                                              minFontSize: 14,
                                                                              style: TextStyle(color: Colors.white, fontSize: 16.sp, fontFamily: 'AppleSDM')),
                                                                        ),
                                                                      )),
                                                      );
                                                    })),
                                                    model
                                                                .userSurveyModel
                                                                .surveyQuestions[
                                                                    model.currentStep -
                                                                        1]
                                                                .shortAnswer ==
                                                            null
                                                        ? Container()
                                                        : Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        0),
                                                            // height: 50,
                                                            constraints:
                                                                BoxConstraints(
                                                              minHeight: 50,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width:
                                                                        0.2)),
                                                            child:
                                                                TextFormField(
                                                              // initialValue: "",
                                                              maxLines: null,
                                                              maxLength: 700,
                                                              controller:
                                                                  _controller,
                                                              onChanged: (val) {
                                                                if (val.length >
                                                                        0 &&
                                                                    model
                                                                            .userSurveyModel
                                                                            .surveyQuestions[model.currentStep -
                                                                                1]
                                                                            .answers
                                                                            .length ==
                                                                        0) {
                                                                  setState(() {
                                                                    model.proceed =
                                                                        true;
                                                                  });
                                                                }
                                                                if (val.length ==
                                                                        0 &&
                                                                    model
                                                                            .userSurveyModel
                                                                            .surveyQuestions[model.currentStep -
                                                                                1]
                                                                            .answers
                                                                            .length ==
                                                                        0) {
                                                                  setState(() {
                                                                    model.proceed =
                                                                        false;
                                                                  });
                                                                }
                                                              },
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  helperStyle:
                                                                      TextStyle(
                                                                          color: Colors
                                                                              .grey),
                                                                  isDense: true,
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey),
                                                                  hintText: model
                                                                      .userSurveyModel
                                                                      .surveyQuestions[
                                                                          model.currentStep -
                                                                              1]
                                                                      .shortAnswer),
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    // Flexible(
                                                    //   flex: 1,
                                                    //   child: ElevatedButton(
                                                    //     onPressed: () {
                                                    //       print(model.currentStep);
                                                    //       model.toNextStep(-1);
                                                    //     },
                                                    //     style: ElevatedButton.styleFrom(
                                                    //       padding:
                                                    //           EdgeInsets.symmetric(vertical: 12),
                                                    //       minimumSize: Size(
                                                    //           double.maxFinite, double.minPositive),
                                                    //       shape: RoundedRectangleBorder(
                                                    //         borderRadius:
                                                    //             BorderRadius.circular(30.0),
                                                    //       ),
                                                    //       primary: Color(0xFFcf4d1e),
                                                    //       onPrimary: Color(0xFF1EC8CF),
                                                    //     ),
                                                    //     child: Text("이전",
                                                    //         style: TextStyle(
                                                    //             fontSize: 22,
                                                    //             fontFamily: 'AppleSDB',
                                                    //             height: 1)),
                                                    //   ),
                                                    // ),
                                                    // SizedBox(
                                                    //   width: 20,
                                                    // ),
                                                    Flexible(
                                                      flex: 2,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          if (model.proceed ==
                                                              true) {
                                                            if (_controller.text
                                                                    .length >
                                                                0) {
                                                              model.shortAnswer =
                                                                  _controller
                                                                      .text;
                                                              model
                                                                  .notifyListeners();
                                                            }
                                                            model.toNextStep(1);
                                                            setState(() {
                                                              model.proceed =
                                                                  false;
                                                              _controller
                                                                  .clear();
                                                            });
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 12),
                                                          minimumSize: Size(
                                                              double.maxFinite,
                                                              double
                                                                  .minPositive),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                          ),
                                                          primary:
                                                              model.proceed ==
                                                                      true
                                                                  ? Color(
                                                                      0xFFcf4d1e)
                                                                  : Colors.grey,
                                                          onPrimary:
                                                              Color(0xFF1EC8CF),
                                                        ),
                                                        child: Text("다음",
                                                            style: TextStyle(
                                                                fontSize: 22,
                                                                fontFamily:
                                                                    'AppleSDB',
                                                                height: 1)),
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                          ),
                        ),
                      ));
        });
  }

  Column buildSurveyIntro(UserSurveyViewModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("나가기", style: TextStyle(color: Colors.blueGrey)),
          ),
          height: 32,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
            ),
            Text(model.userSurveyModel.title!.replaceAll("\\n", "\n"),
                style: TextStyle(
                    color: Color(0xFF1EC8CF),
                    fontSize: 30,
                    fontFamily: 'AppleSDEB')),
            SizedBox(
              height: 10,
            ),
            Text(model.userSurveyModel.description!.replaceAll("\\n", "\n"),
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontFamily: 'AppleSDM')),
            SizedBox(
              height: 80,
            ),
            ElevatedButton(
              onPressed: () {
                print(model.currentStep);
                model.toNextStep(1);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
                minimumSize: Size(double.maxFinite, double.minPositive),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                primary: Color(0xFFcf4d1e),
                onPrimary: Color(0xFF1EC8CF),
              ),
              child: Text("설문 참여하기",
                  style: TextStyle(
                      fontSize: 22, fontFamily: 'AppleSDB', height: 1)),
            )
          ],
        ),
      ],
    );
  }
}
