import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/league_address_model.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';

class StartupViewModel extends GetxController {
  late LeagueAddressModel addressModel;
  late RxInt selectedPage;
  @override
  void onInit() {
    selectedPage = 0.obs;
    // get league Address
    Future.delayed(Duration(seconds: 1)).then((value) => addressModel = LeagueAddressModel(league: "league001", date: "20210706", uid: "uid"));
    super.onInit();
  }
}
