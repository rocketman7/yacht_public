import 'package:flutter/material.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/dialog_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/base_model.dart';

class RegisterViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final DialogService _dialogService = locator<DialogService>();
  Map<String, dynamic> userData;

  Future register({
    @required String userName,
    @required String email,
    @required String password,
  }) async {
    var result = await _authService.registerWithEmail(
        userName: userName, email: email, password: password);

    // Register 성공하면,
    if (result is bool) {
      if (result) {
        print('Register Success');
        // HomeView로 이동
        locator<NavigationService>().navigateTo('loggedIn');
      } else {
        // error 다뤄야함.
        print('Register Failure');
      }
    } else {
      var dialogResult = await _dialogService.showDialog(
        title: '회원가입 오류',
        description: result.toString(),
      );
      print(result.toString());
    }
  }
}
