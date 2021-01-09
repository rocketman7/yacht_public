import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LunchtimeEventView extends StatefulWidget {
  @override
  _LunchtimeEventViewState createState() => _LunchtimeEventViewState();
}

class _LunchtimeEventViewState extends State<LunchtimeEventView> {
  @override
  Widget build(BuildContext context) {
    //나중에 아래 Screen Util initial 주석처리
    ScreenUtil.init(context,
        designSize: Size(375, 812), allowFontScaling: true);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                  Color(0xFFC000C5),
                  Color(0xFFFF0057),
                  Color(0xFFFAA15E),
                  Color(0xFF91E0FD),
                  Color(0xFF91E0FD),
                  Color(0xFF2D5BFF)
                ],
                    stops: [
                  0.0,
                  0.167,
                  0.333,
                  0.55,
                  0.8,
                  1.0,
                ])),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AutoSizeText(
                    '점심시간 종가 예측 이벤트',
                    // "10월 12일 신성이엔지와 SK하이닉스중 더 많이 상승할 종목을 선택해주세요",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      letterSpacing: -0.5,
                      fontFamily: 'AppleSDM',
                    ),
                    maxLines: 3,
                    // fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    '오늘의 종가',
                    // "10월 12일 신성이엔지와 SK하이닉스중 더 많이 상승할 종목을 선택해주세요",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      letterSpacing: -0.5,
                      fontFamily: 'AppleSDM',
                    ),
                    maxLines: 3,
                    // fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
