import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import '../../view_models/mypage_friendsCodeInsert_view_model.dart';

class MypageFriendsCodeInsertView extends StatefulWidget {
  @override
  _MypageFriendsCodeInsertViewState createState() =>
      _MypageFriendsCodeInsertViewState();
}

class _MypageFriendsCodeInsertViewState
    extends State<MypageFriendsCodeInsertView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _friendsCodeController = TextEditingController();
  int _codeLength = 0;
  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    myFocusNode.requestFocus();
  }

  @override
  void dispose() {
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypageFriendsCodeInsertViewModel>.reactive(
      viewModelBuilder: () => MypageFriendsCodeInsertViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              '친구의 추천코드 입력하기',
              style: TextStyle(fontSize: 20, fontFamily: 'AppleSDB'),
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
                        child: Column(
                          children: [
                            SizedBox(
                              height: 32,
                            ),
                            model.didInserted
                                ? Text('친구 추천을\n완료하였습니다!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 32, fontFamily: 'AppleSDB'))
                                : Text(
                                    '친구의 추천코드를\n입력해주세요!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 32, fontFamily: 'AppleSDB'),
                                  ),
                            model.didInserted
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, left: 8, right: 8),
                                    child: Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100.0)),
                                          color: Color(0xFFFFD601),
                                          border: Border.all(
                                              color: Colors.black, width: 4)),
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${model.insertedCode}',
                                            style: TextStyle(
                                                fontSize: 28,
                                                fontFamily: 'AppleSDB'),
                                          ),
                                        ],
                                      )),
                                    ),
                                  )
                                : TextFormField(
                                    focusNode: myFocusNode,
                                    onChanged: (text) {
                                      setState(() {
                                        _codeLength = text.length;
                                      });
                                    },
                                    textAlign: TextAlign.left,
                                    controller: _friendsCodeController,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontFamily: 'DmSans',
                                      letterSpacing: -1.0,
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
                                      hintText: '친구의 추천코드 입력',
                                      hintStyle: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            model.didInserted
                                ? Container()
                                : FlatButton(
                                    onPressed: () async {
                                      if (_codeLength == 6) {
                                        model.friedsCodeGgook(
                                            _friendsCodeController.text);
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
                                    color: (_codeLength == 6)
                                        ? Color(0xFF1EC8CF)
                                        : Color(0xFFB2B7BE),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              model.errMsg,
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xFFC5C5C7)),
                            ),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
