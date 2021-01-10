import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:yachtOne/models/rank_model.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/view_models/winner_view_model.dart';
import 'package:yachtOne/views/widgets/avatar_widget.dart';

class LastSeasonRankView extends StatefulWidget {
  final WinnerViewModel model;

  LastSeasonRankView(
    this.model,
  );

  @override
  _LastSeasonRankViewState createState() => _LastSeasonRankViewState();
}

class _LastSeasonRankViewState extends State<LastSeasonRankView> {
  WinnerViewModel model;

  @override
  Widget build(BuildContext context) {
    model = widget.model;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      fontSize: 20,
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
              Row(
                children: [
                  avatarWidget(
                      model.userModel.avatarImage, model.userModel.item),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          "${model.seasonModel.seasonName}",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'DmSans',
                              fontSize: 12),
                        ),
                      ),
                      AutoSizeText(
                        model.userModel.userName,
                        style: TextStyle(
                          fontSize: 24,
                          letterSpacing: -1.0,
                          fontFamily: 'DmSans',
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Text(
                    '나의 최종 승점',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'AppleSDM',
                      // letterSpacing: -1.0,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '${model.myWinPoint}점',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'AppleSDM',
                      // letterSpacing: -1.0,
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
                    '나의 최종 순위',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'AppleSDM',
                      // letterSpacing: -1.0,
                    ),
                  ),
                  Spacer(),
                  Text(
                    model.myRank == 0
                        ? '-'
                        : '${model.returnDigitFormat(model.myRank)}위',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'AppleSDM',
                      // letterSpacing: -1.0,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 1,
                color: Color(0xFFDFDFDF),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '시즌 최종 순위',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 28,
                            letterSpacing: -2.0,
                            fontWeight: FontWeight.bold),
                      ),
                      (model.rankModel.length != 0)
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Text(
                                //   '${model.getDateFormChange()}',
                                //   style: TextStyle(
                                //       fontFamily: 'DmSans', fontSize: 14),
                                // ),
                                Container(
                                  height: 8,
                                  width: 1,
                                  color: Color(0xFFD8D8D8),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  '총 ${model.getUsersNum()}명 참여',
                                  style: TextStyle(
                                      fontFamily: 'DmSans', fontSize: 14),
                                )
                              ],
                            )
                          : Text('시즌 시작 후 순위가 표시됩니다!',
                              style: TextStyle(
                                  fontFamily: 'DmSans', fontSize: 14)),
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
                  itemBuilder: (context, index) => makesRankListView(
                    model,
                    model.rankModel[index],
                    index,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  makesRankListView(WinnerViewModel model, RankModel ranksModel, int index) {
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
            Text(
              '${ranksModel.userName}',
              style: TextStyle(
                fontSize: 20,
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