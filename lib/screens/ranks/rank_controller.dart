import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';

import '../../services/firestore_service.dart';
import '../../services/storage_service.dart';
import '../../locator.dart';
import '../../models/rank_model.dart';

// 메인리그 = 무조건 subLeague001 고정
const int maxNumAllRankerForTop = 10; //
const int maxNumAllRanker = 200; // 아예 세부적으로 갔을 때 최대 몇 명 보여줄 것인지.

class RankController extends GetxController {
  FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  List<Map<String, int>> myRanksAndPoint = [
    {" ": 0}
  ];

  List<Map<String, int>> otherRanksAndPoint = [
    {" ": 0}
  ];

  late List<List<RankModel>> allRanker;

  bool isMyRanksAndPointLoaded = false;

  @override
  void onInit() async {
    // ever(leagueRx, (_) async {
    //   // 이 함수를 넣어준 이유는 혹시 leagueRx가 들어오기 전에 RankController가
    //   // 실행되면 rank가 비어있을 것이므로. (혹은 리그가 변하는 시점도 마찬가지)
    //   // 이 아래에 onInit 아래 부분을 복제
    //   allRanker = await _firestoreService.getAllTopRanker(maxNumAllRanker);
    //   myRanksAndPoint = await _firestoreService.getMyRanks();
    // });

    allRanker = await _firestoreService.getAllTopRanker(maxNumAllRanker);
    myRanksAndPoint = await _firestoreService.getMyRanks();

    isMyRanksAndPointLoaded = true;

    print(allRanker[0].length);

    update(['ranks']);

    super.onInit();
  }

  Future<List<Map<String, int>>> getOtherUserRanks(String uid) async {
    return await _firestoreService.getOtherRanks(uid);
  }

  // Future<String> getImageUrlFromStorage(String imageUrl) async {
  //   return await _firebaseStorageService.downloadImageURL(imageUrl);
  // }

  void test() async {
    await _firestoreService.addRank();
  }
}
