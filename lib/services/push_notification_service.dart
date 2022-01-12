import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/community/community_view.dart';
import 'package:yachtOne/screens/community/detail_post_view.dart';
import 'package:yachtOne/screens/startup/startup_view_model.dart';

import '../locator.dart';
import 'firestore_service.dart';

// https://pub.dev/packages/firebase_messaging/example
// 참고하여 전면 재수정했고 위 내용에서 인앱메세지? 등 아직 구현할 것 많음. 아래는 가장 기본으로만
class PushNotificationService {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  int numOfPushAlarm = 3;
  // List<String> topics = ['vote', 'time', 'result'];
  // 아래 토픽 및 타이틀들은 정해진게 아니므로 (갯수3개도 그렇고) 출시 전 바꿔줘야함
  List<String> topics = ['quest', 'contents', 'feed'];

  List<String> pushAlarmTitles = [
    '퀘스트 알림',
    '컨텐츠 알림',
    '피드 알림',
  ];

  Future initialise() async {
    print("push notification init");
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .requestPermission(alert: true, badge: true, sound: true);

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

      // print('ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ ${GetStorage().read('pushAlarm' + topics[i])}');
    }

    // 처음 들어오거나 특정한 이유로 토큰이 없는 사용자들은 토큰을 저장해줘야한다 DB에. 그리고 기본적으로 모두 구독해줘야한다.
    // if (userModelRx.value!.token == null) {
    String token;

    await FirebaseMessaging.instance.getToken().then((value) async {
      token = value!;
      print('user token... and need to update DB' + token);

      if (userModelRx.value!.token == null ||
          userModelRx.value!.token != token) {
        await _firestoreService.updateUserFCMToken(token);

        for (int i = 0; i < numOfPushAlarm; i++) {
          await FirebaseMessaging.instance.subscribeToTopic(topics[i]);
        }
      }
      // await FirebaseMessaging.instance.subscribeToTopic('admintest');
    });
    // }

    //
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   Map<String, dynamic> data = message.data;

    //   print(data);

    //   if (data['action'] == 'navigate') {
    //     if (data['route'] == 'community') {
    //       Get.find<StartupViewModel>().selectedPage(2);
    //       _firestoreService.getThisPost(data['option']).then((data) {
    //         Get.to(() => DetailPostView(data!));
    //       });
    //     }
    //   }
    // });

    // //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   Map<String, dynamic> data = message.data;

    //   print(data);

    //   if (data['action'] == 'navigate') {
    //     if (data['route'] == 'community') {
    //       Get.find<StartupViewModel>().selectedPage(2);
    //       _firestoreService.getThisPost(data['option']).then((data) {
    //         Get.to(() => DetailPostView(data!));
    //       });
    //     }
    //   }
    // });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        Map<String, dynamic> data = message.data;

        print(data);

        if (data['action'] == 'navigate') {
          if (data['route'] == 'community') {
            Get.find<StartupViewModel>().selectedPage(2);
            _firestoreService.getThisPost(data['option']).then((data) {
              Get.to(() => DetailPostView(data!));
            });
          }
        }
      }
    });
  }

  Future subOrUnscribeToTopic(int i, bool value) async {
    GetStorage().write('pushAlarm' + topics[i], value);

    if (value) {
      print('subscribe to topic ${topics[i]}');
      await FirebaseMessaging.instance.subscribeToTopic(topics[i]);
    } else {
      print('unsubscribe from topic ${topics[i]}');
      await FirebaseMessaging.instance.unsubscribeFromTopic(topics[i]);
    }
  }
}
