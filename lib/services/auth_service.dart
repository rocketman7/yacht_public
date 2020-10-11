import 'dart:async';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import 'package:yachtOne/view_models/phone_auth_view_model.dart';
import 'package:yachtOne/views/phone_auth_view.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;

  final DatabaseService _databaseService = locator<DatabaseService>();
  final NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 현재 User 데이터를 user model에 넣어서 저장
  UserModel _currentUserModel;
  UserModel get currentUser => _currentUserModel;

  String _verificationId;
  String get verificationId => _verificationId;

  PhoneAuthCredential _authCredential;
  PhoneAuthCredential get authCredential => _authCredential;
  // Phone Auth
  Future sendPhoneAuthSms(String value, BuildContext context) async {
    // Firebase Auth의 verifyPhoneNumber method
    _auth.verifyPhoneNumber(
      phoneNumber: value,
      // 일부 안드로이드폰에서 사용자의 수동 입력없이 자동으로 verify되는 경우에만 아래 함수 trigger된다
      verificationCompleted: (credential) => {},
      verificationFailed: (e) => print(e.message),
      codeAutoRetrievalTimeout: (e) => print(e.characters),
      timeout: Duration(seconds: 120),
      // code 보내지면 아래 함수 call
      codeSent: (String verificationId, [int forceResendingToken]) {
        // how to send this 'verificationId' to the ViewModel
        // verificationId;
        _verificationId = verificationId;
      },
    );
  }

  Future verifySms(String code, String verificationId) async {
    print("verficationID is " + verificationId.toString());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: code,
    );

    // FirebaseApp fbWorkerApp =
    //     Firebase.apps['auth-worker'];
    // fbWorkerAuth = fbWorkerApp.auth();

    print(Firebase.apps.length);
    // await Firebase.initializeApp(
    //     name: 'SecondaryAppForTest',
    //     options: const FirebaseOptions(
    //       apiKey: 'AIzaSyCzZB2ckDu2dvKmtXjla3jV79cZeMDNoaY',
    //       appId: '1:122560218272:android:e495faa6a8ee5c3cedb5c5',
    //       messagingSenderId: '122560218272',
    //       projectId: 'yachtonesecondary',
    //     ));
// RejectedCredential
// Indicates that credential related request data is invalid.

// This can occur when there is a project number mismatch
// (sessionInfo, spatula header, temporary proof), an incorrect
// temporary proof phone number, or during game center sign in when
// the user is already signed into a different game center account.
    // FirebaseApp fbWorkerApp = Firebase.app('SecondaryAppForTest');
    // await fbWorkerApp.delete();

    // FirebaseAuth fbWorkerAuth = FirebaseAuth.instanceFor(app: fbWorkerApp);

    // fbWorkerAuth.signInWithCredential(credential).then((value) {
    //   print("SUCCESS");
    //   _navigationService.navigateWithArgTo('register', credential);
    // });

    // credential을 만들 때 code check하지 않고 signInWithCredential에서 체크
    await auth.signInWithCredential(credential).catchError((e) {
      print("ERROR CATCH" + e.message);
      credential = null;
      return credential;
    }).then((value) {
      // value = null;
      if (value != null) {
        // auth.signOut();
        _authCredential = credential;
        print("VALUE IS NOT NULL AND CREDENTIAL IS " +
            credential.toString() +
            auth.currentUser.uid); // auth.signOut();
        // print("SignOut");
        _navigationService.navigateWithArgTo('register', credential);
      }
    });

    // print(auth.currentUser.uid);
    // print(credential);
    // if (credential != null) {
    //   _navigationService.navigateWithArgTo('register', credential);
    // }
  }

  // 이메일 회원가입
  Future registerWithEmail({
    @required userName,
    @required email,
    @required password,
    @required PhoneAuthCredential phoneCredential,
  }) async {
    try {
      // final UserCredential authResult = await _auth
      //     .createUserWithEmailAndPassword(email: email, password: password);

      final credential =
          EmailAuthProvider.credential(email: email, password: password);

      print("Register: " + phoneCredential.toString());
      // AuthCredential emailCredential = EmailAuthProvider.credential(
      //   email: email,
      //   password: password,
      // );

      var user = auth.currentUser;
      print("UID" + auth.currentUser.uid);
      print(phoneCredential.smsCode);
      await user.linkWithCredential(credential);

      User _user = _auth.currentUser;
      String phoneNumber = _user.phoneNumber;
      var rng = Random();

      print("my Phone Number is " + phoneNumber);
      // User 정보 UserModel에 넣기
      _currentUserModel = UserModel(
        uid: user.uid,
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        combo: 0,
        friendsCode: null,
        item: 10,
        avatarImage: "avatar00" + rng.nextInt(9).toString(),
        accNumber: null,
        accName: null,
        secName: null,
      );

      // await authResult.user.sendEmailVerification();

      // Database에 User정보 넣기
      await _databaseService.createUser(_currentUserModel);

      // Register 성공하면 return true

      return (user != null);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'invalid-email':
          return "잘못된 이메일 형식입니다. 다시 확인해주세요.";
        case 'email-already-in-use':
          return "이미 가입된 이메일입니다.";
        default:
          print(e.message);
      }
    }
  }
  // 구글계정 회원가입

  // 이메일 로그인
  Future loginWithEmail({
    @required email,
    @required password,
  }) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 로그인 성공하면 return true
      return authResult.user != null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          print("ECODE" + e.code);
          return "잘못된 이메일 형식입니다. 다시 확인해주세요.";
        case 'wrong-password':
          print(e.code);
          return "비밀번호가 틀렸습니다.";
        case 'user-not-found':
          print(e.code);
          return "가입된 이메일 주소가 없습니다.";
        default:
          print(e.message);
      }
    }
  }
  // 구글계정 로그인

  Stream authState() {
    var user = _auth.authStateChanges();
    if (user == null) {
      _navigationService.navigateTo('login');
    }
    return null;
  }

  // 로그아웃
  Future signOut() async {
    await _auth.signOut();
  }

  // Reset 비밀번호

  // Update 유저
}
