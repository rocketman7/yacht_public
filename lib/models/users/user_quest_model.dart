import 'dart:convert';

import 'package:collection/collection.dart';

class UserQuestModel {
  final String? questId; //quest001
  final dynamic selectDateTime;
  final List<num>? selection;

  UserQuestModel({
    required this.questId,
    required this.selectDateTime,
    required this.selection,
  });

  UserQuestModel copyWith({
    String? questName,
    dynamic selectDateTime,
    List<num>? selection,
  }) {
    return UserQuestModel(
      questId: questName ?? this.questId,
      selectDateTime: selectDateTime ?? this.selectDateTime,
      selection: selection ?? this.selection,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questName': questId,
      'selectDateTime': selectDateTime,
      'selection': selection,
    };
  }

  factory UserQuestModel.fromMap(String questId, Map<String, dynamic> map) {
    return UserQuestModel(
      questId: questId,
      selectDateTime: map['selectDateTime'],
      selection:
          map['selection'] == null ? null : List<num>.from(map['selection']),
    );
  }

  String toJson() => json.encode(toMap());

  // factory UserQuestModel.fromJson(String source) =>
  //     UserQuestModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserQuestModel(questName: $questId, selectDateTime: $selectDateTime, selection: $selection)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is UserQuestModel &&
        other.questId == questId &&
        other.selectDateTime == selectDateTime &&
        listEquals(other.selection, selection);
  }

  @override
  int get hashCode =>
      questId.hashCode ^ selectDateTime.hashCode ^ selection.hashCode;
}
