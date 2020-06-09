import 'package:flutter/material.dart';
import 'package:yachtOne/views/home_view.dart';
import 'package:yachtOne/views/login_view.dart';
import 'package:yachtOne/views/register_view.dart';
import 'package:yachtOne/views/startup_view.dart';

import 'locator.dart';
import 'services/navigation_service.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: (routeSettings) {
        switch (routeSettings.name) {
          // navigation service에서 접근할 route이름들 view설정
          case 'loggedIn':
            return MaterialPageRoute(builder: (context) => HomeView());
          case 'register':
            return MaterialPageRoute(builder: (context) => RegisterView());
          case 'login':
            return MaterialPageRoute(builder: (context) => LoginView());
          default:
            return MaterialPageRoute(builder: (context) => StartUpView());
        }
      },
      home: StartUpView(),
    );
  }
}
