import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';

import 'package:yachtOne/models/corporation_model.dart';
import 'package:yachtOne/screens/quest/quest_view_model.dart';

Rx<InvestAddressModel>? newStockAddress;

class StockInfoKRViewModel extends GetxController {
  final InvestAddressModel investAddressModel;
  StockInfoKRViewModel({
    required this.investAddressModel,
  });

  // StockInfoView에서 offset에 scrollController Offset값 넣어줌

  RxDouble offset = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    newStockAddress = investAddressModel.obs;

    // 1) get general info of the stock
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    newStockAddress = null;
    super.onClose();
  }

  void changeInvestAddressModel(InvestAddressModel investAddresses) {
    newStockAddress!(investAddresses);
    // update();
  }
}
