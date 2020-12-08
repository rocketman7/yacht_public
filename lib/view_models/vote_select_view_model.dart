import 'dart:async';

import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/portfolio_model.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/services/amplitude_service.dart';
import 'package:yachtOne/views/nicknameSet_view.dart';

import '../services/api/firebase_kakao_auth_api.dart';
import '../services/stateManage_service.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../services/sharedPreferences_service.dart';
import '../models/sharedPreferences_const.dart';

import '../views/mypage_main_view.dart';

import '../services/adManager_service.dart';
import 'package:firebase_admob/firebase_admob.dart';

class VoteSelectViewModel extends FutureViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>(); //
  final StateManageService _stateManageService = locator<StateManageService>();
  final AmplitudeService _amplitudeService = AmplitudeService();

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

  bool isNameUpdated;
  bool voteSelectTutorial;
  bool termsOfUse;
  int tutorialStatus = 3; // 튜토리얼 내 단계만큼.. (나중에 쉐어드 프리퍼런스로 해야할 듯)
  int tutorialTotalStep = 3; // 튜토리얼 총 단계

  // 리워드 광고 관련 변수
  // bool rewardedAdsLoaded = false;

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

    // 리워드광고 로직을 구현해야 하는 부분.
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.rewarded) {
        //유저가 reward받을 수 있는 조건을 충족하면,
        //아이템을 한 개 늘려주고,
        user.item += 1;
        _databaseService.updateUserItem(uid, user.item);
        //stateManage 업데이트
        _stateManageService.userModelUpdate();

        notifyListeners();
        // print(rewardAmount);
        print('reward ads: rewarded');
      } else if (event == RewardedVideoAdEvent.closed) {
        // 리워드 광고가 닫히면, 새로운 리워드 광고를 로드해줘야함
        rewardedAdsLoaded = false;
        print(rewardedAdsLoaded);
        loadRewardedAds();

        notifyListeners();
        print('reward ads: closed');
      } else if (event == RewardedVideoAdEvent.loaded) {
        // 로딩이 다 되면 로딩됏다고.
        rewardedAdsLoaded = true;

        notifyListeners();
        print('reward ads: loaded');
      } else if (event == RewardedVideoAdEvent.failedToLoad) {
        // 로딩에 실패하면..
        print(RewardedVideoAdEvent.failedToLoad.toString());
        rewardedAdsLoaded = false;
        // 다시 로딩 시도
        // loadRewardedAds();
        // x: 이러면 실패시 너무 많은 로딩 요청을 할 수 있음

        notifyListeners();
        print('reward ads: failedToLoad');
      }
      // else if (event == RewardedVideoAdEvent.completed) {
      //   print('reward ads: completed');
      // } else if (event == RewardedVideoAdEvent.started) {
      //   print('reward ads: started');
      // } else if (event == RewardedVideoAdEvent.opened) {
      //   print('reward ads: opened');
      // } else if (event == RewardedVideoAdEvent.leftApplication) {
      //   print('reward ads: leftApplication');
      // }
    };

    // 여튼 페이지 처음 들어오면 RV광고 로딩 함 해준다.
    loadRewardedAds();
  }

  // 리워드광고 관련 메쏘드
  loadRewardedAds() {
    print('reward ads: start to load');
    RewardedVideoAd.instance.load(
      targetingInfo: MobileAdTargetingInfo(),
      adUnitId: AdManager.rewardedAdUnitId,
    );
  }

  showRewardedAds() {
    RewardedVideoAd.instance.show();
  }

  // Future startStateManager() async {
  //   //stateManager 시작
  //   await _stateManagerService.initStateManager();
  // }
  List<bool> selected;

  void selectUpdate(int idx, bool value) {
    selected[idx] = value;
    notifyListeners();
  }

  Future getDefaultText() async {
    return _databaseService.getDefaultText();
  }

  Future getAllModel(uid) async {
    // signOut();
    // var key = await _sharedPreferencesService.getSharedPreferencesValue(
    //     isNameUpdatedKey, String);
    // print("KEY" + key.toString());

    // _authService.auth.signOut();
    setBusy(true);
    // Amplitude에 voteViewModel log 보내기
    await _amplitudeService.logVoteSelectView(uid);

    print("getallModel uid" + uid);

    // isNameUpdated = await _sharedPreferencesService.getSharedPreferencesValue(
    //     isNameUpdatedKey, bool);
    // if (!isNameUpdated) {
    //   print('뉴비일 가능성이 큽니다. DB만 더 확인하고 다른 페이지로');
    //   UserModel tempUser = await _databaseService.getUser(uid);
    //   if (!tempUser.isNameUpdated) {
    //     print('뉴비확실');
    //     // return NicknameSetView();
    //     _navigationService.navigateWithArgTo('nickname_set', true);
    //   } else {
    //     //뉴비인줄 알았는데 막상 DB보니까 아니니까 쉐어드프리퍼런스 true로 바꿔줘야함.
    //     _sharedPreferencesService.setSharedPreferencesValue(
    //         isNameUpdatedKey, true);
    //     print('뉴비 아님. 바로 다음 진행');
    //   }
    // } else {
    //   print('뉴비 아님. 바로 다음 진행');
    //   // 테스트용. 쉐어드프리퍼런스 값 다시 초기화해줄 때 주석처리 풀고 핫 리스타트 두번.
    //   _sharedPreferencesService.setSharedPreferencesValue(
    //       isNameUpdatedKey, true);
    // }
    // _sharedPreferencesService.setSharedPreferencesValue(
    //     isNameUpdatedKey, false);

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
    print(userVote.userVoteStats);
    // selected = List<bool>.filled(vote.subVotes.length, false, growable: true);
    selected = List<bool>.filled(vote.subVotes.length, false, growable: true);
    setBusy(false);

    notifyListeners();
  }

  Future initialiseOneVote(int resetTarget) async {
    await _databaseService.initialiseOneVote(
      address,
      userVote,
      resetTarget,
    );
    await _stateManageService.userVoteModelUpdate();
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

  Future<void> navigateToMypageToDown(String routeName) async {
    await _navigationService.navigateTo(routeName);
    // 이렇게 페이지 넘어가는 부분에서 await 걸어주고 후에 후속조치 취해주면 하위페이지에서 변동된 데이터를 적용할 수 있음
    await getModels();
    notifyListeners();
  }

  Future<void> navigateToMypage() async {
    await _navigationService.navigateToMyPage(MypageMainView());
    // await _navigationService.navigateTo('mypage_main');
    await getModels();
    notifyListeners();
  }

  Future getModels() async {
    if (_stateManageService.appStart) {
      await _stateManageService.initStateManage(initUid: uid);
    } else {
      if (await _stateManageService.isNeededUpdate())
        await _stateManageService.initStateManage(initUid: uid);
    }

    user = _stateManageService.userModel;
  }

  // 로그아웃 버튼이 눌렸을 경우..
  Future logout() async {
    // var dialogResult = await _dialogService.showDialog(
    //     title: '로그아웃',
    //     description: '로그아웃하시겠습니까?',
    //     buttonTitle: '네',
    //     cancelTitle: '아니오');
    // if (dialogResult.confirmed) {
    // _sharedPreferencesService.setSharedPreferencesValue("twoFactor", false);
    _stateManageService.setMyState();
    FirebaseKakaoAuthAPI().signOut();
    _authService.signOut();

    // _navigationService.popAndNavigateWithArgTo('initial');
    // }
  }

  @override
  Future futureToRun() => getAllModel(uid);
  // throw UnimplementedError();
}
