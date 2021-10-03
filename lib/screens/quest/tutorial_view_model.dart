import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TutorialViewModel extends GetxController {
  RxBool isSelectingSheetShowing = false.obs;
  RxList<bool> toggleList = <bool>[false, false].obs;

  // selectMode에 따라 토글/다수선택/순위선정 함수가 필요
  toggleUserSelect(int index) {
    for (int i = 0; i < toggleList.length; i++) {
      toggleList[i] = false;
    }
    toggleList[index] = true;
  }
}
