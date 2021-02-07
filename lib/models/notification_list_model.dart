import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationListModel {
  final String title; // 알림제목
  final String content; // 알림내용
  final Timestamp notificationTime; // 알림일시
  final String url; // 웹뷰에 연동된 알림이라면 이 값이 있다. 없으면 필드값 자체가 없음.
  final String
      moreContent; // 알림 자세한 내용. 웹뷰에 연동되지 않은 알림들 중 / 더 자세한 내용이 필요한 알림의 알림내용. 없을 수도 있다.

  NotificationListModel(this.title, this.content, this.notificationTime,
      this.url, this.moreContent);

  NotificationListModel.fromData(Map<String, dynamic> data)
      : title = data['title'],
        content = data['content'],
        notificationTime = data['notificationTime'],
        url = data['url'] ?? null,
        moreContent = data['moreContent'] ?? null;
}
