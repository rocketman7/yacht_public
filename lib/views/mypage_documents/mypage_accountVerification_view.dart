import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../view_models/mypage_accountVerification_view_model.dart';
import '../loading_view.dart';
import '../constants/size.dart';

class MypageAccountVerificationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypageAccountVerificationViewModel>.reactive(
        viewModelBuilder: () => MypageAccountVerificationViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  '계좌정보',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                elevation: 0,
              ),
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? LoadingView()
                      : SafeArea(
                          child: Padding(
                          padding:
                              const EdgeInsets.only(left: 18, right: 18, top: 3
                                  // vertical: 18,
                                  ),
                          child: Column(
                            children: [
                              model.user.accNumber == null
                                  ? forNotVerificationUser(model)
                                  : forVerificationUser(model)
                            ],
                          ),
                        )));
        });
  }

  Widget forNotVerificationUser(MypageAccountVerificationViewModel model) {
    return Column(
      children: [
        Container(
          width: deviceWidth,
          padding: EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFFFCA42),
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: Text(
            "⚠️ 증권계좌 인증이 완료되지 않았습니다.",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        model.visibleButton1
            ? FlatButton(
                onPressed: () {
                  model.visibleButton1 = false;
                  model.notifyListeners();
                },
                child: Text(
                  '증권계좌 인증 진행하기',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                color: Color(0xFF1EC8CF),
                height: 56,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)))
            : verificationProcess(model),
        SizedBox(
          height: 100,
        ),
        RaisedButton(
          child: Text('계좌 소유주 확인하기 임시 버튼'),
          onPressed: () {
            model.accOwnerVerificationRequest();
          },
        ),
        Text('${model.accOwnerResp[0]}'),
        Text('${model.accOwnerResp[1]}'),
      ],
    );
  }

  Widget verificationProcess(MypageAccountVerificationViewModel model) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '은행',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
            !model.visibleBankList
                ? IconButton(
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: () {
                      model.visibleBankList = true;
                      model.notifyListeners();
                    })
                : IconButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
          ],
        ),
        model.visibleBankList ? bankList(model) : Container()
      ],
    );
  }

  Widget bankList(MypageAccountVerificationViewModel model) {
    return Container(
      height: deviceHeight / 3,
      child: ListView(
        children: [Text('은행목록들')],
      ),
    );
  }

  Widget forVerificationUser(MypageAccountVerificationViewModel model) {
    return Column(
      children: [
        Container(
          width: deviceWidth,
          padding: EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: Color(0xFF1EC8CF),
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: Text(
            "☑️ 증권계좌 인증이 완료되었습니다!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Row(
          children: [
            Text(
              '은행',
              style: TextStyle(fontSize: 16),
            ),
            Spacer(),
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
