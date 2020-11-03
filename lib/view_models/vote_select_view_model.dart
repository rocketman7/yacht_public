import 'dart:async';

import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/portfolio_model.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';

import '../services/stateManage_service.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../services/sharedPreferences_service.dart';
import '../models/sharedPreferences_const.dart';

class VoteSelectViewModel extends FutureViewModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>(); //
  final StateManageService _stateManageService = locator<StateManageService>();
  //Code:

  String uid;
  UserModel user;
  DatabaseAddressModel address;
  VoteModel vote;
  UserVoteModel userVote;
  SeasonModel seasonInfo;
  List<SubVote> subVote;
  PortfolioModel portfolioModel;
  Timer _everySecond;

  List<String> timeLeftArr = ["", "", ""];

  Timer get everySecond => _everySecond;

  bool voteSelectTutorial;
  int tutorialStatus = 2; // 튜토리얼 내 단계만큼.. (나중에 쉐어드 프리퍼런스로 해야할 듯)
  int tutorialTotalStep = 2; // 튜토리얼 총 단계

  bool isVoting = true;
  DateTime getNow() {
    return DateTime.now();
  }

  String getPortfolioValue() {
    int totalValue = 0;

    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      totalValue += portfolioModel.subPortfolio[i].sharesNum *
          portfolioModel.subPortfolio[i].currentPrice;
    }

    var f = NumberFormat("#,###", "en_US");

    return f.format(totalValue);
  }

  VoteSelectViewModel() {
    // _authService.signOut();

    uid = _authService.auth.currentUser.uid;
    print("UID " + uid);
    // _now = getNow();
    // getUser();
  }

  // Future startStateManager() async {
  //   //stateManager 시작
  //   await _stateManagerService.initStateManager();
  // }

  Future getAllModel(uid) async {
    // _authService.auth.signOut();
    setBusy(true);
    print("getallModel uid" + uid);
    //앱이 최초로 시작하면 여기서 startStateManager를 실행해주고,
    //아니면 다른 화면과 마찬가지로 stateManager 하 지배를 받음.
    if (_stateManageService.appStart) {
      await _stateManageService.initStateManage(initUid: uid);
    } else {
      if (await _stateManageService.isNeededUpdate())
        await _stateManageService.initStateManage(initUid: uid);
    }

    address = _stateManageService.addressModel;
    user = _stateManageService.userModel;
    vote = _stateManageService.voteModel;
    userVote = _stateManageService.userVoteModel;
    portfolioModel = _stateManageService.portfolioModel;
    seasonInfo = _stateManageService.seasonModel;
    // address = await _databaseService.getAddress(uid);
    // user = await _databaseService.getUser(uid);
    // vote = await _databaseService.getVotes(address);
    // userVote = await _databaseService.getUserVote(address);
    // portfolioModel = await _databaseService.getPortfolio(address);
    // seasonInfo = await _databaseService.getSeasonInfo(address);

    voteSelectTutorial = await _sharedPreferencesService
        .getSharedPreferencesValue(voteSelectTutorialKey, bool);
    print("ISVOTING????? " + address.isVoting.toString());

    setBusy(false);
    notifyListeners();
  }

  Future signOut() async {
    await _authService.signOut();
  }

  // 튜토리얼이 한 단계 진행되었을 때
  void tutorialStepProgress() {
    tutorialStatus--;

    if (tutorialStatus == 0) {
      _sharedPreferencesService.setSharedPreferencesValue(
          voteSelectTutorialKey, true);
    }

    notifyListeners();
  }

  // void isVoteAvailable() {
  //   isVoting = false;

  //   // notifyListeners();
  // }

  Stream<PriceModel> getRealtimePrice(
    DatabaseAddressModel address,
    String issueCode,
  ) {
    print("Price Stream returns");
    return _databaseService.getRealtimeReturn(address, issueCode);
  }

  // Stream<List<PriceModel>> getMultiRealtimePrice(
  //   DatabaseAddressModel address,
  //   List<String> issueCode,
  // ) {
  //   print("Price Stream returns");
  //   Stream<List<PriceModel>> = Stream.multi((stream) {
  //     stream.onListen();
  //    })

  //    [ _databaseService.getRealtimeReturn(address, issueCode[0]),
  //     _databaseService.getRealtimeReturn(address, issueCode[1]),];
  //   return

  //   ;
  // }

  // 앱이 처음시작되어 모든 모델들을 불러오기 전에 페이지에 진입하면 로딩뷰를 보여주고, 아니면 로딩뷰를 없앤다.
  bool isFirstLoading() {
    return _stateManageService.appStart;
  }

  @override
  Future futureToRun() => getAllModel(uid);
  // throw UnimplementedError();
}
