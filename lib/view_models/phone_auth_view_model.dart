import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/managers/dialog_manager.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/dialog_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import 'package:yachtOne/view_models/base_model.dart';

import '../locator.dart';

class PhoneAuthViewModel extends FutureViewModel {
  final AuthService? _authService = locator<AuthService>();
  final DatabaseService? _databaseService = locator<DatabaseService>();
  // final DialogService _dialogService = locator<DialogService>();
  final NavigationService? _navigationService = locator<NavigationService>();
  SharedPreferencesService? _sharedPreferencesService =
      locator<SharedPreferencesService>();

  bool isTwoFactorAuthed = false;
  String? get verificationId => _authService!.verificationId;

  // authService로 폰 번호와 content 넘겨서 폰 인증 작업 시작
  Future<dynamic> phoneAuth(
    String phoneNumber,
    BuildContext context,
  ) async {
    setBusy(true);
    // 기존에 가입한 핸드폰 번호인지 check해야 함
    // 이미 가입한 핸드폰 있으면 false 반환
    bool duplicatePhoneNumber = await (_databaseService!
        .duplicatePhoneNumberCheck(phoneNumber) as FutureOr<bool>);

    if (duplicatePhoneNumber == false) {
      setBusy(false);
      return showDialog(
          context: context,
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text("핸드폰 인증 오류"),
                      content: Text("이미 가입한 핸드폰 번호입니다."),
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
                      title: Text("핸드폰 인증 오류"),
                      content: Text("이미 가입한 핸드폰 번호입니다."),
                      actions: <Widget>[
                          FlatButton(
                            child: Text("확인"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ]),
            );
          });
      // await _dialogService.showDialog(
      //   title: '핸드폰 인증 오류',
      //   description: '이미 가입한 핸드폰 번호입니다',
      // );

      // return true;
    } else {
      await _authService!.sendPhoneAuthSms(phoneNumber, context);
      setBusy(false);
    }
  }

  Future matchCode(String code, BuildContext context) async {
    setBusy(true);
    print(verificationId);
    // setTwoFactorAuth(false);

    var credential = await _authService!.verifySms(code, verificationId!);

    print("AFTER PHONEAUTH " + credential.toString());

    if (credential == null) {
      setBusy(false);

      return showDialog(
          context: context,
          builder: (context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text("인증번호 오류"),
                      content: Text("인증번호를 다시 입력해주세요."),
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
                      title: Text("인증번호 오류"),
                      content: Text("인증번호를 다시 입력해주세요."),
                      actions: <Widget>[
                          FlatButton(
                            child: Text("확인"),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ]),
            );
          });

      // await _dialogService.showDialog(
      //   title: '인증번호 오류',
      //   description: '인증번호를 다시 입력해주세요.',
      // );
    } else {
      setBusy(false);
      _navigationService!.navigateWithArgTo('register', credential);
    }
  }

  @override
  Future futureToRun() =>
      _sharedPreferencesService!.setSharedPreferencesValue('twoFactor', false);

  // void setTwoFactorAuth(bool isTwoFactored) {
  //   _sharedPreferencesService.setSharedPreferencesValue(
  //       "twoFactor", isTwoFactored);
  //   isTwoFactorAuthed = isTwoFactored;
  //   notifyListeners();
  // }
}
