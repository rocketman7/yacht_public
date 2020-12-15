import 'package:stacked/stacked.dart';

import '../models/user_model.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/stateManage_service.dart';

class MypageFriendsCodeInsertViewModel extends FutureViewModel {
  // Services Setting
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final StateManageService _stateManageService = locator<StateManageService>();

  // 변수 Setting
  String uid;
  UserModel user;
  bool checking = false;
  bool didInserted = false;
  String insertedCode = '';
  String errMsg = "";

  // method
  MypageFriendsCodeInsertViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getModels() async {
    user = await _databaseService.getUser(uid);
    if (user.insertedFriendsCode == null) {
      didInserted = false;
    } else {
      didInserted = true;
      insertedCode = user.insertedFriendsCode;
    }
    print('insertedFriendsCode is ' + didInserted.toString());
  }

  //추천코드를 입력하면, 1. 유효성 검사를 해주고, 2. 상대방 아이템 반영
  Future friedsCodeGgook(String code) async {
    checking = true;
    notifyListeners();

    if (code.length != 6) {
      checking = false;
      errMsg = '추천코드는 6자입니다! 다시 확인해주세요.';
      notifyListeners();

      return true;
    }

    if (user.friendsCode == code) {
      checking = false;
      errMsg = '자신의 추천코드는 입력할 수 없습니다.';
      notifyListeners();

      return true;
    } else {
      // 비로소 이제.. 그 추천코드를 가진 다른 유저가 있는지 검사해준다.
      var a = await _databaseService.searchByFriendsCode(code);
      // null 이면 없는 거고.. 아니면 있는것. uid를 뱉어냄
      if (a == null) {
        checking = false;
        errMsg = '없는 추천코드입니다. 다시 확인해주세요.';
        notifyListeners();

        return true;
      } else {
        UserModel tempUser = await _databaseService.getUser(a.toString());
        // _databaseService.updateUserItem(uid, 5);
        _databaseService.updateUserItem(a.toString(), 5);
        _databaseService.updateInsertedFriendsCode(uid, code);
        await _stateManageService.userModelUpdate();

        insertedCode = code;

        didInserted = true;

        checking = false;
        errMsg = '';
        notifyListeners();

        return true;
      }
    }
  }

  @override
  Future futureToRun() => getModels();
}
