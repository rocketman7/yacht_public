import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/services/firestore_service.dart';

class ChartViewModel extends GetxController {
  // Rx<List<PriceChartModel>> priceList = Rx<List<PriceChartModel>>();
  // List<PriceChartModel> get prices => priceList.value;

  List<PriceChartModel>? priceList;
  List<String> termList = ["1D", "1M", "3M", "1Y", "5Y"];
  // 이 뷰모델을 불러오면 onInit 실행.
  @override
  onInit() {
    super.onInit();
    return fetchPrices();
  }

  void fetchPrices() async {
    print("get Called");
    priceList = await FirestoreService().getPrices();
    update();
  }
}
