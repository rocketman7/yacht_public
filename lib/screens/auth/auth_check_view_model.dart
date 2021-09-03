import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/repositories/user_repository.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';

import '../../locator.dart';

class AuthCheckViewModel extends GetxController {
  AuthService _authService = locator<AuthService>();
  FirestoreService _firestoreService = locator<FirestoreService>();

  UserRepository _userRepository = UserRepository();
  // User currentUser;
  Rxn<User>? currentUser = Rxn<User>();

  @override
  void onInit() async {
    // TODO: implement onInit
    currentUser!.bindStream(_authService.auth.authStateChanges());
    currentUser!.listen((user) async {
      print('listening $user');

      if (user != null) {
        // userModelRx.value = await _firestoreService.getUserModel(user.uid);
        print('when user is not null');
        userModelRx.bindStream(_userRepository.getUserStream(user.uid));
        userQuestModelRx.bindStream(_userRepository.getUserQuestStream(user.uid));

        // print('this user: ${userModelRx.value}.');
        // userModelRx.listen((user) {
        //   print('this user: $user');
        // });
      } else {
        userModelRx.value = null;
        print('when user is  null');
      }
    });
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
