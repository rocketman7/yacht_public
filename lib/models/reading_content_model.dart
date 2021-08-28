import 'dart:convert';

class ReadingContentModel {
  final String title;
  final String category;
  final String summary;
  final String contentUrl;
  final String thumbnailUrl;
  final dynamic updateDateTime;
  final bool? showHomeView;
  ReadingContentModel({
    required this.title,
    required this.category,
    required this.summary,
    required this.contentUrl,
    required this.thumbnailUrl,
    required this.updateDateTime,
    this.showHomeView,
  });

  ReadingContentModel copyWith({
    String? title,
    String? category,
    String? summary,
    String? contentUrl,
    String? thumbnailUrl,
    dynamic? updateDateTime,
    bool? showHomeView,
  }) {
    return ReadingContentModel(
      title: title ?? this.title,
      category: category ?? this.category,
      summary: summary ?? this.summary,
      contentUrl: contentUrl ?? this.contentUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      updateDateTime: updateDateTime ?? this.updateDateTime,
      showHomeView: showHomeView ?? this.showHomeView,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'summary': summary,
      'contentUrl': contentUrl,
      'thumbnailUrl': thumbnailUrl,
      'updateDateTime': updateDateTime,
      'showHomeView': showHomeView,
    };
  }

  factory ReadingContentModel.fromMap(Map<String, dynamic> map) {
    return ReadingContentModel(
      title: map['title'],
      category: map['category'],
      summary: map['summary'],
      contentUrl: map['contentUrl'],
      thumbnailUrl: map['thumbnailUrl'],
      updateDateTime: map['updateDateTime'],
      showHomeView: map['showHomeView'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ReadingContentModel.fromJson(String source) => ReadingContentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ReadingContentModel(title: $title, category: $category, summary: $summary, contentUrl: $contentUrl, thumbnailUrl: $thumbnailUrl, updateDateTime: $updateDateTime, showHomeView: $showHomeView)';
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
        other.updateDateTime == updateDateTime &&
        other.showHomeView == showHomeView;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        category.hashCode ^
        summary.hashCode ^
        contentUrl.hashCode ^
        thumbnailUrl.hashCode ^
        updateDateTime.hashCode ^
        showHomeView.hashCode;
  }
}
