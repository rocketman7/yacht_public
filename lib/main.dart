import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:kakao_flutter_sdk/auth.dart';

import 'package:timezone/data/latest_all.dart' as tz;

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yachtOne/screens/home/home_view.dart';
import 'package:yachtOne/screens/quest/quest_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/services_binding.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import 'screens/chart/chart_view.dart';
import 'screens/test_view.dart';
import 'styles/size_config.dart';

void main() async {
  tz.initializeTimeZones();

  KakaoContext.clientId = "3134111f38ca4de5e56473f46942e27a";
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await MobileAds.instance.initialize();

// portrait 모드 고정
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MaterialApp(home: MyApp())));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // initMixpanel();
    // _connectionCheckService.checkConnection(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // 아이폰 프로 같은애들 기존에 지가 다크테마 쓰고있어서 스테이터스바 글씨색 하얀색일 경우를 위해

    // var lang = Localizations.localeOf(context).languageCode;
    // print("MAINLanguage is " + lang);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GetMaterialApp(
        enableLog: true,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        // home: StockInfoKrView(),

        getPages: [
          GetPage(
            name: '/',
            page: () => HomeView(),
          ),
          GetPage(
              name: 'stockInfo',
              // settings: RouteSettings(arguments: ),
              page: () => StockInfoKRView(),
              transition: Transition.zoom),
          GetPage(
              name: 'designSystem',
              page: () => YachtDesignSystem(),
              transition: Transition.zoom),
          GetPage(
              name: 'quest',
              page: () => QuestView(),
              transition: Transition.zoom)
        ],
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
      ),
    );
  }
}
