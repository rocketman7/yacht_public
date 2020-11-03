import 'dart:async';

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
  final StreamController priceStreamCtrl;
  final BehaviorSubject behaviorCtrl;
  final StreamController dateTimeStreamCtrl;
  AuthService _authService = locator<AuthService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  List<ChartModel> chartList;
  double displayPrice = 0.0;
  DateTime displayDateTime;
  String uid;
  int subLength = 200;
  bool isSelected = false;

  ChartViewModel(
    this.priceStreamCtrl,
    this.behaviorCtrl,
    this.dateTimeStreamCtrl,
  ) {
    uid = _authService.auth.currentUser.uid;
  }

  Future getAllModel(uid) async {
    chartList = await _databaseService.getPriceForChart('005930');
  }

  void trackball(TrackballArgs args) {
    // print(args.chartPointInfo.chartDataPoint.y);
    displayPrice = args.chartPointInfo.chartDataPoint.y;
    displayDateTime = args.chartPointInfo.chartDataPoint.x;
    // notifyListeners();
    HapticFeedback.lightImpact();
    priceStreamCtrl.add(displayPrice);
    dateTimeStreamCtrl.add(displayDateTime);
  }

  void whenTrackEnd(ChartTouchInteractionArgs args) {
    print("now");
    displayPrice = chartList.last.close;
    displayDateTime = strToDate(chartList.last.date);
    priceStreamCtrl.add(displayPrice);
    dateTimeStreamCtrl.add(displayDateTime);
    // behaviorCtrl.add(displayPrice);
  }

  void changeDuration(int duration) {
    subLength = duration;
    notifyListeners();
  }

  void selectDescriptionDetail() {
    isSelected = !isSelected;

    notifyListeners();
  }

  @override
  Future futureToRun() => getAllModel(uid);
}
