import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;

  final DatabaseService _databaseService = locator<DatabaseService>();

  // 현재 User 데이터를 user model에 넣어서 저장
  UserModel _currentUser;
  UserModel get currentUser => _currentUser;

  // User 로그인여부 확인
  Future<bool> isUserLoggedIn() async {
    var user = await _auth.currentUser();

    // TODO: user정보 모델에 넣기

    // User 정보가 있으면 return true
    return user != null;
  }

  // 이메일 회원가입
  Future registerWithEmail({
    @required userName,
    @required email,
    @required password,
  }) async {
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // User 정보 UserModel에 넣기
      _currentUser = UserModel(
        uid: authResult.user.uid,
        userName: userName,
        email: email,
      );

      // Database에 User정보 넣기
      await _databaseService.createUser(_currentUser);

      // Register 성공하면 return true
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }
  // 구글계정 회원가입

  // 이메일 로그인
  Future loginWithEmail({
    @required email,
    @required password,
  }) async {
    try {
      var authResult = _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 로그인 성공하면 return true
      return authResult != null;
    } catch (e) {
      return e.message;
    }
  }

  // 구글계정 로그인

  // 로그아웃
  Future signOut() async {
    await _auth.signOut();
  }

  // Reset 비밀번호

  // Update 유저
}
