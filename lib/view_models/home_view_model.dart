import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/season_model.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../models/sub_vote_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class HomeViewModel extends FutureViewModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  // UserModel _user;
  UserModel user;
  // UserModel get user => _user;
  DatabaseAddressModel address;
  VoteModel vote;
  SeasonModel seasonInfo;

  String uid;
  // String get uid => _uid;
  // Stream<User> get authUserState => _authUserState();
  // UserModel user;

// Call this function when initialized
  HomeViewModel() {
    // _authService.signOut();
    print("HOMEVIEWMODEL STARTED");
    uid = _authService.auth.currentUser.uid;
    // getUser();
  }

  Future getAllModel(uid) async {
    setBusy(true);
    // _allModel.add(await getAddress());
    // _allModel.add(await getUser(uid));
    // _allModel.add(await getVote(address));

    address = await _databaseService.getAddress(uid);
    user = await _databaseService.getUser(uid);
    vote = await _databaseService.getVotes(address);
    seasonInfo = await _databaseService.getSeasonInfo(address);
    print("LENGTH" + vote.subVotes[0].issueCode.length.toString());
    setBusy(false);
  }

  Future signOut() async {
    await _authService.signOut();
    // _navigationService.navigateTo('/');
    // var hasUserLoggedIn = await _authService.isUserLoggedIn();
    // if (hasUserLoggedIn) {
    //   _navigationService.navigateTo('loggedIn');
    // } else {
    //   _navigationService.navigateTo('login');
    // }
  }

  @override
  Future futureToRun() => getAllModel(uid);

  // Future addVotesTest() async {
  //   await _databaseService.addVotes(voteToday, subvotesToday);
  // }
}
