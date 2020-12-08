import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import 'package:yachtOne/view_models/password_change_view_model.dart';

import '../locator.dart';
import '../view_models/nicknameSet_viewmodel.dart';

class PasswordChangeView extends StatefulWidget {
  @override
  _PasswordChangeViewState createState() => _PasswordChangeViewState();
}

class _PasswordChangeViewState extends State<PasswordChangeView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _checkPasswordController =
      TextEditingController();
  int _passwordLength = 0;
  int _checkPasswordLength = 0;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PasswordChangeViewModel>.reactive(
      viewModelBuilder: () => PasswordChangeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '비밀번호 변경하기',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            elevation: 1,
          ),
          backgroundColor: Colors.white,
          body: model.hasError
              ? Container(
                  child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                )
              : model.isBusy
                  ? Container()
                  : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 60,
                              ),
                              TextFormField(
                                onChanged: (text) {
                                  setState(() {
                                    _passwordLength = text.length;
                                  });
                                },
                                textAlign: TextAlign.left,
                                obscureText: true,
                                // 유저 네임 입력창
                                controller: _passwordController,
                                keyboardType: TextInputType.text,
                                // validator: (value) {},
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'DmSans',
                                  // fontWeight: FontWeight.w700,
                                  letterSpacing: -1.0,
                                ),

                                validator: (value) {
                                  if (value.length < 7) {
                                    return "7자 이상 비밀번호를 입력하세요";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFFF2F2F2),
                                      width: 1.0,
                                    ),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  alignLabelWithHint: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFFF2F2F2),
                                      width: 1.0,
                                    ),
                                  ),
                                  filled: false,
                                  hintText: "새 비밀번호",
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                  ),
                                  // border 둥글게 하고 inputform 밑줄 및 테두리 없앰
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextFormField(
                                onChanged: (text) {
                                  setState(() {
                                    _checkPasswordLength = text.length;
                                  });
                                },
                                obscureText: true,
                                textAlign: TextAlign.left,
                                // 유저 네임 입력창
                                controller: _checkPasswordController,
                                keyboardType: TextInputType.text,
                                // validator: (value) {},
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'DmSans',
                                  // fontWeight: FontWeight.w700,
                                  letterSpacing: -1.0,
                                ),

                                validator: (value) {
                                  if (value != _passwordController.text) {
                                    return "비밀번호가 다릅니다.";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFFF2F2F2),
                                      width: 1.0,
                                    ),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                  alignLabelWithHint: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color(0xFFF2F2F2),
                                      width: 1.0,
                                    ),
                                  ),
                                  filled: false,
                                  hintText: "비밀번호 확인",
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                  ),
                                  // border 둥글게 하고 inputform 밑줄 및 테두리 없앰
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              FlatButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate() &&
                                      (_passwordLength * _checkPasswordLength >
                                          0)) {
                                    model.chanegePassword(
                                      _passwordController.text,
                                      context,
                                    );
                                  }
                                },
                                minWidth: double.infinity,
                                height: 60,
                                child: model.checking
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "비밀번호 변경",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                color:
                                    (_passwordLength * _checkPasswordLength > 0)
                                        ? Color(0xFF1EC8CF)
                                        : Color(0xFFB2B7BE),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
