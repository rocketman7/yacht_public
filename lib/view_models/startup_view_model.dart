import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/views/home_view.dart';
import 'package:yachtOne/views/login_view.dart';

import '../locator.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class StartUpViewModel extends StreamViewModel<User> {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  int index;
  StartUpViewModel() {
    index = 0;
  }

  @override
  // TODO: implement stream
  Stream<User> get stream {
    print("stream");
    return _authService.auth.authStateChanges();
  }

  @override
  void onCancel() {
    print("Subscribe Canceled");
  }

  @override
  void onData(data) {
    print(data);
    if (data == null) {
      // return LoginView();
      _navigationService.navigateTo('login');
    } else {
      // _navigationService.navigateTo('loggedIn');
    }
  }
  // Stream<User> user;

  // Stream handleStartUpLogic() async {
  //   // 유저정보 있으면 True, 없으면 False
  //   _authService.signOut();

  //   bool hasUserLoggedIn = await _authService.isUserLoggedIn();
  //   print(hasUserLoggedIn);
  //   if (hasUserLoggedIn) {
  //     _navigationService.navigateTo('loggedIn');
  //   } else {
  //     _navigationService.navigateTo('login');
  //   }
  // }

  // Stream user() {
  //   var userState = _authService.auth.authStateChanges();
  //   if(userState == null) {

  //   }
  // }
}
