import 'dart:async';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/chart_price_model.dart';
import 'package:yachtOne/models/live_quest_price_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/quest/live/live_detail_view.dart';
import 'package:yachtOne/screens/quest/live/live_quest_view_model.dart';
import 'package:yachtOne/screens/quest/quest_widget.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

// import 'live_quest_view_model.dart';

class LiveWidget extends StatelessWidget {
  final QuestModel questModel;
  final int liveQuestIndex;
  LiveWidget({
    Key? key,
    required this.questModel,
    required this.liveQuestIndex,
  }) : super(key: key);
  final liveQuestViewModel = Get.find<LiveQuestViewModel>();
  final RxBool isShowingLive = true.obs;

  List<ChartPriceModel> lightenChart(List<ChartPriceModel> prices) {
    List<ChartPriceModel> temp = [];
    for (int i = 0; i < prices.length; i++) {
      if (i % 40 == 0) temp.add(prices[i]);
    }

    return temp;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> liveChartDays = businessDaysBtwTwoDates(
      questModel.liveStartDateTime.toDate(),
      questModel.liveEndDateTime.toDate(),
    );

    return GestureDetector(
      onTap: () {
        print('tap');
        Get.to(() => LiveDetailView(), arguments: [questModel, liveQuestIndex]);
      },
      child: sectionBox(
          height: 250.w,
          width: 232.w,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(
                      primaryPaddingSize,
                      primaryPaddingSize,
                      primaryPaddingSize,
                      0,
                    ),
                    child: LiveCardHeader(questModel: questModel)),
                Obx(() => !isShowingLive.value
                    ? Container(
                        height: 110.w,
                        width: 232.w,
                        child: TextButton(
                          onPressed: () {
                            isShowingLive(true);
                          },
                          child: Text("SHOW LIVE"),
                        ))
                    : Row(
                        children: List.generate(liveChartDays.length, (liveChartDayIndex) {
                          // print(DateTime.now());
                          if (liveChartDays[liveChartDayIndex].isAfter(DateTime.now())) {
                            return Stack(
                              children: [
                                Container(
                                  height: 110.w,
                                  width: 232.w / (liveChartDays.length == 0 ? 1 : liveChartDays.length),

                                  // color: Colors.blue,
                                ),
                                liveChartDays.length == liveChartDayIndex + 1
                                    ? Container()
                                    : Positioned(
                                        right: 0,
                                        child: dashedLine(
                                            isVertical: true,
                                            color: yachtGrey.withOpacity(.6),
                                            length: 110.w,
                                            dashedLength: 3.w,
                                            thickness: .5),
                                      )
                              ],
                            );
                          } else {
                            return Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print('tap');
                                    Get.to(() => LiveDetailView(), arguments: [questModel, liveQuestIndex]);
                                  },
                                  child: Container(
                                    height: 110.w,
                                    width: 232.w / (liveChartDays.length == 0 ? 1 : liveChartDays.length),
                                    child: Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: Obx(
                                        () =>
                                            // ClipRRect(
                                            //   borderRadius: BorderRadius.only(
                                            //       bottomLeft: Radius.circular(12.w), bottomRight: Radius.circular(12.w)),
                                            SfCartesianChart(
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
                                                series: List.generate(questModel.investAddresses!.length, (index) {
                                                  return FastLineSeries<ChartPriceModel, DateTime>(
                                                    width: 1.2,
                                                    animationDuration: 0,
                                                    dataSource: lightenChart(liveQuestViewModel
                                                        .livePrices[liveQuestIndex][index].value.chartPrices),
                                                    xValueMapper: (ChartPriceModel chart, _) =>
                                                        stringToDateTime(chart.dateTime!),
                                                    color: lineChartColors[index],
                                                    // gradient: LinearGradient(
                                                    //     colors: areaGraphColors[index],
                                                    //     stops: stops,
                                                    //     begin: Alignment.topCenter,
                                                    //     end: Alignment.bottomCenter),
                                                    yAxisName: index.toString(),
                                                    yValueMapper: (ChartPriceModel chart, _) => chart.normalizedClose,
                                                    // gradient: gradientColors0,
                                                  );
                                                })),
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
                                ),
                                liveChartDays.length == liveChartDayIndex + 1
                                    ? Container()
                                    : Positioned(
                                        right: 0,
                                        child: dashedLine(
                                            isVertical: true,
                                            color: yachtGrey.withOpacity(.6),
                                            length: 110.w,
                                            dashedLength: 3.w,
                                            thickness: .5),
                                      )
                              ],
                            );
                          }
                        }),
                      )),
              ])),
    );

    // Container(
    //     height: 250.w,
    //     width: 232.w,
    //     decoration: primaryBoxDecoration.copyWith(
    //       boxShadow: [primaryBoxShadow],
    //       color: homeModuleBoxBackgroundColor,
    //     ),
    //     child:

    //     Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             padding: moduleBoxPadding(questTermTextStyle.fontSize!),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.max,
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   // '${questModel.category} 퀘스트',
    //                   '일간 퀘스트',
    //                   style: questTermTextStyle,
    //                 ),
    //                 SizedBox(
    //                     height: reducedPaddingWhenTextIsBothSide(
    //                         18.w,
    //                         questTermTextStyle.fontSize!,
    //                         questTitleTextStyle.fontSize!)),
    //                 Text(
    //                   '${questModel.title}',
    //                   style: questTitleTextStyle,
    //                 ),
    //                 btwText(
    //                   questTitleTextStyle.fontSize!,
    //                   questTimeLeftTextStyle.fontSize!,
    //                 ),
    //                 Text(
    //                   "01시간 24분 뒤 마감", // temp
    //                   style: questTimeLeftTextStyle,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             height: 110.w,
    //             width: double.infinity,
    //             child: Stack(
    //               children: [
    //                 Container(
    //                   height: double.infinity,
    //                   width: double.infinity,

    //                   // color: Colors.lightGreen,
    //                   // color: Colors.blue,
    //                   child: StreamBuilder<List<TempRealtimeModel>>(
    //                     stream: _firestoreService.getTempRealtimePrice0(),
    //                     builder: (context, snapshot0) => !snapshot0.hasData
    //                         ? Container(
    //                             // color: Colors.yellow,
    //                             )
    //                         : StreamBuilder<List<TempRealtimeModel>>(
    //                             stream:
    //                                 _firestoreService.getTempRealtimePrice(),
    //                             builder: (context, snapshot) {
    //                               if (!snapshot.hasData) {
    //                                 return Container(
    //                                     // color: Colors.yellow,
    //                                     );
    //                               } else {
    //                                 final List<Color> color0 = <Color>[];
    //                                 color0.add(yachtRed.withOpacity(.5));
    //                                 // color0.add(yachtRed.withOpacity(.1));
    //                                 color0.add(yachtRed.withOpacity(.1));

    //                                 final List<Color> color = <Color>[];
    //                                 color.add(seaBlue.withOpacity(.5));
    //                                 // color.add(seaBlue.withOpacity(.1));
    //                                 color.add(seaBlue.withOpacity(.1));

    //                                 final List<double> stops = <double>[];
    //                                 stops.add(0.0);
    //                                 stops.add(0.5);
    //                                 stops.add(1.0);

    //                                 final LinearGradient gradientColors =
    //                                     LinearGradient(
    //                                   colors: color,
    //                                   begin: Alignment(0, 0),
    //                                   end: Alignment.bottomCenter,
    //                                 );

    //                                 final LinearGradient gradientColors0 =
    //                                     LinearGradient(
    //                                   colors: color0,
    //                                   begin: Alignment(0, 0),
    //                                   end: Alignment.bottomCenter,
    //                                 );
    //                                 return SfCartesianChart(
    //                                     margin: EdgeInsets.all(0),
    //                                     borderWidth: 0,
    //                                     plotAreaBorderWidth: 0,
    //                                     primaryXAxis: DateTimeAxis(
    //                                         minimum: DateTime(
    //                                             2021, 7, 29, 08, 40, 00),
    //                                         maximum: DateTime(
    //                                             2021, 7, 29, 15, 40, 00),
    //                                         majorGridLines: MajorGridLines(
    //                                           width: 0,
    //                                         ),
    //                                         isVisible: false),
    //                                     primaryYAxis: NumericAxis(
    //                                         maximum: 176000,
    //                                         minimum: 168000,
    //                                         // maximum: chartViewModel.maxPrice!,
    //                                         // minimum: (5 * chartViewModel.minPrice! -
    //                                         //         chartViewModel.maxPrice!) /
    //                                         //     4,
    //                                         // chartViewModel.minPrice! *
    //                                         //     0.97, // 차트에 그려지는 PriceChartModel의 low중 min값 받아서 영역의 상단 4/5에만 그려지도록 maximum 값 설정
    //                                         majorGridLines:
    //                                             MajorGridLines(width: 0),
    //                                         isVisible: false),
    //                                     axes: [
    //                                       NumericAxis(
    //                                           name: 'second',
    //                                           maximum: 82600,
    //                                           minimum: 80000,
    //                                           majorGridLines:
    //                                               MajorGridLines(width: 0),
    //                                           isVisible: false)
    //                                     ],
    //                                     series: [
    //                                       AreaSeries<TempRealtimeModel,
    //                                           DateTime>(
    //                                         dataSource: snapshot.data!,
    //                                         xValueMapper:
    //                                             (TempRealtimeModel chart, _) {
    //                                           return chart.createdAt!.toDate();
    //                                         },
    //                                         yValueMapper:
    //                                             (TempRealtimeModel chart, _) =>
    //                                                 chart.price,
    //                                         gradient: gradientColors,
    //                                       ),
    //                                       AreaSeries<TempRealtimeModel,
    //                                           DateTime>(
    //                                         dataSource: snapshot0.data!,
    //                                         xValueMapper:
    //                                             (TempRealtimeModel chart, _) {
    //                                           return chart.createdAt!.toDate();
    //                                         },
    //                                         yAxisName: 'second',
    //                                         yValueMapper:
    //                                             (TempRealtimeModel chart, _) =>
    //                                                 chart.price,
    //                                         gradient: gradientColors0,
    //                                       ),
    //                                     ]);
    //                               }
    //                             }),
    //                   ),
    //                 ),
    //                 Positioned(
    //                   left: 14.w,
    //                   bottom: 14.w,
    //                   child: glassmorphismContainer(
    //                     // color: Colors.blue,
    //                     child: Row(
    //                       children: [
    //                         Text(
    //                           "나의 선택:",
    //                           style: questTermTextStyle.copyWith(
    //                             fontSize: 12.w,
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           width: 4.w,
    //                         ),
    //                         Text(
    //                           "상승",
    //                           style: questTermTextStyle.copyWith(
    //                               fontSize: 12.w, fontWeight: FontWeight.w700),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //             // color: Colors.red,
    //           ),
    //         ]));
  }
}

