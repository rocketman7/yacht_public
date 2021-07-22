import 'package:get/get.dart';
import 'package:yachtOne/models/news_model.dart';

import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../../locator.dart';
import '../stock_info_kr_view_model.dart';

class NewsViewModel extends GetxController {
  final StockAddressModel stockAddressModel;

  NewsViewModel(this.stockAddressModel);
  RxBool isLoading = true.obs;
  final RxString corporationName = RxString("");
  @override
  void onInit() {
    // TODO: implement onInit
    corporationName(stockAddressModel.name);
    newStockAddress!.listen((value) {
      print("Description view value change from stockinfoview $value");
      getNews(value);
    });
    getNews(stockAddressModel);

    super.onInit();
  }

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final String title = "뉴스";

  RxList<NewsModel> newsList = <NewsModel>[].obs;

  Future getNews(StockAddressModel stockAddressModel) async {
    isLoading(true);
    corporationName(stockAddressModel.name);
    newsList(await _firestoreService.getNews(stockAddressModel));
    print('corporation name: $corporationName');
    isLoading(false);
  }
}
