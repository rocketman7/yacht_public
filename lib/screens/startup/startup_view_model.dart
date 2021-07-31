import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/league_address_model.dart';

class StartupViewModel extends GetxController {
  late LeagueAddressModel addressModel;
  @override
  void onInit() {
    // get league Address
    Future.delayed(Duration(seconds: 1)).then((value) => addressModel =
        LeagueAddressModel(league: "league001", date: "20210706", uid: "uid"));
    super.onInit();
  }
}
