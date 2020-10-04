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
                      ? Center(
                          child: Container(
                            height: 100,
                            width: deviceWidth,
                            child: FlareActor(
                              'assets/images/Loading.flr',
                              animation: 'loading',
                              fit: BoxFit.contain,
                            ),
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
                                            "SEASON 1",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Text(model.user.userName,
                                            style: TextStyle(
                                              fontSize: 24,
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
                                      '5,768,654',
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
                                      '시즌 목표 콤보',
                                      style: TextStyle(
                                          fontSize: 20, letterSpacing: -1.0),
                                    ),
                                    Spacer(),
                                    Text(
                                      '30',
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
                                      '현재 콤보',
                                      style: TextStyle(
                                          fontSize: 20, letterSpacing: -1.0),
                                    ),
                                    Spacer(),
                                    Text(
                                      '6',
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
                                      '현재 순위(위)',
                                      style: TextStyle(
                                          fontSize: 20, letterSpacing: -1.0),
                                    ),
                                    Spacer(),
                                    Text(
                                      '6',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'DmSans',
                                          letterSpacing: -1.0,
                                          fontWeight: FontWeight.bold),
                                    )
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
                                              '2020.09.21',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  letterSpacing: -1.0),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Container(
                                              height: 8,
                                              width: 1,
                                              color: Color(0xFFDFDFDF),
                                            ),
                                            SizedBox(
                                              width: 9,
                                            ),
                                            Text(
                                              '10,345명의 참여자',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  letterSpacing: -1.0),
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
                                            model.rankModel[index],
                                            index,
                                            model.uid),
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

  makesRankListView(RankModel ranksModel, int index, String uid) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Column(
              children: [
                Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontSize: 24,
                      letterSpacing: -0.28,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'New',
                  style: TextStyle(
                      fontSize: 12,
                      letterSpacing: -0.28,
                      fontWeight: FontWeight.bold),
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
                backgroundImage: AssetImage('assets/images/avatar.png'),
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
            ranksModel.uid == uid
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
            Text('${ranksModel.combo}',
                style: TextStyle(
                    fontSize: 24,
                    letterSpacing: -2.0,
                    fontWeight: FontWeight.bold))
          ],
        ));
  }
}
