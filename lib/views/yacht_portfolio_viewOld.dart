import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:math' as math;

import 'package:yachtOne/views/constants/size.dart';
import '../view_models/yacht_portfolio_view_model.dart';

// 필요한 const 및 dummy model을 아래에. const는 나중에 어플 통합 const로서 관리되면 더 좋고
// dummy model 도 실제 model 이 되어 DB로 관리할 수 있어야 함.
const double heightForSliverFlexibleSpace =
    kToolbarHeight + 220.0; // 당연히 기기마다 달라져야함. SliverFlexibleSpace를 위한 height
const double paddingForRewardText = 8.0; // 상금 주식 가치 텍스트 위의 패딩(마진)
const Color sliverAppBarColor = Color(0xFFD9D9D9);
const Color backgroundColor = Colors.white;

// fontSize가 n이라면 그 높이는 height가 n인 Container와 유사하다.

class YachtPortfolioViewOld extends StatelessWidget {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<YachtPortfolioViewModel>.reactive(
        viewModelBuilder: () => YachtPortfolioViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                ScrollAnimationForSliverAppBar(
                  scrollController: _scrollController,
                  zeroOpacityOffset: paddingForRewardText +
                      20, // kToolbarHeight 다음부터의 offset. 즉 상금 텍스트 위의 공간만큼 주어야 함
                  fullOpacityOffset: paddingForRewardText +
                      20 +
                      50, // zeroOpacityOffset으로부터 상금 텍스트의 height 가량을 더한, 타이틀이 완전히 보여야 하는 위치로 설정해주어야함. 대략 4-50이면 될듯. 이거는 그냥 대략적인 수치로 갈음해도 자연스러울듯
                ),
                buildPortfolioViewBody(),
              ],
            ),
          );
        });
  }

  Widget buildPortfolioViewBody() => SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32.0,
                ),
                Text(
                  '요트 점수 Top3',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontFamily: 'AppleSDB'),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '4월 한 달간',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'AppleSDM'),
                      ),
                      Text(
                        '가장 많은 요트 점수를 얻으신 세 분,',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'AppleSDM'),
                      ),
                      Text(
                        '상금 주식 받아가세요!',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'AppleSDM'),
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        '상금 주식의 가치는 2021.4.26 종가기준',
                        style: TextStyle(
                            color: Color(0xFF929292),
                            fontSize: 14,
                            fontFamily: 'AppleSDL'),
                      ),
                      Row(
                        children: [
                          Text(
                            '공동우승 시 상금을 공평하게 나눠드려요!',
                            style: TextStyle(
                                color: Color(0xFF929292),
                                fontSize: 14,
                                fontFamily: 'AppleSDB'),
                          ),
                          Text(
                            '예를 들어, 우승자',
                            style: TextStyle(
                                color: Color(0xFF929292),
                                fontSize: 14,
                                fontFamily: 'AppleSDL'),
                          ),
                        ],
                      ),
                      Text(
                        '가 2명이라면... 등 text가 어떻든 바로 적용할 수 있게 코드 수정 필요.',
                        style: TextStyle(
                            color: Color(0xFF929292),
                            fontSize: 14,
                            fontFamily: 'AppleSDL'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '상금 주식 포트폴리오',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontFamily: 'AppleSDB'),
                    ),
                    Spacer(),
                    Text(
                      '2021.4.26종가기준',
                      style: TextStyle(
                          color: Color(0xFF929292),
                          fontSize: 14,
                          fontFamily: 'AppleSDL'),
                    ),
                  ],
                ),
                SizedBox(
                  height: 24.0,
                ),
                /*Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF4F77F7),
                  ),
                  height: deviceWidth - 32.0,
                  width: deviceWidth - 32.0,
                ),*/
                makePortfolioArc(),
                SizedBox(
                  height: 12.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFF4F77F7).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                )),
                            child: Text(
                              '삼성전자',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'AppleSDM'),
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 0.5,
                              color: Color(0xFF989898),
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            '30주',
                            style: TextStyle(
                                color: Color(0xFF989898),
                                fontSize: 14,
                                fontFamily: 'AppleSDB'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFF5399E0).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                )),
                            child: Text(
                              '우리기술투자',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'AppleSDM'),
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 0.5,
                              color: Color(0xFF989898),
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            '6주',
                            style: TextStyle(
                                color: Color(0xFF989898),
                                fontSize: 14,
                                fontFamily: 'AppleSDB'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFF48BADD).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                )),
                            child: Text(
                              'NHN한국사이버결제',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'AppleSDM'),
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 0.5,
                              color: Color(0xFF989898),
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            '18주',
                            style: TextStyle(
                                color: Color(0xFF989898),
                                fontSize: 14,
                                fontFamily: 'AppleSDB'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 4,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xFF4CEDE9).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                )),
                            child: Text(
                              '한국타이어앤테크놀로지',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'AppleSDM'),
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 0.5,
                              color: Color(0xFF989898),
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            '12주',
                            style: TextStyle(
                                color: Color(0xFF989898),
                                fontSize: 14,
                                fontFamily: 'AppleSDB'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '10,128,400원 (',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontFamily: 'AppleSDB'),
                            ),
                            Text(
                              '+3.94%',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 26,
                                  fontFamily: 'AppleSDB'),
                            ),
                            Text(
                              ')',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontFamily: 'AppleSDB'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.0,
                      ),
                      Center(
                        child: Text(
                          '상금 주식 포트폴리오 총 가치 (누적 수익률)',
                          style: TextStyle(
                              color: Color(0xFF989898),
                              fontSize: 12,
                              fontFamily: 'AppleSDL'),
                        ),
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '상금 주식',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 26,
                                fontFamily: 'AppleSDB'),
                          ),
                          Spacer(),
                          Text(
                            '2021.4.26종가기준',
                            style: TextStyle(
                                color: Color(0xFF929292),
                                fontSize: 14,
                                fontFamily: 'AppleSDL'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 36,
                          // horizontal: 4,
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xFFFFDE30),
                            borderRadius: BorderRadius.circular(
                              15.0,
                            )),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '100%',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 36,
                                    fontFamily: 'AppleSDEB'),
                              ),
                              SizedBox(
                                height: 0.0,
                              ),
                              Text(
                                '카카오',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'AppleSDM'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                    ],
                  ),
                ),
                Text(
                  '코멘트',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 26,
                      fontFamily: 'AppleSDB'),
                ),
                Row(
                  children: [
                    Text(
                      '46 %',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontFamily: 'AppleSDEB'),
                    ),
                    Container(height: 22, width: 10, color: Colors.black),
                    Text(
                      '46%',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'AppleSDEB'),
                    ),
                    Container(height: 14, width: 10, color: Colors.black),
                    Container(height: 26, width: 10, color: Colors.black),
                  ],
                )
              ],
            ),
          )
        ]),
      );

  Widget makePortfolioArc() {
    double portfolioArcRadius = deviceWidth - 32;
    double portfolioArcRadiusCenter = 75 * deviceWidth / 375;

    return Container(
      width: portfolioArcRadius,
      height: portfolioArcRadius,
      child: Stack(
        children: makePortfolioArcComponents(
            portfolioArcRadius, portfolioArcRadiusCenter),
      ),
    );
  }

  List<Widget> makePortfolioArcComponents(
      double portfolioArcRadius, double portfolioArcRadiusCenter) {
    List<Widget> result = [];

    result.add(GestureDetector(
      onTap: () {
        print('1번째 component tap');
      },
      child: CustomPaint(
        size: Size(portfolioArcRadius, portfolioArcRadius),
        painter: PortfolioArcChart(
            center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
            color: '4F77F7',
            percentage1: 0.0,
            percentage2: 46.0),
      ),
    ));

    //result.add(Positioned());

    result.add(GestureDetector(
      onTap: () {
        print('2번째 component tap');
      },
      child: CustomPaint(
        size: Size(portfolioArcRadius, portfolioArcRadius),
        painter: PortfolioArcChart(
            center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
            color: '5399E0',
            percentage1: 46.0,
            percentage2: 46.0 + 25.0),
      ),
    ));

    result.add(GestureDetector(
      onTap: () {
        print('3번째 component tap');
      },
      child: CustomPaint(
        size: Size(portfolioArcRadius, portfolioArcRadius),
        painter: PortfolioArcChart(
            center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
            color: '48BADD',
            percentage1: 46.0 + 25.0,
            percentage2: 46.0 + 25.0 + 17.0),
      ),
    ));

    result.add(GestureDetector(
      onTap: () {
        print('4번째 component tap');
      },
      child: CustomPaint(
        size: Size(portfolioArcRadius, portfolioArcRadius),
        painter: PortfolioArcChart(
            center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
            color: '4CEDE9',
            percentage1: 46.0 + 25.0 + 17.0,
            percentage2: 46.0 + 25.0 + 17.0 + 12.0),
      ),
    ));

    result.add(CustomPaint(
      size: Size(portfolioArcRadiusCenter, portfolioArcRadiusCenter),
      painter: PortfolioArcChart(
          center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
          color: 'FFFFFF',
          percentage1: 0,
          percentage2: 100),
    ));

    return result;
  }
}

