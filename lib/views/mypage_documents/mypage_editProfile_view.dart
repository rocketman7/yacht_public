import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../../view_models/mypage_editProfile_view_model.dart';
import '../widgets/avatar_widget.dart';

class MypageEditProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypageEditProfileViewModel>.reactive(
      viewModelBuilder: () => MypageEditProfileViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '회원정보 수정',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            elevation: 1,
          ),
          backgroundColor: Colors.white,
          body: model.hasError
              ? Container(
                  child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                )
              : model.isBusy
                  ? FlareActor(
                      'assets/images/Loading.flr',
                      animation: 'loading',
                    )
                  : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 16,
                            ),
                            Center(
                                child: avatarWidget(
                                    model.sharedPrefForAvatarImage,
                                    model.user.item)),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  model.setAvatarImage('avatar007');
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 83,
                                  height: 27,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(80.0)),
                                    color: Color(0xFFEFEFEF),
                                  ),
                                  child: Text(
                                    '사진 변경',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 48,
                            ),
                            Row(children: [
                              Text(
                                '활동 닉네임',
                                style: TextStyle(fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                model.user.userName,
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onPressed: null)
                            ]),
                            Container(
                              height: 1,
                              color: Color(0xFFE3E3E3),
                            ),
                            Row(children: [
                              Text(
                                '휴대폰 번호',
                                style: TextStyle(fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                model.user.phoneNumber.toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onPressed: null)
                            ]),
                            Container(
                              height: 1,
                              color: Color(0xFFE3E3E3),
                            ),
                            Row(children: [
                              Text(
                                '이메일',
                                style: TextStyle(fontSize: 16),
                              ),
                              Spacer(),
                              Text(
                                model.user.email,
                                style: TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onPressed: null)
                            ]),
                            Container(
                              height: 1,
                              color: Color(0xFFE3E3E3),
                            ),
                            Row(children: [
                              Text(
                                '비밀번호',
                                style: TextStyle(fontSize: 16),
                              ),
                              Spacer(),
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onPressed: null)
                            ]),
                            Container(
                              height: 1,
                              color: Color(0xFFE3E3E3),
                            ),
                            Row(children: [
                              Text(
                                '관심종목 설정',
                                style: TextStyle(fontSize: 16),
                              ),
                              Spacer(),
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  ),
                                  onPressed: null)
                            ]),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
