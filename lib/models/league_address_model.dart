import 'dart:convert';

class LeagueAddressModel {
  final String openLeague;
  final String leagueName;
  final String leagueEndDateTime;
  LeagueAddressModel({
    required this.openLeague,
    required this.leagueName,
    required this.leagueEndDateTime,
  });

  LeagueAddressModel copyWith({
    String? openLeague,
    String? leagueName,
    String? leagueEndDateTime,
  }) {
    return LeagueAddressModel(
      openLeague: openLeague ?? this.openLeague,
      leagueName: leagueName ?? this.leagueName,
      leagueEndDateTime: leagueEndDateTime ?? this.leagueEndDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'openLeague': openLeague,
      'leagueName': leagueName,
      'leagueEndDateTime': leagueEndDateTime,
    };
  }

  factory LeagueAddressModel.fromMap(Map<String, dynamic> map) {
    return LeagueAddressModel(
      openLeague: map['openLeague'],
      leagueName: map['leagueName'],
      leagueEndDateTime: map['leagueEndDateTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LeagueAddressModel.fromJson(String source) => LeagueAddressModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'LeagueAddressModel(openLeague: $openLeague, leagueName: $leagueName, leagueEndDateTime: $leagueEndDateTime)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LeagueAddressModel &&
        other.openLeague == openLeague &&
        other.leagueName == leagueName &&
        other.leagueEndDateTime == leagueEndDateTime;
  }

  @override
  int get hashCode => openLeague.hashCode ^ leagueName.hashCode ^ leagueEndDateTime.hashCode;
}
