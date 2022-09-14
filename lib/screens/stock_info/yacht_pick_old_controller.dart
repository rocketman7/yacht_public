import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/stock_info_new_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_new_controller.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../locator.dart';

class YachtPickOldController extends GetxController {
  List<StockInfoNewModel>? stockInfoNewModels;

  FirestoreService _firestoreService = locator<FirestoreService>();

  bool isModelLoaded = false;
  RxBool isPriceLoaded = false.obs;

  RxList<RxNum> currentClosePrices = <RxNum>[].obs; // 가장 가까운 영업일의 cycle D 히스토리컬 프라이스 종가
  List<num> previousClosePrices = <num>[]; // 그 전 영업일의 cycle D 히스토리컬 프라이스 종가
  // List<num> yachtPickClosePrices = <num>[]; // 요트픽한 가장 가까운 전 영업일 cycle D 히스토리컬 프라이스 종가
  List<num> yachtPickOpenPrices = <num>[]; // 요트픽한 가장 가까운 영업일 cycle D 히스토리컬 프라이스 시가

  final chicagoTime = tz.getLocation('America/Chicago');

  RxInt pickWeather = 0.obs;
  final RxDouble sunnyPicksReturn = 0.0.obs;
  RxDouble randomNumber = 0.0.obs;
  // final RxString testString = "aaaa".obs;
  late Timer randomizer;

  @override
  void onInit() async {
    rng();
    stockInfoNewModels = await _firestoreService.getAllYachtPicks();
    isModelLoaded = true;
    update();
    currentClosePrices = RxList.generate(stockInfoNewModels!.length, (index) => RxNum(0));
    previousClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0.0);
    // yachtPickClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0);
    yachtPickOpenPrices = List.generate(stockInfoNewModels!.length, (index) => 0.0);
    await getLivePriceStream();
    await getPrices();

    calculateReturn();
    isPriceLoaded(true);
    update();
    randomizer.cancel();
    super.onInit();
  }

  @override
  void onClose() {
    if (randomizer.isActive) randomizer.cancel();

    super.onClose();
  }

  getLivePriceStream() {
    print(getLivePriceStream);
    for (int i = 0; i < currentClosePrices.length; i++) {
      currentClosePrices[i].bindStream(
          _firestoreService.getStreamLivePrice(stockInfoNewModels![i].country, stockInfoNewModels![i].code));
      // print(currentClosePrices[i]);
      ever(currentClosePrices[i], (_) {
        // print('trigger');
        calculateReturn();
        // testString("dddd");
        // print('ever:  ${sunnyPicksReturn.value}');
      });
      currentClosePrices[i].refresh();
    }
    //
  }

  rng() {
    // 로딩 때 수익률 숫자 왔다갔다
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

        if (currentClosePrices[i].value != 0 && yachtPickOpenPrices[i] != 0) {
          // print('i: ${stockInfoNewModels![i].code} ${currentClosePrices[i].value}, ${yachtPickOpenPrices[i]}');
          returnSum += currentClosePrices[i].value / yachtPickOpenPrices[i] - 1;
          numOfSunny += 1;
        }
      }
    }
    // print('returnSum: $returnSum');
    // print(numOfSunny);
    // print(returnSum / numOfSunny);
    sunnyPicksReturn(returnSum / numOfSunny);

    // print('sunnyPicksReturn:  ${sunnyPicksReturn.value}');
  }

  getPrices() async {
    // for (int i = 0; i < stockInfoNewModels!.length; i++) {
    //   currentClosePrices[i] = await _firestoreService.getClosePrice(
    //     stockInfoNewModels![i].code,
    //     previousBusinessDay(
    //       DateTime.now(),
    //     ),
    //   );
    // }

    for (int i = 0; i < stockInfoNewModels!.length; i++) {
      previousClosePrices[i] = await _firestoreService.getClosePrice(
        stockInfoNewModels![i].country,
        stockInfoNewModels![i].code,
        previousBusinessDay(
          stockInfoNewModels![i].country == "KR" ? DateTime.now() : tz.TZDateTime.now(chicagoTime),
        ),
      );
    }

    for (int i = 0; i < stockInfoNewModels!.length; i++) {
      yachtPickOpenPrices[i] = await _firestoreService.getOpenPrice(
        stockInfoNewModels![i].country,
        stockInfoNewModels![i].code,
        closestBusinessDay(
          stockInfoNewModels![i].releaseTime.toDate(),
        ),
      );
    }
  }
}
