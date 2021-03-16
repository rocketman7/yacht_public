import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:kakao_flutter_sdk/link.dart';
import 'package:yachtOne/services/mixpanel_service.dart';

import '../../locator.dart';
import '../../view_models/mypage_friendsCode_view_model.dart';

class MypageFriendsCodeView extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  // void shareMyCode() async {
  //   try {
  //     var template = _getTemplate();
  //     var uri = await LinkClient.instance.defaultWithTalk(template);
  //     await LinkClient.instance.launchKakaoTalk(uri);
  //   } catch (error) {
  //     print(error.toString());
  //   }
  // }
  void shareMyCode(String friendsCode) async {
    try {
      var uri = await LinkClient.instance
          .customWithTalk(42121, templateArgs: {'key': friendsCode});
      await LinkClient.instance.launchKakaoTalk(uri);
    } catch (e) {
      print(e.toString());
    }
  }

  // DefaultTemplate _getTemplate() {
  //   String title = "꾸욱 - 주식예측 퀴즈앱";
  //   Uri imageUrl = Uri.parse(
  //       "http://mud-kage.kakao.co.kr/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png");
  //   Link link = Link(mobileWebUrl: Uri.parse("https://team-yacht.com"));
  //   Content content = Content(
  //     title,
  //     imageUrl,
  //     link,
  //   );
  //   FeedTemplate template = FeedTemplate(content,
  //   // buttons: [
  //   //   Button(
  //   //       "구글플레이에서 다운 받기",
  //   //       Link(
  //   //           webUrl: Uri.parse(
  //   //               "https://play.google.com/store/apps/details?id=com.team_yacht.ggook"))),
  //   //   Button(
  //   //       "앱스토어에서 다운 받기",
  //   //       Link(
  //   //           webUrl: Uri.parse(
  //   //               "https://apps.apple.com/kr/app/%EA%BE%B8%EC%9A%B1-%EC%A3%BC%EC%8B%9D%EC%98%88%EC%B8%A1-%ED%80%B4%EC%A6%88%EC%95%B1/id1536611320"))),
  //   // ]
  //   );
  //   return template;
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypageFriendsCodeViewModel>.reactive(
      viewModelBuilder: () => MypageFriendsCodeViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              '친구에게 추천하기',
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
                            Text(
                              '추천하고\n꾸욱 받아가세요.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 32, fontFamily: 'AppleSDB'),
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
                                      style: TextStyle(
                                          fontSize: 12, fontFamily: 'AppleSDL'),
                                    ),
                                    Text(
                                      '${model.user.friendsCode}',
                                      style: TextStyle(
                                          fontSize: 28, fontFamily: 'AppleSDB'),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: '${model.user.friendsCode}'));
                                        scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                                duration: Duration(seconds: 1),
                                                content: Text(
                                                  "나의 추천인 코드가 복사되었습니다.",
                                                  style: TextStyle(
                                                      fontFamily: 'AppleSDM'),
                                                )));
                                      },
                                      child: Text(
                                        '복사하기',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'AppleSDL',
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Text('친구를 초대하면 꾸욱 아이템 5개를 드립니다.',
                                style: TextStyle(
                                    fontSize: 16, fontFamily: 'AppleSDM')),
                            Spacer(),
                            Container(
                              height: 1,
                              color: Color(0xFFE3E3E3),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                _mixpanelService.mixpanel
                                    .track('Share with Kakao');
                                bool installed = await isKakaoTalkInstalled();
                                // print(installed);
                                if (installed)
                                  shareMyCode(model.user.friendsCode);
                                else {
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text(
                                            "카카오톡이 설치되어있지 않습니다.",
                                            style: TextStyle(
                                                fontFamily: 'AppleSDM'),
                                          )));
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '카카오톡으로 공유하기',
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: 'AppleSDM'),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                  )
                                ],
                              ),
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
