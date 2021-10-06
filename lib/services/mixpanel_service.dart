import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:yachtOne/repositories/repository.dart';

class MixpanelService {
  final String token = "155a00c5962c973fc4f1d87442068894"; // dev token
  // final String token = "9002bc5f97f293659ca2f2f7e1b512c1"; // product token
  Mixpanel mixpanel = Mixpanel("");
  // Map<String, dynamic> properties = {
  //   'uid': userModelRx.value!.uid,
  // };'

  Future initMixpanel() async {
    mixpanel = await Mixpanel.init(token, optOutTrackingDefault: false);
    print("mixpanel initiated");
    mixpanel.flush();
  }
}
