import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/services/auth_service.dart';
import '../../locator.dart';
import 'kakao_firebase_auth_api.dart';

class LoginViewModel extends GetxController {
  KakaoFirebaseAuthApi _api = KakaoFirebaseAuthApi();
  AuthService _authService = locator<AuthService>();
  @override
  void onInit() async {
    // TODO: implement onInit
    // _api.signOut();
    // await _authService.auth.signOut();
    super.onInit();
  }
}
