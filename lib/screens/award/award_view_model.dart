import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:math' as math;
import 'dart:async';

import '../../styles/size_config.dart';

// 임시 모델. 나중에 firebase DB와 연동시켜야하고 / models에 만들어야함
// 그리고 copyWith 같은거 있는 표준 폼으로 바꿔야 함
// 하나의 어워드에 대한 정보를 담는다
class AwardModel {
  // 필수적으로 있어야 하는 정보들이므로? non-nullable로 선언해준다.
  final String awardTitle;
  final String awardDescription;
  final List<AwardStockModel> awardStockModels;
  // 모델을 먼저 선언해주고 값들을 나중에 계산해줄 것이기 때문에 nullable로??
  double totalAwardValue = 0.0;
  final List<AwardStockUIModel>? awardStockUIModels;
  // 테마색깔을 정하지 않았을 경우 기본테마색으로. 즉, nullable??
  final List<String>? awardThemeColors;
  // 첫번째 인덱스는 슬리버앱바의 타이틀색깔임과 동시에 비중이 가장 높은 종목의 포트폴리오 색깔
  // 두번째 인덱스는 비중이 두번째로 높은 종목의 포트폴리오 색깔
  // ....
  // 우리가 생성하는 어워드의 경우 어워드 종목 갯수만큼의 배열이 존재해야함 (그 이상은 어차피 활용안되고)
  // #나중에 사용자들이 생성하는 포트폴리오의 경우는 테마색깔을 이런 배열보다는 다른 식으로 구현해야 할 듯

  AwardModel({
    required this.awardTitle,
    required this.awardDescription,
    required this.awardStockModels,
    this.totalAwardValue = 0.0,
    this.awardStockUIModels,
    this.awardThemeColors,
  });
}

// 임시 모델. 나중에 firebase DB와 연동시켜야하고 / models에 만들어야함
// 그리고 copyWith 같은거 있는 표준 폼으로 바꿔야 함
// 어워드를 구성하는 주식 하나하나의 모델
class AwardStockModel {
  // 필수적으로 있어야 하는 정보들이므로? non-nullable로 선언해준다.
  final String stockName; // 주식이름
  final int sharesNum; // 몇 주?
  final double currentPrice; // 현재가격 (혹은 가장 최근 종가)

  AwardStockModel({
    required this.stockName,
    required this.sharesNum,
    required this.currentPrice,
  });
}

// award 포트폴리오 UI에 필요한 모델. award 모델의 갯수만큼 정확히 있어야 함.
class AwardStockUIModel {
  // 모델을 먼저 선언해주고 값들을 나중에 계산해줄 것이기 때문에 nullable로??
  final bool? legendVisible; // 주식명 및 비중 보여줄 것인지
  final int? roundPercentage; // 정수로 반올림된 퍼센테이지
  final double? startPercentage; // 원을 0~100으로 봤을 때 어디서 시작?
  final double? endPercentage; // .. 어디서 끝?
  final Offset? portionOffsetFromCenter; // 비중의 offset 계산
  final Offset? stockNameOffsetFromCenter; // 주식명의 offset 계산
  final dynamic colorCode; // 테마색깔에서 가져올 주식의 고유 색깔

  AwardStockUIModel(
      {this.legendVisible = true,
      this.roundPercentage = 0,
      this.startPercentage = 0.0,
      this.endPercentage = 0.0,
      this.portionOffsetFromCenter = const Offset(0, 0),
      this.stockNameOffsetFromCenter = const Offset(0, 0),
      this.colorCode = 'FFFFFF'});
}

// 15% 이상일 경우만 주식명 및 비중을 보여준다 (즉 위 UI 모델의 legendVisible이 true)
const legendVisiblePercentage = 0.15;

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

// getx viewModel(controller)
class AwardViewModel extends GetxController {
  // 어워드 종류가 몇 개냐에 따라 아래 List들의 length가 결정
  List<AwardModel> awardModels = [];

  /////////////////////////////////////////////////////////////////
  String appBarTitle = '';
  String totalAwardValueStr = '';

  void updateAppBarTitle(int page) {
    appBarTitle = awardModels[page].awardTitle;
    totalAwardValueStr = awardModels[page].totalAwardValue.toString();

    update();
  }
  /////////////////////////////////////////////////////////////////

  @override
  void onInit() {
    super.onInit();

    return getModels();
  }

  void getModels() async {
    // Timer(Duration(seconds: 3), () {
    // temp 변수들. 나중에 DB랑 연동시키면 없어져도 될 듯?
    List<AwardStockModel> awardStockModels = [
      AwardStockModel(
        stockName: '하이트진로', // 000080
        sharesNum: 12,
        currentPrice: 39900,
      ),
      AwardStockModel(
        stockName: 'JYP Ent', // 035900 코스닥
        sharesNum: 6,
        currentPrice: 39950,
      ),
      AwardStockModel(
        stockName: 'LG화학', // 051910
        sharesNum: 1,
        currentPrice: 850000,
      ),
      AwardStockModel(
        stockName: '한국타이어앤테크놀로지', // 161390
        sharesNum: 104,
        currentPrice: 53600,
      ),
      AwardStockModel(
        stockName: 'NHN한국사이버결제', // 060250 코스닥
        sharesNum: 56,
        currentPrice: 53900,
      ),
      AwardStockModel(
        stockName: '삼성전자', // 005930
        sharesNum: 24,
        currentPrice: 81000,
      ),
    ];

    List<String> awardThemeColors = [
      '4F77F7',
      '5399E0',
      '48BADD',
      '4CEDE9',
      '88F3F1',
      'BEF1F0',
      'CFF8F7',
    ];

    awardModels.add(AwardModel(
        awardTitle: '요트 점수 Top3',
        awardDescription:
            '요트 점수가 가장 높은 세 분에게! 공동 우승 시 상금은 어떻게 드려요.\n예를 들어, 이럴 경우 이렇게 드려요.',
        awardStockModels: awardStockModels,
        awardStockUIModels: [],
        awardThemeColors: awardThemeColors));

    awardModels.add(AwardModel(
        awardTitle: '요트 추천왕 Top100',
        awardDescription: '요트를 친구에게 가장 많이 추천해 준 100분에게 드려요.',
        awardStockModels: awardStockModels,
        awardStockUIModels: [],
        awardThemeColors: awardThemeColors));

    awardModels.add(AwardModel(
        awardTitle: '요트 소통왕 Top200',
        awardDescription: '가장 많은 하트 받으신 분에게',
        awardStockModels: [
          AwardStockModel(
            stockName: '카카오',
            sharesNum: 1,
            currentPrice: 500000,
          )
        ],
        awardStockUIModels: [],
        awardThemeColors: awardThemeColors));

    sortAwardStocksAndCalcUIvar();
    // });
  }

