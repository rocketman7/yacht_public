import 'package:flutter/material.dart';

import '../locator.dart';
import '../services/accountVerification_service.dart';

class AccountVerificationViewModel extends ChangeNotifier {
  // Services Setting
  final AccountVerificationService accountVerificationService =
      locator<AccountVerificationService>();

  // 변수 Setting
  // 차례대로 계좌인증 성공여부, 에러메세지 를 담는다.
  List accOwnerResp = [false, ''];
  List accOccupyResp = [false, ''];
  int authNum;

  // method
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
}
