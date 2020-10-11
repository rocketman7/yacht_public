import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/managers/dialog_manager.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/dialog_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import 'package:yachtOne/view_models/base_model.dart';

import '../locator.dart';

class PhoneAuthViewModel extends FutureViewModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final DialogService _dialogService = locator<DialogService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  bool isTwoFactorAuthed = false;
  String get verificationId => _authService.verificationId;

  // authService로 폰 번호와 content 넘겨서 폰 인증 작업 시작
  Future<dynamic> phoneAuth(
    String phoneNumber,
    BuildContext context,
  ) async {
    setBusy(true);
    // 기존에 가입한 핸드폰 번호인지 check해야 함
    // 이미 가입한 핸드폰 있으면 false 반환
    bool duplicatePhoneNumber =
        await _databaseService.duplicatePhoneNumberCheck(phoneNumber);

    if (duplicatePhoneNumber == false) {
      await _dialogService.showDialog(
        title: '핸드폰 인증 오류',
        description: '이미 가입한 핸드폰 번호입니다',
      );
      setBusy(false);

      return true;
    } else {
      await _authService.sendPhoneAuthSms(phoneNumber, context);
      setBusy(false);
    }
    setBusy(false);
  }

  Future matchCode(String code) async {
    print(verificationId);
    // setTwoFactorAuth(false);
    await _authService.verifySms(code, verificationId);
  }

  @override
  Future futureToRun() =>
      _sharedPreferencesService.setSharedPreferencesValue('twoFactor', false);

  // void setTwoFactorAuth(bool isTwoFactored) {
  //   _sharedPreferencesService.setSharedPreferencesValue(
  //       "twoFactor", isTwoFactored);
  //   isTwoFactorAuthed = isTwoFactored;
  //   notifyListeners();
  // }
}
