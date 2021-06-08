import 'dart:convert';
import 'dart:core';

class StatsModel {
  final num? year;
  final String? dateTime;
  final String? term;
  final num? revenue;
  final num? profit;
  final num? operatingIncome;
  final num? netIncome;
  final num? equity;
  final num? debt;
  StatsModel({
    this.year,
    this.dateTime,
    this.term,
    this.revenue,
    this.profit,
    this.operatingIncome,
    this.netIncome,
    this.equity,
    this.debt,
  });

  StatsModel copyWith({
    num? year,
    String? dateTime,
    String? term,
    num? revenue,
    num? profit,
    num? operatingIncome,
    num? netIncome,
    num? equity,
    num? debt,
  }) {
    return StatsModel(
      year: year ?? this.year,
      dateTime: dateTime ?? this.dateTime,
      term: term ?? this.term,
      revenue: revenue ?? this.revenue,
      profit: profit ?? this.profit,
      operatingIncome: operatingIncome ?? this.operatingIncome,
      netIncome: netIncome ?? this.netIncome,
      equity: equity ?? this.equity,
      debt: debt ?? this.debt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'dateTime': dateTime,
      'term': term,
      'revenue': revenue,
      'profit': profit,
      'operatingIncome': operatingIncome,
      'netIncome': netIncome,
      'equity': equity,
      'debt': debt,
    };
  }

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    return StatsModel(
      year: map['year'],
      dateTime: map['dateTime'],
      term: map['term'],
      revenue: map['revenue'],
      profit: map['profit'],
      operatingIncome: map['operatingIncome'],
      netIncome: map['netIncome'],
      equity: map['equity'],
      debt: map['debt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StatsModel.fromJson(String source) =>
      StatsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StatsModel(year: $year, dateTime: $dateTime, term: $term, revenue: $revenue, profit: $profit, operatingIncome: $operatingIncome, netIncome: $netIncome, equity: $equity, debt: $debt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StatsModel &&
        other.year == year &&
        other.dateTime == dateTime &&
        other.term == term &&
        other.revenue == revenue &&
        other.profit == profit &&
        other.operatingIncome == operatingIncome &&
        other.netIncome == netIncome &&
        other.equity == equity &&
        other.debt == debt;
  }

  @override
  int get hashCode {
    return year.hashCode ^
        dateTime.hashCode ^
        term.hashCode ^
        revenue.hashCode ^
        profit.hashCode ^
        operatingIncome.hashCode ^
        netIncome.hashCode ^
        equity.hashCode ^
        debt.hashCode;
  }
}
