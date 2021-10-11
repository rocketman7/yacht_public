import 'package:cloud_firestore/cloud_firestore.dart';

class OneOnOneListModel {
  final String category;
  final String content;
  final Timestamp dateTime;
  final String? answer;

  OneOnOneListModel({
    required this.category,
    required this.content,
    required this.dateTime,
    this.answer,
  });

  OneOnOneListModel.fromData(Map<String, dynamic> data)
      : category = data['category'],
        content = data['content'],
        dateTime = data['dateTime'],
        answer = data['answer'] ?? '';
}
