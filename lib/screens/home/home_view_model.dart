import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/dictionary_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/repositories/quest_repository.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';

import '../../locator.dart';

class HomeViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authService = locator<AuthService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  QuestRepository _questRepository = QuestRepository();
  QuestModel? tempQuestModel;
  // 시즌 내에 모든 퀘스트 받아서 RxList에 저장
  final allQuests = <QuestModel>[].obs;

  final newQuests = <QuestModel>[].obs;
  final liveQuests = <QuestModel>[].obs;
  final resultQuests = <QuestModel>[].obs;

  final dictionaries = <DictionaryModel>[].obs;

  late final String uid;
  Rxn<UserModel> userModel = Rxn<UserModel>();

  late String globalString;
  bool isLoading = true;
  RxBool isQuestDataLoading = true.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    // await getTodayData();
    await getAllQuests();
    await getDictionaries();
    // await getUser();
    isLoading = false;
    super.onInit();
  }

  Future getDictionaries() async {
    dictionaries(await _firestoreService.getDictionaries());
  }

  Future<String> getImageUrlFromStorage(String imageUrl) async {
    return await _firebaseStorageService.downloadImageURL(imageUrl);
  }
  // Future getUser() async {
  //   uid = _authService.auth.currentUser!.uid;
  //   // Future.delayed(Duration(seconds: 10)).then((value) async {
  //   userModel(await _firestoreService.getUserModel(uid));
  //   // });
  // }

  // 이런 방식으로 처음 메뉴 들어왔을 때 필요한 데이터들을 받아서 global로 저장해놓고
  // 데이터가 있으면 로컬을, 없으면 서버에서 가져오는 방식
  // 기존에 Statemanagement와 비슷
  Future getTodayData() async {
    Future.delayed(Duration(seconds: 3)).then((value) {
      print("3 secs passed");
      globalString = "All data Fetched";
    });
  }

  Future getTodayAwards() async {}

  Future getAllQuests() async {
    allQuests.assignAll(await _questRepository.getQuestForHomeView());
    // 분리작업
    DateTime now = DateTime.now();
    allQuests.forEach((element) {
      if (element.showHomeDateTime.toDate().isBefore(now) && element.liveStartDateTime.toDate().isAfter(now)) {
        newQuests.add(element);
      } else if (element.liveStartDateTime.toDate().isBefore(now) && element.liveEndDateTime.toDate().isAfter(now)) {
        liveQuests.add(element);
      } else if (element.resultDateTime.toDate().isBefore(now) && element.closeHomeDateTime.toDate().isAfter(now)) {
        resultQuests.add(element);
      } else {
        print("포함 안 된 quest: $element");
      }
    });
  }
}
