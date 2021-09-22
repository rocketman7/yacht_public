import 'dart:convert';

class RankModel {
  final String uid;
  final String userName;
  final String? avatarImage;
  final num todayRank;
  final num todayPoint;
  //updateDateTime;

  RankModel({
    required this.uid,
    required this.userName,
    this.avatarImage,
    required this.todayRank,
    required this.todayPoint,
  });

  RankModel copyWith({
    String? uid,
    String? userName,
    String? avatarImage,
    num? todayRank,
    num? todayPoint,
  }) {
    return RankModel(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      avatarImage: avatarImage ?? this.avatarImage,
      todayRank: todayRank ?? this.todayRank,
      todayPoint: todayPoint ?? this.todayPoint,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userName': userName,
      'avatarImage': avatarImage,
      'todayRank': todayRank,
      'todayPoint': todayPoint,
    };
  }

  factory RankModel.fromMap(Map<String, dynamic> map) {
    return RankModel(
      uid: map['uid'],
      userName: map['userName'],
      avatarImage: map['avatarImage'] ?? null,
      todayRank: map['todayRank'],
      todayPoint: map['todayPoint'],
    );
  }

  String toJson() => json.encode(toMap());

  factory RankModel.fromJson(String source) =>
      RankModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uid: $uid, userName: $userName, avatarImage: $avatarImage, todayRank: $todayRank, todayPoint: $todayPoint';
  }
}
