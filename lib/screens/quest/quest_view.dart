import 'dart:async';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';

import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';

import 'package:yachtOne/screens/quest/quest_widget.dart';
import 'package:yachtOne/screens/quest/quest_view_model.dart';

import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/widgets/loading_container.dart';
import '../../locator.dart';
import 'quest_widget.dart';
import 'package:yachtOne/styles/style_constants.dart';

// const double heightForSliverFlexibleSpace =
//     kToolbarHeight + 220.0; // 당연히 기기마다 달라져야함. SliverFlexibleSpace를 위한 height
// const double paddingForRewardText = 8.0; // 상금 주식 가치 텍스트 위의 패딩(마진)
// const Color sliverAppBarColor = Color(0xFFD9D9D9);
// const Color backgroundColor = Colors.white;

class QuestView extends StatelessWidget {
  // final QuestModel questModel;
  // QuestView({Key? key, required this.questModel}) : super(key: key);
  // const QuestView({Key? key}) : super(key: key);

  // final ScrollController _scrollController =
  //     ScrollController(initialScrollOffset: 0.0);

  QuestModel questModel = Get.arguments;

  double appBarHeight = 0;
  double bottomBarHeight = 0;
  double offset = 0.0;

  @override
  Widget build(BuildContext context) {
    // 뷰 모델에 퀘스트 데이터 모델 넣어주기
    final QuestViewModel questViewModel = Get.put(QuestViewModel(questModel));
    final MixpanelService _mixpanelService = locator<MixpanelService>();
    final stockInfoViewModel = Get.put(
        StockInfoKRViewModel(investAddressModel: questModel.investAddresses![questViewModel.stockInfoIndex.value]));
    // questViewModel.init(questModel);
    // streamSubscription =
    //     StockInfoKRView.streamController.stream.listen((event) {
    //   offset = event;
    //   localStreamController.add(offset);
    // });

    // StreamController controller = StockInfoKRView
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
    // ));
    return Scaffold(
      backgroundColor: yachtBlack,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
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
                  color: yachtBlack,
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
                      Column(
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
                          QuestDescription(questModel: questModel)
                        ],
                      )
                      // btwHomeModule,
                    ],
                  ),
                ),
              ),
              // SliverPersistentHeader(
              //   delegate: SectionHeaderDelegate("Section B"),
              //   pinned: true,
              // ),

              SliverToBoxAdapter(
                  child: Container(
                padding: textTopPadding(homeModuleTitleTextStyle.fontSize!),
                child: Text(
                  "기업 정보",
                  style: sectionTitle,
                ),
              )),
              // 스크롤 내리면 위에 붙을 퀘스트 선택지 기업 목록
              SliverPersistentHeader(
                delegate: SectionHeaderDelegate(
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: questModel.investAddresses!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  questViewModel.changeIndex(index);
                                  stockInfoViewModel.changeInvestAddressModel(questModel.investAddresses![index]);
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(14.w, 0, 4.w, 0),
                                  child: Obx(
                                    () => Container(
                                      padding: EdgeInsets.symmetric(vertical: 6.w),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: questViewModel.stockInfoIndex.value == index
                                                  ? BorderSide(width: 3.w, color: yachtViolet)
                                                  : BorderSide.none)),
                                      child: Obx(() => Text("  ${questModel.investAddresses![index].name}  ",
                                          style: buttonTextStyle.copyWith(
                                              color: questViewModel.stockInfoIndex.value == index
                                                  ? white
                                                  : yachtLightGrey))),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                    40.w),
                pinned: true,
              ),
              // SliverToBoxAdapter(
              //   child: btwHomeModuleTitleBox,
              // ),
              SliverToBoxAdapter(
                  child: Container(
                // color: yachtGrey,
                padding: textTopPadding(homeModuleTitleTextStyle.fontSize!),
                child:
                    // 퀘스트 종목간 선택 row

                    GetBuilder<QuestViewModel>(
                  builder: (questViewModel) {
                    return StockInfoKRView(
                        investAddressModel: questModel.investAddresses![questViewModel.stockInfoIndex.value]);
                  },
                ),
              )),
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 88.w,
              )),
            ],
          ),
          // 선택 확정하기 눌렀을 때 배경 회색처리, 그 때 배경 아무데나 눌러도 원래 퀘스트뷰 화면으로 복귀
          Obx(() => questViewModel.isSelectingSheetShowing.value
              ? GestureDetector(
                  onTap: () {
                    questViewModel.isSelectingSheetShowing(false);
                  },
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      // color: ,
                    ),
                  ),
                )
              : Container()),
          // 최종선택하기 위한 custom bottom sheet
          Obx(() {
            // selectMode에 따라 표기 다르게 설정. 일단 'one' 이라고 가정
            // if (questModel.selectMode == 'one') {

            // }

            // List<num>? answers = questViewModel.userQuestModel.value!.selection;
            // print('answers from server: $toggleList');
            return newSelectBottomSheet(questViewModel);
          }),
          Obx(
            () => Positioned(
                left: 14.w,
                right: 14.w,
                bottom: ScreenUtil().bottomBarHeight + 8.w,
                child: GestureDetector(
                  onTap: () async {
                    // print(questViewModel.checkIfUserSelectedAny());
                    if (questViewModel.isSelectingSheetShowing.value == false) {
                      questViewModel.isSelectingSheetShowing(true);
                      questViewModel.syncUserSelect();
                    } else {
                      // DateTime.now().isAfter(other)

                      if (!questViewModel.checkIfUserSelectedAny() && questModel.selectMode != "order") {
                        yachtSnackBarFromBottom(
                          "선택을 완료한 후 확정할 수 있습니다.",
                          // longerDuration: 2000,
                        );
                      } else if (questModel.questEndDateTime.toDate().isBefore(DateTime.now())) {
                        yachtSnackBarFromBottom(
                          "퀘스트 참여가능한 시간이 지났습니다.",
                          // longerDuration: 2000,
                        );
                      } else if (questModel.itemNeeded > userModelRx.value!.item) {
                        yachtSnackBarFromBottom(
                          "보유 중인 조가비가 부족합니다.\n홈 화면에서 광고를 보고 조가비를 얻을 수 있어요.",
                          longerDuration: 2000,
                        );
                      } else {
                        await questViewModel.updateUserQuest();
                        _mixpanelService.mixpanel.track('Quest Participate', properties: {
                          'Participate Quest ID': questModel.questId,
                          'Participate League ID': questModel.leagueId,
                          'Participate Quest Title': questModel.title,
                          'Participate Quest Category': questModel.category,
                          'Participate Quest Select Mode': questModel.selectMode,
                          'Participate Quest Item Used': questModel.itemNeeded,
                          'Participate Quest Yacht Point Success Reward': questModel.yachtPointSuccessReward,
                          'Participate Quest League Point Success Reward': questModel.leaguePointSuccessReward,
                        });
                        Future.delayed(Duration(milliseconds: 600)).then((_) {
                          questViewModel.isSelectingSheetShowing(false);
                        });
                        yachtSnackBarFromBottom("저장되었습니다.");
                      }
                    }
                  },
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        height: 55.w,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.w),
                          color: yachtViolet.withOpacity(.8),
                        ),
                        child: Center(
                            child: Text(
                          questViewModel.isSelectingSheetShowing.value
                              ? "예측 확정하기"
                              : (questViewModel.thisUserQuestModel.value == null ||
                                      questViewModel.thisUserQuestModel.value!.selectDateTime == null)
                                  ? "예측하기"
                                  : "예측 변경하기",
                          style: buttonTextStyle.copyWith(fontSize: 20.w),
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

  // Positioned oldSelectBottomSheet(QuestViewModel questViewModel) {
  //   return Positioned(
  //       left: 14.w,
  //       right: 14.w,
  //       bottom: 20.w + 60.w + 20.w,
  //       child: Container(
  //         // color: Colors.white,
  //         width: double.infinity,
  //         // height: 100,
  //         padding: EdgeInsets.all(14.w),
  //         decoration: (primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow])),
  //         child: Column(
  //           children: [
  //             Align(
  //               alignment: Alignment.centerRight,
  //               child: GestureDetector(
  //                 onTap: () => questViewModel.isSelectingSheetShowing(false),
  //                 child: Container(
  //                   alignment: Alignment.centerRight,
  //                   width: 50.w,
  //                   color: Colors.yellow.withOpacity(.2),
  //                   child: Icon(
  //                     Icons.close,
  //                     color: primaryFontColor,
  //                     size: 30.w,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: reducedPaddingWhenTextIsBelow(8.w, questTitleTextStyle.fontSize!)),
  //             Padding(
  //               padding: EdgeInsets.all(16.0.w),
  //               child: Text(questModel.selectInstruction, style: questTitleTextStyle, textAlign: TextAlign.center),
  //             ),
  //             SizedBox(height: reducedPaddingWhenTextIsBelow(16.w, questTitleTextStyle.fontSize!)),
  //             Divider(color: primaryFontColor.withOpacity(.4)),
  //             Column(
  //               children: List.generate(
  //                   questModel.investAddresses!.length,
  //                   (index) => Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Obx(
  //                             () => InkWell(
  //                               onTap: () {
  //                                 questViewModel.toggleUserSelect(index);
  //                                 print('$index is change to ${questViewModel.toggleList}');
  //                               },
  //                               child: Container(
  //                                 padding: EdgeInsets.all(8.0.w),
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.start,
  //                                   crossAxisAlignment: CrossAxisAlignment.center,
  //                                   children: [
  //                                     Image.asset(
  //                                       questViewModel.toggleList[index] == false
  //                                           ? 'assets/buttons/radio_inactive.png'
  //                                           : 'assets/buttons/radio_active.png',
  //                                       width: 34.w,
  //                                       height: 34.w,
  //                                     ),
  //                                     SizedBox(width: 8.w),
  //                                     Text(
  //                                       questModel.investAddresses![index].name,
  //                                       style: detailedContentTextStyle.copyWith(fontSize: 18.w),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Divider(color: primaryFontColor.withOpacity(.4)),
  //                         ],
  //                       )),
  //             ),
  //             SizedBox(height: 12.w)
  //           ],
  //         ),
  //       ));
  // }

  AnimatedPositioned newSelectBottomSheet(QuestViewModel questViewModel) {
    return AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        left: 14.w,
        right: 14.w,
        bottom: questViewModel.isSelectingSheetShowing.value ? (ScreenUtil().bottomBarHeight + 60.w + 20.w) : -500.w,
        child: Container(
          width: double.infinity,
          // height: 100,
          padding: EdgeInsets.all(14.w),
          decoration: (primaryBoxDecoration.copyWith(
            boxShadow: [
              primaryBoxShadow,
            ],
            color: yachtDarkGrey,
          )),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    questViewModel.isSelectingSheetShowing(false);
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    width: 50.w,
                    // color: Colors.yellow.withOpacity(.2),
                    child: Column(
                      children: [
                        Icon(
                          Icons.close,
                          color: yachtLightGrey,
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
              Text(questModel.basePriceInstruction),
              SizedBox(height: reducedPaddingWhenTextIsBelow(16.w, questTitleTextStyle.fontSize!)),
              questModel.selectMode == 'pickone'
                  ? Column(
                      children: [
                        Row(
                            children: List.generate(questModel.investAddresses!.length, (index) {
                          return Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  questViewModel.toggleUserSelect(index);
                                  HapticFeedback.lightImpact();
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  width: 151.w,
                                  height: 151.w,
                                  decoration: yachtChoiceBoxDecoration.copyWith(
                                      boxShadow: questViewModel.toggleList[index]
                                          ? yachtChoiceBoxDecoration.boxShadow
                                          : [BoxShadow()],
                                      color: questViewModel.toggleList[index] ? yachtRed : yachtMidGrey),
                                  child: Padding(
                                    padding: primaryAllPadding,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Obx(
                                            () => Container(
                                                width: 38.w,
                                                height: 38.w,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: yachtGrey,
                                                ),
                                                child: questViewModel.logoImage.length > 0
                                                    ? questViewModel.logoImage[index]
                                                    : Container()),
                                          ),
                                        ),
                                        Text(
                                          questModel.investAddresses![index].name,
                                          style: yachtChoiceBoxName.copyWith(
                                              color: questViewModel.toggleList[index] ? white : yachtLightGrey),
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
                  : questModel.selectMode == 'updown'
                      ? Column(
                          children: [
                            Row(
                                children: List.generate(2, (index) {
                              return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      questViewModel.toggleUserSelect(index);
                                      print('$index is change to ${questViewModel.toggleList}');
                                      HapticFeedback.lightImpact();
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(milliseconds: 300),
                                      width: 151.w,
                                      height: 151.w,
                                      decoration: yachtChoiceBoxDecoration.copyWith(
                                          boxShadow: questViewModel.toggleList[index]
                                              ? yachtChoiceBoxDecoration.boxShadow
                                              : [BoxShadow()],
                                          color: index == 0 && questViewModel.toggleList[0]
                                              ? yachtRed
                                              : index == 1 && questViewModel.toggleList[1]
                                                  ? yachtBlue
                                                  : yachtMidGrey),
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
                                                          color: questViewModel.toggleList[0] ? white : yachtRed)
                                                      : Image.asset('assets/icons/quest_select_down.png',
                                                          color: questViewModel.toggleList[1] ? white : yachtBlue)),
                                            ),
                                            Text(
                                              questModel.choices![index],
                                              style: yachtChoiceBoxName.copyWith(
                                                  color: questViewModel.toggleList[index] ? white : yachtLightGrey),
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
                      : questModel.selectMode == 'order'
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: List.generate(
                                            questModel.investAddresses!.length,
                                            (index) => Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: index != questModel.investAddresses!.length ? 10.w : 0.0),
                                                  height: 50.w,
                                                  child: Center(
                                                    child: Text(
                                                      (index + 1).toString(),
                                                      style: yachtChoiceReOrderableListTitle.copyWith(
                                                          fontWeight: FontWeight.w600),
                                                    ),
                                                  ),
                                                )),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Container(
                                        // height: 200.w,
                                        child: Theme(
                                          data: ThemeData(
                                            canvasColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            backgroundColor: Colors.transparent,
                                            dialogBackgroundColor: Colors.transparent,
                                          ),
                                          child: ReorderableListView(
                                            // dragStartBehavior: DragStartBehavior.down,
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,

                                            onReorder: (oldIndex, newIndex) {
                                              // Vibration.vibrate();
                                              questViewModel.reorderUserSelect(oldIndex, newIndex);
                                            },
                                            children: List.generate(questModel.investAddresses!.length, (index) {
                                              return Container(
                                                key: ValueKey(index),
                                                margin: EdgeInsets.only(
                                                    bottom: index != questModel.investAddresses!.length ? 10.w : 0.0),
                                                clipBehavior: Clip.hardEdge,
                                                padding: primaryHorizontalPadding,
                                                height: 50.w,
                                                decoration: yachtBoxDecoration,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Obx(
                                                          () => Container(
                                                              width: 24.w,
                                                              height: 24.w,
                                                              decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: yachtGrey,
                                                              ),
                                                              child: !questViewModel.isLoading.value
                                                                  ? questViewModel
                                                                      .logoImage[questViewModel.orderList[index]]
                                                                  : Container()),
                                                        ),
                                                        SizedBox(width: 8.w),
                                                        // orderList 없을 때 처리 필요
                                                        Obx(() => Text(
                                                              questModel
                                                                  .investAddresses![questViewModel.orderList[index]]
                                                                  .name,
                                                              style: yachtChoiceReOrderableListTitle,
                                                            )),
                                                        Spacer(),
                                                        Image.asset(
                                                          'assets/icons/three_lines.png',
                                                          width: 14.w,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                          : questModel.selectMode == 'updown_many'
                              ? Container(
                                  constraints: BoxConstraints.loose(
                                    Size(double.infinity, 300.w),
                                  ),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: questModel.investAddresses!.length,
                                        itemBuilder: (_, index) {
                                          return Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      FutureBuilder<String>(
                                                          future: questViewModel.getLogoByIssueCode(
                                                              questModel.investAddresses![index].issueCode),
                                                          builder: (context, snapshot) {
                                                            if (!snapshot.hasData) {
                                                              return Container(
                                                                  height: 36.w,
                                                                  width: 36.w,
                                                                  decoration: BoxDecoration(shape: BoxShape.circle),
                                                                  child: LoadingContainer(
                                                                      height: 36.w, width: 36.w, radius: 36.w));
                                                            } else {
                                                              // print(snapshot.data);
                                                              return Image.network(
                                                                snapshot.data!,
                                                                height: 36.w,
                                                                // width: 28.w,
                                                                // height: 27.w,
                                                                // width: 27.w,
                                                                filterQuality: FilterQuality.high,
                                                                // isAntiAlias: true,
                                                              );
                                                            }
                                                          }),
                                                      SizedBox(width: 8.w),
                                                      Text(
                                                        questModel.investAddresses![index].name,
                                                        style: yachtChoiceBoxName,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Container(
                                                        // color: Colors.blue,
                                                        child: Text(
                                                          "기준 가격",
                                                          style: TextStyle(
                                                              color: yachtGrey,
                                                              fontSize: captionSize,
                                                              fontFamily: 'Default'),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                      Container(
                                                        // color: Colors.blue,
                                                        child: Text(
                                                            (questModel.investAddresses![index].basePrice == null
                                                                    ? 0.toString()
                                                                    : toPriceKRW(questModel
                                                                        .investAddresses![index].basePrice as num)) +
                                                                "원",
                                                            style: yachtChoiceBoxName.copyWith(
                                                              fontWeight: FontWeight.w600,
                                                              height: 1.0,
                                                            )),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 16.w),
                                              Row(
                                                children: List.generate(2, (choice) {
                                                  return Obx(() => !questViewModel.isLoading.value
                                                      ? Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                questViewModel.updownManyList[index] = choice;
                                                                print(questViewModel.updownManyList);
                                                                HapticFeedback.lightImpact();
                                                              },
                                                              child: AnimatedContainer(
                                                                duration: Duration(milliseconds: 300),
                                                                width: 151.w,
                                                                height: 50.w,
                                                                decoration: yachtChoiceBoxDecoration.copyWith(
                                                                    color: choice == 0 &&
                                                                            questViewModel.updownManyList[index] == 0
                                                                        ? yachtRed
                                                                        : choice == 1 &&
                                                                                questViewModel.updownManyList[index] ==
                                                                                    1
                                                                            ? yachtBlue
                                                                            : white),
                                                                child: Padding(
                                                                  padding: primaryAllPadding,
                                                                  child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Center(
                                                                        child: Container(
                                                                            width: 28.w,
                                                                            // height: 38.w,

                                                                            child: choice == 0
                                                                                ? Image.asset(
                                                                                    'assets/icons/quest_select_up.png',
                                                                                    color:
                                                                                        questViewModel.updownManyList[
                                                                                                    index] ==
                                                                                                0
                                                                                            ? white
                                                                                            : yachtRed)
                                                                                : Image.asset(
                                                                                    'assets/icons/quest_select_down.png',
                                                                                    color:
                                                                                        questViewModel.updownManyList[
                                                                                                    index] ==
                                                                                                1
                                                                                            ? white
                                                                                            : yachtBlue)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            if (choice == 0) SizedBox(width: primaryPaddingSize)
                                                          ],
                                                        )
                                                      : Container());
                                                }),
                                              ),
                                              (index != questModel.investAddresses!.length - 1)
                                                  ? SizedBox(
                                                      height: 32.w,
                                                    )
                                                  : Container()
                                            ],
                                          );
                                        },
                                      ),
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
                                  ),
                                )

                              //   ],
                              // )
                              : Container(),

              // SizedBox(height: 16.w)
            ],
          ),
        ));
  }
}

class QuestDescription extends StatelessWidget {
  const QuestDescription({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  final QuestModel questModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("퀘스트 안내",
            style: questDescription.copyWith(
              fontWeight: FontWeight.w500,
            )),
        SizedBox(
          height: 14.w,
        ),
        Text(
          questModel.questDescription.replaceAll('\\n', '\n'),
          style: questDescription,
        ),
        SizedBox(
          height: 24.w,
        ),
        questModel.rewardDescription != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("퀘스트 보상",
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
                    questModel.rewardDescription!.replaceAll('\\n', '\n'),
                    style: questDescription,
                  ), //temp
                ],
              )
            : Container(),
        SizedBox(height: 14.w),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 96,
              child: Column(
                children: [
                  Container(
                      width: double.infinity,
                      height: 39.w,
                      child: Center(
                        child: Text(
                          "",
                          style: questResultRewardTitle.copyWith(
                              // color: yachtBlack,
                              ),
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      height: 39.w,
                      // color: buttonNormal,
                      child: Center(
                        child: Text(
                          "참여 보상",
                          style: questResultRewardTitle.copyWith(
                            fontFamily: krFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      height: 39.w,
                      // color: buttonNormal,
                      child: Center(
                        child: Text(
                          "성공 보상",
                          style: questResultRewardTitle.copyWith(
                            fontFamily: krFont,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Flexible(
              flex: 109,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 39.w,
                    // color: yachtYellowBackGround,
                    child: SvgPicture.asset(
                      'assets/icons/trophy.svg',
                      width: 27.w,
                      height: 27.w,
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      height: 39.w,
                      // color: buttonNormal,
                      child: Center(
                        child: Text(
                          "${questModel.leaguePointParticipationReward ?? 0}점",
                          style: questResultRewardTitle.copyWith(
                              fontSize: bodyBigSize,
                              fontFamily: krFont,
                              fontWeight: FontWeight.w500,
                              color: yachtYellow),
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      height: 39.w,
                      // color: buttonNormal,
                      child: Center(
                        child: Text(
                          "${questModel.leaguePointSuccessReward ?? 0}점",
                          style: questResultRewardTitle.copyWith(
                              fontSize: bodyBigSize,
                              fontFamily: krFont,
                              fontWeight: FontWeight.w500,
                              color: yachtYellow),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Flexible(
              flex: 109,
              child: Column(
                children: [
                  Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.only(
                    //     topRight: Radius.circular(10.w),
                    //     bottomRight: Radius.circular(10.w),
                    //   ),
                    //   color: yachtGreenBackGround,
                    // ),
                    width: double.infinity,
                    height: 39.w,
                    child: SvgPicture.asset(
                      'assets/icons/gem.svg',
                      width: 27.w,
                      height: 27.w,
                    ),
                  ),
                  Container(
                      width: double.infinity,
                      height: 39.w,
                      // color: buttonNormal,
                      child: Center(
                        child: Text(
                          "${toPriceKRW(questModel.yachtPointParticipationReward ?? 0)}원",
                          style: questResultRewardTitle.copyWith(
                              fontSize: bodyBigSize,
                              fontFamily: krFont,
                              fontWeight: FontWeight.w500,
                              color: yachtGreen),
                        ),
                      )),
                  Container(
                      width: double.infinity,
                      height: 39.w,
                      // color: buttonNormal,
                      child: Center(
                        child: Text(
                          "${toPriceKRW(questModel.yachtPointSuccessReward ?? 0)}원",
                          style: questResultRewardTitle.copyWith(
                              fontSize: bodyBigSize,
                              fontFamily: krFont,
                              fontWeight: FontWeight.w500,
                              color: yachtGreen),
                        ),
                      )),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SectionHeaderDelegate(this.child, [this.height = 50]);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: primaryBackgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
