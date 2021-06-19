import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:math' as math;

import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';
import 'award_view_model.dart';

//ignore: must_be_immutable
class AwardView extends StatelessWidget {
  final AwardViewModel awardViewModel = Get.find();
  final ScrollController _scrollController = ScrollController();
  late PageController _pageController;
  final int initialPage;
  late int currentPage;

  AwardView({required this.initialPage}) {
    _pageController = PageController(initialPage: initialPage);
    currentPage = initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, isScrolled) {
          return [
            ScrollAnimationForSliverAppBar(
              scrollController: _scrollController,
              pageController: _pageController,
              zeroOpacityOffset: paddingForRewardText + 20,
              // kToolbarHeight 다음부터의 offset. 즉 상금 텍스트 위의 공간만큼 주어야 함
              fullOpacityOffset: paddingForRewardText + 20 + 50,
              // zeroOpacityOffset으로부터 상금 텍스트의 height 가량을 더한, 타이틀이 완전히 보여야 하는 위치로 설정해주어야함. 대략 4-50이면 될듯. 이거는 그냥 대략적인 수치로 갈음해도 자연스러울듯
            ),
          ];
        },
        body: PageView.builder(
          controller: _pageController,
          itemBuilder: (builder, index) {
            return AwardPageView(
              awardModel: awardViewModel.awardModels[index],
            );
          },
          itemCount: awardViewModel.awardModels.length,
          // physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {
            currentPage = page;
          },
        ),
      ),
    );
  }
}

class AwardPageView extends StatelessWidget {
  final AwardModel awardModel;

  AwardPageView({required this.awardModel});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceExtraLarge,
                Padding(
                  padding: const EdgeInsets.only(
                      left: mainPadding, right: mainPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '요트 점수 Top3',
                        style: titleTxtStyle,
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '4월 한 달간\n가장 많은 요트 점수를 얻으신 세분,\n상금 주식 받아가세요!',
                              style: descriptionTxtStyle,
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
                    ],
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: mainPadding, right: mainPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        // length > 1
                        //     ? '상금 주식 포트폴리오'
                        //     :
                        '상금 주식',
                        style: titleTxtStyle,
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
                ),
                SizedBox(
                  height: 24.0,
                ),
                PortfolioChart(awardModel: awardModel),
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
                            '46%',
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
                            '25%',
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
                            '16%',
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
                              'LG화학',
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
                            '7%',
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
                                color: Color(0xFF88F3F1).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                )),
                            child: Text(
                              '하이트진로',
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
                            '4%',
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
                                color: Color(0xFFBEF1F0).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(
                                  5.0,
                                )),
                            child: Text(
                              'JPY Ent',
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
                            '2%',
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
                      SizedBox(
                        height: 24.0,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ]),
        ),
      ],
    );
  }
}

class PortfolioChart extends StatelessWidget {
  final AwardModel awardModel;

  PortfolioChart({required this.awardModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: mainPadding, right: mainPadding),
      child: awardModel.awardStockModels.length > 1
          ? Container(
              width: portfolioArcRadius,
              height: portfolioArcRadius,
              child: Stack(
                children: portfolioList(),
              ),
            )
          : GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: mainPadding * 3,
                ),
                decoration: BoxDecoration(
                    color: Color(int.parse(
                        'FF${awardModel.awardStockUIModels![0].colorCode}',
                        radix: 16)),
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
                        awardModel.awardStockModels[0].stockName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'AppleSDM'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  List<Widget> portfolioList() {
    List<Widget> result = [];

    for (int i = 0; i < awardModel.awardStockModels.length; i++) {
      result.add(
        GestureDetector(
          onTap: () {},
          child: CustomPaint(
            size: Size(portfolioArcRadius, portfolioArcRadius),
            painter: PortfolioArcChartPainter(
                center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                color: awardModel.awardStockUIModels![i].colorCode,
                percentage1:
                    awardModel.awardStockUIModels![i].startPercentage! * 100,
                percentage2:
                    awardModel.awardStockUIModels![i].endPercentage! * 100),
          ),
        ),
      );
    }

    result.add(CustomPaint(
      size: Size(portfolioArcRadius * 0.2, portfolioArcRadius * 0.2),
      painter: PortfolioArcChartPainter(
          center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
          color: 'FFFFFF',
          percentage1: 0,
          percentage2: 100),
    ));

    for (int i = 0; i < awardModel.awardStockModels.length; i++) {
      if (awardModel.awardStockUIModels![i].legendVisible!)
        result.add(
          Positioned(
            left: awardModel.awardStockUIModels![i].portionOffsetFromCenter!.dx,
            top: awardModel.awardStockUIModels![i].portionOffsetFromCenter!.dy,
            child: Text(
              '${awardModel.awardStockUIModels![i].roundPercentage}%',
              style: portionTxtStyle,
            ),
          ),
        );
      if (awardModel.awardStockUIModels![i].legendVisible!)
        result.add(
          Positioned(
              left: awardModel
                  .awardStockUIModels![i].stockNameOffsetFromCenter!.dx,
              top: awardModel
                  .awardStockUIModels![i].stockNameOffsetFromCenter!.dy,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: txtContainerPadding,
                  horizontal: txtContainerPadding,
                ),
                decoration: BoxDecoration(
                    color: Color(int.parse(
                            'FF${awardModel.awardStockUIModels![i].colorCode}',
                            radix: 16))
                        .withOpacity(0.8),
                    borderRadius: BorderRadius.circular(
                      5.0,
                    )),
                child: Text(
                  awardModel.awardStockModels[i].stockName,
                  style: stockNameTxtStyle,
                ),
              )),
        );
    }

