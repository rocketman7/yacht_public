import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';

import '../../services/firestore_service.dart';
import '../../services/account_verification_service.dart';
import '../../locator.dart';

class AccountViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AccountVerificationService _accountVerificationService = locator<AccountVerificationService>();

  // 차례대로 계좌인증 성공여부, 에러메세지 를 담는다.
  List accOwnerResp = [false, ''];
  List accOccupyResp = [false, ''];
  late int authNum;
  // 증권계좌가 인증되지 않았을 때 인증절차에서 필요한 ui 변수들. 이마저 viewmodel에 담는게 나은것인지?
  bool visibleButton1 = true;
  bool visibleBankList = false;
  bool ableBankListButton = true;
  bool visibleButton2 = false;
  bool ableButton2 = true;
  bool ableButton3 = false;
  bool visibleAuthNumProcess = false;
  bool verificationSuccess = false;
  String accVerificationFailMsg = '';
  String verificationFailMsg = '';
  bool accNumberInsertProcess = false;
  bool accNameInsertProcess = false;
  int selectSecLogo = 100;
  // 새로운 UI 흐름
  bool verificationFlowStart = false;
  bool selectBankFlow = false;
  // 사용자가 선택, 입력한 증권계좌정보들
  String secName = '';
  String bankCode = '';
  String accNumber = '';
  String accName = '';

  // method
  @override
  void onInit() async {
    if (userModelRx.value!.account == null || userModelRx.value!.account['secName'] != null) {
      for (int i = 0; i < _accountVerificationService.getBankListLength(); i++) {
        if (_accountVerificationService.getBankList().keys.toList()[i] == userModelRx.value!.account['secName'])
          selectSecLogo = i;
      }
    }

    super.onInit();
  }

  Future<String> accOwnerVerificationRequest() async {
    bankCode = _accountVerificationService.getBankList()['$secName']!;

    accOwnerResp = await _accountVerificationService.accOwnerVerification(accNumber, bankCode, accName);

    // notifyListeners();

    if (accOwnerResp[0])
      return 'success';
    else
      return accOwnerResp[1];
  }

  Future<String> accOccupyVerificationRequest() async {
    authNum = AccoutVerificationServiceMydata().authTextGenerate();

    bankCode = _accountVerificationService.getBankList()['$secName']!;

    accOccupyResp = await _accountVerificationService.accOccupyVerification(accNumber, bankCode, authNum.toString());

    // notifyListeners();

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

  Future<bool> accVerification(String authNumInput) async {
    if (authNumInput == authNum.toString()) {
      await setAccInformations();

      return true;
    } else {
      verificationFailMsg = '인증번호가 틀립니다. 다시 입력해주세요';

      return false;
    }
  }

  // Future setAccInformation() async {
  //   _databaseService.setAccInformation(user, uid);
  // }

  Future setAccInformations() async {
    await _firestoreService.setAccInformations(accNumber, accName, secName, userModelRx.value!.uid);
  }

  int getBankListLength() => _accountVerificationService.getBankListLength();

  Map<String, String> getBankList() => _accountVerificationService.getBankList();

  Map<String, String> getBankLogoList() => _accountVerificationService.getBankLogoList();
}
