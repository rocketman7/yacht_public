import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_segment/flutter_segment.dart';
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
  AuthService? _authService = locator<AuthService>();
  DatabaseService? _databaseService = locator<DatabaseService>();
  final AmplitudeService _amplitudeService = AmplitudeService();
  final StateManageService? _stateManageService = locator<StateManageService>();

  String? uid;
  DatabaseAddressModel? address;
  late DatabaseAddressModel newAddress;
  UserModel? user;
  UserVoteModel? userVote;
  VoteModel? vote;
  SeasonModel? seasonModel;
  SeasonModel? newSeasonModel;
  String? showingSeasonName;
  List<RankModel>? rankModel = [];
  List<UserVoteModel> allSeasonUserVoteList = [];
  List<VoteModel> allSeasonVoteList = [];
  List<String> seasonNameList = [];
  List<SeasonModel>? seasonModelList = [];
  bool isChangingSeason = false;
  // List<Widget> voteRows;

  int? myRank = 0;

  TrackRecordViewModel() {
    uid = _authService!.auth.currentUser!.uid;
    print(uid);
  }

  Future getAllModel(uid) async {
    await _amplitudeService.logTrackRecordView(uid);

    Segment.track(
      eventName: 'Test ButtonClicked',
      properties: {
        'foo': 'bar',
        'number': 1337,
        'clicked': true,
      },
    );

    if (_stateManageService!.appStart) {
      await _stateManageService!.initStateManage(initUid: uid);
    } else {
      if (await _stateManageService!.isNeededUpdate())
        await _stateManageService!.initStateManage(initUid: uid);
    }

    address = _stateManageService!.addressModel;
    user = _stateManageService!.userModel;
    vote = _stateManageService!.voteModel;
    userVote = _stateManageService!.userVoteModel;
    rankModel = _stateManageService!.rankModel;
    seasonModel = _stateManageService!.seasonModel;
    showingSeasonName = seasonModel!.seasonName;
    for (int i = 0; i < rankModel!.length; i++) {
      if (rankModel![i].uid == uid) {
        myRank = rankModel![i].todayRank;
      }
    }

    allSeasonUserVoteList = await (_databaseService!
        .getAllSeasonUserVote(address!) as FutureOr<List<UserVoteModel>>);
    allSeasonVoteList = await (_databaseService!.getAllSeasonVote(address!)
        as FutureOr<List<VoteModel>>);
    // print("ALLSEASON" + allSeasonVoteList.length.toString());
    // print(allSeasonVoteList[0].voteDate.toString());
    // print(allSeasonVoteList[1].voteDate.toString());
    // print(allSeasonVoteList[2].voteDate.toString());
    // print(allSeasonVoteList[3].voteDate.toString());
    // print(allSeasonVoteList[4].voteDate.toString());
    // print(allSeasonVoteList[5].voteDate.toString());
  }

  Future<List<String>> getAllSeasonList() async {
    List<String> seasonNameList = [];

    seasonModelList = await _databaseService!.getAllSeasonInfoList();
    print("SEASONLIST" + seasonModelList![0].toString());
    seasonModelList!.forEach((element) {
      seasonNameList.add(element.seasonName.toString());
    });
    print("SEASON NAME LIST" + seasonNameList.toString());
    // seasonNameList = ['시즌 2', '시즌 1'];
    // seasonNameList.sort();
    return seasonNameList;
  }

  Future renewAddress(String? seasonName) async {
    String? newEndDate;
    String? newSeason;

    for (var i = 0; i < seasonModelList!.length; i++) {
      if (seasonModelList![i].seasonName == seasonName) {
        newEndDate = seasonModelList![i].endDate ?? address!.date;
        newSeason = seasonModelList![i].seasonId;
        print(newEndDate);
        print(newSeason);
      }
    }
    isChangingSeason = true;
    notifyListeners();
    // setBusy(true);
    newAddress = DatabaseAddressModel(
      uid: uid,
      date: newEndDate,
      category: address!.category,
      season: newSeason,
      // isVoting: address.isVoting,
    );

    userVote = await (_databaseService!.getUserVote(newAddress)
        as FutureOr<UserVoteModel?>);
    allSeasonUserVoteList = await (_databaseService!
        .getAllSeasonUserVote(newAddress) as FutureOr<List<UserVoteModel>>);
    allSeasonVoteList = await (_databaseService!.getAllSeasonVote(newAddress)
        as FutureOr<List<VoteModel>>);
    newSeasonModel = await _databaseService!.getSeasonInfo(newAddress);
    showingSeasonName = newSeasonModel!.seasonName;
    rankModel = await _databaseService!.getRankList(newAddress);
    for (int i = 0; i < rankModel!.length; i++) {
      if (rankModel![i].uid == uid) {
        myRank = rankModel![i].todayRank;
      }
    }
    isChangingSeason = false;
    notifyListeners();
  }

  String returnDigitFormat(int? value) {
    var f = NumberFormat("#,###", "en_US");

    return f.format(value);
  }

  @override
  Future futureToRun() => getAllModel(uid);
}
