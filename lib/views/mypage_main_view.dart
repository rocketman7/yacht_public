import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import '../view_models/mypage_main_view_model.dart';

import 'constants/size.dart';
import 'widgets/avatar_widget.dart';

import 'package:blobs/blobs.dart';

import 'dart:ui';
import 'dart:math' as math;

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
                    ? Container()
                    : SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Column(
                            children: [
                              mypageMainTopBar(model),
                              Expanded(
                                child: ListView(
                                  children: [
                                    mypageMainAccPref(model),
                                    // mypageMainAppPref(model),
                                    mypageMainCSCenter(model),
                                    mypageMainTermsOfUse(model),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
              // height: 200,
              width: deviceWidth - 36 - 72,
              child: Column(
                children: [
                  model.user.accNumber == null
                      ? Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFCA42),
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  )),
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
                                    "증권계좌 미인증회원",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xFF1EC8CF),
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  )),
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
                                    "증권계좌 인증회원",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.user.userName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: model.user.userName.length > 8
                                  ? 32
                                  : model.user.userName.length > 6 ? 40 : 48,
                              fontFamily: 'DmSans',
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
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
          behavior: HitTestBehavior.opaque,
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
          SizedBox(
            height: 24,
          ),
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
          // makeMypageMainComponent(model, 'x내가 받은 상금 현황', null),
          // makeMypageMainComponent(model, 'x내 활동', null),
          makeMypageMainComponent(model, '계좌 정보', 'mypage_accoutverification'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  model.logout();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(
                    '더블 탭하여 로그아웃',
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
          makeMypageMainComponent(model, '1:1 문의', 'oneonone'),
          makeMypageMainComponent(model, '자주 묻는 질문', 'faq'),
          makeMypageMainComponent(model, '공지사항', 'notice'),
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
          makeMypageMainComponent(model, '', null),
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

class _MypageTempGGookViewState extends State<MypageTempGGookView>
    with TickerProviderStateMixin {
  // Animation<double> animation;
  // // AnimationController animationController;
  // AnimationController _animationController;
  // Animation animation;

  // BlobController blobCtrl;

  int x = 0;

  @override
  void initState() {
    super.initState();
    // animationController =
    //     AnimationController(vsync: this, duration: Duration(seconds: 3));
    // animation = Tween<double>(begin: 1.0, end: 3.0).animate(animationController)
    //   ..addListener(() {
    //     setState(() {});
    //   });
    // animationController.forward();
    //
    // _animationController =
    //     AnimationController(duration: Duration(seconds: 200), vsync: this);
    // animation =
    //     Tween<double>(begin: 1.0, end: 350.0).animate(_animationController);
    // _animationController.addListener(() {
    //   setState(() {});
    // });
    // _animationController.repeat();
  }

  @override
  void dispose() {
    // blobCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                ),
                GestureDetector(
                  child: Text('디버그'),
                  onTap: () {
                    // BlobData blobData = blobCtrl.change();
                    // print(blobData);
                    setState(() {
                      x += 10;
                    });
                  },
                ),
                GestureDetector(
                  child: Text('선택애니메이션'),
                  onTap: () {
                    // print(blobCtrl.change().size);
                    // animationController.forward();
                  },
                )
              ],
            ),
          )),
          //애니메이션이 전체화면을 덮을 수도 있으니 여기에서 관리해야할듯?
          Positioned(
            left: 50,
            top: 400,
            child: Container(
              width: 400,
              height: 400,
              child: Stack(
                children: [
                  Positioned(child: Test5Widget()),
                  TestWidget(),
                  Test3Widget(),
                  Positioned(
                      left: 10,
                      top: 10,
                      child: Test2Widget(
                        blobColor: Color(0xFFFFDE34),
                      )),
                ],
              ),
            ),
          ),

          // Positioned(
          //   left: 190,
          //   top: 600,
          //   child: Container(
          //     width: 400,
          //     height: 400,
          //     child: Stack(
          //       children: [
          //         Positioned(child: Test5Widget()),
          //         TestWidget(),
          //         Positioned(
          //             left: 10,
          //             top: 10,
          //             child: Test2Widget(
          //               blobColor: Color(0xFF8DFF34),
          //             )),
          //       ],
          //     ),
          //   ),
          // ),

          Positioned(
            left: 160,
            top: 200,
            child: ScaleBlobAnimation(),
          )
          // Transform.scale(
          //     scale: animation.value,
          //     child: Positioned(left: 100, top: 100, child: TestWidget())),
//           Positioned(left: 100, top: 100, child: TestWidget()),
//           Positioned(
//             left: 50,
//             top: 400,
//             child: Stack(
//               children: [
//                 // Transform.scale(
//                 //   scale: animation.value,
//                 //   child: Blob.fromID(id: ['10-7-848634'], size: 200),
//                 // )
// //
//                 Transform.scale(
//                   // scale: animation.value,
//                   scale: 1,
//                   child: Blob.animatedFromID(
//                       size: 200,
//                       id: [
//                         '10-7-848634',
//                         '10-7-863638',
//                         '10-7-63404',
//                         '10-7-424041',
//                         '10-7-88922'
//                       ],
//                       styles: BlobStyles(
//                         // color: Color(0xFFFFDE34).withOpacity(.5),
//                         color: Color(0xFF000000),
//                         // fillType: BlobFillType.stroke,
//                         // strokeWidth: 10,
//                       ),
//                       controller: blobCtrl,
//                       loop: true,
//                       duration: Duration(milliseconds: 1000)),
//                 ),
//                 // Positioned(
//                 //   top: 10,
//                 //   left: 10,
//                 //   child: Blob.animatedFromID(
//                 //       size: 180,
//                 //       id: [
//                 //         '10-7-88922',
//                 //         '10-7-848634',
//                 //         '10-7-863638',
//                 //         '10-7-63404',
//                 //         '10-7-424041',
//                 //       ],
//                 //       styles: BlobStyles(
//                 //         color: Color(0xFFFFDE34),
//                 //       ),
//                 //       controller: blobCtrl,
//                 //       loop: true,
//                 //       duration: Duration(milliseconds: 1000)),
//                 // ),
//                 // AnimatedBuilder(
//                 //     animation: animation,
//                 //     builder: (context, child) {
//                 //       return Positioned(
//                 //           left: 100,
//                 //           top: 100,
//                 //           child: Container(
//                 //             height: animation.value,
//                 //             width: animation.value,
//                 //             color: Colors.red,
//                 //           ));
//                 //     }),
//                 //
//                 // Column(
//                 //   mainAxisSize: MainAxisSize.min,
//                 //   children: [
//                 //     Container(
//                 //       child: Stack(
//                 //         alignment: Alignment.center,
//                 //         children: [
//                 //           Transform.rotate(
//                 //             angle: (animation.value * 0.6) * 360.0,
//                 //             child: Blob.fromID(
//                 //               size: 190,
//                 //               id: ['6-8-34659'],
//                 //               styles: BlobStyles(
//                 //                 color: Color(0xffff6b81).withOpacity(0.2),
//                 //                 fillType: BlobFillType.fill,
//                 //               ),
//                 //             ),
//                 //           ),
//                 //           Transform.rotate(
//                 //             angle: animation.value * 360.0,
//                 //             child: Blob.fromID(
//                 //               size: 200,
//                 //               id: ['6-8-6090'],
//                 //               styles: BlobStyles(
//                 //                 color: Color(0xffFC427B),
//                 //                 fillType: BlobFillType.stroke,
//                 //               ),
//                 //             ),
//                 //           ),
//                 //           Transform.rotate(
//                 //             angle: (animation.value * 0.4) * 360.0,
//                 //             child: Blob.fromID(
//                 //               size: 200,
//                 //               id: ['6-8-115566'],
//                 //               styles: BlobStyles(
//                 //                 color: Color(0xffB33771),
//                 //                 fillType: BlobFillType.stroke,
//                 //               ),
//                 //             ),
//                 //           ),
//                 //           Center(
//                 //               child: Text(
//                 //             "blobs",
//                 //             style: TextStyle(
//                 //               fontFamily: 'Ropa',
//                 //               fontSize: 30,
//                 //               color: Color(0xffc44569),
//                 //             ),
//                 //           )),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   ],
//                 // ),
//                 //
//                 // Positioned(
//                 //     top: 80,
//                 //     left: 60,
//                 //     child: AnimatedBuilder(
//                 //         animation: animation,
//                 //         builder: (context, child) {
//                 //           return Transform.translate(
//                 //               offset: Offset(0, animation.value),
//                 //               child: Text(
//                 //                 '카카오',
//                 //                 style: TextStyle(
//                 //                     fontSize: 28, fontWeight: FontWeight.bold),
//                 //               ));
//                 //         }))
//               ],
//             ),
//           )
        ],
      ),
    );
  }
}

