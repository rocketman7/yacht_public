import 'dart:convert';

import 'package:flutter/foundation.dart';

// enum Category { ONE, TWO, THREE }

class QuestModel {
  final String title;
  final String subtitle;
  final String country;
  final String category;
  final num pointReward;
  final num cashReward;
  final num exp;
  final dynamic startDateTime;
  final dynamic endDateTime;
  final dynamic resultDateTime;
  final List<String>? choices;
  final List<String>? logoUrl;
  final List<int>? counts;
  final List<int>? results;
  final List<Map<String, dynamic>> candidates;
  QuestModel({
    required this.title,
    required this.subtitle,
    required this.country,
    required this.category,
    required this.pointReward,
    required this.cashReward,
    required this.exp,
    required this.startDateTime,
    required this.endDateTime,
    required this.resultDateTime,
    this.choices,
    this.logoUrl,
    this.counts,
    this.results,
    required this.candidates,
  });

  QuestModel copyWith({
    String? title,
    String? subtitle,
    String? country,
    String? category,
    num? pointReward,
    num? cashReward,
    num? exp,
    dynamic startDateTime,
    dynamic endDateTime,
    dynamic resultDateTime,
    List<String>? choices,
    List<String>? logoUrl,
    List<int>? counts,
    List<int>? results,
    List<Map<String, dynamic>>? candidates,
  }) {
    return QuestModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      country: country ?? this.country,
      category: category ?? this.category,
      pointReward: pointReward ?? this.pointReward,
      cashReward: cashReward ?? this.cashReward,
      exp: exp ?? this.exp,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      resultDateTime: resultDateTime ?? this.resultDateTime,
      choices: choices ?? this.choices,
      logoUrl: logoUrl ?? this.logoUrl,
      counts: counts ?? this.counts,
      results: results ?? this.results,
      candidates: candidates ?? this.candidates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'country': country,
      'category': category,
      'pointReward': pointReward,
      'cashReward': cashReward,
      'exp': exp,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'resultDateTime': resultDateTime,
      'choices': choices,
      'logoUrl': logoUrl,
      'counts': counts,
      'results': results,
      'candidates': candidates,
    };
  }

  factory QuestModel.fromMap(Map<String, dynamic> map) {
    return QuestModel(
      title: map['title'],
      subtitle: map['subtitle'],
      country: map['country'],
      category: map['category'],
      pointReward: map['pointReward'],
      cashReward: map['cashReward'],
      exp: map['exp'],
      startDateTime: map['startDateTime'],
      endDateTime: map['endDateTime'],
      resultDateTime: map['resultDateTime'],
      choices: List<String>.from(map['choices']),
      logoUrl: List<String>.from(map['logoUrl']),
      counts: List<int>.from(map['counts']),
      results: List<int>.from(map['results']),
      candidates:
          List<Map<String, dynamic>>.from(map['candidates']?.map((x) => x)),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestModel.fromJson(String source) =>
      QuestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuestModel(title: $title, subtitle: $subtitle, country: $country, category: $category, pointReward: $pointReward, cashReward: $cashReward, exp: $exp, startDateTime: $startDateTime, endDateTime: $endDateTime, resultDateTime: $resultDateTime, choices: $choices, logoUrl: $logoUrl, counts: $counts, results: $results, candidates: $candidates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestModel &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.country == country &&
        other.category == category &&
        other.pointReward == pointReward &&
        other.cashReward == cashReward &&
        other.exp == exp &&
        other.startDateTime == startDateTime &&
        other.endDateTime == endDateTime &&
        other.resultDateTime == resultDateTime &&
        listEquals(other.choices, choices) &&
        listEquals(other.logoUrl, logoUrl) &&
        listEquals(other.counts, counts) &&
        listEquals(other.results, results) &&
        listEquals(other.candidates, candidates);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subtitle.hashCode ^
        country.hashCode ^
        category.hashCode ^
        pointReward.hashCode ^
        cashReward.hashCode ^
        exp.hashCode ^
        startDateTime.hashCode ^
        endDateTime.hashCode ^
        resultDateTime.hashCode ^
        choices.hashCode ^
        logoUrl.hashCode ^
        counts.hashCode ^
        results.hashCode ^
        candidates.hashCode;
  }
}
