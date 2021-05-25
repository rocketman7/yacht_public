import 'package:cloud_firestore/cloud_firestore.dart';

class UserPostModel {
  final String? category;
  final String? season;
  final String? subVote;
  final String? date;

  final Timestamp? createdAt;

  UserPostModel({
    this.category,
    this.season,
    this.subVote,
    this.date,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': this.category,
      'season': this.season,
      'subVote': this.subVote,
      'date': this.date,
      'createdAt': this.createdAt,
    };
  }

  factory UserPostModel.fromMap(Map<String, dynamic> data) {
    // if (data == null) return null;

    return UserPostModel(
      category: data['category'],
      season: data['season'],
      subVote: data['subVote'],
      date: data['date'],
      createdAt: data['createdAt'],
    );
  }

  @override
  String toString() {
    return 'UserPostModel(category: $category, season: $season, subVote: $subVote, date: $date,   createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is UserPostModel &&
        o.category == category &&
        o.season == season &&
        o.subVote == subVote &&
        o.date == date &&
        o.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return category.hashCode ^
        season.hashCode ^
        subVote.hashCode ^
        date.hashCode ^
        createdAt.hashCode;
  }
}
