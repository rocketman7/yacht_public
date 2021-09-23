import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class UserQuestModel {
  final String? leagueId; // league001
  final String? questId; //quest001
  final dynamic selectDateTime;
  final List<int>? selection;
  final bool? hasSucceeded;
  final num? yachtPointRewarded;
  final num? leaguePointRewarded;
  final num? expRewarded;
  UserQuestModel({
    this.leagueId,
    this.questId,
    required this.selectDateTime,
    this.selection,
    this.hasSucceeded,
    this.yachtPointRewarded,
    this.leaguePointRewarded,
    this.expRewarded,
  });

  UserQuestModel copyWith({
    String? leagueId,
    String? questId,
    dynamic? selectDateTime,
    List<int>? selection,
    bool? hasSucceeded,
    num? yachtPointRewarded,
    num? leaguePointRewarded,
    num? expRewarded,
  }) {
    return UserQuestModel(
      leagueId: leagueId ?? this.leagueId,
      questId: questId ?? this.questId,
      selectDateTime: selectDateTime ?? this.selectDateTime,
      selection: selection ?? this.selection,
      hasSucceeded: hasSucceeded ?? this.hasSucceeded,
      yachtPointRewarded: yachtPointRewarded ?? this.yachtPointRewarded,
      leaguePointRewarded: leaguePointRewarded ?? this.leaguePointRewarded,
      expRewarded: expRewarded ?? this.expRewarded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leagueId': leagueId,
      'questId': questId,
      'selectDateTime': selectDateTime,
      'selection': selection,
      'hasSucceeded': hasSucceeded,
      'yachtPointRewarded': yachtPointRewarded,
      'leaguePointRewarded': leaguePointRewarded,
      'expRewarded': expRewarded,
    };
  }

  factory UserQuestModel.fromMap(String questId, Map<String, dynamic> map) {
    return UserQuestModel(
      leagueId: map['leagueId'],
      questId: questId,
      selectDateTime: map['selectDateTime'],
      selection: List<int>.from(map['selection']),
      hasSucceeded: map['hasSucceeded'],
      yachtPointRewarded: map['yachtPointRewarded'],
      leaguePointRewarded: map['leaguePointRewarded'],
      expRewarded: map['expRewarded'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory UserQuestModel.fromJson(String source) => UserQuestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserQuestModel(leagueId: $leagueId, questId: $questId, selectDateTime: $selectDateTime, selection: $selection, hasSucceeded: $hasSucceeded, yachtPointRewarded: $yachtPointRewarded, leaguePointRewarded: $leaguePointRewarded, expRewarded: $expRewarded)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserQuestModel &&
        other.leagueId == leagueId &&
        other.questId == questId &&
        other.selectDateTime == selectDateTime &&
        listEquals(other.selection, selection) &&
        other.hasSucceeded == hasSucceeded &&
        other.yachtPointRewarded == yachtPointRewarded &&
        other.leaguePointRewarded == leaguePointRewarded &&
        other.expRewarded == expRewarded;
  }

  @override
  int get hashCode {
    return leagueId.hashCode ^
        questId.hashCode ^
        selectDateTime.hashCode ^
        selection.hashCode ^
        hasSucceeded.hashCode ^
        yachtPointRewarded.hashCode ^
        leaguePointRewarded.hashCode ^
        expRewarded.hashCode;
  }
}
