import 'package:get/get.dart';
import 'package:yachtOne/models/corporation_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../../locator.dart';

class DescriptionViewModel extends GetxController {
  final StockAddressModel stockAddressModel;

  DescriptionViewModel(this.stockAddressModel);

  @override
  void onInit() {
    super.onInit();
    // TODO: implement onInit
    // newStockAddress = stockAddressModel.obs;
    newStockAddress!.listen((value) {
      print("Description view value change from stockinfoview $value");
      getCorporationInfo(value);
    });
    getCorporationInfo(stockAddressModel);
  }

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final String title = "기업 소개";

  Rx<CorporationModel> corporationModel = Rx<CorporationModel>(
      CorporationModel(ceo: "", avrSalary: 0, description: "", employees: 0));

  Future getCorporationInfo(StockAddressModel stockAddressModel) async {
    corporationModel(
        await _firestoreService.getCorporationInfo(stockAddressModel));
    print(corporationModel.value);
  }
}
