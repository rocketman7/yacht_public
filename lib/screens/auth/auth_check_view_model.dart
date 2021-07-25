import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yachtOne/services/auth_service.dart';

import '../../locator.dart';

class AuthCheckViewModel extends GetxController {
  AuthService _authService = locator<AuthService>();

  // User currentUser;
  Rxn<User>? currentUser = Rxn<User>();

  @override
  void onInit() {
    // TODO: implement onInit
    currentUser!.bindStream(_authService.auth.authStateChanges());
    // _authService.auth.signOut();
    // _authService.auth.authStateChanges().listen((event) {
    //   print(event == null);
    //   print('event : ${event.toString()}');
    //   if (event == null) {
    //     print("event is null now");
    //     currentUser!(event);
    //   } else {
    //     currentUser!(event);
    //   }
    //   print('currentUser value: ${currentUser!.value}');
    // });
    super.onInit();
  }
}
