import 'dart:convert';

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

  StockInfoNewModel copyWith({
    bool? showMain,
    bool? isTobeContinue,
    String? logoUrl,
    String? descriptionUrl,
    String? name,
    Timestamp? updateTime,
    String? assetCategory,
    String? code,
    String? country,
  }) {
    return StockInfoNewModel(
      showMain: showMain ?? this.showMain,
      isTobeContinue: isTobeContinue ?? this.isTobeContinue,
      logoUrl: logoUrl ?? this.logoUrl,
      descriptionUrl: descriptionUrl ?? this.descriptionUrl,
      name: name ?? this.name,
      updateTime: updateTime ?? this.updateTime,
      assetCategory: assetCategory ?? this.assetCategory,
      code: code ?? this.code,
      country: country ?? this.country,
    );
  }

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
      showMain: map['showMain'] ?? false,
      isTobeContinue: map['isTobeContinue'] ?? false,
      logoUrl: map['logoUrl'] ?? '',
      descriptionUrl: map['descriptionUrl'] ?? '',
      name: map['name'] ?? '',
      updateTime: map['updateTime'],
      assetCategory: map['assetCategory'] ?? '',
      code: map['code'] ?? '',
      country: map['country'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StockInfoNewModel.fromJson(String source) => StockInfoNewModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StockInfoNewModel(showMain: $showMain, isTobeContinue: $isTobeContinue, logoUrl: $logoUrl, descriptionUrl: $descriptionUrl, name: $name, updateTime: $updateTime, assetCategory: $assetCategory, code: $code, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StockInfoNewModel &&
        other.showMain == showMain &&
        other.isTobeContinue == isTobeContinue &&
        other.logoUrl == logoUrl &&
        other.descriptionUrl == descriptionUrl &&
        other.name == name &&
        other.updateTime == updateTime &&
        other.assetCategory == assetCategory &&
        other.code == code &&
        other.country == country;
  }

  @override
  int get hashCode {
    return showMain.hashCode ^
        isTobeContinue.hashCode ^
        logoUrl.hashCode ^
        descriptionUrl.hashCode ^
        name.hashCode ^
        updateTime.hashCode ^
        assetCategory.hashCode ^
        code.hashCode ^
        country.hashCode;
  }
}
