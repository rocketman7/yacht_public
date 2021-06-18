import 'dart:convert';
import 'dart:core';

class StatsModel {
  final String? year;
  final String? term;
  final String? dateTime;
  // BS
  final num? currentAssetsBS; // 유동자산
  final num? nonCurrentAssetsBS; // 비유동자산
  final num? totalAssetsBS; // 자산총계
  final num? currentLiabilitiesBS; // 유동부채
  final num? nonCurrentLiabilitiesBS; // 비유동부채
  final num? totalLiabilitiesBS; // 부채총계
  final num? shareholdersEquityBS; // 자본금
  final num? retainedEarningsBS; // 이익잉여금
  final num? totalShareholdersEquityBS; // 자본총계
  // IS
  final num? salesIS; // 매출액
  final num? operatingIncomeIS; // 영업이익
  final num? incomeBeforeTaxesIS; // 법인세차감전 순이익
  final num? netIncomeIS; // 당기순이익
  final num? salesAccIS; // 누적 매출액
  final num? operatingIncomeAccIS; // 누적 영업이익
  final num? incomeBeforeTaxesAccIS; // 누적 법인세차감전 순이익
  final num? netIncomeAccIS; // 누적 당기순이익

  final bool? isOfficial; // 확정
  StatsModel({
    this.year,
    this.term,
    this.dateTime,
    this.currentAssetsBS,
    this.nonCurrentAssetsBS,
    this.totalAssetsBS,
    this.currentLiabilitiesBS,
    this.nonCurrentLiabilitiesBS,
    this.totalLiabilitiesBS,
    this.shareholdersEquityBS,
    this.retainedEarningsBS,
    this.totalShareholdersEquityBS,
    this.salesIS,
    this.operatingIncomeIS,
    this.incomeBeforeTaxesIS,
    this.netIncomeIS,
    this.salesAccIS,
    this.operatingIncomeAccIS,
    this.incomeBeforeTaxesAccIS,
    this.netIncomeAccIS,
    this.isOfficial,
  });

