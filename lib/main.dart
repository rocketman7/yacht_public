import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_segment/flutter_segment.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/views/chart_view.dart';
import 'package:yachtOne/views/initial_view.dart';
import 'package:yachtOne/views/intro_view.dart';
import 'package:yachtOne/views/lunchtime_event_view.dart';
import 'package:yachtOne/views/test_home_view.dart';
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
import 'views/constants/theme.dart';
import 'views/constants/view_constants.dart';
import 'views/startup_view.dart';

import 'locator.dart';
import 'services/navigation_service.dart';

import 'services/adManager_service.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

void main() async {
  tz.initializeTimeZones();
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
  // Mixpanel mixpanel;
  // final APP_STORE_URL =
  //     'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=YOUR-APP-ID&mt=8';
  // final PLAY_STORE_URL =
  //     'https://play.google.com/store/apps/details?id=YOUR-APP-ID';

  // Future<void> initMixpanel() async {
  //   mixpanel = await Mixpanel.init("afd70bf6950f6a48c4c38856b667dffd",
  //       optOutTrackingDefault: false);
  // }

  @override
  void initState() {
    super.initState();
    // initMixpanel();
    // _connectionCheckService.checkConnection(context);
  }

  @override
  void dispose() {
    _connectionCheckService.listener.cancel();
    super.dispose();
  }

  // GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');
  @override
  Widget build(BuildContext context) {
    Segment.screen(
      screenName: 'Test Screen for main.dart',
    );

    // 아이폰 프로 같은애들 기존에 지가 다크테마 쓰고있어서 스테이터스바 글씨색 하얀색일 경우를 위해
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.blue, // navigation bar color
      statusBarColor: Colors.pink,
      // statusBarColor: Colors.white,
      statusBarBrightness: Brightness.light,
    ));
    // var lang = Localizations.localeOf(context).languageCode;
    // print("MAINLanguage is " + lang);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        theme: theme(),
        debugShowCheckedModeBanner: false,

        // showPerformanceOverlay: true,
        // key: navBarGlobalKey,
        // navigatorKey: locator<NavigationService>().navigatorKey,
        // onGenerateRoute: Routers.generateRoute,
        home: TestHomeView(),
        // textDirection: TextDirection.LTR,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child,
          );
        },
      ),
    );
  }
}
