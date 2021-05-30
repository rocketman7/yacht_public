import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/price_chart_model.dart';
import '../../handlers/handle_date_time.dart';
import 'chart_view_model.dart';

class ChartView extends StatelessWidget {
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
                      // height: 200,
                      color: Colors.white,
                      child: SfCartesianChart(
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          activationMode: ActivationMode.singleTap,
                          tooltipSettings: InteractiveTooltip(
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
                                (chart.tradeVolume! / 1000),
                            yAxisName: 'volume',
                          )
                          // FastLineSeries<ChartModel, DateTime>(
                          //   dataSource: tempChartData,
                          //   yValueMapper: (ChartModel chart, _) => chart.close,
                          //   xValueMapper: (ChartModel chart, _) => strToDate(chart.date),
                          // )
                        ],
                        primaryXAxis: CategoryAxis(
                            majorGridLines: MajorGridLines(
                              width: 0,
                            ),
                            isVisible: false),
                        primaryYAxis: NumericAxis(
                            maximum: 70000,
                            minimum: 40000,
                            majorGridLines: MajorGridLines(width: 0),
                            isVisible: false),
                            
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
