import 'package:flutter/material.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/views/constants/size.dart';

import '../view_models/phone_auth_view_model.dart';
import '../locator.dart';

class PhoneAuthView extends StatefulWidget {
  @override
  _PhoneAuthViewState createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  final NavigationService _navigationService = locator<NavigationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _verifyNumberController = TextEditingController();

  String _textValue = "인증번호 전송";
  bool _visibility = false;
  int _smsCodeLength;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    deviceHeight = size.height;
    deviceWidth = size.width;
    print("phoneAuthView rebuilt");
    return ViewModelBuilder<PhoneAuthViewModel>.reactive(
      viewModelBuilder: () => PhoneAuthViewModel(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: deviceHeight * .08,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Image(
                        image: AssetImage('assets/images/ggookLogo.png'),
                        height: 75,
                      ),
                    ),
                    SizedBox(
                      height: deviceHeight * .02,
                    ),
                    Text(
                      "휴대폰인증",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      "안녕하세요. 꾸욱에 오신 걸 환영합니다.\n휴대폰 인증을 진행해주세요.",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Stack(
                      children: <Widget>[
                        TextFormField(
                          textAlign: TextAlign.left,
                          // 유저 네임 입력창
                          controller: _phoneNumberController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value.length < 9) {
                              return "휴대폰 번호가 잘못됐습니다";
                            }
                            return null;
                          },
                          style: TextStyle(
                            fontSize: 25,
                            fontFamily: 'Arkhip',
                            // fontWeight: FontWeight.w700,
                            letterSpacing: -2.0,
                          ),
                          // validator: ((value) {
                          //   if (model.checkUserNameDuplicate(value) == true) {
                          //     return "이미 존재하는 닉네임입니다";
                          //   }
                          //   return null;
                          // }),
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFF2F2F2),
                                width: 1.0,
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            alignLabelWithHint: true,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFF2F2F2),
                                width: 1.0,
                              ),
                            ),
                            filled: false,
                            hintText: "휴대폰 번호",
                            hintStyle: TextStyle(
                              fontSize: 15,
                            ),
                            // border 둥글게 하고 inputform 밑줄 및 테두리 없앰
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () async {
                                print(_formKey.currentState.validate());
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _textValue = "재전송";
                                    _visibility = true;
                                  });
                                  model.phoneAuth(
                                      "+82" +
                                          _phoneNumberController.text
                                              .trim()
                                              .substring(1),
                                      context);
                                }
                              },
                              child: Text(
                                _textValue,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Color(0xFF1EC8CF),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Visibility(
                      visible: _visibility,
                      child: Stack(
                        children: <Widget>[
                          TextFormField(
                            onChanged: (text) {
                              setState(() {
                                _smsCodeLength = text.length;
                              });
                            },
                            textAlign: TextAlign.left,
                            // 유저 네임 입력창
                            controller: _verifyNumberController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Arkhip',
                              // fontWeight: FontWeight.w700,
                              letterSpacing: -2.0,
                            ),
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
                              hintText: "인증번호 입력",
                              hintStyle: TextStyle(
                                fontSize: 15,
                              ),
                              // border 둥글게 하고 inputform 밑줄 및 테두리 없앰
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Timer",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFFF402B),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: _visibility,
                      child: FlatButton(
                        onPressed: () async {
                          (_smsCodeLength == 6)
                              ? model.matchCode(
                                  _verifyNumberController.text.trim())
                              : 0;
                        },
                        minWidth: double.infinity,
                        height: 60,
                        child: model.isBusy
                            ? CircularProgressIndicator()
                            : Text(
                                "다음",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                        color: (_smsCodeLength == 6)
                            ? Color(0xFF1EC8CF)
                            : Color(0xFFB2B7BE),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("이미 회원이신가요?"),
                        ButtonTheme(
                          // minWidth: 2,
                          child: FlatButton(
                            onPressed: () {
                              _navigationService.navigateTo('login');
                            },
                            child: Text("로그인하기",
                                style: TextStyle(
                                    fontSize: 14, color: Color(0xFF1EC8CF))),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // InkWell(
  //                         onTap: () {
  //                           _navigationService.navigateTo('login');
  //                         },
  //                         child: Container(
  //                           alignment: Alignment.center,
  //                           height: 20,
  //                           // color: Colors.red,
  //                           child: Text(" 로그인하기",
  //                               style: TextStyle(
  //                                 fontSize: 14,
  //                                 color: Color(0xFF1EC8CF),
  //                               )),
  //                         ),
  //                       )
}
