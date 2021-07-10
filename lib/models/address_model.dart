import 'dart:convert';

class AddressModel {
  final String uid;
  final String league;
  final String date;
  AddressModel({
    required this.uid,
    required this.league,
    required this.date,
  });

  AddressModel copyWith({
    String? uid,
    String? league,
    String? date,
  }) {
    return AddressModel(
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

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      uid: map['uid'],
      league: map['league'],
      date: map['date'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));

  @override
  String toString() => 'AddressModel(uid: $uid, league: $league, date: $date)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressModel &&
        other.uid == uid &&
        other.league == league &&
        other.date == date;
  }

  @override
  int get hashCode => uid.hashCode ^ league.hashCode ^ date.hashCode;
}
