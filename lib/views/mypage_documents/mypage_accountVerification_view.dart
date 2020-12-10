import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

import '../../view_models/mypage_accountVerification_view_model.dart';
import '../constants/size.dart';

// 텍스트 입력 시 formkey 를 위해 얘만 stateful widget.
class MypageAccountVerificationView extends StatefulWidget {
  @override
  _MypageAccountVerificationViewState createState() =>
      _MypageAccountVerificationViewState();
}

class _MypageAccountVerificationViewState
    extends State<MypageAccountVerificationView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accNumberController = TextEditingController();
  final TextEditingController _accNameController = TextEditingController();
  final TextEditingController _authNumController = TextEditingController();
  FocusNode myFocusNode;
  FocusNode myFocusNode2;
  FocusNode myFocusNode3;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNode3 = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    myFocusNode2.dispose();
    myFocusNode3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypageAccountVerificationViewModel>.reactive(
        viewModelBuilder: () => MypageAccountVerificationViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  '계좌 정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                elevation: 0,
              ),
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? Container()
                      : Form(
                          key: _formKey,
                          child: SafeArea(
                              child: Column(
                            children: [
                              model.user.accNumber == null
                                  ? Container(
                                      width: double.infinity,
                                      color: Color(0xFFFFCA42),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 16,
                                              child: SvgPicture.asset(
                                                'assets/icons/notification.svg',
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              '증권계좌 인증이 완료되지 않았습니다.',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ))
                                  : Container(
                                      width: double.infinity,
                                      color: Color(0xFF1EC8CF),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 16,
                                              child: SvgPicture.asset(
                                                'assets/icons/check.svg',
                                                color: Color(0xFFFFFFFF),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 3,
                                            ),
                                            Text(
                                              '증권계좌 인증이 완료되었습니다!',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      )),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                ),
                                child: Column(
                                  children: [
                                    model.user.accNumber == null
                                        ? forNotVerificationUser(model)
                                        : forVerificationUser(model)
                                  ],
                                ),
                              ),
                            ],
                          )),
                        ));
        });
  }

  Widget forNotVerificationUser(MypageAccountVerificationViewModel model) {
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        model.visibleButton1
            ? Container(
                height: 56,
                width: double.infinity,
                child: RaisedButton(
                    onPressed: () {
                      model.visibleButton1 = false;
                      model.visibleBankList = true;
                      model.visibleButton2 = true;
                      model.notifyListeners();
                    },
                    child: Text(
                      '증권계좌 인증 진행하기',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    color: Color(0xFF1EC8CF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              )
            : verificationProcess(model),
        model.visibleButton1
            ? Text('은행연계계좌는 계좌 인증이 불가능하며, 계좌 인증 서비스를 제공하지 못하는 증권사가 존재할 수 있습니다.',
                style: TextStyle(fontSize: 12, color: Color(0xFFC5C5C7)))
            : Container(),
        model.visibleButton1 ? Container() : accNumberInsertProcess(model),
        model.visibleButton1 ? Container() : accNameInsertProcess(model),
        model.visibleButton2
            ? Container(
                width: deviceWidth,
                height: 40,
                child: RaisedButton(
                  color:
                      model.ableButton2 ? Color(0xFF1EC8CF) : Color(0xFFB2B7BE),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  onPressed: () async {
                    if (model.ableButton2) {
                      if (_accNameController.text != '' &&
                          _accNumberController.text != '' &&
                          model.secName != '') {
                        model.accNumber = _accNumberController.text;
                        model.accName = _accNameController.text;

                        model.ableButton2 = false;
                        model.ableBankListButton = false;

                        model.notifyListeners();

                        String result = await model.accVerificationRequest();

                        if (result == 'success') {
                          model.visibleButton2 = false;
                          model.visibleAuthNumProcess = true;

                          model.accVerificationFailMsg = '';

                          // 이제 위에 적은 값들 수정 안되게
                          model.accNameInsertProcess = true;
                          model.accNumberInsertProcess = true;
                          // model.ableBankListButton = false;

                          myFocusNode3.requestFocus();
                        } else {
                          model.accVerificationFailMsg = result;
                          model.ableBankListButton = true;
                        }

                        model.ableButton2 = true;
                        model.notifyListeners();
                      } else {
                        model.accVerificationFailMsg = '값들을 모두 입력하여주세요!';

                        model.notifyListeners();
                      }
                    } else {
                      return null;
                    }
                  },
                  child: Text(
                    model.ableButton2 ? '계좌 인증 코드 전송하기' : '진행 중',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ))
            : Container(),
        SizedBox(
          height: 8,
        ),
        Text(
          '${model.accVerificationFailMsg}',
          style: TextStyle(color: Color(0xFFC5C5C7)),
        ),
        model.visibleAuthNumProcess ? authNumProcess(model) : Container()
      ],
    );
  }

  Widget verificationProcess(MypageAccountVerificationViewModel model) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '증권사',
              style: TextStyle(fontSize: 16, letterSpacing: -1),
            ),
            Spacer(),
            model.selectSecLogo != 100
                ? Image.asset(
                    '${model.getBankLogoList().values.toList()[model.selectSecLogo]}',
                    width: 20,
                    height: 20)
                : Container(),
            SizedBox(
              width: 5,
            ),
            Text(
              '${model.secName}',
              style: TextStyle(fontSize: 16),
            ),
            model.ableBankListButton
                ? (!model.visibleBankList
                    ? IconButton(
                        icon: Icon(Icons.keyboard_arrow_down),
                        onPressed: () {
                          model.visibleBankList = true;
                          model.secName = '';
                          model.selectSecLogo = 100;
                          myFocusNode.unfocus();
                          model.notifyListeners();
                        })
                    : IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.transparent,
                        ),
                        onPressed: null,
                      ))
                : IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.transparent,
                    ),
                    onPressed: null),
          ],
        ),
        model.visibleBankList ? bankList(model) : Container()
      ],
    );
  }

  Widget bankList(MypageAccountVerificationViewModel model) {
    return Container(
      height: deviceHeight / 3,
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 6,
        children: List.generate(model.getBankListLength(), (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                model.secName = model.getBankList().keys.toList()[index];
                model.visibleBankList = false;
                model.selectSecLogo = index;
                myFocusNode.requestFocus();
                model.notifyListeners();
              },
              child: Row(
                children: [
                  Image.asset(
                      '${model.getBankLogoList().values.toList()[index]}'),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${model.getBankList().keys.toList()[index]}',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget accNumberInsertProcess(MypageAccountVerificationViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: Color(0xFFE3E3E3),
        ),
        Row(
          children: [
            Text(
              '계좌번호',
              style: TextStyle(fontSize: 16, letterSpacing: -1),
            ),
            Expanded(
              child: TextField(
                readOnly: model.accNumberInsertProcess,
                focusNode: myFocusNode,
                textAlign: TextAlign.right,
                controller: _accNumberController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'DM Sans',
                  // letterSpacing: 2.0,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF2F2F2),
                      width: 0.0,
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  alignLabelWithHint: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF2F2F2),
                      width: 0.0,
                    ),
                  ),
                  filled: false,
                  // hintText: "계좌번호",
                  // hintStyle: TextStyle(
                  //   fontSize: 12,
                  // ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // 쓸데없는 영역이지만, 사용자가 텍스트필드 오른쪽을 클릭해도 포커스되도록
                myFocusNode.requestFocus();
              },
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.transparent,
                ),
                onPressed: null,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget accNameInsertProcess(MypageAccountVerificationViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: Color(0xFFE3E3E3),
        ),
        Row(
          children: [
            Text(
              '예금주',
              style: TextStyle(fontSize: 16, letterSpacing: -1),
            ),
            // Spacer(),
            Expanded(
              // width: 200,
              child: TextField(
                readOnly: model.accNameInsertProcess,
                focusNode: myFocusNode2,
                textAlign: TextAlign.right,
                controller: _accNameController,
                style: TextStyle(
                  fontSize: 16,
                  // fontFamily: 'DM Sans',
                  // letterSpacing: 2.0,
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF2F2F2),
                      width: 0.0,
                    ),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  alignLabelWithHint: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFF2F2F2),
                      width: 0.0,
                    ),
                  ),
                  filled: false,
                  // hintText: "예금주 이름",
                  // hintStyle: TextStyle(fontSize: 16, letterSpacing: -1),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // 쓸데없는 영역이지만, 사용자가 텍스트필드 오른쪽을 클릭해도 포커스되도록
                myFocusNode2.requestFocus();
              },
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.transparent,
                ),
                onPressed: null,
              ),
            )
          ],
        ),
        Container(
          height: 1,
          color: Color(0xFFE3E3E3),
        ),
      ],
    );
  }

  Widget authNumProcess(MypageAccountVerificationViewModel model) {
    return Column(
      children: [
        Text(
          '인증계좌로 1원을 입금하였습니다.\n입금 확인 후, 입금자명에 쓰인 숫자 네 자를 입력하여주세요!',
          style: TextStyle(color: Color(0xFFC5C5C7)),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  _authNumController.text = '';
                },
                child: TextField(
                  focusNode: myFocusNode3,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  textAlign: TextAlign.center,
                  controller: _authNumController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'DM Sans',
                    letterSpacing: 3.0,
                  ),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFF2F2F2),
                        width: 0.0,
                      ),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    alignLabelWithHint: true,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFFF2F2F2),
                        width: 0.0,
                      ),
                    ),
                    filled: false,
                    hintText: "____",
                    hintStyle: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
        RaisedButton(
          color: Color(0xFF1EC8CF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          onPressed: () async {
            model.verificationSuccess =
                await model.accVerification(_authNumController.text);
            FocusScope.of(context).unfocus();
            model.notifyListeners();
          },
          child: Text(
            '계좌 인증하기',
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
        model.verificationSuccess
            ? Container()
            : Text('${model.verificationFailMsg}')
      ],
    );
  }

  Widget forVerificationUser(MypageAccountVerificationViewModel model) {
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Row(
          children: [
            Text(
              '증권사',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Image.asset(
                '${model.getBankLogoList().values.toList()[model.selectSecLogo]}',
                width: 20,
                height: 20),
            SizedBox(
              width: 5,
            ),
            Text(
              '${model.user.secName}',
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          height: 1,
          color: Color(0xFFE3E3E3),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Text(
              '계좌번호',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Text(
              '${model.user.accNumber}',
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          height: 1,
          color: Color(0xFFE3E3E3),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Text(
              '예금주',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            Text(
              '${model.user.accName}',
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ],
    );
  }
}
