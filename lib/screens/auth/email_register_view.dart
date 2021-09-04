import 'package:flutter/material.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailRegisterView extends StatelessWidget {
  EmailRegisterView({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController(text: "");
  final TextEditingController _passwordController = TextEditingController(text: "");
  final TextEditingController _confirmPasswordController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: primaryAllPadding * 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "회원가입",
              style: emailRegisterTitle,
            ),
            Text(
              "이메일",
              style: emailRegisterFieldName,
            ),
            TextFormField(
              controller: _emailController,
              decoration: emailRegisterInputDecoration,
            ),
            Text(
              "이메일 형식으로 입력해주세요.",
              style: emailRegisterFieldInstruction,
            ),
            bigTextContainerButton(text: "가입 완료하기", isDisabled: true, height: 60.w),
            bigTextContainerButton(text: "가입 완료하기", isDisabled: false, height: 60.w),
          ],
        ),
      )),
    );
  }
}
