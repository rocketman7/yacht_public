import 'package:yachtOne/managers/dialog_manager.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/dialog_service.dart';
import 'package:yachtOne/view_models/base_model.dart';

import '../locator.dart';

class PhoneAuthViewModel extends BaseModel {
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final DialogService _dialogService = locator<DialogService>();

  // authService로 폰 번호와 content 넘겨서 폰 인증 작업 시작
  Future<dynamic> phoneAuth(String phoneNumber, context) async {
    // 기존에 가입한 핸드폰 번호인지 check해야 함
    // 이미 가입한 핸드폰 있으면 false 반환
    bool duplicatePhoneNumber =
        await _databaseService.duplicatePhoneNumberCheck(phoneNumber);

    if (duplicatePhoneNumber == false) {
      await _dialogService.showDialog(
        title: '핸드폰 인증 오류',
        description: '이미 가입한 핸드폰 번호입니다',
      );
      return true;
    } else {
      await _authService.verifyPhoneNumber(phoneNumber, context);
    }
  }
}
