import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/corporation_model.dart';
import 'package:yachtOne/screens/stock_info/stats/stats_view_model.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class StatsView extends StatelessWidget {
  final InvestAddressModel investAddressModel;
  final StatsViewModel statsViewModel;
  const StatsView({
    Key? key,
    required this.investAddressModel,
    required this.statsViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => statsViewModel.isLoading.value
          ? Container(
              // color: Colors.blue,
              child: Column(
                children: [
                  Row(
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
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "재무정보",
                          style: questTitleTextStyle,
                        ),
                        Text(
                          "최근 사업보고서 기준",
                          style: questTermTextStyle.copyWith(fontSize: 12.w),
                        ),
                      ],
                    ),
                    Container(
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
                                    statsViewModel.changeTerm();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
                                    child: Text(statsViewModel.toggleTerms[index],
                                        style: questTermTextStyle.copyWith(
                                          color: statsViewModel.selectedTerm.value == index ? white : yachtMidGrey,
                                        )
                                        // contentStyle.copyWith(
                                        //     color: statsViewModel
                                        //                 .selectedTerm.value ==
                                        //             index
                                        //         ? termToggleSelectedTextColor
                                        //         : termToggleNotSelectedTextColor),
                                        ),
                                  ),
                                ),
                                if (index < statsViewModel.toggleTerms.length - 1)
                                  Container(
                                    width: 1.5.w,
                                    height: questTermTextStyle.fontSize,
                                    color: yachtLightGrey,
                                  )
                              ],
                            ),
                          )),
                    )),
                  ],
                ),
                verticalSpaceSmall,
                IncomeStatementChart(statsViewModel: statsViewModel, fieldName: 'salesIS', title: "매출액"),
                verticalSpaceExtraLarge,
                IncomeStatementChart(statsViewModel: statsViewModel, fieldName: 'operatingIncomeIS', title: "영업이익"),
                verticalSpaceExtraLarge,
                IncomeStatementChart(statsViewModel: statsViewModel, fieldName: 'netIncomeIS', title: "당기순이익"),
              ],
            ),
    );
  }
}

