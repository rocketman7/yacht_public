import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/models/vote_comment_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/season_community_view_model.dart';
import 'package:yachtOne/views/constants/size.dart';

import '../locator.dart';
import 'widgets/avatar_widget.dart';

class SeasonCommunityView extends StatefulWidget {
  @override
  _SeasonCommunityViewState createState() => _SeasonCommunityViewState();
}

final TextEditingController _commentInputController = TextEditingController();
final ScrollController _commentScrollController = ScrollController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
VoteCommentModel voteCommentModel;
final _scaffoldKey = GlobalKey<ScaffoldState>();
int _textLength;

class _SeasonCommunityViewState extends State<SeasonCommunityView> {
  final NavigationService _navigationService = locator<NavigationService>();
  bool isliked;
  @override
  Widget build(BuildContext context) {
    print(deviceHeight);

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SeasonCommunityViewModel(),
      builder: (context, model, child) {
        // print("BUILDING" + model.idx.toString());
        return model.isBusy
            ? Scaffold(
                body: Center(
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
              )
            : Scaffold(
                body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    FocusScope.of(_navigationService
                                            .navigatorKey.currentContext)
                                        .unfocus();
                                    Navigator.of(_navigationService
                                            .navigatorKey.currentContext)
                                        .pop();
                                  },
                                  child: Icon(Icons.arrow_back_ios)),
                              Column(
                                children: <Widget>[
                                  Text("자유게시판",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  // Text("총 투표 " +
                                  //     ((model.vote.subVotes[idx].numVoted0 ?? 1) +
                                  //             (model.vote.subVotes[idx]
                                  //                     .numVoted1 ??
                                  //                 1))
                                  //         .toString()),
                                ],
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 2.0,
                          ),
                          // buildSquares(model, idx),
                          // SizedBox(height: 8),
                          Expanded(
                            child: buildCommentList(
                              model,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            // height: 100,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 40,
                                  child: avatarWidgetWithoutItem(
                                    model.user.avatarImage,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Stack(children: <Widget>[
                                  Container(
                                    // height: 40,
                                    constraints: BoxConstraints(
                                      minHeight: 40,
                                    ),
                                    width: deviceWidth * .75,
                                    child: TextFormField(
                                      // scrollController: _commentScrollController,
                                      // scrollPhysics: ScrollPhysics(),
                                      controller: _commentInputController,
                                      textAlign: TextAlign.start,
                                      validator: (value) {
                                        if (value.length < 1) {
                                          print(value.length);
                                          return "의견을 입력해주세요.";
                                        }
                                        return null;
                                      },
                                      // textAlignVertical: TextAlignVertical.top,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                      // minLines: 1,
                                      maxLines: null,
                                      maxLength: 80,
                                      // maxLengthEnforced: true,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              15, 12, 40, 12),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Color(0xFFBDBDBD),
                                              width: 1.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            borderSide: BorderSide(
                                              color: Color(0xFFBDBDBD),
                                              width: 1.0,
                                            ),
                                          ),
                                          hintText: '이번 시즌 관한 이야기를 나눠보세요',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF828282),
                                          )),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (_formKey.currentState.validate()) {
                                          voteCommentModel = VoteCommentModel(
                                            uid: model.user.uid,

                                            userName: model.user.userName,
                                            postText:
                                                _commentInputController.text,
                                            // choice: model.userVote == null
                                            //     ? "선택안함"
                                            //     : model.userVote.voteSelected[
                                            //                 model.idx] ==
                                            //             0
                                            //         ? "선택안함"
                                            //         : model.vote.subVotes[model.idx]
                                            //                 .voteChoices[
                                            //             model.userVote.voteSelected[
                                            //                     model.idx] -
                                            //                 1],
                                            postDateTime: Timestamp.fromDate(
                                                DateTime.now()),

                                            // postDateTime: DateTime.now(),
                                          );
                                          print("TAP");
                                          print(voteCommentModel.uid);
                                          model.postComments(
                                            model.address,
                                            voteCommentModel,
                                          );
                                          _commentInputController.text = '';
                                        }
                                      },
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 42,
                                          width: 42,
                                          decoration: BoxDecoration(
                                            // color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 8,
                                                  color: Colors.black
                                                      .withOpacity(.2),
                                                  spreadRadius: 0)
                                            ],
                                          ),
                                          child: Image.asset(
                                            'assets/icons/post_comment_button.png',
                                            // width: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                SizedBox(width: 8),
                                // Expanded(
                                //   child:
                                // ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
              ));
      },
    );
  }

  Widget buildSquares(SeasonCommunityViewModel model, int idx) {
    // 각 투표수 가져오기
    var numVoted0 = model.vote.subVotes[idx].numVoted0 ?? 1;
    var numVoted1 = model.vote.subVotes[idx].numVoted1 ?? 1;

    // 투표수 -> 퍼센티지 변환
    double vote0Percentage = numVoted0 / (numVoted0 + numVoted1);
    double vote1Percentage = numVoted1 / (numVoted0 + numVoted1);

    // 차트에 표시할 포맷
    var formatVotePct = new NumberFormat("##.0%");
    var formatReturnPct = new NumberFormat("0.00%");

    // length가 1이면 상,하 대결. 2이면 종목 대결
    int length = model.vote.subVotes[idx].issueCode.length;
    Color hexToColor(String code) {
      return Color(int.parse(code, radix: 16) + 0xFF0000000);
    }

    if (length == 1) {
      return StreamBuilder(
          stream: model.getRealtimePrice(
            model.address,
            model.vote.subVotes[idx].issueCode[0],
          ),
          builder: (context, snapshot) {
            print("STREAM BUILDING");
            if (snapshot.data == null) {
              print("SNAP NULL");
              return Center(child: CircularProgressIndicator());
            } else {
              print("SNAP RECEIVED");
              PriceModel price0;
              price0 = snapshot.data;
              print(model.vote.subVotes[idx].voteChoices[1].toString());
              return Stack(children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      flex: numVoted0,
                      child: Stack(children: <Widget>[
                        Container(
                          // width: 150,
                          height: deviceHeight * .17,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF3E3E),
                            border: Border(
                              left: BorderSide(
                                //                   <--- left side
                                color: Colors.black,
                                width: 2.0,
                              ),
                              top: BorderSide(
                                //                    <--- top side
                                color: Colors.black,
                                width: 2.0,
                              ),
                              right: BorderSide(
                                //                    <--- top side
                                color: Colors.black,
                                width: 1.0,
                              ),
                              bottom: BorderSide(
                                //                    <--- top side
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                          child: Text(
                            model.vote.subVotes[idx].voteChoices[0] +
                                " ${(formatVotePct.format(vote0Percentage)).toString()}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Container(
                        //   // 종목 1
                        //   height: deviceHeight * .17,
                        //   child: Align(
                        //     alignment: Alignment.bottomRight,
                        //     child: Padding(
                        //       padding: const EdgeInsets.fromLTRB(0, 0, 6, 9),
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: 6,
                        //           vertical: 3,
                        //         ),
                        //         decoration: BoxDecoration(
                        //             color: Color(
                        //                 0xFFFCDE34), // 지고 있을 때 종목 컬러랑 같게하고 이기고 있을 때 색 변화주면 됨.
                        //             borderRadius: BorderRadius.circular(
                        //               30,
                        //             )),
                        //         child: Container(
                        //           padding: EdgeInsets.all(6),
                        //           decoration: BoxDecoration(
                        //               color: (price0.pricePctChange < 0)
                        //                   ? Color(0xFF3485FF)
                        //                   : Colors.red,
                        //               borderRadius: BorderRadius.circular(
                        //                 30,
                        //               )),
                        //           child: price0.pricePctChange < 0
                        //               ? Text(
                        //                   formatReturnPct
                        //                       .format(price0.pricePctChange)
                        //                       .toString(),
                        //                   style: TextStyle(
                        //                     color: Colors.white,
                        //                     fontSize: 20,
                        //                   ),
                        //                 )
                        //               : Text(
                        //                   "+" +
                        //                       formatReturnPct
                        //                           .format(price0.pricePctChange)
                        //                           .toString(),
                        //                   style: TextStyle(
                        //                     color: Colors.white,
                        //                     fontSize: 20,
                        //                   ),
                        //                 ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ]),
                    ),
                    Flexible(
                      flex: numVoted1,
                      child: Stack(children: <Widget>[
                        Container(
                          // 종목2
                          // width: 150,
                          height: deviceHeight * .17,
                          decoration: BoxDecoration(
                            color: Color(0xFF3485FF),
                            border: Border(
                              left: BorderSide(
                                //                   <--- left side
                                color: Colors.black,
                                width: 1.0,
                              ),
                              top: BorderSide(
                                //                    <--- top side
                                color: Colors.black,
                                width: 2.0,
                              ),
                              right: BorderSide(
                                //                    <--- top side
                                color: Colors.black,
                                width: 2.0,
                              ),
                              bottom: BorderSide(
                                //                    <--- top side
                                color: Colors.black,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
                          child: Text(
                            model.vote.subVotes[idx].voteChoices[1] +
                                " ${(formatVotePct.format(vote1Percentage)).toString()}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // Container(
                        //   height: deviceHeight * .17,
                        //   child: Align(
                        //     alignment: Alignment.bottomRight,
                        //     child: Padding(
                        //       padding: const EdgeInsets.fromLTRB(0, 0, 6, 9),
                        //       child: Container(
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: 6,
                        //           vertical: 3,
                        //         ),
                        //         decoration: BoxDecoration(
                        //             color: Color(
                        //                 0xFFFFE609), // 지고 있을 때 종목 컬러랑 같게하고 이기고 있을 때 색 변화주면 됨.
                        //             borderRadius: BorderRadius.circular(
                        //               30,
                        //             )),
                        //         // child: Container(
                        //         //   padding: EdgeInsets.all(6),
                        //         //   decoration: BoxDecoration(
                        //         //       color: (price1.pricePctChange < 0)
                        //         //           ? Color(0xFF3485FF)
                        //         //           : Colors.red,
                        //         //       borderRadius: BorderRadius.circular(
                        //         //         30,
                        //         //       )),
                        //         //   child: price1.pricePctChange < 0
                        //         //       ? Text(
                        //         //           formatReturnPct
                        //         //               .format(price1.pricePctChange)
                        //         //               .toString(),
                        //         //           style: TextStyle(
                        //         //             color: Colors.white,
                        //         //             fontSize: 20,
                        //         //           ),
                        //         //         )
                        //         //       : Text(
                        //         //           "+" +
                        //         //               formatReturnPct
                        //         //                   .format(price1.pricePctChange)
                        //         //                   .toString(),
                        //         //           style: TextStyle(
                        //         //             color: Colors.white,
                        //         //             fontSize: 20,
                        //         //           ),
                        //         //         ),
                        //         // ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ]),
                    )
                  ],
                ),
                // vs or 가운데 수익률 마크
                Positioned(
                    // 기기width에서 padding 빼고 vote0이 차지하는 비중 곱한 뒤 vs위젯 width의 절반을 마이너스 offset
                    left: (deviceWidth - 32) * vote0Percentage - 40,
                    top: (deviceHeight * .17 / 2) - 20,
                    child: Container(
                      alignment: Alignment.center,
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(
                            40,
                          )),
                      child: Text(
                          " ${(formatReturnPct.format(price0.pricePctChange)).toString()}",
                          style: TextStyle(
                            fontSize: 16,
                            color: price0.pricePctChange < 0
                                ? Color(0xFF3485FF)
                                : Color(0xFFFF3E3E),
                            fontWeight: FontWeight.bold,
                          )),
                    )),
              ]);
            }
          });
    } else {
      return StreamBuilder<PriceModel>(
          stream: model.getRealtimePrice(
            model.address,
            model.vote.subVotes[idx].issueCode[0],
          ),
          builder: (context, snapshot0) {
            if (snapshot0.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              PriceModel price0;
              price0 = snapshot0.data;
              return StreamBuilder<PriceModel>(
                  stream: model.getRealtimePrice(
                    model.address,
                    model.vote.subVotes[idx].issueCode[1],
                  ),
                  builder: (context, snapshot1) {
                    if (snapshot1.data == null) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      PriceModel price1;
                      price1 = snapshot1.data;
                      return Stack(children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              flex: numVoted0,
                              child: Stack(children: <Widget>[
                                Container(
                                  // width: 150,
                                  height: deviceHeight * .17,
                                  decoration: BoxDecoration(
                                    color: length == 1
                                        ? Color(0xFFFF3E3E)
                                        : hexToColor(
                                            model.vote.subVotes[idx]
                                                .colorCode[0],
                                          ),
                                    border: Border(
                                      left: BorderSide(
                                        //                   <--- left side
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                      top: BorderSide(
                                        //                    <--- top side
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                      right: BorderSide(
                                        //                    <--- top side
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      bottom: BorderSide(
                                        //                    <--- top side
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  child: Text(
                                    model.vote.subVotes[idx].voteChoices[0] +
                                        " ${(formatVotePct.format(vote0Percentage)).toString()}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  // 종목 1
                                  height: deviceHeight * .17,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 6, 9),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(
                                                0xFFFCDE34), // 지고 있을 때 종목 컬러랑 같게하고 이기고 있을 때 색 변화주면 됨.
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            )),
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: (price0.pricePctChange < 0)
                                                  ? Color(0xFF3485FF)
                                                  : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30,
                                              )),
                                          child: price0.pricePctChange < 0
                                              ? Text(
                                                  formatReturnPct
                                                      .format(
                                                          price0.pricePctChange)
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                )
                                              : Text(
                                                  "+" +
                                                      formatReturnPct
                                                          .format(price0
                                                              .pricePctChange)
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            Flexible(
                              flex: numVoted1,
                              child: Stack(children: <Widget>[
                                Container(
                                  // 종목2
                                  // width: 150,
                                  height: deviceHeight * .17,
                                  decoration: BoxDecoration(
                                    color: length == 1
                                        ? Color(0xFF3485FF)
                                        : hexToColor(
                                            model.vote.subVotes[idx]
                                                .colorCode[1],
                                          ),
                                    border: Border(
                                      left: BorderSide(
                                        //                   <--- left side
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                      top: BorderSide(
                                        //                    <--- top side
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                      right: BorderSide(
                                        //                    <--- top side
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                      bottom: BorderSide(
                                        //                    <--- top side
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 12, 0, 0),
                                  child: Text(
                                    model.vote.subVotes[idx].voteChoices[1] +
                                        " ${(formatVotePct.format(vote1Percentage)).toString()}",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  height: deviceHeight * .17,
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 6, 9),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Color(
                                                0xFFFFE609), // 지고 있을 때 종목 컬러랑 같게하고 이기고 있을 때 색 변화주면 됨.
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            )),
                                        child: Container(
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: (price1.pricePctChange < 0)
                                                  ? Color(0xFF3485FF)
                                                  : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30,
                                              )),
                                          child: price1.pricePctChange < 0
                                              ? Text(
                                                  formatReturnPct
                                                      .format(
                                                          price1.pricePctChange)
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                )
                                              : Text(
                                                  "+" +
                                                      formatReturnPct
                                                          .format(price1
                                                              .pricePctChange)
                                                          .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            )
                          ],
                        ),
                        // vs or 가운데 수익률 마크
                        (length == 1)
                            ? Positioned(
                                // 기기width에서 padding 빼고 vote0이 차지하는 비중 곱한 뒤 vs위젯 width의 절반을 마이너스 offset
                                left: (deviceWidth - 32) * vote0Percentage - 20,
                                top: (deviceHeight * .17 / 2) - 20,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(
                                        40,
                                      )),
                                  child: price0.pricePctChange < 0
                                      ? Text(
                                          formatReturnPct
                                              .format(price0.pricePctChange)
                                              .toString(),
                                          style: TextStyle(
                                            color: Color(0xFF3485FF),
                                            fontSize: 20,
                                          ),
                                        )
                                      : Text(
                                          "+" +
                                              formatReturnPct
                                                  .format(price0.pricePctChange)
                                                  .toString(),
                                          style: TextStyle(
                                            color: Color(0xFFFF3E3E),
                                            fontSize: 20,
                                          ),
                                        ),
                                ))
                            : Positioned(
                                // 기기width에서 padding 빼고 vote0이 차지하는 비중 곱한 뒤 vs위젯 width의 절반을 마이너스 offset
                                left: (deviceWidth - 32) * vote0Percentage - 20,
                                top: (deviceHeight * .17 / 2) - 20,
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(
                                        40,
                                      )),
                                  child: Text("vs",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )),
                      ]);
                    }
                  });
            }
          });
    }
  }

  Widget buildCommentList(
    SeasonCommunityViewModel model,
  ) {
    return StreamBuilder<List<VoteCommentModel>>(
        stream: model.getPost(model.address),
        builder: (context, snapshot) {
          List<VoteCommentModel> beforeCommentList = snapshot.data;

          if (snapshot.data == null) {
            return Container();
          } else if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                "아직 의견이 없습니다.\n ${model.user.userName}님이 첫 번째 의견을 나눠보세요.",
                style: TextStyle(
                  fontFamily: 'DmSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF999999),
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            List<dynamic> blockList = model.user.blockList;
            List<VoteCommentModel> commentList = [];
            if (blockList != null) {
              for (int i = 0; i < beforeCommentList.length; i++) {
                if (blockList.contains(beforeCommentList[i].uid)) {
                  print("NOT Contain");
                } else {
                  commentList.add(beforeCommentList[i]);
                }
              }
              return Container(
                  // height: deviceHeight * .55,
                  child: ListView.builder(
                      key: _scaffoldKey,
                      controller: _commentScrollController,
                      // addAutomaticKeepAlives: true,
                      itemCount: commentList.length,
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return buildColumn(
                          model,
                          commentList[index],
                          commentList,
                          index,
                        );
                      }));
            }
          }
        });
  }

  Widget buildColumn(
    SeasonCommunityViewModel model,
    VoteCommentModel voteComment,
    List<VoteCommentModel> commentList,
    int index,
  ) {
    bool isPostLiked = voteComment.likedBy.contains(model.uid);
    Duration timeElapsed =
        DateTime.now().difference(voteComment.postDateTime.toDate());

    print(voteComment.likedBy.contains(model.uid));
    print(voteComment.likedBy.toString());
    // likedBy에 있으면 true
    // isPostLiked = voteComment.likedBy.contains(model.uid);
    // print(isPostLiked);

    return Column(
      children: <Widget>[
        Divider(
          thickness: 1.0,
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          // height: deviceHeight * .07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  FutureBuilder(
                      future: model.getAvatar(voteComment.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          String _avatar = snapshot.data;
                          print("FutureBUilder" + snapshot.data.toString());
                          return Container(
                              height: 40,
                              width: 40,
                              child: avatarWidgetWithoutItem(_avatar));
                        } else {
                          return Container(
                            height: 40,
                            width: 40,
                          );
                        }
                      }),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(voteComment.userName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                          voteComment.postDateTime == null
                              ? ' '
                              : (timeElapsed.inMinutes < 1)
                                  ? "방금 전"
                                  : (timeElapsed.inMinutes < 60)
                                      ? timeElapsed.inMinutes.toString() + "분 전"
                                      : (timeElapsed.inHours < 24)
                                          ? timeElapsed.inHours.toString() +
                                              "시간 전"
                                          : timeElapsed.inDays.toString() +
                                              "일 전",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF999999),
                          )),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      LikeButton(
                        size: 20,
                        isLiked: isPostLiked,
                        bubblesSize: 80,
                        countPostion: CountPostion.right,
                        likeCount: voteComment.likedBy == null
                            ? 0
                            : voteComment.likedBy.length,
                        likeCountAnimationType: LikeCountAnimationType.all,
                        onTap: (isPostLiked) async {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            model.likeComment(voteComment);
                          });
                          return !isPostLiked;
                        },
                        countBuilder: (likeCount, isLiked, count) {
                          return Text(
                            count,
                            style: TextStyle(
                              // fontFamily: 'DmSans',
                              fontSize: 14,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          );
                        },
                        likeCountPadding: EdgeInsets.only(
                          left: 4,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      voteComment.uid == model.uid
                          ? GestureDetector(
                              onTap: () {
                                print(model.address.postsSeasonCollection());
                                print(voteComment.postUid);
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Platform.isIOS
                                          ? CupertinoAlertDialog(
                                              content: Text('이 게시글을 삭제하시겠습니까?'),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                  child: Text('아뇨'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoDialogAction(
                                                  child: Text('네'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    model.deleteComment(
                                                        model.address,
                                                        voteComment.postUid);
                                                    // model.logout();
                                                  },
                                                )
                                              ],
                                            )
                                          : AlertDialog(
                                              content: Text('이 게시글을 삭제하시겠습니까?'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('아뇨'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('네'),
                                                  onPressed: () {
                                                    Navigator.pop(context);

                                                    model.deleteComment(
                                                        model.address,
                                                        voteComment.postUid);
                                                    // model.logout();
                                                    // model.logout();
                                                  },
                                                )
                                              ],
                                            ),
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.grey[500],
                                size: 18,

                                // Text(
                                //   "삭제",
                                //   textAlign: TextAlign.end,
                                //   style: TextStyle(
                                //     color: Colors.black,
                                //     fontSize: 13,
                                //     fontFamily: 'AdventPro',
                                //   ),
                                // ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context)
                                          .copyWith(textScaleFactor: 1.0),
                                      child: Platform.isIOS
                                          ? CupertinoAlertDialog(
                                              content:
                                                  Text('이 게시글을 신고/차단하시겠습니까?'),
                                              actions: <Widget>[
                                                CupertinoDialogAction(
                                                  child: Text('아뇨'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoDialogAction(
                                                  child: Text('네'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    model.addBlockList(
                                                        model.user,
                                                        voteComment);
                                                    setState(() {
                                                      commentList
                                                          .removeAt(index);
                                                    });
                                                  },
                                                )
                                              ],
                                            )
                                          : AlertDialog(
                                              content:
                                                  Text('이 게시글을 신고/차단하시겠습니까?'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('아뇨'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('네'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    model.addBlockList(
                                                        model.user,
                                                        voteComment);
                                                    setState(() {
                                                      commentList
                                                          .removeAt(index);
                                                    });
                                                    // model.logout();
                                                  },
                                                )
                                              ],
                                            ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "신고/차단",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              voteComment.postText,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
