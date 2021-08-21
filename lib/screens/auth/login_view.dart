import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'kakao_firebase_auth_api.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginView extends StatelessWidget {
  // const LoginView({Key? key}) : super(key: key);
  final KakaoFirebaseAuthApi _kakaoAuthApi = KakaoFirebaseAuthApi();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () async {
            await _kakaoAuthApi.signIn();
            // succeed = true;
            // print(authResult);
          },
          child: Text("카카오 로그인 "),
        ),
        TextButton(
          onPressed: () async {
            await signInWithApple();
          },
          child: Text("Apple 로그인 "),
        )
      ],
    );
  }

  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    final authResult = await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    print('after apple signin: ${FirebaseAuth.instance.currentUser}');
    return authResult;
  }
}
