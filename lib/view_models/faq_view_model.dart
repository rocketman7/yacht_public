import 'package:stacked/stacked.dart';

import '../locator.dart';
import '../models/faq_model.dart';
import '../services/database_service.dart';

class FaqViewModel extends FutureViewModel {
  // Services Setting
  final DatabaseService _databaseService = locator<DatabaseService>();

  // 변수 Setting
  List<FaqModel> faqModel = [];
  List<bool> isSelected = [];

  FaqViewModel();

  // method
  // futureToRun으로 호출하는.
  Future getFaqList() async {
    faqModel = await _databaseService.getFaq();

    for (int i = 0; i < faqModel.length; i++) {
      // faqModel[i].content.replaceAll('\\n', '\n');
      isSelected.add(false);
    }
    notifyListeners();
  }

  // 선택하면 isSelected 바꿔준다
  void selectFaqDetail(int index) {
    isSelected[index] = !isSelected[index];

    notifyListeners();
  }

  @override
  Future futureToRun() => getFaqList();
}
