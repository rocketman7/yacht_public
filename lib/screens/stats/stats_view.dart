import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        return statsViewModel.isLoading
            ? Container(
                color: Colors.blue,
                child: Column(
                  children: [
                    Padding(
                      padding: kHorizontalPadding,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            " ",
                            style: subtitleStyle.copyWith(color: Colors.black),
                          ),
                          Text(
                            " ",
                            style: detailStyle.copyWith(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Padding(
                    padding: kHorizontalPadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "기업정보",
                          style: subtitleStyle.copyWith(color: Colors.black),
                        ),
                        Text(
                          "최근 사업보고서 기준",
                          style: detailStyle.copyWith(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceSmall,
                  Padding(
                    padding: kHorizontalPadding,
                    child: Container(
                        // alignment: Alignment.centerRight,
                        // height: verticalSpaceLarge.height,
                        // width: double.infinity,

                        child: Obx(
                      () => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: List.generate(
                            statsViewModel.toggleTerms.length,
                            (index) => Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    statsViewModel.selectedTerm(index);
                                    print(statsViewModel.selectedTerm.value);
                                    statsViewModel.changeTerm();
                                  },
                                  child: toggleButton(
                                    Text(statsViewModel.toggleTerms[index],
                                        style: contentStyle
                                        // contentStyle.copyWith(
                                        //     color: statsViewModel
                                        //                 .selectedTerm.value ==
                                        //             index
                                        //         ? termToggleSelectedTextColor
                                        //         : termToggleNotSelectedTextColor),
                                        ),
                                    statsViewModel.selectedTerm.value == index
                                        ? toggleButtonColor
                                        : Colors.transparent,
                                  ),
                                ),
                                if (index <
                                    statsViewModel.toggleTerms.length - 1)
                                  horizontalSpaceMedium
                              ],
                            ),
                          )),
                    )),
                  ),
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
          height: 110,
          child: SfCartesianChart(
            // zoomPanBehavior: ZoomPanBehavior(
            //   zoomMode: ZoomMode.x,
            //   enablePanning: true,
            // ),
            plotAreaBorderWidth: 0,
            borderWidth: 0,

            trackballBehavior: TrackballBehavior(enable: true),
            series: statsViewModel!.selectedTerm.value == 0
                ? _columnSeries(statsViewModel!, fieldName!, title!).sublist(3)
                : _columnSeries(statsViewModel!, fieldName!, title!),

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
                maximum: fieldName == "salesIS"
                    ? statsViewModel!.maxSales
                    : fieldName == "operatingIncomeIS"
                        ? statsViewModel!.maxOperatingIncome
                        : statsViewModel!.maxNetIncome,
                minimum: statsViewModel!.chartStats.length == 1
                    ? 0
                    : fieldName == "salesIS"
                        ? statsViewModel!.minSales! -
                            (statsViewModel!.maxSales! -
                                    statsViewModel!.minSales!) /
                                2
                        : fieldName == "operatingIncomeIS"
                            ? statsViewModel!.minOperatingIncome! -
                                (statsViewModel!.maxOperatingIncome! -
                                        statsViewModel!.minOperatingIncome!) /
                                    2
                            : statsViewModel!.minNetIncome! -
                                (statsViewModel!.maxNetIncome! -
                                        statsViewModel!.minNetIncome!) /
                                    3,
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

  List<ColumnSeries> _columnSeries(
          StatsViewModel statsViewModel, String fieldName, String title) =>
      [
        ColumnSeries<StatsModel, String>(
          dataLabelMapper: (_, index) {
            if (index == statsViewModel.chartStats.length - 1)
              return parseBigNumberShortKRW(_.toMap()[fieldName]!);
            else
              return "";
          },
          dataLabelSettings: DataLabelSettings(isVisible: true),
          dataSource: statsViewModel.chartStats,
          xValueMapper: (StatsModel stats, _) => stats.year,
          yValueMapper: (StatsModel stats, _) {
            var result;
            if (stats.dateTime!.substring(4, 6) == '03') {
              result = stats.toMap()[fieldName]!;
            }
            return result;
          },
          width: statsViewModel.width,
          spacing: statsViewModel.spacing,
          color: barColor1,
        ),
        ColumnSeries<StatsModel, String>(
          dataLabelMapper: (_, index) {
            if (index == statsViewModel.chartStats.length - 1)
              return parseBigNumberShortKRW(_.toMap()[fieldName]!);
            else
              return "";
          },
          dataLabelSettings: DataLabelSettings(isVisible: true),
          dataSource: statsViewModel.chartStats,
          xValueMapper: (StatsModel stats, _) => stats.year,
          yValueMapper: (StatsModel stats, _) {
            var result;
            if (stats.dateTime!.substring(4, 6) == '06') {
              result = stats.toMap()[fieldName]!;
            }
            return result;
          },
          width: statsViewModel.width,
          spacing: statsViewModel.spacing,
          color: barColor2,
        ),
        ColumnSeries<StatsModel, String>(
          dataLabelMapper: (_, index) {
            if (index == statsViewModel.chartStats.length - 1)
              return parseBigNumberShortKRW(_.toMap()[fieldName]!);
            else
              return "";
          },
          dataLabelSettings: DataLabelSettings(isVisible: true),
          dataSource: statsViewModel.chartStats,
          xValueMapper: (StatsModel stats, _) => stats.year,
          yValueMapper: (StatsModel stats, _) {
            var result;
            if (stats.dateTime!.substring(4, 6) == '09') {
              result = stats.toMap()[fieldName]!;
            }
            return result;
          },
          width: statsViewModel.width,
          spacing: statsViewModel.spacing,
          color: barColor3,
        ),
        ColumnSeries<StatsModel, String>(
          dataLabelMapper: (_, index) {
            if (index == statsViewModel.chartStats.length - 1)
              return parseBigNumberShortKRW(_.toMap()[fieldName]!);
            else
              return "";
            //index가 0이면서 사업보고서만 있으면 1년임을 표시
            // if (_.term == "Y")
            //   return "1년* " + parseBigNumberShortKRW(_.salesIS!);
          },
          dataLabelSettings: DataLabelSettings(isVisible: true),
          dataSource: statsViewModel.chartStats,
          xValueMapper: (StatsModel stats, _) => stats.year,
          yValueMapper: (StatsModel stats, _) {
            var result;
            if (stats.dateTime!.substring(4, 6) == '12') {
              result = stats.toMap()[fieldName]!;
            }
            return result;
          },
          width: statsViewModel.width,
          spacing: statsViewModel.spacing,
          color: barColor4,
        ),
      ];
}

// double spacing = 0;
