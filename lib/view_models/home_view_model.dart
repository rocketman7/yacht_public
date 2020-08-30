import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../models/sub_vote_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class HomeViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  UserModel _user;
  DatabaseAddressModel _address;
  VoteModel _vote;
  List<SubVote> _subVote;
  String uid;
  // String get uid => _uid;
  // Stream<User> get authUserState => _authUserState();
  // UserModel user;

// Call this function when initialized
  HomeViewModel() {
    // _authService.signOut();

    uid = _authService.auth.currentUser.uid;
    // getUser();
    print("getUserInitialized");
  }

  Future<List<Object>> getAllModel(uid) async {
    List<Object> _allModel = [];

    _address = await getAddress();
    _allModel.add(_address);
    _allModel.add(await getUser(uid));
    _allModel.add(await getVote(_address));

    print(_allModel);
    return _allModel;
  }

  Future<UserModel> getUser(String uid) async {
    // Future 안에서 왜 _currentUser 받아올 때까지 기다리지 않고 다음 라인이 실행되나?
    //NoSuchMethodError (NoSuchMethodError: The getter 'uid' was called on null. 이 오류 왜 뜨는지 확인필요
    // ->>
    // currentUser는 initializing이 안 되면 null을 반환할 때도 있다.
    // 따라서 이 getUser() Future를 불러오기 전에 HomeView에서 StreamBuilder로
    // onAuthStateChanged의 변화를 listen하다가 data가 있을 때 다음 진행하도록 설정하니 에러 없음
    _user = await _databaseService.getUser(uid);
    return _user;
  }

  Future<DatabaseAddressModel> getAddress() async {
    _address = await _databaseService.getAddress(uid);
    return _address;
  }

  Future<VoteModel> getVote(DatabaseAddressModel model) async {
    _vote = await _databaseService.getVotes(model);
    return _vote;
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

  // Future addVotesTest() async {
  //   await _databaseService.addVotes(voteToday, subvotesToday);
  // }
}
