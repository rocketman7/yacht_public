import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserVoteStatsModel {
  final String? firstVote;
  final int? currentWinPoint;
  final int? maxWinPoint;
  final List<bool>? participation;
  final Map<String, dynamic>? winPointHistory;
  final int? numOfPrediction;
  final int? numOfWin;

  UserVoteStatsModel({
    this.firstVote,
    this.currentWinPoint,
    this.maxWinPoint,
    this.participation,
    this.winPointHistory,
    this.numOfPrediction,
    this.numOfWin,
  });

  UserVoteStatsModel copyWith({
    String? firstVote,
    int? currentWinPoint,
    int? maxWinningPoint,
    List<bool>? participation,
    Map<dynamic, int>? winPointHistory,
    int? numOfPrediction,
    int? numOfWin,
  }) {
    return UserVoteStatsModel(
      firstVote: firstVote ?? this.firstVote,
      currentWinPoint: currentWinPoint ?? this.currentWinPoint,
      maxWinPoint: maxWinningPoint ?? this.maxWinPoint,
      participation: participation ?? this.participation,
      winPointHistory: winPointHistory as Map<String, dynamic>? ?? this.winPointHistory,
      numOfPrediction: numOfPrediction ?? this.numOfPrediction,
    );
  }

  UserVoteStatsModel.fromData(
    Map<String, dynamic> data,
  )   : firstVote = data['firstVote'],
        currentWinPoint = data['currentWinPoint'],
        // List<int>를 json으로 가져오면 List<dynamic>으로 인식하여 int로 다시 cast해줌
        maxWinPoint = data['maxWinningPoint'],
        participation = data['participation'] == null
            ? null
            : List<bool>.from(data['participation']),
        winPointHistory = data['winPointHistory'],
        numOfPrediction = data['numOfPrediction'],
        numOfWin = data['numOfWin'];

  Map<String, dynamic> toJson() {
    return {
      'firstVote': this.firstVote,
      'currentWinPoint': this.currentWinPoint,
      'maxWinningPoint': this.maxWinPoint,
      'participation': this.participation,
      'winPointHistory': this.winPointHistory,
      'numOfPrediction': this.numOfPrediction,
      'numOfWin': this.numOfWin,
    };
  }
}
