import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserVoteStatsModel {
  final String firstVote;
  final int currentWinningPoint;
  final int maxWinningPoint;
  final List<bool> participation;

  UserVoteStatsModel({
    this.firstVote,
    this.currentWinningPoint,
    this.maxWinningPoint,
    this.participation,
  });

  UserVoteStatsModel copyWith({
    String firstVote,
    int currentWinningPoint,
    int maxWinningPoint,
    List<bool> participation,
  }) {
    return UserVoteStatsModel(
      firstVote: firstVote ?? this.firstVote,
      currentWinningPoint: currentWinningPoint ?? this.currentWinningPoint,
      maxWinningPoint: maxWinningPoint ?? this.maxWinningPoint,
      participation: participation ?? this.participation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstVote': firstVote,
      'currentWinningPoint': currentWinningPoint,
      'maxWinningPoint': maxWinningPoint,
      'participation': participation,
    };
  }

  factory UserVoteStatsModel.fromData(Map<String, dynamic> data) {
    if (data == null) return null;

    return UserVoteStatsModel(
      firstVote: data['firstVote'],
      currentWinningPoint: data['currentWinningPoint'],
      maxWinningPoint: data['maxWinningPoint'],
      participation: List<bool>.from(data['participation']),
    );
  }

  @override
  String toString() {
    return 'UserVoteStatsModel(firstVote: $firstVote, currentWinningPoint: $currentWinningPoint, maxWinningPoint: $maxWinningPoint, participation: $participation)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserVoteStatsModel &&
        o.firstVote == firstVote &&
        o.currentWinningPoint == currentWinningPoint &&
        o.maxWinningPoint == maxWinningPoint &&
        listEquals(o.participation, participation);
  }

  @override
  int get hashCode {
    return firstVote.hashCode ^
        currentWinningPoint.hashCode ^
        maxWinningPoint.hashCode ^
        participation.hashCode;
  }
}
