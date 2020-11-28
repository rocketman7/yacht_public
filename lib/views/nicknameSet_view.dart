import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';

import '../locator.dart';
import '../view_models/nicknameSet_viewmodel.dart';

class NicknameSetView extends StatefulWidget {
  final bool isMandatory;

  NicknameSetView(this.isMandatory);
  @override
  _NicknameSetViewState createState() => _NicknameSetViewState();
}

class _NicknameSetViewState extends State<NicknameSetView> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  int _nickLength = 0;

  @override
  Widget build(BuildContext context) {
    bool isMandatory = widget.isMandatory;
    print("Mandatory?" + isMandatory.toString());
    return ViewModelBuilder<NicknameSetViewModel>.reactive(
      viewModelBuilder: () => NicknameSetViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //     '닉네임 정하기',
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //   ),
          //   elevation: 1,
          // ),
          // backgroundColor: Colors.red,
          backgroundColor: Colors.white,
          body: model.hasError
              ? Container(
                  child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                )
              : model.isBusy
                  ? Container()
                  : isMandatory
                      ? buildMandatoryPage(model)
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
                                  Text(
                                    '닉네임 설정하기',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 100),
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

                                    validator: (value) {
                                      if (value.length > 8) {
                                        return "8자 이하 닉네임을 입력하세요";
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
                                      hintText: "닉네임",
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                      ),
                                      // border 둥글게 하고 inputform 밑줄 및 테두리 없앰
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  FlatButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate() &&
                                          (_nickLength > 0)) {
                                        model.checkUserNameDuplicateAndSet(
                                          _userNameController.text,
                                        );
                                      }
                                    },
                                    minWidth: double.infinity,
                                    height: 60,
                                    child: model.checking
                                        ? CircularProgressIndicator()
                                        : Text(
                                            "완료",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                    color: (_nickLength > 0)
                                        ? Color(0xFF1EC8CF)
                                        : Color(0xFFB2B7BE),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
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

  WillPopScope buildMandatoryPage(NicknameSetViewModel model) {
    return WillPopScope(
      onWillPop: () async {
        _navigatorKey.currentState.maybePop();
        return false;
      },
      child: SafeArea(
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
                Text(
                  '닉네임 설정하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 100),
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

                  validator: (value) {
                    if (value.length > 8) {
                      return "8자 이하 닉네임을 입력하세요";
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
                FlatButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate() && (_nickLength > 0)) {
                      model.checkUserNameDuplicateAndSet(
                        _userNameController.text,
                      );
                    }
                  },
                  minWidth: double.infinity,
                  height: 60,
                  child: model.checking
                      ? CircularProgressIndicator()
                      : Text(
                          "다음",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                  color:
                      (_nickLength > 0) ? Color(0xFF1EC8CF) : Color(0xFFB2B7BE),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
