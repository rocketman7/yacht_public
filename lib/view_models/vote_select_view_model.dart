import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/base_model.dart';

class VoteSelectViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  //Code:

  UserModel _user;
  VoteModel _vote;

  Future getUserDB(String uid) async {
    _user = await _databaseService.getUser(uid);
    return _user;
  }

  Future getVoteDB(String date) async {
    _vote = await _databaseService.getVotes(date);
    return _vote;
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
