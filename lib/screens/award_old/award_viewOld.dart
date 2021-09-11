import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:math' as math;

import 'award_view_modelOld.dart';

import '../../styles/size_config.dart';

// 앱 전체적으로 관리되는 색깔, 폰트 등
//// 필요한 const 및 dummy model을 아래에. const는 나중에 어플 통합 const로서 관리되면 더 좋고
// dummy model 도 실제 model 이 되어 DB로 관리할 수 있어야 함.
const double heightForSliverFlexibleSpace =
    kToolbarHeight + 220.0; // 당연히 기기마다 달라져야함. SliverFlexibleSpace를 위한 height
const double paddingForRewardText = 8.0; // 상금 주식 가치 텍스트 위의 패딩(마진)
const Color sliverAppBarColor = Color(0xFF4F77F7);
// const Color sliverAppBarColor = Color(0xFFD9D9D9);
const Color backgroundColor = Colors.white;
const double mainPadding = 16.0;
const double txtContainerPadding = 3.0;
final double portfolioArcRadius = SizeConfig.screenWidth - mainPadding * 2;
const TextStyle titleTxtStyle =
    TextStyle(fontFamily: 'AppleSDB', fontSize: 26.0);
const TextStyle descriptionTxtStyle =
    TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'AppleSDM');
const TextStyle portionTxtStyle =
    TextStyle(fontFamily: 'AppleSDEB', fontSize: 22.0);
const TextStyle stockNameTxtStyle =
    TextStyle(fontFamily: 'AppleSDM', fontSize: 12.0);

const visiblePercentage = 0.06; // 15% 이상 포션이면 보여준다.

List<String> portfolioColor = [
  '4F77F7',
  '5399E0',
  '48BADD',
  '4CEDE9',
  '88F3F1',
  'BEF1F0',
  'CFF8F7',
];

// // text size get 함수
// Size textSizeGet(String txt, TextStyle txtStyle) {
//   return (TextPainter(
//           text: TextSpan(text: txt, style: txtStyle),
//           maxLines: 1,
//           textDirection: TextDirection.ltr)
//         ..layout())
//       .size;
// }

// model.
class PortfolioModel {
  final String? stockName;
  final int? sharesNum;
  final double? currentPrice;

  PortfolioModel({this.stockName, this.sharesNum, this.currentPrice});
}

List<PortfolioModel> portfolioModel = [
  PortfolioModel(
    stockName: '하이트진로',
    sharesNum: 12,
    currentPrice: 39900,
  ),
  PortfolioModel(
    stockName: 'JYP Ent',
    sharesNum: 6,
    currentPrice: 39950,
  ),
  PortfolioModel(
    stockName: 'LG화학',
    sharesNum: 1,
    currentPrice: 850000,
  ),
  PortfolioModel(
    stockName: '한국타이어앤테크놀로지',
    sharesNum: 104,
    currentPrice: 53600,
  ),
  PortfolioModel(
    stockName: 'NHN한국사이버결제',
    sharesNum: 56,
    currentPrice: 53900,
  ),
  PortfolioModel(
    stockName: '삼성전자',
    sharesNum: 24,
    currentPrice: 81000,
  ),
];
// List<PortfolioModel> portfolioModel = [
//   PortfolioModel(
//     stockName: '카카오',
//     sharesNum: 12,
//     currentPrice: 39900,
//   ),
// ];

// 상금 주식 포트폴리오의 토탈밸류
// double? totalValue;
double totalValue = 0.0;

// model for awards info

// model for UI
class PortfolioModelForUI {
  final bool? visible;
  final int? percentage;
  final double? startPercentage;
  final double? endPercentage;
  final Offset? portionOffsetFromCenter;
  final Offset? stockNameOffsetFromCenter;
  final dynamic colorCode;

  PortfolioModelForUI(
      {this.visible,
      this.percentage,
      this.startPercentage,
      this.endPercentage,
      this.portionOffsetFromCenter,
      this.stockNameOffsetFromCenter,
      this.colorCode});
}

List<PortfolioModelForUI> portfolioModelForUI = [];

