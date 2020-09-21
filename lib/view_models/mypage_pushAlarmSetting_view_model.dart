import 'package:stacked/stacked.dart';

import '../services/sharedPreferences_service.dart';
import '../locator.dart';
import '../models/sharedPreferences_const.dart';

class MypagePushAlarmSettingViewModel extends FutureViewModel {
  // Services Setting
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 변수 Setting
  // Shared Preferences 변수 Setting
  // Shared Preferences 값들을 아래에서 선언 및 관리해준다. 초기값을 넣어주는게 안전함.
  // * /models/shared_preferences_const 에서도 key 값을 관리해주어야함.
  int numOfPushAlarm = 10;
  List<bool> pushAlarm = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  // 아래에 title, subTitle 기록. 뭐인지 여기서 보기편한목적 + 코드 통일. numOfPushAlarm.
  List<String> pushAlarmTitles = [
    '투표시작 알림',
    '투표마감 10분 전 알림',
    '투표마감 알림',
    '장개시 알림',
    '교환아이템 사용가능 알림',
    '교환아이템 사용마감 10분 전 알림',
    '교환아이템 사용마감 알림',
    '장 마감 알림',
    '결과통보 알림',
    '이벤트 알림',
  ];
  List<String> pushAlarmSubTitles = [
    '새로운 주제에 대한 투표가 시작되었음을 알립니다.',
    '오늘 주제에 대한 투표 마감시간이 10분 남았음을 알립니다.',
    '오늘 주제에 대한 투표가 마감되었음을 알립니다.',
    '오늘 장이 개시되었음을 알립니다.',
    '교환아이템을 사용가능함을 알립니다.',
    '교환아이템을 사용할 수 있는 시간이 10분 남았음을 알립니다.',
    '교환아이템 사용가능시간이 마감되었음을 알립니다.',
    '장이 마감되었음을 알립니다.',
    '오늘의 투표 결과를 통보해줍니다.',
    '이벤트 관련 전반에 대해 알립니다(시즌 종료, 특별 주제 등)',
  ];

  // method
  // shared preferences method
  void clearSharedPreferencesAll() {
    _sharedPreferencesService.clearSharedPreferencesAll();
    for (int i = 0; i < numOfPushAlarm; i++) pushAlarm[i] = false;

    notifyListeners();
  }

  Future getSharedPreferencesAll() async {
    for (int i = 0; i < numOfPushAlarm; i++)
      pushAlarm[i] = await _sharedPreferencesService.getSharedPreferencesValue(
          pushAlarmKey[i], bool);

    notifyListeners();
  }

  void setSharedPreferencesAll() {
    for (int i = 0; i < numOfPushAlarm; i++)
      _sharedPreferencesService.setSharedPreferencesValue(
          pushAlarmKey[i], pushAlarm[i]);

    notifyListeners();
  }

  @override
  Future futureToRun() => getSharedPreferencesAll();
}
