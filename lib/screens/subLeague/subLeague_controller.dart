import 'package:get/get.dart';

import '../../services/firestore_service.dart';
import '../../models/subLeague_model.dart';

class SubLeagueController extends GetxController {
  FirestoreService _firestoreService = FirestoreService();
  List<SubLeagueModel> allSubLeagues = [];
  bool isAllSubLeaguesLoaded = false;
  RxInt pageIndexForUI = 0.obs;

  @override
  void onInit() async {
    // 실제 홈 화면에서도 얘를 가장 먼저 호출해야할듯? 가장 중요하면서 위에 있는 정보니까.
    allSubLeagues = await getAllSubLeague();

    Future.delayed(Duration(seconds: 1), () {
      print('futurefuture');
      isAllSubLeaguesLoaded = true;

      update();
    });

    super.onInit();
  }

  Future getAllSubLeague() async {
    return _firestoreService.getAllSubLeague();
  }

  // 페이지 이동
  void pageNavigateToRight() {
    if (isAllSubLeaguesLoaded &&
        pageIndexForUI.value < (allSubLeagues.length - 1)) {
      pageIndexForUI++;
      print(
          'allSubLeagues.length is ${allSubLeagues.length} & pageIndex is ${pageIndexForUI.value}');
    }
  }

  void pageNavigateToLeft() {
    if (isAllSubLeaguesLoaded && pageIndexForUI.value > 0) {
      pageIndexForUI--;
    }
  }
}
