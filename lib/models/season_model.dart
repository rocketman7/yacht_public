import 'dart:convert';

class SeasonModel {
  final String seasonId;
  final String seasonName;
  final String startDate;
  final int maxDailyVote;
  final int correctPoint;
  final int wrongPoint;
  final int initialAwardValue;
  final int winningPoint;
  final String endDate;

  SeasonModel(
      this.seasonId,
      this.seasonName,
      this.startDate,
      this.maxDailyVote,
      this.correctPoint,
      this.wrongPoint,
      this.initialAwardValue,
      this.winningPoint,
      this.endDate);

  Map<String, dynamic> toJson() {
    return {
      'seasonId': seasonId,
      'seasonName': seasonName,
      'startDate': startDate,
      'maxDailyVote': maxDailyVote,
      'correctPoint': correctPoint,
      'wrongPoint': wrongPoint,
      'initialAwardValue': initialAwardValue,
      'winningPoint': winningPoint,
      'endDate': endDate,
    };
  }

  SeasonModel.fromData(Map<String, dynamic> map, String seasonId)
      : seasonId = seasonId ?? null,
        seasonName = map['seasonName'] ?? null,
        startDate = map['startDate'] ?? null,
        maxDailyVote = map['maxDailyVote'] ?? null,
        correctPoint = map['correctPoint'] ?? null,
        wrongPoint = map['wrongPoint'] ?? null,
        initialAwardValue = map['initialAwardValue'] ?? null,
        winningPoint = map['winningPoint'] ?? null,
        endDate = map['endDate'] ?? null;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SeasonModel &&
        o.seasonId == seasonId &&
        o.seasonName == seasonName &&
        o.startDate == startDate &&
        o.maxDailyVote == maxDailyVote &&
        o.correctPoint == correctPoint &&
        o.wrongPoint == wrongPoint &&
        o.initialAwardValue == initialAwardValue &&
        o.winningPoint == winningPoint &&
        o.endDate == endDate;
  }

  @override
  int get hashCode {
    return seasonId.hashCode ^
        seasonName.hashCode ^
        startDate.hashCode ^
        maxDailyVote.hashCode ^
        correctPoint.hashCode ^
        wrongPoint.hashCode ^
        initialAwardValue.hashCode ^
        winningPoint.hashCode ^
        endDate.hashCode;
  }
}
