import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_model.dart';

abstract class Repository<T> {
  Future<T> getFromFirestore();
  Future<T> getUserData(String uid);
  Future<T> getStock(StockAddressModel argument);
  // Future<List<ChartPriceModel>> getChartPrices();
}

List<QuestModel>? todayQuests;
Map<StockAddressModel, List<ChartPriceModel>>? chartPriceMapping =
    <StockAddressModel, List<ChartPriceModel>>{};
UserModel? userModel;
