import 'package:flutter/material.dart';
import 'kakao_firebase_auth_api.dart';

class LoginView extends StatelessWidget {
  // const LoginView({Key? key}) : super(key: key);
  final KakaoFirebaseAuthApi _api = KakaoFirebaseAuthApi();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () async {
            await _api.signIn();
            // succeed = true;
            // print(authResult);
          },
          child: Text("카카오 로그인 "),
        )
      ],
    );
  }
}
