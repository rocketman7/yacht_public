import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:quiver/iterables.dart' as quiver;

class ChartViewModel extends GetxController {
  FirestoreService _firestoreService = FirestoreService();
  // Rx<List<PriceChartModel>> priceList = Rx<List<PriceChartModel>>();
  // List<PriceChartModel> get prices => priceList.value;

  List<PriceChartModel>? prices;
  List<PriceChartModel> dailyPrices = [];
  List<PriceChartModel> intradayPrices = [];
  List<PriceChartModel>? chartPrices; //차트에 쓰일 최종 가격 데이터
  List<String> cycles = ["1일", "1주", "1개월", "3개월", "1년", "5년"];
  // 차트 전환 토글
  RxBool showingCandleChart = true.obs;

  // 차트 주기 선택
  int selectedCycle = 0;
  //차트 그리기 위한 가격 Max, Min, 볼륨 Max, Min 변수
  double? _maxPrice;
  double? _minPrice;
  double? _maxVolume;
  double? _minVolume;
  double? get maxPrice => _maxPrice;
  double? get minPrice => _minPrice;
  double? get maxVolume => _maxVolume;
  double? get minVolume => _minVolume;

  // TrackBall 활성화 감지하기
  RxBool isTracking = false.obs;

  // TrackBall에서 가격정보 가져오기
  Rx<num> open = 0.obs;
  Rx<num> close = 0.obs;
  Rx<num> high = 0.obs;
  Rx<num> low = 0.obs;
  Rx<num> volume = 0.obs;

  RxDouble opacity = 1.0.obs;

  // 이 뷰모델을 불러오면 onInit 실행.
  @override
  onInit() {
    super.onInit();
    return getPrices();
  }

  void toggleChartType() {
    showingCandleChart(!showingCandleChart.value);
    update();
  }

  Timer? _timer;
  void opacityDown() {
    if (opacity.value == 1) {
      _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
        if (opacity.value <= 0.1) {
          // opacity(opacity.value = 0.0);
          timer.cancel();
        } else {
          opacity(opacity.value -= 0.02);
          // print(opacity.value);
        }
      });
    }
  }

  // Trackball 움직이고 있을 때
  void onTrackballChanging(TrackballArgs trackballArgs) {
    isTracking(true);
    if (opacity.value < 0.1) {
      opacity(0.0);
    }
    // Future.delayed(Duration(seconds: 1), () {
    if (showingCandleChart.value) {
      print("candle tracking");
      if (trackballArgs.chartPointInfo.seriesIndex == 0) {
        open(trackballArgs.chartPointInfo.chartDataPoint!.open as int);
        close(trackballArgs.chartPointInfo.chartDataPoint!.close as int);
        high(trackballArgs.chartPointInfo.chartDataPoint!.high as int);
        low(trackballArgs.chartPointInfo.chartDataPoint!.low as int);
      } else {
        volume(trackballArgs.chartPointInfo.chartDataPoint!.yValue);
      }
    } else {
      print("line tracking");
      // // print(trackballArgs.chartPointInfo.chartDataPoint!.y);
      close(trackballArgs.chartPointInfo.chartDataPoint!.y as int);
    }

    // });

    // print(trackballArgs.chartPointInfo.series);
    // volume(trackballArgs.chartPointInfo.series.!.y as int);
  }

  // 차트에서 손 떼고 Trackball 없어질 때
  void onTracballEnds() {
    opacity(opacity.value = 1);
    _timer!.cancel();
    isTracking(false);
  }

  // subList를 기간 별로 만들어주는 로직 필요

