import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  final String category;
  final String title;
  final String content;
  final Timestamp noticeDateTime;

  NoticeModel({
    this.category,
    this.title,
    this.content,
    this.noticeDateTime,
  });

  NoticeModel.fromData(Map<String, dynamic> data)
      : category = data['category'],
        title = data['title'],
        content = data['content'],
        noticeDateTime = data['noticeDateTime'];

  Map<String, dynamic> toJson() {
    return {
      'category': this.category,
      'title': this.title,
      'content': this.content,
      'noticeDateTime': this.noticeDateTime,
    };
  }
}
