import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/auth_service.dart';
import '../services/navigation_service.dart';
import '../view_models/login_view_model.dart';
import '../locator.dart';
import '../views/constants/size.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  int _passwordLength = 0;
  // 애니메이션 컨트롤러, 애니메이션 선언
  // AnimationController _aniController;
  // Animation _animation;

  // input과 관련된 컨트롤러 선언

  // @override
  // void initState() {
  //   super.initState();
  //   _aniController = AnimationController(
  //     duration: const Duration(seconds: 7),
  //     vsync: this,
  //   );
  //   // Tween은 _animation의 두 사이 값을 지정
  //   _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
  //     CurvedAnimation(
  //       curve: Curves.easeIn,
  //       parent: _aniController,
  //     ),
  //   );
  //   _aniController.repeat();
  // }

  // @override
  // void dispose() {
  //   _aniController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    deviceHeight = size.height;
    deviceWidth = size.width;
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
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
                      "이메일로 로그인",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      "안녕하세요. 꾸욱에 오신 걸 환영합니다.\n이메일 로그인을 진행해주세요.",
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
                      textAlign: TextAlign.left,
                      // 유저 네임 입력창
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {},
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
                        hintText: "이메일을 입력해주세요",
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
                          print(_passwordLength);
                        });
                      },
                      textAlign: TextAlign.left,
                      // 유저 네임 입력창
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
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
                        hintText: "비밀번호를 입력해주세요",
                        hintStyle: TextStyle(
                          fontSize: 15,
                        ),
                        // border 둥글게 하고 inputform 밑줄 및 테두리 없앰
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FlatButton(
                      onPressed: () {
                        model.login(
                            email: _emailController.text,
                            password: _passwordController.text);
                      },
                      minWidth: double.infinity,
                      height: 60,
                      child: model.isBusy
                          ? CircularProgressIndicator()
                          : Text(
                              "로그인",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                      color: (_passwordLength == 0)
                          ? Color(0xFFB2B7BE)
                          : Color(0xFF1EC8CF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("꾸욱 계정이 없으신가요?"),
                        ButtonTheme(
                          // minWidth: 2,
                          child: FlatButton(
                            onPressed: () {
                              _navigationService.navigateTo('phoneAuth');
                            },
                            child: Text("회원가입하기",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1EC8CF),
                                )),
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

  Stack buildStack(LoginViewModel model) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 1],
              colors: <Color>[
                const Color(0xFF7BE0C8),
                const Color(0xFF53D3D8),
              ],
            ),
          ),
        ),
        // 이걸로 column 전체 감싸줘야 키보드 열릴 때 화면 가변적으로 움직이게 됨
        SingleChildScrollView(
          // reverse를 true로 둬야 Email Textform 클릭했을 때 column 맨 아래까지 키보드 위로 올라감.
          reverse: true,
          child: Column(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
              ),
              Text(
                "꾸  욱",
                style: TextStyle(
                  fontFamily: 'NanumHandWriting',
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/images/googleLogo.png'),
                    height: 27,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Sign in with Google Account',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // 아래 따로 위젯으로 만듬
              _inputForm(model),
              SizedBox(
                height: 11,
              ),
              FlatButton(
                onPressed: () {
                  _navigationService.navigateTo('phoneAuth');
                },
                child: Text(
                  "계정이 없으신가요? 지금 가입하세요!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ],
    );
  }

  // 로그인 관련한 inputForm 위젯
  Widget _inputForm(model) {
    return Column(children: <Widget>[
      // TextFormField 크기 제한
      Container(
        width: 250,
        child: TextFormField(
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
      SizedBox(
        height: gap_xxxs,
      ),
      Container(
        width: 250,
        child: TextFormField(
          controller: _passwordController,
          obscureText: true,
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
      SizedBox(height: gap_m),
      // Card는 child의 크기를 이어 받는다 -> ConstrainedBox로 제한
      FlatButton(
        //VIewModel의 login함수로 계정 정보를 넘긴다.
        onPressed: () => model.login(
            email: _emailController.text, password: _passwordController.text),
        child: Card(
          color: Color(0xFF09C3CF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size(250, 50),
            ),
            child: Center(
              child: Text(
                "로그인",
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
    ]);
  }
}
