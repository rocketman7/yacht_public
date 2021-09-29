import 'package:get/get.dart';
import 'package:yachtOne/models/chart_price_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/models/tier_system_model.dart';

abstract class Repository<T> {
  Future<T> getQuestForHomeView();
  // Future<T> getUserData(String uid);
  Future<T> getStock(InvestAddressModel argument);
  // Future<List<ChartPriceModel>> getChartPrices();

  // Future<T> getTierSystem();
}

List<QuestModel>? todayQuests;
Map<InvestAddressModel, List<ChartPriceModel>>? chartPriceMapping = <InvestAddressModel, List<ChartPriceModel>>{};
UserModel? userModel;
// Usermodel Rx형태로 만들어서 어디서든 구독
final Rxn<UserModel> userModelRx = Rxn<UserModel>();
final RxList<UserQuestModel> userQuestModelRx = RxList<UserQuestModel>();

final RxString leagueRx = "".obs;

final Rxn<TierSystemModel> tierSystemModelRx = Rxn<TierSystemModel>();
final RxList<String> holidayListKR = <String>[].obs;
