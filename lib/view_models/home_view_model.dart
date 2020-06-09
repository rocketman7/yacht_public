import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/base_model.dart';

class HomeViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  // UserModel _currentUser;
  String uid;

  Future getUser() async {
    // Future 안에서 왜 _currentUser 받아올 때까지 기다리지 않고 다음 라인이 실행되나?
    var _currentUser = await _authService.auth.currentUser();
    print("currentUser Done");
    if (_currentUser == null) {
      print("null");
    } else {
      return _databaseService.getUser(_currentUser.uid);
    }
    //NoSuchMethodError (NoSuchMethodError: The getter 'uid' was called on null. 이 오류 왜 뜨는지 확인필요
    // 위에서 currentUser 먼저 받은 다음에 아래 라인 실행되는 게 아닌가?

    // _currentUser = await _databaseService.getUser(userResult.uid);
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
