import 'dart:convert';

import 'package:flutter/foundation.dart';

// enum Category { ONE, TWO, THREE }

class QuestModel {
  final String title;
  final String country;
  final String category;
  final num pointReward;
  final num cashReward;
  final num exp;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final DateTime resultDateTime;
  final List<int>? count;
  final List<int>? result;
  final List<Map<String, String>> candidates;
  QuestModel({
    required this.title,
    required this.country,
    required this.category,
    required this.pointReward,
    required this.cashReward,
    required this.exp,
    required this.startDateTime,
    required this.endDateTime,
    required this.resultDateTime,
    this.count,
    this.result,
    required this.candidates,
  });

  QuestModel copyWith({
    String? title,
    String? country,
    String? category,
    num? pointReward,
    num? cashReward,
    num? exp,
    DateTime? startDateTime,
    DateTime? endDateTime,
    DateTime? resultDateTime,
    List<int>? count,
    List<int>? result,
    List<Map<String, String>>? candidates,
  }) {
    return QuestModel(
      title: title ?? this.title,
      country: country ?? this.country,
      category: category ?? this.category,
      pointReward: pointReward ?? this.pointReward,
      cashReward: cashReward ?? this.cashReward,
      exp: exp ?? this.exp,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      resultDateTime: resultDateTime ?? this.resultDateTime,
      count: count ?? this.count,
      result: result ?? this.result,
      candidates: candidates ?? this.candidates,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'country': country,
      'category': category,
      'pointReward': pointReward,
      'cashReward': cashReward,
      'exp': exp,
      'startDateTime': startDateTime.millisecondsSinceEpoch,
      'endDateTime': endDateTime.millisecondsSinceEpoch,
      'resultDateTime': resultDateTime.millisecondsSinceEpoch,
      'count': count,
      'result': result,
      'candidates': candidates,
    };
  }

  factory QuestModel.fromMap(Map<String, dynamic> map) {
    return QuestModel(
      title: map['title'],
      country: map['country'],
      category: map['category'],
      pointReward: map['pointReward'],
      cashReward: map['cashReward'],
      exp: map['exp'],
      startDateTime: DateTime.fromMillisecondsSinceEpoch(map['startDateTime']),
      endDateTime: DateTime.fromMillisecondsSinceEpoch(map['endDateTime']),
      resultDateTime:
          DateTime.fromMillisecondsSinceEpoch(map['resultDateTime']),
      count: List<int>.from(map['count']),
      result: List<int>.from(map['result']),
      candidates:
          List<Map<String, String>>.from(map['candidates']?.map((x) => x)),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestModel.fromJson(String source) =>
      QuestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'QuestModel(title: $title, country: $country, category: $category, pointReward: $pointReward, cashReward: $cashReward, exp: $exp, startDateTime: $startDateTime, endDateTime: $endDateTime, resultDateTime: $resultDateTime, count: $count, result: $result, candidates: $candidates)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestModel &&
        other.title == title &&
        other.country == country &&
        other.category == category &&
        other.pointReward == pointReward &&
        other.cashReward == cashReward &&
        other.exp == exp &&
        other.startDateTime == startDateTime &&
        other.endDateTime == endDateTime &&
        other.resultDateTime == resultDateTime &&
        listEquals(other.count, count) &&
        listEquals(other.result, result) &&
        listEquals(other.candidates, candidates);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        country.hashCode ^
        category.hashCode ^
        pointReward.hashCode ^
        cashReward.hashCode ^
        exp.hashCode ^
        startDateTime.hashCode ^
        endDateTime.hashCode ^
        resultDateTime.hashCode ^
        count.hashCode ^
        result.hashCode ^
        candidates.hashCode;
  }
}
