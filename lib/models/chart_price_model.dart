import 'dart:convert';

import 'package:flutter/foundation.dart';

class ChartPriceModel {
  final String? dateTime; // Firebase에서 String으로 받아온 뒤 차트에서 String -> DateTime으로 처리하기 위함
  final dynamic updateDateTime;
  final String? cycle;
  final num? open;
  final num? high;
  final num? low;
  final num? close;
  final num? tradeVolume;
  final num? tradeAmount;
  final num? normalizedClose;
  ChartPriceModel({
    this.dateTime,
    this.updateDateTime,
    this.cycle,
    this.open,
    this.high,
    this.low,
    this.close,
    this.tradeVolume,
    this.tradeAmount,
    this.normalizedClose,
  });

  ChartPriceModel copyWith({
    String? dateTime,
    dynamic? updateDateTime,
    String? cycle,
    num? open,
    num? high,
    num? low,
    num? close,
    num? tradeVolume,
    num? tradeAmount,
    num? normalizedClose,
  }) {
    return ChartPriceModel(
      dateTime: dateTime ?? this.dateTime,
      updateDateTime: updateDateTime ?? this.updateDateTime,
      cycle: cycle ?? this.cycle,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      tradeVolume: tradeVolume ?? this.tradeVolume,
      tradeAmount: tradeAmount ?? this.tradeAmount,
      normalizedClose: normalizedClose ?? this.normalizedClose,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'updateDateTime': updateDateTime,
      'cycle': cycle,
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'tradeVolume': tradeVolume,
      'tradeAmount': tradeAmount,
      'normalizedClose': normalizedClose,
    };
  }

  factory ChartPriceModel.fromMap(Map<String, dynamic> map) {
    return ChartPriceModel(
      dateTime: map['dateTime'],
      updateDateTime: map['updateDateTime'],
      cycle: map['cycle'],
      open: map['open'],
      high: map['high'],
      low: map['low'],
      close: map['close'],
      tradeVolume: map['tradeVolume'],
      tradeAmount: map['tradeAmount'],
      normalizedClose: map['normalizedClose'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChartPriceModel.fromJson(String source) => ChartPriceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ChartPriceModel(dateTime: $dateTime, updateDateTime: $updateDateTime, cycle: $cycle, open: $open, high: $high, low: $low, close: $close, tradeVolume: $tradeVolume, tradeAmount: $tradeAmount, normalizedClose: $normalizedClose)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChartPriceModel &&
        other.dateTime == dateTime &&
        other.updateDateTime == updateDateTime &&
        other.cycle == cycle &&
        other.open == open &&
        other.high == high &&
        other.low == low &&
        other.close == close &&
        other.tradeVolume == tradeVolume &&
        other.tradeAmount == tradeAmount &&
        other.normalizedClose == normalizedClose;
  }

  @override
  int get hashCode {
    return dateTime.hashCode ^
        updateDateTime.hashCode ^
        cycle.hashCode ^
        open.hashCode ^
        high.hashCode ^
        low.hashCode ^
        close.hashCode ^
        tradeVolume.hashCode ^
        tradeAmount.hashCode ^
        normalizedClose.hashCode;
  }
}
