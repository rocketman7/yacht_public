import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/screens/auth/auth_check_view.dart';
import 'package:yachtOne/screens/auth/email_verification_wating_view.dart';

import '../locator.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Future startWithEmail(String email, String password) async {
    print('start with email');
    try {
      UserCredential authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
      print('registered');
      if (authResult.user != null) {
        UserModel newUser = newUserModel(
          uid: authResult.user!.uid,
          userName: "새유저",
        );

        _firestoreService.makeNewUser(newUser);
        await authResult.user!.sendEmailVerification();
        Get.to(() => EmailVerificationWaitingView());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        /// ab@gmail.com has alread been registered.
        print('already in use');
        print(email);
        print("trying login");
      }
      UserCredential authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
      if (authResult.user != null) {
        if (!authResult.user!.emailVerified) {
          await authResult.user!.sendEmailVerification();
          Get.to(() => EmailVerificationWaitingView());
        } else {
          Get.to(() => AuthCheckView());
        }
        // Get.back();
      }
    }
  }
}