    return result;
  }
}

class PortfolioArcChartPainter extends CustomPainter {
  Offset? center;
  String? color;
  double? percentage1 = 0.0;
  double? percentage2 = 0.0;

  PortfolioArcChartPainter(
      {this.center, this.color, this.percentage1, this.percentage2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(int.parse('FF$color', radix: 16))
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    double arcAngle1 = 2 * math.pi * (percentage1! / 100) - math.pi / 2;
    double arcAngle2 = 2 * math.pi * (percentage2! / 100) - math.pi / 2;
    canvas.drawArc(Rect.fromCircle(center: center!, radius: radius), arcAngle1,
        arcAngle2 - arcAngle1, true, paint);
  }

  @override
  bool shouldRepaint(PortfolioArcChartPainter oldDelegate) {
    return false;
  }

  // @override
  // bool hitTest(Offset position) {
  //   return super.hitTest(position)!;
  //   //   return paint.contains(position);
  // }
}

class ScrollAnimationForSliverAppBar extends StatefulWidget {
  final ScrollController scrollController;
  final PageController pageController;
  final double zeroOpacityOffset;
  final double fullOpacityOffset;

  ScrollAnimationForSliverAppBar(
      {Key? key,
      required this.scrollController,
      required this.pageController,
      this.zeroOpacityOffset = 0.0,
      this.fullOpacityOffset = 0.0});

  @override
  _ScrollAnimationForSliverAppBarState createState() =>
      _ScrollAnimationForSliverAppBarState();
}

class _ScrollAnimationForSliverAppBarState
    extends State<ScrollAnimationForSliverAppBar> {
  double? _offset;

  @override
  initState() {
    print("scroll init");
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
    if (_offset! <= widget.zeroOpacityOffset)
      return 0;
    else if (_offset! >= widget.fullOpacityOffset)
      return 1;
    else
      return (_offset! - widget.zeroOpacityOffset) /
          (widget.fullOpacityOffset - widget.zeroOpacityOffset);
  }

  double _calculatePositioned() {
    if (_offset! >= heightForSliverFlexibleSpace)
      return -heightForSliverFlexibleSpace;
    else if (_offset! <= 0)
      return 0.0;
    else
      return -(_offset!);
  }

  @override
  Widget build(BuildContext context) {
    print("scroll app build");
    return SliverAppBar(
      expandedHeight:
          heightForSliverFlexibleSpace, // kToolbarHeight 다음부터의 height을 말함.
      backgroundColor: sliverAppBarColor, // 해당 상금 주식의 테마 색이 되어야함.
      pinned: true,
      elevation: 0, // appBar의 깊이.
      centerTitle: true,
      title: Opacity(
        opacity: _calculateOpacity(),
        // child: Text(
        //   // '10,128,400원 - 요트 점수 Top 3',
        //   '${widget.awardModel.awardTitle}',
        //   style: TextStyle(
        //     fontFamily: 'AppleSDL',
        //     fontSize: 18,
        //     letterSpacing: -2.0,
        //     // color: Colors.white,
        //   ),
        //   textAlign: TextAlign.start,
        // ),
        child: GetBuilder<AwardViewModel>(builder: (controller) {
          return Text('${controller.appBarTitle}');
        }),
      ),
      flexibleSpace: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: paddingForRewardText +
                  kToolbarHeight +
                  _calculatePositioned(),
              child: Container(
                width: SizeConfig.screenWidth,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    // Text(
                    //   '${widget.awardModel.totalAwardValue}',
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 40,
                    //       fontFamily: 'AppleSDB'),
                    // ),
                    GetBuilder<AwardViewModel>(
                      builder: (controller) {
                        return Text(
                          '${controller.totalAwardValueStr}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'AppleSDB'),
                        );
                      },
                    ),
                    SizedBox(
                      height: 24.0,
                    ),
                    Container(
                      height: 50,
                      width: SizeConfig.screenWidth,
                      color: sliverAppBarColor,
                    ),
                    Container(
                      height: heightForSliverFlexibleSpace -
                          kToolbarHeight, // 안전하게 이정도. 밑에 영역 크기를 정확히 계산할 수 없으므로 걍 넘겨버린다.
                      width: SizeConfig.screenWidth,
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
                width: SizeConfig.screenWidth,
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
                    //   width: SizeConfig.screenWidth,
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
                            child: GestureDetector(
                              onTap: () {
                                if (widget.pageController.page!.toInt() > 0)
                                  widget.pageController.animateToPage(
                                      widget.pageController.page!.toInt() - 1,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease);
                              },
                              child: SvgPicture.asset(
                                'assets/icons/portfolio_left_arrow.svg',
                                width: 50,
                                height: 50,
                              ),
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
                            child: GestureDetector(
                              onTap: () {
                                Get.find<AwardViewModel>().updateAppBarTitle(
                                    widget.pageController.page!.toInt());
                                widget.pageController.animateToPage(
                                    widget.pageController.page!.toInt() + 1,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease);
                              },
                              child: SvgPicture.asset(
                                'assets/icons/portfolio_right_arrow.svg',
                                width: 50,
                                height: 50,
                              ),
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
                    width: SizeConfig.screenWidth,
                    color: sliverAppBarColor,
                  ),
                )),
            // Positioned(
            //     top: kToolbarHeight,
            //     child: Opacity(
            //         opacity: _calculateOpacity(),
            //         child: Container(
            //           height: 1,
            //           width:
            // ,
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
