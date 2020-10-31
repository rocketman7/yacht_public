import 'dart:math';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:kakao_flutter_sdk/user.dart' as Kakao;
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:yachtOne/services/database_service.dart';
import '../../locator.dart';
import 'base_auth_api.dart';
import 'dart:convert';

class FirebaseKakaoAuthAPI implements BaseAuthAPI {
  DatabaseService _databaseService = locator<DatabaseService>();
  FirebaseKakaoAuthAPI();

  AuthService _authService = locator<AuthService>();
  static const String providerId = 'kakaocorp.com';

  @override
  Future<UserCredential> signIn() async {
    try {
      print("KaKao Sign in started");
      final String token = await _retrieveToken();
      print(token);
      final String verifiedToken = await _verifyToken(token);
      print(verifiedToken);
      final authResult =
          await _authService.auth.signInWithCustomToken(verifiedToken);

      final User firebaseUser = authResult.user;
      final User currentUser = _authService.auth.currentUser;
      assert(firebaseUser.uid == currentUser.uid);

      await _updateEmailInfo(firebaseUser);
      var userDatabase = await _databaseService.getUser(currentUser.uid);
      if (userDatabase == null) {
        var rng = Random();
        UserModel _currentUserModel = UserModel(
          uid: firebaseUser.uid,
          userName: firebaseUser.displayName,
          email: firebaseUser.email,
          phoneNumber: firebaseUser.phoneNumber,
          friendsCode: null,
          item: 10,
          avatarImage: "avatar00" + (rng.nextInt(9) + 1).toString(),
          accNumber: null,
          accName: null,
          secName: null,
        );

        // await authResult.user.sendEmailVerification();

        // Database에 User정보 넣기
        await _databaseService.createUser(_currentUserModel);
      }

      return authResult;
    } on KakaoAuthException catch (e) {
      return Future.error(e);
    } on KakaoClientException catch (e) {
      return Future.error(e);
    } catch (e) {
      if (e.toString().contains("already in use")) {
        return Future.error(PlatformException(
            code: "ERROR_EMAIL_ALREADY_IN_USE",
            message: "The email address is already in use by another account"));
      }
      return Future.error(e);
    }
  }

  Future<String> _retrieveToken() async {
    final installed = await isKakaoTalkInstalled();
    final authCode = installed
        ? await AuthCodeClient.instance.requestWithTalk()
        : await AuthCodeClient.instance.request();
    AccessTokenResponse token =
        await AuthApi.instance.issueAccessToken(authCode);

    await AccessTokenStore.instance.toStore(
        token); // Store access token in AccessTokenStore for future API requests.
    return token.accessToken;
  }

  Future<void> _updateEmailInfo(User firebaseUser) async {
    // When sign in is done, update email info.
    Kakao.User kakaoUser = await Kakao.UserApi.instance.me();
    if (kakaoUser.kakaoAccount.email.isNotEmpty) {
      firebaseUser.updateEmail(kakaoUser.kakaoAccount.email);
    }
  }

  Future<String> _verifyToken(String kakaoToken) async {
    try {
      print("start calling");
      final HttpsCallable callable = CloudFunctions(region: 'asia-northeast3')
          .getHttpsCallable(functionName: 'verifyKakaoToken');

      print("callable function made");
      final HttpsCallableResult result = await callable.call(
        {
          'token': kakaoToken,
        },
      );
      // String url =
      //     "https://asia-northeast3-ggook-5fb08.cloudfunctions.net/verifyKakaoToken";
      // // final HttpsCallableResult result = await CloudFunctions.instance
      // //     .getHttpsCallable(functionName: 'helloWorld')
      // //     .call();

      // Map data = {"token": kakaoToken};
      // var body = json.encode(data);
      // var result = await http.post(
      //   url,
      //   headers: {"Content-Type": "application/x-www-form-urlencoded"},
      //   body: {'token': kakaoToken},
      // );

      // CloudFunctions.instance.
      print(result.data);

      if (result.data['error'] != null) {
        return Future.error(result.data['error']);
      } else {
        return result.data['token'];
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  /// Kakao API does not need sign up.
  @override
  Future<UserCredential> signUp() {
    return Future.error(PlatformException(
        code: "UNSUPPORTED_FUNCTION",
        message: "Kakao Signin does not need sign up."));
  }

  @override
  Future<void> signOut() {
    AccessTokenStore.instance.clear();
    return Future.value("");
  }

  @override
  Future<User> linkWith(User user) async {
    try {
      final token = await _retrieveToken();

      final HttpsCallable callable = CloudFunctions.instance
          .getHttpsCallable(functionName: 'linkWithKakao')
            ..timeout = const Duration(seconds: 30);

      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'token': token,
        },
      );

      if (result.data['error'] != null) {
        return Future.error(result.data['error']);
      } else {
        User user = _authService.auth.currentUser;

        // Update email info if possible.
        await _updateEmailInfo(user);

        return user;
      }
    } on KakaoAuthException catch (e) {
      return Future.error(e);
    } on KakaoClientException catch (e) {
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> unlinkFrom(User user) async {
    try {
      await user.unlink("kakaocorp.com");
    } catch (e) {
      throw Future.error(e);
    }
  }
}
