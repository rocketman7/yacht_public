import 'package:stacked/stacked.dart';

import '../locator.dart';
import '../models/oneOnOne_model.dart';
import '../services/database_service.dart';

class OneOnOneViewModel extends FutureViewModel {
  // Services Setting
  final DatabaseService _databaseService = locator<DatabaseService>();

  // 변수 Setting
  List<OneOnOneModel> oneOnOneModel = [];
  List<bool> isSelected = [];
  bool isPageOne = true;

  OneOnOneViewModel();

  // method
  // futureToRun으로 호출하는.
  Future getOneOnOneList() async {
    oneOnOneModel = await _databaseService.getOneOnOne();

    for (int i = 0; i < oneOnOneModel.length; i++) {
      isSelected.add(false);
    }
    notifyListeners();
  }

  // 선택하면 isSelected 바꿔준다
  void selectOneOnOneDetail(int index) {
    isSelected[index] = !isSelected[index];

    notifyListeners();
  }

  // 문의작성인지, 답변보는 탭인지
  void changePage() {
    isPageOne = !isPageOne;

    notifyListeners();
  }

  @override
  Future futureToRun() => getOneOnOneList();
}
