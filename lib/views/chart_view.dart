import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';

class ChartView extends StatefulWidget {
  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body: Container(
          height: 300,
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Tesla this week'),
              // Enable legend
              legend: Legend(isVisible: false),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              trackballBehavior: TrackballBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                // tooltipDisplayMode: TrackballDisplayMode.nearestPoint,
                // lineType: TrackballLineType.horizontal,
                // tooltipSettings: InteractiveTooltip(),
              ),
              series: <CandleSeries<_SalesData, String>>[
                CandleSeries<_SalesData, String>(
                    bullColor: Colors.red,
                    bearColor: Colors.blue,
                    dataSource: <_SalesData>[
                      _SalesData('10/19', 445.74, 446.60, 428.93, 430.83),
                      _SalesData('10/20', 430.91, 430.91, 419.10, 421.94),
                      _SalesData('10/21', 423.25, 432.90, 421.25, 422.64),
                      _SalesData('10/22', 442.15, 444.74, 424.72, 431.59),
                      _SalesData('10/23', 449.74, 465.75, 447.77, 461.30),
                      _SalesData('10/24', 469.74, 490.75, 468.77, 480.30),
                    ],
                    xValueMapper: (_SalesData sales, _) => sales.date,
                    lowValueMapper: (_SalesData sales, _) => sales.low,
                    highValueMapper: (_SalesData sales, _) => sales.high,
                    openValueMapper: (_SalesData sales, _) => sales.open,
                    closeValueMapper: (_SalesData sales, _) => sales.close,
                    enableSolidCandles: true,

                    // yValueMapper: (_SalesData sales, _) => sales.sales,
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: false))
              ]),
        ));
  }
}

class _SalesData {
  _SalesData(
    this.date,
    this.open,
    this.high,
    this.low,
    this.close,
  );

  final String date;
  final double open;
  final double high;
  final double low;
  final double close;
}
