import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:yachtOne/services/navigation_service.dart';

import '../locator.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final NavigationService _navigationService = locator<NavigationService>();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
      _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });

      // _fcm.requestNotificationPermissions(IosNotificationSettings());

    }
    print("PUSH initialised");
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _serializeAndNavigate(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _serializeAndNavigate(message);
      },
    );

    _fcm.getToken().then((value) => print("TOKEN IS " + value));
  }

  void _serializeAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      if (view == 'voteSelect') {
        _navigationService.navigateWithArgTo('startup', '1');
      }
    }
  }
}
