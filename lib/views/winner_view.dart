import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:yachtOne/view_models/winner_view_model.dart';

import 'constants/size.dart';
import '../models/rank_model.dart';
import '../views/widgets/avatar_widget.dart';

class WinnerView extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WinnerViewModel>.reactive(
        viewModelBuilder: () => WinnerViewModel(),
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
                                top: deviceHeight / 2 - 100,
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
                      : SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(Icons.arrow_back_ios),
                                    ),
                                    Spacer(),
                                    Text(
                                      "",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: 'AppleSDB',
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      // color: Colors.red,
                                      width: 30,
                                      // height: 30,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/winner_resize.svg',
                                      height: 80,
                                      // width: 80,
                                      // color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 4,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          )),
                                      child: Text(
                                        "시즌 1",
                                        style: TextStyle(
                                            color: Colors.white,
                                            height: 1,
                                            letterSpacing: -1.0,
                                            fontFamily: 'AppleSDM',
                                            fontSize: 16),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '시즌 시작일',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        height: 1,
                                        fontFamily: 'AppleSDM',
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "2020.12.11",
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        height: 1,
                                        fontFamily: 'AppleSDM',
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '목표 승점',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        height: 1,
                                        fontFamily: 'AppleSDM',
                                        letterSpacing: -1.0,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${model.seasonModel.winningPoint}점',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        height: 1,
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
                                      '참여자',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        height: 1,
                                        fontFamily: 'AppleSDM',
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${model.getUsersNum()}명',
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        height: 1,
                                        fontFamily: 'AppleSDM',
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '시즌 최종 상금',
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
                                        // model.navigateToPortfolioPage();
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
                                        // model.navigateToPortfolioPage();
                                      },
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16.sp,
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
                                Center(
                                  child: Text(
                                    '시즌 1 우승자',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 28,
                                        letterSpacing: -1.0,
                                        fontFamily: 'AppleSDEB'),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.h,
                                ),
                                // Winners List
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: model.winners.length,
                                    itemBuilder: (context, index) =>
                                        buildWinnersListView(
                                      model,
                                      model.rankModel[index],
                                      index,
                                    ),
                                  ),
                                ),
                                Divider(),
                                Center(
                                  child: Text(
                                    '시즌 1 특별상',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 28,
                                        letterSpacing: -1.0,
                                        fontFamily: 'AppleSDEB'),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '커뮤니티 하트상',
                                      style: TextStyle(
                                        fontFamily: 'AppleSDB',
                                        fontSize: 20,
                                        letterSpacing: -0.28,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Container(
                                      height: 36,
                                      width: 36,
                                      child: CircleAvatar(
                                        maxRadius: 36,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: AssetImage(
                                            'assets/images/avatar004.png'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    Text('LemonAde',
                                        style: TextStyle(
                                            fontSize: 24,
                                            letterSpacing: -2.0,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 16.h,
                                  ),
                                ),

                                // Winners List

                                Spacer(),
                              ],
                            ),
                          ),
                        ));
        });
  }

  buildWinnersListView(WinnerViewModel model, RankModel ranksModel, int index) {
    // 나중에 몇만명 이렇게 늘어나면 고쳐야할듯?
    const double rankNumWidth = 48;

    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   height: 36,
            //   width: 36,
            //   child: CircleAvatar(
            //     maxRadius: 36,
            //     backgroundColor: Colors.transparent,
            //     backgroundImage:
            //         AssetImage('assets/images/${ranksModel.avatarImage}.png'),
            //   ),
            // ),
            // SizedBox(
            //   width: 18,
            // ),
            Text(
              '${ranksModel.userName}',
              style: TextStyle(
                fontSize: 40,
                height: 1,
                fontFamily: 'AppleSDB',
                letterSpacing: -0.28,
              ),
              overflow: TextOverflow.ellipsis,
            ),
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
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ));
  }
}

class DrawTriangle extends CustomPainter {
  bool isUp;
  Paint _paint;

  DrawTriangle({this.isUp}) {
    _paint = Paint()
      ..color = isUp ? Color(0xFFFF402B) : Color(0xFF2B40FF)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    if (isUp) {
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
