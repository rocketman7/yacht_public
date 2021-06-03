import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/styles/style_constants.dart';

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
    return MixinBuilder<ChartViewModel>(
        init: ChartViewModel(),
        builder: (chartViewModel) {
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              chartViewModel.isTracking.value == true
                  ? Padding(
                      padding: kHorizontalPadding,
                      child: Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("시가",
                                        style: ohlcInfoStyle.copyWith(
                                            color: Colors.grey[600])),
                                    Text(toPriceKRW(chartViewModel.open.value),
                                        style: ohlcPriceStyle)
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("고가",
                                        style: ohlcInfoStyle.copyWith(
                                            color: Colors.grey[600])),
                                    Text(toPriceKRW(chartViewModel.high.value),
                                        style: ohlcPriceStyle)
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("거래량",
                                        style: ohlcInfoStyle.copyWith(
                                            color: Colors.grey[600])),
                                    Text(
                                        toPriceKRW(chartViewModel.volume.value),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("종가",
                                        style: ohlcInfoStyle.copyWith(
                                            color: Colors.grey[600])),
                                    Text(toPriceKRW(chartViewModel.close.value),
                                        style: ohlcPriceStyle)
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("저가",
                                        style: ohlcInfoStyle.copyWith(
                                            color: Colors.grey[600])),
                                    Text(toPriceKRW(chartViewModel.low.value),
                                        style: ohlcPriceStyle)
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("변동",
                                        style: ohlcInfoStyle.copyWith(
                                            color: Colors.grey[600])),
                                    Text("-2.24%", style: ohlcPriceStyle)
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    )
                  : Container(
                      // key: ValueKey(chartViewModel.isTracking),
                      // color: Colors.blueGrey[50],
                      width: double.infinity,
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // color: Colors.blueGrey[200],
                            child: Padding(
                              padding: kHorizontalPadding,
                              // TODO: parent에서 받아오는 것 구현
                              child: Text(
                                "삼성전자",
                                style: headingStyle,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          (chartViewModel.priceList == null)
                              ? Container()
                              : Container(
                                  // color: Colors.blueGrey[200],
                                  child: Padding(
                                    padding: kHorizontalPadding,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${toPriceKRW(chartViewModel.subList!.last.close!)}",
                                          style: headingStyleEN,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              "${toPriceChangeKRW(chartViewModel.subList!.last.close! - chartViewModel.subList!.first.close!)}",
                                              style: detailPriceStyle.copyWith(
                                                  color: (chartViewModel
                                                                  .subList!
                                                                  .last
                                                                  .close! -
                                                              chartViewModel
                                                                  .subList!
                                                                  .first
                                                                  .close!) >
                                                          0
                                                      ? bullColorKR
                                                      : (chartViewModel
                                                                      .subList!
                                                                      .last
                                                                      .close! -
                                                                  chartViewModel
                                                                      .subList!
                                                                      .first
                                                                      .close!) <
                                                              0
                                                          ? bearColorKR
                                                          : Colors.black),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                                "(${toPercentageChange(chartViewModel.subList!.last.close! / chartViewModel.subList!.first.close! - 1)})",
                                                style:
                                                    detailPriceStyle.copyWith(
                                                        color: (chartViewModel
                                                                            .subList!
                                                                            .last
                                                                            .close! /
                                                                        chartViewModel
                                                                            .subList!
                                                                            .first
                                                                            .close! -
                                                                    1) >
                                                                0
                                                            ? bullColorKR
                                                            : (chartViewModel.subList!.last.close! /
                                                                            chartViewModel.subList!.first.close! -
                                                                        1) <
                                                                    0
                                                                ? bearColorKR
                                                                : Colors.black))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
              (chartViewModel.priceList == null)
                  ? Container(height: 200, color: Colors.blue)
                  : Container(
                      height: 200,
                      // color: Colors.white,
                      child: SfCartesianChart(
                        // Trackball과 관련된 것들
                        onTrackballPositionChanging: (TrackballArgs args) {
                          // trackball의 X Position이 변하지 않으면 아무것도 하지 않음
                          // trackball의 X Position이 변했으면 햅틱을 주고 직전 X Position을 업데이트함
                          // if (previousXPosition !=
                          //     args.chartPointInfo.xPosition) {

                          if (args.chartPointInfo.seriesIndex == 0 &&
                              previousXPosition !=
                                  args.chartPointInfo.xPosition) {
                            // Printing Coordinate intersect point of first line
                            chartViewModel.onTrackballChanging(args);
                          }
                          if (args.chartPointInfo.seriesIndex == 1) {
                            // Printing Coordinate intersect point of second line
                            chartViewModel.onTrackballChanging(args);
                          }

                          // }
                          previousXPosition = args.chartPointInfo.xPosition!;
                          HapticFeedback.lightImpact();

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
                        enableAxisAnimation: true,
                        series: <ChartSeries>[
                          CandleSeries<PriceChartModel, DateTime>(
                            // borderWidth: 0,
                            bullColor: bullColorKR,
                            bearColor: bearColorKR,
                            enableSolidCandles: true,
                            dataSource:
                                chartViewModel.priceList!.sublist(1, 60),
                            lowValueMapper: (PriceChartModel chart, _) =>
                                chart.low,
                            highValueMapper: (PriceChartModel chart, _) =>
                                chart.high,
                            openValueMapper: (PriceChartModel chart, _) =>
                                chart.open,
                            closeValueMapper: (PriceChartModel chart, _) =>
                                chart.close,
                            xValueMapper: (PriceChartModel chart, _) =>
                                stringToDateTime(chart.dateTime!),
                          ),
                          ColumnSeries<PriceChartModel, DateTime>(
                            dataSource:
                                chartViewModel.priceList!.sublist(1, 60),
                            xValueMapper: (PriceChartModel chart, _) =>
                                stringToDateTime(chart.dateTime!),
                            yValueMapper: (PriceChartModel chart, _) =>
                                chart.tradeVolume!,
                            yAxisName: 'volume',
                          )
                          // FastLineSeries<ChartModel, DateTime>(
                          //   dataSource: tempChartData,
                          //   yValueMapper: (ChartModel chart, _) => chart.close,
                          //   xValueMapper: (ChartModel chart, _) => strToDate(chart.date),
                          // )
                        ],
                        primaryXAxis: DateTimeCategoryAxis(
                            majorGridLines: MajorGridLines(
                              width: 0,
                            ),
                            isVisible: false),
                        primaryYAxis: NumericAxis(
                            maximum: chartViewModel.maxPrice! * 1.01,
                            minimum: chartViewModel.minPrice! *
                                0.95, // 차트에 그려지는 PriceChartModel의 low중 min값 받아서 영역의 상단 4/5에만 그려지도록 maximum 값 설정
                            majorGridLines: MajorGridLines(width: 0),
                            isVisible: false),
                        axes: [
                          NumericAxis(
                              // 차트에 그려지는 PriceChartModel의 volume들 중 max값 받아서 영역의 1/5에만 그려지도록 maximum 값 설정
                              maximum: chartViewModel.maxVolume! * 5,
                              minimum: 0,
                              majorGridLines: MajorGridLines(width: 0),
                              isVisible: false,
                              name: 'volume'),
                        ],
                        enableSideBySideSeriesPlacement: false,
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    List.generate(chartViewModel.termList.length + 1, (index) {
                  return Container(
                    color: Colors.blueGrey.shade100,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: (index == chartViewModel.termList.length)
                        ? Icon(
                            Icons.auto_graph,
                            size: 18,
                          )
                        : Text(chartViewModel.termList[index]),
                  );
                }),
                //
              )
            ],
          );
        });
  }
}
