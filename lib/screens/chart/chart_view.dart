import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/styles/style_constants.dart';
import '../../styles/style_constants.dart';
import '../../handlers/date_time_handler.dart';
import '../../models/price_chart_model.dart';
import 'chart_view_model.dart';

class ChartView extends StatelessWidget {
  final String? issueCode;
  // onTrackballPositionChanging에서 X Position이 변했는지 체크하기 위해 직전 X Position을 저장

  ChartView({
    Key? key,
    required this.issueCode,
  }) : super(key: key);

  double previousXPosition = 0;

  @override
  Widget build(BuildContext context) {
    print('rebuilt');
    // Mixin Builder로 하니까 차트 onTap마다 차트가 다시 그려졌음.
    // 명확하게 update를 받아오는 부분에서 GetBuilder를 쓰거나
    // 아니면 필요한 위젯 상단에 Obx로 obs 밸류 가져오는 방법이 좋을듯
    // Mixin Builder를 써서가 아니라 MixinBuilder의 Obx 기능이
    // 너무 상단 위젯에 존재해서 그럼.
    return GetBuilder<ChartViewModel>(
        init: ChartViewModel(),
        builder: (chartViewModel) {
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Stack(children: [
                  (chartViewModel.isTracking.value == true &&
                          chartViewModel.showingCandleChart.value)
                      ? Padding(
                          padding: kHorizontalPadding,
                          child: Opacity(
                            opacity: 1 - chartViewModel.opacity.value < 0
                                ? 0
                                : 1 - chartViewModel.opacity.value,
                            child: DetailedPriceDisplayVer2(
                                chartViewModel: chartViewModel),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: kHorizontalPadding,
                    child: Opacity(
                      opacity: !chartViewModel.showingCandleChart.value
                          ? 1
                          : chartViewModel.opacity.value > 0.2
                              ? chartViewModel.opacity.value
                              : 0,
                      child: (chartViewModel.prices == null)
                          ? Container(
                              height: 120,
                              width: double.infinity,
                              // color: Colors.blueGrey.withOpacity(.1),
                            )
                          : Container(
                              height: 120,
                              width: double.infinity,
                              // color: Colors.blueGrey.withOpacity(.1),
                              child: MainPriceDisplay(
                                  chartViewModel: chartViewModel)),
                    ),
                  ),
                ]),
              ),
              (chartViewModel.prices == null)
                  ? Container(height: 200, color: Colors.blue)
                  : Obx(
                      () => Container(
                        height: 200,
                        // color: Colors.white,
                        child: SfCartesianChart(
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
                                previousXPosition !=
                                    args.chartPointInfo.xPosition) {
                              // Printing Coordinate intersect point of first line
                              HapticFeedback.lightImpact();
                              print(args.chartPointInfo.chartDataPoint!.x);
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
                              ? _candleChart(chartViewModel)
                              : _lineChart(chartViewModel),
                          primaryXAxis: DateTimeCategoryAxis(
                              majorGridLines: MajorGridLines(
                                width: 0,
                              ),
                              isVisible: false),
                          primaryYAxis: NumericAxis(
                              maximum: chartViewModel.maxPrice!,
                              minimum: (5 * chartViewModel.minPrice! -
                                      chartViewModel.maxPrice!) /
                                  4,
                              // chartViewModel.minPrice! *
                              //     0.97, // 차트에 그려지는 PriceChartModel의 low중 min값 받아서 영역의 상단 4/5에만 그려지도록 maximum 값 설정
                              majorGridLines: MajorGridLines(width: 0),
                              isVisible: false),
                          axes: [
                            NumericAxis(
                                // 차트에 그려지는 PriceChartModel의 volume들 중 max값 받아서 영역의 1/5에만 그려지도록 maximum 값 설정
                                maximum: chartViewModel.maxVolume! * 4.5,
                                minimum: 0,
                                majorGridLines: MajorGridLines(width: 0),
                                isVisible: false,
                                name: 'volume'),
                          ],
                          enableSideBySideSeriesPlacement: false,
                        ),
                      ),
                    ),
              Padding(
                padding: kHorizontalPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      List.generate(chartViewModel.cycles.length + 1, (index) {
                    return InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          if (index == chartViewModel.cycles.length) {
                            chartViewModel.toggleChartType();
                          } else {
                            if (chartViewModel.selectedCycle != index) {
                              chartViewModel.selectedCycle = index;
                              chartViewModel.changeCycle();
                            }
                          }
                        },
                        child: toggleButton(
                          (index == chartViewModel.cycles.length)
                              ? Icon(
                                  Icons.auto_graph,
                                  size: 18,
                                )
                              : Text(
                                  chartViewModel.cycles[index],
                                  style: detailStyle,
                                ),
                          (chartViewModel.selectedCycle == index)
                              ? toggleButtonColor
                              : Colors.transparent,
                        )
                        // Container(
                        //   decoration: BoxDecoration(
                        //     color: (chartViewModel.selectedCycle == index)
                        //         ? Color(0xFFE8EAF6)
                        //         : Colors.transparent,
                        //     borderRadius: BorderRadius.circular(70),
                        //   ),
                        //   // color: Colors.blueGrey.shade100,
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 10, vertical: 6),
                        //   child: (index == chartViewModel.cycleList.length)
                        //       ? Icon(
                        //           Icons.auto_graph,
                        //           size: 18,
                        //         )
                        //       : Text(
                        //           chartViewModel.cycleList[index],
                        //           style: detailStyle,
                        //         ),
                        // ),
                        );
                  }),
                  //
                ),
              )
            ],
          );
        });
  }

  List<ChartSeries> _candleChart(
    ChartViewModel chartViewModel,
  ) =>
      [
        CandleSeries<PriceChartModel, DateTime>(
          // borderWidth: 0,
          animationDuration: 500,
          bullColor: bullColorKR,
          bearColor: bearColorKR,
          enableSolidCandles: true,
          dataSource: chartViewModel.chartPrices!,
          lowValueMapper: (PriceChartModel chart, _) => chart.low,
          highValueMapper: (PriceChartModel chart, _) => chart.high,
          openValueMapper: (PriceChartModel chart, _) => chart.open,
          closeValueMapper: (PriceChartModel chart, _) => chart.close,
          xValueMapper: (PriceChartModel chart, _) =>
              stringToDateTime(chart.dateTime!),
          showIndicationForSameValues: true,
        ),
        ColumnSeries<PriceChartModel, DateTime>(
            dataSource: chartViewModel.chartPrices!,
            xValueMapper: (PriceChartModel chart, _) =>
                stringToDateTime(chart.dateTime!),
            yValueMapper: (PriceChartModel chart, _) => chart.tradeVolume!,
            yAxisName: 'volume',
            color: volumeColor)
        // FastLineSeries<ChartModel, DateTime>(
        //   dataSource: tempChartData,
        //   yValueMapper: (ChartModel chart, _) => chart.close,
        //   xValueMapper: (ChartModel chart, _) => strToDate(chart.date),
        // )
      ];

  List<ChartSeries> _lineChart(
    ChartViewModel chartViewModel,
  ) =>
      [
        FastLineSeries<PriceChartModel, DateTime>(
          animationDuration: 500,
          dataSource: chartViewModel.chartPrices!,
          emptyPointSettings: EmptyPointSettings(
            mode: EmptyPointMode.gap,
          ),
          //오래된것이 last
          color: (chartViewModel.chartPrices!.first.close! -
                      chartViewModel.chartPrices!.last.close!) >
                  0
              ? bullColorKR
              : (chartViewModel.chartPrices!.first.close! -
                          chartViewModel.chartPrices!.last.close!) ==
                      0
                  ? Colors.black
                  : bearColorKR,

          // animationDuration: 10000,
          // splineType: SplineType.cardinal,
          // cardinalSplineTension: 0.3,

          enableTooltip: true,
          // <ChartModel>[

          xValueMapper: (PriceChartModel chart, _) =>
              stringToDateTime(chart.dateTime!),
          yValueMapper: (PriceChartModel chart, _) => chart.close,
          // animationDuration: 1000,
        )
      ];
}

