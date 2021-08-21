import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:yachtOne/models/quest_model.dart';

import 'package:yachtOne/screens/home/quest_widget.dart';
import 'package:yachtOne/screens/quest/quest_view_model.dart';

import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import '../home/quest_widget.dart';
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

    final stockInfoViewModel = Get.put(StockInfoKRViewModel(
        stockAddressModel:
            questModel.stockAddress[questViewModel.stockInfoIndex.value]));
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
      // ClipRect(
      //     child: BackdropFilter(
      //   filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      //   child: Opacity(
      //       opacity: 0.8,
      //       child: Container(
      //         // Don't wrap this in any SafeArea widgets, use padding instead
      //         // padding: EdgeInsets.only(top: safeAreaPadding.top),
      //         // height: maxExtent,
      //         color: primaryBackgroundColor,
      //         child: Padding(
      //           padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
      //           child: Center(
      //               child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.end,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(
      //                 child: Text(
      //                   "장한나",
      //                   style: homeHeaderName,
      //                 ),
      //               ),
      //               Container(
      //                 // color: Colors.blue,
      //                 child: Text(" 님의 요트", style: homeHeaderAfterName),
      //               ),
      //             ],
      //           )),
      //         ),
      //         // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
      //         // child: Stack(
      //         //   clipBehavior: Clip.none,
      //         //   children: <Widget>[
      //         //     Positioned(
      //         //       bottom: 0,
      //         //       left: 0,
      //         //       right: 0,
      //         //       child: AppBar(
      //         //         primary: true,
      //         //         elevation: 0,
      //         //         backgroundColor: Colors.transparent,
      //         //         title: Text("Translucent App Bar"),
      //         //       ),
      //         //     )
      //         // ],
      //         // ),
      //       )),
      // )),

      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: primaryBackgroundColor,
                pinned: true,
                title: Text(
                  "퀘스트 참여하기",
                  style: homeHeaderAfterName,
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
                        style: homeModuleTitleTextStyle,
                      ),
                      btwHomeModuleTitleBox,
                      Container(
                          padding:
                              moduleBoxPadding(questTermTextStyle.fontSize!),
                          decoration: primaryBoxDecoration.copyWith(
                              boxShadow: [primaryBoxShadow],
                              color: homeModuleBoxBackgroundColor),
                          child: Column(
                            children: [
                              QuestCardHeader(
                                questModel: questModel,
                              ),
                              btwHomeModuleTitleBox,
                              QuestCardRewards(questModel: questModel),
                              Divider(color: primaryFontColor),
                              Text(
                                questModel.questDescription,
                                style: detailedContentTextStyle,
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
                  style: homeModuleTitleTextStyle,
                ),
              )),
              // 스크롤 내리면 위에 붙을 퀘스트 선택지 기업 목록
              SliverPersistentHeader(
                delegate: SectionHeaderDelegate(
                    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: questModel.stockAddress.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  questViewModel.changeIndex(index);
                                  stockInfoViewModel.changeStockAddressModel(
                                      questModel.stockAddress[index]);
                                },
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(14.w, 0, 4.w, 0),
                                  child: Obx(
                                    () => Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 6.w),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: questViewModel
                                                          .stockInfoIndex
                                                          .value ==
                                                      index
                                                  ? BorderSide(
                                                      width: 3.w,
                                                      color: seaBlue)
                                                  : BorderSide.none)),
                                      child: Obx(() => Text(
                                          questModel.stockAddress[index].name,
                                          style: buttonTextStyle.copyWith(
                                              color: questViewModel
                                                          .stockInfoIndex
                                                          .value ==
                                                      index
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
                  decoration: primaryBoxDecoration.copyWith(
                      boxShadow: [primaryBoxShadow],
                      color: homeModuleBoxBackgroundColor),
                  child: GetBuilder<QuestViewModel>(
                    builder: (questViewModel) {
                      return StockInfoKRView(
                          stockAddressModel: questModel.stockAddress[
                              questViewModel.stockInfoIndex.value]);
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

            List<num>? answers = questViewModel.userQuestModel.value!.selection;
            // print('answers from server: $toggleList');
            return questViewModel.isSelectingSheetShowing.value
                ? Positioned(
                    left: 14.w,
                    right: 14.w,
                    bottom: 20.w + 60.w + 20.w,
                    child: Container(
                      // color: Colors.white,
                      width: double.infinity,
                      // height: 100,
                      padding: EdgeInsets.all(14.w),
                      decoration: (primaryBoxDecoration
                          .copyWith(boxShadow: [primaryBoxShadow])),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () =>
                                  questViewModel.isSelectingSheetShowing(false),
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
                          SizedBox(
                              height: reducedPaddingWhenTextIsBelow(
                                  8.w, questTitleTextStyle.fontSize!)),
                          Padding(
                            padding: EdgeInsets.all(16.0.w),
                            child: Text(questModel.selectInstruction,
                                style: questTitleTextStyle,
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(
                              height: reducedPaddingWhenTextIsBelow(
                                  16.w, questTitleTextStyle.fontSize!)),
                          Divider(color: primaryFontColor.withOpacity(.4)),
                          Column(
                            children: List.generate(
                                questModel.stockAddress.length,
                                (index) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(
                                          () => InkWell(
                                            onTap: () {
                                              questViewModel
                                                  .toggleUserSelect(index);
                                              print(
                                                  '$index is change to ${questViewModel.toggleList}');
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(8.0.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    questViewModel.toggleList[
                                                                index] ==
                                                            false
                                                        ? 'assets/buttons/radio_inactive.png'
                                                        : 'assets/buttons/radio_active.png',
                                                    width: 34.w,
                                                    height: 34.w,
                                                  ),
                                                  SizedBox(width: 8.w),
                                                  Text(
                                                    questModel
                                                        .stockAddress[index]
                                                        .name,
                                                    style:
                                                        detailedContentTextStyle
                                                            .copyWith(
                                                                fontSize: 18.w),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(
                                            color: primaryFontColor
                                                .withOpacity(.4)),
                                      ],
                                    )),
                          ),
                          SizedBox(height: 12.w)
                        ],
                      ),
                    ))
                : Container();
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
                      ;
                    } else {
                      questViewModel.updateUserQuest();
                      Get.snackbar(" ", "저장되었습니다.",
                          snackPosition: SnackPosition.BOTTOM);
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
                              ? "나의 예측 저장"
                              : (questViewModel.userQuestModel.value == null ||
                                      questViewModel.userQuestModel.value!
                                              .selectDateTime ==
                                          null)
                                  ? "예측 확정하기"
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
