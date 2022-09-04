import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/services/firestore_service.dart';

class TradingViewChartViewModel extends GetxController {
  final FirestoreService firestoreService = locator<FirestoreService>();
  // @override
  // void onInit() async {
  //   // TODO: implement onInit
  //   super.onInit();
  // }

  Future<String> getTradingViewUrl() async {
    return await firestoreService.getTradingViewUrl();
  }
}
