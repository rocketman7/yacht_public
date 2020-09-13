import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/auth_service.dart';

import '../locator.dart';

class InitialViewModel extends StreamViewModel {
  final AuthService _authService = locator<AuthService>();

  Stream<User> getAuthChange() {
    return _authService.auth.authStateChanges();
  }

  @override
  // TODO: implement stream
  Stream get stream => getAuthChange();
}
