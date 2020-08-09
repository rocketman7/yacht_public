import 'dart:math';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';
import '../services/auth_service.dart';
import '../services/navigation_service.dart';
import 'package:flutter/material.dart';
import '../view_models/login_view_model.dart';
import '../locator.dart';
import '../views/constants/size.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();

  // 애니메이션 컨트롤러, 애니메이션 선언
  AnimationController _aniController;
  Animation _animation;

  // input과 관련된 컨트롤러 선언
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _aniController = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    );
    // Tween은 _animation의 두 사이 값을 지정
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        curve: Curves.easeIn,
        parent: _aniController,
      ),
    );
    _aniController.repeat();
  }

  @override
  void dispose() {
    _aniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) => model,
      builder: (context, model, child) => Scaffold(
        body: Stack(
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
                      _navigationService.navigateTo('register');
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
        ),
      ),
    );
  }

  // 로그인 관련한 inputForm 위젯
  Widget _inputForm(model) {
    return Column(children: <Widget>[
      // TextFormField 크기 제한
      ConstrainedBox(
        constraints: BoxConstraints.tight(
          Size(250, 50),
        ),
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
      ConstrainedBox(
        constraints: BoxConstraints.tight(
          Size(250, 50),
        ),
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
