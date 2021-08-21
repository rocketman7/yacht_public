import 'dart:convert';

class ReadingContentModel {
  final String title;
  final String category;
  final String summary;
  final String contentUrl;
  final String thumbnailUrl;
  final dynamic updatedDateTime;
  ReadingContentModel({
    required this.title,
    required this.category,
    required this.summary,
    required this.contentUrl,
    required this.thumbnailUrl,
    required this.updatedDateTime,
  });

  ReadingContentModel copyWith({
    String? title,
    String? category,
    String? summary,
    String? contentUrl,
    String? thumbnailUrl,
    dynamic? updatedDateTime,
  }) {
    return ReadingContentModel(
      title: title ?? this.title,
      category: category ?? this.category,
      summary: summary ?? this.summary,
      contentUrl: contentUrl ?? this.contentUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      updatedDateTime: updatedDateTime ?? this.updatedDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'summary': summary,
      'contentUrl': contentUrl,
      'thumbnailUrl': thumbnailUrl,
      'updatedDateTime': updatedDateTime,
    };
  }

  factory ReadingContentModel.fromMap(Map<String, dynamic> map) {
    return ReadingContentModel(
      title: map['title'],
      category: map['category'],
      summary: map['summary'],
      contentUrl: map['contentUrl'],
      thumbnailUrl: map['thumbnailUrl'],
      updatedDateTime: map['updatedDateTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReadingContentModel.fromJson(String source) =>
      ReadingContentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReadingContentModel(title: $title, category: $category, summary: $summary, contentUrl: $contentUrl, thumbnailUrl: $thumbnailUrl, updatedDateTime: $updatedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReadingContentModel &&
        other.title == title &&
        other.category == category &&
        other.summary == summary &&
        other.contentUrl == contentUrl &&
        other.thumbnailUrl == thumbnailUrl &&
        other.updatedDateTime == updatedDateTime;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        category.hashCode ^
        summary.hashCode ^
        contentUrl.hashCode ^
        thumbnailUrl.hashCode ^
        updatedDateTime.hashCode;
  }
}
