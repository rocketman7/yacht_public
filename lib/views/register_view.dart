import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/register_view_model.dart';
import '../views/constants/size.dart';

class RegisterView extends StatefulWidget {
  final PhoneAuthCredential? credential;
  RegisterView(this.credential);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final NavigationService? _navigationService = locator<NavigationService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  late int _nickLength;
  late int _emailLength;
  late int _passwordLength;
  late int _confirmPasswordLength;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _nickLength = 0;
    _emailLength = 0;
    _passwordLength = 0;
    _confirmPasswordLength = 0;
  }

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();

    final PhoneAuthCredential? credential = widget.credential;
    final Size size = MediaQuery.of(context).size;
    final deviceHeight = size.height;
    final deviceWidth = size.width;

    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(),
      onModelReady: (model) => model,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
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
                        "계정정보",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        "회원가입을 위해 아래 정보를 입력해주세요.",
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
                      TextFormField(
                        onChanged: (text) {
                          setState(() {
                            _nickLength = text.length;
                          });
                        },
                        textAlign: TextAlign.left,
                        // 유저 네임 입력창
                        controller: _userNameController,
                        keyboardType: TextInputType.text,
                        // validator: (value) {},
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'DmSans',
                          // fontWeight: FontWeight.w700,
                          letterSpacing: -1.0,
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
                          hintText: "닉네임",
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
                            _emailLength = text.length;
                          });
                        },
                        textAlign: TextAlign.left,
                        // 유저 네임 입력창
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        // validator: (value) {},
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'DmSans',
                          // fontWeight: FontWeight.w700,
                          letterSpacing: -1.0,
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
                          hintText: "이메일",
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
                            _passwordLength = text.length;
                          });
                        },
                        textAlign: TextAlign.left,
                        obscureText: true,
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.length < 7) {
                            return "7자 이상 비밀번호를 입력하세요";
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'DmSans',
                          // fontWeight: FontWeight.w700,
                          letterSpacing: -1.0,
                        ),
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
                          hintText: "비밀번호",
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
                            _confirmPasswordLength = text.length;
                          });
                        },
                        textAlign: TextAlign.left,
                        obscureText: true,
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "비밀번호가 다릅니다.";
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 25,
                          fontFamily: 'DmSans',
                          // fontWeight: FontWeight.w700,
                          letterSpacing: -1.0,
                        ),
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
                          hintText: "비밀번호 확인",
                          hintStyle: TextStyle(
                            fontSize: 15,
                          ),
                          // border 둥글게 하고 inputform 밑줄 및 테두리 없앰
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              (_nickLength *
                                      _emailLength *
                                      _passwordLength *
                                      _confirmPasswordLength >
                                  0)) {
                            model.register(
                              userName: _userNameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              credential: credential,
                              context: context,
                            );
                          }
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
                        color: (_nickLength *
                                    _emailLength *
                                    _passwordLength *
                                    _confirmPasswordLength >
                                0)
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
          )),
    );
  }

  Widget _inputForm(model, context, PhoneAuthCredential credential) {
    // FormState를 사용할 inputForm들을 모두 Form 아래에 위치해서 key 지정 -> validator에 조건 지정
    // .currentState.validate() 으로 validate 여부 가릴 수 있음
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: gap_xxxs,
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size(250, 50),
            ),
            child: TextFormField(
              // 유저 네임 입력창
              controller: _userNameController,
              keyboardType: TextInputType.emailAddress,
              // validator: ((value) {
              //   if (model.checkUserNameDuplicate(value) == true) {
              //     return "이미 존재하는 닉네임입니다";
              //   }
              //   return null;
              // }),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFABD8E3),
                labelText: "닉네임",
                labelStyle: TextStyle(fontSize: 11),
                // border 둥글게 하고 inputform 밑줄 및 테두리 없앰
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: gap_xxxs,
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size(250, 50),
            ),
            child: TextFormField(
              // 이메일 입력창
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFFABD8E3),
                labelText: "Email",
                labelStyle: TextStyle(fontSize: 11),
                // border 둥글게 하고 inputform 밑줄 및 테두리 없앰
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(height: gap_xxxs),
          ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size(250, 50),
            ),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value!.length < 7) {
                  return "7자 이상 비밀번호를 입력하세요";
                }
                return null;
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFABD8E3),
                  labelText: "Password",
                  labelStyle: TextStyle(fontSize: 11),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  )),
            ),
          ),
          SizedBox(
            height: gap_xxxs,
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size(250, 50),
            ),
            child: TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              // 위에서 입력한 passwordController와 현재 컨트롤러 밸류를 비교해서 동일한지 체크
              validator: (value) {
                if (value != _passwordController.text) {
                  return "비밀번호가 다릅니다.";
                }
                return null;
              },
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFABD8E3),
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(fontSize: 11),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  )),
            ),
          ),
          SizedBox(height: gap_m),
          // Card는 child의 크기를 이어 받는다 -> ConstrainedBox로 제한
          FlatButton(
            onPressed: () {
              //웨에 설정한 validation 들이 모두 true이면 아래 함수 실행
              // !! userName DB와 비교하여 중복 안 되게 해야 함!! //
              if (_formKey.currentState!.validate()) {
                model.register(
                  userName: _userNameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                  credential: credential,
                );
              }
            },
            child: Card(
              color: Color(0xFF961A1A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ConstrainedBox(
                constraints: BoxConstraints.tight(
                  Size(250, 50),
                ),
                child: Center(
                  child: Text(
                    "회원가입",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 11,
          ),
          FlatButton(
            onPressed: () {
              _navigationService!.navigateTo('login');
            },
            child: Text(
              "계정이 이미 있으면 로그인하세요!",
              style: TextStyle(fontSize: 14, color: Color(0xFFCFD8E4)),
            ),
          ),
        ],
      ),
    );
  }
}
