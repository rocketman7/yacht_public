import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';

import '../repositories/repository.dart';

class AppsflyerService extends GetxService {
  Map<String, dynamic> appsFlyerOptions = {};
  AppsflyerSdk appsflyerSdk = AppsflyerSdk(
    AppsFlyerOptions(
      afDevKey: 'EYsojBdLQEn9rLjkSe9xgG',
      showDebug: true,
      appId: '1536611320',
    ),
  );

  @override
  void onInit() {
    // print('appsf init');
    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);

    // appsflyerSdk.logEvent('test event', {'uid': 'testUid'});
    // TODO: implement onInit

    super.onInit();
  }
}
