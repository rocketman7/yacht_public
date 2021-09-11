import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/chart_price_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/live_quest_price_model.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/live/live_quest_view.dart';
import 'package:yachtOne/screens/quest/quest_widget.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../locator.dart';
import 'live_quest_view_model.dart';

class LiveWidget extends StatelessWidget {
  final int liveQuestIndex;
  final HomeViewModel homeViewModel;
  LiveWidget({Key? key, required this.homeViewModel, required this.liveQuestIndex}) : super(key: key);

  final liveQuestViewModel = Get.find<LiveQuestViewModel>();
  @override
  Widget build(BuildContext context) {
    // Area 차트에 쓰일 색상들
    final List<double> stops = <double>[0.0, 1.0];
    final List<List<Color>> areaGraphColors = [];
    final List<Color> color0 = <Color>[graph0, graph0.withOpacity(0.05)];
    final List<Color> color1 = <Color>[graph1, graph1.withOpacity(0.05)];
    final List<Color> color2 = <Color>[graph2, graph2.withOpacity(0.05)];
    final List<Color> color3 = <Color>[graph3, graph3.withOpacity(0.05)];
    final List<Color> color4 = <Color>[graph4, graph4.withOpacity(0.05)];
    areaGraphColors.add(color0);
    areaGraphColors.add(color1);
    areaGraphColors.add(color2);
    areaGraphColors.add(color3);
    areaGraphColors.add(color4);

    print('live widget $liveQuestIndex');
    return sectionBox(
        height: 250.w,
        width: 232.w,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(primaryPaddingSize, primaryPaddingSize, primaryPaddingSize, 0),
                  child: LiveCardHeader(questModel: homeViewModel.liveQuests[liveQuestIndex])),
              Container(
                height: 110.w,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Obx(
                        () => ClipRRect(
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(12.w), bottomRight: Radius.circular(12.w)),
                          child: SfCartesianChart(
                              margin: EdgeInsets.all(0),
                              borderWidth: 0,
                              plotAreaBorderWidth: 0,
                              primaryXAxis: DateTimeAxis(
                                  minimum: DateTime(2021, 9, 2, 08, 40, 00),
                                  maximum: DateTime(2021, 9, 2, 15, 40, 00),
                                  majorGridLines: MajorGridLines(
                                    width: 0,
                                  ),
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
                                  homeViewModel.liveQuests[liveQuestIndex].investAddresses!.length,
                                  (index) => NumericAxis(
                                      name: index.toString(),
                                      // maximum: 101,
                                      // minimum: 97,
                                      majorGridLines: MajorGridLines(width: 0),
                                      isVisible: false)),
                              series: List.generate(homeViewModel.liveQuests[liveQuestIndex].investAddresses!.length,
                                  (index) {
                                return AreaSeries<ChartPriceModel, DateTime>(
                                  dataSource: liveQuestViewModel.livePrices[liveQuestIndex][index].value.chartPrices,
                                  xValueMapper: (ChartPriceModel chart, _) => stringToDateTime(chart.dateTime!),
                                  gradient: LinearGradient(
                                      colors: areaGraphColors[index],
                                      stops: stops,
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter),
                                  yAxisName: index.toString(),
                                  yValueMapper: (ChartPriceModel chart, _) => chart.normalizedClose,
                                  // gradient: gradientColors0,
                                );
                              })),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14.w,
                      bottom: 14.w,
                      child: glassmorphismContainer(
                        // color: Colors.blue,
                        child: Row(
                          children: [
                            Text(
                              "나의 선택:",
                              style: questTermTextStyle.copyWith(
                                fontSize: 12.w,
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              "상승",
                              style: questTermTextStyle.copyWith(fontSize: 12.w, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                // color: Colors.red,
              ),
            ]));

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

  makeAreaSeriesList(LiveQuestViewModel liveQuestViewModel, int index) {
    // var list = liveQuestViewModel.getListStreamPriceModel(homeViewModel.liveQuests[0].investAddresses);

    // liveQuestViewModel.livePrices.forEach((element) {
    //   element.listen((event) {
    //     print("liveprice binding");
    //     print(event);
    //     // element.refresh();
    //   });
    // });

    // List.generate(3, (index) => StreamBuilder(builder: (context, snapshot) {}));
    // return AreaSeries<ChartPriceModel, DateTime>(
    //   dataSource: temp[0].chartPrices,
    //   xValueMapper: (ChartPriceModel chart, _) => stringToDateTime(chart.dateTime!),
    //   yAxisName: 'second',
    //   yValueMapper: (ChartPriceModel chart, _) => chart.normalizedClose,
    // );

    // return List.generate(homeViewModel.liveQuests[0].investAddresses.length, (index) {
    //   return AreaSeries<ChartPriceModel, DateTime>(
    //     dataSource: liveQuestViewModel.livePrices[index].value.chartPrices,
    //     xValueMapper: (ChartPriceModel chart, _) => stringToDateTime(chart.dateTime!),
    //     yAxisName: 'second',
    //     yValueMapper: (ChartPriceModel chart, _) => chart.normalizedClose,
    //     // gradient: gradientColors0,
    //   );
    // });
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
              '일간 퀘스트',
              style: subheadingStyle,
            ),
            SizedBox(height: 6.w),
            Text(
              '${questModel.title}',
              style: sectionTitle,
            )
          ],
        ),
        SizedBox(
          height: correctHeight(10.w, sectionTitle.fontSize, questTimerStyle.fontSize),
        ),
        Text(
          "01시간 24분 뒤 마감", // temp
          style: questTimerStyle,
        ),
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
