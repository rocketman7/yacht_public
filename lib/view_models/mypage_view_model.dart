import 'package:flutter/material.dart';
import '../models/dialog_model.dart';
import '../services/dialog_service.dart';
import '../services/sharedPreferences_service.dart';
import '../services/storage_service.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class MypageViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final StorageService _storageService = locator<StorageService>();
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  UserModel _user;
  String _downloadAddress;

  Future getUser(String uid) async {
    _user = await _databaseService.getUser(uid);
    return _user;
  }

  String get downloadAddress => _downloadAddress;

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

  Future downloadImage() async {
    _downloadAddress = await _storageService.downloadImage();
    return _downloadAddress;
  }

  Future<void> clearSharedPreferencesAll() async {
    _sharedPreferencesService.clearSharedPreferencesAll();
  }

  Future<dynamic> getSharedPreferences(String key, Type type) async {
    return await _sharedPreferencesService.getSharedPreferences(key, type);
  }

  Future<void> setSharedPreferences(String key, dynamic value) async {
    _sharedPreferencesService.setSharedPreferences(key, value);
  }
}
