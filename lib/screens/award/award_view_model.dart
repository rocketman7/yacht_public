import 'package:stacked/stacked.dart';

class AwardViewModel extends FutureViewModel {
  // Services Setting

  // 변수 Setting

  // 생성자
  AwardViewModel();

  // futureToRun으로 호출하는.
  Future getNotificationList() async {
    notifyListeners();
  }

  // method

  @override
  Future futureToRun() => getNotificationList();
}
