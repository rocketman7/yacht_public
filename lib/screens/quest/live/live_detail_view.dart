import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/quest/quest_view_model.dart';
import 'package:yachtOne/screens/quest/quest_widget.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../quest_view.dart';

class LiveDetailView extends StatelessWidget {
  LiveDetailView({Key? key}) : super(key: key);

  QuestModel questModel = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final QuestViewModel questViewModel = Get.put(QuestViewModel(questModel));
    final stockInfoViewModel = Get.put(
        StockInfoKRViewModel(investAddressModel: questModel.investAddresses![questViewModel.stockInfoIndex.value]));
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: primaryBackgroundColor,
                pinned: true,
                title: Text(
                  "퀘스트 생중계",
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
                        "퀘스트 진행 현황",
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
                                height: correctHeight(30.w, 0.0, detailedContentTextStyle.fontSize),
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
                                                  ? yachtViolet
                                                  : yachtViolet.withOpacity(.4)))),
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
              // SliverToBoxAdapter(
              //     child: SizedBox(
              //   height: 88.w,
              // )),
            ],
          ),
          // 선택 확정하기 눌렀을 때 배경 회색처리, 그 때 배경 아무데나 눌러도 원래 퀘스트뷰 화면으로 복귀
          // Obx(() => questViewModel.isSelectingSheetShowing.value
          //     ? GestureDetector(
          //         onTap: () {
          //           questViewModel.isSelectingSheetShowing(false);
          //         },
          //         child: Container(
          //           height: double.infinity,
          //           width: double.infinity,
          //           color: backgroundWhenPopup,
          //         ),
          //       )
          //     : Container()),
          // // 최종선택하기 위한 custom bottom sheet
          // Obx(() {
          //   // selectMode에 따라 표기 다르게 설정. 일단 'one' 이라고 가정
          //   // if (questModel.selectMode == 'one') {

          //   // }

          //   // List<num>? answers = questViewModel.userQuestModel.value!.selection;
          //   // print('answers from server: $toggleList');
          //   return newSelectBottomSheet(questViewModel);
          // }),
          // Obx(
          //   () => Positioned(
          //       left: 14.w,
          //       right: 14.w,
          //       bottom: 20.w,
          //       child: GestureDetector(
          //         onTap: () {
          //           if (questViewModel.isSelectingSheetShowing.value == false) {
          //             questViewModel.isSelectingSheetShowing(true);
          //             questViewModel.syncUserSelect();
          //           } else {
          //             questViewModel.updateUserQuest();
          //             Future.delayed(Duration(milliseconds: 600)).then((_) {
          //               questViewModel.isSelectingSheetShowing(false);
          //             });
          //             yachtSnackBarFromBottom("저장되었습니다.");
          //           }
          //           ;
          //         },
          //         child: ClipRect(
          //           child: BackdropFilter(
          //             filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          //             child: Container(
          //               height: 60.w,
          //               width: double.infinity,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(50.w),
          //                 color: yachtViolet80.withOpacity(.8),
          //               ),
          //               child: Center(
          //                   child: Text(
          //                 questViewModel.isSelectingSheetShowing.value
          //                     ? "예측 확정하기"
          //                     : (questViewModel.thisUserQuestModel.value == null ||
          //                             questViewModel.thisUserQuestModel.value!.selectDateTime == null)
          //                         ? "예측하기"
          //                         : "예측 변경하기",
          //                 style: buttonTextStyle.copyWith(fontSize: 24.w),
          //               )),
          //             ),
          //           ),
          //         ),
          //       )),
          // ),
        ],
      ),
    );
  }
}
