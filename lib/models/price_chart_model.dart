import 'dart:convert';

class PriceChartModel {
  String?
      dateTime; // Firebase에서 String으로 받아온 뒤 차트에서 String -> DateTime으로 처리하기 위함
  num? open;
  num? high;
  num? low;
  num? close;
  num? tradeVolume;
  num? tradeAmount;
  PriceChartModel({
    this.dateTime,
    this.open,
    this.high,
    this.low,
    this.close,
    this.tradeVolume,
    this.tradeAmount,
  });

  PriceChartModel copyWith({
    String? dateTime,
    num? open,
    num? high,
    num? low,
    num? close,
    num? tradeVolume,
    num? tradeAmount,
  }) {
    return PriceChartModel(
      dateTime: dateTime ?? this.dateTime,
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
      dateTime: map['date'],
      open: map['open'],
      high: map['high'],
      low: map['low'],
      close: map['close'],
      tradeVolume: map['tradeVol'],
      tradeAmount: map['tradeAmount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PriceChartModel.fromJson(String source) =>
      PriceChartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PriceChartModel(dateTime: $dateTime, open: $open, high: $high, low: $low, close: $close, tradeVolume: $tradeVolume, tradeAmount: $tradeAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PriceChartModel &&
        other.dateTime == dateTime &&
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
        open.hashCode ^
        high.hashCode ^
        low.hashCode ^
        close.hashCode ^
        tradeVolume.hashCode ^
        tradeAmount.hashCode;
  }
}
