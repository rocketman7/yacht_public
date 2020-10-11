import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';

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
  //Code:

  String uid;
  UserModel user;
  DatabaseAddressModel address;
  VoteModel vote;
  UserVoteModel userVote;
  SeasonModel seasonInfo;
  List<SubVote> subVote;
  Timer _everySecond;

  List<String> timeLeftArr = ["", "", ""];

  Timer get everySecond => _everySecond;

  bool voteSelectTutorial;
  int tutorialStatus = 2; // 튜토리얼 내 단계만큼.. (나중에 쉐어드 프리퍼런스로 해야할 듯)
  int tutorialTotalStep = 2; // 튜토리얼 총 단계

  DateTime getNow() {
    return DateTime.now();
  }

  VoteSelectViewModel() {
    // _authService.signOut();

    uid = _authService.auth.currentUser.uid;

    // _now = getNow();
    // getUser();
  }

  Future getAllModel(uid) async {
    setBusy(true);
    address = await _databaseService.getAddress(uid);
    user = await _databaseService.getUser(uid);
    vote = await _databaseService.getVotes(address);
    userVote = await _databaseService.getUserVote(address);
    seasonInfo = await _databaseService.getSeasonInfo(address);
    voteSelectTutorial = await _sharedPreferencesService
        .getSharedPreferencesValue(voteSelectTutorialKey, bool);
    print(vote.voteEndDateTime);
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

  @override
  Future futureToRun() => getAllModel(uid);
  // throw UnimplementedError();
}
