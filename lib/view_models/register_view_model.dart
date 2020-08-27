import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yachtOne/services/database_service.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class RegisterViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final DialogService _dialogService = locator<DialogService>();
  Map<String, dynamic> userData;

  Future register({
    @required String userName,
    @required String email,
    @required String password,
    AuthCredential credential,
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
      }
    }
  }

  Future<dynamic> phoneAuth(String value, context) async {
    // var user = _authService.currentUser;
    return _authService.verifyPhoneNumber(value, context);
  }
  // Future checkUserNameDuplicate(@required userName) async {
  //   print("All user " + allUserName.toString());
  //   return true;
  // }
}
