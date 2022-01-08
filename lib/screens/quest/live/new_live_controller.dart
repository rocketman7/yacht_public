import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/live_quest_price_model.dart';

import 'package:yachtOne/models/quest_model.dart';

class NewLiveController extends GetxController {
  NewLiveController({
    required this.questModel,
  });
  final QuestModel questModel;

  List<InvestAddressModel> investAddresses = [];
  List<Rx<LiveQuestPriceModel>> livePricesOfThisQuest = <Rx<LiveQuestPriceModel>>[];

  RxBool isLiveLoading = true.obs;
  int investmentModelLength = 0;
  @override
  void onInit() async {
    investmentModelLength = questModel.investAddresses!.length;
    investAddresses.addAll(questModel.investAddresses!);
    // TODO: implement onInit
    getLivePrice();
    print('investAddresses: $investAddresses');
    super.onInit();
  }

  getLivePrice() {}
}
