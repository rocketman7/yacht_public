import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class LoginViewModel extends BaseViewModel {
  final AuthService? _authService = locator<AuthService>();
  final NavigationService? _navigationService = locator<NavigationService>();
  final DatabaseService? _databaseService = locator<DatabaseService>();
  // final DialogService _dialogService = locator<DialogService>();
  final SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // Future doThings() async {
  //   print("dialog shown");
  //   var dialogResult = await _dialogService.showDialog();
  //   print(dialogResult);
  //   print("dialog close");
  // }

  // 로그인 function. View로부터 전달받은 계정정보를 input으로 authService의 로그인 함수를 호출.
  Future login(
      {required String email,
      required String password,
      BuildContext? context}) async {
    setBusy(true);
    var result =
        await _authService!.loginWithEmail(email: email, password: password);
    // 로그인 성공하면
    print(result.toString());
    if (result is bool) {
      setBusy(false);
      if (result == true) {
        // print('Login Success');
        // loggedIn 화면으로 route (HomeView)
        _sharedPreferencesService!.setSharedPreferencesValue("twoFactor", true);
        _navigationService!.navigateTo(
          'startup',
        );
      } else {
        print('Login Failure');
      }
    } else {
      setBusy(false);
      return showDialog(
          context: context!,
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text("로그인 오류"),
                      content: Text(result.toString()),
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
                      title: Text("로그인 오류"),
                      content: Text(
                        result.toString(),
                      ),
                      actions: <Widget>[
                          FlatButton(
                            child: Text("확인"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ]),
            );
          });
      // var dialogResult = await _dialogService.showDialog(
      //   title: '로그인 오류',
      //   description: result.toString(),
      // );
      // print(result.toString());
    }
  }
}
