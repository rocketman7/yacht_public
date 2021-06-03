import 'dart:ffi';

import 'package:get/get.dart';
import 'dart:math';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:quiver/iterables.dart' as quiver;

class ChartViewModel extends GetxController {
  FirestoreService _firestoreService = FirestoreService();
  // Rx<List<PriceChartModel>> priceList = Rx<List<PriceChartModel>>();
  // List<PriceChartModel> get prices => priceList.value;

  List<PriceChartModel>? priceList;
  List<PriceChartModel>? subList;
  List<String> termList = ["1D", "1M", "3M", "1Y", "5Y"];

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
    subList = priceList!.sublist(
      0,
      60,
    );
    // print(subList);
    getMaxMin();
    update();
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
    print(end.difference(start));
  }
}
