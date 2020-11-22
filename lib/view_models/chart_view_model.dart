import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/models/chart_model.dart';
import 'package:yachtOne/models/index_info_model.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/models/stock_info_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/views/constants/holiday.dart';
import 'package:flutter/services.dart';
import '../locator.dart';

class ChartViewModel extends FutureViewModel {
  final String countryCode;
  final String stockOrIndex;
  final String issueCode;
  final StreamController priceStreamCtrl;
  final BehaviorSubject behaviorCtrl;
  final StreamController dateTimeStreamCtrl;
  final StreamController scrollStreamCtrl;
  final bool isVoting;

  ChartViewModel(
    this.countryCode,
    this.stockOrIndex,
    this.issueCode,
    this.priceStreamCtrl,
    this.behaviorCtrl,
    this.dateTimeStreamCtrl,
    this.scrollStreamCtrl,
    this.isVoting,
  ) {
    isDurationSelected = isVoting
        ? [false, false, false, false, true]
        : [true, false, false, false, false];
    lastDays = durationString[isDurationSelected.indexOf(true)];
  }

  AuthService _authService = locator<AuthService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  List<ChartModel> chartList;
  double displayPrice = 0.0;
  DateTime displayDateTime;
  bool isSelected = false;
  bool isDaysVisible = true;
  String uid;
  StockInfoModel stockInfoModel;
  IndexInfoModel indexInfoModel;

  // 차트 기간 설정 관련된 변수들

  // List<bool> isDurationSelected = [false, false, false, false, true];
  List<bool> isDurationSelected;
  List<String> durationChoiceString = ["LIVE", "1개월", "3개월", "6개월", "1년"];
  List<String> durationString = ["LIVE", "지난 1개월", "지난 3개월", "지난 6개월", "지난 1년"];
  List<int> durationDays = [10, 20, 60, 120, 200];

  int durationIndex;
  String lastDays;
  int priceSubLength = 200;

  Future getAllModel(
    countryCode,
    stockOrIndex,
    issueCode,
  ) async {
    print("beforeStockinfo" + DateTime.now().toString());

    stockOrIndex == "stocks"
        ? stockInfoModel = await _databaseService.getStockInfo(
            countryCode,
            issueCode,
          )
        : indexInfoModel = await _databaseService.getIndexInfo(
            countryCode,
            issueCode,
          );
    // print("Index info model get" + indexInfoModel.toString());
    print("afterStockInfo" + DateTime.now().toString());
    // notifyListeners();
    chartList = await _databaseService.getPriceForChart(
      countryCode,
      issueCode,
    );
    whenTrackEnd();
    // notifyListeners();
    print("afterChart" + DateTime.now().toString());

    // print(mapData.keys);
    // print(mapData['2Q2020']);
    // print(mapData['2Q2020']['estEps']);
    // print(mapData['3Q2020']);
    // mapData.data().values.forEach((e) {
    //   print(e);
    // });
  }

  Stream<List<PriceModel>> getRealtimePriceForChart(issueCode) {
    return _databaseService.getRealtimePriceForChart(issueCode);
  }

  void trackball(TrackballArgs args) {
    if (isDaysVisible) {
      isDaysVisible = false;
      notifyListeners();
    }

    print("track ball triggered");
    // print(args.chartPointInfo.chartDataPoint.y);
    displayPrice = args.chartPointInfo.chartDataPoint.y;
    displayDateTime = args.chartPointInfo.chartDataPoint.x;
    // notifyListeners();
    HapticFeedback.lightImpact();
    priceStreamCtrl.add(displayPrice);
    dateTimeStreamCtrl.add(displayDateTime);
  }

  void scrollPosition(ScrollController controller) {
    double position = controller.offset;
    // print(position);
    scrollStreamCtrl.add(position);
  }

  void whenTrackEnd() {
    displayPrice = chartList.last.close;
    displayDateTime = strToDate(chartList.last.date);
    priceStreamCtrl.add(displayPrice);
    dateTimeStreamCtrl.add(displayDateTime);
    // behaviorCtrl.add(displayPrice);
    isDaysVisible = true;
    notifyListeners();
  }

  void whenTrackEndOnLive(double price, DateTime today) {
    priceStreamCtrl.add(price);
    dateTimeStreamCtrl.add(today);
    // behaviorCtrl.add(displayPrice);
    isDaysVisible = true;
    notifyListeners();
  }

  void whenTrackStart(ChartTouchInteractionArgs args) {
    print("Track start");
  }

  void changeDuration(int durationIndex) {
    priceSubLength = durationDays[durationIndex];
    lastDays = durationString[durationIndex];
    isDurationSelected = [false, false, false, false, false];
    isDurationSelected[durationIndex] = true;
    notifyListeners();
  }

  void selectDescriptionDetail() {
    isSelected = !isSelected;

    notifyListeners();
  }

  @override
  Future futureToRun() => getAllModel(
        countryCode,
        stockOrIndex,
        issueCode,
      );
}
