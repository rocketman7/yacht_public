import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  final String textOrNavigateTo;
  final List<String> navigateArgu;
  final String category;
  final String title;
  final String content;
  final Timestamp noticeDateTime;

  NoticeModel({
    this.textOrNavigateTo,
    this.navigateArgu,
    this.category,
    this.title,
    this.content,
    this.noticeDateTime,
  });

  NoticeModel.fromData(Map<String, dynamic> data)
      : textOrNavigateTo = data['textOrNavigateTo'],
        navigateArgu = data['navigateArgu'] == null
            ? []
            : data['navigateArgu'].cast<String>(),
        category = data['category'],
        title = data['title'],
        content = data['content'],
        noticeDateTime = data['noticeDateTime'];

  Map<String, dynamic> toJson() {
    return {
      'textOrNavigateTo': this.textOrNavigateTo,
      'navigateArgu': this.navigateArgu,
      'category': this.category,
      'title': this.title,
      'content': this.content,
      'noticeDateTime': this.noticeDateTime,
    };
  }
}