class TestWidget extends StatefulWidget {
  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  BlobController blobCtrl;

  @override
  void dispose() {
    // blobCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Blob.animatedFromID(
        size: 200,
        id: [
          '10-7-848634',
          '10-7-863638',
          '10-7-63404',
          '10-7-424041',
          '10-7-88922'
        ],
        styles: BlobStyles(
          color: Color(0xFF000000),
        ),
        controller: blobCtrl,
        loop: true,
        duration: Duration(milliseconds: 2000));
  }
}

class Test2Widget extends StatefulWidget {
  final Color blobColor;

  const Test2Widget({Key key, this.blobColor}) : super(key: key);

  @override
  _Test2WidgetState createState() => _Test2WidgetState();
}

class _Test2WidgetState extends State<Test2Widget> {
  BlobController blobCtrl;

  @override
  void dispose() {
    // blobCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Blob.animatedFromID(
        size: 180,
        id: [
          '10-7-88922',
          '10-7-848634',
          '10-7-863638',
          '10-7-63404',
          '10-7-424041',
        ],
        styles: BlobStyles(
          color: widget.blobColor,
          // color: Color(0xFFFFDE34).withOpacity(.5),
        ),
        controller: blobCtrl,
        loop: true,
        duration: Duration(milliseconds: 2000));
  }
}

