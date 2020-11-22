import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    double containerHeight = deviceHeight * .09;
    double sizedBoxHeight = deviceHeight * .018;

    TextStyle titleStyleWhite = TextStyle(
      fontSize: 28,
      fontFamily: 'AppleSDB',
      color: Colors.white,
      // height: 1,
    );

    TextStyle titleStyleBlack = TextStyle(
      fontSize: 28,
      fontFamily: 'AppleSDB',
      color: Colors.black,
      // height: 1,
    );

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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: [
                  // Row(
                  //   children: <Widget>[
                  //     Container(
                  //       width: 120,
                  //       height: containerHeight,
                  //       decoration: BoxDecoration(
                  //           border: Border.all(
                  //             width: 4.0,
                  //             color: Color(0xFF1EC8CF),
                  //           ),
                  //           borderRadius: BorderRadius.circular(
                  //             40,
                  //           )),
                  //     ),
                  //     SizedBox(width: 8),
                  //     Expanded(
                  //       flex: 1,
                  //       child: Container(
                  //         // width: 50,
                  //         height: containerHeight,
                  //         decoration: BoxDecoration(
                  //             border: Border.all(
                  //               width: 4.0,
                  //               color: Color(0xFF2E57BA),
                  //             ),
                  //             borderRadius: BorderRadius.circular(
                  //               40,
                  //             )),
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: containerHeight,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 4.0,
                              color: Color(0xFFCD859C),
                            ),
                            borderRadius: BorderRadius.circular(
                              40,
                            )),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        flex: 1,
                        child: Container(
                          // width: 50,
                          height: containerHeight,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 4.0,
                                color: Color(0xFF427D6A),
                              ),
                              borderRadius: BorderRadius.circular(
                                40,
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sizedBoxHeight),
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                        ),
                        width: 150,
                        height: containerHeight,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFD601),
                          borderRadius: BorderRadius.circular(
                            40,
                          ),
                        ),
                        child: Text(
                          "주식예측",
                          style: titleStyleBlack,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Container(
                          // width: 50,
                          height: containerHeight,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 4.0,
                                color: Color(0xFFD17F2C),
                              ),
                              borderRadius: BorderRadius.circular(
                                40,
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sizedBoxHeight),
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                          horizontal: 22,
                        ),
                        width: 230,
                        height: containerHeight,
                        decoration: BoxDecoration(
                          color: Color(0xFF2E57B9),
                          borderRadius: BorderRadius.circular(
                            40,
                          ),
                        ),
                        child: Text(
                          "퀴즈앱",
                          style: titleStyleWhite,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Container(
                          // width: 50,
                          height: containerHeight,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 4.0,
                                color: Color(0xFFD17F2C),
                              ),
                              borderRadius: BorderRadius.circular(
                                40,
                              )),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sizedBoxHeight),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(
                            horizontal: 22,
                          ),
                          // width: 230,
                          height: containerHeight,
                          decoration: BoxDecoration(
                            color: Color(0xFF1EC8CF),
                            borderRadius: BorderRadius.circular(
                              40,
                            ),
                          ),
                          child: Text(
                            "꾸욱",
                            style: titleStyleWhite,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                          width: containerHeight,
                          height: containerHeight,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 4.0,
                                color: Color(0xFFB063E2),
                              ),
                              borderRadius: BorderRadius.circular(
                                40,
                              )),
                          child: SvgPicture.asset(
                            'assets/icons/dog_foot.svg',
                          )),
                    ],
                  ),

                  SizedBox(height: sizedBoxHeight),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: containerHeight,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 4.0,
                              color: Color(0xFFCD859C),
                            ),
                            borderRadius: BorderRadius.circular(
                              40,
                            )),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: containerHeight,
                        height: containerHeight,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 4.0,
                              color: Color(0xFF2E57B9),
                            ),
                            borderRadius: BorderRadius.circular(
                              40,
                            )),
                        child: SvgPicture.asset(
                          'assets/icons/dog_foot.svg',
                          color: Color(0xFF2E57B9),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Container(
                          // width: 50,
                          height: containerHeight,
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 4.0,
                                color: Color(0xFF427D6A),
                              ),
                              borderRadius: BorderRadius.circular(
                                40,
                              )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // SizedBox(
              //   height: deviceHeight * .05,
              // ),
              // Text(
              //   "주식예측\n퀴즈앱 꾸욱",
              //   style: TextStyle(
              //     fontSize: 40,
              //     fontWeight: FontWeight.w700,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // SizedBox(
              //   height: deviceHeight * .35,
              // ),
              // GestureDetector(
              //   onTap: () {
              //     _navigationService.navigateTo('login');
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
              //       "이메일로 꾸욱 시작",
              //       style: TextStyle(
              //         fontSize: 16,
              //       ),
              //     ),
              //   ),
              // ),

              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _performSignIn(FirebaseKakaoAuthAPI());
                },
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                    color: Color(0xFFFFEB04),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Image(
                                alignment: Alignment.center,
                                image:
                                    AssetImage('assets/icons/kakao_logo.png'),
                                height: 20,
                              ),
                            ),
                            Text(
                              "카카오계정으로 꾸욱 시작",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'AppleSDM',
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 10),

              // GestureDetector(
              //   onTap: () async {
              //     FirebaseKakaoAuthAPI().signOut();
              //     _authService.signOut();
              //     // final HttpsCallable callable = CloudFunctions.instance
              //     //     .getHttpsCallable(
              //     //         functionName:
              //     //             'helloWorld'); // 호출할 Cloud Functions 의 함수명
              //     // // ..timeout = const Duration(seconds: 30); // 타임아웃 설정(옵션)

              //     // String resp = "";
              //     // final HttpsCallableResult result = await callable.call();
              //     // print(resp);
              //     // setState(() {
              //     //   resp = result.data;
              //     // });

              //     // String url =
              //     //     "https://asia-northeast3-ggook-5fb08.cloudfunctions.net/helloWorld";
              //     // // showProgressSnackBar();
              //     // var response = await http.get(url);

              //     // print(response.body);
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
