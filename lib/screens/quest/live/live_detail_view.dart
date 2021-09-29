import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/chart_price_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/quest/live/live_quest_view_model.dart';
import 'package:yachtOne/screens/quest/quest_view_model.dart';
import 'package:yachtOne/screens/quest/quest_widget.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../quest_view.dart';

class LiveDetailView extends StatelessWidget {
  LiveDetailView({Key? key}) : super(key: key);

  QuestModel questModel = Get.arguments[0];
  int liveQuestIndex = Get.arguments[1];

  final List<List<Color>> areaGraphColors = [];

  @override
  Widget build(BuildContext context) {
    final QuestViewModel questViewModel = Get.put(QuestViewModel(questModel));
    final stockInfoViewModel = Get.put(
        StockInfoKRViewModel(investAddressModel: questModel.investAddresses![questViewModel.stockInfoIndex.value]));
    final liveQuestViewModel = Get.find<LiveQuestViewModel>();

    areaGraphColors.add(liveAreaColor0);
    areaGraphColors.add(liveAreaColor1);
    areaGraphColors.add(liveAreaColor2);
    areaGraphColors.add(liveAreaColor3);
    areaGraphColors.add(liveAreaColor4);

    List<DateTime> liveChartDays = businessDaysBtwTwoDates(
      questModel.liveStartDateTime.toDate(),
      questModel.liveEndDateTime.toDate(),
    );
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
                              SizedBox(
                                height: correctHeight(20.w, 0.0, questRewardAmoutStyle.fontSize),
                              ),
                              Column(
                                  children: List.generate(questModel.investAddresses!.length, (index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 14.w,
                                          width: 14.w,
                                          decoration: BoxDecoration(
                                            color: areaGraphColors[index][0],
                                            borderRadius: BorderRadius.circular(2.w),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          questModel.investAddresses![index].name,
                                          style: TextStyle(
                                            fontFamily: 'Default',
                                            fontSize: captionSize,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Obx(
                                          () => Text(
                                            toPercentageChange(((liveQuestViewModel.livePrices[liveQuestIndex][index]
                                                            .value.chartPrices.last.normalizedClose ??
                                                        100) -
                                                    100) /
                                                100),
                                            style: detailPriceStyle.copyWith(
                                                color: liveQuestViewModel.livePrices[liveQuestIndex][index].value
                                                            .chartPrices.last.normalizedClose ==
                                                        null
                                                    ? yachtBlack
                                                    : liveQuestViewModel.livePrices[liveQuestIndex][index].value
                                                                .chartPrices.last.normalizedClose! >
                                                            100
                                                        ? bullColorKR
                                                        : liveQuestViewModel.livePrices[liveQuestIndex][index].value
                                                                    .chartPrices.last.normalizedClose ==
                                                                100
                                                            ? yachtBlack
                                                            : bearColorKR),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.w),
                                  ],
                                );
                              })),
                              // 라이브 차트 빅사이즈 버전
                              LayoutBuilder(builder: (context, constraints) {
                                return Container(
                                  height: 210.w,
                                  // color: yachtGrey,
                                  child: Row(
                                    children: List.generate(liveChartDays.length, (liveChartDayIndex) {
                                      if (liveChartDays[liveChartDayIndex].isAfter(DateTime.now())) {
                                        return Stack(
                                          children: [
                                            Container(
                                              height: 210.w,
                                              width: constraints.maxWidth /
                                                  (liveChartDays.length == 0 ? 1 : liveChartDays.length),

                                              // color: Colors.blue,
                                            ),
                                            liveChartDays.length == liveChartDayIndex + 1
                                                ? Container()
                                                : Positioned(
                                                    right: 0,
                                                    child: dashedLine(
                                                        isVertical: true,
                                                        color: yachtGrey.withOpacity(.6),
                                                        length: 210.w,
                                                        dashedLength: 3.w,
                                                        thickness: .5),
                                                  )
                                          ],
                                        );
                                      } else {
                                        return Stack(
                                          children: [
                                            Container(
                                              height: 210.w,
                                              width: constraints.maxWidth /
                                                  (liveChartDays.length == 0 ? 1 : liveChartDays.length),
                                              child: Container(
                                                height: double.infinity,
                                                width: double.infinity,
                                                child: Obx(
                                                  () => ClipRRect(
                                                    borderRadius: BorderRadius.only(
                                                        bottomLeft: Radius.circular(12.w),
                                                        bottomRight: Radius.circular(12.w)),
                                                    child: SfCartesianChart(
                                                        margin: EdgeInsets.all(0),
                                                        borderWidth: 0,
                                                        plotAreaBorderWidth: 0,
                                                        primaryXAxis: DateTimeAxis(
                                                            minimum: DateTime(
                                                              liveChartDays[liveChartDayIndex].year,
                                                              liveChartDays[liveChartDayIndex].month,
                                                              liveChartDays[liveChartDayIndex].day,
                                                              questModel.liveStartDateTime.toDate().hour,
                                                              questModel.liveStartDateTime.toDate().minute,
                                                              questModel.liveStartDateTime.toDate().second,
                                                            ),

                                                            //  homeViewModel.liveQuests[liveQuestIndex].liveStartDateTime.toDate().hour, ,
                                                            maximum: DateTime(
                                                              liveChartDays[liveChartDayIndex].year,
                                                              liveChartDays[liveChartDayIndex].month,
                                                              liveChartDays[liveChartDayIndex].day,
                                                              questModel.liveEndDateTime.toDate().hour,
                                                              questModel.liveEndDateTime.toDate().minute,
                                                              questModel.liveEndDateTime.toDate().second,
                                                            ),
                                                            majorGridLines: MajorGridLines(
                                                              width: 0,
                                                            ),
                                                            // intervalType: DateTimeIntervalType.days,
                                                            // interval: 10,
                                                            isVisible: false),
                                                        primaryYAxis: NumericAxis(
                                                            // maximum: 176000,
                                                            // minimum: 168000,
                                                            // maximum: chartViewModel.maxPrice!,
                                                            // minimum: (5 * chartViewModel.minPrice! -
                                                            //         chartViewModel.maxPrice!) /
                                                            //     4,
                                                            // chartViewModel.minPrice! *
                                                            //     0.97, // 차트에 그려지는 PriceChartModel의 low중 min값 받아서 영역의 상단 4/5에만 그려지도록 maximum 값 설정
                                                            majorGridLines: MajorGridLines(width: 0),
                                                            isVisible: false),
                                                        axes: List.generate(
                                                            questModel.investAddresses!.length,
                                                            (index) => NumericAxis(
                                                                name: index.toString(),
                                                                // maximum: 101,
                                                                // minimum: 97,
                                                                majorGridLines: MajorGridLines(width: 0),
                                                                isVisible: false)),
                                                        series:
                                                            List.generate(questModel.investAddresses!.length, (index) {
                                                          return AreaSeries<ChartPriceModel, DateTime>(
                                                            dataSource: liveQuestViewModel
                                                                .livePrices[liveQuestIndex][index].value.chartPrices,
                                                            xValueMapper: (ChartPriceModel chart, _) =>
                                                                stringToDateTime(chart.dateTime!),
                                                            gradient: LinearGradient(
                                                                colors: areaGraphColors[index],
                                                                stops: stops,
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter),
                                                            yAxisName: index.toString(),
                                                            yValueMapper: (ChartPriceModel chart, _) =>
                                                                chart.normalizedClose,
                                                            // gradient: gradientColors0,
                                                          );
                                                        })),
                                                  ),
                                                ),
                                              ),

                                              // Positioned(
                                              //   left: 14.w,
                                              //   bottom: 14.w,
                                              //   child: glassmorphismContainer(
                                              //     // color: Colors.blue,
                                              //     child: Row(
                                              //       children: [
                                              //         Text(
                                              //           "나의 선택:",
                                              //           style: questTermTextStyle.copyWith(
                                              //             fontSize: 12.w,
                                              //           ),
                                              //         ),
                                              //         SizedBox(
                                              //           width: 4.w,
                                              //         ),
                                              //         Text(
                                              //           "상승",
                                              //           style: questTermTextStyle.copyWith(fontSize: 12.w, fontWeight: FontWeight.w700),
                                              //         ),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // )

                                              // color: Colors.red,
                                            ),
                                            liveChartDays.length == liveChartDayIndex + 1
                                                ? Container()
                                                : Positioned(
                                                    right: 0,
                                                    child: dashedLine(
                                                        isVertical: true,
                                                        color: yachtGrey.withOpacity(.6),
                                                        length: 210.w,
                                                        dashedLength: 3.w,
                                                        thickness: .5),
                                                  )
                                          ],
                                        );
                                      }
                                    }),
                                  ),
                                );
                              }),

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
