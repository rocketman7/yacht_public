import 'package:stacked/stacked.dart';

import '../services/push_notification_service.dart';
import '../locator.dart';

class MypagePushAlarmSettingViewModel extends FutureViewModel {
  PushNotificationService _notificationService =
      locator<PushNotificationService>();

  // 알람 종류, topic등이 추가되어야 하면 서비스에서 직접 추가하면됨. + shared preferences const 도 수정해줘야. 뷰모델에서 건들건 없음
  int numOfPushAlarm;
  List<bool> pushAlarm;
  List<String> pushAlarmTitles;
  List<String> pushAlarmSubTitles;

  // method
  Future getSharedPreferencesAll() async {
    numOfPushAlarm = _notificationService.numOfPushAlarm;
    pushAlarm = _notificationService.pushAlarm;
    pushAlarmTitles = _notificationService.pushAlarmTitles;
    pushAlarmSubTitles = _notificationService.pushAlarmSubTitles;

    notifyListeners();
  }

  void setSharedPreference(int i, bool value) {
    pushAlarm[i] = value;
    _notificationService.subOrUnscribeToTopic(i, value);

    notifyListeners();
  }

  @override
  Future futureToRun() => getSharedPreferencesAll();
}
