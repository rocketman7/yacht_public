import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class PasswordChangeViewModel extends BaseViewModel {
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
  PasswordChangeViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future chanegePassword(String newPassword, BuildContext context) async {
    setChecking(true);
    var result = await _authService.changePassword(newPassword);
    print("RESULTD " + result.toString());
    if (result == true) {
      setChecking(false);
      // Navigator.pop(context);
      // _navigationService.navigateTo('initial');
    } else if (result == "firebase_auth/requires-recent-login") {
      setChecking(false);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text("재 로그인이 필요합니다"),
                      content: Text("비밀번호를 변경하기 위해서 다시 로그인한 후 변경해야 합니다."),
                    )
                  : AlertDialog(
                      title: Text("재 로그인이 필요합니다"),
                      content: Text("비밀번호를 변경하기 위해서 다시 로그인한 후 변경해야 합니다."),
                    ),
            );
          });
    } else {
      Navigator.pop(context);
    }
//
    //
  }
}