class PortfolioArcChart extends CustomPainter {
  Offset center;
  String color;
  double percentage1 = 0.0;
  double percentage2 = 0.0;

  PortfolioArcChart(
      {this.center, this.color, this.percentage1, this.percentage2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(int.parse('FF$color', radix: 16))
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    if (percentage1 != 100) percentage1 = percentage1 % 100;
    if (percentage2 != 100) percentage2 = percentage2 % 100;

    if (percentage1 > percentage2) {
      double arcAngle1 = 2 * math.pi * (percentage1 / 100);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle1,
          2 * math.pi - arcAngle1, true, paint);

      double arcAngle2 = 2 * math.pi * (percentage2 / 100);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          2 * math.pi, arcAngle2, true, paint);
    } else {
      double arcAngle1 = 2 * math.pi * (percentage1 / 100);
      double arcAngle2 = 2 * math.pi * (percentage2 / 100);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle1,
          arcAngle2 - arcAngle1, true, paint);
    }
  }

  @override
  bool shouldRepaint(PortfolioArcChart oldDelegate) {
    return false;
  }

  @override
  bool hitTest(Offset position) {
    // TODO: implement hitTest

    print('$position');

    return super.hitTest(position);
  }

  // @override
  // bool hitTest(Offset position) {
  //   return paint.contains(position);
  // }
}

