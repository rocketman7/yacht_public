import 'package:get/get.dart';
import 'package:yachtOne/models/dictionary_model.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../../locator.dart';

class DictionaryViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final dictionaries = <DictionaryModel>[].obs;
  @override
  void onInit() async {
    await getDictionaries();
    // TODO: implement onInit
    super.onInit();
  }

  Future getDictionaries() async {
    dictionaries(await _firestoreService.getDictionaries());
    update();
  }
}
