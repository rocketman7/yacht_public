import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/corporation_model.dart';
import 'package:yachtOne/screens/quest/quest_view_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import '../../../styles/style_constants.dart';
import '../../../handlers/date_time_handler.dart';
import '../../../models/chart_price_model.dart';
import 'chart_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Color chartTrackingColor(ChartViewModel chartViewModel) {
  return (chartViewModel.close.value / chartViewModel.chartPrices!.last.close! - 1) > 0
      ? bullColorKR
      : (chartViewModel.close.value / chartViewModel.chartPrices!.last.close! - 1) < 0
          ? bearColorKR
          : yachtWhite;
}

Color chartClosePriceColor(ChartViewModel chartViewModel) {
  return (chartViewModel.chartPrices!.first.close! - chartViewModel.chartPrices!.last.close!) > 0
      ? bullColorKR
      : (chartViewModel.chartPrices!.first.close! - chartViewModel.chartPrices!.last.close!) < 0
          ? bearColorKR
          : yachtWhite;
}

class NewChartView extends StatelessWidget {
  final InvestAddressModel investAddressModel;
  final ChartViewModel chartViewModel;
  // onTrackballPositionChanging에서 X Position이 변했는지 체크하기 위해 직전 X Position을 저장
  Color chartTrackingColor(ChartViewModel chartViewModel) {
    return (chartViewModel.close.value / chartViewModel.chartPrices!.last.close! - 1) > 0
        ? bullColorKR
        : (chartViewModel.close.value / chartViewModel.chartPrices!.last.close! - 1) < 0
            ? bearColorKR
            : yachtWhite;
  }

  Color chartClosePriceColor(ChartViewModel chartViewModel) {
    return (chartViewModel.chartPrices!.first.close! - chartViewModel.chartPrices!.last.close!) > 0
        ? bullColorKR
        : (chartViewModel.chartPrices!.first.close! - chartViewModel.chartPrices!.last.close!) < 0
            ? bearColorKR
            : yachtWhite;
  }

  NewChartView({Key? key, required this.investAddressModel, required this.chartViewModel}) : super(key: key);

  double previousXPosition = 0;

