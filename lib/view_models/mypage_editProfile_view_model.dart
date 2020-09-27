import 'package:stacked/stacked.dart';

import '../models/user_model.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/sharedPreferences_service.dart';
import '../models/sharedPreferences_const.dart';

class MypageEditProfileViewModel extends FutureViewModel {
  // Services Setting
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 변수 Setting
  String uid;
  UserModel user;
  String sharedPrefForAvatarImage; //DB에서 관리되지만 즉각적반응을 위해 sharedPref도

  void setAvatarImage(String avatarImage) {
    _databaseService.setAvatarImage(avatarImage, uid);
    _sharedPreferencesService.setSharedPreferencesValue(avatarKey, avatarImage);
    sharedPrefForAvatarImage = avatarImage;

    notifyListeners();
  }

  // method
  MypageEditProfileViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getModels() async {
    user = await _databaseService.getUser(uid);
    sharedPrefForAvatarImage = await _sharedPreferencesService
        .getSharedPreferencesValue(avatarKey, String);

    if (sharedPrefForAvatarImage == '') sharedPrefForAvatarImage = 'avatar';
  }

  @override
  Future futureToRun() => getModels();
}