methodCalcPortfolioModelForUI() {
  portfolioModelForUI = [];
  double accumPercentage = 0.0;

  // 전체 상금 주식 가치 계산

  for (int i = 0; i < portfolioModel.length; i++) {
    totalValue +=
        portfolioModel[i].sharesNum! * portfolioModel[i].currentPrice!;
  }

  // 각 종목 비중별로 정렬한다.
  for (int i = 0; i < portfolioModel.length; i++) {
    PortfolioModel tempPortfolioModel;
    for (int j = i + 1; j < portfolioModel.length; j++) {
      if (portfolioModel[i].sharesNum! * portfolioModel[i].currentPrice! <
          portfolioModel[j].sharesNum! * portfolioModel[j].currentPrice!) {
        tempPortfolioModel = portfolioModel[i];
        portfolioModel[i] = portfolioModel[j];
        portfolioModel[j] = tempPortfolioModel;
      }
    }
  }

  // UI를 위한 모델을 채워준다.
  for (int i = 0; i < portfolioModel.length; i++) {
    //
    double portion =
        (portfolioModel[i].currentPrice! * portfolioModel[i].sharesNum!) /
            totalValue;
    double nextAccumPercentage = accumPercentage + portion;
    int portionInt = (portion * 100).round();
    Size portionTxtSize = textSizeGet('$portionInt%', portionTxtStyle);
    Size stockNameTxtSize =
        textSizeGet('${portfolioModel[i].stockName}', stockNameTxtStyle);
    bool visible = portion >= visiblePercentage ? true : false;

    //
    portfolioModelForUI.add(
      PortfolioModelForUI(
        visible: visible,
        percentage: portionInt,
        startPercentage: accumPercentage,
        endPercentage: nextAccumPercentage,
        portionOffsetFromCenter: Offset(
            portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.cos(2 *
                            math.pi *
                            ((accumPercentage + nextAccumPercentage) / 2) -
                        math.pi / 2) -
                portionTxtSize.width / 2,
            portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.sin(2 *
                            math.pi *
                            ((accumPercentage + nextAccumPercentage) / 2) -
                        math.pi / 2) -
                portionTxtSize.height),
        stockNameOffsetFromCenter: Offset(
            portfolioArcRadius / 2 +
                        (portfolioArcRadius / 2) *
                            0.6 *
                            math.cos(
                                2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) -
                                    math.pi / 2) -
                        stockNameTxtSize.width / 2 -
                        txtContainerPadding >
                    0
                ? portfolioArcRadius / 2 +
                            (portfolioArcRadius / 2) *
                                0.6 *
                                math.cos(2 *
                                        math.pi *
                                        ((accumPercentage + nextAccumPercentage) /
                                            2) -
                                    math.pi / 2) +
                            stockNameTxtSize.width / 2 +
                            txtContainerPadding <
                        portfolioArcRadius
                    ? portfolioArcRadius / 2 +
                        (portfolioArcRadius / 2) *
                            0.6 *
                            math.cos(
                                2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) -
                                    math.pi / 2) -
                        stockNameTxtSize.width / 2 -
                        txtContainerPadding
                    : portfolioArcRadius -
                        txtContainerPadding * 2 -
                        stockNameTxtSize.width
                : 0,
            portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.sin(2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) - math.pi / 2)),
        colorCode: portfolioColor[i],
      ),
    );

    accumPercentage = nextAccumPercentage;
  }
}

class AwardOldView extends StatelessWidget {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  AwardOldView() {
    methodCalcPortfolioModelForUI();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AwardOldViewViewModel>.reactive(
        viewModelBuilder: () => AwardOldViewViewModel(),
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
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 32.0,
                        ),
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
                                portfolioModel.length > 1
                                    ? '상금 주식 포트폴리오'
                                    : '상금 주식',
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
                        PortfolioChart(),
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
                                        color:
                                            Color(0xFF4F77F7).withOpacity(0.8),
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
                                        color:
                                            Color(0xFF5399E0).withOpacity(0.8),
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
                                        color:
                                            Color(0xFF48BADD).withOpacity(0.8),
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
                                        color:
                                            Color(0xFF4CEDE9).withOpacity(0.8),
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
                                        color:
                                            Color(0xFF88F3F1).withOpacity(0.8),
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
                                        color:
                                            Color(0xFFBEF1F0).withOpacity(0.8),
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
            ),
          );
        });
  }
}