// update()는 notifyListeners() 처럼 쓰면 되고 그 전에 Future에서 받아온 데이터 넣으면 됨.
  void getPrices() async {
    // print("get Called");
    prices = await _firestoreService.getPrices();
    // subList 기본값 만들어줘야 함

    // 선택된 기간에 따라 priceList 다루기
    // 1. 가장 최근 날짜 get
    // 2. lastDateToBe = today.subtract(원하는 기간)
    // 3. lastDateToBe가 전체 데이터 안에 속하는 날짜인지 체크해야 함
    // 4. lastDateToBe가 휴일이면 어떻게 해아 하나?
    // 5. lastDateToBe가 전체 데이터에 속하고 휴일이 아니면 subList의 last는 lastDateToBe로
    // 6. lastDateToBe가 전체 데이터 밖이면 priceList를 그대로 subList로 쓰되, 빈 날짜를 처리해야 함.
    // print(stringToDateTime(priceList!.first.dateTime!));
    // DateTime today = stringToDateTime(priceList!.first.dateTime!)!;
    // print(today.subtract(Duration(days: 7)));

    // 가져오는 PriceList는 최신이 first로, 오래된 것이 last로 정렬된다
    prices!.forEach((e) {
      if (e.cycle == "D") {
        dailyPrices.add(e);
      } else if (e.cycle == "10M") {
        // print("10M detected");
        intradayPrices.add(e);
      }
    });

    // 1D: 10 mins
    // 1W: 30 mins
    // 1M: 130 mins
    // 3M: 1 day
    // 1Y: 1 week
    // 5Y: 1 month

    // if cycle == 1D {
    //   dateTime == today or closePreviousDay로 지정하고
    //   10M List에서 당일치만 가져옴
    // } else if cycle ==  1W {
    //   today or closePreviousDay로 부터 -4 business day까지
    //   그 뒤에 3개씩 묶어서 ochl을 다시 짠다.
    // } else if cycle == 1M {
    //   today or closePreviousDay 부터 -1 month or -30 days부터
    //   그 뒤에 13개씩 묶어서 ochl 다시 짬
    // } else if cycle == 3M {
    //   dailyPrice그대로 쓰면서 -3 month부터
    // } else if cycle == 1Y {
    //   월-금까지 묶어야 하는데..
    // } else (cycle == 5Y) {
    //   same month 끼리 묶는다.
    // }

    changeCycle();

    // combineCandles(subList!);
    calculateMaxMin();
    update();
  }

  // 차트 아래 주기 버튼 누르면 차트에 그릴 list 새로 만들기
  // 1) 먼저 받아온 차트 데이터에서 기간 별로 나눠주는 로직 구현하고,
  // 2) 데이터가 충분하지 않을 때 어떻게 처리할지 구현해야 함. (빅히트로)
  void changeCycle() {
    switch (cycles[selectedCycle]) {
      case "1일":
        // 임시 price chart model list를 만들고
        List<PriceChartModel> temp = [];
        // intraday price list를 처음(현재로부터 가장 최신)부터 loop
        // print(i);
        for (int i = 0; i < intradayPrices.length; i++) {
          // intradayPriceList.first, 즉 가장 최신의 intraday 데이터에서
          // dateTime을 string으로 변환.
          String? latestDate = intradayPrices.first.dateTime!.substring(0, 8);
          //
          if (intradayPrices[i].dateTime!.substring(0, 8) == latestDate) {
            temp.add(intradayPrices[i]);
          } else {
            break;
          }
        }

        chartPrices = temp;
        calculateMaxMin();
        update();
        break;

      case "1주":
        List<PriceChartModel> subdataForThisInterval = [];
        // subList = [];
        int interval = 3;

        Set<String> days = Set<String>();
        int i = 0;
        // 5 영업일 고르고
        do {
          days.add(intradayPrices[i].dateTime!.substring(0, 8));
          i++;
          if (i > intradayPrices.length - 1) break;
        } while (days.length <= 5);

        // 차트에 쓸 데이터들만
        subdataForThisInterval = intradayPrices.sublist(0, i - 1);
        // dateTime 오름차순으로 정렬
        subdataForThisInterval
            .sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

        chartPrices = loopByCycle(subdataForThisInterval, interval);

        calculateMaxMin();
        update();
        break;

      case "1개월":
        List<PriceChartModel> subdataForThisInterval;

        int interval = 12;
        Set<String> days = Set<String>();
        int i = 0;
        // 5 영업일 고르고
        do {
          days.add(intradayPrices[i].dateTime!.substring(0, 8));
          i++;
          if (i > intradayPrices.length - 1) break;
        } while (days.length <= 20);

        // 차트에 쓸 데이터들만
        subdataForThisInterval = intradayPrices.sublist(0, i - 1);
        // dateTime 오름차순으로 정렬
        subdataForThisInterval
            .sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

        chartPrices = loopByCycle(subdataForThisInterval, interval);
        calculateMaxMin();
        update();
        break;

      case "3개월":
        List<PriceChartModel> temp = [];

        String? latestDate = dailyPrices.first.dateTime!.substring(0, 8);
        // print(latestDate);

        int i = 0;
        // loop 조건이 끝나면 바로 나갈 수 있게 if 대신 while로
        // 현재로부터 90일 이전 날짜까지 포함시키기
        while (stringToDateTime(dailyPrices[i].dateTime!)!.isAfter(
            stringToDateTime(latestDate)!.subtract(Duration(days: 91)))) {
          temp.add(dailyPrices[i]);
          i++;
          if (i > dailyPrices.length - 1) break;
        }
        chartPrices = temp;

        calculateMaxMin();
        update();
        break;

      case "1년":
        List<PriceChartModel> subdataForThisInterval = [];

        chartPrices = [];
        int interval = 5;

        String? latestDate = dailyPrices.first.dateTime!.substring(0, 8);
        int i = 0;
        // 1년 전 데이터부터 오늘까지
        while (stringToDateTime(dailyPrices[i].dateTime!)!.isAfter(
            stringToDateTime(latestDate)!.subtract(Duration(days: 366)))) {
          subdataForThisInterval.add(dailyPrices[i]);
          i++;
          if (i > dailyPrices.length - 1) break;
        }

        // dateTime 오름차순으로 정렬
        subdataForThisInterval
            .sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

        int j = 0;
        List<PriceChartModel> temp = [];
        chartPrices = [];

        for (int i = 0; i < subdataForThisInterval.length - 1; i++) {
          //weekday 1~5만

          if ((stringToDateTime(subdataForThisInterval[i].dateTime!)!.weekday ==
                  5) ||
              // 금요일이 휴일일 경우에
              // 이번 주의 temp 리스트의 첫 날과
              // 현재 보고 있는 subDataForThisInterval의 다음 날이
              // 5일 이상 차이 나면 거기서 temp를 끊고 주간 모델 생성
              // 만약 수,목이 휴일이면 화요일 체크시 다음 날은 금요일이고 첫날인 월과 금요일은
              // Duration 5days를 넘지 않으므로 다음 금요일로 loop 계속 진행

              ((temp.length > 0) &&
                  stringToDateTime(subdataForThisInterval[i + 1].dateTime!)!
                          .difference(stringToDateTime(temp[0].dateTime!)!) >
                      Duration(days: 5))) {
            temp.add(subdataForThisInterval[i]);
            PriceChartModel combinedModel = combineCandles(temp);
            // temp에 있는 가격들의 OHLC 합쳐서 새 모델 만들어야 함.
            chartPrices!.add(combinedModel);
            temp = [];
          } else {
            temp.add(subdataForThisInterval[i]);
            if (i + 1 == subdataForThisInterval.length - 1) {
              temp.add(subdataForThisInterval[i + 1]);
              PriceChartModel combinedModel = combineCandles(temp);
              chartPrices!.add(combinedModel);
              temp = [];
            }
          }
        }

        chartPrices!.sort((b, a) => a.dateTime!.compareTo(b.dateTime!));

        calculateMaxMin();
        update();
        break;

      case "5년":
        List<PriceChartModel> subdataForThisInterval = [];

        chartPrices = [];
        int interval = 5;

        String? latestDate = dailyPrices.first.dateTime!.substring(0, 8);
        int i = 0;
        // 1년 전 데이터부터 오늘까지
        while (stringToDateTime(dailyPrices[i].dateTime!)!.isAfter(
            stringToDateTime(latestDate)!.subtract(Duration(days: 1825)))) {
          subdataForThisInterval.add(dailyPrices[i]);
          i++;
          if (i > dailyPrices.length - 1) {
            print(i);
            break;
            // subdataForThisInterval.add(PriceChartModel(
            //   dateTime: dateTimeToString(
            //       stringToDateTime(dailyPrices[i - 1].dateTime!)!
            //           .subtract(Duration(days: 1)),
            //       8),
            //   open: dailyPrices[i - 1].open,
            //   close: dailyPrices[i - 1].close,
            //   high: dailyPrices[i - 1].high,
            //   low: dailyPrices[i - 1].low,
            // )
            // );
            // subdataForThisInterval.add(
            //   subdataForThisInterval[i - 2].copyWith(
            //     dateTime: dateTimeToString(
            //         stringToDateTime(subdataForThisInterval[i - 1].dateTime!)!
            //             .subtract(Duration(days: 1)),
            //         8),
            //     open: subdataForThisInterval[i - 2].open,
            //     close: subdataForThisInterval[i - 2].open,
            //     high: subdataForThisInterval[i - 2].open,
            //     low: subdataForThisInterval[i - 2].open,
            //     tradeAmount: 0,
            //     tradeVolume: 0,
            //   ),
            // );
          }
          // break;
        }

        // dateTime 오름차순으로 정렬
        subdataForThisInterval
            .sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

        int j = 0;
        List<PriceChartModel> temp = [];
        chartPrices = [];

        for (int i = 0; i < subdataForThisInterval.length - 1; i++) {
          //weekday 1~5만

          if (stringToDateTime(subdataForThisInterval[i].dateTime!)!.month !=
              stringToDateTime(subdataForThisInterval[i + 1].dateTime!)!
                  .month) {
            temp.add(subdataForThisInterval[i]);
            PriceChartModel combinedModel = combineCandles(temp);
            // temp에 있는 가격들의 OHLC 합쳐서 새 모델 만들어야 함.
            chartPrices!.add(combinedModel);
            temp = [];
          } else {
            temp.add(subdataForThisInterval[i]);
            if (i + 1 == subdataForThisInterval.length - 1) {
              temp.add(subdataForThisInterval[i + 1]);
              PriceChartModel combinedModel = combineCandles(temp);
              chartPrices!.add(combinedModel);
              temp = [];
            }
          }
        }
        chartPrices!.sort((b, a) => a.dateTime!.compareTo(b.dateTime!));
        calculateMaxMin();
        update();
        break;

      default:
    }
  }

  List<PriceChartModel> loopByCycle(
      List<PriceChartModel> subdataForThisInterval, int interval) {
    // loop에서 쓸 데이터들 초기화 해주고
    int j = 0;
    List<PriceChartModel> temp = [];
    List<PriceChartModel> arrangedList = [];
    for (int i = 0; i < subdataForThisInterval.length - 1; i++) {
      if (((j + 1) % interval == 0) ||
          (subdataForThisInterval[i].dateTime!.substring(0, 8) !=
              subdataForThisInterval[i + 1].dateTime!.substring(0, 8))) {
        // print('${i}th list');
        temp.add(subdataForThisInterval[i]);
        // length가 31, i = 0 ~ 29까지, i+1 = 30,
        // print(subdataForThisInterval[i].dateTime!);
        // print(subdataForThisInterval[i + 1].dateTime);
        // subList!.add(temp[0]);
        // print(temp.length);

        PriceChartModel combinedModel = combineCandles(temp);
        // temp에 있는 가격들의 OHLC 합쳐서 새 모델 만들어야 함.

        arrangedList.add(combinedModel);
        temp = [];
        j = 0;
      } else {
        temp.add(subdataForThisInterval[i]);
        if (i + 1 == subdataForThisInterval.length - 1) {
          // print(
          //     "last one added ${i + 1}, the length is ${subdataForThisInterval.length}");
          // print(subdataForThisInterval[i + 1]);
          temp.add(subdataForThisInterval[i + 1]);

          PriceChartModel combinedModel = combineCandles(temp);
          arrangedList.add(combinedModel);
          temp = [];
        }
        j++;
      }
    }

    // 시간 내림차순으로 정렬
    arrangedList.sort((b, a) => a.dateTime!.compareTo(b.dateTime!));
    return arrangedList;
  }

  // PriceChartModel의 리스트를 받아서 그것들을 하나의 PriceChartModel로 합쳐서 return
  PriceChartModel combineCandles(List<PriceChartModel> temp) {
    num tempLow = temp[0].low!;
    num tempHigh = temp[0].high!;
    num tempOpen = temp[0].open!;
    num tempClose = temp[temp.length - 1].close!;
    num tempTradeVolume = 0;
    num tempTradeAmount = 0;
    for (int k = 0; k < temp.length; k++) {
      if (temp[k].low! < tempLow) {
        tempLow = temp[k].low!;
      }
      if (temp[k].high! > tempHigh) {
        tempHigh = temp[k].high!;
      }
      tempTradeVolume += temp[k].tradeVolume!;
      tempTradeAmount += temp[k].tradeAmount!;
    }

    PriceChartModel newModel = PriceChartModel(
        dateTime: temp[temp.length - 1].dateTime,
        open: tempOpen,
        close: tempClose,
        low: tempLow,
        high: tempHigh,
        tradeVolume: tempTradeVolume,
        tradeAmount: tempTradeAmount,
        cycle: "30M");

    return newModel;
  }

  // 차트에 그려줄 subList of PriceChartModel에서 각각 가격, 거래량 max, min 값 구하기
  void calculateMaxMin() {
    DateTime start, end;
    start = DateTime.now();
    _maxPrice = quiver.max(List.generate(
            chartPrices!.length, (index) => chartPrices![index].high))! *
        1.00;
    _minPrice = quiver.min(List.generate(
            chartPrices!.length, (index) => chartPrices![index].low))! *
        1.00;
    _maxVolume = quiver.max(List.generate(
            chartPrices!.length, (index) => chartPrices![index].tradeVolume))! *
        1.00;
    // _minVolume = quiver.min(List.generate(
    //         subList!.length, (index) => subList![index].tradeVolume))! *
    //     1.00;
    // 계산 소요시간 체크
    end = DateTime.now();
    // print(end.difference(start));
  }
}
