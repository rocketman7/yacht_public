import 'dart:convert';

class PriceChartModel {
  final String?
      dateTime; // Firebase에서 String으로 받아온 뒤 차트에서 String -> DateTime으로 처리하기 위함
  final String? cycle;
  final num? open;
  final num? high;
  final num? low;
  final num? close;
  final num? tradeVolume;
  final num? tradeAmount;
  PriceChartModel({
    this.dateTime,
    this.cycle,
    this.open,
    this.high,
    this.low,
    this.close,
    this.tradeVolume,
    this.tradeAmount,
  });

  PriceChartModel copyWith({
    String? dateTime,
    String? cycle,
    num? open,
    num? high,
    num? low,
    num? close,
    num? tradeVolume,
    num? tradeAmount,
  }) {
    return PriceChartModel(
      dateTime: dateTime ?? this.dateTime,
      cycle: cycle ?? this.cycle,
      open: open ?? this.open,
      high: high ?? this.high,
      low: low ?? this.low,
      close: close ?? this.close,
      tradeVolume: tradeVolume ?? this.tradeVolume,
      tradeAmount: tradeAmount ?? this.tradeAmount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'cycle': cycle,
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'tradeVolume': tradeVolume,
      'tradeAmount': tradeAmount,
    };
  }

  factory PriceChartModel.fromMap(Map<String, dynamic> map) {
    return PriceChartModel(
      dateTime: map['dateTime'],
      cycle: map['cycle'],
      open: map['open'],
      high: map['high'],
      low: map['low'],
      close: map['close'],
      tradeVolume: map['tradeVolume'],
      tradeAmount: map['tradeAmount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PriceChartModel.fromJson(String source) =>
      PriceChartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PriceChartModel(dateTime: $dateTime, cycle: $cycle, open: $open, high: $high, low: $low, close: $close, tradeVolume: $tradeVolume, tradeAmount: $tradeAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PriceChartModel &&
        other.dateTime == dateTime &&
        other.cycle == cycle &&
        other.open == open &&
        other.high == high &&
        other.low == low &&
        other.close == close &&
        other.tradeVolume == tradeVolume &&
        other.tradeAmount == tradeAmount;
  }

  @override
  int get hashCode {
    return dateTime.hashCode ^
        cycle.hashCode ^
        open.hashCode ^
        high.hashCode ^
        low.hashCode ^
        close.hashCode ^
        tradeVolume.hashCode ^
        tradeAmount.hashCode;
  }
}
