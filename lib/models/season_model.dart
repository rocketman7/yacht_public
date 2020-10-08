import 'dart:convert';

class SeasonModel {
  final String seasonName;
  final String startDate;
  final int winningPoint;
  final int correctPoint;
  final int wrongPoint;
  final int initialAwardValue;
  final int winningCombo;

  SeasonModel(
      this.seasonName,
      this.startDate,
      this.winningPoint,
      this.correctPoint,
      this.wrongPoint,
      this.initialAwardValue,
      this.winningCombo);

  SeasonModel copyWith({
    String seasonName,
    String startDate,
    int winningPoint,
    int correctPoint,
    int wrongPoint,
    int initialAwardValue,
    int winningcombo,
  }) {
    return SeasonModel(
      seasonName ?? this.seasonName,
      startDate ?? this.startDate,
      winningPoint ?? this.winningPoint,
      correctPoint ?? this.correctPoint,
      wrongPoint ?? this.wrongPoint,
      initialAwardValue ?? this.initialAwardValue,
      winningcombo ?? this.winningCombo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seasonName': seasonName,
      'startDate': startDate,
      'winningPoint': winningPoint,
      'correctPoint': correctPoint,
      'wrongPoint': wrongPoint,
      'initialAwardValue': initialAwardValue,
      'winningCombo': winningCombo
    };
  }

  factory SeasonModel.fromData(Map<String, dynamic> map) {
    if (map == null) return null;

    return SeasonModel(
      map['seasonName'],
      map['startDate'],
      map['winningPoint'],
      map['correctPoint'],
      map['wrongPoint'],
      map['initialAwardValue'],
      map['winningCombo'],
    );
  }

  factory SeasonModel.fromJson(String source) =>
      SeasonModel.fromData(json.decode(source));

  @override
  String toString() {
    return 'SeasonModel(seasonName: $seasonName, startDate: $startDate, winningPoint: $winningPoint, correctPoint: $correctPoint, wrongPoint: $wrongPoint, initialAwardValue: $initialAwardValue, winningCombo: $winningCombo)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is SeasonModel &&
        o.seasonName == seasonName &&
        o.startDate == startDate &&
        o.winningPoint == winningPoint &&
        o.correctPoint == correctPoint &&
        o.wrongPoint == wrongPoint &&
        o.initialAwardValue == initialAwardValue &&
        o.winningCombo == winningCombo;
  }

  @override
  int get hashCode {
    return seasonName.hashCode ^
        startDate.hashCode ^
        winningPoint.hashCode ^
        correctPoint.hashCode ^
        wrongPoint.hashCode ^
        initialAwardValue.hashCode ^
        winningCombo.hashCode;
  }
}
