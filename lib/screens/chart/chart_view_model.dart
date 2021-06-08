import 'dart:ffi';

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

  List<PriceChartModel>? priceList;
  List<PriceChartModel> dailyPriceList = [];
  List<PriceChartModel> intradayPriceList = [];
  List<PriceChartModel>? subList;
  List<String> cycleList = ["1D", "1W", "1M", "3M", "1Y", "5Y"];

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
  RxString? dateTime;

  // 이 뷰모델을 불러오면 onInit 실행.
  @override
  onInit() {
    super.onInit();
    return fetchPrices();
  }

  // Trackball 움직이고 있을 때
  void onTrackballChanging(TrackballArgs trackballArgs) {
    isTracking(true);
    if (trackballArgs.chartPointInfo.seriesIndex == 0) {
      open(trackballArgs.chartPointInfo.chartDataPoint!.open as int);
      close(trackballArgs.chartPointInfo.chartDataPoint!.close as int);
      high(trackballArgs.chartPointInfo.chartDataPoint!.high as int);
      low(trackballArgs.chartPointInfo.chartDataPoint!.low as int);
    } else {
      volume(trackballArgs.chartPointInfo.chartDataPoint!.yValue);
    }
    // print(trackballArgs.chartPointInfo.series);
    // volume(trackballArgs.chartPointInfo.series.!.y as int);
  }

  // 차트에서 손 떼고 Trackball 없어질 때
  void onTracballEnds() {
    isTracking(false);
  }

  // subList를 기간 별로 만들어주는 로직 필요

