import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/price_chart_model.dart';
import '../../handlers/handle_date_time.dart';
import 'chart_view_model.dart';
import 'package:flutter/services.dart';

class ChartView extends StatelessWidget {
  // onTrackballPositionChanging에서 X Position이 변했는지 체크하기 위해 직전 X Position을 저장
  double previousXPosition = 0;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChartViewModel>(
        init: ChartViewModel(),
        builder: (chartViewModel) {
          return Column(
            children: [
              Container(
                height: 50,
                color: Colors.blueGrey.shade50,
                child: Text((chartViewModel.priceList == null)
                    ? ""
                    : chartViewModel.priceList!.last.close.toString()),
              ),
              (chartViewModel.priceList == null)
                  ? Container(height: 200, color: Colors.blue)
                  : Container(
                      height: 200,
                      // color: Colors.white,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        onTrackballPositionChanging: (_) {
                          // trackball의 X Position이 변하지 않으면 아무것도 하지 않음
                          // trackball의 X Position이 변했으면 햅틱을 주고 직전 X Position을 업데이트함
                          if (previousXPosition != _.chartPointInfo.xPosition) {
                            print(_.chartPointInfo.markerXPos);
                            HapticFeedback.lightImpact();
                            previousXPosition = _.chartPointInfo.xPosition!;
                          }
                          // print(_.chartPointInfo.xPosition);
                          // HapticFeedback.lightImpact();
                        },
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          activationMode: ActivationMode.longPress,
                          tooltipSettings: InteractiveTooltip(
                            enable: false,
                            // Formatting trackball tooltip text
                            // format: ''
                          ),
                        ),
                        enableAxisAnimation: true,
                        series: <ChartSeries>[
                          CandleSeries<PriceChartModel, DateTime>(
                            // borderWidth: 0,
                            bullColor: Colors.red,
                            bearColor: Colors.blue,
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
                            maximum: chartViewModel.maxPrice,
                            minimum: chartViewModel.minPrice! *
                                .8, // 차트에 그려지는 PriceChartModel의 low중 min값 받아서 영역의 상단 4/5에만 그려지도록 maximum 값 설정
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

  // List<PriceChartModel> tempChartData = [
  //   PriceChartModel(
  //       dateTime: '20200101', open: 20, close: 23, high: 27, low: 17),
  //   PriceChartModel(
  //       dateTime: '20200103', open: 24, close: 23, high: 27, low: 14),
  //   PriceChartModel(
  //       dateTime: '20200105', open: 24, close: 19, high: 27, low: 14),
  //   PriceChartModel(
  //       dateTime: '20200107', open: 24, close: 31, high: 41, low: 21),
  //   PriceChartModel(
  //       dateTime: '20200108', open: 24, close: 31, high: 45, low: 10),
  //   PriceChartModel(
  //       dateTime: '20200109', open: 24, close: 31, high: 41, low: 10),
  //   PriceChartModel(
  //       dateTime: '20200110', open: 24, close: 27, high: 41, low: 10),
  //   PriceChartModel(
  //       dateTime: '20200201', open: 20, close: 23, high: 27, low: 17),
  //   PriceChartModel(
  //       dateTime: '20200203', open: 24, close: 23, high: 27, low: 14),
  //   PriceChartModel(
  //       dateTime: '20200205', open: 24, close: 19, high: 27, low: 14),
  //   PriceChartModel(
  //       dateTime: '20200207', open: 24, close: 31, high: 41, low: 21),
  //   PriceChartModel(
  //       dateTime: '20200208', open: 17, close: 31, high: 30, low: 10),
  //   PriceChartModel(
  //       dateTime: '20200209', open: 19, close: 31, high: 41, low: 10),
  //   PriceChartModel(
  //       dateTime: '20200210', open: 24, close: 27, high: 41, low: 10),
  //   PriceChartModel(
  //       dateTime: '20200301', open: 20, close: 23, high: 27, low: 17),
  //   PriceChartModel(
  //       dateTime: '20200303', open: 24, close: 23, high: 27, low: 14),
  //   PriceChartModel(
  //       dateTime: '20200305', open: 24, close: 19, high: 27, low: 14),
  //   PriceChartModel(
  //       dateTime: '20200307', open: 24, close: 31, high: 41, low: 21),
  //   PriceChartModel(
  //       dateTime: '20200308', open: 24, close: 31, high: 45, low: 10),
  //   PriceChartModel(
  //       dateTime: '20200309', open: 24, close: 31, high: 41, low: 10),
  // ];
}
