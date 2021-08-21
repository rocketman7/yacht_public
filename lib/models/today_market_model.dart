import 'dart:convert';

import 'package:yachtOne/models/news_model.dart';

class TodayMarketModel {
  final dynamic dateTime;
  final String category;
  final String title;
  final String? summary;
  final String newsUrl;
  final String newspaper;
  final String? imageUrl;
  TodayMarketModel({
    required this.dateTime,
    required this.category,
    required this.title,
    this.summary,
    required this.newsUrl,
    required this.newspaper,
    this.imageUrl,
  });

  TodayMarketModel copyWith({
    dynamic? dateTime,
    String? category,
    String? title,
    String? summary,
    String? newsUrl,
    String? newspaper,
    String? imageUrl,
  }) {
    return TodayMarketModel(
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      newsUrl: newsUrl ?? this.newsUrl,
      newspaper: newspaper ?? this.newspaper,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'category': category,
      'title': title,
      'summary': summary,
      'newsUrl': newsUrl,
      'newspaper': newspaper,
      'imageUrl': imageUrl,
    };
  }

  factory TodayMarketModel.fromMap(Map<String, dynamic> map) {
    return TodayMarketModel(
      dateTime: map['dateTime'],
      category: map['category'],
      title: map['title'],
      summary: map['summary'],
      newsUrl: map['newsUrl'],
      newspaper: map['newspaper'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TodayMarketModel.fromJson(String source) =>
      TodayMarketModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TodayMarketModel(dateTime: $dateTime, category: $category, title: $title, summary: $summary, newsUrl: $newsUrl, newspaper: $newspaper, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TodayMarketModel &&
        other.dateTime == dateTime &&
        other.category == category &&
        other.title == title &&
        other.summary == summary &&
        other.newsUrl == newsUrl &&
        other.newspaper == newspaper &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return dateTime.hashCode ^
        category.hashCode ^
        title.hashCode ^
        summary.hashCode ^
        newsUrl.hashCode ^
        newspaper.hashCode ^
        imageUrl.hashCode;
  }
}
