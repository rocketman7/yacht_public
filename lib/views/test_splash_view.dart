import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestSplashView extends StatefulWidget {
  @override
  _TestSplashViewState createState() => _TestSplashViewState();
}

class _TestSplashViewState extends State<TestSplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);

    _animation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.10))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          child: SlideTransition(
        position: _animation,
        child: SvgPicture.asset(
          'assets/images/sailingYacht.svg',
          height: 120,
        ),
      )),
    ));
  }
}
