import 'dart:io';

bool rewardedAdsLoaded = false;

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3726614606720353~1645546590";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3726614606720353~1848726570";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3726614606720353/3696994867";
      // 아래 testId로 먼저.
      // return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3726614606720353/5596399897";
      // 아래 testId로 먼저.
      // return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3726614606720353/3671140756";
      return "ca-app-pub-3940256099942544/2247696110"; // test id
    } else if (Platform.isIOS) {
      // return "ca-app-pub-3726614606720353/2848820155";
      return "ca-app-pub-3940256099942544/3986624511"; // test id
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3726614606720353/3671140756";
      return "ca-app-pub-3726614606720353/6169650190";
    } else if (Platform.isIOS) {
      // return "ca-app-pub-3726614606720353/2848820155";
      return "ca-app-pub-3726614606720353/2641506715";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerBottomAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3726614606720353/3671140756";
      return "ca-app-pub-3726614606720353/6705547258";
    } else if (Platform.isIOS) {
      // return "ca-app-pub-3726614606720353/2848820155";
      return "ca-app-pub-3726614606720353/9651274797";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
