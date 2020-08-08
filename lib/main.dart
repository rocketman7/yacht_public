import 'package:flutter/material.dart';
import 'package:yachtOne/managers/dialog_manager.dart';
import 'package:yachtOne/router.dart';
import 'package:yachtOne/views/animation_test.dart';
import 'package:yachtOne/views/animation_test2.dart';
import 'package:yachtOne/views/register_view.dart';
import 'package:yachtOne/views/sliding_card.dart';
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
      onGenerateRoute: Router.generateRoute,
      home: DialogManager(child: StartUpView()),
    );
  }
}
