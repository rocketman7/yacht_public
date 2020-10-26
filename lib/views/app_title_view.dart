import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yachtOne/services/api/base_auth_api.dart';
import 'package:yachtOne/services/api/firebase_kakao_auth_api.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/navigation_service.dart';

import '../locator.dart';
import 'constants/size.dart';

class AppTitleView extends StatefulWidget {
  @override
  _AppTitleViewState createState() => _AppTitleViewState();
}

class _AppTitleViewState extends State<AppTitleView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    deviceHeight = size.height;
    deviceWidth = size.width;
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: deviceHeight * .05,
              ),
              Text(
                "주식예측\n퀴즈앱 꾸욱",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: deviceHeight * .35,
              ),
              GestureDetector(
                onTap: () {
                  _navigationService.navigateTo('login');
                },
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                    color: Color(0xFFF7F6F7),
                  ),
                  child: Text(
                    "이메일로 꾸욱 시작",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // GestureDetector(
              //   onTap: () {
              //     _performSignIn(FirebaseKakaoAuthAPI());
              //   },
              //   child: Container(
              //     height: 48,
              //     alignment: Alignment.center,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(
              //         8,
              //       ),
              //       color: Color(0xFFF7F6F7),
              //     ),
              //     child: Text(
              //       "카카오계정으로 꾸욱 시작",
              //       style: TextStyle(
              //         fontSize: 16,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10),
              // GestureDetector(
              //   onTap: () {
              //     FirebaseKakaoAuthAPI().signOut();
              //   },
              //   child: Container(
              //     height: 48,
              //     alignment: Alignment.center,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(
              //         8,
              //       ),
              //       color: Color(0xFFF7F6F7),
              //     ),
              //     child: Text(
              //       "카카오계정 로그아웃",
              //       style: TextStyle(
              //         fontSize: 16,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ));
  }

  // _performSignIn(BaseAuthAPI api) async {
  //   bool succeed = false;

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   try {
  //     await api.signIn();
  //     succeed = true;
  //   } on PlatformException catch (e) {
  //     print("platform exception: $e");
  //     final snackBar = SnackBar(content: Text(e.message));
  //     Scaffold.of(context).showSnackBar(snackBar);
  //   } catch (e) {
  //     print("other exceptions: $e");
  //     final snackBar = SnackBar(content: Text(e));
  //     Scaffold.of(context).showSnackBar(snackBar);
  //   }

  //   if (mounted) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   }

  //   return succeed;
  // }
}
