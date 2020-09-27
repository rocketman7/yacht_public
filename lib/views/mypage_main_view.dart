import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../view_models/mypage_main_view_model.dart';

import 'constants/size.dart';
import 'widgets/avatar_widget.dart';

import 'package:blobs/blobs.dart';

class MypageMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MypageMainViewModel>.reactive(
        viewModelBuilder: () => MypageMainViewModel(),
        builder: (context, model, child) {
          return Scaffold(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          child: Column(
                            children: [
                              mypageMainTopBar(model),
                              Expanded(
                                child: ListView(
                                  children: [
                                    mypageMainAccPref(model),
                                    mypageMainAppPref(model),
                                    mypageMainCSCenter(model),
                                    mypageMainTermsOfUse(model),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            // bottomNavigationBar: bottomNavigationBar(context)
          );
        });
  }

  Widget mypageMainTopBar(MypageMainViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        child: Row(
          children: [
            Container(
              height: 72,
              width: deviceWidth - 36 - 72,
              child: Stack(
                children: [
                  model.user.accNumber == null
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xFFFFCA42),
                              borderRadius: BorderRadius.circular(
                                30,
                              )),
                          child: Text(
                            "⚠️증권계좌 미인증회원",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xFF1EC8CF),
                              borderRadius: BorderRadius.circular(
                                30,
                              )),
                          child: Text(
                            "☑️증권계좌 인증회원",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                  Positioned(
                    top: 10,
                    child: Text(
                      model.user.userName,
                      style: TextStyle(
                          fontSize: 48,
                          fontFamily: 'DmSans',
                          fontWeight: FontWeight.w900),
                    ),
                  )
                ],
              ),
            ),
            avatarWidget(model.user.avatarImage, model.user.item)
          ],
        ),
      ),
    );
  }

  Widget makeMypageMainComponent(
      MypageMainViewModel model, String title, String navigateTo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (navigateTo != null) model.navigateToMypageToDown(navigateTo);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ),
        ),
        Container(
          height: 1,
          color: Color(0xFFE3E3E3),
        )
      ],
    );
  }

  Widget mypageMainAccPref(MypageMainViewModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 계정설정',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            color: Colors.black,
          ),
          makeMypageMainComponent(model, '회원정보 수정', 'mypage_editprofile'),
          makeMypageMainComponent(model, 'x내가 받은 상금 현황', null),
          makeMypageMainComponent(model, 'x내 활동', null),
          makeMypageMainComponent(model, '계좌 정보', 'mypage_accoutverification'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  model.logout();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(
                    '로그아웃',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Color(0xFFE3E3E3),
              )
            ],
          ),
          SizedBox(
            height: 42,
          )
        ],
      ),
    );
  }

  Widget mypageMainAppPref(MypageMainViewModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '앱 사용 설정',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            color: Colors.black,
          ),
          makeMypageMainComponent(model, '푸쉬알림 설정', 'mypage_pushalarmsetting'),
          makeMypageMainComponent(model, '친구에게 추천하기', 'mypage_friendscode'),
          SizedBox(
            height: 42,
          )
        ],
      ),
    );
  }

  Widget mypageMainCSCenter(MypageMainViewModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '고객 센터',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            color: Colors.black,
          ),
          makeMypageMainComponent(model, 'x1:1 문의내역', null),
          makeMypageMainComponent(model, 'x자주묻는 질문', null),
          makeMypageMainComponent(model, 'x공지사항', null),
          SizedBox(
            height: 42,
          )
        ],
      ),
    );
  }

  Widget mypageMainTermsOfUse(MypageMainViewModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '약관 및 정보',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            color: Colors.black,
          ),
          makeMypageMainComponent(model, '이용약관', 'mypage_termsofuse'),
          makeMypageMainComponent(model, '개인정보취급방침', 'mypage_privacypolicy'),
          makeMypageMainComponent(model, '사업자정보', 'mypage_businessinformation'),
          makeMypageMainComponent(model, '꾸욱 셀렉션 임시', 'mypage_tempggook'),
          SizedBox(
            height: 42,
          )
        ],
      ),
    );
  }
}

class MypageTempGGookView extends StatefulWidget {
  @override
  _MypageTempGGookViewState createState() => _MypageTempGGookViewState();
}

class _MypageTempGGookViewState extends State<MypageTempGGookView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '카카오와 네이버\n수익률 높은 종목을\n꾸욱해주세요.',
                  style: TextStyle(
                      fontSize: 32,
                      letterSpacing: -0.28,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Container(
                      height: 16,
                      width: 48,
                      child: Stack(
                        children: [
                          Container(
                            height: 16,
                            width: 16,
                            child: CircleAvatar(
                              maxRadius: 16,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage('assets/images/avatar.png'),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            child: Container(
                              height: 16,
                              width: 16,
                              child: CircleAvatar(
                                maxRadius: 16,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage('assets/images/avatar.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            child: Container(
                              height: 16,
                              width: 16,
                              child: CircleAvatar(
                                maxRadius: 16,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage('assets/images/avatar.png'),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 24,
                            child: Container(
                              height: 16,
                              width: 16,
                              child: CircleAvatar(
                                maxRadius: 16,
                                backgroundColor: Colors.transparent,
                                backgroundImage:
                                    AssetImage('assets/images/avatar.png'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '345명이 이 주제에 참여했습니다.',
                      style: TextStyle(fontSize: 16, letterSpacing: -0.28),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '네이버 전일가',
                      style: TextStyle(fontSize: 16, letterSpacing: -0.28),
                    ),
                    Text(
                      ' 322,450',
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: -0.28,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF3E3E)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '카카오 전일가',
                      style: TextStyle(fontSize: 16, letterSpacing: -0.28),
                    ),
                    Text(
                      ' 389,000',
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: -0.28,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3485FF)),
                    ),
                  ],
                )
              ],
            ),
          )),
          //애니메이션이 전체화면을 덮을 수도 있으니 여기에서 관리해야할듯?
          Positioned(
            left: 50,
            top: 400,
            child: Stack(
              children: [
                Blob.animatedFromID(
                    size: 200,
                    id: [
                      '10-7-848634',
                      '10-7-863638',
                      '10-7-63404',
                      '10-7-424041'
                    ],
                    loop: true,
                    duration: Duration(milliseconds: 1000)),
                Blob.animatedFromID(
                    size: 180,
                    id: [
                      '10-7-848634',
                      '10-7-863638',
                      '10-7-63404',
                      '10-7-424041'
                    ],
                    loop: true,
                    duration: Duration(milliseconds: 1000)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
