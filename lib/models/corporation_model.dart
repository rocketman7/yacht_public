import 'dart:convert';

import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/stats_model.dart';

class CorporationModel {
  // final String country;
  // final String field;
  // final String market;
  // final String issueCode;
  // final String name;
  // final String engName;
  // final String logoUrl;
  // final StockAddressModel investAddressModel;
  final String? ceo;
  final num? employees;
  final num? avrSalary;
  final String? description;
  CorporationModel({
    required this.ceo,
    required this.employees,
    required this.avrSalary,
    required this.description,
  });

  // 종목 기본 정보

  // // 기업 기본 정보

  // final StatsModel stats;

  CorporationModel copyWith({
    String? ceo,
    num? employees,
    num? avrSalary,
    String? description,
  }) {
    return CorporationModel(
      ceo: ceo ?? this.ceo,
      employees: employees ?? this.employees,
      avrSalary: avrSalary ?? this.avrSalary,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ceo': ceo,
      'employees': employees,
      'avrSalary': avrSalary,
      'description': description,
    };
  }

  factory CorporationModel.fromMap(Map<String, dynamic> map) {
    return CorporationModel(
      ceo: map['ceo'] ?? null,
      employees: map['employees'] ?? null,
      avrSalary: map['avrSalary'] ?? null,
      description: map['description'] ?? null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CorporationModel.fromJson(String source) => CorporationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CorporationModel(ceo: $ceo, employees: $employees, avrSalary: $avrSalary, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CorporationModel &&
        other.ceo == ceo &&
        other.employees == employees &&
        other.avrSalary == avrSalary &&
        other.description == description;
  }

  @override
  int get hashCode {
    return ceo.hashCode ^ employees.hashCode ^ avrSalary.hashCode ^ description.hashCode;
  }
}
