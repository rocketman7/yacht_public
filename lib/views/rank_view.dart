import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';

import 'constants/size.dart';
import '../models/rank_model.dart';
import '../view_models/rank_view_model.dart';
import '../views/widgets/avatar_widget.dart';

class RankView extends StatelessWidget {
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
                              children: [
                                Row(
                                  children: [
                                    avatarWidget(model.user.avatarImage,
                                        model.user.item),
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
                                            "${model.seasonModel.seasonName}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'DmSans',
                                                fontSize: 12),
                                          ),
                                        ),
                                        Text(model.user.userName,
                                            style: TextStyle(
                                              fontSize: 24,
                                              letterSpacing: -1.0,
                                              fontFamily: 'DmSans',
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '현재 상금가치(원)',
                                      style: TextStyle(
                                          fontSize: 20, letterSpacing: -1.0),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${model.getPortfolioValue()}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'DmSans',
                                          letterSpacing: -1.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        model.navigateToPortfolioPage();
                                      },
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
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
                                      '시즌 목표 승점',
                                      style: TextStyle(
                                          fontSize: 20, letterSpacing: -1.0),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${model.seasonModel.winningPoint}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'DmSans',
                                          letterSpacing: -1.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '현재 승점',
                                      style: TextStyle(
                                          fontSize: 20, letterSpacing: -1.0),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${model.userVoteStatsModel.currentWinPoint}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'DmSans',
                                          letterSpacing: -1.0,
                                          fontWeight: FontWeight.bold),
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
                                          fontSize: 20, letterSpacing: -1.0),
                                    ),
                                    Spacer(),
                                    model.myRankChangeSymbol == '*'
                                        ? Text(
                                            '${model.myRankChange}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                letterSpacing: -0.28,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFFCE20)),
                                          )
                                        : (model.myRankChangeSymbol == '+')
                                            ? Row(
                                                children: [
                                                  CustomPaint(
                                                      size: Size(8, 4),
                                                      painter: DrawTriangle(
                                                          isUp: true)),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                ],
                                              )
                                            : (model.myRankChangeSymbol == '-')
                                                ? Row(
                                                    children: [
                                                      CustomPaint(
                                                          size: Size(8, 4),
                                                          painter: DrawTriangle(
                                                              isUp: false)),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                    ],
                                                  )
                                                : Container(
                                                    width: 8,
                                                    height: 2,
                                                    color: Color(0xFFC4C4C4),
                                                  ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    // Text(
                                    //   '${model.returnDigitFormat(model.myRank)}',
                                    //   style: TextStyle(
                                    //       fontSize: 20,
                                    //       fontFamily: 'DmSans',
                                    //       letterSpacing: -1.0,
                                    //       fontWeight: FontWeight.bold),
                                    // )
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 1,
                                  color: Color(0xFFDFDFDF),
                                ),
                                SizedBox(
                                  height: 31,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '오늘의 랭킹',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 28,
                                              letterSpacing: -2.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
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
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                      ],
                                    ),
                                    Spacer()
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: model.rankModel.length,
                                    itemBuilder: (context, index) =>
                                        makesRankListView(
                                      model,
                                      model.rankModel[index],
                                      index,
                                    ),
                                  ),
                                ),
                                // RaisedButton(
                                //   onPressed: () {
                                //     model.addRank();
                                //   },
                                //   child: Text('rank DB 추가'),
                                // ),
                              ],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: rankNumWidth,
                  height: 28,
                  child: Center(
                    child: Text(
                      '${model.returnDigitFormat(model.rankModel[index].todayRank)}',
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
              height: 36,
              width: 36,
              child: CircleAvatar(
                maxRadius: 36,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage('assets/images/${ranksModel.avatarImage}.png'),
              ),
            ),
            SizedBox(
              width: 18,
            ),
            Text('${ranksModel.userName}',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: -0.28,
                )),
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
            Spacer(),
            Text('${ranksModel.currentWinPoint}',
                style: TextStyle(
                    fontSize: 24,
                    letterSpacing: -2.0,
                    fontWeight: FontWeight.bold)),
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
