import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/services/push_notification_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import '../models/sharedPreferences_const.dart';

import '../locator.dart';

class InitialViewModel extends FutureViewModel {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  final PushNotificationService _pushNotificationService =
      locator<PushNotificationService>();

  bool isTwoFactorAuthed = true;
  bool didSurvey;
  var authChange;

  Stream<User> getAuthChange() {
    // _sharedPreferencesService.setSharedPreferencesValue('twoFactor', false);
    if (isTwoFactorAuthed) {
      print("TWO FACTOR AT INITIAL when" + isTwoFactorAuthed.toString());
      print("AUTH STATE CHANGE IS " + authChange.toString());
      authChange = _authService.auth.authStateChanges();
      // print("TWO FACTOR AT INITIAL" + isTwoFactorAuthed.toString());
    } else {
      print("TWO FACTOR AT INITIAL" + isTwoFactorAuthed.toString());
      authChange = null;
    }
    print("AUTH STATE CHANGE IS " + authChange.toString());
    // authChange = _authService.auth.authStateChanges();
    return authChange;
  }

  Future<bool> getTwoFactor() async {
    return await _sharedPreferencesService.getSharedPreferencesValue(
        'twoFactor', bool);
  }

  Future getSharedPreferences() async {
    print(isTwoFactorAuthed);
    isTwoFactorAuthed = await _sharedPreferencesService
        .getSharedPreferencesValue('twoFactor', bool);

    didSurvey = await _sharedPreferencesService.getSharedPreferencesValue(
        didSurveyKey, bool);
    // _sharedPreferencesService.setSharedPreferencesValue(didSurveyKey, false);
    // print('didSurvey(shared preference only) is.. ' + didSurvey.toString());
    print(isTwoFactorAuthed);
    notifyListeners();
  }

  @override
  Future futureToRun() async {
    await _pushNotificationService.initialise();
    // _sharedPreferencesService.setSharedPreferencesValue(
    //     voteSelectTutorialKey, false);
    return getSharedPreferences();
  }
}
