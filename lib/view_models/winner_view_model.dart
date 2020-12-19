import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/portfolio_model.dart';
import 'package:yachtOne/models/rank_model.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/services/amplitude_service.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/services/stateManage_service.dart';
import 'package:yachtOne/views/constants/holiday.dart';

import '../locator.dart';

class WinnerViewModel extends FutureViewModel {
  @override
  Future futureToRun() => getUserAndRankList();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final StateManageService _stateManageService = locator<StateManageService>();
  final AmplitudeService _amplitudeService = AmplitudeService();

  // 변수 Setting
  // 아래에 stateManagerService에 있는 놈들 중 사용할 모델들 설정
  DatabaseAddressModel addressModel;
  PortfolioModel portfolioModel;
  SeasonModel seasonModel;
  UserModel userModel;
  // 여기는 이 화면 고유의 모델 설정
  List<RankModel> rankModel = [];
  List<RankModel> winners = [];

  String uid;
  int myRank = 0;
  int myWinPoint = 0;
  String myRankChange;
  String myRankChangeSymbol;
  List<String> rankChange = [];
  List<String> rankChangeSymbol = [];

  Future getUserAndRankList() async {
    await _amplitudeService.logRankingView(uid);
    if (_stateManageService.appStart) {
      await _stateManageService.initStateManage(initUid: uid);
    } else {
      if (await _stateManageService.isNeededUpdate())
        await _stateManageService.initStateManage(initUid: uid);
    }

    addressModel = _stateManageService.addressModel;
    portfolioModel = _stateManageService.portfolioModel;
    seasonModel = _stateManageService.seasonModel;
    userModel = _stateManageService.userModel;
    rankModel = _stateManageService.rankModel;

    // 순위변동 구해주자.
    for (int i = 0; i < rankModel.length; i++) {
      // - 10 없애야 함
      if (rankModel[i].currentWinPoint >= seasonModel.winningPoint - 6) {
        winners.add(rankModel[i]);
      }
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
    notifyListeners();
  }

  // 전일종가 기준 포트폴리오 총 가치를 계산하여 ###,###,### 형태로 반환
  String getPortfolioValue() {
    int totalValue = 0;

    for (int i = 0;
        i < _stateManageService.portfolioModel.subPortfolio.length;
        i++) {
      totalValue +=
          _stateManageService.portfolioModel.subPortfolio[i].sharesNum *
              _stateManageService.portfolioModel.subPortfolio[i].currentPrice;
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

  String getDateFormChange() {
    DateTime previousdate = strToDate(_stateManageService.addressModel.date);

    previousdate = previousBusinessDay(previousdate);
    String previousdateStr = stringDate.format(previousdate);

    return previousdateStr.substring(0, 4) +
        '.' +
        previousdateStr.substring(4, 6) +
        '.' +
        previousdateStr.substring(6, 8);
  }
}