  @override
  Widget build(BuildContext context) {
    // ChartViewModel chartViewModel =
    //     Get.put(ChartViewModel(investAddressModel: investAddressModel));

    // Get.put(ChartViewModel(field: field, market: market, issueCode: issueCode));
    // Mixin Builder로 하니까 차트 onTap마다 차트가 다시 그려졌음.
    // 명확하게 update를 받아오는 부분에서 GetBuilder를 쓰거나
    // 아니면 필요한 위젯 상단에 Obx로 obs 밸류 가져오는 방법이 좋을듯
    // Mixin Builder를 써서가 아니라 MixinBuilder의 Obx 기능이
    // 너무 상단 위젯에 존재해서 그럼.

    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            // 캔들 차트에서 트래킹할 때 보여주는 화면 구현
            () => Stack(children: [
              (chartViewModel.isTracking.value == true && chartViewModel.showingCandleChart.value)
                  ? Opacity(
                      opacity: 1 - chartViewModel.opacity.value < 0 ? 0 : 1 - chartViewModel.opacity.value,
                      child: DetailedPriceDisplayVer2(chartViewModel: chartViewModel),
                    )
                  : SizedBox.shrink(),
              // 트래킹 안할 때 기본 차트 뷰 헤더
              Opacity(
                opacity: !chartViewModel.showingCandleChart.value
                    ? 1
                    : chartViewModel.opacity.value > 0.2
                        ? chartViewModel.opacity.value
                        : 0,
                child: (chartViewModel.isLoading.value) // 로딩 중이면 빈 화면
                    ? Container(
                        height: 120.w,
                        width: double.infinity,
                        // color: Colors.blueGrey.withOpacity(.1),
                      )
                    : Container(
                        height: 120.w,
                        width: double.infinity,
                        // color: Colors.blueGrey.withOpacity(.1),
                        child: MainPriceDisplay(chartViewModel: chartViewModel)),
              ),
            ]),
          ),
          Obx(() => (chartViewModel.isLoading.value == true)
              ? Container(height: 200.w, color: Colors.transparent)
              : Container(
                  height: 200.w,
                  // color: Colors.white,
                  child: Obx(() {
                    // 아래 프린트를 해야 dataSource에 반영되네;;
                    // dataSource에서 분기되는 지점을 method로 따로 빼서 Obx가 제대로 obs value 구독을 못하는 듯
                    print(chartViewModel.chartPrices!.first.close);
                    return SfCartesianChart(
                      // Trackball과 관련된 것들
                      onChartTouchInteractionDown: (_) {
                        chartViewModel.opacityDown();
                      },
                      onTrackballPositionChanging: (TrackballArgs args) {
                        // trackball의 X Position이 변하지 않으면 아무것도 하지 않음
                        // trackball의 X Position이 변했으면 햅틱을 주고 직전 X Position을 업데이트함
                        // if (previousXPosition !=
                        //     args.chartPointInfo.xPosition) {
                        // print(args.chartPointInfo.seriesIndex);
                        if (args.chartPointInfo.seriesIndex == 0 &&
                            previousXPosition != args.chartPointInfo.xPosition) {
                          // Printing Coordinate intersect point of first line
                          HapticFeedback.lightImpact();
                          // print(args.chartPointInfo.chartDataPoint!.x);
                          chartViewModel.onTrackballChanging(args);
                        }
                        if (args.chartPointInfo.seriesIndex == 1) {
                          // Printing Coordinate intersect point of second line
                          // print("second series");
                          chartViewModel.onTrackballChanging(args);
                        }

                        // }
                        previousXPosition = args.chartPointInfo.xPosition!;

                        // if (args.chartPointInfo.seriesIndex == 0) {
                        //   // Printing Coordinate intersect point of first line
                        //   print('x:' +
                        //       args.chartPointInfo.xPosition.toString());
                        //   print('y:' +
                        //       args.chartPointInfo.yPosition.toString());
                        // }
                        // if (args.chartPointInfo.seriesIndex == 1) {
                        //   // Printing Coordinate intersect point of second line
                        //   print('x:' +
                        //       args.chartPointInfo.xPosition.toString());
                        //   print('y:' +
                        //       args.chartPointInfo.yPosition.toString());
                        // }
                      },
                      onChartTouchInteractionUp: (_) {
                        chartViewModel.onTracballEnds();
                        // print("차트에서 손 뗌");
                      },

                      trackballBehavior: TrackballBehavior(
                        enable: true,
                        activationMode: ActivationMode.singleTap,
                        tooltipSettings: InteractiveTooltip(
                          enable: false,
                          // Formatting trackball tooltip text
                          // format: ''
                        ),
                      ),
                      plotAreaBorderWidth: 0,
                      // enableAxisAnimation: true,

                      series: chartViewModel.showingCandleChart.value
                          ? _candleChart(chartViewModel.chartPrices!)
                          : _lineChart(chartViewModel.chartPrices!),
                      primaryXAxis: DateTimeCategoryAxis(
                          isInversed: true,
                          majorGridLines: MajorGridLines(
                            width: 0,
                          ),
                          isVisible: false),
                      primaryYAxis: NumericAxis(
                          maximum: chartViewModel.maxPrice!,
                          minimum: (5 * chartViewModel.minPrice! - chartViewModel.maxPrice!) / 4,
                          // chartViewModel.minPrice! *
                          //     0.97, // 차트에 그려지는 PriceChartModel의 low중 min값 받아서 영역의 상단 4/5에만 그려지도록 maximum 값 설정
                          majorGridLines: MajorGridLines(width: 0),
                          isVisible: false),
                      axes: [
                        NumericAxis(
                            // isInversed: true,
                            // 차트에 그려지는 PriceChartModel의 volume들 중 max값 받아서 영역의 1/5에만 그려지도록 maximum 값 설정
                            maximum: chartViewModel.maxVolume! * 4.5,
                            minimum: 0,
                            majorGridLines: MajorGridLines(width: 0),
                            isVisible: false,
                            name: 'volume'),
                      ],
                      enableSideBySideSeriesPlacement: false,
                    );
                  }),
                )),
          Obx(
            () => chartViewModel.isLoading.value
                ? Container()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(chartViewModel.cycles.length + 1, (index) {
                      return InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();

                          if (index == chartViewModel.cycles.length) {
                            chartViewModel.toggleChartType();
                          } else {
                            if (chartViewModel.selectedCycle.value != index) {
                              chartViewModel.selectedCycle(index);
                              chartViewModel.changeCycle();
                            }
                          }
                        },
                        child: Obx(() {
                          bool isSelected = chartViewModel.selectedCycle.value == index;
                          // print('$index isSelected: $isSelected');
                          return chartToggleButton(
                            child: (index == chartViewModel.cycles.length)
                                ? Icon(
                                    Icons.auto_graph,
                                    size: 18,
                                    color: yachtWhite,
                                  )
                                : Text(
                                    chartViewModel.cycles[index],
                                    style: stockPriceChangeTextStyle.copyWith(
                                        color: chartViewModel.selectedCycle.value == index
                                            ? Colors.white
                                            : yachtLightGrey),
                                  ),
                            isSelected: isSelected,
                            color: (chartViewModel.isLoading.value && isSelected)
                                ? yachtDarkGrey
                                : chartViewModel.isLoading.value
                                    ? yachtDarkGrey
                                    : isSelected
                                        ? (chartViewModel.chartPrices!.first.close! -
                                                    chartViewModel.chartPrices!.last.close!) >
                                                0
                                            ? bullColorKR
                                            : (chartViewModel.chartPrices!.first.close! -
                                                        chartViewModel.chartPrices!.last.close!) <
                                                    0
                                                ? bearColorKR
                                                : yachtDarkGrey
                                        : yachtDarkGrey,
                          );
                        }),
                      );
                    }),
                    //
                  ),
          ),
          // Row(
          //   children: [
          //     TextButton(
          //         onPressed: () {
          //           // chartViewModel.getPrices(
          //           //     investAddressModel.copyWith(issueCode: "005930"));
          //           chartViewModel.changeStockAddressModel(
          //               investAddressModel.copyWith(issueCode: "005930"));
          //           // chartViewModel.investAddressModel =
          //           //     investAddressModel.copyWith(issueCode: "005930");
          //           chartViewModel.getPrices(newStockAddress!.value);
          //         },
          //         child: Text("0번")),
          //     TextButton(
          //         onPressed: () {
          //           // chartViewModel.getPrices(
          //           //     investAddressModel.copyWith(issueCode: "326030"));
          //           chartViewModel.changeStockAddressModel(
          //               investAddressModel.copyWith(issueCode: "326030"));
          //           // chartViewModel.investAddressModel =
          //           // investAddressModel.copyWith(issueCode: "326030");
          //           chartViewModel.getPrices(newStockAddress!.value);
          //         },
          //         child: Text("1번")),
          //   ],
          // )
        ],
      ),
    );
  }

  List<ChartSeries> _candleChart(
    List<ChartPriceModel> chartPrices,
  ) =>
      [
        CandleSeries<ChartPriceModel, DateTime>(
          // borderWidth: 0,
          animationDuration: 500,
          bullColor: bullColorKR,
          bearColor: bearColorKR,

          enableSolidCandles: true,
          dataSource: chartPrices,
          xValueMapper: (ChartPriceModel chart, _) => stringToDateTime(chart.dateTime!),
          openValueMapper: (ChartPriceModel chart, _) => chart.open,
          lowValueMapper: (ChartPriceModel chart, _) => chart.low,
          highValueMapper: (ChartPriceModel chart, _) => chart.high,
          closeValueMapper: (ChartPriceModel chart, _) => chart.close,
          showIndicationForSameValues: true,
        ),
        ColumnSeries<ChartPriceModel, DateTime>(
            dataSource: chartPrices,
            xValueMapper: (ChartPriceModel chart, _) => stringToDateTime(chart.dateTime!),
            yValueMapper: (ChartPriceModel chart, _) => chart.tradeVolume!,
            yAxisName: 'volume',
            color: volumeColor)
        // FastLineSeries<ChartModel, DateTime>(
        //   dataSource: tempChartData,
        //   yValueMapper: (ChartModel chart, _) => chart.close,
        //   xValueMapper: (ChartModel chart, _) => strToDate(chart.date),
        // )
      ];

  List<ChartSeries> _lineChart(
    List<ChartPriceModel> chartPrices,
  ) =>
      [
        FastLineSeries<ChartPriceModel, DateTime>(
          animationDuration: 500,
          dataSource: chartPrices,
          emptyPointSettings: EmptyPointSettings(
            mode: EmptyPointMode.gap,
          ),
          //오래된것이 last
          color: (chartPrices.first.close! - chartPrices.last.close!) > 0
              ? bullColorKR
              : (chartPrices.first.close! - chartPrices.last.close!) == 0
                  ? Colors.black
                  : bearColorKR,

          // animationDuration: 10000,
          // splineType: SplineType.cardinal,
          // cardinalSplineTension: 0.3,

          enableTooltip: true,
          // <ChartModel>[

          xValueMapper: (ChartPriceModel chart, _) => stringToDateTime(chart.dateTime!),
          yValueMapper: (ChartPriceModel chart, _) => chart.close,
          // animationDuration: 1000,
        )
      ];
}

