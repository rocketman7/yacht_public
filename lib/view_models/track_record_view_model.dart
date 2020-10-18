import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';

import '../locator.dart';

class TrackRecordViewModel extends FutureViewModel {
  AuthService _authService = locator<AuthService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  String uid;
  DatabaseAddressModel address;
  UserModel user;
  UserVoteModel userVote;
  VoteModel vote;
  List<UserVoteModel> allSeasonUserVoteList = [];
  List<VoteModel> allSeasonVoteList = [];
  // List<Widget> voteRows;

  TrackRecordViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getAllModel(uid) async {
    address = await _databaseService.getAddress(uid);
    user = await _databaseService.getUser(uid);
    userVote = await _databaseService.getUserVote(address);
    vote = await _databaseService.getVotes(address);
    allSeasonUserVoteList =
        await _databaseService.getAllSeasonUserVote(address);

    allSeasonVoteList = await _databaseService.getAllSeasonVote(address);
    print("ALLSEASON" + allSeasonVoteList.length.toString());
    print(allSeasonVoteList[0].voteDate.toString());
    print(allSeasonVoteList[1].voteDate.toString());
    print(allSeasonVoteList[2].voteDate.toString());
    print(allSeasonVoteList[3].voteDate.toString());
    print(allSeasonVoteList[4].voteDate.toString());
    // print(allSeasonVoteList[5].voteDate.toString());
  }

  @override
  Future futureToRun() => getAllModel(uid);
}
