import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class StockInfoNewModel {
  final bool showMain;
  final bool isTobeContinue;
  final String logoUrl;
  final String descriptionUrl;
  final String name;
  final Timestamp updateTime;
  final String assetCategory;
  final String code;
  final String country;

  StockInfoNewModel({
    required this.showMain,
    required this.isTobeContinue,
    required this.logoUrl,
    required this.descriptionUrl,
    required this.name,
    required this.updateTime,
    required this.assetCategory,
    required this.code,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'showMain': showMain,
      'isTobeContinue': isTobeContinue,
      'logoUrl': logoUrl,
      'descriptionUrl': descriptionUrl,
      'name': name,
      'updateTime': updateTime,
      'assetCategory': assetCategory,
      'code': code,
      'country': country,
    };
  }

  factory StockInfoNewModel.fromMap(Map<String, dynamic> map) {
    return StockInfoNewModel(
      showMain: map['showMain'],
      isTobeContinue: map['isTobeContinue'],
      logoUrl: map['logoUrl'],
      descriptionUrl: map['descriptionUrl'],
      name: map['name'],
      updateTime: map['updateTime'],
      assetCategory: map['assetCategory'],
      code: map['code'],
      country: map['country'],
    );
  }
}
