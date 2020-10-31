import 'dart:async';

import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/portfolio_model.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';

import '../services/stateManager_service.dart';
import '../services/stateManager_service.dart' as global;

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
  final StateManagerServiceService _stateManagerService =
      locator<StateManagerServiceService>();
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

  Future startStateManager() async {
    //stateManager 시작
    await _stateManagerService.initStateManager();
  }

  Future getAllModel(uid) async {
    setBusy(true);

    //앱이 최초로 시작하면 여기서 startStateManager를 실행해주고,
    //아니면 다른 화면과 마찬가지로 stateManager 하 지배를 받음.
    // if (global.appStart) {
    //   await startStateManager();

    // address = global.localAddressModel;
    // user = global.localUserModel;
    // vote = global.localVoteModel;
    // userVote = global.localUserVoteModel;
    // portfolioModel = global.localPortfolioModel;
    // seasonInfo = global.localSeasonModel;
    // } else {
    //   //=======================stateManagerService이용하여 뷰모델 시작=======================
    //   String myState = _stateManagerService.calcState();

    //   if (_stateManagerService.hasLocalStateChange(myState)) {
    //     if (await _stateManagerService.hasDBStateChange(myState)) {
    //       // update needed. local & db 모두 변했기 때문
    //       // 아래처럼 stateManagerService에서 각 모델들을 모두 리로드해주고, 그걸 뷰모델 내 모델변수에 재입력해준다.
    //       await _stateManagerService.initStateManager();
    //     }
    //   }
    //   address = global.localAddressModel;
    //   user = global.localUserModel;
    //   vote = global.localVoteModel;
    //   userVote = global.localUserVoteModel;
    //   portfolioModel = global.localPortfolioModel;
    //   seasonInfo = global.localSeasonModel;
    //   //=======================stateManagerService이용하여 뷰모델 시작=======================

    // }

    address = await _databaseService.getAddress(uid);
    user = await _databaseService.getUser(uid);
    vote = await _databaseService.getVotes(address);
    userVote = await _databaseService.getUserVote(address);
    portfolioModel = await _databaseService.getPortfolio(address);
    seasonInfo = await _databaseService.getSeasonInfo(address);

    voteSelectTutorial = await _sharedPreferencesService
        .getSharedPreferencesValue(voteSelectTutorialKey, bool);
    print("ISVOTING????? " + address.isVoting.toString());

    // String myState = _stateManagerService.calcState();

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

  @override
  Future futureToRun() => getAllModel(uid);
  // throw UnimplementedError();
}
