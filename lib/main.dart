import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yachtOne/views/initial_view.dart';
import 'package:yachtOne/views/intro_view.dart';
import 'managers/dialog_manager.dart';
import 'router.dart';
// import 'views/animation_test.dart';
// import 'views/animation_test2.dart';
// import 'views/register_view.dart';
// import 'views/sliding_card.dart';
import 'views/startup_view.dart';

import 'locator.dart';
import 'services/navigation_service.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');
  @override
  Widget build(BuildContext context) {
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
        theme: ThemeData(primaryColor: Colors.white),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = Duration(seconds: 4);
    return Timer(_duration, navigationPage);
  }

  NavigationService _navigationService = locator<NavigationService>();

  void navigationPage() {
    _navigationService.navigateTo('initial');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return IntroView();
  }
}
