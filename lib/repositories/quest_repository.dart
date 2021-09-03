import 'package:yachtOne/models/chart_price_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../locator.dart';

class QuestRepository extends Repository<List<QuestModel>> {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Future<List<QuestModel>> getQuestForHomeView() async {
    if (todayQuests == null) {
      todayQuests = await _firestoreService.getAllQuests();
      return todayQuests!;
    } else {
      return todayQuests!;
    }
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class PriceRepository implements Repository<List<ChartPriceModel>> {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Future<List<ChartPriceModel>> getStock(InvestAddressModel investAddresses) async {
    // check if the map has it
    if (chartPriceMapping == null) {
      chartPriceMapping![investAddresses] = await _firestoreService.getPrices(investAddresses);
      return chartPriceMapping![investAddresses]!;
    } else {
      if (chartPriceMapping!.containsKey(investAddresses)) {
        return chartPriceMapping![investAddresses]!;
      } else {
        chartPriceMapping![investAddresses] = await _firestoreService.getPrices(investAddresses);
        return chartPriceMapping![investAddresses]!;
      }
    }

    // // if (chartPriceModel == null) {
    // chartPriceModel = await _firestoreService.getPrices(investAddresses);
    // return chartPriceModel!;
    // } else {
    //   return chartPriceModel!;
    // }
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
