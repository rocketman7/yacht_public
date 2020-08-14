import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/register_view_model.dart';
import '../views/constants/size.dart';

class RegisterView extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  // inputFormState 관리
  // 회원가입 시 password 넣을 때 validate 해야 하기 때문에 FormKey 필요
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegisterViewModel>.nonReactive(
      viewModelBuilder: () => RegisterViewModel(),
      onModelReady: (model) => model,
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Color(0XFF051417),
            ),
            // 이걸로 column 전체 감싸줘야 키보드 열릴 때 화면 가변적으로 움직이게 됨
            SingleChildScrollView(
              // reverse를 true로 둬야 Email Textform 클릭했을 때 column 맨 아래까지 키보드 위로 올라감.
              reverse: true,
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 200,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "꾸  욱",
                      style: TextStyle(
                        fontFamily: 'NanumHandWriting',
                        fontSize: 70,
                        color: const Color(0xFFCFD8E4),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                  ),
                  // 아래 따로 위젯으로 만듬
                  _inputForm(model),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputForm(model) {
    // FormState를 사용할 inputForm들을 모두 Form 아래에 위치해서 key 지정 -> validator에 조건 지정
    // .currentState.validate() 으로 validate 여부 가릴 수 있음
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // TextFormField 크기 제한
          ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size(250, 50),
            ),
            child: TextFormField(
              // 유저 네임 입력창
              controller: _userNameController,
              keyboardType: TextInputType.emailAddress,
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
                if (value.length < 7) {
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
              if (_formKey.currentState.validate()) {
                model.register(
                  userName: _userNameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
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
              _navigationService.navigateTo('login');
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
