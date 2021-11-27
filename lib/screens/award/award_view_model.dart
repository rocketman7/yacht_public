import 'dart:ui';

import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import 'dart:math' as math;

import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';

import '../../services/firestore_service.dart';
import '../../models/subLeague_model.dart';

class AwardViewModel extends GetxController {
  FirestoreService _firestoreService = FirestoreService();
  List<SubLeagueModel> allSubLeagues = [];
  bool isAllSubLeaguesLoaded = false;
  RxInt pageIndexForHomeUI = 0.obs;
  RxInt pageIndexForUI = 0.obs;
  List<double> totalValue = [];
  List<double> totalCurrentValue = [];

  //for STATE
  // RxString test = homeRepositoryStateStream1;

  //for UI..
  final portfolioArcRadius = SizeConfig.screenWidth - 14.0.w * 4;
  List<List<SubLeaguePortfolioUIModel>> subLeaguePortfolioUIModels = [[]];
  RxList<labelState> isMaxLabel = [labelState.NONEED].obs;

  @override
  void onInit() async {
    print('award view model oninit');
    // 실제 홈 화면에서도 얘를 가장 먼저 호출해야할듯? 가장 중요하면서 위에 있는 정보니까.
    allSubLeagues = await getAllSubLeague();

    for (int i = 0; i < allSubLeagues.length; i++) {
      // for (int j = 0; j < allSubLeagues[i].stocks.length; j++) {
      //   allSubLeagues[i].stocks[j].currentPrice = await _firestoreService
      //       .getCurrentStocksPrice(allSubLeagues[i].stocks[j].issueCode);
      // }
      for (var items in allSubLeagues[i].stocks) {
        items.currentPrice = await _firestoreService.getCurrentStocksPrice(items.issueCode);
      }
    }

    sortAwardStocksAndCalcUIvar();
    isAllSubLeaguesLoaded = true;
    update();

    super.onInit();
  }

  // DB에서 모든 서브리그를 불러온다.
  Future getAllSubLeague() async {
    return _firestoreService.getAllSubLeague();
  }

