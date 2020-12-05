import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/api/firebase_kakao_auth_api.dart';
import 'package:yachtOne/views/startup_view.dart';

import '../services/sharedPreferences_service.dart';
import '../services/stateManage_service.dart';
import '../services/dialog_service.dart';

import '../locator.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../views/vote_select_v2_view.dart';

class MypageMainViewModel extends FutureViewModel {
  // Services Setting
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  final StateManageService _stateManageService = locator<StateManageService>();

  // 변수 Setting
  String uid;
  UserModel user;

  // method
  MypageMainViewModel() {
    _authService.auth.currentUser.uid == null
        ? _authService.auth.signOut()
        : uid = _authService.auth.currentUser.uid;
  }

  Future getModels() async {
    if (_stateManageService.appStart) {
      await _stateManageService.initStateManage(initUid: uid);
    } else {
      if (await _stateManageService.isNeededUpdate())
        await _stateManageService.initStateManage(initUid: uid);
    }

    user = _stateManageService.userModel;
  }

  Future<void> navigateToMypageToDown(String routeName) async {
    await _navigationService.navigateTo(routeName);
    // 이렇게 페이지 넘어가는 부분에서 await 걸어주고 후에 후속조치 취해주면 하위페이지에서 변동된 데이터를 적용할 수 있음
    await getModels();
    notifyListeners();
  }

  Future<void> navigateToHome() async {
    await _navigationService.navigateToHome(StartUpView(0));
    // await _navigationService.popAndNavigateWithArgTo('startup');
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
    _stateManageService.setMyState();
    _stateManageService.setAppStart();
    FirebaseKakaoAuthAPI().signOut();
    _authService.signOut();
    _navigationService.popAndNavigateWithArgTo('initial');
    // await _navigationService.navigateToMyPage(MypageMainView());

    // _navigationService.popAndNavigateWithArgTo('initial');
    // }
  }

  Future deleteAccount(String uid) async {
    await _databaseService.deleteUser();
    await _authService.deleteAccount();
    _sharedPreferencesService.setSharedPreferencesValue("twoFactor", false);
    _stateManageService.setMyState();
    _stateManageService.setAppStart();
    _navigationService.popAndNavigateWithArgTo('initial');
  }

  @override
  Future futureToRun() => getModels();
}
