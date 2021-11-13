import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/subLeague_model.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../models/last_subLeague_model.dart';

import '../../services/firestore_service.dart';
import 'award_view_model.dart';
import 'last_award_view.dart';

class LastAwardDetailViewModel extends GetxController {
  LastAwardDetailViewModel({required this.lastSubLeague});

  FirestoreService _firestoreService = FirestoreService();

  LastSubLeagueModel lastSubLeague;
  List<FinalRankModel> allFinalRanks = [];

  List<num> rankNums = [];
  List<Map<String, num>> rankOrder = [];

  bool isLastSubLeaguesAllLoaded = false;

  bool moreRanks = false;

  //for UI..
  final portfolioArcRadius = SizeConfig.screenWidth - 14.0.w * 4;
  List<SubLeaguePortfolioUIModel> subLeaguePortfolioUIModels = [];
  // Rx<labelState> isMaxLabel = labelState.NONEED.obs;

  double totalValue = 0.0;
  double totalCurrentValue = 0.0;

  @override
  void onInit() async {
    allFinalRanks = await _firestoreService.getFinalRanks(lastSubLeague.docId);

    orderingRanks();

    isLastSubLeaguesAllLoaded = true;

    sortAwardStocksAndCalcUIvar();

    update();

    // print(allFinalRanks[0].award[0].sharesNum);

    super.onInit();
  }

  void orderingRanks() {
    rankNums.clear();
    rankOrder.clear();

    for (int i = 0; i < allFinalRanks.length; i++) {
      rankNums.addIf(!rankNums.contains(allFinalRanks[i].todayRank),
          allFinalRanks[i].todayRank);
    }

    for (int i = 0; i < rankNums.length; i++) {
      rankOrder.add({'rank': rankNums[i], 'nums': 0});
    }

    for (int i = 0; i < allFinalRanks.length; i++) {
      rankOrder[rankNums.indexOf(allFinalRanks[i].todayRank)]['nums'] =
          rankOrder[rankNums.indexOf(allFinalRanks[i].todayRank)]['nums']! + 1;
    }

    for (int i = 0; i < rankNums.length; i++) {
      rankOrder[i]['firstIndex'] = rankOrder[i]['rank']! - 1;
    }

    // print(rankOrder);
  }

  double getAwardPrice(int index) {
    double sum = 0.0;

    for (int i = 0; i < allFinalRanks[index].award.length; i++) {
      if (allFinalRanks[index].award[i].isStock) {
        sum = sum +
            lastSubLeague
                    .stocks[allFinalRanks[index].award[i].stocksIndex!.toInt()]
                    .currentPrice! *
                allFinalRanks[index].award[i].sharesNum!.toInt();
      } else {
        sum = sum + allFinalRanks[index].award[i].yachtPoint!;
      }
    }

    return sum;
  }

  void moreRanksMethod() {
    moreRanks = !moreRanks;

    update();
  }

  List<FinalRankModel> getRanksModels(int ranks) {
    List<FinalRankModel> tempRanks = [];

    for (int i = 0; i < allFinalRanks.length; i++) {
      if (allFinalRanks[i].todayRank == ranks) {
        tempRanks.add(allFinalRanks[i]);
      }
    }

    return tempRanks;
  }

