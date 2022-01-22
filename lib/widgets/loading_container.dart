import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:flutter/src/painting/gradient.dart' as painting;
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class LoadingContainer extends StatefulWidget {
  final double? height;
  final double? width;
  final double radius;
  LoadingContainer({
    Key? key,
    this.height,
    this.width,
    required this.radius,
  }) : super(key: key);

  @override
  _LoadingContainerState createState() => _LoadingContainerState();
}

class _LoadingContainerState extends State<LoadingContainer> {
  RxDouble animator = 0.0.obs;
  @override
  void initState() {
    int i = 0;
    // TODO: implement initState
    Timer timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      animator(sin((pi / 180) * i).abs());
      i++;
      // print(sin((pi / 180) * i).abs());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            height: widget.height ?? double.infinity,
            width: widget.width ?? double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                gradient: painting.LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    yachtGrey.withOpacity(0.2),
                    yachtGrey.withOpacity(0.6),
                    yachtGrey.withOpacity(0.2),
                  ],
                  stops: [0.0, animator.value, 1.0],
                )),
          ),
        ),
      ],
    );
  }
}
