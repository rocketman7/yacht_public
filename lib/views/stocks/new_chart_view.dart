import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/models/chart_model.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/views/constants/holiday.dart';

class NewChartView extends StatefulWidget {
  @override
  _NewChartViewState createState() => _NewChartViewState();
}

class _NewChartViewState extends State<NewChartView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
          series: <ChartSeries>[
            CandleSeries<ChartModel, DateTime>(
              borderWidth: 1,
              bullColor: Colors.red,
              bearColor: Colors.blue,
              enableSolidCandles: true,
              dataSource: tempChartData,
              lowValueMapper: (ChartModel chart, _) => chart.low,
              highValueMapper: (ChartModel chart, _) => chart.high,
              openValueMapper: (ChartModel chart, _) => chart.open,
              closeValueMapper: (ChartModel chart, _) => chart.close,
              xValueMapper: (ChartModel chart, _) => strToDate(chart.date!),
            ),
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
              majorGridLines: MajorGridLines(width: 0), isVisible: false)),
    );
  }
}

List<ChartModel> tempChartData = [
  ChartModel(date: '20200101', open: 20, close: 23, high: 27, low: 17),
  ChartModel(date: '20200103', open: 24, close: 23, high: 27, low: 14),
  ChartModel(date: '20200105', open: 24, close: 19, high: 27, low: 14),
  ChartModel(date: '20200107', open: 24, close: 31, high: 41, low: 21),
  ChartModel(date: '20200108', open: 24, close: 31, high: 45, low: 10),
  ChartModel(date: '20200109', open: 24, close: 31, high: 41, low: 10),
  ChartModel(date: '20200110', open: 24, close: 27, high: 41, low: 10),
  ChartModel(date: '20200201', open: 20, close: 23, high: 27, low: 17),
  ChartModel(date: '20200203', open: 24, close: 23, high: 27, low: 14),
  ChartModel(date: '20200205', open: 24, close: 19, high: 27, low: 14),
  ChartModel(date: '20200207', open: 24, close: 31, high: 41, low: 21),
  ChartModel(date: '20200208', open: 17, close: 31, high: 30, low: 10),
  ChartModel(date: '20200209', open: 19, close: 31, high: 41, low: 10),
  ChartModel(date: '20200210', open: 24, close: 27, high: 41, low: 10),
  ChartModel(date: '20200301', open: 20, close: 23, high: 27, low: 17),
  ChartModel(date: '20200303', open: 24, close: 23, high: 27, low: 14),
  ChartModel(date: '20200305', open: 24, close: 19, high: 27, low: 14),
  ChartModel(date: '20200307', open: 24, close: 31, high: 41, low: 21),
  ChartModel(date: '20200308', open: 24, close: 31, high: 45, low: 10),
  ChartModel(date: '20200309', open: 24, close: 31, high: 41, low: 10),
];
