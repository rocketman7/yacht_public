import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:yachtOne/services/mixpanel_service.dart';

import '../locator.dart';
import 'constants/size.dart';
import '../models/rank_model.dart';
import '../view_models/rank_view_model.dart';
import '../views/widgets/avatar_widget.dart';

class RankView extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final MixpanelService? _mixpanelService = locator<MixpanelService>();
  DateTime? currentBackPressTime;
  Future<bool> _onWillPop() async {
    if (currentBackPressTime == null ||
        DateTime.now().difference(currentBackPressTime!) >
            Duration(seconds: 2)) {
      currentBackPressTime = DateTime.now();
      Fluttertoast.showToast(msg: "뒤로 가기를 다시 누르면 앱이 종료됩니다");
      return Future.value(false);
      // return null;
    } else {
      print("TURN OFF");
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RankViewModel>.reactive(
        viewModelBuilder: () => RankViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? Container(
                          height: deviceHeight,
                          width: deviceWidth,
                          child: Stack(
                            children: [
                              Positioned(
                                top: deviceHeight! / 2 - 100,
                                child: Container(
                                  height: 100,
                                  width: deviceWidth,
                                  child: FlareActor(
                                    'assets/images/Loading.flr',
                                    animation: 'loading',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : WillPopScope(
                          onWillPop: _onWillPop,
                          child: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      avatarWidget(model.userModel!.avatarImage,
                                          model.userModel!.item),
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 3,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  30,
                                                )),
                                            child: Text(
                                              "${model.seasonModel!.seasonName}",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'DmSans',
                                                  fontSize: 12),
                                            ),
                                          ),
                                          AutoSizeText(
                                            model.userModel!.userName!,
                                            style: TextStyle(
                                              fontSize: 24,
                                              letterSpacing: -1.0,
                                              fontFamily: 'AppleSDB',
                                              // fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '시즌 상금 가치',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          _mixpanelService!.mixpanel
                                              .track('Portfolio View - Rank');
                                          model.navigateToPortfolioPage();
                                        },
                                        child: Text(
                                          '${model.getPortfolioValue()}원',
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            height: 1,
                                            fontFamily: 'AppleSDM',
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          model.navigateToPortfolioPage();
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '현재 / 목표 승점',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -1.0,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${model.myWinPoint}   /   ${model.seasonModel!.winningPoint}',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -1.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '현재 순위',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -1.0,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        model.myRank == 0
                                            ? '-'
                                            : '${model.returnDigitFormat(model.myRank)}',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -1.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Container(
                                    height: 1,
                                    color: Color(0xFFDFDFDF),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '오늘의 순위',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 28.sp,
                                                letterSpacing: -2.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          (model.rankModel!.length != 0)
                                              ? Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '${model.getDateFormChange()}',
                                                      style: TextStyle(
                                                          fontFamily: 'DmSans',
                                                          fontSize: 14),
                                                    ),
                                                    Container(
                                                      height: 8,
                                                      width: 1,
                                                      color: Color(0xFFD8D8D8),
                                                    ),
                                                    SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(
                                                      '${model.getUsersNum()}명 경쟁 중!',
                                                      style: TextStyle(
                                                          fontFamily: 'DmSans',
                                                          fontSize: 14),
                                                    )
                                                  ],
                                                )
                                              : Text('시즌 시작 후 순위가 표시됩니다!',
                                                  style: TextStyle(
                                                      fontFamily: 'DmSans',
                                                      fontSize: 14)),
                                          SizedBox(
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                      // Spacer(),
                                      // GestureDetector(
                                      //   onTap: () async {
                                      //     print('dddd');
                                      //     await model.scrollToMyRank();
                                      //   },
                                      //   child: Container(
                                      //     padding: EdgeInsets.symmetric(
                                      //         horizontal: 8, vertical: 6),
                                      //     decoration: BoxDecoration(
                                      //         color: Colors.blueGrey,
                                      //         borderRadius: BorderRadius.all(
                                      //             Radius.circular(20))),
                                      //     child: Center(
                                      //       child: Text(
                                      //         "내 순위로 가기",
                                      //         style: TextStyle(
                                      //             fontSize: 12,
                                      //             height: 1,
                                      //             color: Colors.white,
                                      //             fontFamily: 'AppleSDM'),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      // controller: model.scrollController,
                                      itemCount: model.rankModel!.length,
                                      itemBuilder: (context, index) =>
                                          makesRankListView(
                                        model,
                                        model.rankModel![index],
                                        index,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
        });
  }

  makesRankListView(RankViewModel model, RankModel ranksModel, int index) {
    // 나중에 몇만명 이렇게 늘어나면 고쳐야할듯?
    const double rankNumWidth = 48;

    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Container(
                  width: rankNumWidth,
                  height: 28,
                  child: Center(
                    child: Text(
                      '${model.returnDigitFormat(model.rankModel![index].todayRank)}',
                      style: TextStyle(
                          fontSize: 24,
                          letterSpacing: -0.28,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                model.rankChangeSymbol[index] == '*'
                    ? Text(
                        '${model.rankChange[index]}',
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: -0.28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFCE20)),
                      )
                    : (model.rankChangeSymbol[index] == '+')
                        ? Row(
                            children: [
                              CustomPaint(
                                  size: Size(8, 4),
                                  painter: DrawTriangle(isUp: true)),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                '${model.rankChange[index]}',
                                style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: -0.28,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF402B)),
                              ),
                            ],
                          )
                        : (model.rankChangeSymbol[index] == '-')
                            ? Row(
                                children: [
                                  CustomPaint(
                                      size: Size(8, 4),
                                      painter: DrawTriangle(isUp: false)),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    '${model.rankChange[index].substring(1, model.rankChange[index].length)}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: -0.28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2B40FF)),
                                  ),
                                ],
                              )
                            : Container(
                                width: 8,
                                height: 2,
                                color: Color(0xFFC4C4C4),
                              )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              height: 36.sp,
              width: 36.sp,
              child: CircleAvatar(
                maxRadius: 36,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage('assets/images/${ranksModel.avatarImage}.png'),
              ),
            ),
            SizedBox(
              width: 18.sp,
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      ranksModel.userName!,
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: -0.28,
                      ),
                      maxLines: 1,
                      // minFontSize: 10,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Spacer(),
                  Row(
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      ranksModel.uid == model.uid
                          ? Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 3,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      )),
                                  child: Text(
                                    "본인",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        width: 8,
                      ),
                      Text('${ranksModel.currentWinPoint}',
                          style: TextStyle(
                              fontSize: 24,
                              letterSpacing: -2.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class DrawTriangle extends CustomPainter {
  bool? isUp;
  late Paint _paint;

  DrawTriangle({this.isUp}) {
    _paint = Paint()
      ..color = isUp! ? Color(0xFFFF402B) : Color(0xFF2B40FF)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    if (isUp!) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.close();
    } else {
      path.moveTo(size.width / 2, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
      path.close();
    }

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
