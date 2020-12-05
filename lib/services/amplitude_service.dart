import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

class AmplitudeService {
  final Amplitude analytics = Amplitude.getInstance(instanceName: 'testGgook');
  final String apiKey = "2b70b7ef5dca3bc9708968745c935a0c";

  Future voteViewModelLog(String uid) async {
    analytics.init(apiKey);
    analytics.setUserId(uid);
    analytics.trackingSessionEvents(true);

    analytics.logEvent(
      'Vote Select View',
      // eventProperties: {'friend_num': 10, 'is_heavy_user': true}
    );
  }

  Future viewStockInfo(String uid) async {
    analytics.init(apiKey);
    analytics.setUserId(uid);
    analytics.trackingSessionEvents(true);

    analytics.logEvent('Stock Info View');
  }

  Future initialiseSession() async {
    final Amplitude analytics = Amplitude.getInstance(instanceName: "project");
    // Create the instance

    // Initialize SDK
    print("before intialized");
    // apiKey
    analytics.init("2b70b7ef5dca3bc9708968745c935a0c");
    // Set user Id
    print("set user id");
    analytics.setUserId("test_user");

    // Turn on automatic session events
    analytics.trackingSessionEvents(true);
  }

  Future<void> exampleForAmplitude() async {
    // Create the instance
    final Amplitude analytics = Amplitude.getInstance(instanceName: "project");

    // Initialize SDK
    print("before intialized");
    analytics.setServerUrl("https://api2.amplitude.com");
    analytics.init("2b70b7ef5dca3bc9708968745c935a0c");
    print("intialized");
    print("set user id");
    analytics.setUserId("test_user");

    // Turn on automatic session events
    analytics.trackingSessionEvents(true);
    // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
    // analytics.enableCoppaControl();

    // Log an event
    print("logging");
    analytics.logEvent('MyApp startup',
        eventProperties: {'friend_num': 10, 'is_heavy_user': true});

    // Identify
    print("identify");
    final Identify identify1 = Identify()
      ..set('identify_test',
          'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
      ..add('identify_count', 1);
    analytics.identify(identify1);

    // Set group
    print("grouping");
    analytics.setGroup('orgId', 15);

    // Group identify
    final Identify identify2 = Identify()..set('identify_count', 1);
    analytics.groupIdentify('orgId', '15', identify2);
  }
}
