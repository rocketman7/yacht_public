import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/stats/stats_view_model.dart';
import 'package:yachtOne/styles/style_constants.dart';

class StatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatsViewModel>(
      init: StatsViewModel(),
      builder: (statsViewModel) {
        // return Container(
        //   child: Obx(() => Text(statsViewModel.text.value)),
        // );
        return statsViewModel.isFetching
            ? Container(color: Colors.blue)
            : Column(
                children: [
                  IncomeStatementChart(
                      statsViewModel: statsViewModel,
                      fieldName: 'salesIS',
                      title: "매출액"),
                  verticalSpaceExtraLarge,
                  IncomeStatementChart(
                      statsViewModel: statsViewModel,
                      fieldName: 'operatingIncomeIS',
                      title: "영업이익"),
                  verticalSpaceExtraLarge,
                  IncomeStatementChart(
                      statsViewModel: statsViewModel,
                      fieldName: 'netIncomeIS',
                      title: "당기순이익"),
                ],
              );
      },
    );
  }
}

class IncomeStatementChart extends StatelessWidget {
  final StatsViewModel? statsViewModel;
  final String? fieldName;
  final String? title;

  const IncomeStatementChart({
    Key? key,
    this.statsViewModel,
    this.fieldName,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: kHorizontalPadding,
          child: Text(title!, style: contentStyle),
        ),
        Container(
          height: 150,
          child: SfCartesianChart(
            // zoomPanBehavior: ZoomPanBehavior(
            //   zoomMode: ZoomMode.x,
            //   enablePanning: true,
            // ),
            plotAreaBorderWidth: 1,
            borderWidth: 1,

            trackballBehavior: TrackballBehavior(enable: true),
            series: [
              ColumnSeries<StatsModel, String>(
                dataLabelMapper: (_, index) {
                  if (index == statsViewModel!.quarterStatsList!.length - 1)
                    return parseBigNumberShortKRW(_.toMap()[fieldName]!);
                  else
                    return "";
                },
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: statsViewModel!.quarterStatsList!,
                xValueMapper: (StatsModel stats, _) => stats.year,
                yValueMapper: (StatsModel stats, _) {
                  var result;
                  if (stats.dateTime!.substring(4, 6) == '03') {
                    result = stats.toMap()[fieldName]!;
                  }
                  return result;
                },
                color: barColor1,
              ),
              ColumnSeries<StatsModel, String>(
                dataLabelMapper: (_, index) {
                  if (index == statsViewModel!.quarterStatsList!.length - 1)
                    return parseBigNumberShortKRW(_.toMap()[fieldName]!);
                  else
                    return "";
                },
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: statsViewModel!.quarterStatsList!,
                xValueMapper: (StatsModel stats, _) => stats.year,
                yValueMapper: (StatsModel stats, _) {
                  var result;
                  if (stats.dateTime!.substring(4, 6) == '06') {
                    result = stats.toMap()[fieldName]!;
                  }
                  return result;
                },
                color: barColor2,
              ),
              ColumnSeries<StatsModel, String>(
                dataLabelMapper: (_, index) {
                  if (index == statsViewModel!.quarterStatsList!.length - 1)
                    return parseBigNumberShortKRW(_.toMap()[fieldName]!);
                  else
                    return "";
                },
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: statsViewModel!.quarterStatsList!,
                xValueMapper: (StatsModel stats, _) => stats.year,
                yValueMapper: (StatsModel stats, _) {
                  var result;
                  if (stats.dateTime!.substring(4, 6) == '09') {
                    result = stats.toMap()[fieldName]!;
                  }
                  return result;
                },
                color: barColor3,
              ),
              ColumnSeries<StatsModel, String>(
                dataLabelMapper: (_, index) {
                  if (index == statsViewModel!.quarterStatsList!.length - 1)
                    return parseBigNumberShortKRW(_.toMap()[fieldName]!);
                  else
                    return "";
                  //index가 0이면서 사업보고서만 있으면 1년임을 표시
                  // if (_.term == "Y")
                  //   return "1년* " + parseBigNumberShortKRW(_.salesIS!);
                },
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: statsViewModel!.quarterStatsList!,
                xValueMapper: (StatsModel stats, _) => stats.year,
                yValueMapper: (StatsModel stats, _) {
                  var result;
                  if (stats.dateTime!.substring(4, 6) == '12') {
                    result = stats.toMap()[fieldName]!;
                  }
                  return result;
                },
                color: barColor4,
              ),
              LineSeries<StatsModel, String>(
                // dataLabelMapper: (_, index) {
                //   if (index == statsViewModel!.quarterStatsList!.length - 1)
                //     return parseBigNumberShortKRW(_.salesIS!);
                //   else
                //     return "";
                //   //index가 0이면서 사업보고서만 있으면 1년임을 표시
                //   // if (_.term == "Y")
                //   //   return "1년* " + parseBigNumberShortKRW(_.salesIS!);
                // },
                // dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: statsViewModel!.yearStatsList,
                xValueMapper: (StatsModel stats, _) => stats.year,
                yValueMapper: (StatsModel stats, _) {
                  return stats.toMap()[fieldName]!;
                },
                color: accLineColor,
                width: 3.6,
                yAxisName: 'yearAcc',
              ),
            ],
            primaryXAxis: CategoryAxis(
                labelAlignment: LabelAlignment.center,
                // edgeLabelPlacement: EdgeLabelPlacement.shift,
                // labelPlacement: LabelPlacement.betweenTicks,
                rangePadding: ChartRangePadding.none,
                // zoomPosition: 1,
                // zoomFactor: 0.85,
                // isInversed: true,
                crossesAt: 0,
                placeLabelsNearAxisLine: false,
                axisLine: AxisLine(width: 0),
                majorGridLines: MajorGridLines(width: 0),
                minorGridLines: MinorGridLines(width: 0),
                majorTickLines: MajorTickLines(width: 0),
                minorTickLines: MinorTickLines(width: 0),
                isVisible: true),
            primaryYAxis: NumericAxis(
                majorTickLines: MajorTickLines(width: 0),
                numberFormat: formatPriceKRW,
                axisLine: AxisLine(width: 1),
                majorGridLines: MajorGridLines(width: 1),
                // maximum: 150000,
                // minimum: 40000000000000,
                //     85000, // 차트에 그려지는 PriceChartModel의 low중 min값 받아서 영역의 상단 4/5에만 그려지도록 maximum 값 설정
                // majorGridLines: MajorGridLines(width: 0),
                isVisible: false),
            axes: [
              NumericAxis(
                // minimum: 200000000000000,
                isVisible: false,
                name: 'yearAcc',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OperatingIncomeChart extends StatelessWidget {
  final StatsViewModel? statsViewModel;
  const OperatingIncomeChart({
    Key? key,
    this.statsViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: kHorizontalPadding,
          child: Text("영업이익", style: contentStyle),
        ),
        Container(
          height: 150,
          child: SfCartesianChart(
            // zoomPanBehavior: ZoomPanBehavior(
            //   zoomMode: ZoomMode.x,
            //   enablePanning: true,
            // ),
            plotAreaBorderWidth: 0,
            borderWidth: 0,

            trackballBehavior: TrackballBehavior(enable: true),
            series: [
              ColumnSeries<StatsModel, String>(
                dataLabelMapper: (_, index) {
                  if (index == statsViewModel!.quarterStatsList!.length - 1)
                    return parseBigNumberShortKRW(_.operatingIncomeIS!);
                  else
                    return "";
                },
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: statsViewModel!.quarterStatsList!,
                xValueMapper: (StatsModel stats, _) => stats.year,
                yValueMapper: (StatsModel stats, _) {
                  var result;
                  if (stats.dateTime!.substring(4, 6) == '03') {
                    result = stats.operatingIncomeIS!;
                  }
                  return result;
                },
                color: barColor1,
              ),
              ColumnSeries<StatsModel, String>(
                dataLabelMapper: (_, index) {
                  if (index == statsViewModel!.quarterStatsList!.length - 1)
                    return parseBigNumberShortKRW(_.operatingIncomeIS!);
                  else
                    return "";
                },
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: statsViewModel!.quarterStatsList!,
                xValueMapper: (StatsModel stats, _) => stats.year,
                yValueMapper: (StatsModel stats, _) {
                  var result;
                  if (stats.dateTime!.substring(4, 6) == '06') {
                    result = stats.operatingIncomeIS!;
                  }
                  return result;
                },
                color: barColor2,
              ),
              ColumnSeries<StatsModel, String>(
                dataLabelMapper: (_, index) {
                  if (index == statsViewModel!.quarterStatsList!.length - 1)
                    return parseBigNumberShortKRW(_.operatingIncomeIS!);
                  else
                    return "";
                },
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: statsViewModel!.quarterStatsList!,
                xValueMapper: (StatsModel stats, _) => stats.year,
                yValueMapper: (StatsModel stats, _) {
                  var result;
                  if (stats.dateTime!.substring(4, 6) == '09') {
                    result = stats.operatingIncomeIS!;
                  }
                  return result;
                },
                color: barColor3,
              ),
              ColumnSeries<StatsModel, String>(
                dataLabelMapper: (_, index) {
                  if (index == statsViewModel!.quarterStatsList!.length - 1)
                    return parseBigNumberShortKRW(_.operatingIncomeIS!);
                  else
                    return "";
                  //index가 0이면서 사업보고서만 있으면 1년임을 표시
                  // if (_.term == "Y")
                  //   return "1년* " + parseBigNumberShortKRW(_.operatingIncomeIS!);
                },
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: statsViewModel!.quarterStatsList!,
                xValueMapper: (StatsModel stats, _) => stats.year,
                yValueMapper: (StatsModel stats, _) {
                  var result;
                  if (stats.dateTime!.substring(4, 6) == '12') {
                    result = stats.operatingIncomeIS!;
                  }
                  return result;
                },
                color: barColor4,
              ),
              LineSeries<StatsModel, String>(
                // dataLabelMapper: (_, index) {
                //   if (index == statsViewModel!.quarterStatsList!.length - 1)
                //     return parseBigNumberShortKRW(_.operatingIncomeIS!);
                //   else
                //     return "";
                //   //index가 0이면서 사업보고서만 있으면 1년임을 표시
                //   // if (_.term == "Y")
                //   //   return "1년* " + parseBigNumberShortKRW(_.operatingIncomeIS!);
                // },
                // dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: statsViewModel!.yearStatsList,
                xValueMapper: (StatsModel stats, _) => stats.year,
                yValueMapper: (StatsModel stats, _) {
                  return stats.operatingIncomeIS!;
                },
                color: accLineColor,
                width: 3.6,
                yAxisName: 'yearAcc',
              )
            ],
            primaryXAxis: CategoryAxis(
                labelAlignment: LabelAlignment.center,
                // edgeLabelPlacement: EdgeLabelPlacement.shift,
                // labelPlacement: LabelPlacement.betweenTicks,
                rangePadding: ChartRangePadding.none,
                // zoomPosition: 1,
                // zoomFactor: 0.85,
                // isInversed: true,
                axisLine: AxisLine(width: 0),
                majorGridLines: MajorGridLines(width: 0),
                minorGridLines: MinorGridLines(width: 0),
                majorTickLines: MajorTickLines(width: 0),
                minorTickLines: MinorTickLines(width: 0),
                isVisible: true),
            primaryYAxis: NumericAxis(
                numberFormat: formatPriceKRW,
                // maximum: 150000,
                // minimum: 40000000000000,
                //     85000, // 차트에 그려지는 PriceChartModel의 low중 min값 받아서 영역의 상단 4/5에만 그려지도록 maximum 값 설정
                // majorGridLines: MajorGridLines(width: 0),
                isVisible: false),
            axes: [
              NumericAxis(
                // minimum: 200000000000000,
                isVisible: false,
                name: 'yearAcc',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
