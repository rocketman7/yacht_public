import 'dart:convert';

import 'package:yachtOne/models/stats_model.dart';

class StockModel {
  // 종목 기본 정보
  final String name;
  final String country;
  final String issueCode;

  // 기업 기본 정보
  final String ceo;
  final int employees;
  final int avrSalary;

  final StatsModel stats;
  StockModel({
    required this.name,
    required this.country,
    required this.issueCode,
    required this.ceo,
    required this.employees,
    required this.avrSalary,
    required this.stats,
  });

  StockModel copyWith({
    String? name,
    String? country,
    String? issueCode,
    String? ceo,
    int? employees,
    int? avrSalary,
    StatsModel? stats,
  }) {
    return StockModel(
      name: name ?? this.name,
      country: country ?? this.country,
      issueCode: issueCode ?? this.issueCode,
      ceo: ceo ?? this.ceo,
      employees: employees ?? this.employees,
      avrSalary: avrSalary ?? this.avrSalary,
      stats: stats ?? this.stats,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'country': country,
      'issueCode': issueCode,
      'ceo': ceo,
      'employees': employees,
      'avrSalary': avrSalary,
      'stats': stats.toMap(),
    };
  }

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      name: map['name'],
      country: map['country'],
      issueCode: map['issueCode'],
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
    return 'StockModel(name: $name, country: $country, issueCode: $issueCode, ceo: $ceo, employees: $employees, avrSalary: $avrSalary, stats: $stats)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockModel &&
        other.name == name &&
        other.country == country &&
        other.issueCode == issueCode &&
        other.ceo == ceo &&
        other.employees == employees &&
        other.avrSalary == avrSalary &&
        other.stats == stats;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        country.hashCode ^
        issueCode.hashCode ^
        ceo.hashCode ^
        employees.hashCode ^
        avrSalary.hashCode ^
        stats.hashCode;
  }
}
