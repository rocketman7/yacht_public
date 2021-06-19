import 'package:stacked/stacked.dart';

class AwardOldViewViewModel extends FutureViewModel {
  // Services Setting

  // 변수 Setting

  // 생성자
  AwardOldViewViewModel();

  // futureToRun으로 호출하는.
  Future getNotificationList() async {
    notifyListeners();
  }

  // method

  @override
  Future futureToRun() => getNotificationList();
}
