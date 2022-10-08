import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/stock_info_new_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:timezone/timezone.dart' as tz;

class YahctPickViewModel extends GetxController {
  List<StockInfoNewModel> stockInfoNewModels = [];

  FirestoreService _firestoreService = locator<FirestoreService>();

  bool isModelLoaded = false;
  RxBool isPricesLoaded = false.obs;
  RxList<RxNum> todayCurrentPrices = <RxNum>[].obs;
  RxList<num> yesterdayClosePrices = <num>[].obs;
  final chicagoTime = tz.getLocation('America/Chicago');
  @override
  void onInit() async {
    // stockInfoNewModels = await _firestoreService.getAllYachtPicks();
    stockInfoNewModels = await _firestoreService.getYachtPicks();
    todayCurrentPrices = List.generate(stockInfoNewModels.length, (index) => RxNum(0)).obs;
    yesterdayClosePrices = List.generate(stockInfoNewModels.length, (index) => 0.0).obs;

    isModelLoaded = true;

    print('stockInfoNewModels: ${stockInfoNewModels[0].toString()}');
    await getLivePrice();
    // print(stockInfoNewModels[0].name);
    // print(stockInfoNewModels[0].yachtView);
    isPricesLoaded(true);
    update();

    super.onInit();
  }

  getLivePrice() async {
    print('length: ${stockInfoNewModels.length}');
    for (int i = 0; i < stockInfoNewModels.length; i++) {
      yesterdayClosePrices[i] = await _firestoreService.getClosePrice(
        stockInfoNewModels[i].country,
        stockInfoNewModels[i].code,
        previousBusinessDay(
          (stockInfoNewModels[i].country == "KR" || stockInfoNewModels[i].country == "JP")
              ? DateTime.now()
              : tz.TZDateTime.now(chicagoTime),
        ),
      );

      todayCurrentPrices[i].bindStream(
        _firestoreService.streamOneStockPrice(
          stockInfoNewModels[i].country,
          stockInfoNewModels[i].code,
        ),
      );
    }
    todayCurrentPrices.refresh();

    print('yesterdayClosePrices: $yesterdayClosePrices');
    print('todayCurrentPrices: $todayCurrentPrices');
  }

  Future<String> getTobeContinueDescription() async {
    return await _firestoreService.getTobeContinueDescription();
  }
}
