import 'package:flutter/material.dart';
import 'managers/dialog_manager.dart';
import 'router.dart';
import 'views/animation_test.dart';
import 'views/animation_test2.dart';
import 'views/register_view.dart';
import 'views/sliding_card.dart';
import 'views/startup_view.dart';

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
      onGenerateRoute: Router.generateRoute,
      home: DialogManager(child: StartUpView()),
    );
  }
}