class DetailedPriceDisplay extends StatelessWidget {
  final ChartViewModel chartViewModel;
  const DetailedPriceDisplay({
    Key? key,
    required this.chartViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black12,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("시가",
                      style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
                  Text(toPriceKRW(chartViewModel.open.value),
                      style: ohlcPriceStyle)
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("고가",
                      style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
                  Text(toPriceKRW(chartViewModel.high.value),
                      style: ohlcPriceStyle)
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("거래량",
                      style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
                  Text(toPriceKRW(chartViewModel.volume.value),
                      style: ohlcPriceStyle)
                ],
              )
            ],
          )),
          SizedBox(width: 36),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("종가",
                      style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
                  Text(toPriceKRW(chartViewModel.close.value),
                      style: ohlcPriceStyle)
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("저가",
                      style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
                  Text(toPriceKRW(chartViewModel.low.value),
                      style: ohlcPriceStyle)
                ],
              ),
              SizedBox(height: 8),
              //TODO: 변동 폭 계산 필요
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(" ",
                      style: ohlcInfoStyle.copyWith(color: Colors.grey[600])),
                  Text("", style: ohlcPriceStyle)
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}

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
        // color: Colors.black12,
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: MainPriceDisplay(chartViewModel: chartViewModel)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("시가",
                          style:
                              ohlcInfoStyle.copyWith(color: Colors.grey[600])),
                      Text(toPriceKRW(chartViewModel.open.value),
                          style: ohlcPriceStyle)
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("고가",
                          style:
                              ohlcInfoStyle.copyWith(color: Colors.grey[600])),
                      Text(toPriceKRW(chartViewModel.high.value),
                          style: ohlcPriceStyle)
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("저가",
                          style:
                              ohlcInfoStyle.copyWith(color: Colors.grey[600])),
                      Text(toPriceKRW(chartViewModel.low.value),
                          style: ohlcPriceStyle)
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("거래량",
                          style:
                              ohlcInfoStyle.copyWith(color: Colors.grey[600])),
                      Text(toPriceKRW(chartViewModel.volume.value),
                          style: ohlcPriceStyle)
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
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // color: Colors.blueGrey[200],

              // TODO: parent에서 받아오는 것 구현
              child: Text(
                "삼성전자",
                style: headingStyle,
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Container(
              // color: Colors.blueGrey[200],

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chartViewModel.isTracking.value == true
                        ? "${toPriceKRW(chartViewModel.close.value)}"
                        : "${toPriceKRW(chartViewModel.chartPrices!.first.close!)}",
                    style: headingStyleEN,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        chartViewModel.isTracking.value == true
                            ? "${toPriceChangeKRW(chartViewModel.close.value - chartViewModel.chartPrices!.last.close!)}"
                            : "${toPriceChangeKRW(chartViewModel.chartPrices!.first.close! - chartViewModel.chartPrices!.last.close!)}",
                        style: detailPriceStyle.copyWith(
                            color: chartViewModel.isTracking.value == true
                                ? (chartViewModel.close.value /
                                                chartViewModel
                                                    .chartPrices!.last.close! -
                                            1) >
                                        0
                                    ? bullColorKR
                                    : (chartViewModel.close.value /
                                                    chartViewModel.chartPrices!
                                                        .last.close! -
                                                1) <
                                            0
                                        ? bearColorKR
                                        : Colors.black
                                : (chartViewModel.chartPrices!.first.close! -
                                            chartViewModel
                                                .chartPrices!.last.close!) >
                                        0
                                    ? bullColorKR
                                    : (chartViewModel
                                                    .chartPrices!.first.close! -
                                                chartViewModel
                                                    .chartPrices!.last.close!) <
                                            0
                                        ? bearColorKR
                                        : Colors.black),
                      ),
                      SizedBox(width: 4),
                      Text(
                          chartViewModel.isTracking.value == true
                              ? "(${toPercentageChange(chartViewModel.close.value / chartViewModel.chartPrices!.last.close! - 1)})"
                              : "(${toPercentageChange(chartViewModel.chartPrices!.first.close! / chartViewModel.chartPrices!.last.close! - 1)})",
                          style: detailPriceStyle.copyWith(
                              color: chartViewModel.isTracking.value == true
                                  ? (chartViewModel.close.value /
                                                  chartViewModel.chartPrices!
                                                      .last.close! -
                                              1) >
                                          0
                                      ? bullColorKR
                                      : (chartViewModel.close.value /
                                                      chartViewModel
                                                          .chartPrices!
                                                          .last
                                                          .close! -
                                                  1) <
                                              0
                                          ? bearColorKR
                                          : Colors.black
                                  : (chartViewModel.chartPrices!.first.close! /
                                                  chartViewModel.chartPrices!
                                                      .last.close! -
                                              1) >
                                          0
                                      ? bullColorKR
                                      : (chartViewModel.chartPrices!.first
                                                          .close! /
                                                      chartViewModel
                                                          .chartPrices!
                                                          .last
                                                          .close! -
                                                  1) <
                                              0
                                          ? bearColorKR
                                          : Colors.black))
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
