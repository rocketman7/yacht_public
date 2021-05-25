import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class RegisterViewModel extends BaseViewModel {
  final AuthService? _authService = locator<AuthService>();
  final DatabaseService? _databaseService = locator<DatabaseService>();
  // final DialogService _dialogService = locator<DialogService>();
  final NavigationService? _navigationService = locator<NavigationService>();
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();
  Map<String, dynamic>? userData;

  Future register({
    required String userName,
    required String email,
    required String password,
    PhoneAuthCredential? credential,
    BuildContext? context,
  }) async {
    setBusy(true);
    List<String?> allUserName = await (_databaseService!
        .getAllUserNameSnapshot() as FutureOr<List<String?>>);

    if (allUserName.contains(userName)) {
      setBusy(false);
      return showDialog(
          context: context!,
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
    } else {
      var result = await _authService!.registerWithEmail(
        userName: userName,
        email: email,
        password: password,
        phoneCredential: credential!,
      );

      // Register 성공하면,
      if (result is bool) {
        setBusy(false);
        if (result) {
          // HomeView로 이동

          _sharedPreferencesService!
              .setSharedPreferencesValue("twoFactor", true);

          print('Register Success AND' +
              _sharedPreferencesService!
                  .getSharedPreferencesValue('twoFactor', bool)
                  .toString());
          notifyListeners();

          _navigationService!.navigateTo('startup');
        } else {
          // error 다뤄야함.
          print('Register Failure');
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
                        title: Text("회원가입 오류"),
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
                        title: Text("회원가입 오류"),
                        content: Text(result.toString()),
                        actions: <Widget>[
                            FlatButton(
                              child: Text("확인"),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ]),
              );
            });
        // var dialogResult = await _dialogService.showDialog(
        //   title: '회원가입 오류',
        //   description: result.toString(),
        // );
      }
    }
  }

  // Future checkUserNameDuplicate(@required userName) async {
  //   print("All user " + allUserName.toString());
  //   return true;
  // }
}
