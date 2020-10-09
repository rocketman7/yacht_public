import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserVoteStatsModel {
  final String firstVote;
  final int currentWinPoint;
  final int maxWinPoint;
  final List<bool> participation;

  UserVoteStatsModel({
    this.firstVote,
    this.currentWinPoint,
    this.maxWinPoint,
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
      currentWinPoint: currentWinningPoint ?? this.currentWinPoint,
      maxWinPoint: maxWinningPoint ?? this.maxWinPoint,
      participation: participation ?? this.participation,
    );
  }

  UserVoteStatsModel.fromData(
    Map<String, dynamic> data,
  )   : firstVote = data['firstVote'],
        currentWinPoint = data['currentWinningPoint'],
        // List<int>를 json으로 가져오면 List<dynamic>으로 인식하여 int로 다시 cast해줌
        maxWinPoint = data['maxWinningPoint'],
        participation = data['participation'] == null
            ? null
            : List<bool>.from(data['participation']);

  Map<String, dynamic> toJson() {
    return {
      'firstVote': this.firstVote,
      'currentWinningPoint': this.currentWinPoint,
      'maxWinningPoint': this.maxWinPoint,
      'participation': this.participation,
    };
  }
}
