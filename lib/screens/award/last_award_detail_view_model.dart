import 'package:get/get.dart';

import '../../models/last_subLeague_model.dart';

import '../../services/firestore_service.dart';

class LastAwardDetailViewModel extends GetxController {
  LastAwardDetailViewModel({required this.lastSubLeague});

  FirestoreService _firestoreService = FirestoreService();

  LastSubLeagueModel lastSubLeague;

  bool isLastSubLeaguesAllLoaded = false;

  @override
  void onInit() async {
    super.onInit();
  }
}