  // 서브리그들마다 / 주식들의 비중을 정렬해주고 UI위한 변수를 계산해준다.
  void sortAwardStocksAndCalcUIvar() {
    subLeaguePortfolioUIModels = [[]];
    totalValue = [];
    totalCurrentValue = [];
    isMaxLabel.remove(labelState.NONEED);

    // award 의 갯수만큼 돌아가야함. (페이지당 하나의 어워드 = 페이지 갯수만큼)
    for (int v = 0; v < allSubLeagues.length; v++) {
      subLeaguePortfolioUIModels.add([]);
      isMaxLabel.add(allSubLeagues[v].stocks.length > labelMaxNum ? labelState.NEED_MIN : labelState.NONEED);

      // 어워드의 상금 전체 가치 계산
      totalValue.add(0.0);
      totalCurrentValue.add(0.0);
      for (int i = 0; i < allSubLeagues[v].stocks.length; i++) {
        totalValue[v] += allSubLeagues[v].stocks[i].sharesNum * allSubLeagues[v].stocks[i].standardPrice;

        totalCurrentValue[v] += allSubLeagues[v].stocks[i].sharesNum *
            (allSubLeagues[v].stocks[i].currentPrice ?? allSubLeagues[v].stocks[i].standardPrice);
        // 혹시 몰라서 currentPrice없으면 걍 standardPrice로

        // print(totalCurrentValue[v]);
      }

      for (int i = 0; i < allSubLeagues[v].stocks.length; i++) {
        // awardModels[i].totalAwardValue = 0.0;

        double accumPercentage = 0.0;

        // 각 종목 비중별로 정렬한다.
        for (int j = 0; j < allSubLeagues[v].stocks.length; j++) {
          SubLeagueStocksModel tempSubLeagueStockModel;
          for (int k = j + 1; k < allSubLeagues[v].stocks.length; k++) {
            if (allSubLeagues[v].stocks[j].sharesNum *
                    (allSubLeagues[v].stocks[j].currentPrice ?? allSubLeagues[v].stocks[j].standardPrice) <
                allSubLeagues[v].stocks[k].sharesNum *
                    (allSubLeagues[v].stocks[k].currentPrice ?? allSubLeagues[v].stocks[k].standardPrice)) {
              tempSubLeagueStockModel = allSubLeagues[v].stocks[j];
              allSubLeagues[v].stocks[j] = allSubLeagues[v].stocks[k];
              allSubLeagues[v].stocks[k] = tempSubLeagueStockModel;
            }
          }
        }

        // UI를 위한 모델을 채워준다.
        if (allSubLeagues[v].stocks.length == 1) {
          Size portionTxtSize = textSizeGet('100%', subLeagueAwardPortionStyle);
          Size stockNameTxtSize = textSizeGet('${allSubLeagues[v].stocks[0].name}', subLeagueAwardStockNameStyle);

          subLeaguePortfolioUIModels[v].add(SubLeaguePortfolioUIModel(
            legendVisible: true,
            roundPercentage: 100,
            startPercentage: 0,
            endPercentage: 100,
            portionOffsetFromCenter: Offset(
                portfolioArcRadius / 2 - portionTxtSize.width / 2, portfolioArcRadius / 2 - portionTxtSize.height),
            stockNameOffsetFromCenter:
                Offset(portfolioArcRadius / 2 - stockNameTxtSize.width / 2, portfolioArcRadius / 2),
          ));
        } else {
          for (int j = 0; j < allSubLeagues[v].stocks.length; j++) {
            double portion = ((allSubLeagues[v].stocks[j].currentPrice ?? allSubLeagues[v].stocks[j].standardPrice) *
                    allSubLeagues[v].stocks[j].sharesNum) /
                totalCurrentValue[v];
            double nextAccumPercentage = accumPercentage + portion;
            int portionInt = (portion * 100).round();
            Size portionTxtSize = textSizeGet('$portionInt%', subLeagueAwardPortionStyle);
            Size stockNameTxtSize = textSizeGet('${allSubLeagues[v].stocks[j].name}', subLeagueAwardStockNameStyle);
            bool legendVisible = portion >= legendVisiblePercentage ? true : false;

            //
            subLeaguePortfolioUIModels[v].add(SubLeaguePortfolioUIModel(
              legendVisible: legendVisible,
              roundPercentage: portionInt,
              startPercentage: accumPercentage,
              endPercentage: nextAccumPercentage,
              portionOffsetFromCenter: Offset(
                  portfolioArcRadius / 2 +
                      (portfolioArcRadius / 2) *
                          0.5 *
                          math.cos(2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) - math.pi / 2) -
                      portionTxtSize.width / 2,
                  portfolioArcRadius / 2 +
                      (portfolioArcRadius / 2) *
                          0.5 *
                          math.sin(2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) - math.pi / 2) -
                      portionTxtSize.height),
              stockNameOffsetFromCenter: Offset(
                  portfolioArcRadius / 2 +
                              (portfolioArcRadius / 2) *
                                  0.5 *
                                  math.cos(2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) - math.pi / 2) -
                              stockNameTxtSize.width / 2 >
                          0
                      ? portfolioArcRadius / 2 +
                                  (portfolioArcRadius / 2) *
                                      0.5 *
                                      math.cos(
                                          2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) - math.pi / 2) +
                                  stockNameTxtSize.width / 2 <
                              portfolioArcRadius
                          ? portfolioArcRadius / 2 +
                              (portfolioArcRadius / 2) *
                                  0.5 *
                                  math.cos(2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) - math.pi / 2) -
                              stockNameTxtSize.width / 2
                          : portfolioArcRadius - stockNameTxtSize.width
                      : 0,
                  portfolioArcRadius / 2 +
                      (portfolioArcRadius / 2) *
                          0.5 *
                          math.sin(2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) - math.pi / 2)),
            ));

            accumPercentage = nextAccumPercentage;
          }
        }
      }
    }
  }

  // 서브리그 내 개별주식가치 현재총합을 계산해준다.
  double getStockCurrentTotalValue(int i, int j) {
    double tempValue = 0.0;

    tempValue += allSubLeagues[i].stocks[j].sharesNum *
        (allSubLeagues[i].stocks[j].currentPrice ?? allSubLeagues[i].stocks[j].standardPrice);

    return tempValue;
  }

  // 서브리그 내 개별주식가치 기준 총합을 계산해준다.
  double getStockStandardTotalValue(int i, int j) {
    double tempValue = 0.0;

    tempValue += allSubLeagues[i].stocks[j].sharesNum * allSubLeagues[i].stocks[j].standardPrice;

    return tempValue;
  }

  // 페이지 이동
  void pageNavigateToRight() {
    if (isAllSubLeaguesLoaded && pageIndexForUI.value < (allSubLeagues.length - 1)) {
      pageIndexForUI++;
    }
  }

  void pageNavigateToLeft() {
    if (isAllSubLeaguesLoaded && pageIndexForUI.value > 0) {
      pageIndexForUI--;
    }
  }

  // 더보기 / 닫기 스위칭
  void moreStockOrCancel(int index) {
    if (isMaxLabel[index] == labelState.NEED_MAX)
      isMaxLabel[index] = labelState.NEED_MIN;
    else if (isMaxLabel[index] == labelState.NEED_MIN) isMaxLabel[index] = labelState.NEED_MAX;
  }

  // color index 고르기
  // 아래 color는 style_constant -> awardColor list의 색깔들을
  // 1, 2, 3, ..., color갯수-1, color갯수, color갯수-1, ..., 3, 2, 1, 2, 3, ... 처럼 쓰기 위함
  Color colorIndex(int index, int sideOrCenter) {
    //sideOrCenter => 0 or 1
    return awardColors[index < awardColors.length
        ? index
        : (((index - awardColors.length) / (awardColors.length - 1)).floor() % 2) == 1
            ? (index -
                    awardColors.length -
                    ((index - awardColors.length) / (awardColors.length - 1)).floor() * (awardColors.length - 1)) +
                1
            : (awardColors.length - 1) -
                (index -
                    awardColors.length -
                    ((index - awardColors.length) / (awardColors.length - 1)).floor() * (awardColors.length - 1)) -
                1][sideOrCenter];
  }

  //지난 시즌 DB test
  Future testLastLeaguesDB() async {
    // await _firestoreService.updateTestDBForLastLeagues(allSubLeagues[2]);
    // await _firestoreService.updateTestDBForLastLeaguesFinalRanks();
  }
}

