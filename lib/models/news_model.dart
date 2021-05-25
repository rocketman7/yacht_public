import 'dart:convert';

class NewsModel {
  final String? title;
  final String? link;
  final String? newsFrom;
  final dynamic date;
  NewsModel({
    this.title,
    this.link,
    this.newsFrom,
    this.date,
  });

  NewsModel copyWith({
    String? title,
    String? link,
    String? newsFrom,
    dynamic date,
  }) {
    return NewsModel(
      title: title ?? this.title,
      link: link ?? this.link,
      newsFrom: newsFrom ?? this.newsFrom,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'newsFrom': newsFrom,
      'date': date,
    };
  }

  factory NewsModel.fromData(Map<String, dynamic>? data) {
    // if (data == null) return null;

    return NewsModel(
      title: data!['title'],
      link: data['link'],
      newsFrom: data['newsFrom'],
      date: data['date'],
    );
  }

  @override
  String toString() {
    return 'NewsModel(title: $title, link: $link, newsFrom: $newsFrom, date: $date)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is NewsModel &&
        o.title == title &&
        o.link == link &&
        o.newsFrom == newsFrom &&
        o.date == date;
  }

  @override
  int get hashCode {
    return title.hashCode ^ link.hashCode ^ newsFrom.hashCode ^ date.hashCode;
  }
}
