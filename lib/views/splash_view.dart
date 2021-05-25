import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yachtOne/services/navigation_service.dart';

import '../locator.dart';
import 'intro_view.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  NavigationService? _navigationService = locator<NavigationService>();

  void navigationPage() {
    _navigationService!.navigateTo('initial');
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
