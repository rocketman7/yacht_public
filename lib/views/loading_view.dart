import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  // 애니메이션 컨트롤러, 애니메이션 선언
  AnimationController _aniController;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    var animationController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    );
    _aniController = animationController;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
            animation: _aniController.view,
            child: SvgPicture.asset(
              'assets/images/sailingYacht.svg',
              height: 130,
            ),
            builder: (context, child) {
              // translate는 offset 값에 tween을 넣어 child의 시작, 끝 위치 지정
              return Transform.translate(
                // offset: Offset(_animation.value * 150 + 130, 0),
                offset: Offset(128, 0),
                // angle: _controller.value * 2.0 * pi,
                child: Transform.rotate(
                  angle: sin(_animation.value * pi * 3) / 10,
                  child: Transform(
                    transform: Matrix4.rotationY(pi),
                    child: child,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
