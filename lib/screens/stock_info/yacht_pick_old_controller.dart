import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/stock_info_new_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_new_controller.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../locator.dart';

class YachtPickOldController extends GetxController {
  List<StockInfoNewModel>? stockInfoNewModels;

  FirestoreService _firestoreService = locator<FirestoreService>();

  bool isModelLoaded = false;
  bool isPriceLoaded = false;

  List<num> currentClosePrices = <num>[]; // 가장 가까운 영업일의 cycle D 히스토리컬 프라이스 종가
  List<num> previousClosePrices = <num>[]; // 그 전 영업일의 cycle D 히스토리컬 프라이스 종가
  List<num> yachtPickClosePrices = <num>[]; // 요트픽한 가장 가까운 전 영업일 cycle D 히스토리컬 프라이스 종가

  @override
  void onInit() async {
    stockInfoNewModels = await _firestoreService.getOldYachtPicks();
    isModelLoaded = true;
    update();

    currentClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0);
    previousClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0);
    yachtPickClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0);
    await getPrices();
    isPriceLoaded = true;
    update();

    super.onInit();
  }

  getPrices() async {
    for (int i = 0; i < stockInfoNewModels!.length; i++) {
      currentClosePrices[i] = await _firestoreService.getClosePrice(
        stockInfoNewModels![i].code,
        previousBusinessDay(
          DateTime.now(),
        ),
      );
    }

    for (int i = 0; i < stockInfoNewModels!.length; i++) {
      previousClosePrices[i] = await _firestoreService.getClosePrice(
        stockInfoNewModels![i].code,
        previousBusinessDay(previousBusinessDay(
          DateTime.now(),
        )),
      );
    }

    for (int i = 0; i < stockInfoNewModels!.length; i++) {
      yachtPickClosePrices[i] = await _firestoreService.getClosePrice(
        stockInfoNewModels![i].code,
        previousBusinessDay(
          stockInfoNewModels![i].updateTime.toDate(),
        ),
      );
    }
  }
}
