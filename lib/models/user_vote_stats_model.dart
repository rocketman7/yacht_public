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

  UserVoteStatsModel.fromData(
    Map<String, dynamic> data,
  )   : firstVote = data['firstVote'],
        currentWinningPoint = data['currentWinningPoint'],
        // List<int>를 json으로 가져오면 List<dynamic>으로 인식하여 int로 다시 cast해줌
        maxWinningPoint = data['maxWinningPoint'],
        participation = data['participation'] == null
            ? null
            : List<bool>.from(data['participation']);

  Map<String, dynamic> toJson() {
    return {
      'firstVote': this.firstVote,
      'currentWinningPoint': this.currentWinningPoint,
      'maxWinningPoint': this.maxWinningPoint,
      'participation': this.participation,
    };
  }
}
