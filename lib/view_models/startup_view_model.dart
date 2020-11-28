import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import 'package:yachtOne/views/home_view.dart';
import 'package:yachtOne/views/login_view.dart';

import '../locator.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class StartUpViewModel extends BaseViewModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  int index;
  String uid;
  StartUpViewModel() {
    index = 0;
    uid = _authService.auth.currentUser.uid;
  }

  // bool isTwoFactorAuthed;

  // @override
  // // TODO: implement stream
  // Stream<User> get stream {
  //   print("stream");

  //   return _authService.auth.authStateChanges();
  // }

  // @override
  // void onCancel() {
  //   print("Subscribe Canceled");
  // }

  // @override
  // void onData(data) async {
  //   isTwoFactorAuthed = await _sharedPreferencesService
  //       .getSharedPreferencesValue("twoFactor", bool);
  //   print("TWOFACTOR" + isTwoFactorAuthed.toString());
  //   notifyListeners();

  //   print(data);
  //   // if (!isTwoFactorAuthed) {
  //   //   _navigationService.navigateWithArgTo(
  //   //       // 'register', _authService.authCredential);
  //   // } else {
  //   if (data == null) {
  //     // return LoginView();
  //     print("GOTOLOGIN");
  //     _navigationService.navigateTo('login');
  //   } else {}
  // }
  // }
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
