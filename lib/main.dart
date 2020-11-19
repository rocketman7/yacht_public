import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:yachtOne/views/chart_view.dart';
import 'package:yachtOne/views/initial_view.dart';
import 'package:yachtOne/views/intro_view.dart';
import 'package:yachtOne/views/track_record_view.dart';
import 'managers/dialog_manager.dart';
import 'router.dart';
// import 'views/animation_test.dart';
// import 'views/animation_test2.dart';
// import 'views/register_view.dart';
// import 'views/sliding_card.dart';
import 'views/startup_view.dart';

import 'locator.dart';
import 'services/navigation_service.dart';

import 'services/adManager_service.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() async {
  setupLocator();
  KakaoContext.clientId = "3134111f38ca4de5e56473f46942e27a";
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseAdMob.instance.initialize(appId: AdManager.appId);

// portrait 모드 고정
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');
  @override
  Widget build(BuildContext context) {
    // 아이폰 프로 같은애들 기존에 지가 다크테마 쓰고있어서 스테이터스바 글씨색 하얀색일 경우를 위해
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.light,
    ));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        // showPerformanceOverlay: true,
        // key: navBarGlobalKey,
        navigatorKey: locator<NavigationService>().navigatorKey,
        onGenerateRoute: Routers.generateRoute,
        home: InitialView(),
        builder: (context, navigator) {
          var lang = Localizations.localeOf(context).languageCode;
          print("Language is " + lang);

          return Theme(
            data: ThemeData(
              fontFamily: lang == 'en' ? 'DmSans' : 'AppleSD',
              primaryColor: Colors.white,
            ),
            child: navigator,
          );
        },
      ),
    );
  }
}