  StatsModel copyWith({
    String? year,
    String? term,
    String? dateTime,
    num? currentAssetsBS,
    num? nonCurrentAssetsBS,
    num? totalAssetsBS,
    num? currentLiabilitiesBS,
    num? nonCurrentLiabilitiesBS,
    num? totalLiabilitiesBS,
    num? shareholdersEquityBS,
    num? retainedEarningsBS,
    num? totalShareholdersEquityBS,
    num? salesIS,
    num? operatingIncomeIS,
    num? incomeBeforeTaxesIS,
    num? netIncomeIS,
    num? salesAccIS,
    num? operatingIncomeAccIS,
    num? incomeBeforeTaxesAccIS,
    num? netIncomeAccIS,
    bool? isOfficial,
  }) {
    return StatsModel(
      year: year ?? this.year,
      term: term ?? this.term,
      dateTime: dateTime ?? this.dateTime,
      currentAssetsBS: currentAssetsBS ?? this.currentAssetsBS,
      nonCurrentAssetsBS: nonCurrentAssetsBS ?? this.nonCurrentAssetsBS,
      totalAssetsBS: totalAssetsBS ?? this.totalAssetsBS,
      currentLiabilitiesBS: currentLiabilitiesBS ?? this.currentLiabilitiesBS,
      nonCurrentLiabilitiesBS:
          nonCurrentLiabilitiesBS ?? this.nonCurrentLiabilitiesBS,
      totalLiabilitiesBS: totalLiabilitiesBS ?? this.totalLiabilitiesBS,
      shareholdersEquityBS: shareholdersEquityBS ?? this.shareholdersEquityBS,
      retainedEarningsBS: retainedEarningsBS ?? this.retainedEarningsBS,
      totalShareholdersEquityBS:
          totalShareholdersEquityBS ?? this.totalShareholdersEquityBS,
      salesIS: salesIS ?? this.salesIS,
      operatingIncomeIS: operatingIncomeIS ?? this.operatingIncomeIS,
      incomeBeforeTaxesIS: incomeBeforeTaxesIS ?? this.incomeBeforeTaxesIS,
      netIncomeIS: netIncomeIS ?? this.netIncomeIS,
      salesAccIS: salesAccIS ?? this.salesAccIS,
      operatingIncomeAccIS: operatingIncomeAccIS ?? this.operatingIncomeAccIS,
      incomeBeforeTaxesAccIS:
          incomeBeforeTaxesAccIS ?? this.incomeBeforeTaxesAccIS,
      netIncomeAccIS: netIncomeAccIS ?? this.netIncomeAccIS,
      isOfficial: isOfficial ?? this.isOfficial,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'year': year,
      'term': term,
      'dateTime': dateTime,
      'currentAssetsBS': currentAssetsBS,
      'nonCurrentAssetsBS': nonCurrentAssetsBS,
      'totalAssetsBS': totalAssetsBS,
      'currentLiabilitiesBS': currentLiabilitiesBS,
      'nonCurrentLiabilitiesBS': nonCurrentLiabilitiesBS,
      'totalLiabilitiesBS': totalLiabilitiesBS,
      'shareholdersEquityBS': shareholdersEquityBS,
      'retainedEarningsBS': retainedEarningsBS,
      'totalShareholdersEquityBS': totalShareholdersEquityBS,
      'salesIS': salesIS,
      'operatingIncomeIS': operatingIncomeIS,
      'incomeBeforeTaxesIS': incomeBeforeTaxesIS,
      'netIncomeIS': netIncomeIS,
      'salesAccIS': salesAccIS,
      'operatingIncomeAccIS': operatingIncomeAccIS,
      'incomeBeforeTaxesAccIS': incomeBeforeTaxesAccIS,
      'netIncomeAccIS': netIncomeAccIS,
      'isOfficial': isOfficial,
    };
  }

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    return StatsModel(
      year: map['year'],
      term: map['term'],
      dateTime: map['dateTime'],
      currentAssetsBS: map['currentAssetsBS'],
      nonCurrentAssetsBS: map['nonCurrentAssetsBS'],
      totalAssetsBS: map['totalAssetsBS'],
      currentLiabilitiesBS: map['currentLiabilitiesBS'],
      nonCurrentLiabilitiesBS: map['nonCurrentLiabilitiesBS'],
      totalLiabilitiesBS: map['totalLiabilitiesBS'],
      shareholdersEquityBS: map['shareholdersEquityBS'],
      retainedEarningsBS: map['retainedEarningsBS'],
      totalShareholdersEquityBS: map['totalShareholdersEquityBS'],
      salesIS: map['salesIS'],
      operatingIncomeIS: map['operatingIncomeIS'],
      incomeBeforeTaxesIS: map['incomeBeforeTaxesIS'],
      netIncomeIS: map['netIncomeIS'],
      salesAccIS: map['salesAccIS'],
      operatingIncomeAccIS: map['operatingIncomeAccIS'],
      incomeBeforeTaxesAccIS: map['incomeBeforeTaxesAccIS'],
      netIncomeAccIS: map['netIncomeAccIS'],
      isOfficial: map['isOfficial'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StatsModel.fromJson(String source) =>
      StatsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StatsModel(year: $year, term: $term, dateTime: $dateTime, currentAssetsBS: $currentAssetsBS, nonCurrentAssetsBS: $nonCurrentAssetsBS, totalAssetsBS: $totalAssetsBS, currentLiabilitiesBS: $currentLiabilitiesBS, nonCurrentLiabilitiesBS: $nonCurrentLiabilitiesBS, totalLiabilitiesBS: $totalLiabilitiesBS, shareholdersEquityBS: $shareholdersEquityBS, retainedEarningsBS: $retainedEarningsBS, totalShareholdersEquityBS: $totalShareholdersEquityBS, salesIS: $salesIS, operatingIncomeIS: $operatingIncomeIS, incomeBeforeTaxesIS: $incomeBeforeTaxesIS, netIncomeIS: $netIncomeIS, salesAccIS: $salesAccIS, operatingIncomeAccIS: $operatingIncomeAccIS, incomeBeforeTaxesAccIS: $incomeBeforeTaxesAccIS, netIncomeAccIS: $netIncomeAccIS, isOfficial: $isOfficial)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StatsModel &&
        other.year == year &&
        other.term == term &&
        other.dateTime == dateTime &&
        other.currentAssetsBS == currentAssetsBS &&
        other.nonCurrentAssetsBS == nonCurrentAssetsBS &&
        other.totalAssetsBS == totalAssetsBS &&
        other.currentLiabilitiesBS == currentLiabilitiesBS &&
        other.nonCurrentLiabilitiesBS == nonCurrentLiabilitiesBS &&
        other.totalLiabilitiesBS == totalLiabilitiesBS &&
        other.shareholdersEquityBS == shareholdersEquityBS &&
        other.retainedEarningsBS == retainedEarningsBS &&
        other.totalShareholdersEquityBS == totalShareholdersEquityBS &&
        other.salesIS == salesIS &&
        other.operatingIncomeIS == operatingIncomeIS &&
        other.incomeBeforeTaxesIS == incomeBeforeTaxesIS &&
        other.netIncomeIS == netIncomeIS &&
        other.salesAccIS == salesAccIS &&
        other.operatingIncomeAccIS == operatingIncomeAccIS &&
        other.incomeBeforeTaxesAccIS == incomeBeforeTaxesAccIS &&
        other.netIncomeAccIS == netIncomeAccIS &&
        other.isOfficial == isOfficial;
  }

  @override
  int get hashCode {
    return year.hashCode ^
        term.hashCode ^
        dateTime.hashCode ^
        currentAssetsBS.hashCode ^
        nonCurrentAssetsBS.hashCode ^
        totalAssetsBS.hashCode ^
        currentLiabilitiesBS.hashCode ^
        nonCurrentLiabilitiesBS.hashCode ^
        totalLiabilitiesBS.hashCode ^
        shareholdersEquityBS.hashCode ^
        retainedEarningsBS.hashCode ^
        totalShareholdersEquityBS.hashCode ^
        salesIS.hashCode ^
        operatingIncomeIS.hashCode ^
        incomeBeforeTaxesIS.hashCode ^
        netIncomeIS.hashCode ^
        salesAccIS.hashCode ^
        operatingIncomeAccIS.hashCode ^
        incomeBeforeTaxesAccIS.hashCode ^
        netIncomeAccIS.hashCode ^
        isOfficial.hashCode;
  }
}
