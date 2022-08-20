import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/yacht_design_system/yds_color.dart';

// 텍스트, 숫자 로딩 중에 쓰는 네모박스 그라데이션 위젯
class TextLoadingWidget extends StatefulWidget {
  TextLoadingWidget({
    Key? key,
    required this.height,
    required this.width,
  }) : super(key: key);

  final double height;
  final double width;

  @override
  State<TextLoadingWidget> createState() => _TextLoadingWidgetState();
}

class _TextLoadingWidgetState extends State<TextLoadingWidget> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 800),
  )..repeat(reverse: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        // tween: Tween(begin: 0.0, end: 1.0),
        // duration: Duration(milliseconds: 500),
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                yachtGrey,
                Color(0xff545758).withOpacity(.6),
                yachtGrey,
              ], stops: [
                0,
                _controller.value,
                1,
              ]),
            ),
            height: widget.height,
            width: widget.width,
            // color: yachtWhite,
          );
        });
  }
}
