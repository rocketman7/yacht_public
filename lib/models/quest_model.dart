import 'dart:convert';

import 'package:flutter/foundation.dart';

// enum Category { ONE, TWO, THREE }

class QuestModel {
  final String title;
  final String subtitle;

  final String category; // daily, weekly
  final num pointReward;
  final num cashReward;
  final num exp;
  final dynamic startDateTime;
  final dynamic endDateTime;
  final dynamic resultDateTime;
// 상승, 하락 등 명시되어있으면 그걸 쓰고 null이면 OptionModel의 name을 쓰도록.
  final List<String>? choices;
  final List<int>? counts;
  final List<int>? results;
  List<StockAddressModel> stockAddress;
  QuestModel({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.pointReward,
    required this.cashReward,
    required this.exp,
    required this.startDateTime,
    required this.endDateTime,
    required this.resultDateTime,
    this.choices,
    this.counts,
    this.results,
    required this.stockAddress,
  });

  QuestModel copyWith({
    String? title,
    String? subtitle,
    String? country,
    String? category,
    num? pointReward,
    num? cashReward,
    num? exp,
    dynamic? startDateTime,
    dynamic? endDateTime,
    dynamic? resultDateTime,
    List<String>? choices,
    List<int>? counts,
    List<int>? results,
    List<StockAddressModel>? options,
  }) {
    return QuestModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      category: category ?? this.category,
      pointReward: pointReward ?? this.pointReward,
      cashReward: cashReward ?? this.cashReward,
      exp: exp ?? this.exp,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      resultDateTime: resultDateTime ?? this.resultDateTime,
      choices: choices ?? this.choices,
      counts: counts ?? this.counts,
      results: results ?? this.results,
      stockAddress: options ?? this.stockAddress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'pointReward': pointReward,
      'cashReward': cashReward,
      'exp': exp,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'resultDateTime': resultDateTime,
      'choices': choices,
      'counts': counts,
      'results': results,
      'options': stockAddress,
    };
  }

  factory QuestModel.fromMap(
      Map<String, dynamic> map, List<StockAddressModel> options) {
    return QuestModel(
        title: map['title'],
        subtitle: map['subtitle'],
        category: map['category'],
        pointReward: map['pointReward'],
        cashReward: map['cashReward'],
        exp: map['exp'],
        startDateTime: map['startDateTime'],
        endDateTime: map['endDateTime'],
        resultDateTime: map['resultDateTime'],
        choices:
            map['choices'] == null ? null : List<String>.from(map['choices']),
        counts: List<int>.from(map['counts']),
        results: map['results'] == null ? null : List<int>.from(map['results']),
        stockAddress: options);
  }

  String toJson() => json.encode(toMap());

  // factory QuestModel.fromJson(String source, OptionModel options) =>
  //     QuestModel.fromMap(json.decode(source), json.decode(options));

  @override
  String toString() {
    return 'QuestModel(title: $title, subtitle: $subtitle,  category: $category, pointReward: $pointReward, cashReward: $cashReward, exp: $exp, startDateTime: $startDateTime, endDateTime: $endDateTime, resultDateTime: $resultDateTime, choices: $choices, counts: $counts, results: $results, options: $stockAddress)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestModel &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.category == category &&
        other.pointReward == pointReward &&
        other.cashReward == cashReward &&
        other.exp == exp &&
        other.startDateTime == startDateTime &&
        other.endDateTime == endDateTime &&
        other.resultDateTime == resultDateTime &&
        listEquals(other.choices, choices) &&
        listEquals(other.counts, counts) &&
        listEquals(other.results, results) &&
        other.stockAddress == stockAddress;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subtitle.hashCode ^
        category.hashCode ^
        pointReward.hashCode ^
        cashReward.hashCode ^
        exp.hashCode ^
        startDateTime.hashCode ^
        endDateTime.hashCode ^
        resultDateTime.hashCode ^
        choices.hashCode ^
        counts.hashCode ^
        results.hashCode ^
        stockAddress.hashCode;
  }
}

class StockAddressModel {
  final String country;
  final String field; //stocks
  final String market; // kospi, kosdaq,
  final String issueCode; // '005930'
  final String name; // 삼성전자, 바이오팜 or 상승, 하락
  final String logoUrl;
  StockAddressModel({
    required this.country,
    required this.field,
    required this.market,
    required this.issueCode,
    required this.name,
    required this.logoUrl,
  });

  StockAddressModel copyWith({
    String? country,
    String? field,
    String? market,
    String? issueCode,
    String? name,
    String? logoUrl,
  }) {
    return StockAddressModel(
      country: country ?? this.country,
      field: field ?? this.field,
      market: market ?? this.market,
      issueCode: issueCode ?? this.issueCode,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'field': field,
      'market': market,
      'issueCode': issueCode,
      'name': name,
      'logoUrl': logoUrl,
    };
  }

  factory StockAddressModel.fromMap(Map<String, dynamic> map) {
    return StockAddressModel(
      country: map['country'],
      field: map['field'],
      market: map['market'],
      issueCode: map['issueCode'],
      name: map['name'],
      logoUrl: map['logoUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StockAddressModel.fromJson(String source) =>
      StockAddressModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OptionModel(country: $country, field: $field, market: $market, issueCode: $issueCode, name: $name, logoUrl: $logoUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockAddressModel &&
        other.country == country &&
        other.field == field &&
        other.market == market &&
        other.issueCode == issueCode &&
        other.name == name &&
        other.logoUrl == logoUrl;
  }

  @override
  int get hashCode {
    return country.hashCode ^
        field.hashCode ^
        market.hashCode ^
        issueCode.hashCode ^
        name.hashCode ^
        logoUrl.hashCode;
  }
}
