import 'dart:async';
import 'package:flutter/material.dart';
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

class ChartForAllViewModel extends FutureViewModel {
  final String countryCode;
  final String stockOrIndex;
  final String issueCode;
  final StreamController priceStreamCtrl;
  final StreamController dateTimeStreamCtrl;
  final StreamController scrollStreamCtrl;

  ChartForAllViewModel(
    this.countryCode,
    this.stockOrIndex,
    this.issueCode,
    this.priceStreamCtrl,
    this.dateTimeStreamCtrl,
    this.scrollStreamCtrl,
  ) {
    lastDays = durationString[isDurationSelected.indexOf(true)];
    uid = _authService.auth.currentUser.uid;
  }

  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  List<ChartModel> chartList;
  List<PriceModel> liveList;
  double displayPrice = 0.0;
  DateTime displayDateTime;
  bool isSelected = false;
  bool isDaysVisible = true;
  String uid;
  StockInfoModel stockInfoModel;
  IndexInfoModel indexInfoModel;

  // 차트 기간 설정 관련된 변수들
  List<bool> isDurationSelected = [false, false, false, true];
  List<String> durationChoiceString = ["1개월", "3개월", "6개월", "1년"];
  List<String> durationString = ["지난 1개월", "지난 3개월", "지난 6개월", "지난 1년"];
  List<int> durationDays = [20, 60, 120, 200];

  int durationIndex;
  String lastDays;
  int priceSubLength = 200;

  Future getAllModel(
    countryCode,
    stockOrIndex,
    issueCode,
  ) async {
    stockOrIndex == "stocks"
        ? stockInfoModel = await _databaseService.getStockInfo(
            countryCode,
            issueCode,
          )
        : indexInfoModel = await _databaseService.getIndexInfo(
            countryCode,
            issueCode,
          );

    chartList = await _databaseService.getPriceForChart(
      countryCode,
      issueCode,
    );

    whenTrackEnd();
  }

  void trackball(TrackballArgs args) {
    if (isDaysVisible) {
      isDaysVisible = false;
      notifyListeners();
    }

    displayPrice = args.chartPointInfo.chartDataPoint.y;
    displayDateTime = args.chartPointInfo.chartDataPoint.x;
    HapticFeedback.lightImpact();
    priceStreamCtrl.add(displayPrice);
    dateTimeStreamCtrl.add(displayDateTime);
  }

  void scrollPosition(ScrollController controller) {
    double position = controller.offset;
    scrollStreamCtrl.add(position);
  }

  void whenTrackEnd() {
    displayPrice = chartList.last.close;
    displayDateTime = strToDate(chartList.last.date);
    priceStreamCtrl.add(displayPrice);
    dateTimeStreamCtrl.add(displayDateTime);
    isDaysVisible = true;
    notifyListeners();
  }

  void whenTrackEndOnLive(double price, DateTime today) {
    priceStreamCtrl.add(price);
    dateTimeStreamCtrl.add(today);
    isDaysVisible = true;
    notifyListeners();
  }

  void whenTrackStart(ChartTouchInteractionArgs args) {}

  void changeDuration(int durationIndex) {
    priceSubLength = durationDays[durationIndex];
    lastDays = durationString[durationIndex];
    isDurationSelected = [false, false, false, false];
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
