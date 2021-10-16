import 'package:get/get.dart';
import 'package:yachtOne/models/corporation_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../../locator.dart';

class DescriptionViewModel extends GetxController {
  final InvestAddressModel investAddressModel;

  DescriptionViewModel(this.investAddressModel);
  RxBool showMore = false.obs;
  @override
  void onInit() {
    super.onInit();
    // TODO: implement onInit
    // newStockAddress = investAddressModel.obs;
    newStockAddress!.listen((value) {
      getCorporationInfo(value);
    });
    getCorporationInfo(investAddressModel);
  }

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final String title = "기업 소개";

  Rx<CorporationModel> corporationModel =
      Rx<CorporationModel>(CorporationModel(ceo: "", avrSalary: 0, description: "", employees: 0));

  Future getCorporationInfo(InvestAddressModel investAddressModel) async {
    corporationModel(await _firestoreService.getCorporationInfo(investAddressModel));
  }
}
