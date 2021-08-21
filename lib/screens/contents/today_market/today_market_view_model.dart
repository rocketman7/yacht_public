import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/today_market_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../locator.dart';

class TodayMarketViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  late final RxInt newsIndex;

  RxList<TodayMarketModel> todayMarkets = <TodayMarketModel>[].obs;

  @override
  void onInit() async {
    newsIndex = 0.obs;
    await getTodayMarket();
    // TODO: implement onInit
    super.onInit();
  }

  Future getTodayMarket() async {
    todayMarkets(await _firestoreService.getTodayMarkets());
    print(todayMarkets);
  }

  Future launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
