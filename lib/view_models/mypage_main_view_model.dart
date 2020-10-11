import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';

import '../services/dialog_service.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class MypageMainViewModel extends FutureViewModel {
  // Services Setting
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 변수 Setting
  String uid;
  UserModel user;

  // method
  MypageMainViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getModels() async {
    user = await _databaseService.getUser(uid);
  }

  void navigateToMypageToDown(String routeName) {
    _navigationService.navigateTo(routeName);
  }

  // 로그아웃 버튼이 눌렸을 경우..
  Future logout() async {
    // var dialogResult = await _dialogService.showDialog(
    //     title: '로그아웃',
    //     description: '로그아웃하시겠습니까?',
    //     buttonTitle: '네',
    //     cancelTitle: '아니오');
    // if (dialogResult.confirmed) {
    _sharedPreferencesService.setSharedPreferencesValue("twoFactor", false);
    _authService.signOut();

    //   _navigationService.popAndNavigateWithArgTo('initial');
    // }
  }

  @override
  Future futureToRun() => getModels();
}
