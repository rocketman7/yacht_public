import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AnimationTest extends StatefulWidget {
  @override
  _AnimationTestState createState() => _AnimationTestState();
}

class _AnimationTestState extends State<AnimationTest> {
  PageController pageController;
  double pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.8,
      keepPage: true,
    );
    pageController.addListener(() {
      setState(() {
        pageOffset = pageController.page;
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget redCard(int index) {
    return Container(
      width: 120,
      height: 180,
      child: Card(
        color: Colors.red[400],
        child: Text(index.toString(),
            style: TextStyle(
              fontSize: 35,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: 25,
          ),
          height: 420,
          child: PageView.builder(
            itemCount: 5,
            controller: pageController,
            itemBuilder: (context, index) => (redCard(index)),
          ),
        ),
      ),
    );
  }
}
