import 'package:stacked/stacked.dart';

class YachtPortfolioViewModel extends FutureViewModel {
  // Services Setting

  // 변수 Setting

  // 생성자
  YachtPortfolioViewModel();

  // futureToRun으로 호출하는.
  Future getNotificationList() async {
    notifyListeners();
  }

  // method

  @override
  Future futureToRun() => getNotificationList();
}