  // award view model 에서 복붙한것임.
  // 서브리그들마다 / 주식들의 비중을 정렬해주고 UI위한 변수를 계산해준다.
  void sortAwardStocksAndCalcUIvar() {
    subLeaguePortfolioUIModels = [];

    // if (lastSubLeague.stocks.length > labelMaxNum) {
    //   isMaxLabel(labelState.NEED_MIN);
    // } else {
    //   isMaxLabel(labelState.NONEED);
    // }

    // 어워드의 상금 전체 가치 계산
    totalValue = 0.0;
    totalCurrentValue = 0.0;
    for (int i = 0; i < lastSubLeague.stocks.length; i++) {
      totalValue += lastSubLeague.stocks[i].sharesNum *
          lastSubLeague.stocks[i].standardPrice;

      totalCurrentValue += lastSubLeague.stocks[i].sharesNum *
          (lastSubLeague.stocks[i].currentPrice ??
              lastSubLeague.stocks[i].standardPrice);
      // 혹시 몰라서 currentPrice없으면 걍 standardPrice로

      // print(totalCurrentValue[v]);
    }

    for (int i = 0; i < lastSubLeague.stocks.length; i++) {
      // awardModels[i].totalAwardValue = 0.0;

      double accumPercentage = 0.0;

      // 각 종목 비중별로 정렬한다.
      for (int j = 0; j < lastSubLeague.stocks.length; j++) {
        SubLeagueStocksModel tempSubLeagueStockModel;
        for (int k = j + 1; k < lastSubLeague.stocks.length; k++) {
          if (lastSubLeague.stocks[j].sharesNum *
                  (lastSubLeague.stocks[j].currentPrice ??
                      lastSubLeague.stocks[j].standardPrice) <
              lastSubLeague.stocks[k].sharesNum *
                  (lastSubLeague.stocks[k].currentPrice ??
                      lastSubLeague.stocks[k].standardPrice)) {
            tempSubLeagueStockModel = lastSubLeague.stocks[j];
            lastSubLeague.stocks[j] = lastSubLeague.stocks[k];
            lastSubLeague.stocks[k] = tempSubLeagueStockModel;
          }
        }
      }

      // UI를 위한 모델을 채워준다.
      if (lastSubLeague.stocks.length == 1) {
        Size portionTxtSize =
            textSizeGet('100%', lastLeagueDetailViewPortfolioPercentage);
        Size stockNameTxtSize = textSizeGet('${lastSubLeague.stocks[0].name}',
            lastLeagueDetailViewPortfolioName);

        subLeaguePortfolioUIModels.add(SubLeaguePortfolioUIModel(
          legendVisible: true,
          roundPercentage: 100,
          startPercentage: 0,
          endPercentage: 100,
          portionOffsetFromCenter: Offset(
              portfolioArcRadius / 2 - portionTxtSize.width / 2,
              portfolioArcRadius / 2 - portionTxtSize.height),
          stockNameOffsetFromCenter: Offset(
              portfolioArcRadius / 2 - stockNameTxtSize.width / 2,
              portfolioArcRadius / 2),
        ));
      } else {
        for (int j = 0; j < lastSubLeague.stocks.length; j++) {
          double portion = ((lastSubLeague.stocks[j].currentPrice ??
                      lastSubLeague.stocks[j].standardPrice) *
                  lastSubLeague.stocks[j].sharesNum) /
              totalCurrentValue;
          double nextAccumPercentage = accumPercentage + portion;
          int portionInt = (portion * 100).round();
          Size portionTxtSize = textSizeGet(
              '$portionInt%', lastLeagueDetailViewPortfolioPercentage);
          Size stockNameTxtSize = textSizeGet('${lastSubLeague.stocks[j].name}',
              lastLeagueDetailViewPortfolioName);
          bool legendVisible =
              portion >= legendVisiblePercentage ? true : false;

          //
          subLeaguePortfolioUIModels.add(SubLeaguePortfolioUIModel(
            legendVisible: legendVisible,
            roundPercentage: portionInt,
            startPercentage: accumPercentage,
            endPercentage: nextAccumPercentage,
            portionOffsetFromCenter: Offset(
                portfolioArcRadius / 2 +
                    (portfolioArcRadius / 2) *
                        0.5 *
                        math.cos(2 *
                                math.pi *
                                ((accumPercentage + nextAccumPercentage) / 2) -
                            math.pi / 2) -
                    portionTxtSize.width / 2,
                portfolioArcRadius / 2 +
                    (portfolioArcRadius / 2) *
                        0.5 *
                        math.sin(2 *
                                math.pi *
                                ((accumPercentage + nextAccumPercentage) / 2) -
                            math.pi / 2) -
                    portionTxtSize.height),
            stockNameOffsetFromCenter: Offset(
                portfolioArcRadius / 2 +
                            (portfolioArcRadius / 2) *
                                0.5 *
                                math.cos(2 *
                                        math.pi *
                                        ((accumPercentage + nextAccumPercentage) /
                                            2) -
                                    math.pi / 2) -
                            stockNameTxtSize.width / 2 >
                        0
                    ? portfolioArcRadius / 2 +
                                (portfolioArcRadius / 2) *
                                    0.5 *
                                    math.cos(
                                        2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) -
                                            math.pi / 2) +
                                stockNameTxtSize.width / 2 <
                            portfolioArcRadius
                        ? portfolioArcRadius / 2 +
                            (portfolioArcRadius / 2) *
                                0.5 *
                                math.cos(
                                    2 * math.pi * ((accumPercentage + nextAccumPercentage) / 2) -
                                        math.pi / 2) -
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

  // 서브리그 내 개별주식가치 현재총합을 계산해준다.
  double getStockCurrentTotalValue(int j) {
    double tempValue = 0.0;

    tempValue += lastSubLeague.stocks[j].sharesNum *
        (lastSubLeague.stocks[j].currentPrice ??
            lastSubLeague.stocks[j].standardPrice);

    return tempValue;
  }

  // 서브리그 내 개별주식가치 기준 총합을 계산해준다.
  double getStockStandardTotalValue(int j) {
    double tempValue = 0.0;

    tempValue += lastSubLeague.stocks[j].sharesNum *
        lastSubLeague.stocks[j].standardPrice;

    return tempValue;
  }

  // 더보기 / 닫기 스위칭
  // void moreStockOrCancel() {
  //   if (isMaxLabel.value == labelState.NEED_MAX)
  //     isMaxLabel(labelState.NEED_MIN);
  //   else if (isMaxLabel.value == labelState.NEED_MIN)
  //     isMaxLabel(labelState.NEED_MAX);
  // }
}
