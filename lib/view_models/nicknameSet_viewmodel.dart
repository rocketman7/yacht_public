import 'package:stacked/stacked.dart';

import '../models/sharedPreferences_const.dart';
import '../models/user_model.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../services/sharedPreferences_service.dart';

class NicknameSetViewModel extends FutureViewModel {
  // Services Setting
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 변수 Setting
  String uid;
  UserModel user;

  // method
  NicknameSetViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getModels() async {
    user = await _databaseService.getUser(uid);
  }

  //
  setNickname() {
    _databaseService.updateUserName(uid, '잘바뀜');
    _sharedPreferencesService.setSharedPreferencesValue(isNameUpdatedKey, true);
    _navigationService.navigateTo('initial');
  }

  @override
  Future futureToRun() => getModels();
}
