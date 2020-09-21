import 'package:stacked/stacked.dart';

import '../models/user_model.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/accountVerification_service.dart';

class MypageAccountVerificationViewModel extends FutureViewModel {
  // Services Setting
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final AccountVerificationService accountVerificationService =
      locator<AccountVerificationService>();

  // 변수 Setting
  String uid;
  UserModel user;
  // 차례대로 계좌인증 성공여부, 에러메세지 를 담는다.
  List accOwnerResp = [false, ''];
  List accOccupyResp = [false, ''];
  int authNum;
  // 증권계좌가 인증되지 않았을 때 인증절차에서 필요한 ui 변수들. 이마저 viewmodel에 담는게 나은것인지?
  bool visibleButton1 = true;
  bool visibleBankList = false;

  // method
  MypageAccountVerificationViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getModels() async {
    user = await _databaseService.getUser(uid);
  }

  Future<void> accOwnerVerificationRequest() async {
    accOwnerResp = await accountVerificationService.accOwnerVerification(
        '17711040661', '278', '김세준');

    print(accOwnerResp[0]);
    print(accOwnerResp[1]);

    notifyListeners();
    return null;
  }

  Future<void> accOccupyVerificationRequest() async {
    authNum = AccoutVerificationServiceMydata().authTextGenerate();
    accOccupyResp = await accountVerificationService.accOccupyVerification(
        '17711040661', '278', authNum.toString());

    print(accOccupyResp[0]);
    print(accOccupyResp[1]);

    notifyListeners();
    return null;
  }

  @override
  Future futureToRun() => getModels();
}
