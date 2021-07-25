import 'dart:convert';

import 'package:collection/collection.dart';

class UserQuestModel {
  final String? questName; //quest001
  final dynamic selectDateTime;
  final List<num>? selection;

  UserQuestModel({
    required this.questName,
    required this.selectDateTime,
    required this.selection,
  });

  UserQuestModel copyWith({
    String? questName,
    dynamic selectDateTime,
    List<num>? selection,
  }) {
    return UserQuestModel(
      questName: questName ?? this.questName,
      selectDateTime: selectDateTime ?? this.selectDateTime,
      selection: selection ?? this.selection,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questName': questName,
      'selectDateTime': selectDateTime,
      'selection': selection,
    };
  }

  factory UserQuestModel.fromMap(Map<String, dynamic> map) {
    return UserQuestModel(
      questName: map['questName'],
      selectDateTime: map['selectDateTime'],
      selection: List<num>.from(map['selection']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserQuestModel.fromJson(String source) =>
      UserQuestModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserQuestModel(questName: $questName, selectDateTime: $selectDateTime, selection: $selection)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is UserQuestModel &&
        other.questName == questName &&
        other.selectDateTime == selectDateTime &&
        listEquals(other.selection, selection);
  }

  @override
  int get hashCode =>
      questName.hashCode ^ selectDateTime.hashCode ^ selection.hashCode;
}
