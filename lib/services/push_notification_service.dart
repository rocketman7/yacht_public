import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yachtOne/repositories/repository.dart';

import '../locator.dart';
import 'firestore_service.dart';

// https://pub.dev/packages/firebase_messaging/example
// 참고하여 전면 재수정했고 위 내용에서 인앱메세지? 등 아직 구현할 것 많음. 아래는 가장 기본으로만
class PushNotificationService {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  int numOfPushAlarm = 3;
  // List<bool> pushAlarm = [
  //   false,
  //   false,
  //   false,
  // ]; //***중요:true이면 알림이 오는것이고, false이면 알림 거부하는 것임

  // List<String> topics = ['vote', 'time', 'result'];
  // 아래 토픽 및 타이틀들은 정해진게 아니므로 (갯수3개도 그렇고) 출시 전 바꿔줘야함
  List<String> topics = ['aaa', 'bbb', 'ccc'];

  List<String> pushAlarmTitles = [
    '새로운 퀘스트 및 퀘스트 마감 알림',
    '퀘스트 결과 알림',
    '장의 시작/종료 알림',
  ];

  Future initialise() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    for (int i = 0; i < numOfPushAlarm; i++) {
      if (GetStorage().read('pushAlarm' + topics[i]) == null) {
        // 만약 첫사용자거나 해서 pushAlarm 값이 없다면.. 일단 걍 트루로 (나중엔 바꿔줘야겠지만)
        GetStorage().write('pushAlarm' + topics[i], true);
        print('pushpushpuhspuhspuhspuhs');
      }

      // print('${GetStorage().read('pushAlarm' + topics[i])}');
    }

    // 처음 들어오거나 특정한 이유로 토큰이 없는 사용자들은 토큰을 저장해줘야한다 DB에. 그리고 기본적으로 모두 구독해줘야한다.
    if (userModelRx.value!.token == null) {
      String token;

      await FirebaseMessaging.instance.getToken().then((value) async {
        token = value!;
        print('user token... and need to update DB' + token);

        await _firestoreService.updateUserFCMToken(token);
      });

      for (int i = 0; i < numOfPushAlarm; i++) {
        await FirebaseMessaging.instance.subscribeToTopic(topics[i]);
      }
    }
  }

  Future subOrUnscribeToTopic(int i, bool value) async {
    GetStorage().write('pushAlarm' + topics[i], value);

    if (value)
      await FirebaseMessaging.instance.subscribeToTopic(topics[i]);
    else
      await FirebaseMessaging.instance.unsubscribeFromTopic(topics[i]);
  }
}
