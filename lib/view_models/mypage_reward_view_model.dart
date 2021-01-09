import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../models/user_model.dart';
import '../models/user_reward_model.dart';

import '../locator.dart';

class MypageRewardViewModel extends FutureViewModel {
  ///se
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final NavigationService _navigationService = locator<NavigationService>();

  ///va
  String uid;
  UserModel userModel;
  List<UserRewardModel> userRewardModels = [];

  int userRewardBeforeDeliveryCnt = 0;
  int userRewardAfterDeliveryCnt = 0;

  ///ui va
  bool initTab = true;

  // 주민등록번호 체크 주소
  String checkNameUrl;

  ///me
  MypageRewardViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Stream<String> getNameCheckResult(uid) {
    var result = _databaseService.getNameCheckResult(uid);
    return result;
  }

  // for futureToRun
  Future getModels() async {
    userModel = await _databaseService.getUser(uid);
    userRewardModels = await _databaseService.getUserRewardList(uid);

    for (UserRewardModel userRewardModel in userRewardModels) {
      // print(userRewardModel.listOfAward[0].stockName);
      if (userRewardModel.deliveryStatus == 1 ||
          userRewardModel.deliveryStatus == 0) {
        userRewardBeforeDeliveryCnt++;
      } else if (userRewardModel.deliveryStatus == -1) {
        userRewardAfterDeliveryCnt++;
      }
    }

    checkNameUrl = await _databaseService.checkNameUrl();
  }

  // 보유 중인 주식 / 출고 완료한 주식 간 탭 전환할 때
  void moveTab() {
    initTab = !initTab;

    notifyListeners();
  }

  // 날짜를 xxxx.xx.xx 형식으로 변환
  String dateFormChange(String date) => (date.substring(0, 4) +
      '.' +
      date.substring(4, 6) +
      '.' +
      date.substring(6, 8));

  // 금액을 xxx,xxx 형식 + String으로 변환
  String priceFormChange(double num) {
    var f = NumberFormat("#,###", "en_US");

    return f.format(num);
  }

  // 해당 index의 가치를 계산 (이미 출고한 주식 case. 즉, priceAtAward가 출고 시 가격으로 바뀌어 있는 상태일 것)
  double calcTotalValue(int index) {
    double totalValue = 0;

    for (RewardModel rewardModel in userRewardModels[index].listOfAward) {
      totalValue += rewardModel.priceAtAward * rewardModel.sharesNum;
    }

    return totalValue;
  }

  // 해당 index의 가치를 계산 (출고 전 주식을 위한 case)
  double calcTotalValueForHistPrice(int index, List<double> histPrices) {
    double totalValue = 0;

    for (int i = 0; i < userRewardModels[index].listOfAward.length; i++) {
      totalValue +=
          histPrices[i] * userRewardModels[index].listOfAward[i].sharesNum;
    }

    return totalValue;
  }

  // 해당 index의 가장 최근 historical price를 불러온다.
  Future<double> getHistoricalPrice(int indexI, int indexJ) async {
    double price = await _databaseService.getHistoricalPriceForUserReward(
        userRewardModels[indexI].listOfAward[indexJ].issueCode);

    return price;
  }

  // 해당 index의 가장 최근 historical price들을 불러온다. (출고 전 주식을 위한 case)
  Future<List<double>> getHistoricalPrices(int index) async {
    List<double> histPriceTemp = [];

    for (int i = 0; i < userRewardModels[index].listOfAward.length; i++) {
      histPriceTemp.add(await _databaseService.getHistoricalPriceForUserReward(
          userRewardModels[index].listOfAward[i].issueCode));
    }

    return histPriceTemp;
  }

  // 해당 index의 가치가 받았을 때 대비 올랐는지, 안올랐는지 판단해주는 (출고 전 주식을 위한 case)
  bool judgeUporDown(double currentPrice, int indexI, int indexJ) {
    // 헷갈릴 수 있지만 currentPrice또한 뷰의 퓨처빌더에서 불러온 indexI, indexJ의 히스토리컬 프라이스(최신)임.
    return (currentPrice >=
        userRewardModels[indexI].listOfAward[indexJ].priceAtAward);
  }

  // 해당 index의 가치 변화를 +-xx.xx%형태로 (출고 전 주식을 위한 case)
  String calcReturn(double currentPrice, int indexI, int indexJ) {
    var f = NumberFormat("##.##%", "en_US");

    return f.format((currentPrice /
            userRewardModels[indexI].listOfAward[indexJ].priceAtAward) -
        1);
  }

  //
  Future<void> navigateToAccountVerifView() async {
    await _navigationService.navigateTo('mypage_accoutverification');
    // // 이렇게 페이지 넘어가는 부분에서 await 걸어주고 후에 후속조치 취해주면 하위페이지에서 변동된 데이터를 적용할 수 있음
    await getModels();
    notifyListeners();
    // _navigationService.navigateTo('mypage_accoutverification');
  }

  // dialog에 출고 주식 표시해주기 위한
  String deliveryStocksForDialog(int index) {
    String temp = '';

    for (int i = 0; i < userRewardModels[index].listOfAward.length; i++) {
      temp = temp +
          '${userRewardModels[index].listOfAward[i].stockName}: ${userRewardModels[index].listOfAward[i].sharesNum}주\n';
    }

    return temp;
  }

  // 출고하기버튼을 눌렀을 떄
  Future<void> actDelivery(int index) async {
    await _databaseService.updateUserRewardDeliveryStatus(
        uid, userRewardModels[index].id, 0);
    await getModels();

    notifyListeners();

    // 원천징수해야하는지 여부에 따라,, 다음 안내를?
    print('원천징수 여부: ' + userRewardModels[index].isTax.toString());

    // 출고신청한 것 우리가 알 수 있게끔 여기에 조치를 취해놓으면 좋을 듯
  }

  @override
  Future futureToRun() => getModels();
}
