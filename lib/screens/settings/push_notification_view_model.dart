import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../locator.dart';
import '../../services/push_notification_service.dart';

class PushNotificationViewModel extends GetxController {
  PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  @override
  void onInit() async {
    super.onInit();
  }

  int getPushAlarmLength() {
    return _pushNotificationService.numOfPushAlarm;
  }

  String getPushAlarmTitle(int index) {
    return _pushNotificationService.pushAlarmTitles[index];
  }

  bool getPushAlarmValue(int index) {
    return GetStorage()
        .read('pushAlarm' + _pushNotificationService.topics[index]);
  }

  void setPushAlarmValue(int index, bool value) {
    GetStorage()
        .write('pushAlarm' + _pushNotificationService.topics[index], !value);
    _pushNotificationService.subOrUnscribeToTopic(index, !value);

    update(['pushAlarmValue']);
  }
}
