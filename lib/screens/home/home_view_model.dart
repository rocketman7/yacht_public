import 'package:get/get_state_manager/get_state_manager.dart';

class HomeViewModel extends GetxController {
  late String globalString;
  @override
  void onInit() {
    // TODO: implement onInit
    getTodayData();
    super.onInit();
  }

  // 이런 방식으로 처음 메뉴 들어왔을 때 필요한 데이터들을 받아서 global로 저장해놓고
  // 데이터가 있으면 로컬을, 없으면 서버에서 가져오는 방식
  // 기존에 Statemanagement와 비슷
  Future getTodayData() async {
    Future.delayed(Duration(seconds: 3)).then((value) {
      print("3 secs passed");
      globalString = "All data Fetchd";
    });
  }
}
