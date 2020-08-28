import 'package:flutter/material.dart';
import 'package:yachtOne/models/dialog_model.dart';
import 'package:yachtOne/services/dialog_service.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class MypageViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  UserModel _user;

  Future getUser(String uid) async {
    _user = await _databaseService.getUser(uid);
    return _user;
  }

  // 로그아웃 버튼이 눌렸을 경우..
  Future logout() async {
    var dialogResult = await _dialogService.showDialog(
        title: '로그아웃',
        description: '로그아웃하시겠습니까?',
        buttonTitle: '네',
        cancelTitle: '아니오');
    print(dialogResult.toString());
    print(dialogResult.fieldOne);
    print(dialogResult.fieldTwo);
    print(dialogResult.confirmed);
    if (dialogResult.confirmed) {
      print('DD');
      _authService.signOut();

      //_navigationService.navigatorKey.currentState.popAndPushNamed('login');
      //_navigationService.navigateTo('login');
      // _navigationService.navigatorKey.currentState
      //     .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
      _navigationService.popAndNavigateWithArgTo('login', null);
    }
  }
}
