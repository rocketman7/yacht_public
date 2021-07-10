import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/models/quest_model.dart';

List<QuestModel>? todayQuests;
Map<StockAddressModel, List<ChartPriceModel>>? chartPriceMapping =
    <StockAddressModel, List<ChartPriceModel>>{};

abstract class Repository<T> {
  Future<T> getFromFirestore();
  Future<T> getStock(StockAddressModel argument);
  // Future<List<ChartPriceModel>> getChartPrices();
}