// update()는 notifyListeners() 처럼 쓰면 되고 그 전에 Future에서 받아온 데이터 넣으면 됨.
  void fetchPrices() async {
    // print("get Called");
    priceList = await _firestoreService.getPrices();
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
    priceList!.forEach((e) {
      if (e.cycle == "D") {
        dailyPriceList.add(e);
      } else if (e.cycle == "10M") {
        // print("10M detected");
        intradayPriceList.add(e);
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
    print(subList!.sublist(0, 39)[38]);
    // combineCandles(subList!);
    getMaxMin();
    update();
  }

  // 차트 아래 주기 버튼 누르면 차트에 그릴 list 새로 만들기
  // 1) 먼저 받아온 차트 데이터에서 기간 별로 나눠주는 로직 구현하고,
  // 2) 데이터가 충분하지 않을 때 어떻게 처리할지 구현해야 함. (빅히트로)
  void changeCycle() {
    switch (cycleList[selectedCycle]) {
      case "1D":
        // 임시 price chart model list를 만들고
        List<PriceChartModel> temp = [];
        // intraday price list를 처음(현재로부터 가장 최신)부터 loop
        // int i = 0;
        // intradayPriceList.forEach((element) {
        //   // intradayPriceList.first, 즉 가장 최신의 intraday 데이터에서
        //   // dateTime을 string으로 변환.
        //   String? latestDate =
        //       intradayPriceList.first.dateTime!.substring(0, 8);
        //   //
        //   if (element.dateTime!.substring(0, 8) == latestDate) {
        //     temp.add(element);
        //   }
        //   i++;
        // });
        // print(i);
        for (int i = 0; i < intradayPriceList.length; i++) {
          // intradayPriceList.first, 즉 가장 최신의 intraday 데이터에서
          // dateTime을 string으로 변환.
          String? latestDate =
              intradayPriceList.first.dateTime!.substring(0, 8);
          //
          if (intradayPriceList[i].dateTime!.substring(0, 8) == latestDate) {
            temp.add(intradayPriceList[i]);
          } else {
            break;
          }
        }

        subList = temp;
        getMaxMin();
        update();
        break;

      case "1W": // 30min 캔들 만들어야 하므로 0900부터 3개씩 합쳐야 함.
        List<PriceChartModel> subdataForThisInterval;
        subList = [];

        Set<String> days = Set<String>();
        int i = 0;

        // for (int i = 0; i < intradayPriceList.length; i++) {

        //   days.add(intradayPriceList[i].dateTime!.substring(0, 8));

        // }
        // 5 영업일 고르고
        do {
          days.add(intradayPriceList[i].dateTime!.substring(0, 8));
          i++;
        } while (days.length <= 5);

        // 차트에 쓸 데이터들만
        subdataForThisInterval = intradayPriceList.sublist(0, i - 1);
        print(days);
        print(subdataForThisInterval.last);

        // dateTime 오름차순으로 정렬
        subdataForThisInterval
            .sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
        int j = 0;
        List<PriceChartModel> temp = [];
        subList = [];
        for (int i = 0; i < subdataForThisInterval.length - 1; i++) {
          if (((j + 1) % 12 == 0) ||
              (subdataForThisInterval[i].dateTime!.substring(0, 8) !=
                  subdataForThisInterval[i + 1].dateTime!.substring(0, 8))) {
            // print((i + 1) % 6);
            // print('${i}th list');
            temp.add(subdataForThisInterval[i]);
            // print(subdataForThisInterval[i].dateTime!);
            // print(subdataForThisInterval[i + 1].dateTime);
            subList!.add(temp[0]);
            print(temp.length);
            temp = [];
            j = 0;
          } else {
            temp.add(subdataForThisInterval[i]);
            print('${i}th list done');
            j++;
          }
        }
        // int j = 0;
        // int interval = 3;
        // var quotient;
        // var remainder;

        // for (j = 0; j < quotient; j++) {
        //   List<PriceChartModel> loopTemp;
        //   loopTemp = temp1.sublist(0 + j * interval, j * interval);

        // }

        // int countEachCandle = 0;
        // String? latestDate = intradayPriceList.first.dateTime!.substring(0, 8);
        // intradayPriceList.forEach((element) {
        //   if (element.dateTime!.substring(0, 8) == latestDate) {
        //     temp.add(element);
        //   }
        // });
        // // temp에서 interval로 나눔, mod 고려해서
        // // 각 나눈 것에서 ohlc 뽑아서 subList에 add
        // // 이전일로 이동

        // int i = 0;
        // while (stringToDateTime(intradayPriceList[i].dateTime!)!.isAfter(
        //     stringToDateTime(latestDate)!.subtract(Duration(days: 1)))) {
        //   temp.add(intradayPriceList[i]);
        //   i++;
        // }

        // // subList = temp;
        getMaxMin();
        update();
        break;

      case "3M":
        List<PriceChartModel> temp = [];

        String? latestDate = dailyPriceList.first.dateTime!.substring(0, 8);
        // print(latestDate);

        int i = 0;
        // loop 조건이 끝나면 바로 나갈 수 있게 if 대신 while로
        // 현재로부터 90일 이전 날짜까지 포함시키기
        while (stringToDateTime(dailyPriceList[i].dateTime!)!.isAfter(
            stringToDateTime(latestDate)!.subtract(Duration(days: 91)))) {
          temp.add(dailyPriceList[i]);
          i++;
        }
        subList = temp;
        getMaxMin();
        update();
        break;

      case "5Y":
        combineCandles(
          intradayPriceList,
        );
        break;

      default:
    }
  }

// 여러 캔들 합치기
  void combineCandles(
    List<PriceChartModel> chartModels,
  ) {
    // 1D: 10 mins
    // 1W: 30 mins
    // 1M: 120 mins or 60 mins
    // 3M: 1 day
    // 1Y: 1 week
    // 5Y: 1 month

    // chartModels를 정렬해야 함
    // print(chartModels);
    // 입력받은 chartModel List를 dateTime 오름차순으로 정리

    // cycle: 10M => chartModels[0].dateTime -> yyyyMMddHHmmSS  14자리
    // cycle:  1D => chartModels[0].dateTime -> yyyyMMdd         8자리

    // 총 5 영업일을 추출하고 싶다면,

    Set<String> days = Set<String>();
    int i = 0;

    do {
      days.add(chartModels[i].dateTime!.substring(0, 8));
      i++;
    } while (days.length <= 5);

    List<String> coveredDays = days.toList();
    coveredDays.sort();
    coveredDays.removeAt(0);
    print(i);
    print(chartModels[i]);
    print(coveredDays);

    List<PriceChartModel> finalList = chartModels.sublist(0, i - 1);
    print(finalList.last);

    int interval = 3;
    int j = 0;

    finalList.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

    List combineSublist = finalList.sublist(0, 3);

    num open = 0;
    num close = 0;
    num low = 0;
    num high = 0;

    // for (int i = 0; i < interval; i++) {
    //   if (i == 0) {
    //     low = combineSublist[i].low;
    //     high = combineSublist[i].high;
    //     open = combineSublist[i].open;
    //   } else if (i == interval - 1) {
    //     close = combineSublist[i].close;
    //   }
    //   if (combineSublist[i].low < low) {
    //     low = combineSublist[i].low;
    //   }
    //   if (combineSublist[i].high > high) {
    //     high = combineSublist[i].high;
    //   }
    // }
    int loop = (finalList.length / interval).floor();
    int mod = finalList.length % interval;

    for (int i = 0; i < loop; i++) {
      for (int j = 0; j < interval; j++) {
        print(i * j);
      }
    }

    print(combineSublist);
    print(open);
    print(low);
    print(high);

    // PriceChartModel(dateTime: ,
    // open: ,
    // high: ,
    // low: ,
    // close: ,
    // tradeAmount: ,
    // tradeVolume: ,
    // )
    // if (decending == false) {
    //   chartModels.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
    // }

    // 1W이면 먼저 총 5일을 써야 함.

    // print(chartModels);

    // 시작일과 마지막일을 먼저 구해서 하루씩 캔들을 합쳐야 함.

    int length = chartModels.length;
    // int numberOfCombined = (length / combineCount).floor();
    // int mod = length % combineCount;

    // var high = chartModels[0].high;
    // var low = chartModels[0].low;
    // var close = chartModels[0].close;
    // var open = chartModels[0].open;
  }

  // 차트에 그려줄 subList of PriceChartModel에서 각각 가격, 거래량 max, min 값 구하기
  void getMaxMin() {
    DateTime start, end;
    start = DateTime.now();
    _maxPrice = quiver.max(
            List.generate(subList!.length, (index) => subList![index].high))! *
        1.00;
    _minPrice = quiver.min(
            List.generate(subList!.length, (index) => subList![index].low))! *
        1.00;
    _maxVolume = quiver.max(List.generate(
            subList!.length, (index) => subList![index].tradeVolume))! *
        1.00;

    // _minVolume = quiver.min(List.generate(
    //         subList!.length, (index) => subList![index].tradeVolume))! *
    //     0.95;
    // 계산 소요시간 체크

    end = DateTime.now();
    print(stringToDateTime('20210604153000'));
    print(end.difference(start));
    // update();
  }
}
