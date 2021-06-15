import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockInfoKRViewModel extends GetxController {
  // static final scrollController = ScrollController(initialScrollOffset: 0);
  RxDouble offset = 0.0.obs;

  @override
  void onInit() {
    // StreamController<double> _streamController;

    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    // scrollController.close();
    super.onClose();
  }
}