class ScrollAnimationForSliverAppBar extends StatefulWidget {
  final ScrollController scrollController;
  final double zeroOpacityOffset;
  final double fullOpacityOffset;

  ScrollAnimationForSliverAppBar(
      {Key? key,
      required this.scrollController,
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
    return SliverAppBar(
      expandedHeight:
          heightForSliverFlexibleSpace, // kToolbarHeight 다음부터의 height을 말함.
      backgroundColor: sliverAppBarColor, // 해당 상금 주식의 테마 색이 되어야함.
      pinned: true,
      elevation: 0, // appBar의 깊이.
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
                width: SizeConfig.screenWidth,
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

class PortfolioChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: mainPadding, right: mainPadding),
      child: portfolioModel.length > 1
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
                        'FF${portfolioModelForUI[0].colorCode}',
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
                        portfolioModel[0].stockName!,
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

    for (int i = 0; i < portfolioModel.length; i++) {
      result.add(
        GestureDetector(
          onTap: () {},
          child: CustomPaint(
            size: Size(portfolioArcRadius, portfolioArcRadius),
            painter: PortfolioArcChartPainter(
                center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                color: portfolioModelForUI[i].colorCode,
                percentage1: portfolioModelForUI[i].startPercentage! * 100,
                percentage2: portfolioModelForUI[i].endPercentage! * 100),
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

    for (int i = 0; i < portfolioModel.length; i++) {
      if (portfolioModelForUI[i].visible!)
        result.add(
          Positioned(
            left: portfolioModelForUI[i].portionOffsetFromCenter!.dx,
            top: portfolioModelForUI[i].portionOffsetFromCenter!.dy,
            child: Text(
              '${portfolioModelForUI[i].percentage}%',
              style: portionTxtStyle,
            ),
          ),
        );
      if (portfolioModelForUI[i].visible!)
        result.add(
          Positioned(
              left: portfolioModelForUI[i].stockNameOffsetFromCenter!.dx,
              top: portfolioModelForUI[i].stockNameOffsetFromCenter!.dy,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: txtContainerPadding,
                  horizontal: txtContainerPadding,
                ),
                decoration: BoxDecoration(
                    color: Color(int.parse(
                            'FF${portfolioModelForUI[i].colorCode}',
                            radix: 16))
                        .withOpacity(0.8),
                    borderRadius: BorderRadius.circular(
                      5.0,
                    )),
                child: Text(
                  portfolioModel[i].stockName!,
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

////////////////////////////////////////////////////////////////////////////////////////

/*
// 필요한 const 및 dummy model을 아래에. const는 나중에 어플 통합 const로서 관리되면 더 좋고
// dummy model 도 실제 model 이 되어 DB로 관리할 수 있어야 함.
const double heightForSliverFlexibleSpace =
    kToolbarHeight + 220.0; // 당연히 기기마다 달라져야함. SliverFlexibleSpace를 위한 height
const double paddingForRewardText = 8.0; // 상금 주식 가치 텍스트 위의 패딩(마진)
const Color sliverAppBarColor = Color(0xFFD9D9D9);
const Color backgroundColor = Colors.white;
////////////////////////////////////////////

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
*/

/*import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

import 'dart:math' as math;

import 'package:yachtOne/views/constants/size.dart';

import '../view_models/yacht_portfolio_view_model.dart';

// 앱 전체적으로 관리되는 색깔, 폰트 등
const Color backgroundColor = Colors.white;
const double mainPadding = 16.0;

// text size get 함수
Size textSizeGet(String txt, TextStyle txtStyle) {
  return (TextPainter(
          text: TextSpan(text: txt, style: txtStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr)
        ..layout())
      .size;
}

class YachtPortfolioView extends StatelessWidget {
  // final ScrollController _scrollController =
  //     ScrollController(initialScrollOffset: 0.0);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<YachtPortfolioViewModel>.reactive(
        viewModelBuilder: () => YachtPortfolioViewModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: backgroundColor,
            // body: CustomScrollView(),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: mainPadding, right: mainPadding),
                    child: Text('상금 주식 포트폴리오',
                        style:
                            TextStyle(fontFamily: 'AppleSDB', fontSize: 22.0)),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  PortfolioArcChart(),
                ],
              ),
            ),
          );
        });
  }
}

class PortfolioArcChart extends StatelessWidget {
  final double portfolioArcRadius = deviceWidth - mainPadding * 2;

  final Size size1 =
      textSizeGet('46%', TextStyle(fontFamily: 'AppleSDEB', fontSize: 22.0));
  final Size size2 =
      textSizeGet('25%', TextStyle(fontFamily: 'AppleSDEB', fontSize: 22.0));
  final Size size3 =
      textSizeGet('16%', TextStyle(fontFamily: 'AppleSDEB', fontSize: 22.0));
  final Size size11 =
      textSizeGet('삼성전자', TextStyle(fontFamily: 'AppleSDM', fontSize: 12.0));
  final Size size22 = textSizeGet('NHN한국사이버결제NHN한국사이버결제NHN한국사이버결제',
      TextStyle(fontFamily: 'AppleSDM', fontSize: 12.0));
  final Size size33 = textSizeGet(
      '라이프사이언스테크놀로지', TextStyle(fontFamily: 'AppleSDM', fontSize: 12.0));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: mainPadding, right: mainPadding),
      child: Container(
        width: portfolioArcRadius,
        height: portfolioArcRadius,
        child: Stack(children: [
          GestureDetector(
            onTap: () {},
            child: CustomPaint(
              size: Size(portfolioArcRadius, portfolioArcRadius),
              painter: PortfolioArcChartPainter(
                  center:
                      Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                  color: '4F77F7',
                  percentage1: 0.0,
                  percentage2: 46.0),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: CustomPaint(
              size: Size(portfolioArcRadius, portfolioArcRadius),
              painter: PortfolioArcChartPainter(
                  center:
                      Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                  color: '5399E0',
                  percentage1: 46.0,
                  percentage2: 46.0 + 25.0),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: CustomPaint(
              size: Size(portfolioArcRadius, portfolioArcRadius),
              painter: PortfolioArcChartPainter(
                  center:
                      Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                  color: '48BADD',
                  percentage1: 46.0 + 25.0,
                  percentage2: 46.0 + 25.0 + 16.0),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: CustomPaint(
              size: Size(portfolioArcRadius, portfolioArcRadius),
              painter: PortfolioArcChartPainter(
                  center:
                      Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                  color: '4CEDE9',
                  percentage1: 46.0 + 25.0 + 16.0,
                  percentage2: 46.0 + 25.0 + 16.0 + 7.0),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: CustomPaint(
              size: Size(portfolioArcRadius, portfolioArcRadius),
              painter: PortfolioArcChartPainter(
                  center:
                      Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                  color: '88F3F1',
                  percentage1: 46.0 + 25.0 + 16.0 + 7.0,
                  percentage2: 46.0 + 25.0 + 16.0 + 7.0 + 3.0),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: CustomPaint(
              size: Size(portfolioArcRadius, portfolioArcRadius),
              painter: PortfolioArcChartPainter(
                  center:
                      Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                  color: 'BEF1F0',
                  percentage1: 46.0 + 25.0 + 16.0 + 7.0 + 3.0,
                  percentage2: 46.0 + 25.0 + 16.0 + 7.0 + 3.0 + 2.0),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: CustomPaint(
              size: Size(portfolioArcRadius, portfolioArcRadius),
              painter: PortfolioArcChartPainter(
                  center:
                      Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                  color: 'CFF8F7',
                  percentage1: 46.0 + 25.0 + 16.0 + 7.0 + 3.0 + 2.0,
                  percentage2: 46.0 + 25.0 + 16.0 + 7.0 + 3.0 + 2.0 + 1.0),
            ),
          ),
          Positioned(
            left: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.cos(2 * math.pi * ((0.0 + 46.0) / 2 / 100)) -
                size1.width / 2,
            top: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.sin(2 * math.pi * ((0.0 + 46.0) / 2 / 100)) -
                size1.height,
            child: Text(
              '46%',
              style: TextStyle(fontFamily: 'AppleSDEB', fontSize: 22.0),
            ),
          ),
          Positioned(
              left: portfolioArcRadius / 2 +
                  (portfolioArcRadius / 2) *
                      0.6 *
                      math.cos(2 * math.pi * ((0.0 + 46.0) / 2 / 100)) -
                  size11.width / 2 -
                  3,
              top: portfolioArcRadius / 2 +
                  (portfolioArcRadius / 2) *
                      0.6 *
                      math.sin(2 * math.pi * ((0.0 + 46.0) / 2 / 100)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 3,
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
                      fontSize: 12,
                      fontFamily: 'AppleSDM'),
                ),
              )),
          Positioned(
            left: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.cos(2 * math.pi * ((46.0 + 71.0) / 2 / 100)) -
                size2.width / 2,
            top: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.sin(2 * math.pi * ((46.0 + 71.0) / 2 / 100)) -
                size2.height,
            child: Text(
              '25%',
              style: TextStyle(fontFamily: 'AppleSDEB', fontSize: 22.0),
            ),
          ),
          Positioned(
              left: portfolioArcRadius / 2 +
                  (portfolioArcRadius / 2) *
                      0.6 *
                      math.cos(2 * math.pi * ((46.0 + 71.0) / 2 / 100)) -
                  size22.width / 2 -
                  3 +
                  52,
              top: portfolioArcRadius / 2 +
                  (portfolioArcRadius / 2) *
                      0.6 *
                      math.sin(2 * math.pi * ((46.0 + 71.0) / 2 / 100)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 3,
                ),
                decoration: BoxDecoration(
                    color: Color(0xFF5399E0).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(
                      5.0,
                    )),
                child: Text(
                  'NHN한국사이버결제NHN한국사이버결제NHN한국사이버결제',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'AppleSDM'),
                ),
              )),
          Positioned(
            left: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.cos(2 * math.pi * ((71.0 + 87.0) / 2 / 100)) -
                size2.width / 2,
            top: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.sin(2 * math.pi * ((71.0 + 87.0) / 2 / 100)) -
                size2.height,
            child: Text(
              '16%',
              style: TextStyle(fontFamily: 'AppleSDEB', fontSize: 22.0),
            ),
          ),
          Positioned(
              left: portfolioArcRadius / 2 +
                  (portfolioArcRadius / 2) *
                      0.6 *
                      math.cos(2 * math.pi * ((71.0 + 87.0) / 2 / 100)) -
                  size33.width / 2 -
                  3,
              top: portfolioArcRadius / 2 +
                  (portfolioArcRadius / 2) *
                      0.6 *
                      math.sin(2 * math.pi * ((71.0 + 87.0) / 2 / 100)),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 3,
                ),
                decoration: BoxDecoration(
                    color: Color(0xFF48BADD).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(
                      5.0,
                    )),
                child: Text(
                  '라이프사이언스테크놀로지',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'AppleSDM'),
                ),
              )),
          Positioned(
            left: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.cos(2 * math.pi * ((0.0 + 46.0) / 2 / 100)) -
                2,
            top: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.sin(2 * math.pi * ((0.0 + 46.0) / 2 / 100)) -
                2,
            child: Container(
              height: 4.0,
              width: 4.0,
              color: Colors.red,
            ),
          ),
          Positioned(
            left: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.cos(2 * math.pi * ((46.0 + 71.0) / 2 / 100)) -
                2,
            top: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.sin(2 * math.pi * ((46.0 + 71.0) / 2 / 100)) -
                2,
            child: Container(
              height: 4.0,
              width: 4.0,
              color: Colors.red,
            ),
          ),
          Positioned(
            left: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.cos(2 * math.pi * ((71.0 + 87.0) / 2 / 100)) -
                2,
            top: portfolioArcRadius / 2 +
                (portfolioArcRadius / 2) *
                    0.6 *
                    math.sin(2 * math.pi * ((71.0 + 87.0) / 2 / 100)) -
                2,
            child: Container(
              height: 4.0,
              width: 4.0,
              color: Colors.red,
            ),
          ),
          CustomPaint(
            size: Size(portfolioArcRadius * 0.2, portfolioArcRadius * 0.2),
            painter: PortfolioArcChartPainter(
                center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                color: 'FFFFFF',
                percentage1: 0.0,
                percentage2: 100.0),
          ),
        ]),
      ),
    );
  }
}

class PortfolioArcChartPainter extends CustomPainter {
  Offset center;
  String color;
  double percentage1 = 0.0;
  double percentage2 = 0.0;

  PortfolioArcChartPainter(
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
  bool shouldRepaint(PortfolioArcChartPainter oldDelegate) {
    return false;
  }

  @override
  bool hitTest(Offset position) {
    return super.hitTest(position);
    //   return paint.contains(position);
  }
}

/*class PortfolioModel {
  final String stockName;
  final int sharesNum;
  final double currentPrice;

  PortfolioModel({this.stockName, this.sharesNum, this.currentPrice});
}

List<PortfolioModel> portfolioModel = [
  PortfolioModel(stockName: '한국타이어앤테크놀로지', sharesNum: 30, currentPrice: 30000),
  PortfolioModel(stockName: '삼성전자', sharesNum: 15, currentPrice: 100000)
];

Size textSizeGet(String portionTxt, String stockNameTxt,
    TextStyle portionTxtStyle, TextStyle stockNameTxtStyle) {
  Size portionTxtsize = (TextPainter(
          text: TextSpan(text: portionTxt, style: portionTxtStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr)
        ..layout())
      .size;
  Size stockNameTxtsize = (TextPainter(
          text: TextSpan(text: stockNameTxt, style: stockNameTxtStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr)
        ..layout())
      .size;

  return Size(math.max(portionTxtsize.width, stockNameTxtsize.width),
      (portionTxtsize.height + stockNameTxtsize.height));
}

final TextStyle portionTxtStyle = TextStyle(
  fontFamily: 'AppleSDEB',
  fontSize: 22.0,
);
final TextStyle stockNameTxtStyle = TextStyle(
  fontFamily: 'AppleSDL',
  fontSize: 12.0,
);

class YachtPortfolioView extends StatelessWidget {
  final List<Size> sizes = [
    textSizeGet(
        '40%', portfolioModel[0].stockName, portionTxtStyle, stockNameTxtStyle),
    textSizeGet(
        '60%', portfolioModel[1].stockName, portionTxtStyle, stockNameTxtStyle),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          Positioned(
            left: 200 - sizes[0].width / 2,
            top: 200 - sizes[0].height / 2,
            child: Column(
              children: [
                Text(
                  '46%',
                  style: portionTxtStyle,
                ),
                Text(
                  '${portfolioModel[0].stockName}',
                  style: stockNameTxtStyle,
                )
              ],
            ),
          ),
          Positioned(
            left: 200 - 1.5,
            top: 200 - 1.5,
            child: Container(
              color: Colors.red,
              height: 3,
              width: 3,
            ),
          ),
        ],
      )),
    );
  }
}*/

// class YachtPortfolioView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: Column(
//         children: [
//           // Container(
//           //   height: 100,
//           //   width: 100,
//           // ),
//           // Container(height: 100, width: 100, color: Colors.red),
//           // Stack(
//           //   children: [
//           //     GestureDetector(
//           //       onTap: () {
//           //         print('dd1');
//           //       },
//           //       child: CustomPaint(
//           //           size: Size(100, 100),
//           //           painter: YachtPortfolioArcChart('4F77F7', 0.0, 60.0)),
//           //     ),
//           //     /*GestureDetector(
//           //       onTap: () {
//           //         print('dd2');
//           //       },
//           //       child: CustomPaint(
//           //           size: Size(100, 100),
//           //           painter: YachtPortfolioArcChart('5399E0', 60.0, 85.0)),
//           //     ),
//           //     GestureDetector(
//           //       onTap: () {
//           //         print('dd3');
//           //       },
//           //       child: CustomPaint(
//           //           size: Size(100, 100),
//           //           painter: YachtPortfolioArcChart('48BADD', 85.0, 94.0)),
//           //     ),
//           //     GestureDetector(
//           //       onTap: () {
//           //         print('dd4');
//           //       },
//           //       child: CustomPaint(
//           //           size: Size(100, 100),
//           //           painter: YachtPortfolioArcChart('4CEDE9', 94.0, 99.0)),
//           //     ),*/
//           //   ],
//           // ),
//           Stack(
//             children: [
//               CustomPaint(
//                   size: Size(300, 300),
//                   painter: YachtPortfolioArcChart('4F77F7', 50.0, 65.0)),
//               // CustomPaint(
//               //     size: Size(300, 300),
//               //     painter: YachtPortfolioArcChart('5399E0', 55.0, 60.0)),
//               Positioned(
//                 left: 300 / 2 +
//                     300 /
//                         2 *
//                         0.75 *
//                         math.cos(2 * math.pi * ((50.0 + 65.0) / 2 / 100)),
//                 top: 300 / 2 +
//                     300 /
//                         2 *
//                         0.75 *
//                         math.sin(2 * math.pi * ((50.0 + 65.0) / 2 / 100)),
//                 child: Container(
//                   width: 11 * 12.0 * 0.9 + 6,
//                   height: 22.0 + 12.0 + 6.0 + 9.0,
//                   color: Colors.grey,
//                   child: Column(
//                     children: [
//                       Text(
//                         '46%',
//                         style: TextStyle(
//                             fontSize: 22.0, fontWeight: FontWeight.bold),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 3,
//                           horizontal: 3,
//                         ),
//                         decoration: BoxDecoration(
//                             color: Color(0xFF4F77F7).withOpacity(0.8),
//                             borderRadius: BorderRadius.circular(
//                               5.0,
//                             )),
//                         child: Text(
//                           '한국타이어앤테크놀로지',
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // Positioned(
//               //   left: 300 / 2 +
//               //       300 /
//               //           2 *
//               //           0.75 *
//               //           math.cos(2 * math.pi * ((50.0 + 55.0) / 2 / 100)) -
//               //       11,
//               //   top: 300 / 2 +
//               //       300 /
//               //           2 *
//               //           0.75 *
//               //           math.sin(2 * math.pi * ((50.0 + 55.0) / 2 / 100)) -
//               //       11 / 2 -
//               //       6 -
//               //       8,
//               //   child:
//               //       // Container(
//               //       //   color: Colors.black,
//               //       //   height: 4,
//               //       //   width: 4,
//               //       // ),
//               //       Text(
//               //     '46%',
//               //     style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
//               //   ),
//               // ),
//               // Positioned(
//               //   left: 300 / 2 +
//               //       300 /
//               //           2 *
//               //           0.75 *
//               //           math.cos(2 * math.pi * ((50.0 + 55.0) / 2 / 100)) -
//               //       12 * 0.9 * 11 / 2 +
//               //       17,
//               //   top: 300 / 2 +
//               //       300 /
//               //           2 *
//               //           0.75 *
//               //           math.sin(2 * math.pi * ((50.0 + 55.0) / 2 / 100)) +
//               //       11 / 2,
//               //   child: Container(
//               //     padding: const EdgeInsets.symmetric(
//               //       vertical: 4,
//               //       horizontal: 4,
//               //     ),
//               //     decoration: BoxDecoration(
//               //         color: Color(0xFF4F77F7).withOpacity(0.8),
//               //         borderRadius: BorderRadius.circular(
//               //           5.0,
//               //         )),
//               //     child: Text(
//               //       '한국타이어앤테크놀로지',
//               //       style: TextStyle(
//               //         color: Colors.black,
//               //         fontSize: 12,
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ],
//           ),
//         ],
//       )),
//     );
//   }
// }

/*class YachtPortfolioArcChart extends CustomPainter {
  String color;
  double percentage1;
  double percentage2;

  YachtPortfolioArcChart(this.color, this.percentage1, this.percentage2);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(int.parse('FF$color', radix: 16))
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    double arcAngle1 = 2 * math.pi * (percentage1 / 100);
    double arcAngle2 = 2 * math.pi * (percentage2 / 100);
    canvas.drawArc(
        Rect.fromCircle(center: Offset(300 / 2, 300 / 2), radius: radius),
        arcAngle1,
        arcAngle2 - arcAngle1,
        true,
        paint);
  }

  @override
  bool shouldRepaint(YachtPortfolioArcChart oldDelegate) {
    return false;
  }

  @override
  bool hitTest(Offset position) {
    print('$position');
    final Path path = Path();
    // path.
    path.moveTo(100 / 2, 100 / 2);
    path.addArc(Rect.fromCircle(center: Offset(100 / 2, 100 / 2), radius: 50),
        2 * math.pi * (percentage1 / 100), 2 * math.pi * (percentage2 / 100));

    return path.contains(position);
    // return super.hitTest(position);
  }

  // @override
  // bool hitTest(Offset position) {
  //   return paint.contains(position);
  // }
}
*/
*/
