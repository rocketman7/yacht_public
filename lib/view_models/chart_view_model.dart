import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/models/chart_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/views/constants/holiday.dart';
import 'package:flutter/services.dart';
import '../locator.dart';

class ChartViewModel extends FutureViewModel {
  final String countryCode;
  final String issueCode;
  final StreamController priceStreamCtrl;
  final BehaviorSubject behaviorCtrl;
  final StreamController dateTimeStreamCtrl;
  final StreamController scrollStreamCtrl;

  AuthService _authService = locator<AuthService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  List<ChartModel> chartList;
  double displayPrice = 0.0;
  DateTime displayDateTime;
  String uid;
  String lastDays = "지난 1년";
  int subLength = 200;
  bool isSelected = false;
  bool isDaysVisible = true;

  ChartViewModel(
    this.countryCode,
    this.issueCode,
    this.priceStreamCtrl,
    this.behaviorCtrl,
    this.dateTimeStreamCtrl,
    this.scrollStreamCtrl,
  ) {
    uid = _authService.auth.currentUser.uid;
  }

  Future getAllModel(uid) async {
    chartList = await _databaseService.getPriceForChart(
      countryCode,
      issueCode,
    );

    var mapData = await _databaseService.getStats();

    // print(mapData.keys);
    print(mapData['2Q2020']);
    print(mapData['2Q2020']['estEps']);
    print(mapData['3Q2020']);
    mapData.data().values.forEach((e) {
      print(e);
    });
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
    print(position);
    scrollStreamCtrl.add(position);
  }

  void whenTrackEnd(ChartTouchInteractionArgs args) {
    displayPrice = chartList.last.close;
    displayDateTime = strToDate(chartList.last.date);
    priceStreamCtrl.add(displayPrice);
    dateTimeStreamCtrl.add(displayDateTime);
    // behaviorCtrl.add(displayPrice);
    isDaysVisible = true;
    notifyListeners();
  }

  void whenTrackStart(ChartTouchInteractionArgs args) {
    print("Track start");
  }

  void changeDuration(int duration, String days) {
    subLength = duration;
    lastDays = days;
    notifyListeners();
  }

  void selectDescriptionDetail() {
    isSelected = !isSelected;

    notifyListeners();
  }

  @override
  Future futureToRun() => getAllModel(uid);
}
