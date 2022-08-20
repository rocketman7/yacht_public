import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/auth/auth_check_view.dart';
import 'package:yachtOne/screens/auth/auth_check_view_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

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
  RxBool justSent = false.obs;

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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: defaultPaddingAll * 2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: correctHeight(60.w, 0.0, emailRegisterTitle.fontSize),
                  ),
                  Text(
                    "이메일 인증 요청",
                    style: emailRegisterTitle,
                  ),
                  SizedBox(
                    height: correctHeight(40.w, emailRegisterTitle.fontSize, emailRegisterFieldName.fontSize),
                  ),
                  Text(
                    _authService.auth.currentUser!.email!,
                    style: TextStyle(
                      fontSize: 16.w,
                      fontWeight: FontWeight.w600,
                      color: yachtViolet,
                    ),
                  ),
                  SizedBox(
                    height: correctHeight(14.w, emailRegisterTitle.fontSize, emailRegisterFieldName.fontSize),
                  ),
                  Text(
                    "위 이메일로 인증 링크를 보내드렸어요.\n링크를 눌러 인증을 완료해주세요.\n인증이 완료되면 메인으로 자동 이동됩니다.\n\n혹시 메일이 오지 않았나요?\n스팸 메일함을 확인해보시고\n여전히 메일이 오지 않았다면\n아래 버튼으로 재요청해주세요.\n\n문제가 계속되면 \nofficial@team-yacht.com으로 문의주세요.",
                    style: TextStyle(
                      fontFamily: 'Default',
                      fontSize: 16.w,
                      // fontWeight: FontWeight.w600,
                      color: yachtLightGrey,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(
                    height: 50.w,
                  ),
                  Obx(() => !justSent.value
                      ? InkWell(
                          onTap: () async {
                            HapticFeedback.mediumImpact();
                            justSent(true);
                            _authService.auth.currentUser!.sendEmailVerification();
                            Future.delayed(Duration(seconds: 1)).then((value) {
                              justSent(false);
                              yachtSnackBarFromBottom("인증메일을 전송하였습니다.");
                            });
                          },
                          child: bigTextContainerButton(
                            text: "인증메일 재요청",
                            isDisabled: false,
                            height: 60.w,
                          ),
                        )
                      : Container(
                          height: 60.w,
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                          decoration: BoxDecoration(
                            color: primaryButtonBackground,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: buttonNormal,
                            ),
                          ),
                        )),
                  SizedBox(height: 20.w),

                  InkWell(
                    onTap: () async {
                      _authService.auth.signOut();
                      userModelRx(null);
                      userQuestModelRx.value = [];
                      leagueRx("");
                      print("signout");
                      Navigator.of(context).pop();
                      await Get.offAll(() => AuthCheckView());
                      // Get.find<AuthCheckViewModel>().onInit();
                    },
                    child: Center(
                      child: Text(
                        '로그아웃',
                        style: settingLogout,
                      ),
                    ),
                  )
                  // bigTextContainerButton(text: "가입 완료하기", isDisabled: false, height: 60.w),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
