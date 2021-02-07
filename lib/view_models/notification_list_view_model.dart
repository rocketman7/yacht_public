import 'package:stacked/stacked.dart';

import '../locator.dart';
import '../models/notification_list_model.dart';
import '../services/database_service.dart';
import '../services/sharedPreferences_service.dart';
import '../models/sharedPreferences_const.dart';

class NotificationListViewModel extends FutureViewModel {
  // Services Setting
  final DatabaseService _databaseService = locator<DatabaseService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 변수 Setting
  List<NotificationListModel> notificationListModel = [];
  List<String> notificationTimeStr = [];
  List<bool> isSelected = [];

  Function callbackFunc;

  NotificationListViewModel({this.callbackFunc});

  // method
  // futureToRun으로 호출하는.
  Future getNotificationList() async {
    notificationListModel = await _databaseService.getNotificationList();

    for (int i = 0; i < notificationListModel.length; i++) {
      isSelected.add(false);
    }

    // 날짜를 String 형태로 바꿔놓는다
    for (int i = 0; i < notificationListModel.length; i++) {
      notificationTimeStr
          .add(notificationListModel[i].notificationTime.toDate().toString());

      notificationTimeStr[i] = notificationTimeStr[i].substring(0, 4) +
          '.' +
          notificationTimeStr[i].substring(5, 7) +
          '.' +
          notificationTimeStr[i].substring(8, 10) +
          ' ' +
          notificationTimeStr[i].substring(11, 13) +
          ':' +
          notificationTimeStr[i].substring(14, 16);
    }

    // 현재를 마지막으로 노티피케이션 체크한 시점으로 저장해둔다.
    DateTime now = DateTime.now();
    String nowString = now.toString();
    nowString = nowString.substring(0, 4) +
        nowString.substring(5, 7) +
        nowString.substring(8, 10) +
        nowString.substring(11, 13) +
        nowString.substring(14, 16);

    // print(nowString);

    await _sharedPreferencesService.setSharedPreferencesValue(
        lastCheckTimeKey, nowString);

    // 이러면 pop으로 돌아가면 바로 노티피케이션 빨간 점 없어짐
    if (callbackFunc != null) callbackFunc();

    notifyListeners();
  }

  // 선택했을 때. 오로지 자세한 내용 있는 알림일 경우만 작동.
  void selectNotification(int index) {
    isSelected[index] = !isSelected[index];

    notifyListeners();
  }

  @override
  Future futureToRun() => getNotificationList();
}
