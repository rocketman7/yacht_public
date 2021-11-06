import 'package:get/get.dart';

import '../../models/last_subLeague_model.dart';

import '../../services/firestore_service.dart';

List<String> leagueCategory = [
  '전체',
];

const List<String> orderByCategory = [
  '상금 높은 순',
  '상금 낮은 순',
];

class LastAwardViewModel extends GetxController {
  FirestoreService _firestoreService = FirestoreService();

  List<LastSubLeagueModel> allLastSubLeagues = [];
  List<LastSubLeagueModel> orderLastSubLeagues = [];
  // List<double> totalValue = [];

  bool isAllLastSubLeaguesLoaded = false;

  RxBool isLeagueCategorySelect = false.obs;
  RxInt selectedLeagueCategoryIndex = 0.obs;
  RxBool isOrderByCategorySelect = false.obs;
  RxInt selectedOrderByCategoryIndex = 0.obs;

  @override
  void onInit() async {
    allLastSubLeagues = await _firestoreService.getAllLastSubLeague();

    // 각 토탈 상금 계산.
    for (int i = 0; i < allLastSubLeagues.length; i++) {
      // totalValue.add(0.0);
      allLastSubLeagues[i].totalValue = 0.0;
      for (int j = 0; j < allLastSubLeagues[i].stocks.length; j++) {
        // totalValue[i] += allLastSubLeagues[i].stocks[j].sharesNum *
        //     allLastSubLeagues[i].stocks[j].standardPrice;
        allLastSubLeagues[i].totalValue = allLastSubLeagues[i].totalValue! +
            allLastSubLeagues[i].stocks[j].sharesNum *
                allLastSubLeagues[i].stocks[j].standardPrice;
      }
    }

    // orderLastSubLeagues = allLastSubLeagues;
    for (int i = 0; i < allLastSubLeagues.length; i++) {
      orderLastSubLeagues.add(allLastSubLeagues[i]);
    }

    orderMethod(0, 0);

    isAllLastSubLeaguesLoaded = true;

    update();

    // 이 부분 바로 바꿔야함. 지금은 테스트용.
    leagueCategory.add('2021년 11월');
    leagueCategory.add('2021년 10월');
    update(['leagueCategory']);
    update();

    super.onInit();
  }

  void leagueCategorySelectMethod() {
    isLeagueCategorySelect(!isLeagueCategorySelect.value);
    if (isOrderByCategorySelect.value) {
      isOrderByCategorySelect(false);
    }
  }

  void leagueCategoryIndexSelectMethod(int index) {
    selectedLeagueCategoryIndex(index);
  }

  void orderByCategorySelectMethod() {
    isOrderByCategorySelect(!isOrderByCategorySelect.value);
    if (isLeagueCategorySelect.value) {
      isLeagueCategorySelect(false);
    }
  }

  void orderByCategoryIndexSelectMethod(int index) {
    selectedOrderByCategoryIndex(index);
  }

  void orderMethod(int leagueIndex, int orderByIndex) {
    orderLastSubLeagues.clear();
    if (leagueCategory[leagueIndex] == '전체') {
      for (int i = 0; i < allLastSubLeagues.length; i++) {
        orderLastSubLeagues.add(allLastSubLeagues[i]);
      }
    } else {
      for (int i = 0; i < allLastSubLeagues.length; i++) {
        if (leagueCategory[leagueIndex] == allLastSubLeagues[i].leagueName) {
          orderLastSubLeagues.add(allLastSubLeagues[i]);
        }
      }
    }

    if (orderByCategory[orderByIndex] == '상금 높은 순') {
      orderLastSubLeagues.sort((a, b) {
        return b.totalValue!.compareTo(a.totalValue!);
      });
    } else if (orderByCategory[orderByIndex] == '상금 낮은 순') {
      orderLastSubLeagues.sort((a, b) {
        return a.totalValue!.compareTo(b.totalValue!);
      });
    }

    update();
  }
}
