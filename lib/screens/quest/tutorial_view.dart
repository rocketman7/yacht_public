import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/quest/quest_widget.dart';
import 'package:yachtOne/screens/quest/tutorial_view_model.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

// import 'package:showcaseview/showcaseview.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialView extends StatefulWidget {
  TutorialView({Key? key}) : super(key: key);

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  QuestModel questModel = Get.arguments;

  double appBarHeight = 0;

  double bottomBarHeight = 0;

  double offset = 0.0;

  late TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = <TargetFocus>[];

  late TutorialCoachMark tutorialCoachMark2;
  List<TargetFocus> targets2 = <TargetFocus>[];

  GlobalKey _step1 = GlobalKey();
  GlobalKey _step2 = GlobalKey();
  GlobalKey _step3 = GlobalKey();

  GlobalKey _step21 = GlobalKey();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200), showTutorial);
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   showTutorial();
    // });
    super.initState();
  }

  void showTutorial() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: 'STEP1',
        keyTarget: _step1,
        shape: ShapeLightFocus.RRect,
        radius: 12.w,
        paddingFocus: 5.w,
        enableOverlayTab: false,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.custom,
            customPosition: CustomTargetContentPosition(bottom: 20.w),
            // align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    tutorialDescription(true, '퀘스트 내용을 확인해볼까요?'),
                    SizedBox(
                      height: 6.w,
                    ),
                    tutorialDescription(true, '이제 직접 참여해보세요.'),
                    SizedBox(
                      height: 6.w,
                    ),
                    tutorialButton(tutorialCoachMark, true, '다음 단계로 넘어가기'),
                    SizedBox(
                      height: 50.w,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: 'STEP2',
        keyTarget: _step2,
        shape: ShapeLightFocus.RRect,
        radius: 33.w,
        paddingFocus: 5.w,
        enableOverlayTab: false,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    tutorialDescription(false, '아래 버튼을 눌러 퀘스트에 참여해보세요.'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "STEP3",
        keyTarget: _step3,
        shape: ShapeLightFocus.RRect,
        radius: 12.w,
        paddingFocus: 5.w,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    tutorialDescription(true, '연습이니 편하게 선택해보세요.'),
                    SizedBox(
                      height: 6.w,
                    ),
                    tutorialDescription(true, '선택 후에는 꼭 저장 버튼을 눌러주세요.'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    tutorialCoachMark = TutorialCoachMark(
      context,
      targets: targets,
      colorShadow: Color(0xFF343434),
      opacityShadow: 0.5,
      hideSkip: true,
      paddingFocus: 0,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
        // print(target.targetPosition!.offset.dx);
        if (target.identify == 'STEP2') {
          print('aaaaaaaaa');
          Get.find<TutorialViewModel>().isSelectingSheetShowing(true);
        }
      },
      onSkip: () {
        print("skip");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
    )..show();
  }

  void showTutorial2() {
    targets2.clear();
    targets2.add(
      TargetFocus(
        identify: "STEP21",
        keyTarget: _step21,
        shape: ShapeLightFocus.RRect,
        // radius: 12.w,
        // paddingFocus: 5.w,
        enableOverlayTab: true,
        enableTargetTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: SizeConfig.safeAreaTop,
                    ),
                    tutorialDescription(true, '잘 저장되었어요!'),
                    SizedBox(
                      height: 6.w,
                    ),
                    tutorialDescription(true, '튜토리얼은 여기까지에요.'),
                    SizedBox(
                      height: 6.w,
                    ),
                    tutorialDescription(true, '실제 퀘스트를 진행하면,'),
                    SizedBox(
                      height: 6.w,
                    ),
                    tutorialDescription(true, '홈화면에서 퀘스트 결과를 볼 수 있어요!'),
                    SizedBox(
                      height: 6.w,
                    ),
                    tutorialButton(tutorialCoachMark2, true, '튜토리얼 끝내기'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    tutorialCoachMark2 = TutorialCoachMark(
      context,
      targets: targets2,
      colorShadow: Color(0xFF343434),
      opacityShadow: 0.5,
      hideSkip: true,
      paddingFocus: 0,
      onFinish: () async {
        await Get.find<TutorialViewModel>().endOfTutorial();
      },
      onClickTarget: (target) {},
      onSkip: () {},
      onClickOverlay: (target) {},
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    TutorialViewModel tutorialViewModel = Get.put(TutorialViewModel());

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -10,
            child: Center(
              child: Container(
                key: _step21,
                width: SizeConfig.screenWidth,
              ),
            ),
          ),
          CustomScrollView(slivers: [
            SliverAppBar(
              backgroundColor: primaryBackgroundColor,
              pinned: true,
              title: Text(
                "퀘스트 참여하기",
                style: appBarTitle,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: textTopPadding(homeModuleTitleTextStyle.fontSize!),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "퀘스트 정보",
                        style: sectionTitle,
                      ),
                    ),
                    btwHomeModuleTitleBox,
                    Container(
                        key: _step1,
                        padding: moduleBoxPadding(questTermTextStyle.fontSize!),
                        decoration: primaryBoxDecoration
                            .copyWith(boxShadow: [primaryBoxShadow], color: homeModuleBoxBackgroundColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            QuestCardHeader(
                              questModel: questModel,
                            ),
                            btwHomeModuleTitleBox,
                            QuestCardRewards(questModel: questModel),
                            SizedBox(
                              height: correctHeight(24.w, 0.0, detailedContentTextStyle.fontSize),
                            ),
                            Text("퀘스트 상세 설명",
                                style: questDescription.copyWith(
                                  fontWeight: FontWeight.w500,
                                )),
                            SizedBox(
                              height: correctHeight(
                                14.w,
                                detailedContentTextStyle.fontSize,
                                questDescription.fontSize,
                              ),
                            ),
                            Text(
                              questModel.questDescription,
                              style: questDescription,
                            ),
                            SizedBox(
                              height: correctHeight(24.w, 0.0, detailedContentTextStyle.fontSize),
                            ),
                            questModel.rewardDescription != null
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("리워드 상세 설명",
                                          style: questDescription.copyWith(
                                            fontWeight: FontWeight.w500,
                                          )),
                                      SizedBox(
                                        height: correctHeight(
                                          14.w,
                                          detailedContentTextStyle.fontSize,
                                          questDescription.fontSize,
                                        ),
                                      ),
                                      Text(
                                        questModel.rewardDescription!,
                                        style: questDescription,
                                      ), //temp
                                    ],
                                  )
                                : Container(),
                          ],
                        )),
                    // btwHomeModule,
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
                child: SizedBox(
              height: 88.w,
            )),
          ]),
          Obx(() => tutorialViewModel.isSelectingSheetShowing.value
              ? GestureDetector(
                  onTap: () {
                    tutorialViewModel.isSelectingSheetShowing(false);
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: backgroundWhenPopup,
                  ),
                )
              : Container()),
          // // 최종선택하기 위한 custom bottom sheet
          Obx(() {
            return newSelectBottomSheet(tutorialViewModel);
          }),
          Obx(
            () => Positioned(
                left: 14.w,
                right: 14.w,
                bottom: 20.w,
                child: GestureDetector(
                  onTap: () {
                    if (tutorialViewModel.isSelectingSheetShowing.value == false) {
                      tutorialViewModel.isSelectingSheetShowing(true);
                      // questViewModel.syncUserSelect();
                    } else {
                      // questViewModel.updateUserQuest();
                      // Future.delayed(Duration(milliseconds: 600)).then((_) {
                      //   // tutorialViewModel.isSelectingSheetShowing(false);
                      // });
                      if (tutorialViewModel.toggleList.contains(true)) {
                        tutorialViewModel.isSelectingSheetShowing(false);
                        yachtSnackBarFromBottomForTutorial("저장되었습니다.");
                        showTutorial2();
                      }
                    }
                  },
                  child: ClipRect(
                    key: _step2,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        height: 60.w,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.w),
                          color: yachtViolet80.withOpacity(.8),
                        ),
                        child: Center(
                            child: Text(
                          tutorialViewModel.isSelectingSheetShowing.value
                              ? "예측 확정하기"
                              // : (tutorialViewModel.thisUserQuestModel.value == null ||
                              //         tutorialViewModel.thisUserQuestModel.value!.selectDateTime == null)
                              //     ? "예측하기"
                              : "예측하기",
                          style: buttonTextStyle.copyWith(fontSize: 24.w),
                        )),
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  AnimatedPositioned newSelectBottomSheet(TutorialViewModel tutorialViewModel) {
    return AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        left: 14.w,
        right: 14.w,
        bottom: tutorialViewModel.isSelectingSheetShowing.value ? (20.w + 60.w + 20.w) : -500.w,
        child: Container(
          key: _step3,
          // color: Colors.white,
          width: double.infinity,
          // height: 100,
          padding: EdgeInsets.all(14.w),
          decoration: (primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow])),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    tutorialViewModel.isSelectingSheetShowing(false);
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    width: 50.w,
                    // color: Colors.yellow.withOpacity(.2),
                    child: Column(
                      children: [
                        Icon(
                          Icons.close,
                          color: yachtBlack,
                          size: 30.w,
                        ),
                        SizedBox(height: reducedPaddingWhenTextIsBelow(8.w, questTitleTextStyle.fontSize!)),
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(height: reducedPaddingWhenTextIsBelow(8.w, questTitleTextStyle.fontSize!)),
              Padding(
                padding: EdgeInsets.all(4.0.w),
                child: Text(questModel.selectInstruction,
                    style: questTitleTextStyle, maxLines: 3, textAlign: TextAlign.center),
              ),
              SizedBox(height: reducedPaddingWhenTextIsBelow(16.w, questTitleTextStyle.fontSize!)),
              Column(
                children: [
                  Row(
                      children: List.generate(2, (index) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            tutorialViewModel.toggleUserSelect(index);
                            print('$index is change to ${tutorialViewModel.toggleList}');
                            HapticFeedback.lightImpact();
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 151.w,
                            height: 151.w,
                            decoration: yachtChoiceBoxDecoration.copyWith(
                                color: index == 0 && tutorialViewModel.toggleList[0]
                                    ? yachtRed
                                    : index == 1 && tutorialViewModel.toggleList[1]
                                        ? yachtBlue
                                        : white),
                            child: Padding(
                              padding: primaryAllPadding,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                        width: 38.w,
                                        height: 38.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          // color: yachtDarkGrey,
                                        ),
                                        child: index == 0
                                            ? Image.asset('assets/icons/quest_select_up.png',
                                                color: tutorialViewModel.toggleList[0] ? white : yachtRed)
                                            : Image.asset('assets/icons/quest_select_down.png',
                                                color: tutorialViewModel.toggleList[1] ? white : yachtBlue)),
                                  ),
                                  Text(
                                    questModel.choices![index],
                                    style: yachtChoiceBoxName.copyWith(
                                        color: tutorialViewModel.toggleList[index] ? white : yachtBlack),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (index == 0) SizedBox(width: primaryPaddingSize)
                      ],
                    );
                  })),
                  SizedBox(
                    height: 12.w,
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/jogabi.svg',
                            height: 20.w,
                            width: 20.w,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Text(
                            "${questModel.itemNeeded}개",
                            style: jogabiNumberStyle.copyWith(fontSize: 14.w),
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                        ],
                      )),
                ],
              )

              // SizedBox(height: 16.w)
            ],
          ),
        ));
  }
}

