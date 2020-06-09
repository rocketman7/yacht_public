import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:yachtOne/view_models/login_view_model.dart';
import 'package:yachtOne/locator.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  // 애니메이션 컨트롤러, 애니메이션 선언
  AnimationController _aniController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    );
    // Tween은 _animation의 두 사이 값을 지정
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _aniController,
      ),
    );
    _aniController.repeat();
  }

  @override
  void dispose() {
    _aniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
