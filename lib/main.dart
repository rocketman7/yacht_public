import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      // key: navBarGlobalKey,
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: Routers.generateRoute,
      home: DialogManager(child: StartUpView(0)),
    );
  }
}
