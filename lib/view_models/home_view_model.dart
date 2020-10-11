import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/portfolio_model.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';

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
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // UserModel _user;
  UserModel user;
  // UserModel get user => _user;
  DatabaseAddressModel address;
  VoteModel vote;
  UserVoteModel userVote;
  SeasonModel seasonInfo;
  PortfolioModel portfolioModel;

  String uid;
  // String get uid => _uid;
  // Stream<User> get authUserState => _authUserState();
  // UserModel user;

// Call this function when initialized
  HomeViewModel() {
    // _authService.signOut();
    print("HOMEVIEWMODEL STARTED");
    uid = _authService.auth.currentUser.uid;
    // _sharedPreferencesService.setSharedPreferencesValue('twoFactor', true);
    // getUser();
    if (_authService.auth.currentUser.email != null) {
      _sharedPreferencesService.setSharedPreferencesValue('twoFactor', true);
    }
  }

  Future getAllModel(uid) async {
    setBusy(true);

    // _allModel.add(await getAddress());
    // _allModel.add(await getUser(uid));
    // _allModel.add(await getVote(address));

    address = await _databaseService.getAddress(uid);
    user = await _databaseService.getUser(uid);
    vote = await _databaseService.getVotes(address);
    userVote = await _databaseService.getUserVote(address);
    seasonInfo = await _databaseService.getSeasonInfo(address);
    portfolioModel = await _databaseService.getPortfolio(address);
    print(userVote.userVoteStats.currentWinPoint.toString());
    print("LENGTH" + vote.subVotes[0].issueCode.length.toString());
    setBusy(false);
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
