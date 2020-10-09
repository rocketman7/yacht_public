import 'package:stacked/stacked.dart';

import '../models/user_model.dart';
import '../locator.dart';
import '../services/navigation_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/sharedPreferences_service.dart';
import '../models/sharedPreferences_const.dart';

// 아바타이미지들 List 나중에 다른곳으로 뺴줘야?
List<String> globalAvatarImages = [
  'avatar',
  'avatar001',
  'avatar002',
  'avatar003',
  'avatar004',
  'avatar005',
  'avatar006',
  'avatar007',
  'avatar008',
  'avatar009',
];

class MypageEditProfileViewModel extends FutureViewModel {
  // Services Setting
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  // 변수 Setting
  String uid;
  UserModel user;
  String sharedPrefForAvatarImage; //DB에서 관리되지만 즉각적반응을 위해 sharedPref도
  String checkedAvatarImage;
  List<String> avatarImages = [];

  void setAvatarImage(String avatarImage) {
    _databaseService.setAvatarImage(avatarImage, uid);
    _sharedPreferencesService.setSharedPreferencesValue(avatarKey, avatarImage);
    sharedPrefForAvatarImage = avatarImage;

    notifyListeners();
  }

  // method
  MypageEditProfileViewModel() {
    uid = _authService.auth.currentUser.uid;
    avatarImages = globalAvatarImages;
  }

  // 다시 돌아갈 때~ 아직 이상하게 구현됨
  void navigateToMypageMainAgain() {
    _navigationService.popAndNavigateWithArgTo('mypage_main');
  }

  Future getModels() async {
    user = await _databaseService.getUser(uid);
    sharedPrefForAvatarImage = await _sharedPreferencesService
        .getSharedPreferencesValue(avatarKey, String);

    if (sharedPrefForAvatarImage == '') {
      // sharedPref가 없으면 DB에 있으면 그걸로, 아님 기본값으로
      sharedPrefForAvatarImage = user.avatarImage ?? avatarImages[0];
    }

    checkedAvatarImage = sharedPrefForAvatarImage;
  }

  @override
  Future futureToRun() => getModels();
}
