import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:get/get.dart';

class RevenueView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text("매출액"),
        SizedBox(
          height: 150,
          child: SfCartesianChart(
            // zoomPanBehavior: ZoomPanBehavior(
            //   zoomMode: ZoomMode.x,
            //   enablePanning: true,
            // ),
            series: [
              ColumnSeries<StatsModel, num>(
                  dataSource: tempData,
                  xValueMapper: (StatsModel stats, _) => stats.year,
                  yValueMapper: (StatsModel stats, _) {
                    var result;
                    if (stats.term! == '1Q') {
                      result = stats.sales!;
                    }
                    return result;
                  }),
              ColumnSeries<StatsModel, num>(
                  dataSource: tempData,
                  xValueMapper: (StatsModel stats, _) => stats.year,
                  yValueMapper: (StatsModel stats, _) {
                    var result;
                    if (stats.term! == '2Q') {
                      result = stats.sales!;
                    }
                    return result;
                  }),
              ColumnSeries<StatsModel, num>(
                  dataSource: tempData,
                  xValueMapper: (StatsModel stats, _) => stats.year,
                  yValueMapper: (StatsModel stats, _) {
                    var result;
                    if (stats.term! == '3Q') {
                      result = stats.sales!;
                    }
                    return result;
                  }),
              ColumnSeries<StatsModel, num>(
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  dataSource: tempData,
                  xValueMapper: (StatsModel stats, _) => stats.year,
                  yValueMapper: (StatsModel stats, _) {
                    var result;
                    if (stats.term! == '4Q') {
                      result = stats.sales!;
                    }
                    return result;
                  }),
            ],
            primaryXAxis: CategoryAxis(
                // zoomPosition: 1,
                // zoomFactor: 0.85,
                // isInversed: true,
                majorGridLines: MajorGridLines(
                  width: 0,
                ),
                isVisible: true),
            primaryYAxis: NumericAxis(
                numberFormat: formatPriceKRW,
                maximum: 150000,
                minimum:
                    85000, // 차트에 그려지는 PriceChartModel의 low중 min값 받아서 영역의 상단 4/5에만 그려지도록 maximum 값 설정
                majorGridLines: MajorGridLines(width: 0),
                isVisible: false),
          ),
        )
      ],
    );
  }

  final List<StatsModel> tempData = [
    StatsModel(
      dateTime: '20180331',
      year: 2018,
      term: '1Q',
      sales: 100000,
    ),
    StatsModel(
      dateTime: '20180630',
      year: 2018,
      term: '2Q',
      sales: 110000,
    ),
    StatsModel(
      dateTime: '20180930',
      year: 2018,
      term: '3Q',
      sales: 103000,
    ),
    StatsModel(
      dateTime: '20181231',
      year: 2018,
      term: '4Q',
      sales: 132000,
    ),
    StatsModel(
      dateTime: '20190331',
      year: 2019,
      term: '1Q',
      sales: 114000,
    ),
    StatsModel(
      dateTime: '20190630',
      year: 2019,
      term: '2Q',
      sales: 113000,
    ),
    StatsModel(
      dateTime: '20190930',
      year: 2019,
      term: '3Q',
      sales: 135000,
    ),
    StatsModel(
      dateTime: '20191231',
      year: 2019,
      term: '4Q',
      sales: 111000,
    ),
    StatsModel(
      dateTime: '20200331',
      year: 2020,
      term: '1Q',
      sales: 100000,
    ),
    StatsModel(
      dateTime: '20200630',
      year: 2020,
      term: '2Q',
      sales: 110000,
    ),
    StatsModel(
      dateTime: '20200930',
      year: 2020,
      term: '3Q',
      sales: 103000,
    ),
    StatsModel(
      dateTime: '20201231',
      year: 2020,
      term: '4Q',
      sales: 132000,
    ),
    StatsModel(
      dateTime: '20210331',
      year: 2021,
      term: '1Q',
      sales: 120000,
    ),
  ];
}
