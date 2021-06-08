import 'dart:convert';
import 'dart:core';

class StatsModel {
  final num? year;
  final String? term;
  final String? dateTime;
  // FS
  final num? currentAssets; // 유동자산
  final num? nonCurrentAssets; // 비유동자산
  final num? totalAssets; // 자산총계
  final num? currentLiabilities; // 유동부채
  final num? nonCurrentLiabilities; // 비유동부채
  final num? totalLiabilities; // 부채총계
  final num? shareholdersEquity; // 자본금
  final num? retainedEarnings; // 이익잉여금
  final num? totalShareholdersEquity; // 자본총계
  // IS
  final num? sales; // 매출액
  final num? operatingIncome; // 영업이익
  final num? incomeBeforeTaxes; // 법인세차감전 순이익
  final num? netIncome; // 당기순이익

  final bool? isOfficial; // 확정
  StatsModel({
    this.year,
    this.term,
    this.dateTime,
    this.currentAssets,
    this.nonCurrentAssets,
    this.totalAssets,
    this.currentLiabilities,
    this.nonCurrentLiabilities,
    this.totalLiabilities,
    this.shareholdersEquity,
    this.retainedEarnings,
    this.totalShareholdersEquity,
    this.sales,
    this.operatingIncome,
    this.incomeBeforeTaxes,
    this.netIncome,
    this.isOfficial,
  });

  StatsModel copyWith({
    num? year,
    String? term,
    String? dateTime,
    num? currentAssets,
    num? nonCurrentAssets,
    num? totalAssets,
    num? currentLiabilities,
    num? nonCurrentLiabilities,
    num? totalLiabilities,
    num? shareholdersEquity,
    num? retainedEarnings,
    num? totalShareholdersEquity,
    num? sales,
    num? operatingIncome,
    num? incomeBeforeTaxes,
    num? netIncome,
    bool? isOfficial,
  }) {
    return StatsModel(
      year: year ?? this.year,
      term: term ?? this.term,
      dateTime: dateTime ?? this.dateTime,
      currentAssets: currentAssets ?? this.currentAssets,
      nonCurrentAssets: nonCurrentAssets ?? this.nonCurrentAssets,
      totalAssets: totalAssets ?? this.totalAssets,
      currentLiabilities: currentLiabilities ?? this.currentLiabilities,
      nonCurrentLiabilities:
          nonCurrentLiabilities ?? this.nonCurrentLiabilities,
      totalLiabilities: totalLiabilities ?? this.totalLiabilities,
      shareholdersEquity: shareholdersEquity ?? this.shareholdersEquity,
      retainedEarnings: retainedEarnings ?? this.retainedEarnings,
      totalShareholdersEquity:
          totalShareholdersEquity ?? this.totalShareholdersEquity,
      sales: sales ?? this.sales,
      operatingIncome: operatingIncome ?? this.operatingIncome,
      incomeBeforeTaxes: incomeBeforeTaxes ?? this.incomeBeforeTaxes,
      netIncome: netIncome ?? this.netIncome,
      isOfficial: isOfficial ?? this.isOfficial,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'term': term,
      'dateTime': dateTime,
      'currentAssets': currentAssets,
      'nonCurrentAssets': nonCurrentAssets,
      'totalAssets': totalAssets,
      'currentLiabilities': currentLiabilities,
      'nonCurrentLiabilities': nonCurrentLiabilities,
      'totalLiabilities': totalLiabilities,
      'shareholdersEquity': shareholdersEquity,
      'retainedEarnings': retainedEarnings,
      'totalShareholdersEquity': totalShareholdersEquity,
      'sales': sales,
      'operatingIncome': operatingIncome,
      'incomeBeforeTaxes': incomeBeforeTaxes,
      'netIncome': netIncome,
      'isOfficial': isOfficial,
    };
  }

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    return StatsModel(
      year: map['year'],
      term: map['term'],
      dateTime: map['dateTime'],
      currentAssets: map['currentAssets'],
      nonCurrentAssets: map['nonCurrentAssets'],
      totalAssets: map['totalAssets'],
      currentLiabilities: map['currentLiabilities'],
      nonCurrentLiabilities: map['nonCurrentLiabilities'],
      totalLiabilities: map['totalLiabilities'],
      shareholdersEquity: map['shareholdersEquity'],
      retainedEarnings: map['retainedEarnings'],
      totalShareholdersEquity: map['totalShareholdersEquity'],
      sales: map['sales'],
      operatingIncome: map['operatingIncome'],
      incomeBeforeTaxes: map['incomeBeforeTaxes'],
      netIncome: map['netIncome'],
      isOfficial: map['isOfficial'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StatsModel.fromJson(String source) =>
      StatsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StatsModel(year: $year, term: $term, dateTime: $dateTime, currentAssets: $currentAssets, nonCurrentAssets: $nonCurrentAssets, totalAssets: $totalAssets, currentLiabilities: $currentLiabilities, nonCurrentLiabilities: $nonCurrentLiabilities, totalLiabilities: $totalLiabilities, shareholdersEquity: $shareholdersEquity, retainedEarnings: $retainedEarnings, totalShareholdersEquity: $totalShareholdersEquity, sales: $sales, operatingIncome: $operatingIncome, incomeBeforeTaxes: $incomeBeforeTaxes, netIncome: $netIncome, isOfficial: $isOfficial)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StatsModel &&
        other.year == year &&
        other.term == term &&
        other.dateTime == dateTime &&
        other.currentAssets == currentAssets &&
        other.nonCurrentAssets == nonCurrentAssets &&
        other.totalAssets == totalAssets &&
        other.currentLiabilities == currentLiabilities &&
        other.nonCurrentLiabilities == nonCurrentLiabilities &&
        other.totalLiabilities == totalLiabilities &&
        other.shareholdersEquity == shareholdersEquity &&
        other.retainedEarnings == retainedEarnings &&
        other.totalShareholdersEquity == totalShareholdersEquity &&
        other.sales == sales &&
        other.operatingIncome == operatingIncome &&
        other.incomeBeforeTaxes == incomeBeforeTaxes &&
        other.netIncome == netIncome &&
        other.isOfficial == isOfficial;
  }

  @override
  int get hashCode {
    return year.hashCode ^
        term.hashCode ^
        dateTime.hashCode ^
        currentAssets.hashCode ^
        nonCurrentAssets.hashCode ^
        totalAssets.hashCode ^
        currentLiabilities.hashCode ^
        nonCurrentLiabilities.hashCode ^
        totalLiabilities.hashCode ^
        shareholdersEquity.hashCode ^
        retainedEarnings.hashCode ^
        totalShareholdersEquity.hashCode ^
        sales.hashCode ^
        operatingIncome.hashCode ^
        incomeBeforeTaxes.hashCode ^
        netIncome.hashCode ^
        isOfficial.hashCode;
  }
}
