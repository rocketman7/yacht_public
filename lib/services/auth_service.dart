import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:yachtOne/services/navigation_service.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;

  final DatabaseService _databaseService = locator<DatabaseService>();
  final NavigationService _navigationService = locator<NavigationService>();

  // 현재 User 데이터를 user model에 넣어서 저장
  UserModel _currentUserModel;
  UserModel get currentUser => _currentUserModel;

  // Phone Auth
  Future verifyPhoneNumber(String value, context) async {
    final TextEditingController _verificationCodeController =
        TextEditingController();
    // Firebase Auth의 verifyPhoneNumber method
    _auth.verifyPhoneNumber(
        phoneNumber: value,
        // 일부 안드로이드폰에서 사용자의 수동 입력없이 자동으로 verify되는 경우에만 아래 함수 trigger된다
        verificationCompleted: (credential) => {},
        verificationFailed: (e) => print(e.message),
        codeAutoRetrievalTimeout: (e) => print(e.characters),
        timeout: Duration(seconds: 60),
        // code 보내지면 아래 함수 call
        codeSent: (String verificationId, [int forceResendingToken]) {
          //show dialog to take input from the user
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Text("Enter SMS Code"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _verificationCodeController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Confirm"),
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        onPressed: () async {
                          final String code =
                              _verificationCodeController.text.trim();

                          print(
                              "verficationID is " + verificationId.toString());
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);

                          print(credential);
                          // UserCredential result =
                          //     await _auth.signInWithCredential(credential);

                          // User user = result.user;
                          print("After Signin " + credential.toString());
                          // print(result.user);
                          if (credential != null) {
                            Navigator.pop(context);
                            _navigationService.navigateWithArgTo(
                                'register', credential);
                          }
                        },
                      )
                    ],
                  ));
        });
  }

  // 이메일 회원가입
  Future registerWithEmail({
    @required userName,
    @required email,
    @required password,
    @required AuthCredential phoneCredential,
  }) async {
    try {
      final UserCredential authResult = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // AuthCredential emailCredential = EmailAuthProvider.credential(
      //   email: email,
      //   password: password,
      // );

      await authResult.user.linkWithCredential(phoneCredential);

      User _user = _auth.currentUser;
      String phoneNumber = _user.phoneNumber;
      print("my Phone Number is " + phoneNumber);
      // User 정보 UserModel에 넣기
      _currentUserModel = UserModel(
        uid: authResult.user.uid,
        userName: userName,
        email: email,
        phoneNumber: phoneNumber,
        combo: 0,
      );

      // await authResult.user.sendEmailVerification();

      // Database에 User정보 넣기
      await _databaseService.createUser(_currentUserModel);

      // Register 성공하면 return true
      return authResult.user != null;
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
