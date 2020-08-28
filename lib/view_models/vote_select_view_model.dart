import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';

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

  UserModel _userModel;
  VoteModel _voteModel;

  Future<UserModel> getUser(String uid) async {
    _userModel = await _databaseService.getUser(uid);
    return _userModel;
  }

  Future<VoteModel> getVote(DatabaseAddressModel addressModel) async {
    _voteModel = await _databaseService.getVotes(addressModel);
    return _voteModel;
  }

  Future signOut() async {
    await _authService.signOut();
    var hasUserLoggedIn = await _authService.isUserLoggedIn();
    if (hasUserLoggedIn) {
      _navigationService.navigateTo('loggedIn');
    } else {
      _navigationService.navigateTo('login');
    }
  }

  @override
  Future futureToRun() async {
    // TODO: implement futureToRun
    var uid = await Future.delayed(Duration(seconds: 3))
        .then((value) => _authService.auth.currentUser.uid);
    print('after 3 sec ' + uid);
    return uid;
    // throw UnimplementedError();
  }
}
