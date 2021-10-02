import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:yachtOne/models/survey_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/quest/survey_view_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/widgets/loading_container.dart';

class SurveyView extends GetView<SurveyViewModel> {
  SurveyView({Key? key}) : super(key: key);

  QuestModel questModel = Get.arguments;
  PageController pageController = PageController(initialPage: 0);

  @override
  // TODO: implement controller
  SurveyViewModel get controller => Get.put(SurveyViewModel(surveyQuestionPageModel: questModel.surveys!));

  @override
  // TODO: implement controller
  // SurveyViewModel get controller => Get.put(SurveyViewModel());
  RxInt pageNumber = 0.obs;
  RxInt scoreSum = 0.obs;

  @override
  Widget build(BuildContext context) {
    List<Widget> surveyPages = List.generate(
      questModel.surveys!.length,
      (index) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: primaryPaddingSize,
          ),
          (questModel.surveys![index].pageType == 'quizResult')
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Text(
                    questModel.surveys![index].question.replaceAll('\\n', '\n'),
                    style: surveyTitle,
                  ),
                ),
          (questModel.surveys![index].pageType == 'quizResult')
              ? Container()
              : SizedBox(
                  height: correctHeight(26.w, surveyTitle.fontSize, 0.0),
                ),
          (questModel.surveys![index].pageType == 'quizResult')
              ? Expanded(
                  child: Obx(
                    () => FutureBuilder<String>(
                        future: controller.getResultImageAddress(
                            questModel.surveys![index].resultPictureMapping![scoreSum.toString()]),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              // color: Colors.blue,
                              // child: Text(scoreSum.value.toString()),
                              child: Center(
                                child: Image.network(
                                  snapshot.data!,
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            );
                          } else {
                            return Container();
                            // return LoadingContainer(height: double.infinity, width: double.infinity, radius: 0);
                          }
                        }),
                  ),
                )
              : Expanded(
                  child: ListView(children: [
                    if (questModel.surveys![index].answers != null) ...{
                      // 선지가 있고
                      if (questModel.surveys![index].answerType == 'pickOne') ...{
                        // 택1인 경우
                        ...List.generate(questModel.surveys![index].answers!.length, (answerIndex) {
                          return Column(
                            children: [
                              if (answerIndex == 0)
                                SizedBox(
                                  height: 20.w,
                                  // color: yachtBlack.withOpacity(.4),
                                ),
                              GestureDetector(
                                onTap: () async {
                                  HapticFeedback.lightImpact();
                                  controller.answerList[questModel.surveys![index].answersId!] = answerIndex;

                                  if (questModel.surveys![pageController.page!.round()].pageType == 'quiz') {
                                    // 유저가 지금 페이지 질문에 응답한 답
                                    int userAnswerToThisPage = controller
                                        .answerList[questModel.surveys![pageController.page!.round()].answersId!];
                                    print(userAnswerToThisPage);
                                    print(questModel.surveys![pageController.page!.round()].rightAnswer);
                                    if (userAnswerToThisPage ==
                                        questModel.surveys![pageController.page!.round()].rightAnswer)
                                      scoreSum(
                                          scoreSum.value += questModel.surveys![pageController.page!.round()].score!);
                                  }

                                  controller.update();
                                  Future.delayed(Duration(milliseconds: 350)).then((value) {
                                    print(controller.answerList);
                                    if (questModel.surveys![pageController.page!.round()].redirect ?? false) {
                                      // 유저가 지금 페이지 질문에 응답한 답
                                      int userAnswerToThisPage = controller
                                          .answerList[questModel.surveys![pageController.page!.round()].answersId!];
                                      print('userAnswerToThisPage: $userAnswerToThisPage');
                                      // redirect 해야하는 answerId
                                      print(questModel.surveys![pageController.page!.round()]);
                                      int answerIdRedirectTo = questModel.surveys![pageController.page!.round()]
                                          .redirectQuestionIndex![userAnswerToThisPage];
                                      print('answerIdRedirectTo: $answerIdRedirectTo');
                                      int pageNumberToGo = questModel.surveys!
                                          .indexWhere((element) => element.answersId == answerIdRedirectTo);

                                      pageController.jumpToPage(pageNumberToGo);

                                      //  (duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                    } else {
                                      pageController.nextPage(
                                          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                    }
                                  });
                                },
                                child: Container(
                                  // clipBehavior: Clip.hardEdge,
                                  child: GetBuilder<SurveyViewModel>(builder: (controller) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 28.w),
                                      child: AnimatedContainer(
                                          duration: Duration(milliseconds: 300),
                                          height: 56.w,
                                          decoration: BoxDecoration(
                                              color: controller.answerList[questModel.surveys![index].answersId!] ==
                                                      answerIndex
                                                  ? yachtViolet
                                                  : white,
                                              borderRadius: BorderRadius.circular(12.w),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: yachtShadow,
                                                  blurRadius: 8.w,
                                                  spreadRadius: 1.w,
                                                )
                                              ]),
                                          padding: primaryHorizontalPadding,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  questModel.surveys![index].answers![answerIndex],
                                                  style: surveySelection.copyWith(
                                                      color: controller
                                                                  .answerList[questModel.surveys![index].answersId!] ==
                                                              answerIndex
                                                          ? buttonNormal
                                                          : surveySelection.color),
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ],
                                          )),
                                    );
                                  }),
                                ),
                              ),
                              SizedBox(
                                height: 14.w,
                              ),
                            ],
                          );
                        }),
                      } else if (questModel.surveys![index].answerType == 'pickManyCircles') ...{
                        Padding(
                            padding: primaryHorizontalPadding,
                            child: Wrap(
                              clipBehavior: Clip.none,
                              spacing: 12.w,
                              runSpacing: 12.w,
                              alignment: WrapAlignment.center,
                              children: List.generate(
                                  questModel.surveys![index].answers!.length,
                                  (answerIndex) => GetBuilder<SurveyViewModel>(builder: (controller) {
                                        return GestureDetector(
                                          onTap: () {
                                            HapticFeedback.lightImpact();
                                            controller.answerList[questModel.surveys![index].answersId!]
                                                    .contains(answerIndex)
                                                ? controller.answerList[questModel.surveys![index].answersId!]
                                                    .remove(answerIndex)
                                                : controller.answerList[questModel.surveys![index].answersId!]
                                                    .add(answerIndex);
                                            controller.update();
                                            print(controller.answerList);
                                          },
                                          child: AnimatedContainer(
                                            duration: Duration(milliseconds: 300),
                                            height: 80.w,
                                            width: 80.w,
                                            clipBehavior: Clip.hardEdge,
                                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: controller.answerList[questModel.surveys![index].answersId!]
                                                      .contains(answerIndex)
                                                  ? yachtViolet
                                                  : buttonNormal,
                                            ),
                                            child: Center(
                                              child: Text(
                                                questModel.surveys![index].answers![answerIndex],
                                                style: controller.answerList[questModel.surveys![index].answersId!]
                                                        .contains(answerIndex)
                                                    ? pickManyCircleName.copyWith(color: buttonNormal)
                                                    : pickManyCircleName,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                        );
                                      })),
                            )),
                      }
                    }
                  ]),
                )
        ],
      ),
    );

    pageController.addListener(() {
      pageNumber(pageController.page!.round());
    });

    return Scaffold(
        backgroundColor: white,
        body: SafeArea(
          child: GetBuilder<SurveyViewModel>(
            init: SurveyViewModel(surveyQuestionPageModel: questModel.surveys!),
            builder: (controller) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Container(
                    width: double.infinity,
                    height: 60.w,
                    // color: Colors.blue[50],
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: LayoutBuilder(builder: (_, constraints) {
                            return Stack(
                              children: [
                                Container(
                                  height: 20.w,
                                  // width: 200,
                                  decoration: BoxDecoration(
                                    color: buttonNormal,
                                    borderRadius: BorderRadius.circular(34.w),
                                  ),
                                ),
                                Obx(
                                  () => Container(
                                    width: (pageNumber.value / (surveyPages.length - 1)) * constraints.maxWidth,
                                    height: 20.w,
                                    decoration: BoxDecoration(
                                      color: yachtViolet,
                                      borderRadius: BorderRadius.circular(34.w),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        SizedBox(width: 30.w),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("나중에 하기"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    onPageChanged: (index) {},
                    physics: NeverScrollableScrollPhysics(),
                    controller: pageController,
                    children: surveyPages,
                  ),
                ),

                // Container(
                //   height: 300,
                //   width: 300,
                //   child: PlayOneShotAnimation(),
                // ),
                Container(
                  clipBehavior: Clip.none,
                  color: Colors.transparent,
                  height: 26.w,
                ),

                Obx(
                  () => Padding(
                      padding: EdgeInsets.fromLTRB(28.w, 0.0, 28.w, 28.w),
                      child: pageNumber.value == 0
                          ? InkWell(
                              onTap: () {
                                if (pageController.hasClients) print(pageController.page!.round());

                                pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                              },
                              child: textContainerButtonWithOptions(
                                height: 56.w,
                                text: "시작하기",
                                isDarkBackground: true,
                              ),
                            )
                          : questModel.surveys![pageController.page!.round()].pageType == 'quizResult'
                              ? Column(
                                  children: [
                                    // Row(children: [
                                    //   // InkWell(
                                    //   //   onTap: () {
                                    //   //     pageController.previousPage(
                                    //   //         duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                    //   //   },
                                    //   //   child: textContainerButtonWithOptions(
                                    //   //       height: 56.w,
                                    //   //       text: "이전",
                                    //   //       isDarkBackground: false,
                                    //   //       padding: EdgeInsets.symmetric(horizontal: 32.w)),
                                    //   // ),
                                    //   // SizedBox(width: 10.w),
                                    //   Expanded(
                                    //     child: InkWell(
                                    //       onTap: () async {
                                    //         // if (questModel.surveys![pageNumber.value].answerType != 'none') {
                                    //         //   controller.userAnswerList.replaceRange(
                                    //         //       questModel.surveys![pageNumber.value].answersId!,
                                    //         //       questModel.surveys![pageNumber.value].answersId! + 2,
                                    //         //       controller.answerList[questModel.surveys![pageNumber.value].answersId!]);
                                    //         // }

                                    //         print(controller.answerList);

                                    //         if (questModel.surveys![pageController.page!.round()].redirect ?? false) {
                                    //           // 유저가 지금 페이지 질문에 응답한 답
                                    //           int userAnswerToThisPage = controller.answerList[
                                    //               questModel.surveys![pageController.page!.round()].answersId!];
                                    //           print('userAnswerToThisPage: $userAnswerToThisPage');
                                    //           // redirect 해야하는 answerId
                                    //           print(questModel.surveys![pageController.page!.round()]);
                                    //           int answerIdRedirectTo = questModel.surveys![pageController.page!.round()]
                                    //               .redirectQuestionIndex![userAnswerToThisPage];
                                    //           print('answerIdRedirectTo: $answerIdRedirectTo');
                                    //           int pageNumberToGo = questModel.surveys!
                                    //               .indexWhere((element) => element.answersId == answerIdRedirectTo);

                                    //           pageController.jumpToPage(pageNumberToGo);

                                    //           //  (duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                    //         } else {
                                    //           pageController.nextPage(
                                    //               duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                    //         }
                                    //       },
                                    //       child: textContainerButtonWithOptions(
                                    //         fontSize: 18.w,
                                    //         height: 56.w,
                                    //         text:
                                    //             questModel.surveys![pageController.page!.round()].instruction ?? "공유하기",
                                    //         isDarkBackground: false,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ]),
                                    // SizedBox(height: 14.w),
                                    Row(children: [
                                      // InkWell(
                                      //   onTap: () {
                                      //     pageController.previousPage(
                                      //         duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                      //   },
                                      //   child: textContainerButtonWithOptions(
                                      //       height: 56.w,
                                      //       text: "이전",
                                      //       isDarkBackground: false,
                                      //       padding: EdgeInsets.symmetric(horizontal: 32.w)),
                                      // ),
                                      // SizedBox(width: 10.w),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            Get.back();
                                          },
                                          child: textContainerButtonWithOptions(
                                            fontSize: 18.w,
                                            height: 56.w,
                                            text: questModel.surveys![pageController.page!.round()].instruction ??
                                                "요트 탑승하기",
                                            isDarkBackground: true,
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ],
                                )
                              : (questModel.surveys![pageController.page!.round()].answerType == 'pickMany' ||
                                      questModel.surveys![pageController.page!.round()].answerType ==
                                          'pickManyCircles' ||
                                      questModel.surveys![pageController.page!.round()].answerType == 'none')
                                  ? Row(children: [
                                      // InkWell(
                                      //   onTap: () {
                                      //     pageController.previousPage(
                                      //         duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                      //   },
                                      //   child: textContainerButtonWithOptions(
                                      //       height: 56.w,
                                      //       text: "이전",
                                      //       isDarkBackground: false,
                                      //       padding: EdgeInsets.symmetric(horizontal: 32.w)),
                                      // ),
                                      // SizedBox(width: 10.w),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            // if (questModel.surveys![pageNumber.value].answerType != 'none') {
                                            //   controller.userAnswerList.replaceRange(
                                            //       questModel.surveys![pageNumber.value].answersId!,
                                            //       questModel.surveys![pageNumber.value].answersId! + 2,
                                            //       controller.answerList[questModel.surveys![pageNumber.value].answersId!]);
                                            // }
                                            if (questModel.surveys![pageController.page!.round()].isFinal != null &&
                                                questModel.surveys![pageController.page!.round()].isFinal!) {
                                              await controller.updateUserSurvey(questModel);
                                              await controller.updateQuestParticipationReward(questModel);
                                              todayQuests = null;
                                              await Get.find<HomeViewModel>().getAllQuests();
                                            }

                                            print(controller.answerList);
                                            if (questModel.surveys![pageController.page!.round()].redirect ?? false) {
                                              // 유저가 지금 페이지 질문에 응답한 답
                                              int userAnswerToThisPage = controller.answerList[
                                                  questModel.surveys![pageController.page!.round()].answersId!];
                                              print('userAnswerToThisPage: $userAnswerToThisPage');
                                              // redirect 해야하는 answerId
                                              print(questModel.surveys![pageController.page!.round()]);
                                              int answerIdRedirectTo = questModel.surveys![pageController.page!.round()]
                                                  .redirectQuestionIndex![userAnswerToThisPage];
                                              print('answerIdRedirectTo: $answerIdRedirectTo');
                                              int pageNumberToGo = questModel.surveys!
                                                  .indexWhere((element) => element.answersId == answerIdRedirectTo);

                                              pageController.jumpToPage(pageNumberToGo);

                                              //  (duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                            } else {
                                              pageController.nextPage(
                                                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                            }
                                          },
                                          child: textContainerButtonWithOptions(
                                            fontSize: 18.w,
                                            height: 56.w,
                                            text: questModel.surveys![pageController.page!.round()].instruction ??
                                                "선택 완료",
                                            isDarkBackground: true,
                                          ),
                                        ),
                                      ),
                                    ])
                                  : Container()),
                )
              ],
            ),
          ),
        )

        // IntroductionScreen(
        //   controlsPadding: EdgeInsets.zero,
        //   pages: surveyPages,
        //   onDone: () {
        //     // GetStorage().write('hasSeenOnboarding', true);
        //     // Get.off(() => AuthCheckView());
        //   },
        //   showSkipButton: true,
        //   skip: Text(
        //     "넘어가기",
        //     style: skipOnboarding,
        //   ),
        //   done: Text(
        //     "항해 시작!",
        //     style: nextPage,
        //   ),
        //   next: Text(
        //     "다음",
        //     style: nextPage,
        //   ),
        //   dotsDecorator: DotsDecorator(
        //     size: const Size.square(0),
        //     activeSize: const Size(0.0, 0.0),
        //     activeColor: yachtRed,
        //     color: yachtGrey,
        //     spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        //     activeShape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(25.0),
        //     ),
        //   ),
        // ),
        );
  }
}
