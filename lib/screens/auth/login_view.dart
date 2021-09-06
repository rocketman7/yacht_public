import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/screens/auth/email_register_view.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'kakao_firebase_auth_api.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatelessWidget {
  // const LoginView({Key? key}) : super(key: key);
  final KakaoFirebaseAuthApi _kakaoAuthApi = KakaoFirebaseAuthApi();
  final RxBool isKakaoLoggingIn = false.obs;
  final RxBool isAppleLoggingIn = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: yachtViolet,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: Image.asset(
                    'assets/logos/yacht_white.png',
                    height: 115.w,
                  ),
                ),
              ),
            ),
            Obx(
              () => InkWell(
                onTap: () async {
                  if (!isKakaoLoggingIn.value && !isAppleLoggingIn.value) {
                    isKakaoLoggingIn(true);
                    await _kakaoAuthApi.signIn();
                    isKakaoLoggingIn(false);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: socialLoginContainer(
                      logo: Image.asset(
                        'assets/logos/kakao_black_with_paddings.png',
                        width: 30.w,
                        height: 30.w,
                      ),
                      title: isKakaoLoggingIn.value
                          ? CircularProgressIndicator(
                              color: socialLogin.color,
                            )
                          : Text(
                              '카카오로 시작하기',
                              style: socialLogin,
                            ),
                      loginBackgroundColor: Color(0xFFFEE500)),
                ),
              ),
            ),
            SizedBox(
              height: 10.w,
            ),
            Obx(() => InkWell(
                  onTap: () async {
                    if (!isKakaoLoggingIn.value && !isAppleLoggingIn.value) {
                      isAppleLoggingIn(true);
                      await signInWithApple();
                      isAppleLoggingIn(false);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: socialLoginContainer(
                        logo: Image.asset(
                          'assets/logos/apple_white_with_paddings.png',
                          width: 30.w,
                          height: 30.w,
                        ),
                        title: isAppleLoggingIn.value
                            ? CircularProgressIndicator(
                                color: white,
                              )
                            : Text(
                                'Apple로 시작하기',
                                style: socialLogin.copyWith(color: white),
                              ),
                        loginBackgroundColor: Colors.black),
                  ),
                )),
            SizedBox(
              height: 16.w,
            ),
            Container(
              padding: EdgeInsets.only(bottom: 6.w),
              // height: 26.w,
              // width: ,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.w, color: white),
                ),
              ),
              child: InkWell(
                onTap: () {
                  Get.toNamed('/emailRegister');
                },
                child: Text(
                  " 이메일로 시작하기 ",
                  style: socialLogin.copyWith(color: white),
                ),
              ),
            ),
            SizedBox(
              height: 50.w,
            )
          ],
        ),
      ),
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
