import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/base_model.dart';

class HomeViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  UserModel _user;
  String uid;
  // UserModel user;

  Future getUser() async {
    // Future 안에서 왜 _currentUser 받아올 때까지 기다리지 않고 다음 라인이 실행되나?
    //NoSuchMethodError (NoSuchMethodError: The getter 'uid' was called on null. 이 오류 왜 뜨는지 확인필요
    // ->>
    // currentUser는 initializing이 안 되면 null을 반환할 때도 있다.
    // 따라서 이 getUser() Future를 불러오기 전에 HomeView에서 StreamBuilder로
    // onAuthStateChanged의 변화를 listen하다가 data가 있을 때 다음 진행하도록 설정하니 에러 없음
    var _currentUser = await _authService.auth.currentUser();
    print("'__inside getUser Future'");
    print(_currentUser);

    _user = await _databaseService.getUser(_currentUser.uid);
    return _user;
  }

  Future signOut() async {
    await _authService.signOut();
    var hasUserLoggedIn = await _authService.isUserLoggedIn();
    if (hasUserLoggedIn) {
      _navigationService.navigateTo('loggedIn');
    } else {
      _navigationService.navigateTo('login');
    }
  }
}