Widget tutorialDescription(bool isAlignLeft, String description) {
  return Row(
    children: [
      isAlignLeft ? Container() : Spacer(),
      Container(
        height: 40.w,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(54.0), color: buttonNormal),
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Center(
            child: Text(
              description,
              style: tutorialDescriptionStyle,
            ),
          ),
        ),
      ),
      Spacer(),
    ],
  );
}

Widget tutorialButton(TutorialCoachMark tutorialCoachMark, bool isAlignLeft, String description) {
  return Row(
    children: [
      isAlignLeft ? Container() : Spacer(),
      GestureDetector(
        onTap: () {
          tutorialCoachMark.next();
        },
        child: Container(
          height: 40.w,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(54.0), color: yachtViolet),
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Center(
              child: Text(
                description,
                style: tutorialDescriptionStyle.copyWith(color: buttonNormal),
              ),
            ),
          ),
        ),
      ),
      Spacer(),
    ],
  );
}

yachtSnackBarFromBottomForTutorial(String title) {
  return Get.rawSnackbar(
    messageText: Center(
      child: Text(
        title,
        style: snackBarStyle.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: white.withOpacity(.7),
    barBlur: 2,
    margin: EdgeInsets.only(bottom: 60.w /*+ SizeConfig.safeAreaBottom*/),
    duration: const Duration(seconds: 1, milliseconds: 300),
    // animationDuration: const Duration(microseconds: 1000),
  );
}
