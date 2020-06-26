import 'package:flutter/material.dart';
import 'package:yachtOne/managers/dialog_manager.dart';
import 'package:yachtOne/views/animation_test.dart';
import 'package:yachtOne/views/animation_test2.dart';
import 'package:yachtOne/views/home_view.dart';
import 'package:yachtOne/views/loading_view.dart';
import 'package:yachtOne/views/login_view.dart';
import 'package:yachtOne/views/register_view.dart';
import 'package:yachtOne/views/sliding_card.dart';
import 'package:yachtOne/views/startup_view.dart';
import 'package:yachtOne/views/vote2_view.dart';
import 'package:yachtOne/views/vote1_view.dart';
import 'package:yachtOne/views/vote_feed.dart';
import 'package:yachtOne/views/vote_select_view.dart';
import 'package:yachtOne/views/vote0_view.dart';

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
            return MaterialPageRoute(
                builder: (context) => DialogManager(child: HomeView()));
          case 'register':
            return MaterialPageRoute(
                builder: (context) => DialogManager(child: RegisterView()));
          case 'login':
            return MaterialPageRoute(
                builder: (context) => DialogManager(child: LoginView()));
          case 'voteSelect':
            return MaterialPageRoute(
                builder: (context) => DialogManager(
                    child: VoteSelectView(routeSettings.arguments)));
          case 'vote0':
            return MaterialPageRoute(
                builder: (context) =>
                    DialogManager(child: Vote0View(routeSettings.arguments)));
          case 'vote1':
            return MaterialPageRoute(
                builder: (context) =>
                    DialogManager(child: Vote1View(routeSettings.arguments)));
          case 'vote2':
            return MaterialPageRoute(
                builder: (context) =>
                    DialogManager(child: Vote2View(routeSettings.arguments)));
          case 'voteFeed':
            return MaterialPageRoute(
                builder: (context) => DialogManager(child: VoteFeed()));
          default:
            return MaterialPageRoute(
                builder: (context) => DialogManager(child: StartUpView()));
        }
      },
      home: DialogManager(child: StartUpView()),
    );
  }
}
