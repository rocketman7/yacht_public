import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/register_view_model.dart';

class RegisterView extends StatelessWidget {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  // inputFormState 관리
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
          backgroundColor: Colors.blueGrey,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_inputForm(model)],
            ),
          )),
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
              controller: _userNameController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF79D0E5).withOpacity(.41),
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
            height: 12,
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tight(
              Size(250, 50),
            ),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF79D0E5).withOpacity(.41),
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
            height: 2,
          ),
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
                  fillColor: Color(0xFF79D0E5).withOpacity(.41),
                  labelText: "Password",
                  labelStyle: TextStyle(fontSize: 11),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  )),
            ),
          ),
          SizedBox(
            height: 2,
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
                  fillColor: Color(0xFF79D0E5).withOpacity(.41),
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(fontSize: 11),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  )),
            ),
          ),
          SizedBox(height: 4),
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
              color: Color(0xFF09C3CF).withOpacity(.56),
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
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
