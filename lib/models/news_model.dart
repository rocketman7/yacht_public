import 'dart:convert';

class NewsModel {
  final dynamic dateTime;
  final String newsUrl;
  final String newspaper;
  final String title;
  final String? imageUrl;
  NewsModel({
    required this.dateTime,
    required this.newsUrl,
    required this.newspaper,
    required this.title,
    required this.imageUrl,
  });

  NewsModel copyWith({
    dynamic dateTime,
    String? newsUrl,
    String? newspaper,
    String? title,
    String? imageUrl,
  }) {
    return NewsModel(
      dateTime: dateTime ?? this.dateTime,
      newsUrl: newsUrl ?? this.newsUrl,
      newspaper: newspaper ?? this.newspaper,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'newsUrl': newsUrl,
      'newspaper': newspaper,
      'title': title,
      'imageUrl': imageUrl,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      dateTime: map['dateTime'],
      newsUrl: map['newsUrl'],
      newspaper: map['newspaper'],
      title: map['title'],
      imageUrl: map['imageUrl'] ?? null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NewsModel(dateTime: $dateTime, newsUrl: $newsUrl, newspaper: $newspaper, title: $title, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NewsModel &&
        other.dateTime == dateTime &&
        other.newsUrl == newsUrl &&
        other.newspaper == newspaper &&
        other.title == title &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return dateTime.hashCode ^
        newsUrl.hashCode ^
        newspaper.hashCode ^
        title.hashCode ^
        imageUrl.hashCode;
  }
}
