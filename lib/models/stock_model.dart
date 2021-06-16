import 'dart:convert';

import 'package:yachtOne/models/stats_model.dart';

class StockModel {
  // 종목 기본 정보
  final String country;
  final String issueCode;
  final String name;
  final String logoUrl;

  // 기업 기본 정보
  final String ceo;
  final int employees;
  final int avrSalary;

  final StatsModel stats;
  StockModel({
    required this.country,
    required this.issueCode,
    required this.name,
    required this.logoUrl,
    required this.ceo,
    required this.employees,
    required this.avrSalary,
    required this.stats,
  });

  StockModel copyWith({
    String? country,
    String? issueCode,
    String? name,
    String? logoUrl,
    String? ceo,
    int? employees,
    int? avrSalary,
    StatsModel? stats,
  }) {
    return StockModel(
      country: country ?? this.country,
      issueCode: issueCode ?? this.issueCode,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      ceo: ceo ?? this.ceo,
      employees: employees ?? this.employees,
      avrSalary: avrSalary ?? this.avrSalary,
      stats: stats ?? this.stats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'issueCode': issueCode,
      'name': name,
      'logoUrl': logoUrl,
      'ceo': ceo,
      'employees': employees,
      'avrSalary': avrSalary,
      'stats': stats.toMap(),
    };
  }

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      country: map['country'],
      issueCode: map['issueCode'],
      name: map['name'],
      logoUrl: map['logoUrl'],
      ceo: map['ceo'],
      employees: map['employees'],
      avrSalary: map['avrSalary'],
      stats: StatsModel.fromMap(map['stats']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StockModel.fromJson(String source) =>
      StockModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StockModel(country: $country, issueCode: $issueCode, name: $name, logoUrl: $logoUrl, ceo: $ceo, employees: $employees, avrSalary: $avrSalary, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockModel &&
        other.country == country &&
        other.issueCode == issueCode &&
        other.name == name &&
        other.logoUrl == logoUrl &&
        other.ceo == ceo &&
        other.employees == employees &&
        other.avrSalary == avrSalary &&
        other.stats == stats;
  }

  @override
  int get hashCode {
    return country.hashCode ^
        issueCode.hashCode ^
        name.hashCode ^
        logoUrl.hashCode ^
        ceo.hashCode ^
        employees.hashCode ^
        avrSalary.hashCode ^
        stats.hashCode;
  }
}