class LiveCardHeader extends StatelessWidget {
  const LiveCardHeader({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  final QuestModel questModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // '${questModel.category} 퀘스트',
              questModel.category,
              style: subheadingStyle,
            ),
            SizedBox(height: 6.w),
            Text(
              '${questModel.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: sectionTitle,
            )
          ],
        ),
        SizedBox(
          height: correctHeight(10.w, sectionTitle.fontSize, questTimerStyle.fontSize),
        ),

        LiveToEndCounter(questModel: questModel), // temp

        SizedBox(
          height: correctHeight(10.w, questTimerStyle.fontSize, questRewardTextStyle.fontSize),
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/manypeople.svg',
              width: 17.w,
              color: yachtBlack,
            ),
            SizedBox(width: 4.w),
            questModel.counts == null
                ? Text(
                    '0',
                    style: questRewardAmoutStyle.copyWith(fontSize: captionSize),
                  )
                : Text(
                    '${questModel.counts!.fold<int>(0, (previous, current) => previous + current)}',
                    style: questRewardAmoutStyle.copyWith(fontSize: captionSize),
                  )
          ],
        ),
      ],
    );
  }
}

class LiveToEndCounter extends StatefulWidget {
  final QuestModel questModel;
  LiveToEndCounter({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  @override
  State<LiveToEndCounter> createState() => _LiveToEndCounterState();
}

class _LiveToEndCounterState extends State<LiveToEndCounter> {
  // 타이머 1초마다 작동
  Timer? _everySecond;
  // 남은 시간 보여줌
  RxString timeToEnd = "".obs;
  DateTime now = DateTime.now();

  @override
  void initState() {
    _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {
      now = DateTime.now();
      timeLeft();
    });
    // TODO: implement initState
    super.initState();
  }

  void timeLeft() {
    if (widget.questModel.questEndDateTime == null) {
      timeToEnd("마감시한 없음");
    } else {
      Duration timeLeft = widget.questModel.liveEndDateTime.toDate().difference(now);
      timeToEnd('${countDown(timeLeft)} 뒤 마감');
    }
    // return countDown(timeLeft);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
          timeToEnd.value, // temp
          style: questTimerStyle,
        ));
  }
}