  void sortAwardStocksAndCalcUIvar() {
    // award 의 갯수만큼 돌아가야함. (페이지당 하나의 어워드 = 페이지 갯수만큼)
    for (int i = 0; i < awardModels.length; i++) {
      awardModels[i].totalAwardValue = 0.0;

      double accumPercentage = 0.0;

      // 어워드의 상금 전체 가치 계산
      for (int j = 0; j < awardModels[i].awardStockModels.length; j++) {
        awardModels[i].totalAwardValue +=
            awardModels[i].awardStockModels[j].sharesNum *
                awardModels[i].awardStockModels[j].currentPrice;
      }

      // 각 종목 비중별로 정렬한다.
      for (int j = 0; j < awardModels[i].awardStockModels.length; j++) {
        AwardStockModel tempAwardStockModel;
        for (int k = j + 1; k < awardModels[i].awardStockModels.length; k++) {
          if (awardModels[i].awardStockModels[j].sharesNum *
                  awardModels[i].awardStockModels[j].currentPrice <
              awardModels[i].awardStockModels[k].sharesNum *
                  awardModels[i].awardStockModels[k].currentPrice) {
            tempAwardStockModel = awardModels[i].awardStockModels[j];
            awardModels[i].awardStockModels[j] =
                awardModels[i].awardStockModels[k];
            awardModels[i].awardStockModels[k] = tempAwardStockModel;
          }
        }
      }

      // UI를 위한 모델을 채워준다.
      for (int j = 0; j < awardModels[i].awardStockModels.length; j++) {
        double portion = (awardModels[i].awardStockModels[j].currentPrice *
                awardModels[i].awardStockModels[j].sharesNum) /
            awardModels[i].totalAwardValue;
        double nextAccumPercentage = accumPercentage + portion;
        int portionInt = (portion * 100).round();
        Size portionTxtSize = textSizeGet('$portionInt%', portionTxtStyle);
        Size stockNameTxtSize = textSizeGet(
            '${awardModels[i].awardStockModels[j].stockName}',
            stockNameTxtStyle);
        bool legendVisible = portion >= legendVisiblePercentage ? true : false;

        //
        awardModels[i].awardStockUIModels!.add(
              AwardStockUIModel(
                legendVisible: legendVisible,
                roundPercentage: portionInt,
                startPercentage: accumPercentage,
                endPercentage: nextAccumPercentage,
                portionOffsetFromCenter: Offset(
                    portfolioArcRadius / 2 +
                        (portfolioArcRadius / 2) *
                            0.6 *
                            math.cos(2 *
                                    math.pi *
                                    ((accumPercentage + nextAccumPercentage) /
                                        2) -
                                math.pi / 2) -
                        portionTxtSize.width / 2,
                    portfolioArcRadius / 2 +
                        (portfolioArcRadius / 2) *
                            0.6 *
                            math.sin(2 *
                                    math.pi *
                                    ((accumPercentage + nextAccumPercentage) /
                                        2) -
                                math.pi / 2) -
                        portionTxtSize.height),
                stockNameOffsetFromCenter: Offset(
                    portfolioArcRadius / 2 +
                                (portfolioArcRadius / 2) *
                                    0.6 *
                                    math.cos(2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) -
                                        math.pi / 2) -
                                stockNameTxtSize.width / 2 -
                                txtContainerPadding >
                            0
                        ? portfolioArcRadius / 2 +
                                    (portfolioArcRadius / 2) *
                                        0.6 *
                                        math.cos(2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) -
                                            math.pi / 2) +
                                    stockNameTxtSize.width / 2 +
                                    txtContainerPadding <
                                portfolioArcRadius
                            ? portfolioArcRadius / 2 +
                                (portfolioArcRadius / 2) *
                                    0.6 *
                                    math.cos(2 *
                                            math.pi *
                                            ((accumPercentage + nextAccumPercentage) /
                                                2) -
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
                colorCode: awardModels[i].awardThemeColors![j],
              ),
            );

        accumPercentage = nextAccumPercentage;
      }
    }
  }
}

// text size get 함수. 공통적으로 쓸 수 있으므로 나중에 다른 폴더 / 다른 파일에 넣고 활용
// text 와 textStyle 을 넣으면 Text Widget의 크기가 얼마일지 Size 형식으로 반환해준다.
Size textSizeGet(String txt, TextStyle txtStyle) {
  return (TextPainter(
          text: TextSpan(text: txt, style: txtStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr)
        ..layout())
      .size;
}
