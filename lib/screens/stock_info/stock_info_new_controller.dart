import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/stock_info_new_model.dart';

class StockInfoNewController extends GetxController {
  final StockInfoNewModel stockInfoNewModel;

  // 생성자
  StockInfoNewController({required this.stockInfoNewModel});

  // get 변수들

  // 서비스 (임시)

  // UI 관련 변수
  // WebViewController? webViewController;
  // double webViewLoadingHeight = 200.w;
  PageController pageController = PageController(initialPage: 0);
  RxInt index = 0.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void selectTab(int i) {
    index(i);
    pageController.jumpToPage(i);
  }
}
