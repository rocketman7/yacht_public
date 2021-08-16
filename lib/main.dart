import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'package:kakao_flutter_sdk/auth.dart';

import 'package:timezone/data/latest_all.dart' as tz;

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yachtOne/screens/auth/auth_check_view.dart';
import 'package:yachtOne/screens/home/home_view.dart';
import 'package:yachtOne/screens/quest/quest_view.dart';
import 'package:yachtOne/screens/startup/startup_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/services_binding.dart';
import 'package:yachtOne/styles/theme.dart';
import 'package:yachtOne/styles/yacht_design_system_sample_view.dart';

import 'locator.dart';
import 'models/corporation_model.dart';
import 'screens/award/award_view.dart';
import 'screens/award_old/award_viewOld.dart';
import 'screens/stock_info/chart/chart_view.dart';
import 'screens/subLeague/subLeague_view.dart';
import 'screens/subLeague/temp_home_view.dart';
import 'screens/test_view.dart';
import 'styles/size_config.dart';

import 'screens/subLeague/subLeague_controller.dart';

void main() async {
  tz.initializeTimeZones();
  setupLocator();

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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    SizeConfig().init(context);
    ScreenUtil.init(
        BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: MediaQuery.of(context).size.height),
        designSize: Size(375, 812),
        orientation: Orientation.portrait);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');
  @override
  Widget build(BuildContext context) {
    // 아이폰 프로 같은애들 기존에 지가 다크테마 쓰고있어서 스테이터스바 글씨색 하얀색일 경우를 위해
    // print("MyApp built");
    // var lang = Localizations.localeOf(context).languageCode;
    // print("MAINLanguage is " + lang);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GetMaterialApp(
        theme: theme(),
        enableLog: true,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        // home: StockInfoKrView(),

        getPages: [
          GetPage(
            name: '/',
            page: () => AuthCheckView(),
          ),
          // GetPage(
          //     name: 'stockInfo',
          //     // settings: RouteSettings(arguments: ),
          //     page: () => StockInfoKRView(
          //           bottomPadding: 0,
          //         field: f,
          //         ),
          //     transition: Transition.zoom),
          GetPage(
              name: 'designSystem',
              page: () => YachtDesignSystemSampleView(),
              transition: Transition.zoom),
          GetPage(
              name: 'quest',
              page: () => QuestView(),
              transition: Transition.zoom),
          // GetPage(
          //     name: 'award',
          //     page: () => AwardView(),
          //     transition: Transition.rightToLeft),
          GetPage(
              name: 'awardold',
              page: () => AwardOldView(),
              transition: Transition.rightToLeft),
          // GetPage(
          //     name: 'tempHome',
          //     page: () => TempHomeView(leagueName: '7월',),
          //     transition: Transition.rightToLeft),
          GetPage(
            name: 'subLeague',
            page: () => SubLeagueView(),
            transition: Transition.rightToLeft,
            binding: BindingsBuilder(() {
              // Get.lazyPut<SubLeagueController>(() => SubLeagueController());
              // Get.put(SubLeagueController());
              Get.put(HomeRepository());
            }),
          ),
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
