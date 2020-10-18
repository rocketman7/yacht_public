import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import '../services/stateManager_service.dart';
import '../services/stateManager_service.dart' as global;

import '../locator.dart';
import '../models/user_model.dart';
import '../models/rank_model.dart';
import '../models/season_model.dart';
// import '../models/portfolio_model.dart';
import '../models/database_address_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../views/constants/holiday.dart';

class RankViewModel extends FutureViewModel {
  // Services Setting
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final StateManagerServiceService _stateManagerServiceService =
      locator<StateManagerServiceService>();

  // 변수 Setting
  // DatabaseAddressModel addressModel;
  SeasonModel seasonModel;
  // PortfolioModel
  //     portfolioModel; //상금 현재가치 불러올려고 굳이 접근해야하는건데 이런건 처음 앱 실행시 한번에 불러오고 저장해두면 안되나?
  List<RankModel> rankModel = [];
  UserModel user;
  String uid;
  int myRank = 0;
  int myWinPoint = 0;
  String myRankChange;
  String myRankChangeSymbol;
  List<String> rankChange = [];
  List<String> rankChangeSymbol = [];

  RankViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  // method
  // futureToRun으로 호출하는.
  Future getUserAndRankList() async {
    // 사실은 첫화면인 startup?homeview에 있어야하지만 test를 위해. 즉 어플을 처음 켤 때 mystate가 결정된다.
    _stateManagerServiceService.initStateManager();

    // 그럼과 동시에 stateManager 에서 관리할 local 모델들을 모두 업데이트해줘야함 <= initState 에 같이 넣자
    // _stateManagerServiceService.reloadAddressModel();
    global.localAddressModel = await _databaseService.getAddress(uid);
    global.localPortfolioModel =
        await _databaseService.getPortfolio(global.localAddressModel);
    global.localSeasonModel =
        await _databaseService.getSeasonInfo(global.localAddressModel);
    user = await _databaseService.getUser(uid);
    seasonModel = global.localSeasonModel;
    rankModel = await _databaseService.getRankList(global.localAddressModel);

    // 순위변동 구해주자.
    for (int i = 0; i < rankModel.length; i++) {
      if (rankModel[i].prevRank != null) {
        int tempRankChange = rankModel[i].prevRank - rankModel[i].todayRank;
        rankChange.add(tempRankChange.toString());

        if (tempRankChange > 0)
          rankChangeSymbol.add('+');
        else if (tempRankChange < 0)
          rankChangeSymbol.add('-');
        else
          rankChangeSymbol.add('0');
      } else {
        rankChange.add('NEW');

        rankChangeSymbol.add('*');
      }
    }

    // 나의 현재순위 구해주자
    for (int i = 0; i < rankModel.length; i++) {
      if (rankModel[i].uid == uid) {
        myRank = rankModel[i].todayRank;
        myRankChangeSymbol = rankChangeSymbol[i];
        myRankChange = rankChange[i];

        myWinPoint = rankModel[i].currentWinPoint;
      }
    }

    notifyListeners();
  }

  // 어드레스모델이 가리키는 전 날짜를 가져와서 xxxx.xx.xx 형식으로 변환
  String getDateFormChange() {
    DateTime previousdate = strToDate(global.localAddressModel.date);

    previousdate = previousBusinessDay(previousdate);
    String previousdateStr = stringDate.format(previousdate);

    return previousdateStr.substring(0, 4) +
        '.' +
        previousdateStr.substring(4, 6) +
        '.' +
        previousdateStr.substring(6, 8);
  }

  // 전일종가 기준 포트폴리오 총 가치를 계산하여 ###,###,### 형태로 반환
  String getPortfolioValue() {
    int totalValue = 0;

    for (int i = 0; i < global.localPortfolioModel.subPortfolio.length; i++) {
      totalValue += global.localPortfolioModel.subPortfolio[i].sharesNum *
          global.localPortfolioModel.subPortfolio[i].currentPrice;
    }
    // int totalValue = 100000;

    var f = NumberFormat("#,###", "en_US");

    return f.format(totalValue);
  }

  // 시즌 몇 명 참여중인지 ###,###,### 형태로 변환하여 리턴해주는
  String getUsersNum() {
    var f = NumberFormat("#,###", "en_US");

    return f.format(rankModel.length);
  }

  // 랭킹숫자 등 ###,###,### 형태로 반환
  String returnDigitFormat(int value) {
    var f = NumberFormat("#,###", "en_US");

    return f.format(value);
  }

  // 포트폴리오화면으로 가는 버튼~
  void navigateToPortfolioPage() {
    _navigationService.navigateTo('portfolio');
  }

  Future<void> addRank() {
    _databaseService.addRank();

    notifyListeners();

    return null;
  }

  @override
  Future futureToRun() => getUserAndRankList();
}
