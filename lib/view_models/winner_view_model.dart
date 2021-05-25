import 'dart:async';

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
  final dynamic oldSeasonInfo;

  @override
  Future futureToRun() => getUserAndRankList();
  final AuthService? _authService = locator<AuthService>();
  final DatabaseService? _databaseService = locator<DatabaseService>();
  final NavigationService? _navigationService = locator<NavigationService>();
  final StateManageService? _stateManageService = locator<StateManageService>();
  final AmplitudeService _amplitudeService = AmplitudeService();

  // 변수 Setting
  // 아래에 stateManagerService에 있는 놈들 중 사용할 모델들 설정
  DatabaseAddressModel? lastSeasonAddressModel;
  PortfolioModel? portfolioModel;
  PortfolioModel? newPortfolioModel;
  SeasonModel? seasonModel;
  SeasonModel? newSeasonModel;
  late UserModel userModel;
  // 여기는 이 화면 고유의 모델 설정
  List<RankModel>? rankModel = [];
  List<RankModel> winners = [];

  String? uid;
  int? myRank = 0;
  int? myWinPoint = 0;
  String? myRankChange;
  String? myRankChangeSymbol;
  List<String> rankChange = [];
  List<String> rankChangeSymbol = [];

  Map<String, String>? specialAwardsMap;
  List<String> specialAwards = [];
  List<String> specialAwardsUserName = [];

  WinnerViewModel(this.oldSeasonInfo) {
    uid = _authService!.auth.currentUser!.uid;
    print("OLDSEASON " + oldSeasonInfo.toString());
  }

  Future getUserAndRankList() async {
    // if (_stateManageService.appStart) {
    //   await _stateManageService.initStateManage(initUid: uid);
    // } else {
    //   if (await _stateManageService.isNeededUpdate())
    //     await _stateManageService.initStateManage(initUid: uid);
    // }

    // 지난 시즌 어드레스 모델과 그에 맞는 모델들을 새로 불러와야 함
    oldSeasonInfo == null
        ? lastSeasonAddressModel =
            await _databaseService!.getOldSeasonAddress(uid)
        : lastSeasonAddressModel = DatabaseAddressModel(
            uid: uid,
            category: oldSeasonInfo[0],
            season: oldSeasonInfo[1],
            date: oldSeasonInfo[2],
            isVoting: true, //false면 장 중
          );

    portfolioModel =
        await _databaseService!.getPortfolio(lastSeasonAddressModel!);
    seasonModel =
        await _databaseService!.getSeasonInfo(lastSeasonAddressModel!);
    userModel = await (_databaseService!.getUser(uid) as FutureOr<UserModel>);
    rankModel =
        await _databaseService!.getOldSeasonRankList(lastSeasonAddressModel!);

    // 처음에 로딩 했으므로 state 매니지에 있는 모델들은 새 시즌 모델
    newPortfolioModel = _stateManageService!.portfolioModel;
    newSeasonModel = _stateManageService!.seasonModel;
    // 순위변동 구해주자.
    for (int i = 0; i < rankModel!.length; i++) {
      // - 10 없애야 함
      if (rankModel![i].currentWinPoint! >= seasonModel!.winningPoint!) {
        winners.add(rankModel![i]);
      }
      if (rankModel![i].prevRank != null) {
        int tempRankChange = rankModel![i].prevRank! - rankModel![i].todayRank!;
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
    for (int i = 0; i < rankModel!.length; i++) {
      if (rankModel![i].uid == uid) {
        myRank = rankModel![i].todayRank;
        myRankChangeSymbol = rankChangeSymbol[i];
        myRankChange = rankChange[i];

        myWinPoint = rankModel![i].currentWinPoint;

        print("MY RANK" + myRank.toString());
      }
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getSpecialAwardsMap(
      lastSeasonAddressModel) async {
    specialAwardsMap =
        await (_databaseService!.getSpecialAwards(lastSeasonAddressModel)
            as FutureOr<Map<String, String>?>);
    print(specialAwardsMap);
    return specialAwardsMap;
  }

  Future<String?> getSpecialAwardsDescription(lastSeasonAddressModel) async {
    String? description = await (_databaseService!
            .getSpecialAwardsDescription(lastSeasonAddressModel)
        as FutureOr<String?>);
    // print(specialAwardsMap);
    return description;
  }

  String getLastSeasonPortfolioValue() {
    int totalValue = 0;

    for (int i = 0; i < portfolioModel!.subPortfolio!.length; i++) {
      totalValue += portfolioModel!.subPortfolio![i].sharesNum! *
          portfolioModel!.subPortfolio![i].currentPrice!;
    }
    // int totalValue = 100000;

    var f = NumberFormat("#,###", "en_US");

    return f.format(totalValue);
  }

  // 전일종가 기준 포트폴리오 총 가치를 계산하여 ###,###,### 형태로 반환
  String getPortfolioValue() {
    int totalValue = 0;

    for (int i = 0; i < newPortfolioModel!.subPortfolio!.length; i++) {
      totalValue += newPortfolioModel!.subPortfolio![i].sharesNum! *
          newPortfolioModel!.subPortfolio![i].currentPrice!;
    }
    // int totalValue = 100000;

    var f = NumberFormat("#,###", "en_US");

    return f.format(totalValue);
  }

  // 시즌 몇 명 참여중인지 ###,###,### 형태로 변환하여 리턴해주는
  String getUsersNum() {
    var f = NumberFormat("#,###", "en_US");

    return f.format(rankModel!.length);
  }

  // 랭킹숫자 등 ###,###,### 형태로 반환
  String returnDigitFormat(int? value) {
    var f = NumberFormat("#,###", "en_US");

    return f.format(value);
  }

  String getDateFormChange(String date) {
    return date.substring(0, 4) +
        '.' +
        date.substring(4, 6) +
        '.' +
        date.substring(6, 8);
  }
}