class ScrollAnimationForSliverAppBar extends StatefulWidget {
  final ScrollController scrollController;
  final double zeroOpacityOffset;
  final double fullOpacityOffset;

  ScrollAnimationForSliverAppBar(
      {Key key,
      @required this.scrollController,
      this.zeroOpacityOffset = 0.0,
      this.fullOpacityOffset = 0.0});

  @override
  _ScrollAnimationForSliverAppBarState createState() =>
      _ScrollAnimationForSliverAppBarState();
}

class _ScrollAnimationForSliverAppBarState
    extends State<ScrollAnimationForSliverAppBar> {
  double _offset;

  @override
  initState() {
    super.initState();
    _offset = widget.scrollController.offset;
    widget.scrollController.addListener(_setOffset);
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  double _calculateOpacity() {
    if (_offset <= widget.zeroOpacityOffset)
      return 0;
    else if (_offset >= widget.fullOpacityOffset)
      return 1;
    else
      return (_offset - widget.zeroOpacityOffset) /
          (widget.fullOpacityOffset - widget.zeroOpacityOffset);
  }

  double _calculatePositioned() {
    if (_offset >= heightForSliverFlexibleSpace)
      return -heightForSliverFlexibleSpace;
    else if (_offset <= 0)
      return 0.0;
    else
      return -(_offset);
  }

  @override
  Widget build(BuildContext context) {
    /*return Opacity(
      opacity: _calculateOpacity(),
      child: widget.child,
    );*/
    return SliverAppBar(
      expandedHeight:
          heightForSliverFlexibleSpace, // kToolbarHeight 다음부터의 height을 말함.
      backgroundColor: sliverAppBarColor, // 해당 상금 주식의 테마 색이 되어야함.
      pinned: true,
      elevation: 2, // appBar의 깊이.
      // elevation: 0, // appBar의 깊이.
      centerTitle: true,
      title: Opacity(
        opacity: _calculateOpacity(),
        child: Text(
          '10,128,400원 - 요트 점수 Top 3',
          style: TextStyle(
            fontFamily: 'AppleSDL',
            fontSize: 18,
            letterSpacing: -2.0,
            // color: Colors.white,
          ),
          textAlign: TextAlign.start,
        ),
      ),
      /*flexibleSpace: SafeArea(
          child: Container(
        child: Center(
          child: Text('${_calculatePositioned()}'),
        ),
      )
      ),*/
      flexibleSpace: SafeArea(
        child: Stack(
          children: [
            /*Positioned(
              top: _calculatePositioned(),
              child: Container(
                height: 287.0,
                width: 300,
                color: Colors.red,
              ),
            ),*/
            Positioned(
              top: paddingForRewardText +
                  kToolbarHeight +
                  _calculatePositioned(),
              child: Container(
                width: deviceWidth,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      '10,128,400원',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'AppleSDB'),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Container(
                      height: 50,
                      width: deviceWidth,
                      color: sliverAppBarColor,
                    ),
                    Container(
                      height: heightForSliverFlexibleSpace -
                          kToolbarHeight, // 안전하게 이정도. 밑에 영역 크기를 정확히 계산할 수 없으므로 걍 넘겨버린다.
                      width: deviceWidth,
                      color: backgroundColor,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: paddingForRewardText +
                  kToolbarHeight +
                  _calculatePositioned(),
              child: Container(
                width: deviceWidth,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      '0,000,000원',
                      style: TextStyle(
                          color: Colors.transparent,
                          fontSize: 40,
                          fontFamily: 'AppleSDB'),
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    // Container(
                    //   height: 25,
                    //   width: deviceWidth,
                    // ),
                    Row(children: [
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        children: [
                          Container(
                            height: 25,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            // color: Colors.black,
                            child: SvgPicture.asset(
                              'assets/icons/portfolio_left_arrow.svg',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        height: 80,
                        width: 80,
                        child: SvgPicture.asset(
                          'assets/icons/portfolio_medal_001.svg',
                          width: 80,
                          height: 80,
                        ),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Container(
                            height: 25,
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            // color: Colors.black,
                            child: SvgPicture.asset(
                              'assets/icons/portfolio_right_arrow.svg',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                    ]),
                    SizedBox(
                      height: 24.0,
                    ),
                    Container(
                      height: 9.0,
                      width: 9.0 * 4 + 14.0 * 3,
                      child: Stack(children: [
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFC4C4C4),
                            ),
                            height: 9.0,
                            width: 9.0,
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          left: 9.0 * 1 + 14.0 * 1,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                              // color: Color(0xFFC4C4C4),
                            ),
                            height: 9.0,
                            width: 9.0,
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          left: 9.0 * 2 + 14.0 * 2,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black,
                              // color: Color(0xFFC4C4C4),
                            ),
                            height: 9.0,
                            width: 9.0,
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          left: 9.0 * 3 + 14.0 * 3,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFC4C4C4),
                            ),
                            height: 9.0,
                            width: 9.0,
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          left: 9.0 * 1 + 14.0 * 1 + 4.5,
                          child: Container(
                            height: 9.0,
                            width: 23.0,
                            color: Colors.black,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            // 앱바를 가리지 않기 위해 덮어씌워주는.
            Positioned(
                top: 0.0,
                child: Opacity(
                  opacity: 1.0,
                  child: Container(
                    height: kToolbarHeight,
                    width: deviceWidth,
                    color: sliverAppBarColor,
                  ),
                )),
            // Positioned(
            //     top: kToolbarHeight,
            //     child: Opacity(
            //         opacity: _calculateOpacity(),
            //         child: Container(
            //           height: 1,
            //           width: deviceWidth,
            //           color: Colors.black,
            //         ))),
            // Positioned(
            //   top: kToolbarHeight + _calculatePositioned(),
            //   child: Container(
            //     height: 32.0,
            //     width: 100,
            //     color: Colors.black,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

///////////////////////////////***************/////////////////////////////////
///////////////////////////////***************/////////////////////////////////
///////////////////////////////***************/////////////////////////////////
///////////////////////////////***************/////////////////////////////////
///////////////////////////////***************/////////////////////////////////

/*const double heightForSliverFlexibleSpace =
    288.0; // 이 288.0 은 당연히 기기마다 달라져야함. SliverFlexibleSpace를 위한 하잍
const double paddingForRewardText = 32.0; // 상금 주식 가치 텍스트 위의 패딩(마진)

class YachtPortfolioView extends StatelessWidget {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<YachtPortfolioViewModel>.reactive(
        viewModelBuilder: () => YachtPortfolioViewModel(),
        builder: (context, model, child) {
          /*return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Text(
                  '새포트폴리오~',
                  style: TextStyle(
                    fontFamily: 'AppleSDEB',
                    fontSize: 20.sp,
                    letterSpacing: -2.0,
                  ),
                ),
                elevation: 1,
              ),
              backgroundColor: Colors.white,
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? Container()
                      : SafeArea(
                          child: Container(
                          color: Colors.red,
                        )));*/
          return Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight:
                      heightForSliverFlexibleSpace, // kToolbarHeight 다음부터의 height을 말함.
                  backgroundColor: Colors.blue, // 해당 상금 주식의 테마 색이 되어야함.
                  pinned: true,
                  // elevation: 2, // appBar의 깊이.
                  elevation: 0, // appBar의 깊이.
                  centerTitle: true,
                  title: Container(
                    color: Colors.blue,
                    child: FadeOnScroll(
                      scrollController: _scrollController,
                      zeroOpacityOffset:
                          paddingForRewardText, // kToolbarHeight 다음부터의 offset. 즉 상금 텍스트 위의 공간만큼 주어야 함
                      fullOpacityOffset:
                          50, // zeroOpacityOffset으로부터 상금 텍스트의 height 가량을 더한, 타이틀이 완전히 보여야 하는 위치로 설정해주어야함. 대략 4-50이면 될듯. 이거는 그냥 대략적인 수치로 갈음해도 자연스러울듯
                      child: Text(
                        '10,128,400원 - 요트 점수 Top 3',
                        style: TextStyle(
                          fontFamily: 'AppleSDL',
                          fontSize: 18,
                          letterSpacing: -2.0,
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: SafeArea(child: Container()),
                ),
                buildPortfolioViewBody(),
              ],
            ),
          );
        });
  }

  Widget buildPortfolioViewBody() => SliverList(
        delegate: SliverChildListDelegate([
          Container(
            color: Colors.grey,
            height: 700,
          ),
          Container(
            color: Colors.black,
            height: 700,
          ),
          Container(
            color: Colors.white,
            height: 700,
          ),
        ]),
      );
}

// 아래로 스크롤할 때 title을 서서히 Fade In 시켜주는 stateful widget
class FadeOnScroll extends StatefulWidget {
  final ScrollController scrollController;
  final double zeroOpacityOffset;
  final double fullOpacityOffset;
  final Widget child;

  FadeOnScroll(
      {Key key,
      @required this.scrollController,
      @required this.child,
      this.zeroOpacityOffset = 0.0,
      this.fullOpacityOffset = 0.0});

  @override
  _FadeOnScrollState createState() => _FadeOnScrollState();
}

class _FadeOnScrollState extends State<FadeOnScroll> {
  double _offset;

  @override
  initState() {
    super.initState();
    _offset = widget.scrollController.offset;
    widget.scrollController.addListener(_setOffset);
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  double _calculateOpacity() {
    if (_offset <= widget.zeroOpacityOffset)
      return 0;
    else if (_offset >= widget.fullOpacityOffset)
      return 1;
    else
      return (_offset - widget.zeroOpacityOffset) /
          (widget.fullOpacityOffset - widget.zeroOpacityOffset);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _calculateOpacity(),
      child: widget.child,
    );
  }
}*/

/*class YachtPortfolioView extends StatelessWidget {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<YachtPortfolioViewModel>.reactive(
        viewModelBuilder: () => YachtPortfolioViewModel(),
        builder: (context, model, child) {
          /*return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                title: Text(
                  '새포트폴리오~',
                  style: TextStyle(
                    fontFamily: 'AppleSDEB',
                    fontSize: 20.sp,
                    letterSpacing: -2.0,
                  ),
                ),
                elevation: 1,
              ),
              backgroundColor: Colors.white,
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? Container()
                      : SafeArea(
                          child: Container(
                          color: Colors.red,
                        )));*/
          return Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 288,
                  backgroundColor: Colors.blue,
                  pinned: true,
                  elevation: 2,
                  centerTitle: true,
                  title: Container(
                    color: Colors.blue,
                    child: FadeOnScroll(
                      scrollController: _scrollController,
                      zeroOpacityOffset: 188,
                      fullOpacityOffset: 288 - kToolbarHeight,
                      child: Text(
                        '10,128,400원 - 요트 점수 Top 3',
                        style: TextStyle(
                          fontFamily: 'AppleSDL',
                          fontSize: 18,
                          letterSpacing: -2.0,
                        ),
                      ),
                    ),
                  ),
                  flexibleSpace: SafeArea(
                    child: AnimationScroll(
                      scrollController: _scrollController,
                      zeroOffset: 0,
                      fullOffset: 288 - kToolbarHeight,
                    ),
                  ),
                ),
                buildPortfolioBody(),
              ],
            ),
          );
        });
  }

  Widget buildPortfolioBody() => SliverList(
        delegate: SliverChildListDelegate([
          Container(
            color: Colors.grey,
            height: 100,
          ),
          Container(
            color: Colors.black,
            height: 100,
          ),
          Container(
            color: Colors.white,
            height: 100,
          ),
          Container(
            color: Colors.grey,
            height: 100,
          ),
          Container(
            color: Colors.black,
            height: 100,
          ),
          Container(
            color: Colors.white,
            height: 100,
          ),
          Container(
            color: Colors.grey,
            height: 100,
          ),
          Container(
            color: Colors.black,
            height: 100,
          ),
          Container(
            color: Colors.white,
            height: 100,
          ),
          Container(
            color: Colors.black,
            height: 100,
          ),
          Container(
            color: Colors.grey,
            height: 100,
          ),
          Container(
            color: Colors.white,
            height: 100,
          ),
        ]),
      );
}

// 아래로 스크롤할 때 title을 서서히 Fade In 시켜주는 stateful widget
class FadeOnScroll extends StatefulWidget {
  final ScrollController scrollController;
  final double zeroOpacityOffset;
  final double fullOpacityOffset;
  final Widget child;

  FadeOnScroll(
      {Key key,
      @required this.scrollController,
      @required this.child,
      this.zeroOpacityOffset = 0,
      this.fullOpacityOffset = 0});

  @override
  _FadeOnScrollState createState() => _FadeOnScrollState();
}

class _FadeOnScrollState extends State<FadeOnScroll> {
  double _offset;

  @override
  initState() {
    super.initState();
    _offset = widget.scrollController.offset;
    widget.scrollController.addListener(_setOffset);
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  double _calculateOpacity() {
    if (_offset <= widget.zeroOpacityOffset)
      return 0;
    else if (_offset >= widget.fullOpacityOffset)
      return 1;
    else
      return (_offset - widget.zeroOpacityOffset) /
          (widget.fullOpacityOffset - widget.zeroOpacityOffset);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _calculateOpacity(),
      child: widget.child,
    );
  }
}

// 아래로 스크롤할 때 기타요소들 애니메이션(크기조절, fade 등) 해주는 stateful widget
class AnimationScroll extends StatefulWidget {
  final ScrollController scrollController;
  final double zeroOffset;
  final double fullOffset;

  AnimationScroll(
      {Key key,
      @required this.scrollController,
      this.zeroOffset = 0,
      this.fullOffset = 0});

  @override
  _AnimationScrollState createState() => _AnimationScrollState();
}

class _AnimationScrollState extends State<AnimationScroll> {
  double _offset;

  @override
  initState() {
    super.initState();
    _offset = widget.scrollController.offset;
    widget.scrollController.addListener(_setOffset);
  }

  @override
  dispose() {
    widget.scrollController.removeListener(_setOffset);
    super.dispose();
  }

  void _setOffset() {
    setState(() {
      _offset = widget.scrollController.offset;
    });
  }

  double _calculateHeight() {
    // if (_offset <= widget.zeroOffset)
    //   return 288;
    // else if (_offset >= widget.fullOffset - kToolbarHeight)
    //   return kToolbarHeight;
    // else
    //   return (widget.fullOffset - _offset);
    if (_offset <= widget.zeroOffset)
      return 288-kToolbarHeight;
    else if (_offset >= widget.fullOffset - kToolbarHeight)
      return 0;
    else
      return (widget.fullOffset - _offset);
  }

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    //     Container(
    //       height: _calculateHeight(),
    //       // height: 288,
    //       color: Colors.amber,
    //     ),
    //     // Container(
    //     //   height: 100,
    //     //   color: Colors.amberAccent,
    //     // ),
    //   ],
    // );
    // return Container(
    //   constraints: BoxConstraints(maxHeight: 288.0),
    //   height: _calculateHeight(),
    //   color: Colors.amber,
    //   child: Column(
    //     children: [
    //       SizedBox(
    //         height: 100,
    //       ),
    //       Text('ddd'),
    //       SizedBox(
    //         height: 100,
    //       )
    //     ],
    //   ),
    // );
    double _calculateHeightVal = _calculateHeight();
    // return Container(
    //   height: _calculateHeightVal,
    //   color: Colors.amber,
    //   child: Column(
    //     children: [
    //       // SizedBox(
    //       //   height: max(kToolbarHeight + 24 + (_calculateHeightVal - 288), 0.0),
    //       // ),
    //       Text('dd')
    //     ],
    //   ),
    // );
    return Column(
      children: [
        Container(
          height: kToolbarHeight,
          color: Colors.amberAccent,
        ),
        Container(
          height: _calculateHeightVal,
          color: Colors.amber,
        ),
      ],
    );
  }
}
*/
