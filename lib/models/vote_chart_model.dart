import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class VoteChart {
  final String name;
  final double votePercentage;
  final charts.Color color;

  VoteChart(this.name, this.votePercentage, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
