import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';

import '../../locator.dart';
import '../../services/mixpanel_service.dart';
import 'email_auth_controller.dart';

class EmailRegisterView extends StatefulWidget {
  EmailRegisterView({Key? key}) : super(key: key);

  @override
  _EmailRegisterViewState createState() => _EmailRegisterViewState();
}

class _EmailRegisterViewState extends State<EmailRegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController(text: "");

  final TextEditingController _passwordController = TextEditingController(text: "");

  final EmailAuthController controller = Get.put((EmailAuthController()));

  // final TextEditingController _confirmPasswordController = TextEditingController(text: "");
  bool _obscureText = true;
  bool _registerButtonDisabled = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
            child: Padding(
          padding: primaryAllPadding * 2,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: correctHeight(60.w, 0.0, emailRegisterTitle.fontSize),
                ),
                Text(
                  "이메일로 시작하기",
                  style: emailRegisterTitle,
                ),
                SizedBox(
                  height: correctHeight(50.w, emailRegisterTitle.fontSize, emailRegisterFieldName.fontSize),
                ),
                Text(
                  "이메일",
                  style: emailRegisterFieldName,
                ),
                TextFormField(
                  controller: _emailController,
                  onChanged: (_) {
                    if (_emailController.text.length > 0 &&
                        EmailValidator.validate(_emailController.text) &&
                        _passwordController.text.length > 6) {
                      setState(() {
                        _registerButtonDisabled = false;
                      });
                    } else {
                      setState(() {
                        _registerButtonDisabled = true;
                      });
                    }
                  },
                  validator: (value) {
                    if (value!.length > 0 && EmailValidator.validate(value)) {
                      print("email");
                      return null;
                    } else {
                      return "! 올바른 이메일 형식으로 입력해주세요.";
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: emailRegisterInputDecoration,
                ),
                SizedBox(
                  height: correctHeight(50.w, emailRegisterFieldHint.fontSize, emailRegisterFieldName.fontSize),
                ),
                Text(
                  "비밀번호",
                  style: emailRegisterFieldName,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      onChanged: (_) {
                        if (_emailController.text.length > 0 &&
                            EmailValidator.validate(_emailController.text) &&
                            _passwordController.text.length > 6) {
                          setState(() {
                            _registerButtonDisabled = false;
                          });
                        } else {
                          setState(() {
                            _registerButtonDisabled = true;
                          });
                        }
                      },
                      validator: (value) {
                        if (value!.length > 6) {
                          print("email");
                          return null;
                        } else {
                          return "! 7자 이상의 비밀번호를 입력해주세요.";
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: emailRegisterInputDecoration.copyWith(hintText: "7자 이상의 비밀번호를 입력해주세요."),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Icon(
                            Icons.remove_red_eye_outlined,
                          ),
                        ))
                  ],
                ),
                // Text(
                //   "비밀번호 확인",
                //   style: emailRegisterFieldName,
                // ),
                // TextFormField(
                //   controller: _passwordController,
                //   obscureText: true,
                //   validator: (value) {
                //     if (value! == _passwordController.text) {
                //       print("email");
                //       return null;
                //     } else {
                //       return "! 비밀번호가 일치하지 않아요.";
                //     }
                //   },
                //   keyboardType: TextInputType.emailAddress,
                //   decoration: emailRegisterInputDecoration,
                // ),
                // Text(
                //   "이메일 형식으로 입력해주세요.",
                //   style: emailRegisterFieldInstruction,
                // ),

                SizedBox(
                  height: 50.w,
                ),
                Obx(() => !controller.isAuthProcessing.value
                    ? InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            await controller.startWithEmail(_emailController.text, _passwordController.text);
                          }
                        },
                        child: bigTextContainerButton(
                          text: "시작하기",
                          isDisabled: _registerButtonDisabled,
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
                    if (_emailController.text.length > 0 && EmailValidator.validate(_emailController.text)) {
                      yachtSnackBarFromBottom("비밀번호 재설정 이메일을 전송하였습니다.");
                      controller.passwordRecreate(_emailController.text);
                    }
                  },
                  child: Center(
                    child: Text(
                      '비밀번호 재설정하기',
                      style: settingLogout,
                    ),
                  ),
                )
                // bigTextContainerButton(text: "가입 완료하기", isDisabled: false, height: 60.w),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
