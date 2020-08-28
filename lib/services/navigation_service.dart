import 'package:flutter/material.dart';

class NavigationService {
  // In Flutter GlobalKeys can be used to access the state of a StatefulWidget and
  // that's what we'll use to access the NavigatorState outside of the build context.
  // We'll create a NavigationService that contains the global key, we'll set that key on initialization
  // and we'll expose a function on the service to navigate given a name. Let's start with the NavigationService.

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Navagation Service를 설정하여 context가 없는 class에서도 다른 페이지로 route 가능하게 만든다.
  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> navigateWithArgTo(String routeName, var argument) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: argument);
  }

  Future<dynamic> popAndNavigateWithArgTo(String routeName, var argument) {
    return navigatorKey.currentState
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }

  // Future<dynamic> popAndNavigateWithArgTo(String routeName, var argument) {
  //   return navigatorKey.currentState.
  // }
}
