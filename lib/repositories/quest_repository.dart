import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../locator.dart';

class QuestRepository extends Repository<List<QuestModel>> {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  @override
  Future<List<QuestModel>> getFromFirestore() async {
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
  Future<List<ChartPriceModel>> getStock(StockAddressModel stockAddress) async {
    // check if the map has it
    if (chartPriceMapping == null) {
      chartPriceMapping![stockAddress] =
          await _firestoreService.getPrices(stockAddress);
      return chartPriceMapping![stockAddress]!;
    } else {
      if (chartPriceMapping!.containsKey(stockAddress)) {
        return chartPriceMapping![stockAddress]!;
      } else {
        chartPriceMapping![stockAddress] =
            await _firestoreService.getPrices(stockAddress);
        return chartPriceMapping![stockAddress]!;
      }
    }

    // // if (chartPriceModel == null) {
    // chartPriceModel = await _firestoreService.getPrices(stockAddress);
    // return chartPriceModel!;
    // } else {
    //   return chartPriceModel!;
    // }
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