// portfolio UI 위한 class 및 변수
// 15% 이상일 경우만 주식명 및 비중을 보여준다 (즉 위 UI 모델의 legendVisible이 true)
const legendVisiblePercentage = 0.15;
const labelMaxNum = 5;

// labelMaxNum 이하로 스탁갯수가 있으면 더보기/닫기 해줄 필요 없으니 NONEED,
enum labelState { NONEED, NEED_MAX, NEED_MIN }

// (award 포트폴리오 UI에 필요한 모델. award 모델의 갯수만큼 정확히 있어야 함.)
class SubLeaguePortfolioUIModel {
  // 모델을 먼저 선언해주고 값들을 나중에 계산해줄 것이기 때문에 nullable로??
  final bool? legendVisible; // 주식명 및 비중 보여줄 것인지
  final int? roundPercentage; // 정수로 반올림된 퍼센테이지
  final double? startPercentage; // 원을 0~100으로 봤을 때 어디서 시작?
  final double? endPercentage; // .. 어디서 끝?
  final Offset? portionOffsetFromCenter; // 비중의 offset 계산
  final Offset? stockNameOffsetFromCenter; // 주식명의 offset 계산

  SubLeaguePortfolioUIModel({
    this.legendVisible = true,
    this.roundPercentage = 0,
    this.startPercentage = 0.0,
    this.endPercentage = 0.0,
    this.portionOffsetFromCenter = const Offset(0, 0),
    this.stockNameOffsetFromCenter = const Offset(0, 0),
  });
}

///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////
//// 아래는 repository 및 DB admin state manage (stream) 을 위한 것들을 구현해본 것
// 전역변수를 써야하나?
// RxString homeRepositoryStateStream1 = ''.obs;
// RxString homeRepositoryStateStream2 = ''.obs;

// class HomeRepository extends GetxController {
//   FirestoreService _firestoreService = FirestoreService();

//   @override
//   void onInit() {
//     homeRepositoryStateStream1.bindStream(getStateStream1());
//     homeRepositoryStateStream2.bindStream(getStateStream2());

//     homeRepositoryStateStream1.listen((stream) {
//       print('state stream1 come ==> $stream');
//     });

//     homeRepositoryStateStream2.listen((stream) {
//       print('state stream2 come ==> $stream');
//     });

//     super.onInit();
//   }

//   Stream<String> getStateStream1() {
//     return _firestoreService.getStateStream1();
//   }

//   Stream<String> getStateStream2() {
//     return _firestoreService.getStateStream2();
//   }

//   // late Stream<String> stateStream = _firestoreService.getStateStream();
// }
