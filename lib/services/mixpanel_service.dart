import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelService {
  late Mixpanel mixpanel;
  // for Master
  // String token = "afd70bf6950f6a48c4c38856b667dffd";

  // for Dev
  String token = "8f21d7f99242efcdf97261003ec75ffa";
  Future<void> initMixpanel() async {
    mixpanel = await Mixpanel.init(token, optOutTrackingDefault: false);
    print("mixpanel initiated");
    // mixpanel.identify("test_uid");
    // mixpanel.track('test_event_track');
  }
}
