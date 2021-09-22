import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:yachtOne/models/quest_model.dart';

import 'package:yachtOne/screens/quest/quest_widget.dart';
import 'package:yachtOne/screens/quest/quest_view_model.dart';

import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
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
                            children: [
                              QuestCardHeader(
                                questModel: questModel,
                              ),
                              btwHomeModuleTitleBox,
                              QuestCardRewards(questModel: questModel),
                              SizedBox(
                                height: correctHeight(30.w, 0.0, detailedContentTextStyle.fontSize),
                              ),
                              Text(
                                questModel.questDescription,
                                style: questDescription,
                              ) //temp
                            ],
                          )),
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
                                                  ? BorderSide(width: 3.w, color: seaBlue)
                                                  : BorderSide.none)),
                                      child: Obx(() => Text(questModel.investAddresses![index].name,
                                          style: buttonTextStyle.copyWith(
                                              color: questViewModel.stockInfoIndex.value == index
                                                  ? seaBlue
                                                  : seaBlue.withOpacity(.4)))),
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
                padding: textTopPadding(homeModuleTitleTextStyle.fontSize!),
                child:
                    // 퀘스트 종목간 선택 row

                    Container(
                  // height: 1800, // temp
                  padding: moduleBoxPadding(questTermTextStyle.fontSize!),
                  decoration:
                      primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow], color: homeModuleBoxBackgroundColor),
                  child: GetBuilder<QuestViewModel>(
                    builder: (questViewModel) {
                      return StockInfoKRView(
                          investAddressModel: questModel.investAddresses![questViewModel.stockInfoIndex.value]);
                    },
                  ),
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
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: backgroundWhenPopup,
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
                bottom: 20.w,
                child: GestureDetector(
                  onTap: () {
                    if (questViewModel.isSelectingSheetShowing.value == false) {
                      questViewModel.isSelectingSheetShowing(true);
                      questViewModel.syncUserSelect();
                    } else {
                      questViewModel.updateUserQuest();
                      Future.delayed(Duration(milliseconds: 600)).then((_) {
                        questViewModel.isSelectingSheetShowing(false);
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
                          color: activatedButtonColor.withOpacity(.85),
                        ),
                        child: Center(
                            child: Text(
                          questViewModel.isSelectingSheetShowing.value
                              ? "예측 확정하기"
                              : (questViewModel.thisUserQuestModel.value == null ||
                                      questViewModel.thisUserQuestModel.value!.selectDateTime == null)
                                  ? "예측하기"
                                  : "예측 변경하기",
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

  Positioned oldSelectBottomSheet(QuestViewModel questViewModel) {
    return Positioned(
        left: 14.w,
        right: 14.w,
        bottom: 20.w + 60.w + 20.w,
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
                  onTap: () => questViewModel.isSelectingSheetShowing(false),
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: 50.w,
                    color: Colors.yellow.withOpacity(.2),
                    child: Icon(
                      Icons.close,
                      color: primaryFontColor,
                      size: 30.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: reducedPaddingWhenTextIsBelow(8.w, questTitleTextStyle.fontSize!)),
              Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Text(questModel.selectInstruction, style: questTitleTextStyle, textAlign: TextAlign.center),
              ),
              SizedBox(height: reducedPaddingWhenTextIsBelow(16.w, questTitleTextStyle.fontSize!)),
              Divider(color: primaryFontColor.withOpacity(.4)),
              Column(
                children: List.generate(
                    questModel.investAddresses!.length,
                    (index) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => InkWell(
                                onTap: () {
                                  questViewModel.toggleUserSelect(index);
                                  print('$index is change to ${questViewModel.toggleList}');
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.0.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        questViewModel.toggleList[index] == false
                                            ? 'assets/buttons/radio_inactive.png'
                                            : 'assets/buttons/radio_active.png',
                                        width: 34.w,
                                        height: 34.w,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        questModel.investAddresses![index].name,
                                        style: detailedContentTextStyle.copyWith(fontSize: 18.w),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(color: primaryFontColor.withOpacity(.4)),
                          ],
                        )),
              ),
              SizedBox(height: 12.w)
            ],
          ),
        ));
  }

  AnimatedPositioned newSelectBottomSheet(QuestViewModel questViewModel) {
    return AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        left: 14.w,
        right: 14.w,
        bottom: questViewModel.isSelectingSheetShowing.value ? (20.w + 60.w + 20.w) : -500.w,
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
                padding: EdgeInsets.all(16.0.w),
                child: Text(questModel.selectInstruction, style: questTitleTextStyle, textAlign: TextAlign.center),
              ),
              SizedBox(height: reducedPaddingWhenTextIsBelow(16.w, questTitleTextStyle.fontSize!)),
              questModel.selectMode == 'pickone'
                  ? Row(
                      children: List.generate(questModel.investAddresses!.length, (index) {
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
                                  color: questViewModel.toggleList[index] ? yachtRed : white),
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
                                          color: questViewModel.toggleList[index] ? white : yachtBlack),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (index == 0) SizedBox(width: primaryPaddingSize)
                        ],
                      );
                    }))
                  : questModel.selectMode == 'updown'
                      ? Row(
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
                                      color: index == 0 && questViewModel.toggleList[0]
                                          ? yachtRed
                                          : index == 1 && questViewModel.toggleList[1]
                                              ? seaBlue
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
                                                      color: questViewModel.toggleList[0] ? white : yachtRed)
                                                  : Image.asset('assets/icons/quest_select_down.png',
                                                      color: questViewModel.toggleList[1] ? white : seaBlue)),
                                        ),
                                        Text(
                                          questModel.choices![index],
                                          style: yachtChoiceBoxName.copyWith(
                                              color: questViewModel.toggleList[index] ? white : yachtBlack),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (index == 0) SizedBox(width: primaryPaddingSize)
                            ],
                          );
                        }))
                      : questModel.selectMode == 'order'
                          ? Row(
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
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        onReorder: (oldIndex, newIndex) {
                                          questViewModel.reorderUserSelect(oldIndex, newIndex);
                                          // print('old' + oldIndex.toString());
                                          // print('new' + newIndex.toString());
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
                                                          child: questViewModel.logoImage.length > 0
                                                              ? questViewModel
                                                                  .logoImage[questViewModel.orderList[index]]
                                                              : Container()),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    // orderList 없을 때 처리 필요
                                                    Obx(() => Text(
                                                          questModel
                                                              .investAddresses![questViewModel.orderList[index]].name,
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
                            )
                          : questModel.selectMode == 'updown_many'
                              ? Container(
                                  constraints: BoxConstraints.loose(
                                    Size(double.infinity, 300.w),
                                  ),
                                  child: ListView.builder(
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
                                                  Container(
                                                    height: 27.w,
                                                    width: 27.w,
                                                    color: Colors.blue,
                                                  ),
                                                  SizedBox(width: 3.w),
                                                  Text(questModel.investAddresses![index].name,
                                                      style: yachtChoiceBoxName)
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    "기준 가격",
                                                    style: TextStyle(fontSize: captionSize, fontFamily: 'Default'),
                                                  ),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Text(
                                                      questModel.investAddresses![index].basePrice == null
                                                          ? 0.toString()
                                                          : questModel.investAddresses![index].basePrice.toString(),
                                                      style: yachtChoiceBoxName.copyWith(
                                                        fontWeight: FontWeight.w600,
                                                      ))
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
                                                                            questViewModel.updownManyList[index] == 1
                                                                        ? seaBlue
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
                                                                                color: questViewModel
                                                                                            .updownManyList[index] ==
                                                                                        0
                                                                                    ? white
                                                                                    : yachtRed)
                                                                            : Image.asset(
                                                                                'assets/icons/quest_select_down.png',
                                                                                color: questViewModel
                                                                                            .updownManyList[index] ==
                                                                                        1
                                                                                    ? white
                                                                                    : seaBlue)),
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
                                )

                              //   ],
                              // )
                              : Container(),

              SizedBox(height: 12.w)
            ],
          ),
        ));
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
