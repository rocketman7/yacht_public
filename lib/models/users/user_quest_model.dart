import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class UserQuestModel {
  final String? leagueId; // league001
  final String? questId; //quest001
  final dynamic selectDateTime;
  final List<int>? selection;
  UserQuestModel({
    required this.leagueId,
    this.questId,
    required this.selectDateTime,
    this.selection,
  });

  UserQuestModel copyWith({
    String? leagueId,
    String? questId,
    dynamic selectDateTime,
    List<int>? selection,
  }) {
    return UserQuestModel(
      leagueId: leagueId ?? this.leagueId,
      questId: questId ?? this.questId,
      selectDateTime: selectDateTime ?? this.selectDateTime,
      selection: selection ?? this.selection,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'leagueId': leagueId,
      'questId': questId,
      'selectDateTime': selectDateTime,
      'selection': selection,
    };
  }

  factory UserQuestModel.fromMap(String id, Map<String, dynamic> map) {
    return UserQuestModel(
      leagueId: map['leagueId'],
      questId: id,
      selectDateTime: map['selectDateTime'],
      selection: map['selection'] == null ? null : List<int>.from(map['selection']),
    );
  }

  String toJson() => json.encode(toMap());

  // factory UserQuestModel.fromJson(String source) => UserQuestModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserQuestModel(leagueId: $leagueId, questId: $questId, selectDateTime: $selectDateTime, selection: $selection)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserQuestModel &&
        other.leagueId == leagueId &&
        other.questId == questId &&
        other.selectDateTime == selectDateTime &&
        listEquals(other.selection, selection);
  }

  @override
  int get hashCode {
    return leagueId.hashCode ^ questId.hashCode ^ selectDateTime.hashCode ^ selection.hashCode;
  }
}
