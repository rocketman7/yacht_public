import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class VoteSelectViewModel extends BaseViewModel {
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
}
