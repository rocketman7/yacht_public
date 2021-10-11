import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/firestore_service.dart';
import '../../locator.dart';

const List<String> category = [
  '앱의 업그레이드를 위한 제안',
  '버그 및 오작동 신고',
  '기타 궁금한 점',
  '특정 유저 신고',
];

class OneOnOneViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  RxBool isCategorySelect = false.obs;
  RxInt selectedCategoryIndex = 0.obs;
  RxString content = ''.obs;
  final TextEditingController contentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    contentController.dispose();

    super.onClose();
  }

  void categorySelectMethod() {
    isCategorySelect(!isCategorySelect.value);
  }

  void categoryIndexSelectMethod(int index) {
    selectedCategoryIndex(index);
  }

  Future oneOnOneUpdate(String categoryString, String content) async {
    await _firestoreService.updateOneOnOne(categoryString, content);
  }
}
