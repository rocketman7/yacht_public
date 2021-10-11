import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/one_on_one_list_model.dart';

import '../../services/firestore_service.dart';
import '../../locator.dart';

class OneOnOneListViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  bool isLoaded = false;
  late List<OneOnOneListModel> oneOnOneListList;

  @override
  void onInit() async {
    oneOnOneListList = await _firestoreService.getOneOnOneListList();

    isLoaded = true;

    update();

    super.onInit();
  }
}
