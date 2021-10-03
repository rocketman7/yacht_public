import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/quest/quest_widget.dart';
import 'package:yachtOne/screens/quest/tutorial_view_model.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class TutorialView extends StatelessWidget {
  TutorialView({Key? key}) : super(key: key);
  QuestModel questModel = Get.arguments;

  double appBarHeight = 0;
  double bottomBarHeight = 0;
  double offset = 0.0;

  @override
  Widget build(BuildContext context) {
    TutorialViewModel tutorialViewModel = Get.put(TutorialViewModel());
    return Scaffold(
      body: Stack(
        children: [
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
                    Text(
                      "퀘스트 정보",
                      style: sectionTitle,
                    ),
                    btwHomeModuleTitleBox,
                    Container(
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
                      Future.delayed(Duration(milliseconds: 600)).then((_) {
                        // tutorialViewModel.isSelectingSheetShowing(false);
                      });
                      yachtSnackBarFromBottom("저장되었습니다.");
                    }
                    ;
                  },
                  child: ClipRect(
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
                          color: primaryFontColor,
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
