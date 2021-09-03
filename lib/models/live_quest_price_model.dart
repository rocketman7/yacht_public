import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:yachtOne/models/chart_price_model.dart';

class LiveQuestPriceModel {
  final String issueCode;
  final List<ChartPriceModel> chartPrices;
  LiveQuestPriceModel({
    required this.issueCode,
    required this.chartPrices,
  });

  LiveQuestPriceModel copyWith({
    String? issueCode,
    List<ChartPriceModel>? chartPrices,
  }) {
    return LiveQuestPriceModel(
      issueCode: issueCode ?? this.issueCode,
      chartPrices: chartPrices ?? this.chartPrices,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'issueCode': issueCode,
      'chartPrices': chartPrices.map((x) => x.toMap()).toList(),
    };
  }

  factory LiveQuestPriceModel.fromMap(String issueCode, List<ChartPriceModel> chartPrices) {
    return LiveQuestPriceModel(
      issueCode: issueCode,
      chartPrices: chartPrices,
    );
  }

  String toJson() => json.encode(toMap());

  // factory LiveQuestPriceModel.fromJson(String source) => LiveQuestPriceModel.fromMap(json.decode(source));

  @override
  String toString() => 'LiveQuestPriceModel(issueCode: $issueCode, chartPrices: $chartPrices)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LiveQuestPriceModel && other.issueCode == issueCode && listEquals(other.chartPrices, chartPrices);
  }

  @override
  int get hashCode => issueCode.hashCode ^ chartPrices.hashCode;
}
