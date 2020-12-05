import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/dialog_service.dart';
import 'package:yachtOne/services/stateManage_service.dart';

import '../models/sharedPreferences_const.dart';
import '../models/user_model.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../services/sharedPreferences_service.dart';

class NicknameSetViewModel extends BaseViewModel {
  // Services Setting
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final StateManageService _stateManageService = locator<StateManageService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 변수 Setting
  String uid;
  // String userName;
  UserModel user;

  bool checking = false;
  void setChecking(bool value) {
    checking = value;
    notifyListeners();
  }

  // method
  NicknameSetViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future<bool> checkUserNameDuplicateAndSet(String userName) async {
    setChecking(true);
    bool temp = await _databaseService.isUserNameDuplicated(userName);
    print(temp); // true면 중복있는 것
    if (temp == true) {
      setChecking(false);
      print("중복 닉네임이 있습니다");
      await _dialogService.showDialog(
        title: '회원가입 오류',
        description: "중복 닉네임이 있습니다",
      );
      // return true;
      return true;
    } else {
      _databaseService.updateUserName(uid, userName);
      _sharedPreferencesService.setSharedPreferencesValue(
          isNameUpdatedKey, true);
      _stateManageService.userModelUpdate();
      setChecking(false);
      _navigationService.navigateWithArgTo('startup', 0);
      return true;
    }

    //
  }
}
