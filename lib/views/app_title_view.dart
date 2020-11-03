import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yachtOne/services/api/base_auth_api.dart';
import 'package:yachtOne/services/api/firebase_kakao_auth_api.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:http/http.dart' as http;
import 'package:yachtOne/services/sharedPreferences_service.dart';

import '../locator.dart';
import 'constants/size.dart';

class AppTitleView extends StatefulWidget {
  @override
  _AppTitleViewState createState() => _AppTitleViewState();
}

class _AppTitleViewState extends State<AppTitleView> {
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
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
              GestureDetector(
                onTap: () {
                  _performSignIn(FirebaseKakaoAuthAPI());
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
                    "카카오계정으로 꾸욱 시작",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  FirebaseKakaoAuthAPI().signOut();
                  _authService.signOut();
                  // final HttpsCallable callable = CloudFunctions.instance
                  //     .getHttpsCallable(
                  //         functionName:
                  //             'helloWorld'); // 호출할 Cloud Functions 의 함수명
                  // // ..timeout = const Duration(seconds: 30); // 타임아웃 설정(옵션)

                  // String resp = "";
                  // final HttpsCallableResult result = await callable.call();
                  // print(resp);
                  // setState(() {
                  //   resp = result.data;
                  // });

                  // String url =
                  //     "https://asia-northeast3-ggook-5fb08.cloudfunctions.net/helloWorld";
                  // // showProgressSnackBar();
                  // var response = await http.get(url);

                  // print(response.body);
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
                    "카카오계정 로그아웃",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  _performSignIn(BaseAuthAPI api) async {
    bool succeed = false;

    setState(() {
      _isLoading = true;
    });

    try {
      var authResult = await api.signIn();
      succeed = true;
      print(authResult);
      if (authResult != null) {
        // setBusy(false);
        if (_authService.auth.currentUser != null) {
          print("CurrentUSER" + _authService.auth.currentUser.toString());
          // loggedIn 화면으로 route (HomeView)
          // _sharedPreferencesService.setSharedPreferencesValue(
          //     "twoFactor", true);
          // // bool isTwoFactorAuthed = await _sharedPreferencesService
          // //     .getSharedPreferencesValue('twoFactor', bool);
          // // print(isTwoFactorAuthed);
          // _navigationService.navigateTo(
          //   'startup',
          // );
        } else {
          print('Login Failure');
        }
      } else {
        // setBusy(false);
        // var dialogResult = await _dialogService.showDialog(
        //   title: '로그인 오류',
        //   description: authResult.toString(),
        // );
        print(authResult.toString());
      }
    } on PlatformException catch (e) {
      print("platform exception: $e");
      final snackBar = SnackBar(content: Text(e.message));
      Scaffold.of(context).showSnackBar(snackBar);
    } catch (e) {
      print("other exceptions: $e");
      final snackBar = SnackBar(content: Text(e));
      Scaffold.of(context).showSnackBar(snackBar);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    // if (succeed == true) {
    //   _sharedPreferencesService.setSharedPreferencesValue("twoFactor", true);
    //   _navigationService.navigateWithArgTo('startup', 0);
    // }

    return succeed;
  }
}
