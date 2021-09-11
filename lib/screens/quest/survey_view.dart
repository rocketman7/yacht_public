import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:yachtOne/models/survey_model.dart';
import 'package:yachtOne/screens/quest/survey_view_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class SurveyView extends GetView<SurveyViewModel> {
  SurveyView({Key? key}) : super(key: key);

  QuestModel questModel = Get.arguments;
  PageController pageController = PageController(initialPage: 0);

  @override
  // TODO: implement controller
  SurveyViewModel get controller => Get.put((SurveyViewModel(surveyQuestionPageModel: surveyQuestions)));

  @override
  // TODO: implement controller
  // SurveyViewModel get controller => Get.put(SurveyViewModel());
  RxInt pageNumber = 0.obs;

  @override
  Widget build(BuildContext context) {
    List<Widget> surveyPages = List.generate(
      surveyQuestions.length,
      (index) => Padding(
        padding: EdgeInsets.fromLTRB(28.w, 0.0, 28.w, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: primaryPaddingSize,
            ),
            Text(
              surveyQuestions[index].question.replaceAll('\\n', '\n'),
              style: surveyTitle,
            ),
            SizedBox(
              height: correctHeight(26.w, surveyTitle.fontSize, 0.0),
            ),
            Expanded(
              child: ListView(children: [
                if (surveyQuestions[index].answers != null) ...{
                  // 선지가 있고
                  if (surveyQuestions[index].answerType == 'pickOne') ...{
                    // 택1인 경우
                    ...List.generate(surveyQuestions[index].answers!.length, (answerIndex) {
                      return Column(
                        children: [
                          if (answerIndex == 0)
                            Divider(
                              height: 20.w,
                              color: yachtBlack.withOpacity(.4),
                            ),
                          InkWell(
                            onTap: () {
                              controller.answerList[surveyQuestions[index].answersId!] = answerIndex;
                              controller.update();
                            },
                            child: Container(
                              child: GetBuilder<SurveyViewModel>(builder: (controller) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      controller.answerList[surveyQuestions[index].answersId!] == null
                                          ? 'assets/buttons/radio_inactive.png'
                                          : controller.answerList[surveyQuestions[index].answersId!] == answerIndex
                                              ? 'assets/buttons/radio_active.png'
                                              : 'assets/buttons/radio_inactive.png',
                                      width: 28.w,
                                      height: 28.w,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        surveyQuestions[index].answers![answerIndex],
                                        maxLines: 3,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          Divider(
                            height: 20.w,
                            color: yachtBlack.withOpacity(.4),
                          ),
                        ],
                      );
                    }),
                  } else if (surveyQuestions[index].answerType == 'pickManyCircles') ...{
                    Wrap(
                      clipBehavior: Clip.none,
                      spacing: 12.w,
                      runSpacing: 12.w,
                      alignment: WrapAlignment.center,
                      children: List.generate(
                          surveyQuestions[index].answers!.length,
                          (answerIndex) => GetBuilder<SurveyViewModel>(builder: (controller) {
                                return InkWell(
                                  onTap: () {
                                    controller.answerList[surveyQuestions[index].answersId!].contains(answerIndex)
                                        ? controller.answerList[surveyQuestions[index].answersId!].remove(answerIndex)
                                        : controller.answerList[surveyQuestions[index].answersId!].add(answerIndex);
                                    controller.update();
                                    print(controller.answerList);
                                  },
                                  child: Container(
                                    height: 80.w,
                                    width: 80.w,
                                    clipBehavior: Clip.hardEdge,
                                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          controller.answerList[surveyQuestions[index].answersId!].contains(answerIndex)
                                              ? yachtViolet
                                              : buttonNormal,
                                    ),
                                    child: Center(
                                      child: Text(
                                        surveyQuestions[index].answers![answerIndex],
                                        style: controller.answerList[surveyQuestions[index].answersId!]
                                                .contains(answerIndex)
                                            ? pickManyCircleName.copyWith(color: buttonNormal)
                                            : pickManyCircleName,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                );
                              })),
                    )
                  }
                }
              ]),
            )
          ],
        ),
      ),
    );

    pageController.addListener(() {
      pageNumber(pageController.page!.round());
    });

    return Scaffold(
        backgroundColor: white,
        body: SafeArea(
          child: GetBuilder<SurveyViewModel>(
            init: SurveyViewModel(surveyQuestionPageModel: surveyQuestions),
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
                        : Row(children: [
                            InkWell(
                              onTap: () {
                                pageController.previousPage(
                                    duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                              },
                              child: textContainerButtonWithOptions(
                                  height: 56.w,
                                  text: "이전",
                                  isDarkBackground: false,
                                  padding: EdgeInsets.symmetric(horizontal: 32.w)),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  // if (surveyQuestions[pageNumber.value].answerType != 'none') {
                                  //   controller.userAnswerList.replaceRange(
                                  //       surveyQuestions[pageNumber.value].answersId!,
                                  //       surveyQuestions[pageNumber.value].answersId! + 2,
                                  //       controller.answerList[surveyQuestions[pageNumber.value].answersId!]);
                                  // }
                                  print(controller.answerList);
                                  if (surveyQuestions[pageController.page!.round()].redirect) {
                                    // 유저가 지금 페이지 질문에 응답한 답
                                    int userAnswerToThisPage =
                                        controller.answerList[surveyQuestions[pageController.page!.round()].answersId!];
                                    print('userAnswerToThisPage: $userAnswerToThisPage');
                                    // redirect 해야하는 answerId
                                    print(surveyQuestions[pageController.page!.round()]);
                                    int answerIdRedirectTo = surveyQuestions[pageController.page!.round()]
                                        .redirectQuestionIndex![userAnswerToThisPage];
                                    print('answerIdRedirectTo: $answerIdRedirectTo');
                                    int pageNumberToGo = surveyQuestions
                                        .indexWhere((element) => element.answersId == answerIdRedirectTo);

                                    pageController.jumpToPage(pageNumberToGo);

                                    //  (duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  } else {
                                    pageController.nextPage(
                                        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  }
                                },
                                child: textContainerButtonWithOptions(
                                  height: 56.w,
                                  text: "다음",
                                  isDarkBackground: true,
                                ),
                              ),
                            ),
                          ]),
                  ),
                ),
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
