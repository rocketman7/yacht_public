import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class RegisterViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  Map<String, dynamic> userData;

  Future register({
    @required String userName,
    @required String email,
    @required String password,
    PhoneAuthCredential credential,
  }) async {
    List<String> allUserName = await _databaseService.getAllUserNameSnapshot();

    if (allUserName.contains(userName)) {
      print("중복 닉네임이 있습니다");
      await _dialogService.showDialog(
        title: '회원가입 오류',
        description: "중복 닉네임이 있습니다",
      );
      return true;
    } else {
      var result = await _authService.registerWithEmail(
        userName: userName,
        email: email,
        password: password,
        phoneCredential: credential,
      );

      // Register 성공하면,
      if (result is bool) {
        if (result) {
          // HomeView로 이동

          _sharedPreferencesService.setSharedPreferencesValue(
              "twoFactor", true);

          print('Register Success AND' +
              _sharedPreferencesService
                  .getSharedPreferencesValue('twoFactor', bool)
                  .toString());
          notifyListeners();

          _navigationService.navigateTo('startup');
        } else {
          // error 다뤄야함.
          print('Register Failure');
        }
      } else {
        var dialogResult = await _dialogService.showDialog(
          title: '회원가입 오류',
          description: result.toString(),
        );
      }
    }
  }

  // Future checkUserNameDuplicate(@required userName) async {
  //   print("All user " + allUserName.toString());
  //   return true;
  // }
}
