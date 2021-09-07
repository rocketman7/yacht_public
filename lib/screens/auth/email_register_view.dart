import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:email_validator/email_validator.dart';

class EmailRegisterView extends StatefulWidget {
  EmailRegisterView({Key? key}) : super(key: key);

  @override
  _EmailRegisterViewState createState() => _EmailRegisterViewState();
}

class _EmailRegisterViewState extends State<EmailRegisterView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController(text: "");

  final TextEditingController _passwordController = TextEditingController(text: "");

  final TextEditingController _confirmPasswordController = TextEditingController(text: "");
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
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
                    validator: (value) {
                      if (value!.length > 7) {
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
              InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    print(_emailController.text);
                  }
                },
                child: bigTextContainerButton(
                  text: "가입 완료하기",
                  isDisabled: true,
                  height: 60.w,
                ),
              ),
              bigTextContainerButton(text: "가입 완료하기", isDisabled: false, height: 60.w),
            ],
          ),
        )),
      ),
    );
  }
}
