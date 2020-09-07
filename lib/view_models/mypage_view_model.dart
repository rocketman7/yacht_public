import 'package:flutter/material.dart';
import '../services/dialog_service.dart';
import '../services/sharedPreferences_service.dart';
import '../services/storage_service.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../models/sharedPreferences_const.dart';
import '../models/database_address_model.dart';

class MypageViewModel extends ChangeNotifier {
  // Services Setting
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final StorageService _storageService = locator<StorageService>();

  // 변수 Setting
  DatabaseAddressModel addressModel;
  UserModel _user;
  String _downloadAddress;
  String uid;
  // Shared Preferences 변수 Setting
  // Shared Preferences 값들을 아래에서 선언 및 관리해준다. 초기값을 넣어주는게 안전함.
  // * core/models/shared_preferences_const 에서도 key 값을 관리해주어야함.
  bool pushAlarm1 = false;
  bool pushAlarm2 = false;
  int userCounter = 0;

  MypageViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getUser() async {
    addressModel = await _databaseService.getAddress(uid);
    _user = await _databaseService.getUser(uid);
    return _user;
  }

  String get downloadAddress => _downloadAddress;

  // method
  // 로그아웃 버튼이 눌렸을 경우..
  Future logout() async {
    print("logoutbutton");
    var dialogResult = await _dialogService.showDialog(
        title: '로그아웃',
        description: '로그아웃하시겠습니까?',
        buttonTitle: '네',
        cancelTitle: '아니오');
    if (dialogResult.confirmed) {
      _authService.signOut();

      // _navigationService.popAndNavigateWithArgTo('login', null);
    }
  }

  // shared preferences method
  void clearSharedPreferencesAll() {
    _sharedPreferencesService.clearSharedPreferencesAll();
    pushAlarm1 = false;
    pushAlarm2 = false;
    userCounter = 0;

    notifyListeners();
  }

  Future getSharedPreferencesAll() async {
    pushAlarm1 = await _sharedPreferencesService.getSharedPreferencesValue(
        pushAlarm1key, bool);
    pushAlarm2 = await _sharedPreferencesService.getSharedPreferencesValue(
        pushAlarm2key, bool);
    userCounter = await _sharedPreferencesService.getSharedPreferencesValue(
        userCounterkey, int);

    notifyListeners();
  }

  void setSharedPreferencesAll() {
    _sharedPreferencesService.setSharedPreferencesValue(
        pushAlarm1key, pushAlarm1);
    _sharedPreferencesService.setSharedPreferencesValue(
        pushAlarm2key, pushAlarm2);
    _sharedPreferencesService.setSharedPreferencesValue(
        userCounterkey, userCounter);

    notifyListeners();
  }

  void navigateToMypageToDown(String routeName) {
    _navigationService.navigateTo(routeName);
  }
}
