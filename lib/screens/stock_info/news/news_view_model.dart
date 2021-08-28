import 'package:get/get.dart';
import 'package:yachtOne/models/news_model.dart';

import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../../locator.dart';
import '../stock_info_kr_view_model.dart';

class NewsViewModel extends GetxController {
  final InvestAddressModel investAddressModel;

  NewsViewModel(this.investAddressModel);
  RxBool isLoading = true.obs;
  final RxString corporationName = RxString("");
  @override
  void onInit() {
    // TODO: implement onInit
    corporationName(investAddressModel.name);
    newStockAddress!.listen((value) {
      getNews(value);
    });
    getNews(investAddressModel);

    super.onInit();
  }

  final FirestoreService _firestoreService = locator<FirestoreService>();
  final String title = "뉴스";

  RxList<NewsModel> newsList = <NewsModel>[].obs;

  Future getNews(InvestAddressModel investAddressModel) async {
    isLoading(true);
    corporationName(investAddressModel.name);
    newsList(await _firestoreService.getNews(investAddressModel));
    isLoading(false);
  }
}
