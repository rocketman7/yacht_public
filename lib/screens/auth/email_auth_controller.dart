import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/auth_service.dart';

class EmailAuthController extends GetxController {
  final AuthService _authService = locator<AuthService>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future startWithEmail(String email, String password) async {
    // UserModel newUser = newUserModel(
    //   uid: 'uid',
    //   userName: "새유저",
    // );

    // print(newUser.toMap());

    // print('auth controller');
    await _authService.startWithEmail(email, password);
  }
}