import 'dart:convert';

class LeagueAddressModel {
  final String uid;
  final String league;
  final String date;
  LeagueAddressModel({
    required this.uid,
    required this.league,
    required this.date,
  });

  LeagueAddressModel copyWith({
    String? uid,
    String? league,
    String? date,
  }) {
    return LeagueAddressModel(
      uid: uid ?? this.uid,
      league: league ?? this.league,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'league': league,
      'date': date,
    };
  }

  factory LeagueAddressModel.fromMap(Map<String, dynamic> map) {
    return LeagueAddressModel(
      uid: map['uid'],
      league: map['league'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory LeagueAddressModel.fromJson(String source) =>
      LeagueAddressModel.fromMap(json.decode(source));

  @override
  String toString() => 'AddressModel(uid: $uid, league: $league, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LeagueAddressModel &&
        other.uid == uid &&
        other.league == league &&
        other.date == date;
  }

  @override
  int get hashCode => uid.hashCode ^ league.hashCode ^ date.hashCode;
}
