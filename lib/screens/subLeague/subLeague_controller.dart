import 'package:get/get.dart';

import '../../services/firestore_service.dart';
import '../../models/subLeague_model.dart';

class SubLeagueController extends GetxController {
  FirestoreService _firestoreService = FirestoreService();
  List<SubLeagueModel> allSubLeagues = [];
  bool isAllSubLeaguesLoaded = false;
  RxInt pageIndexForUI = 0.obs;

  // HomeRepository _homeRepository = HomeRepository();

  @override
  void onInit() async {
    // 실제 홈 화면에서도 얘를 가장 먼저 호출해야할듯? 가장 중요하면서 위에 있는 정보니까.
    allSubLeagues = await getAllSubLeague();

    Future.delayed(Duration(seconds: 1), () {
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
    }
  }

  void pageNavigateToLeft() {
    if (isAllSubLeaguesLoaded && pageIndexForUI.value > 0) {
      pageIndexForUI--;
    }
  }
}

//// 아래는 repository 및 DB admin state manage (stream) 을 위한 것들을 구현해본 것
class HomeRepository extends GetxController {
  FirestoreService _firestoreService = FirestoreService();

  RxString stateStream1 = ''.obs;
  RxString stateStream2 = ''.obs;

  @override
  void onInit() {
    stateStream1.bindStream(getStateStream1());
    stateStream2.bindStream(getStateStream2());

    stateStream1.listen((stream) {
      print('state stream1 come ==> $stream');
    });

    stateStream2.listen((stream) {
      print('state stream2 come ==> $stream');
    });

    super.onInit();
  }

  Stream<String> getStateStream1() {
    return _firestoreService.getStateStream1();
  }

  Stream<String> getStateStream2() {
    return _firestoreService.getStateStream2();
  }

  // late Stream<String> stateStream = _firestoreService.getStateStream();
}
