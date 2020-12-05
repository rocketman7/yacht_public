import 'package:stacked/stacked.dart';
import 'package:random_string/random_string.dart';

import '../models/user_model.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class MypageFriendsCodeViewModel extends FutureViewModel {
  // Services Setting
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  // 변수 Setting
  String uid;
  UserModel user;

  // method
  MypageFriendsCodeViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getModels() async {
    user = await _databaseService.getUser(uid);

    //만약 프렌즈코드가 없다면,
    if (user.friendsCode == null) {
      // print('프렌즈코드가 없어요');
      // 프렌즈코드가 없으면 생성, 그리고 중복체크 위해 다른 애들꺼까지 불러와야(아예 콜렉션을..)
      // while무한루프가 맞지만. 그러나 안정성을 위해 n번까지 중복되는 경우는 없다고 가정하고 for 문으로 하자.
      for (int i = 0; i < 10; i++) {
        // 랜덤스트링 생성
        String genCode = randomAlphaNumeric(6);
        // print(code);

        //
        bool isDuplicated = await checkFriendsCode(genCode);

        if (!isDuplicated) {
          // DB에 프렌즈코드 넣어주기
          _databaseService.updateFriendsCode(uid, genCode);
          break;
        }
        // print(isDuplicated);
      }

      // user 콜렉션 다시 불러와줘야.
      user = await _databaseService.getUser(uid);
    } else {
      // print('프렌즈코드가 있어요');
    }
  }

  Future<bool> checkFriendsCode(String code) async {
    bool isDuplicated = await _databaseService.isFriendsCodeDuplicated(code);

    return isDuplicated;
  }

  @override
  Future futureToRun() => getModels();
}
