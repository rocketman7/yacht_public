import 'dart:async';
import 'dart:math';

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

  RxInt pickWeather = 0.obs;
  RxDouble sunnyPicksReturn = 0.0.obs;
  RxDouble randomNumber = 0.0.obs;
  late Timer randomizer;
  @override
  void onInit() async {
    rng();
    stockInfoNewModels = await _firestoreService.getOldYachtPicks();
    isModelLoaded = true;
    update();

    currentClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0);
    previousClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0);
    yachtPickClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0);
    await getPrices();
    calculateReturn();
    isPriceLoaded = true;
    update();
    randomizer.cancel();
    super.onInit();
  }

  @override
  void onClose() {
    if (randomizer.isActive) randomizer.cancel();
    super.onClose();
  }

  rng() {
    randomizer = Timer.periodic(Duration(milliseconds: 500), (t) {
      randomNumber(Random().nextDouble());
    });
  }

  calculateReturn() {
    double returnSum = 0.0;
    int numOfSunny = 0;
    for (int i = 0; i < stockInfoNewModels!.length; i++) {
      if (stockInfoNewModels![i].yachtView.last.view == 'sunny') {
        // print(currentClosePrices[i] / yachtPickClosePrices[i] - 1);
        returnSum += currentClosePrices[i] / yachtPickClosePrices[i] - 1;
        numOfSunny += 1;
      }
    }
    // print(returnSum);
    // print(numOfSunny);
    sunnyPicksReturn(returnSum / numOfSunny);
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
