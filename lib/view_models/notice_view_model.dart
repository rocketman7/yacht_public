import 'package:stacked/stacked.dart';

import '../locator.dart';
import '../models/notice_model.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class NoticeViewModel extends FutureViewModel {
  // Services Setting
  final DatabaseService? _databaseService = locator<DatabaseService>();
  final NavigationService? _navigationService = locator<NavigationService>();

  // 변수 Setting
  List<NoticeModel>? noticeModel = [];
  List<String> noticeDateTimeStr = [];
  List<bool> isNew = [];

  NoticeViewModel();

  // method
  // futureToRun으로 호출하는.
  Future getNoticeList() async {
    noticeModel = await _databaseService!.getNotice();

    for (int i = 0; i < noticeModel!.length; i++) {
      isNew.add(false);
    }

    // 날짜를 String 형태로 바꿔놓는다
    for (int i = 0; i < noticeModel!.length; i++) {
      noticeDateTimeStr.add(noticeModel![i].noticeDateTime!.toDate().toString());

      noticeDateTimeStr[i] = noticeDateTimeStr[i].substring(0, 4) +
          '.' +
          noticeDateTimeStr[i].substring(5, 7) +
          '.' +
          noticeDateTimeStr[i].substring(8, 10);
    }

    DateTime now = DateTime.now();
    // New 인지 판단해준다.
    for (int i = 0; i < noticeModel!.length; i++) {
      if (now.difference(noticeModel![i].noticeDateTime!.toDate()).inDays <= 2) {
        isNew[i] = true;
      }
    }

    notifyListeners();
  }

  // 선택하면 하위페이지로 이동한다
  void selectNotice(int index) {
    if (noticeModel![index].textOrNavigateTo == 'text') {
      _navigationService!.navigateWithArgTo(
          'notice_text_based', noticeModel![index]);
    } else {
      // print('${noticeModel[index].navigateArgu}');
      _navigationService!.navigateWithArgTo(
          noticeModel![index].textOrNavigateTo.toString(),
          noticeModel![index].navigateArgu);
    }
  }

  @override
  Future futureToRun() => getNoticeList();
}
