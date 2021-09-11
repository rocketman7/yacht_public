// import 'package:stacked/stacked.dart';

// import '../models/user_model.dart';
// import '../locator.dart';
// import '../services/auth_service.dart';
// import '../services/database_service.dart';
// import '../services/stateManage_service.dart';

// class MypageFriendsCodeInsertViewModel extends FutureViewModel {
//   // Services Setting
//   final AuthService _authService = locator<AuthService>();
//   final DatabaseService _databaseService = locator<DatabaseService>();
//   final StateManageService _stateManageService = locator<StateManageService>();

//   // 변수 Setting
//   String uid;
//   UserModel user;
//   bool checking = false;
//   bool didInserted = false;
//   String insertedCode = '';
//   String errMsg = "";

//   // method
//   MypageFriendsCodeInsertViewModel() {
//     uid = _authService.auth.currentUser.uid;
//   }

//   Future getModels() async {
//     user = await _databaseService.getUser(uid);
//     if (user.insertedFriendsCode == null) {
//       didInserted = false;
//     } else {
//       didInserted = true;
//       insertedCode = user.insertedFriendsCode;
//     }
//     print('insertedFriendsCode is ' + didInserted.toString());
//   }

//   //추천코드를 입력하면, 1. 유효성 검사를 해주고, 2. 상대방 아이템 반영
//   Future friedsCodeGgook(String code) async {
//     checking = true;
//     notifyListeners();

//     if (code.length != 6) {
//       checking = false;
//       errMsg = '추천코드는 6자입니다! 다시 확인해주세요.';
//       notifyListeners();

//       return true;
//     }

//     if (user.friendsCode == code) {
//       checking = false;
//       errMsg = '자신의 추천코드는 입력할 수 없습니다.';
//       notifyListeners();

//       return true;
//     } else {
//       // 비로소 이제.. 그 추천코드를 가진 다른 유저가 있는지 검사해준다.
//       var a = await _databaseService.searchByFriendsCode(code);
//       // null 이면 없는 거고.. 아니면 있는것. uid를 뱉어냄
//       if (a == null) {
//         checking = false;
//         errMsg = '없는 추천코드입니다. 다시 확인해주세요.';
//         notifyListeners();

//         return true;
//       } else {
//         UserModel tempUser = await _databaseService.getUser(a.toString());
//         // _databaseService.updateUserItem(uid, 5);
//         _databaseService.updateUserItem(a.toString(), 5);
//         _databaseService.updateInsertedFriendsCode(uid, code);
//         await _stateManageService.userModelUpdate();

//         insertedCode = code;

//         didInserted = true;

//         checking = false;
//         errMsg = '';
//         notifyListeners();

//         return true;
//       }
//     }
//   }

//   @override
//   Future futureToRun() => getModels();
// }

import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:kakao_flutter_sdk/link.dart';

import '../../services/firestore_service.dart';
import '../../locator.dart';
import '../../repositories/repository.dart';

class FriendsCodeController extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();

  String uiFriendsCode = '추천 코드 생성 중';
  bool checking = false;
  bool dialogError = false;
  String errMsg = '';

  @override
  void onInit() async {
    // 프랜즈코드가 있다면 생성할 필요가 없고, 없다면 생성해야 한다.
    if (userModelRx.value!.friendsCode == null) {
      // 이런식으로 일부러 딜레이 줘서 추천코드 없는 사람도 최초 설정페이지 들어갔을 때 로딩 없도록
      Future.delayed(Duration(milliseconds: 1000)).then((value) async {
        genFriendsCode();
      });
    } else {
      uiFriendsCode = userModelRx.value!.friendsCode!;
    }

    super.onInit();
  }

  Future genFriendsCode() async {
    // 프렌즈코드가 없으면 생성, 그리고 중복체크 위해 다른 애들꺼까지 불러와야(아예 콜렉션을..)
    // while무한루프가 맞지만. 그러나 안정성을 위해 n번까지 중복되는 경우는 없다고 가정하고 for 문으로 하자.
    for (int i = 0; i < 50; i++) {
      // 랜덤스트링 생성
      String genCode = randomAlphaNumeric(6);
      bool isDuplicated =
          await _firestoreService.isFriendsCodeDuplicated(genCode);

      if (!isDuplicated) {
        // DB에 프렌즈코드 넣어주기
        _firestoreService.updateFriendsCode(userModelRx.value!.uid, genCode);
        uiFriendsCode = genCode;
        update(['friendsCode']);
        break;
      }
    }
  }

  void shareMyCode() async {
    try {
      var uri = await LinkClient.instance.customWithTalk(42121,
          templateArgs: {'key': userModelRx.value!.friendsCode!});
      await LinkClient.instance.launchKakaoTalk(uri);
    } catch (e) {
      print(e.toString());
    }
  }

  void resetFriendsCodeVar() {
    checking = false;
    dialogError = false;
    errMsg = '';
  }

  // 추천코드를 입력하면, 1. 유효성 검사를 해주고, 2. 상대방 아이템 반영
  Future friendsCodeYacht(String code) async {
    checking = true;
    update();

    if (code.length != 6) {
      checking = false;
      dialogError = true;
      errMsg = '추천코드는 6자입니다! 다시 확인해주세요.';
      print(errMsg);
      update();

      return false;
    }

    if (userModelRx.value!.friendsCode == code) {
      checking = false;
      dialogError = true;
      errMsg = '자신의 추천코드는 입력할 수 없습니다.';
      print(errMsg);
      update();

      return false;
    } else {
      // 비로소 이제.. 그 추천코드를 가진 다른 유저가 있는지 검사해준다.
      var a = await _firestoreService.searchByFriendsCode(code);
      // null 이면 없는 거고.. 아니면 있는것. uid를 뱉어냄
      if (a == null) {
        checking = false;
        dialogError = true;
        errMsg = '없는 추천코드입니다. 다시 확인해주세요.';
        print(errMsg);
        update();

        return false;
      } else {
        _firestoreService.updateOtherUserItem(a.toString(), 5);
        // 이 다음에 a의 (즉 코드입력받은 상대방) 피드?에 올려주든지 하면 좋을듯 (추천받아서 아이템 5개 받았다고)
        _firestoreService.updateInsertedFriendsCode(
            a.toString(), userModelRx.value!.friendsCode!);
        _firestoreService.updateFriendsCodeDone(userModelRx.value!.uid, true);

        // insertedCode = code;

        // didInserted = true;

        checking = false;
        errMsg = '';
        print(errMsg);
        update();

        return true;
      }
    }
  }
}
