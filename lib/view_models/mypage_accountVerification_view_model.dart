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
  bool visibleButton2 = false;
  bool ableButton2 = true;
  bool visibleAuthNumProcess = false;
  bool verificationSuccess = false;
  String accVerificationFailMsg = '';
  String verificationFailMsg = '';
  bool accNumberInsertProcess = false;
  bool accNameInsertProcess = false;
  // 사용자가 선택, 입력한 증권계좌정보들
  String secName = '';
  String bankCode = '';
  String accNumber = '';
  String accName = '';

  // method
  MypageAccountVerificationViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getModels() async {
    user = await _databaseService.getUser(uid);
  }

  Future<String> accOwnerVerificationRequest() async {
    bankCode = accountVerificationService.getBankList()['$secName'];

    print(bankCode);

    accOwnerResp = await accountVerificationService.accOwnerVerification(
        accNumber, bankCode, accName);

    print(accOwnerResp[0]);
    print(accOwnerResp[1]);

    notifyListeners();

    if (accOwnerResp[0])
      return 'success';
    else
      return accOwnerResp[1];
  }

  Future<String> accOccupyVerificationRequest() async {
    authNum = AccoutVerificationServiceMydata().authTextGenerate();
    // authNum = 5555;

    bankCode = accountVerificationService.getBankList()['$secName'];

    print(bankCode);

    accOccupyResp = await accountVerificationService.accOccupyVerification(
        accNumber, bankCode, authNum.toString());

    print(accOccupyResp[0]);
    print(accOccupyResp[1]);

    notifyListeners();

    if (accOccupyResp[0])
      return 'success';
    else
      return accOccupyResp[1];
  }

  Future<String> accVerificationRequest() async {
    accVerificationFailMsg = '';

    String result1, result2;
    result1 = await accOwnerVerificationRequest();

    if (result1 == 'success') {
      result2 = await accOccupyVerificationRequest();
      if (result2 == 'success')
        return 'success';
      else {
        accVerificationFailMsg = result2;
        return result2;
      }
    } else {
      accVerificationFailMsg = result1;
      return result1;
    }
  }

  bool accVerification(String authNumInput) {
    if (authNumInput == authNum.toString()) {
      user.accNumber = accNumber;
      user.secName = secName;
      user.accName = accName;

      setAccInformation();
      return true;
    } else {
      verificationFailMsg = '인증번호가 틀립니다. 다시 입력해주세요';
      return false;
    }
  }

  Future setAccInformation() async {
    _databaseService.setAccInformation(user, uid);
  }

  int getBankListLength() => accountVerificationService.getBankListLength();

  Map<String, String> getBankList() => accountVerificationService.getBankList();

  Map<String, String> getBankLogoList() =>
      accountVerificationService.getBankLogoList();

  @override
  Future futureToRun() => getModels();
}
