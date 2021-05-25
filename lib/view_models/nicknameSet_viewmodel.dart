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

class NicknameSetViewModel extends BaseViewModel {
  // Services Setting
  final AuthService? _authService = locator<AuthService>();
  final DatabaseService? _databaseService = locator<DatabaseService>();
  final NavigationService? _navigationService = locator<NavigationService>();
  // final DialogService _dialogService = locator<DialogService>();
  final StateManageService? _stateManageService = locator<StateManageService>();
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 변수 Setting
  String? uid;
  // String userName;
  UserModel? user;

  bool checking = false;
  void setChecking(bool value) {
    checking = value;
    notifyListeners();
  }

  // method
  NicknameSetViewModel() {
    uid = _authService!.auth.currentUser!.uid;
  }

  Future<bool?> checkUserNameDuplicateAndSet(
      String userName, BuildContext context) async {
    setChecking(true);
    bool? temp = await _databaseService!.isUserNameDuplicated(userName);
    print(temp); // true면 중복있는 것
    if (temp == true) {
      setChecking(false);
      return showDialog(
          context: context,
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text("회원가입 오류"),
                      content: Text("중복 닉네임이 있습니다."),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('확인'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  : AlertDialog(
                      title: Text("회원가입 오류"),
                      content: Text("중복 닉네임이 있습니다."),
                      actions: <Widget>[
                          FlatButton(
                            child: Text("확인"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ]),
            );
          });
      // print("중복 닉네임이 있습니다");
      // await _dialogService.showDialog(
      //   title: '회원가입 오류',
      //   description: "중복 닉네임이 있습니다",
      // );
      // return true;
      // return true;
    } else {
      _databaseService!.updateUserName(uid, userName);
      _sharedPreferencesService!.setSharedPreferencesValue(didSurveyKey, true);
      _stateManageService!.userModelUpdate();
      setChecking(false);
      _navigationService!.navigateWithArgTo('startup', 0);
      return true;
    }

    //
  }
}
