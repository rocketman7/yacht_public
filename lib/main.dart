import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/views/chart_view.dart';
import 'package:yachtOne/views/initial_view.dart';
import 'package:yachtOne/views/intro_view.dart';
import 'package:yachtOne/views/track_record_view.dart';
import 'managers/dialog_manager.dart';
import 'router.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// import 'views/animation_test.dart';
// import 'views/animation_test2.dart';
// import 'views/register_view.dart';
// import 'views/sliding_card.dart';
import 'services/connection_check_service.dart';
import 'views/startup_view.dart';

import 'locator.dart';
import 'services/navigation_service.dart';

import 'services/adManager_service.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() async {
  // tz.initializeTimeZones();
  // String koreaTimeZone = 'Asia/Seoul';

  // // print(tz.timeZoneDatabase.locations);
  // var localTime = DateTime.now();
  // var koreaTime =
  //     tz.TZDateTime.from(DateTime.now(), tz.getLocation(koreaTimeZone));
  // print('Local' + localTime.toString());

  tz.initializeTimeZones();
  var seoul = tz.getLocation('Asia/Seoul');
  var now = tz.TZDateTime.now(seoul);
  print("LOCAL" + DateTime.now().toString());
  print("SEOUL" + now.toString());

  // print('Korea' + koreaTime.toString());
  setupLocator();
  KakaoContext.clientId = "3134111f38ca4de5e56473f46942e27a";
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await FirebaseAdMob.instance.initialize(appId: AdManager.appId);

// portrait 모드 고정
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(home: MyApp())));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ConnectionCheckService _connectionCheckService =
      locator<ConnectionCheckService>();
  // final APP_STORE_URL =
  //     'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=YOUR-APP-ID&mt=8';
  // final PLAY_STORE_URL =
  //     'https://play.google.com/store/apps/details?id=YOUR-APP-ID';

  @override
  void initState() {
    super.initState();
    _connectionCheckService.checkConnection(context);
  }

  @override
  void dispose() {
    _connectionCheckService.listener.cancel();
    super.dispose();
  }

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
          print("MAINLanguage is " + lang);

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Theme(
              data: ThemeData(
                fontFamily: lang == 'en' ? 'DmSans' : 'AppleSD',
                primaryColor: Colors.white,
              ),
              child: navigator,
            ),
          );
        },
      ),
    );
  }
}
