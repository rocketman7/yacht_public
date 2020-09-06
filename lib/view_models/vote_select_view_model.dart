import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/sub_vote_model.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

import '../models//temp_address_constant.dart';

class VoteSelectViewModel extends FutureViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  //Code:

  String uid;
  UserModel _user;
  DatabaseAddressModel _address;
  VoteModel _vote;
  List<SubVote> _subVote;
  Timer _everySecond;
  DateTime _now;
  bool _isGgookAvailable = true;

  List<String> timeLeftArr = ["", "", ""];

  Timer get everySecond => _everySecond;

  DateTime getNow() {
    return DateTime.now();
  }

  VoteSelectViewModel() {
    // _authService.signOut();

    uid = _authService.auth.currentUser.uid;
    _now = getNow();
    // getUser();
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
    print(DateTime.now());
    String getUid = _authService.auth.currentUser.uid;
    print(DateTime.now().toString() + getUid);
    _user = await _databaseService.getUser(getUid);
    return _user;
  }

  Future<DatabaseAddressModel> getAddress() async {
    _address = await _databaseService.getAddress(uid);
    return _address;
  }

  Future<VoteModel> getVote(DatabaseAddressModel addressModel) async {
    _vote = await _databaseService.getVotes(addressModel);
    return _vote;
  }

  Future signOut() async {
    await _authService.signOut();
  }

  @override
  Future futureToRun() async {
    // TODO: implement futureToRun
    var uid = await _authService.auth.currentUser.uid;

    return uid;
    // throw UnimplementedError();
  }
}
