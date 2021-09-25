import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class UserQuestModel {
  final String? leagueId; // league001
  final String? questId; //quest001
  final dynamic selectDateTime;
  final List<int>? selection;
  final bool? hasSucceeded;
  final int? yachtPointSuccessRewarded;
  final int? leaguePointSuccessRewarded;
  final int? expSuccessRewarded;
  final int? yachtPointParticipationRewarded;
  final int? leaguePointParticipationRewarded;
  final int? expParticipationRewarded;
  UserQuestModel({
    this.leagueId,
    this.questId,
    required this.selectDateTime,
    this.selection,
    this.hasSucceeded,
    this.yachtPointSuccessRewarded,
    this.leaguePointSuccessRewarded,
    this.expSuccessRewarded,
    this.yachtPointParticipationRewarded,
    this.leaguePointParticipationRewarded,
    this.expParticipationRewarded,
  });

  UserQuestModel copyWith({
    String? leagueId,
    String? questId,
    dynamic? selectDateTime,
    List<int>? selection,
    bool? hasSucceeded,
    int? yachtPointSuccessRewarded,
    int? leaguePointSuccessRewarded,
    int? expSuccessRewarded,
    int? yachtPointParticipationRewarded,
    int? leaguePointParticipationRewarded,
    int? expParticipationRewarded,
  }) {
    return UserQuestModel(
      leagueId: leagueId ?? this.leagueId,
      questId: questId ?? this.questId,
      selectDateTime: selectDateTime ?? this.selectDateTime,
      selection: selection ?? this.selection,
      hasSucceeded: hasSucceeded ?? this.hasSucceeded,
      yachtPointSuccessRewarded: yachtPointSuccessRewarded ?? this.yachtPointSuccessRewarded,
      leaguePointSuccessRewarded: leaguePointSuccessRewarded ?? this.leaguePointSuccessRewarded,
      expSuccessRewarded: expSuccessRewarded ?? this.expSuccessRewarded,
      yachtPointParticipationRewarded: yachtPointParticipationRewarded ?? this.yachtPointParticipationRewarded,
      leaguePointParticipationRewarded: leaguePointParticipationRewarded ?? this.leaguePointParticipationRewarded,
      expParticipationRewarded: expParticipationRewarded ?? this.expParticipationRewarded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leagueId': leagueId,
      'questId': questId,
      'selectDateTime': selectDateTime,
      'selection': selection,
      'hasSucceeded': hasSucceeded,
      'yachtPointSuccessRewarded': yachtPointSuccessRewarded,
      'leaguePointSuccessRewarded': leaguePointSuccessRewarded,
      'expSuccessRewarded': expSuccessRewarded,
      'yachtPointParticipationRewarded': yachtPointParticipationRewarded,
      'leaguePointParticipationRewarded': leaguePointParticipationRewarded,
      'expParticipationRewarded': expParticipationRewarded,
    };
  }

  factory UserQuestModel.fromMap(String questId, Map<String, dynamic> map) {
    return UserQuestModel(
      leagueId: map['leagueId'],
      questId: questId,
      selectDateTime: map['selectDateTime'],
      selection: List<int>.from(map['selection']),
      hasSucceeded: map['hasSucceeded'],
      yachtPointSuccessRewarded: map['yachtPointSuccessRewarded'],
      leaguePointSuccessRewarded: map['leaguePointSuccessRewarded'],
      expSuccessRewarded: map['expSuccessRewarded'],
      yachtPointParticipationRewarded: map['yachtPointParticipationRewarded'],
      leaguePointParticipationRewarded: map['leaguePointParticipationRewarded'],
      expParticipationRewarded: map['expParticipationRewarded'],
    );
  }

  String toJson() => json.encode(toMap());

  // factory UserQuestModel.fromJson(String source) => UserQuestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserQuestModel(leagueId: $leagueId, questId: $questId, selectDateTime: $selectDateTime, selection: $selection, hasSucceeded: $hasSucceeded, yachtPointSuccessRewarded: $yachtPointSuccessRewarded, leaguePointSuccessRewarded: $leaguePointSuccessRewarded, expSuccessRewarded: $expSuccessRewarded, yachtPointParticipationRewarded: $yachtPointParticipationRewarded, leaguePointParticipationRewarded: $leaguePointParticipationRewarded, expParticipationRewarded: $expParticipationRewarded)';
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
        other.yachtPointSuccessRewarded == yachtPointSuccessRewarded &&
        other.leaguePointSuccessRewarded == leaguePointSuccessRewarded &&
        other.expSuccessRewarded == expSuccessRewarded &&
        other.yachtPointParticipationRewarded == yachtPointParticipationRewarded &&
        other.leaguePointParticipationRewarded == leaguePointParticipationRewarded &&
        other.expParticipationRewarded == expParticipationRewarded;
  }

  @override
  int get hashCode {
    return leagueId.hashCode ^
        questId.hashCode ^
        selectDateTime.hashCode ^
        selection.hashCode ^
        hasSucceeded.hashCode ^
        yachtPointSuccessRewarded.hashCode ^
        leaguePointSuccessRewarded.hashCode ^
        expSuccessRewarded.hashCode ^
        yachtPointParticipationRewarded.hashCode ^
        leaguePointParticipationRewarded.hashCode ^
        expParticipationRewarded.hashCode;
  }
}
