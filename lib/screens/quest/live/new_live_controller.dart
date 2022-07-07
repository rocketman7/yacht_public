import 'dart:math';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/chart_price_model.dart';
import 'package:yachtOne/models/live_quest_price_model.dart';

import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../../handlers/date_time_handler.dart';
import '../../../locator.dart';

class NewLiveController extends GetxController {
  NewLiveController({
    required this.questModel,
  });
  final QuestModel questModel;

  final FirestoreService _firestoreService = locator<FirestoreService>();

  List<InvestAddressModel> investAddresses = [];
  RxList<Rx<LiveQuestPriceModel>> livePricesOfThisQuest = <Rx<LiveQuestPriceModel>>[].obs;

  RxBool isPriceLoading = true.obs;
  int investmentModelLength = 0;
  RxInt winnerIndex = 0.obs;
  RxBool isUserAlreadyDone = false.obs;
  RxBool getStandardPriceDone = false.obs;
  RxList userQuestChoice = [].obs;
  RxList livePriceRankByIndex = [].obs;
  RxList todayCurrentPrices = [].obs;
  RxList yesterdayClosePrices = [].obs;
  RxList beforeLiveStartDateClosePrices = [].obs;

  @override
  void onInit() async {
    investmentModelLength = questModel.investAddresses!.length;
    investAddresses.addAll(questModel.investAddresses!);

    livePriceRankByIndex = List.generate(investmentModelLength, (index) => null).obs;
    todayCurrentPrices = List.generate(investmentModelLength, (index) => 0).obs;
    yesterdayClosePrices = List.generate(investmentModelLength, (index) => 0).obs;
    beforeLiveStartDateClosePrices = List.generate(investmentModelLength, (index) => 0).obs;
    await getLivePrice();
    await getStandardPrice();

    await getUserQuest();

    ever(livePricesOfThisQuest.first, (_) {
      print('ever triggered');
      Future.delayed(Duration(milliseconds: 300)).then((_) {
        // if (investmentModelLength > 1) sortLivePricesOfThisQuest();
        getWinnerIndex();

        for (int i = 0; i < investmentModelLength; i++) {
          todayCurrentPrices[i] = livePricesOfThisQuest[i].value.chartPrices.last.close;
        }
        // print('${questModel.title} winnerIndex: $winnerIndex');
      });
    });

    for (int i = 0; i < investmentModelLength; i++) {
      todayCurrentPrices[i] = livePricesOfThisQuest[i].value.chartPrices.last.close;
    }
    // livePricesOfThisQuest.listen((p0) {
    //   print('liveprice changed');
    //   getWinnerIndex();
    // });
    super.onInit();
  }

  getStandardPrice() async {
    for (int i = 0; i < investmentModelLength; i++) {
      // yesterdayClosePrices.add(i);

      yesterdayClosePrices[i] = await _firestoreService.getClosePrice(
        investAddresses[i].issueCode,
        previousBusinessDay(
          DateTime.now(),
        ),
      );

      beforeLiveStartDateClosePrices[i] = await _firestoreService.getClosePrice(
        investAddresses[i].issueCode,
        previousBusinessDay(
          questModel.liveStartDateTime.toDate(),
        ),
      );

      // print(investAddresses[i].issueCode + 'done');
    }
    // print('done');
    getStandardPriceDone(true);
  }

  sortLivePricesOfThisQuest() {
    livePricesOfThisQuest.sort((b, a) =>
        (a.value.chartPrices.last.normalizedClose ?? 100).compareTo(b.value.chartPrices.last.normalizedClose ?? 100));
    // Map<int, num> mapping = Map<int, num>();
    // for (int i = 0; i < investmentModelLength; i++) {
    //   mapping[i] = livePricesOfThisQuest[i].value.chartPrices.last.normalizedClose ?? 100;
    // }

    livePricesOfThisQuest.refresh();
    print(
        'mapping: ${livePricesOfThisQuest[0].value.chartPrices.last.normalizedClose}, ${livePricesOfThisQuest[1].value.chartPrices.last.normalizedClose}');
  }

  getUserQuest() {
// 이 퀘스트의 선택만 가져온다
    if (userQuestModelRx.length > 0) {
      if (userQuestModelRx.where((element) => element.questId == questModel.questId).length > 0) {
        isUserAlreadyDone(true);
        userQuestChoice(userQuestModelRx.where((element) => element.questId == questModel.questId).first.selection);
      }
      // thisUserQuestModel.value == null
      //     ? orderList.addAll(List.generate(questModel.investAddresses!.length, (index) => index))
      //     : orderList(thisUserQuestModel.value!.selection);
    }
  }

  LiveQuestPriceModel initial(InvestAddressModel investAddressModel) {
    return LiveQuestPriceModel(issueCode: investAddressModel.issueCode, chartPrices: [
      ChartPriceModel(
        dateTime: "20210101",
        cycle: "10M",
      )
    ]);
  }

  getWinnerIndex() {
    // print('re calculate current winner');
    // normalized 된 가격 가장 큰 숫자
    var maxValue = livePricesOfThisQuest.map((e) => e.value.chartPrices.last.normalizedClose ?? 100).reduce(max);
    winnerIndex(
        livePricesOfThisQuest.map((e) => e.value.chartPrices.last.normalizedClose ?? 100).toList().indexOf(maxValue));
    // return livePricesOfThisQuest.map((e) => e.value.chartPrices.last.normalizedClose!).toList().indexOf(maxValue);
  }

  // List<bool> getPickoneByBasePrice() {
  //   List<bool> isBeingSuccess = [];

  //   return livePricesOfThisQuest.map((e) {
  //     return e.value.chartPrices.last.close! > questModel.investAddresses![0].basePrice!;
  //   }).toList();
  // }

  bool getPickoneByBasePrice() {
    // print(livePricesOfThisQuest[0].value.issueCode);
    // print(livePricesOfThisQuest[0].value.chartPrices);
    // print(questModel.investAddresses![0].basePrice);
    // print('getpick');
    // print(livePricesOfThisQuest[0].value.chartPrices.last.close);
    // print(questModel.investAddresses![0].basePrice!);
    return (livePricesOfThisQuest[0].value.chartPrices.last.close ?? 0) > questModel.investAddresses![0].basePrice!;
  }

  getLivePrice() {
    for (int i = 0; i < investmentModelLength; i++) {
      livePricesOfThisQuest.add(Rx<LiveQuestPriceModel>(initial(questModel.investAddresses![i])));
      livePricesOfThisQuest[i].bindStream(
        _firestoreService.getStreamLiveQuestPrice(
          questModel.investAddresses![i],
          questModel,
        ),
      );
      livePricesOfThisQuest[i].refresh();
    }
    // sortLivePrices();

    // print('livePricesOfThisQuest: ${livePricesOfThisQuest[0].value.chartPrices}');
  }
}