// class DetailedPriceDisplay extends StatelessWidget {
//   final ChartViewModel chartViewModel;
//   const DetailedPriceDisplay({
//     Key? key,
//     required this.chartViewModel,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // color: Colors.black12,
//       height: 100,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("시가", style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
//                   Text(toPriceKRW(chartViewModel.open.value), style: ohlcPriceStyle)
//                 ],
//               ),
//               SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("고가", style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
//                   Text(toPriceKRW(chartViewModel.high.value), style: ohlcPriceStyle)
//                 ],
//               ),
//               SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("거래량", style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
//                   Text(toPriceKRW(chartViewModel.volume.value), style: ohlcPriceStyle)
//                 ],
//               )
//             ],
//           )),
//           SizedBox(width: 36),
//           Expanded(
//               child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("종가", style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
//                   Text(toPriceKRW(chartViewModel.close.value), style: ohlcPriceStyle)
//                 ],
//               ),
//               SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("저가", style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
//                   Text(toPriceKRW(chartViewModel.low.value), style: ohlcPriceStyle)
//                 ],
//               ),
//               SizedBox(height: 8),
//               //TODO: 변동 폭 계산 필요
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(" ", style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
//                   Text("", style: ohlcPriceStyle)
//                 ],
//               )
//             ],
//           ))
//         ],
//       ),
//     );
//   }
// }

class DetailedPriceDisplayVer2 extends StatelessWidget {
  final ChartViewModel chartViewModel;
  const DetailedPriceDisplayVer2({
    Key? key,
    required this.chartViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 121.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: MainPriceTrackingDisplay(chartViewModel: chartViewModel)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("시가", style: questTermTextStyle),
                      Text('${toPriceKRW(chartViewModel.open.value)}원', style: questTermTextStyle)
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("고가", style: questTermTextStyle),
                      Text('${toPriceKRW(chartViewModel.high.value)}원', style: questTermTextStyle)
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("저가", style: questTermTextStyle),
                      Text('${toPriceKRW(chartViewModel.low.value)}원', style: questTermTextStyle)
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("거래량", style: questTermTextStyle),
                      Text('${toPriceKRW(chartViewModel.volume.value)}주', style: questTermTextStyle)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPriceDisplay extends StatelessWidget {
  final ChartViewModel chartViewModel;
  const MainPriceDisplay({
    Key? key,
    required this.chartViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: Colors.blueGrey[200],

                // TODO: parent에서 받아오는 것 구현
                child: Obx(
                  () => Text(
                    newStockAddress!.value.name,
                    style: stockInfoNameTextStyle,
                  ),
                ),
              ),
              // SizedBox(
              //   height: reducedPaddingWhenTextIsBelow(
              //       6.w, questTermTextStyle.fontSize!),
              // ),
              SizedBox(
                height: 6.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "현재 주가",
                    style: TextStyle(
                      fontSize: 14.w,
                      color: yachtWhite,
                      // fontFamily: 'Default',
                      letterSpacing: -1.0,
                    ),
                  ),
                  Obx(
                    () => Text(
                      chartViewModel.isTracking.value == true
                          ? "${toPriceKRW(chartViewModel.close.value)}"
                          : "${toPriceKRW(chartViewModel.chartPrices!.first.close!)}",
                      style: stockPriceTextStyle.copyWith(height: 1.4),
                    ),
                  ),
                  // SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                          chartViewModel.isTracking.value == true
                              ? "${toPriceChangeKRW(chartViewModel.close.value - chartViewModel.chartPrices!.last.close!)}"
                              : "${toPriceChangeKRW(chartViewModel.chartPrices!.first.close! - chartViewModel.chartPrices!.last.close!)}",
                          style: stockPriceChangeTextStyle.copyWith(
                              height: 1.2,
                              color: chartViewModel.isTracking.value == true
                                  ? chartTrackingColor(chartViewModel)
                                  : chartClosePriceColor(chartViewModel))),
                      SizedBox(width: 4),
                      Text(
                          chartViewModel.isTracking.value == true
                              ? "(${toPercentageChange(chartViewModel.close.value / chartViewModel.chartPrices!.last.close! - 1)})"
                              : "(${toPercentageChange(chartViewModel.chartPrices!.first.close! / chartViewModel.chartPrices!.last.close! - 1)})",
                          style: detailPriceStyle.copyWith(
                              color: chartViewModel.isTracking.value == true
                                  ? chartTrackingColor(chartViewModel)
                                  : chartClosePriceColor(chartViewModel)))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

class MainPriceTrackingDisplay extends StatelessWidget {
  final ChartViewModel chartViewModel;
  const MainPriceTrackingDisplay({
    Key? key,
    required this.chartViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          height: 121.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "기간",
                    style: questTermTextStyle,
                  ),
                  Text(
                    "${chartViewModel.dateStart}\n~${chartViewModel.dateEnd}",
                    style: questTermTextStyle,
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chartViewModel.isTracking.value == true
                        ? "${toPriceKRW(chartViewModel.close.value)}"
                        : "${toPriceKRW(chartViewModel.chartPrices!.first.close!)}",
                    style: stockPriceTextStyle.copyWith(fontSize: 26.w, height: 1.4),
                  ),
                  Row(
                    children: [
                      Text(
                        chartViewModel.isTracking.value == true
                            ? "${toPriceChangeKRW(chartViewModel.close.value - chartViewModel.open.value)}"
                            : "${toPriceChangeKRW(chartViewModel.chartPrices!.first.close! - chartViewModel.chartPrices!.last.close!)}",
                        style: stockPriceChangeTextStyle.copyWith(
                            height: 1.2,
                            color: chartViewModel.isTracking.value == true
                                ? (chartViewModel.close.value / chartViewModel.open.value - 1) > 0
                                    ? bullColorKR
                                    : (chartViewModel.close.value / chartViewModel.open.value - 1) < 0
                                        ? bearColorKR
                                        : yachtWhite
                                : (chartViewModel.chartPrices!.first.close! - chartViewModel.chartPrices!.last.close!) >
                                        0
                                    ? bullColorKR
                                    : (chartViewModel.chartPrices!.first.close! -
                                                chartViewModel.chartPrices!.last.close!) <
                                            0
                                        ? bearColorKR
                                        : yachtWhite),
                      ),
                      SizedBox(width: 4),
                      Text(
                          chartViewModel.isTracking.value == true
                              ? "(${toPercentageChange(chartViewModel.close.value / chartViewModel.open.value - 1)})"
                              : "(${toPercentageChange(chartViewModel.chartPrices!.first.close! / chartViewModel.chartPrices!.last.close! - 1)})",
                          style: detailPriceStyle.copyWith(
                              color: chartViewModel.isTracking.value == true
                                  ? (chartViewModel.close.value / chartViewModel.open.value - 1) > 0
                                      ? bullColorKR
                                      : (chartViewModel.close.value / chartViewModel.open.value - 1) < 0
                                          ? bearColorKR
                                          : yachtWhite
                                  : (chartViewModel.chartPrices!.first.close! /
                                                  chartViewModel.chartPrices!.last.close! -
                                              1) >
                                          0
                                      ? bullColorKR
                                      : (chartViewModel.chartPrices!.first.close! /
                                                      chartViewModel.chartPrices!.last.close! -
                                                  1) <
                                              0
                                          ? bearColorKR
                                          : yachtWhite))
                    ],
                  ),
                ],
              ),
              // SizedBox(height: 4),
            ],
          ),
        ));
  }
}
