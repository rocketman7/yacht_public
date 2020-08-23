import 'package:flutter/material.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:stacked/stacked.dart';

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
  @override
  Widget build(BuildContext context) {
    print("phoneAuthView rebuilt");
    return ViewModelBuilder<PhoneAuthViewModel>.reactive(
      viewModelBuilder: () => PhoneAuthViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              color: Colors.amber[100],
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 300,
                      child: TextFormField(
                        // 유저 네임 입력창
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        // validator: ((value) {
                        //   if (model.checkUserNameDuplicate(value) == true) {
                        //     return "이미 존재하는 닉네임입니다";
                        //   }
                        //   return null;
                        // }),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFABD8E3),
                          labelText: "핸드폰 번호",
                          labelStyle: TextStyle(fontSize: 11),
                          // border 둥글게 하고 inputform 밑줄 및 테두리 없앰
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    onPressed: () async {
                      print(_phoneNumberController.text.trim());
                      model.phoneAuth(
                          _phoneNumberController.text.trim(), context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.blue,
                      width: 100,
                      height: 50,
                      child: Text(
                        "인증번호 받기",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