class Test3Widget extends StatefulWidget {
  @override
  _Test3WidgetState createState() => _Test3WidgetState();
}

class _Test3WidgetState extends State<Test3Widget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    animation =
        Tween<double>(begin: 0.0, end: 100.0).animate(_animationController);
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Transform.rotate(
    //   angle: (animation.value * 0.6) * 360.0,
    //   child: Container(
    //     width: 200,
    //     height: 200,
    //     decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    //   ),
    // );
    return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return CustomPaint(
              size: Size(200, 200),
              painter: PieChart(percentage: animation.value));
        });
  }
}

class PieChart extends CustomPainter {
  double percentage = 0;

  PieChart({this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    double radius = math.min(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, paint);

    double arcAngle = 2 * math.pi * (percentage / 100);

    paint..color = Colors.white;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, arcAngle, true, paint);
  }

  @override
  bool shouldRepaint(PieChart old) {
    return old.percentage != percentage;
  }
}

class Test4Widget extends StatefulWidget {
  @override
  _Test4WidgetState createState() => _Test4WidgetState();
}

class _Test4WidgetState extends State<Test4Widget> {
  BlobController blobCtrl;

  @override
  void dispose() {
    // blobCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Blob.animatedFromID(
        size: 220,
        id: [
          '10-7-863638',
          '10-7-63404',
          '10-7-424041',
          '10-7-88922',
          '10-7-848634',
        ],
        styles: BlobStyles(
          color: Color(0xFFFFFFFF),
        ),
        controller: blobCtrl,
        loop: true,
        duration: Duration(milliseconds: 2000));
  }
}

class Test5Widget extends StatefulWidget {
  @override
  _Test5WidgetState createState() => _Test5WidgetState();
}

class _Test5WidgetState extends State<Test5Widget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
    );
  }
}

class ScaleBlobAnimation extends StatefulWidget {
  @override
  _ScaleBlobAnimationState createState() => _ScaleBlobAnimationState();
}

class _ScaleBlobAnimationState extends State<ScaleBlobAnimation>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(seconds: 1500), vsync: this);
    animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return AnimatedBuilder(
    //     animation: animation,
    //     builder: (context, child) {
    //       return Transform.rotate(
    //         angle: (animation.value * 0.6) * 360.0,
    //         child: BlobAnimation(
    //           blobColor: Color(0xFF0E3F44),
    //           size: 200,
    //         ),
    //       );
    //     });
    return BlobAnimation(
      blobColor: Color(0xFF0E3F44),
      size: 200,
    );
  }
}

class BlobAnimation extends StatefulWidget {
  final Color blobColor;
  final double size;

  const BlobAnimation({Key key, this.blobColor, this.size}) : super(key: key);
  @override
  _BlobAnimationState createState() => _BlobAnimationState();
}

class _BlobAnimationState extends State<BlobAnimation>
    with TickerProviderStateMixin {
  BlobController blobCtrl;

  @override
  void initState() {
    super.initState();

    blobCtrl = BlobController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Blob.animatedFromID(
            size: 180,
            id: [
              '10-7-88922',
              '10-7-848634',
              '10-7-863638',
              '10-7-63404',
              '10-7-424041',
            ],
            styles: BlobStyles(
              color: widget.blobColor,
              // color: Color(0xFFFFDE34).withOpacity(.5),
            ),
            controller: blobCtrl,
            loop: true,
            duration: Duration(milliseconds: 2000)),
        FlatButton(
          onPressed: () {
            BlobData blobData = blobCtrl.change();
            print(blobData.size);
          },
          child: Text('dd'),
        )
      ],
    );
    //
    // return Container(
    //   height: widget.size,
    //   width: widget.size,
    //   color: widget.blobColor,
    // );
    //
    // return Column(
    //   children: [
    //     Blob.animatedRandom(
    //         // id: ['10-7-88922'],
    //         size: widget.size,
    //         controller: blobCtrl,
    //         styles: BlobStyles(color: Color(0xffc44569))),
    //     FlatButton(
    //       onPressed: () {
    //         BlobData blobData = blobCtrl.change();
    //         print(blobData.edges);
    //       },
    //       child: Text('dd'),
    //     )
    //   ],
    // );
  }
}
