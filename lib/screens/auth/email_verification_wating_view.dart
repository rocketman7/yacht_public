import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/screens/auth/auth_check_view.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';

import '../../locator.dart';

class EmailVerificationWaitingView extends StatefulWidget {
  EmailVerificationWaitingView({Key? key}) : super(key: key);

  @override
  _EmailVerificationWaitingViewState createState() => _EmailVerificationWaitingViewState();
}

class _EmailVerificationWaitingViewState extends State<EmailVerificationWaitingView> {
  final AuthService _authService = locator<AuthService>();

  final FirestoreService _firestoreService = locator<FirestoreService>();
  late Timer timer;
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await _authService.auth.currentUser!.reload();
      var user = _authService.auth.currentUser;
      if (user!.emailVerified) {
        setState(() {
          isEmailVerified = user.emailVerified;
          Get.to(() => AuthCheckView());
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [Center(child: Text("이메일 인증을 해주세요. 메일을 인증하면 홈화면으로 바로 이동됩니다."))],
      ),
    );
  }
}
