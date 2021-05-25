import 'dart:convert';

import 'package:yachtOne/views/constants/holiday.dart';

class ChartModel {
  String? date;
  double? open;
  double? high;
  double? low;
  double? close;
  double? volume;
  ChartModel(
      {this.date, this.open, this.high, this.low, this.close, this.volume});
  // DateTime dateTime;

  ChartModel copyWith({
    String? date,
    double? open,
    double? high,
    double? low,
    double? close,
    double? volume,
  }) {
    return ChartModel(
        date: date ?? this.date,
        open: open ?? this.open,
        high: high ?? this.high,
        low: low ?? this.low,
        close: close ?? this.close,
        volume: volume ?? this.volume);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'open': open,
      'high': high,
      'low': low,
      'close': close,
      'volume': volume,
    };
  }

  factory ChartModel.fromData(Map<String, dynamic>? data) {
    if (data == null)
      return ChartModel(
          date: null,
          open: null,
          high: null,
          low: null,
          close: null,
          volume: null);

    double? open = double.tryParse(data['open'].toString());
    double? high = double.tryParse(data['high'].toString());
    double? low = double.tryParse(data['low'].toString());
    double? close = double.tryParse(data['close'].toString());
    double? volume = double.tryParse(data['volume'].toString());
    return ChartModel(
      date: data['date'],
      open: open,
      high: high,
      low: low,
      close: close,
      volume: volume,
    );
  }

  factory ChartModel.fromJson(String source) =>
      ChartModel.fromData(json.decode(source));

  @override
  String toString() {
    return 'ChartModel(date: $date, open: $open, high: $high, low: $low, close: $close, volume: $volume)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ChartModel &&
        o.date == date &&
        o.open == open &&
        o.high == high &&
        o.low == low &&
        o.close == close &&
        o.volume == volume;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        open.hashCode ^
        high.hashCode ^
        low.hashCode ^
        close.hashCode ^
        volume.hashCode;
  }
}
