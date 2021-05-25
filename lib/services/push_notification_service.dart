import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:yachtOne/models/dialog_model.dart';

import 'navigation_service.dart';
import 'dialog_service.dart';
import 'sharedPreferences_service.dart';
import '../models/sharedPreferences_const.dart';

import '../locator.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final NavigationService? _navigationService = locator<NavigationService>();
  final DialogService? _dialogService = locator<DialogService>();
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 여기서 모든 푸쉬알람 리스트, 설정 등을 관리해준다.
  // * /models/shared_preferences_const 에서도 key 값을 관리해주어야함.
  // * 정상적인 배포에서는 현재 푸쉬알람이 3개여야 하고, 'testPushAlarm'이런 애들은 모두 주석처리되어야함
  int numOfPushAlarm = 3;
  List<bool> pushAlarm = [
    false,
    false,
    false,
    // false,
  ]; //***중요:false 면 알림이 오는것이고, true면 알림 거부하는 것임
  // List<String> topics = ['vote', 'time', 'result', 'testPushAlarm'];
  List<String> topics = ['vote', 'time', 'result'];
  List<String> pushAlarmTitles = [
    '투표 관련 알림',
    '장 관련 알림',
    '정답 관련 알림',
  ];
  List<String> pushAlarmSubTitles = [
    '투표 마감 및 새로운 투표 시작을 알립니다.',
    '오늘 장이 시작/종료되었음을 알립니다.',
    '오늘 투표 정답 및 결과를 알립니다.',
  ];

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestPermission(sound: true, badge: true, alert: true);
      NotificationSettings settings = await _fcm.getNotificationSettings();

      print("Settings registered: $settings");

      // print(_fcm.onIosSettingsRegistered);
      // _fcm.subscribeToTopic('test');

      // 현재 사용자의 푸쉬알림 상태에 따라 구독/구독취소를 해준다.
      // 안전하게 true면 구독취소까지해준다.
      // for (int i = 0; i < numOfPushAlarm; i++)
      //   pushAlarm[i] = await _sharedPreferencesService
      //       .getSharedPreferencesValue(pushAlarmKey[i], bool);

      // print('=============================================================');
      // for (int i = 0; i < numOfPushAlarm; i++) {
      //   if (pushAlarm[i]) {
      //     print('unsubscribe(${pushAlarmKey[i]}): ${topics[i]}');
      //     _fcm.unsubscribeFromTopic(topics[i]);
      //   } else {
      //     print('subscribe(${pushAlarmKey[i]}): ${topics[i]}');
      //     _fcm.subscribeToTopic(topics[i]);
      //   }
      // }
      // print(pushAlarm);
      // print('=============================================================');

      // _fcm.requestNotificationPermissions(IosNotificationSettings());

    }

    // _fcm.subscribeToTopic('test');

    print("PUSH initialised");

    // 현재 사용자의 푸쉬알림 상태에 따라 구독/구독취소를 해준다.
    // 안전하게 true면 구독취소까지해준다.
    for (int i = 0; i < numOfPushAlarm; i++)
      pushAlarm[i] = await (_sharedPreferencesService!
          .getSharedPreferencesValue(pushAlarmKey[i], bool) as FutureOr<bool>);

    print('=============================================================');
    for (int i = 0; i < numOfPushAlarm; i++) {
      if (pushAlarm[i]) {
        print('unsubscribe(${pushAlarmKey[i]}): ${topics[i]}');
        _fcm.unsubscribeFromTopic(topics[i]);
      } else {
        print('subscribe(${pushAlarmKey[i]}): ${topics[i]}');
        _fcm.subscribeToTopic(topics[i]);
      }
    }
    print(pushAlarm);
    print('=============================================================');

    // configure가 없어졌으므로 새로운 event handling 적용 해야 함
    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     // 앱이 실행중일 때
    //     print("onMessage: $message");
    //     // _onMessageDialog(message);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     // 앱이 꺼져있을 때 // 이 때 알림 옴
    //     print("onLaunch: $message");
    //     _onNonMessageNavigate(message);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     // 앱이 실행 중이지만 백그라운드에 있을 때 // 이 때도 알림 옴
    //     print("onResume: $message");
    //     _onNonMessageNavigate(message);
    //   },
    // );

    _fcm.getToken().then((value) => print("TOKEN IS " + value!));
  }

  Future subOrUnscribeToTopic(int i, bool value) async {
    pushAlarm[i] = value;
    await _sharedPreferencesService!
        .setSharedPreferencesValue(pushAlarmKey[i], value);
    if (value) {
      await _fcm.unsubscribeFromTopic(topics[i]);
      print('unsubscribe(${pushAlarmKey[i]}): ${topics[i]}');
    } else {
      await _fcm.subscribeToTopic(topics[i]);
      print('subscribe(${pushAlarmKey[i]}): ${topics[i]}');
    }
  }

  // void _serializeAndNavigate(Map<String, dynamic> message) {
  //   _dialogService.showDialog(title: message['notification']['body']);

  //   // if (message['view'] == 'voteSelect')
  //   //   _navigationService.navigateWithArgTo('startup', 1);
  // }

  // 앱이 실행중일 때는 다이얼로그를 띄워준다. 알림 내용 그대로.
  // Future<void> _onMessageDialog(Map<String, dynamic> message) async {
  //   // DialogResponse dialogResponse;
  //   // dialogResponse = await _dialogService.showDialog(
  //   //     title: message['notification']['title'],
  //   //     description: message['notification']['body'],
  //   //     buttonTitle: '확인',
  //   //     cancelTitle: '취소');

  //   // if (dialogResponse.confirmed) {
  //   // _navigationService.navigateTo('mypage_main');
  //   // }
  // }

  // 앱이 실행중일 때는 다이얼로그를 띄워준다. 알림 내용 그대로.
  void _onMessageDialog(Map<String, dynamic> message) {
    // print('call showDialog=-=-=-=-=--=-=-=-=');
    // _dialogService.showDialog(title: message['notification']['body']);
    // DialogResponse dialogResponse;
    // dialogResponse = await _dialogService.showDialog(
    //     title: message['notification']['title'],
    //     description: message['notification']['body'],
    //     buttonTitle: '확인',
    //     cancelTitle: '취소');

    // if (dialogResponse.confirmed) {
    // _navigationService.navigateTo('mypage_main');
    // }
  }

  // 앱이 꺼져있거나 백그라운드에 있을 때는 알림 페이지로 바로 네비게잇할 수 있도록 한다.
  void _onNonMessageNavigate(Map<String, dynamic> message) {
    _navigationService!.navigateTo('notification');
  }
}
