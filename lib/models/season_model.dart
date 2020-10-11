import 'dart:convert';

class SeasonModel {
  final String seasonName;
  final String startDate;
  final int maxDailyVote;
  final int correctPoint;
  final int wrongPoint;
  final int initialAwardValue;
  final int winningPoint;

  SeasonModel(
      this.seasonName,
      this.startDate,
      this.maxDailyVote,
      this.correctPoint,
      this.wrongPoint,
      this.initialAwardValue,
      this.winningPoint);

  Map<String, dynamic> toJson() {
    return {
      'seasonName': seasonName,
      'startDate': startDate,
      'winningPoint': maxDailyVote,
      'correctPoint': correctPoint,
      'wrongPoint': wrongPoint,
      'initialAwardValue': initialAwardValue,
      'winningPoint': winningPoint
    };
  }

  factory SeasonModel.fromData(Map<String, dynamic> map) {
    if (map == null) return null;

    return SeasonModel(
      map['seasonName'],
      map['startDate'],
      map['maxDailyVote'],
      map['correctPoint'],
      map['wrongPoint'],
      map['initialAwardValue'],
      map['winningPoint'],
    );
  }

  factory SeasonModel.fromJson(String source) =>
      SeasonModel.fromData(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SeasonModel &&
        o.seasonName == seasonName &&
        o.startDate == startDate &&
        o.maxDailyVote == maxDailyVote &&
        o.correctPoint == correctPoint &&
        o.wrongPoint == wrongPoint &&
        o.initialAwardValue == initialAwardValue &&
        o.winningPoint == winningPoint;
  }

  @override
  int get hashCode {
    return seasonName.hashCode ^
        startDate.hashCode ^
        maxDailyVote.hashCode ^
        correctPoint.hashCode ^
        wrongPoint.hashCode ^
        initialAwardValue.hashCode ^
        winningPoint.hashCode;
  }
}
