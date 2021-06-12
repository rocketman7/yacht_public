import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:math' as math;

import 'package:yachtOne/views/constants/size.dart';

import '../view_models/yacht_portfolio_view_model.dart';

// 앱 전체적으로 관리되는 색깔, 폰트 등
//// 필요한 const 및 dummy model을 아래에. const는 나중에 어플 통합 const로서 관리되면 더 좋고
// dummy model 도 실제 model 이 되어 DB로 관리할 수 있어야 함.
const double heightForSliverFlexibleSpace =
    kToolbarHeight + 220.0; // 당연히 기기마다 달라져야함. SliverFlexibleSpace를 위한 height
const double paddingForRewardText = 8.0; // 상금 주식 가치 텍스트 위의 패딩(마진)
const Color sliverAppBarColor = Color(0xFFD9D9D9);
const Color backgroundColor = Colors.white;
const double mainPadding = 16.0;
const double txtContainerPadding = 3.0;
final double portfolioArcRadius = deviceWidth - mainPadding * 2;
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

// text size get 함수
Size textSizeGet(String txt, TextStyle txtStyle) {
  return (TextPainter(
          text: TextSpan(text: txt, style: txtStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr)
        ..layout())
      .size;
}

// model.
class PortfolioModel {
  final String stockName;
  final int sharesNum;
  final double currentPrice;

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
double totalValue;

// model for awards info
class AwardInfo {
  final String awardTitle;
  final String awardDescription;
  final String awardDetailDescription;

  //사실 이 안에 포트폴리오모델의 리스트가 있어야함

  AwardInfo(
      {this.awardTitle, this.awardDescription, this.awardDetailDescription});
}

AwardInfo awardInfo = AwardInfo(
    awardTitle: '요트 점수 Top3',
    awardDescription: '4월 한 달간\n가장 많은 요트 점수를 얻으신 세분,\n상금 주식 받아가세요!');

// model for UI
class PortfolioModelForUI {
  final bool visible;
  final int percentage;
  final double startPercentage;
  final double endPercentage;
  final Offset portionOffsetFromCenter;
  final Offset stockNameOffsetFromCenter;
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
  totalValue = 0.0;
  for (int i = 0; i < portfolioModel.length; i++) {
    totalValue += portfolioModel[i].sharesNum * portfolioModel[i].currentPrice;
  }

  // 각 종목 비중별로 정렬한다.
  for (int i = 0; i < portfolioModel.length; i++) {
    PortfolioModel tempPortfolioModel;
    for (int j = i + 1; j < portfolioModel.length; j++) {
      if (portfolioModel[i].sharesNum * portfolioModel[i].currentPrice <
          portfolioModel[j].sharesNum * portfolioModel[j].currentPrice) {
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
        (portfolioModel[i].currentPrice * portfolioModel[i].sharesNum) /
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

class YachtPortfolioView extends StatelessWidget {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  YachtPortfolioView() {
    methodCalcPortfolioModelForUI();
  }

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
                                awardInfo.awardTitle,
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
                                      awardInfo.awardDescription,
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
                        portfolioModel[0].stockName,
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
                percentage1: portfolioModelForUI[i].startPercentage * 100,
                percentage2: portfolioModelForUI[i].endPercentage * 100),
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
      if (portfolioModelForUI[i].visible)
        result.add(
          Positioned(
            left: portfolioModelForUI[i].portionOffsetFromCenter.dx,
            top: portfolioModelForUI[i].portionOffsetFromCenter.dy,
            child: Text(
              '${portfolioModelForUI[i].percentage}%',
              style: portionTxtStyle,
            ),
          ),
        );
      if (portfolioModelForUI[i].visible)
        result.add(
          Positioned(
              left: portfolioModelForUI[i].stockNameOffsetFromCenter.dx,
              top: portfolioModelForUI[i].stockNameOffsetFromCenter.dy,
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
                  portfolioModel[i].stockName,
                  style: stockNameTxtStyle,
                ),
              )),
        );
    }

    return result;
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

    double arcAngle1 = 2 * math.pi * (percentage1 / 100) - math.pi / 2;
    double arcAngle2 = 2 * math.pi * (percentage2 / 100) - math.pi / 2;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle1,
        arcAngle2 - arcAngle1, true, paint);
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
