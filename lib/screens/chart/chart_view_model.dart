import 'package:get/get.dart';
import 'dart:math';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:quiver/iterables.dart' as quiver;

class ChartViewModel extends GetxController {
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

  // 이 뷰모델을 불러오면 onInit 실행.
  @override
  onInit() {
    super.onInit();
    return fetchPrices();
  }

// update()는 notifyListeners() 처럼 쓰면 되고 그 전에 Future에서 받아온 데이터 넣으면 됨.
  void fetchPrices() async {
    print("get Called");
    priceList = await FirestoreService().getPrices();
    subList = priceList!.sublist(1, 60);
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
        1.05;
    _minPrice = quiver.min(
            List.generate(subList!.length, (index) => subList![index].low))! *
        0.95;
    _maxVolume = quiver.max(List.generate(
            subList!.length, (index) => subList![index].tradeVolume))! *
        1.05;
    // _minVolume = quiver.min(List.generate(
    //         subList!.length, (index) => subList![index].tradeVolume))! *
    //     0.95;
    end = DateTime.now();

    print(end.difference(start));
  }
}
