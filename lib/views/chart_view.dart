import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:yachtOne/models/chart_model.dart';
import 'package:yachtOne/view_models/chart_view_model.dart';

class ChartView extends StatefulWidget {
  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ChartViewModel(),
      builder: (context, model, child) {
        print(model.chartList);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Syncfusion Flutter chart'),
          ),
          body: (model.isBusy)
              ? Container()
              : Column(
                  children: [
                    Container(
                      height: 300,
                      child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          // Chart title
                          title: ChartTitle(text: 'Tesla this week'),
                          // Enable legend
                          legend: Legend(isVisible: false),
                          // Enable tooltip
                          // tooltipBehavior: TooltipBehavior(enable: true),
                          trackballBehavior: TrackballBehavior(
                            enable: true,
                            activationMode: ActivationMode.singleTap,
                            // tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
                            // lineType: TrackballLineType.horizontal,
                            tooltipSettings: InteractiveTooltip(),
                          ),
                          series: <CandleSeries<ChartModel, String>>[
                            CandleSeries<ChartModel, String>(
                                bullColor: Colors.red,
                                bearColor: Colors.blue,
                                dataSource: List.generate(
                                    model.chartList.length,
                                    (index) => model.chartList[index]),
                                // <ChartModel>[
                                //   // _SalesData(model.chartList[0].date, 445.74, 446.60,
                                //   //     428.93, 430.83),
                                //   model.chartList[0],
                                //   // _SalesData('10/21', 423.25, 432.90, 421.25, 422.64),
                                //   // _SalesData('10/22', 442.15, 444.74, 424.72, 431.59),
                                //   // _SalesData('10/23', 449.74, 465.75, 447.77, 461.30),
                                //   // _SalesData('10/24', 469.74, 490.75, 468.77, 480.30),
                                // ],
                                xValueMapper: (ChartModel chart, _) =>
                                    chart.date,
                                lowValueMapper: (ChartModel chart, _) =>
                                    chart.low,
                                highValueMapper: (ChartModel chart, _) =>
                                    chart.high,
                                openValueMapper: (ChartModel chart, _) =>
                                    chart.open,
                                closeValueMapper: (ChartModel chart, _) =>
                                    chart.close,
                                enableSolidCandles: true,

                                // yValueMapper: (_SalesData sales, _) => sales.sales,
                                // Enable data label
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: false))
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("1W"),
                        Text("1M"),
                        Text("3M"),
                        Text("1Y"),
                      ],
                    )
                  ],
                ),
        );
      },
    );
  }
}
