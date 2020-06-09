import 'package:flutter/material.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  // 로그인 function. View로부터 전달받은 계정정보를 input으로 authService의 로그인 함수를 호출.
  Future login({@required String email, @required String password}) async {
    var result =
        await _authService.loginWithEmail(email: email, password: password);
    // 로그인 성공하면
    if (result is bool) {
      if (result) {
        print('Login Success');
        // loggedIn 화면으로 route (HomeView)
        _navigationService.navigateTo(
          'loggedIn',
        );
      } else {
        print('Login Failure');
      }
    } else {
      print(result.toString());
    }
  }
}
