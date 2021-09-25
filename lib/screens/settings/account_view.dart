import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'account_view_model.dart';

// 텍스트 입력 시 formkey 를 위해 얘만 stateful widget.
class AccountView extends StatefulWidget {
  @override
  _AccountViewState createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accNumberController = TextEditingController();
  final TextEditingController _accNameController = TextEditingController();
  final TextEditingController _authNumController1 = TextEditingController();
  final TextEditingController _authNumController2 = TextEditingController();
  final TextEditingController _authNumController3 = TextEditingController();
  final TextEditingController _authNumController4 = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusNode2 = FocusNode();
  FocusNode myFocusNode3 = FocusNode(); // 3~6 은 인증코드 네자리
  FocusNode myFocusNode4 = FocusNode();
  FocusNode myFocusNode5 = FocusNode();
  FocusNode myFocusNode6 = FocusNode();

  final AccountViewModel _accountViewModel = Get.put(AccountViewModel());

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNode3 = FocusNode();
    myFocusNode4 = FocusNode();
    myFocusNode5 = FocusNode();
    myFocusNode6 = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    myFocusNode2.dispose();
    myFocusNode3.dispose();
    myFocusNode4.dispose();
    myFocusNode5.dispose();
    myFocusNode6.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: primaryAppBar('계좌 정보'),
      body: Form(
        key: _formKey,
        child: SafeArea(child: GetBuilder<AccountViewModel>(
          builder: (controller) {
            return ListView(
              children: [
                userModelRx.value!.account['accNumber'] == null
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          controller.verificationFlowStart = true;
                          controller.selectBankFlow = true; // 첫번째는 바로 뱅크리스트부터 고르도록 유도
                          controller.update();
                        },
                        child: Container(
                            width: double.infinity,
                            color: buttonNormal,
                            child: Padding(
                              padding: EdgeInsets.only(left: 14.w, top: 8.w, bottom: 8.w, right: 14.w),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/account_not.png',
                                    width: 18.w,
                                    height: 18.w,
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Text('증권계좌 미인증 상태네요. 여기를 눌러 인증해주세요.',
                                      style: accountWarning.copyWith(color: yachtViolet)),
                                  Spacer(),
                                  Image.asset(
                                    'assets/icons/verification_arrow.png',
                                    width: 8.w,
                                    height: 12.w,
                                  ),
                                ],
                              ),
                            )),
                      )
                    : Container(
                        width: double.infinity,
                        color: buttonNormal,
                        child: Padding(
                          padding: EdgeInsets.only(left: 14.w, top: 8.w, bottom: 8.w, right: 14.w),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/account_done.png',
                                width: 18.w,
                                height: 18.w,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                '인증된 증권계좌네요!',
                                style: accountWarning,
                              ),
                            ],
                          ),
                        )),
                Padding(
                  padding: EdgeInsets.only(
                    left: 14.w,
                    right: 14.w,
                  ),
                  child: Column(
                    children: [
                      userModelRx.value!.account['accNumber'] == null
                          ? controller.visibleAuthNumProcess
                              ? authNumProcess()
                              : forNotVerificationUser()
                          : forVerificationUser()
                      // authNumProcess()
                    ],
                  ),
                ),
              ],
            );
          },
        )),
      ),
    );
  }

  Widget authNumProcess() {
    return Column(
      children: [
        SizedBox(
          height: 18.w,
        ),
        Text(
          '인증하신 계좌로 1원을 입금하였습니다.\n입금 확인 후, 입금자명에 쓰인 숫자 네 자를 입력하여주세요!\n(요트OOOO 라고 써져 있을 거에요.)',
          style: accountWarning.copyWith(color: yachtBlack),
        ),
        SizedBox(
          height: 36.w,
        ),
        Row(
          children: [
            Spacer(),
            Container(
              width: 40.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: yachtViolet,
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Center(
                child: TextFormField(
                  onChanged: (value) {
                    if (value.length == 1 && value.isNum) myFocusNode4.requestFocus();
                    // 다 채워졌으면
                    if (_authNumController1.text != '' &&
                        _authNumController2.text != '' &&
                        _authNumController3.text != '' &&
                        _authNumController4.text != '') {
                      _accountViewModel.ableButton3 = true;
                      _accountViewModel.update();
                    } else {
                      _accountViewModel.ableButton3 = false;
                      _accountViewModel.update();
                    }
                  },
                  controller: _authNumController1,
                  focusNode: myFocusNode3,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  style: authNumText,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0.w),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Container(
              width: 40.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: yachtViolet,
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Center(
                child: TextFormField(
                  onChanged: (value) {
                    if (value.length == 1 && value.isNum)
                      myFocusNode5.requestFocus();
                    else if (value.length == 0) myFocusNode3.requestFocus();
                    // 다 채워졌으면
                    if (_authNumController1.text != '' &&
                        _authNumController2.text != '' &&
                        _authNumController3.text != '' &&
                        _authNumController4.text != '') {
                      _accountViewModel.ableButton3 = true;
                      _accountViewModel.update();
                    } else {
                      _accountViewModel.ableButton3 = false;
                      _accountViewModel.update();
                    }
                  },
                  controller: _authNumController2,
                  focusNode: myFocusNode4,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  style: authNumText,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0.w),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Container(
              width: 40.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: yachtViolet,
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Center(
                child: TextFormField(
                  onChanged: (value) {
                    if (value.length == 1 && value.isNum)
                      myFocusNode6.requestFocus();
                    else if (value.length == 0) myFocusNode4.requestFocus();
                    // 다 채워졌으면
                    if (_authNumController1.text != '' &&
                        _authNumController2.text != '' &&
                        _authNumController3.text != '' &&
                        _authNumController4.text != '') {
                      _accountViewModel.ableButton3 = true;
                      _accountViewModel.update();
                    } else {
                      _accountViewModel.ableButton3 = false;
                      _accountViewModel.update();
                    }
                  },
                  controller: _authNumController3,
                  focusNode: myFocusNode5,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  style: authNumText,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0.w),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
            Container(
              width: 40.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: yachtViolet,
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Center(
                child: TextFormField(
                  onChanged: (value) {
                    if (value.length == 0) myFocusNode5.requestFocus();
                    // 다 채워졌으면
                    if (_authNumController1.text != '' &&
                        _authNumController2.text != '' &&
                        _authNumController3.text != '' &&
                        _authNumController4.text != '') {
                      _accountViewModel.ableButton3 = true;
                      _accountViewModel.update();
                    } else {
                      _accountViewModel.ableButton3 = false;
                      _accountViewModel.update();
                    }
                  },
                  controller: _authNumController4,
                  focusNode: myFocusNode6,
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  style: authNumText,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(0.w),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 36.w,
        ),
        _accountViewModel.ableButton3
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  _accountViewModel.verificationSuccess = await _accountViewModel.accVerification(
                      _authNumController1.text +
                          _authNumController2.text +
                          _authNumController3.text +
                          _authNumController4.text);
                  FocusScope.of(context).unfocus();
                  _accountViewModel.update();
                },
                child: Container(
                  height: 50.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(70.0), color: yachtViolet),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      '입력 완료',
                      style: accountButtonText,
                    ),
                  ),
                ),
              )
            : Container(),
        _accountViewModel.verificationSuccess
            ? Container()
            : Text(
                '${_accountViewModel.verificationFailMsg}',
                style: accountWarning.copyWith(color: yachtViolet),
              )
      ],
    );
  }

  Widget forNotVerificationUser() {
    return _accountViewModel.verificationFlowStart
        ? Column(
            children: [
              SizedBox(
                height: correctHeight(18.w, 0.w, accountVerificationTitle.fontSize),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (_accountViewModel.ableBankListButton) {
                    _accountViewModel.selectBankFlow = true;
                    _accountViewModel.secName = '';
                    _accountViewModel.selectSecLogo = 100;
                    myFocusNode.unfocus();
                    _accountViewModel.update();
                  }
                },
                child: Row(
                  children: [
                    Text(
                      '증권사',
                      style: accountVerificationTitle,
                    ),
                    Spacer(),
                    _accountViewModel.selectSecLogo != 100
                        ? Image.asset(
                            '${_accountViewModel.getBankLogoList().values.toList()[_accountViewModel.selectSecLogo]}',
                            width: 17.w,
                            height: 17.w)
                        : Container(),
                    SizedBox(
                      width: 4.w,
                    ),
                    _accountViewModel.selectSecLogo != 100
                        ? Text(
                            '${_accountViewModel.secName}',
                            style: accountVerificationContent,
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: correctHeight(17.w, accountVerificationContent.fontSize, 0.w),
              ),
              _accountViewModel.selectBankFlow ? bankList() : Container(),
              Container(
                height: 1.w,
                color: yachtLine,
              ),
              accNumberInsertProcess(),
              accNameInsertProcess(),
              SizedBox(
                height: 18.w,
              ),
              _accountViewModel.visibleButton2
                  ? GestureDetector(
                      onTap: () async {
                        if (_accountViewModel.ableButton2) {
                          if (_accNameController.text != '' &&
                              _accNumberController.text != '' &&
                              _accountViewModel.secName != '') {
                            FocusScope.of(context).unfocus();
                            _accountViewModel.accNumber = _accNumberController.text;
                            _accountViewModel.accName = _accNameController.text;

                            _accountViewModel.ableButton2 = false;

                            // 이제 위에 적은 값들 수정 안되게
                            _accountViewModel.ableBankListButton = false;
                            _accountViewModel.accNameInsertProcess = true;
                            _accountViewModel.accNumberInsertProcess = true;

                            _accountViewModel.update();

                            String result = await _accountViewModel.accVerificationRequest();

                            if (result == 'success') {
                              _accountViewModel.visibleButton2 = false;
                              _accountViewModel.visibleAuthNumProcess = true;

                              _accountViewModel.accVerificationFailMsg = '';

                              myFocusNode3.requestFocus();
                            } else {
                              _accountViewModel.accVerificationFailMsg = result;
                              _accountViewModel.ableBankListButton = true;
                              _accountViewModel.accNameInsertProcess = false;
                              _accountViewModel.accNumberInsertProcess = false;
                            }

                            _accountViewModel.ableButton2 = true;
                            _accountViewModel.update();
                          } else {
                            _accountViewModel.accVerificationFailMsg = '값들을 모두 입력하여주세요!';

                            _accountViewModel.update();
                          }
                        } else {
                          return null;
                        }
                      },
                      child: Container(
                        height: 50.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70.0),
                            color: _accountViewModel.ableButton2 ? yachtViolet : buttonNormal),
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            _accountViewModel.ableButton2 ? '계좌 인증코드 전송하기' : '인증코드를 전송하고 있어요',
                            style: _accountViewModel.ableButton2
                                ? accountButtonText
                                : accountButtonText.copyWith(color: Color(0xFF6073B4)),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 8.w,
              ),
              Text(
                '${_accountViewModel.accVerificationFailMsg}',
                style: accountWarning.copyWith(color: yachtViolet),
              ),
            ],
          )
        : Container();
  }

  Widget bankList() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: SizeConfig.screenHeight / 3,
          decoration: primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow], color: homeModuleBoxBackgroundColor),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 6,
            children: List.generate(_accountViewModel.getBankListLength(), (index) {
              return Padding(
                padding: EdgeInsets.only(top: 4.w, bottom: 4.w, left: 8.w),
                child: GestureDetector(
                  onTap: () {
                    _accountViewModel.secName = _accountViewModel.getBankList().keys.toList()[index];
                    print(_accountViewModel.secName);
                    // _accountViewModel.visibleBankList = false;
                    _accountViewModel.selectBankFlow = false;
                    _accountViewModel.selectSecLogo = index;
                    myFocusNode.requestFocus();
                    _accountViewModel.update();
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset('${_accountViewModel.getBankLogoList().values.toList()[index]}',
                            width: 17.w, height: 17.w),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        '${_accountViewModel.getBankList().keys.toList()[index]}',
                        style: accountVerificationTitle,
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(
          height: 17.w,
        ),
      ],
    );
  }

  Widget accNumberInsertProcess() {
    return Column(
      children: [
        SizedBox(
          height: correctHeight(18.w, 0.w, accountVerificationTitle.fontSize),
        ),
        Row(
          children: [
            Text(
              '계좌번호',
              style: accountVerificationTitle,
            ),
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  if (_accNameController.text != '' && _accNumberController.text != '') {
                    _accountViewModel.visibleButton2 = true;
                  } else {
                    _accountViewModel.visibleButton2 = false;
                  }
                  _accountViewModel.update();
                },
                readOnly: _accountViewModel.accNumberInsertProcess,
                controller: _accNumberController,
                focusNode: myFocusNode,
                textAlignVertical: TextAlignVertical.bottom,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.phone,
                cursorColor: yachtViolet,
                style: accountVerificationTitle,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0.w),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: correctHeight(17.w, accountVerificationContent.fontSize, 0.w),
        ),
        Container(
          height: 1,
          color: yachtLine,
        ),
      ],
    );
  }

  Widget accNameInsertProcess() {
    return Column(
      children: [
        SizedBox(
          height: correctHeight(18.w, 0.w, accountVerificationTitle.fontSize),
        ),
        Row(
          children: [
            Text(
              '예금주',
              style: accountVerificationTitle,
            ),
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  if (_accNameController.text != '' && _accNumberController.text != '') {
                    _accountViewModel.visibleButton2 = true;
                  } else {
                    _accountViewModel.visibleButton2 = false;
                  }
                  _accountViewModel.update();
                },
                readOnly: _accountViewModel.accNameInsertProcess,
                controller: _accNameController,
                focusNode: myFocusNode2,
                textAlignVertical: TextAlignVertical.bottom,
                textAlign: TextAlign.right,
                style: accountVerificationTitle,
                cursorColor: yachtViolet,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(0.w),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: correctHeight(17.w, accountVerificationContent.fontSize, 0.w),
        ),
        Container(
          height: 1,
          color: yachtLine,
        ),
      ],
    );
  }

  Widget forVerificationUser() {
    return Column(
      children: [
        SizedBox(
          height: correctHeight(18.w, 0.w, accountVerificationTitle.fontSize),
        ),
        Row(
          children: [
            Text(
              '증권사',
              style: accountVerificationTitle,
            ),
            Spacer(),
            Image.asset('${_accountViewModel.getBankLogoList().values.toList()[_accountViewModel.selectSecLogo]}',
                width: 17.w, height: 17.w),
            SizedBox(
              width: 4.w,
            ),
            Text(
              '${userModelRx.value!.account['secName']}',
              style: accountVerificationContent,
            )
          ],
        ),
        SizedBox(
          height: correctHeight(17.w, accountVerificationContent.fontSize, 0.w),
        ),
        Container(
          height: 1.w,
          color: yachtLine,
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, accountVerificationTitle.fontSize),
        ),
        Row(
          children: [
            Text(
              '계좌번호',
              style: accountVerificationTitle,
            ),
            Spacer(),
            Text(
              '${userModelRx.value!.account['accNumber']}',
              style: accountVerificationContent,
            )
          ],
        ),
        SizedBox(
          height: correctHeight(17.w, accountVerificationContent.fontSize, 0.w),
        ),
        Container(
          height: 1,
          color: yachtLine,
        ),
        SizedBox(
          height: correctHeight(18.w, 0.w, accountVerificationTitle.fontSize),
        ),
        Row(
          children: [
            Text(
              '예금주',
              style: accountVerificationTitle,
            ),
            Spacer(),
            Text(
              '${userModelRx.value!.account['accName']}',
              style: accountVerificationContent,
            )
          ],
        ),
        SizedBox(
          height: correctHeight(17.w, accountVerificationContent.fontSize, 0.w),
        ),
        Container(
          height: 1,
          color: yachtLine,
        ),
      ],
    );
  }
}
