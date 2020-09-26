import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../../view_models/mypage_friendsCode_view_model.dart';
import '../loading_view.dart';

class MypageFriendsCodeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypageFriendsCodeViewModel>.reactive(
      viewModelBuilder: () => MypageFriendsCodeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '친구에게 추천하기',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
          ),
          body: model.hasError
              ? Container(
                  child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                )
              : model.isBusy
                  // ? LoadingView()
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
                              height: 32,
                            ),
                            Text(
                              '추천하고\n꾸욱 받아가세요.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                            Padding(
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '나의 추천인 코드',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      '${model.user.friendsCode}',
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: '${model.user.friendsCode}'));
                                      },
                                      child: Text(
                                        '복사하기',
                                        style: TextStyle(
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Text(
                                  '추천인 코드 입력하기',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Spacer(),
                                Text('>')
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
                                  '카카오톡 추천 코드 공유하기',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Spacer(),
                                Text('>')
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              height: 1,
                              color: Color(0xFFE3E3E3),
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
