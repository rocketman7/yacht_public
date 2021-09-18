import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:yachtOne/repositories/repository.dart';

class MixpanelService {
  final String token = "155a00c5962c973fc4f1d87442068894";
  Mixpanel mixpanel = Mixpanel("");
  // Map<String, dynamic> properties = {
  //   'uid': userModelRx.value!.uid,
  // };

  Future initMixpanel() async {
    mixpanel = await Mixpanel.init(token, optOutTrackingDefault: false);
    print("mixpanel initiated");
  }
}
