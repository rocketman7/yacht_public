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

class VoteSelectViewModel extends FutureViewModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
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
    print(vote.voteEndDateTime);
    setBusy(false);
    notifyListeners();
  }

  Future signOut() async {
    await _authService.signOut();
  }

  @override
  Future futureToRun() => getAllModel(uid);
  // throw UnimplementedError();
}
