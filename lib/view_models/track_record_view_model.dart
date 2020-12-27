import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/season_model.dart';

import '../models/rank_model.dart';
import '../models/database_address_model.dart';
import '../models/user_model.dart';
import '../models/user_vote_model.dart';
import '../models/vote_model.dart';
import '../services/amplitude_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/stateManage_service.dart';

import '../locator.dart';

class TrackRecordViewModel extends FutureViewModel {
  AuthService _authService = locator<AuthService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  final AmplitudeService _amplitudeService = AmplitudeService();
  final StateManageService _stateManageService = locator<StateManageService>();

  String uid;
  DatabaseAddressModel address;
  DatabaseAddressModel newAddress;
  UserModel user;
  UserVoteModel userVote;
  VoteModel vote;
  SeasonModel seasonModel;
  SeasonModel newSeasonModel;
  String showingSeasonName;
  List<RankModel> rankModel = [];
  List<UserVoteModel> allSeasonUserVoteList = [];
  List<VoteModel> allSeasonVoteList = [];
  List<String> seasonNameList = [];
  // List<Widget> voteRows;

  int myRank = 0;

  TrackRecordViewModel() {
    uid = _authService.auth.currentUser.uid;
    print(uid);
  }

  Future getAllModel(uid) async {
    await _amplitudeService.logTrackRecordView(uid);

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
    rankModel = _stateManageService.rankModel;
    seasonModel = _stateManageService.seasonModel;
    showingSeasonName = seasonModel.seasonName;
    for (int i = 0; i < rankModel.length; i++) {
      if (rankModel[i].uid == uid) {
        myRank = rankModel[i].todayRank;
      }
    }

    allSeasonUserVoteList =
        await _databaseService.getAllSeasonUserVote(address);
    allSeasonVoteList = await _databaseService.getAllSeasonVote(address);
    // print("ALLSEASON" + allSeasonVoteList.length.toString());
    // print(allSeasonVoteList[0].voteDate.toString());
    // print(allSeasonVoteList[1].voteDate.toString());
    // print(allSeasonVoteList[2].voteDate.toString());
    // print(allSeasonVoteList[3].voteDate.toString());
    // print(allSeasonVoteList[4].voteDate.toString());
    // print(allSeasonVoteList[5].voteDate.toString());
  }

  Future getAllSeasonList() async {
    var seasonList = [];
    seasonList = await _databaseService.getAllSeasonInfoList();
    print("SEASONLIST" + seasonList[0].toString());
    seasonList.forEach((element) {
      seasonNameList.add(element.seasonName);
    });
    // seasonNameList = ['시즌 2', '시즌 1'];
    // seasonNameList.sort();
    return seasonNameList;
  }

  Future renewAddress() async {
    setBusy(true);
    newAddress = DatabaseAddressModel(
      uid: uid,
      date: "20201222",
      category: address.category,
      season: "beta001",
      // isVoting: address.isVoting,
    );

    userVote = await _databaseService.getUserVote(newAddress);
    allSeasonUserVoteList =
        await _databaseService.getAllSeasonUserVote(newAddress);
    allSeasonVoteList = await _databaseService.getAllSeasonVote(newAddress);
    newSeasonModel = await _databaseService.getSeasonInfo(newAddress);
    showingSeasonName = newSeasonModel.seasonName;
    rankModel = await _databaseService.getRankList(newAddress);
    for (int i = 0; i < rankModel.length; i++) {
      if (rankModel[i].uid == uid) {
        myRank = rankModel[i].todayRank;
      }
    }
    setBusy(false);
    notifyListeners();
  }

  String returnDigitFormat(int value) {
    var f = NumberFormat("#,###", "en_US");

    return f.format(value);
  }

  @override
  Future futureToRun() => getAllModel(uid);
}
