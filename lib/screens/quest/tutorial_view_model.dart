import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../locator.dart';

class TutorialViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  RxBool isSelectingSheetShowing = false.obs;
  RxList<bool> toggleList = <bool>[false, false].obs;

  // selectMode에 따라 토글/다수선택/순위선정 함수가 필요
  toggleUserSelect(int index) {
    for (int i = 0; i < toggleList.length; i++) {
      toggleList[i] = false;
    }
    toggleList[index] = true;
  }

  Future<void> endOfTutorial(QuestModel questModel) async {
    // 여기에 튜토리얼이 끝나면 실행시킬 (예를 들어 DB에 유저보트에 넣어주기, 보상주기 등) 코드 입력
    await _firestoreService.updateUserAlltimeQuest(questModel);

    await _firestoreService.updateQuestParticipationReward(questModel);

    // await Get.find<HomeViewModel>().getAllQuests();
    print('end of tutorial');
  }
}