DataLabelSettings _dataLabelSettings = DataLabelSettings(
    // margin: EdgeInsets.only(bottom: 30.w),

    textStyle: mostDetailedContentTextStyle.copyWith(color: yachtRed),
    isVisible: true,
    alignment: ChartAlignment.near,
    // labelAlignment: ChartDataLabelAlignment.outer,
    offset: Offset(0, 8.w),
    labelPosition: ChartDataLabelPosition.outside,
    labelAlignment: ChartDataLabelAlignment.outer);

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
        Text(title!, style: stockInfoStatsTitle.copyWith(fontSize: 14.w)),
        // Text(
        //   "단위: ",
        //   style: questTermTextStyle.copyWith(fontSize: 12.w),
        // ),
        Obx(() {
          if (statsViewModel!.chartStats == null || statsViewModel!.chartStats!.length == 0)
            return Container(
              height: 130.w,
              child: Center(child: Text("제공된 데이터가 없습니다.")),
            );
          else {
            return Container(
              // color: Colors.yellow[200],
              height: 130.w,
              child: SfCartesianChart(
                // zoomPanBehavior: ZoomPanBehavior(
                //   zoomMode: ZoomMode.x,
                //   enablePanning: true,
                // ),
                plotAreaBorderWidth: 0,
                borderWidth: 0,

                trackballBehavior: TrackballBehavior(enable: true),
                series: statsViewModel!.selectedTerm.value == 0
                    // 연간일 때
                    ? _columnSeries(statsViewModel!, fieldName!, title!).sublist(3)
                    // 분기일 때
                    : _columnSeries(statsViewModel!, fieldName!, title!),

                primaryXAxis: CategoryAxis(
                    labelStyle: mostDetailedContentTextStyle.copyWith(fontSize: 14.w),
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
                    labelPosition: ChartDataLabelPosition.outside,
                    // tickPosition: TickPosition.outside,

                    majorTickLines: MajorTickLines(width: 0),
                    numberFormat: formatPriceKRW,
                    axisLine: AxisLine(width: 1),
                    majorGridLines: MajorGridLines(width: 1),
                    // maximum: fieldName == "salesIS"
                    //     ? statsViewModel!.maxSales!

                    //     : fieldName == "operatingIncomeIS"
                    //         ? statsViewModel!.maxOperatingIncome!
                    //         : statsViewModel!.maxNetIncome!
                    // minimum: statsViewModel!.chartStats.length == 1
                    //     ? 0
                    //     : fieldName == "salesIS"
                    //         ? statsViewModel!.minSales! -
                    //             (statsViewModel!.maxSales! -
                    //                     statsViewModel!.minSales!) /
                    //                 2
                    //         : fieldName == "operatingIncomeIS"
                    //             ? statsViewModel!.minOperatingIncome! -
                    //                 (statsViewModel!.maxOperatingIncome! -
                    //                         statsViewModel!.minOperatingIncome!) /
                    //                     2
                    //             : statsViewModel!.minNetIncome! -
                    //                 (statsViewModel!.maxNetIncome! -
                    //                         statsViewModel!.minNetIncome!) /
                    //                     3,
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
            );
          }
        }),
      ],
    );
  }

  List<ColumnSeries> _columnSeries(StatsViewModel statsViewModel, String fieldName, String title) => [
        ColumnSeries<StatsModel, String>(
          dataLabelMapper: (stats, index) {
            // if (index == statsViewModel.chartStats.length - 1)
            return stats.toMap()[fieldName] == null ? "" : parseBigNumberShortKRW(stats.toMap()[fieldName]!);
            // else
            //   return "";
          },
          dataLabelSettings: _dataLabelSettings,
          dataSource: statsViewModel.chartStats!,
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
          color: yachtRed.withOpacity(.4),
        ),
        ColumnSeries<StatsModel, String>(
          dataLabelMapper: (stats, index) {
            // if (index == statsViewModel.chartStats.length - 1)
            return stats.toMap()[fieldName] == null ? "" : parseBigNumberShortKRW(stats.toMap()[fieldName]!);
            // else
            //   return "";
          },
          dataLabelSettings: _dataLabelSettings,
          dataSource: statsViewModel.chartStats!,
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
          color: yachtRed.withOpacity(.6),
        ),
        ColumnSeries<StatsModel, String>(
          dataLabelMapper: (stats, index) {
            // if (index == statsViewModel.chartStats.length - 1)
            return stats.toMap()[fieldName] == null ? "" : parseBigNumberShortKRW(stats.toMap()[fieldName]!);
            // else
            //   return "";
          },
          dataLabelSettings: _dataLabelSettings,
          dataSource: statsViewModel.chartStats!,
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
          color: yachtRed.withOpacity(.8),
        ),
        ColumnSeries<StatsModel, String>(
          dataLabelMapper: (stats, index) {
            // if (index == statsViewModel.chartStats.length - 1)
            return stats.toMap()[fieldName] == null ? "" : parseBigNumberShortKRW(stats.toMap()[fieldName]!);
            // else
            //   return "";
            //index가 0이면서 사업보고서만 있으면 1년임을 표시
            // if (_.term == "Y")
            //   return "1년* " + parseBigNumberShortKRW(_.salesIS!);
          },
          dataLabelSettings: _dataLabelSettings,
          dataSource: statsViewModel.chartStats!,
          xValueMapper: (StatsModel stats, _) => stats.year,
          yValueMapper: (StatsModel stats, _) {
            var result;
            if (stats.dateTime!.substring(4, 6) == '12') {
              result = stats.toMap()[fieldName];
            }
            return result;
          },
          width: statsViewModel.width,
          spacing: statsViewModel.spacing,
          color: yachtRed,
        ),
      ];
}

// double spacing = 0;
