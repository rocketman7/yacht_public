import 'dart:io';
import 'dart:math';
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
import 'package:yachtOne/models/vote_chart_model.dart';
import 'package:yachtOne/models/vote_comment_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/subject_community_view_model.dart';
import 'package:yachtOne/views/constants/size.dart';
import '../locator.dart';
import 'widgets/avatar_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SubjectCommunityView extends StatefulWidget {
  final subjectCommunityviewObject;

  SubjectCommunityView(
    this.subjectCommunityviewObject,
  );
  @override
  _SubjectCommunityViewState createState() => _SubjectCommunityViewState();
}

final TextEditingController _commentInputController = TextEditingController();
final ScrollController _commentScrollController = ScrollController();

VoteCommentModel voteCommentModel;

class _SubjectCommunityViewState extends State<SubjectCommunityView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int idx;
  VoteModel vote;
  bool isliked = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _textLength;

  @override
  Widget build(BuildContext context) {
    vote = widget.subjectCommunityviewObject[0];
    idx = widget.subjectCommunityviewObject[1];
    var numVoteFormat = NumberFormat("#,###");
    print(deviceHeight);

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SubjectCommunityViewModel(vote.voteDate, idx),
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
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        18,
                        18,
                        0,
                      ),
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
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                    )),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            model.vote.subVotes[idx].issueCode
                                                        .length ==
                                                    1
                                                ? model.vote.subVotes[idx].title
                                                : model.vote.subVotes[idx]
                                                    .voteChoices[0],
                                            style: TextStyle(
                                              fontSize: 22,
                                              height: 1,
                                              fontFamily: 'AppleSDEB',
                                              // fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                          ),
                                          model.vote.subVotes[idx].issueCode
                                                      .length ==
                                                  1
                                              ? StreamBuilder<PriceModel>(
                                                  stream:
                                                      model.getRealtimePrice(
                                                          model.newAddress,
                                                          model
                                                              .vote
                                                              .subVotes[idx]
                                                              .issueCode[0]),
                                                  builder:
                                                      (context, snapshot0) {
                                                    if (snapshot0.data ==
                                                        null) {
                                                      return Container();
                                                    } else {
                                                      var formatVotePct =
                                                          new NumberFormat(
                                                              "##.0%");
                                                      var formatPrice =
                                                          NumberFormat("#,###");
                                                      var formatReturnPct =
                                                          new NumberFormat(
                                                              "0.00%");
                                                      PriceModel price0;
                                                      price0 = snapshot0.data;
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          price0.pricePctChange <
                                                                  0
                                                              ? Text(
                                                                  formatReturnPct
                                                                      .format(price0
                                                                          .pricePctChange)
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF3485FF),
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontFamily:
                                                                        'AppleSDB',
                                                                  ),
                                                                )
                                                              : Text(
                                                                  formatReturnPct
                                                                      .format(price0
                                                                          .pricePctChange)
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontFamily:
                                                                        'AppleSDB',
                                                                  ),
                                                                ),
                                                        ],
                                                      );
                                                    }
                                                  },
                                                )
                                              : StreamBuilder<PriceModel>(
                                                  stream:
                                                      model.getRealtimePrice(
                                                          model.newAddress,
                                                          model
                                                              .vote
                                                              .subVotes[idx]
                                                              .issueCode[0]),
                                                  builder: (context, snapshot) {
                                                    var formatVotePct =
                                                        new NumberFormat(
                                                            "##.0%");
                                                    var formatPrice =
                                                        NumberFormat("#,###");
                                                    var formatReturnPct =
                                                        new NumberFormat(
                                                            "0.00%");
                                                    if (snapshot.data == null) {
                                                      return Container();
                                                    } else {
                                                      PriceModel price0;
                                                      price0 = snapshot.data;

                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          price0.pricePctChange <
                                                                  0
                                                              ? Text(
                                                                  formatReturnPct
                                                                      .format(price0
                                                                          .pricePctChange)
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFF3485FF),
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontFamily:
                                                                        'AppleSDB',
                                                                  ),
                                                                )
                                                              : Text(
                                                                  formatReturnPct
                                                                      .format(price0
                                                                          .pricePctChange)
                                                                      .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontFamily:
                                                                        'AppleSDB',
                                                                  ),
                                                                ),
                                                        ],
                                                      );
                                                    }
                                                  },
                                                ),
                                          // Text("총 투표 " +
                                          //     ((model.vote.subVotes[idx].numVoted0 ??
                                          //                 1) +
                                          //             (model.vote.subVotes[idx]
                                          //                     .numVoted1 ??
                                          //                 1))
                                          //         .toString()),
                                        ],
                                      ),
                                      model.vote.subVotes[idx].issueCode
                                                  .length ==
                                              1
                                          ? Container()
                                          : Column(
                                              children: <Widget>[
                                                Text(
                                                  " vs ",
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    height: 1,
                                                    fontFamily: 'AppleSDEB',
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  overflow: TextOverflow.fade,
                                                ),
                                                Text(
                                                  " ",
                                                  style: TextStyle(
                                                    color: Color(0xFF3485FF),
                                                    fontSize: 14.sp,
                                                    fontFamily: 'AppleSDB',
                                                  ),
                                                ),

                                                // Text("총 투표 " +
                                                //     ((model.vote.subVotes[idx].numVoted0 ??
                                                //                 1) +
                                                //             (model.vote.subVotes[idx]
                                                //                     .numVoted1 ??
                                                //                 1))
                                                //         .toString()),
                                              ],
                                            ),
                                      model.vote.subVotes[idx].issueCode
                                                  .length ==
                                              1
                                          ? Container()
                                          : Column(
                                              children: <Widget>[
                                                Text(
                                                  model.vote.subVotes[idx]
                                                      .voteChoices[1],
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    height: 1,
                                                    fontFamily: 'AppleSDEB',
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  softWrap: false,
                                                  overflow: TextOverflow.fade,
                                                ),
                                                model.vote.subVotes[idx]
                                                            .issueCode.length ==
                                                        1
                                                    ? StreamBuilder<PriceModel>(
                                                        stream: model
                                                            .getRealtimePrice(
                                                                model
                                                                    .newAddress,
                                                                model
                                                                    .vote
                                                                    .subVotes[
                                                                        idx]
                                                                    .issueCode[0]),
                                                        builder: (context,
                                                            snapshot0) {
                                                          if (snapshot0.data ==
                                                              null) {
                                                            return Container();
                                                          } else {
                                                            var formatVotePct =
                                                                new NumberFormat(
                                                                    "##.0%");
                                                            var formatPrice =
                                                                NumberFormat(
                                                                    "#,###");
                                                            var formatReturnPct =
                                                                new NumberFormat(
                                                                    "0.00%");
                                                            PriceModel price0;
                                                            price0 =
                                                                snapshot0.data;
                                                            return Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  model
                                                                      .vote
                                                                      .subVotes[
                                                                          idx]
                                                                      .title,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        24.sp,
                                                                    fontFamily:
                                                                        'AppleSDB',
                                                                  ),
                                                                ),
                                                                price0.pricePctChange <
                                                                        0
                                                                    ? Text(
                                                                        formatReturnPct
                                                                            .format(price0.pricePctChange)
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFF3485FF),
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontFamily:
                                                                              'AppleSDB',
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        formatReturnPct
                                                                            .format(price0.pricePctChange)
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontFamily:
                                                                              'AppleSDB',
                                                                        ),
                                                                      ),
                                                              ],
                                                            );
                                                          }
                                                        },
                                                      )
                                                    : StreamBuilder<PriceModel>(
                                                        stream: model
                                                            .getRealtimePrice(
                                                                model
                                                                    .newAddress,
                                                                model
                                                                    .vote
                                                                    .subVotes[
                                                                        idx]
                                                                    .issueCode[1]),
                                                        builder: (context,
                                                            snapshot) {
                                                          var formatVotePct =
                                                              new NumberFormat(
                                                                  "##.0%");
                                                          var formatPrice =
                                                              NumberFormat(
                                                                  "#,###");
                                                          var formatReturnPct =
                                                              new NumberFormat(
                                                                  "0.00%");
                                                          if (snapshot.data ==
                                                              null) {
                                                            return Container();
                                                          } else {
                                                            PriceModel price0;
                                                            price0 =
                                                                snapshot.data;
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: <
                                                                  Widget>[
                                                                price0.pricePctChange <
                                                                        0
                                                                    ? Text(
                                                                        formatReturnPct
                                                                            .format(price0.pricePctChange)
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFF3485FF),
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontFamily:
                                                                              'AppleSDB',
                                                                        ),
                                                                      )
                                                                    : Text(
                                                                        formatReturnPct
                                                                            .format(price0.pricePctChange)
                                                                            .toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontFamily:
                                                                              'AppleSDB',
                                                                        ),
                                                                      ),
                                                              ],
                                                            );
                                                          }
                                                        },
                                                      ),
                                                // Text("총 투표 " +
                                                //     ((model.vote.subVotes[idx].numVoted0 ??
                                                //                 1) +
                                                //             (model.vote.subVotes[idx]
                                                //                     .numVoted1 ??
                                                //                 1))
                                                //         .toString()),
                                              ],
                                            ),
                                    ],
                                  ),
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
                            // model.vote.subVotes[idx].issueCode.length == 1
                            //     ? StreamBuilder<PriceModel>(
                            //         stream: model.getRealtimePrice(
                            //             model.newAddress,
                            //             model.vote.subVotes[idx].issueCode[0]),
                            //         builder: (context, snapshot0) {
                            //           if (snapshot0.data == null) {
                            //             return Container();
                            //           } else {
                            //             var formatVotePct =
                            //                 new NumberFormat("##.0%");
                            //             var formatPrice = NumberFormat("#,###");
                            //             var formatReturnPct =
                            //                 new NumberFormat("0.00%");
                            //             PriceModel price0;
                            //             price0 = snapshot0.data;
                            //             return Column(
                            //               mainAxisAlignment:
                            //                   MainAxisAlignment.spaceAround,
                            //               children: <Widget>[
                            //                 Text(
                            //                   model.vote.subVotes[idx].title,
                            //                   style: TextStyle(
                            //                     fontSize: 24.sp,
                            //                     fontFamily: 'AppleSDB',
                            //                   ),
                            //                 ),
                            //                 price0.pricePctChange < 0
                            //                     ? Text(
                            //                         formatPrice
                            //                                 .format(price0.price)
                            //                                 .toString() +
                            //                             " (" +
                            //                             formatReturnPct
                            //                                 .format(price0
                            //                                     .pricePctChange)
                            //                                 .toString() +
                            //                             ")",
                            //                         style: TextStyle(
                            //                           color: Color(0xFF3485FF),
                            //                           fontSize: 20.sp,
                            //                           fontFamily: 'AppleSDB',
                            //                         ),
                            //                       )
                            //                     : Text(
                            //                         formatPrice
                            //                                 .format(price0.price)
                            //                                 .toString() +
                            //                             " (+" +
                            //                             formatReturnPct
                            //                                 .format(price0
                            //                                     .pricePctChange)
                            //                                 .toString() +
                            //                             ")",
                            //                         style: TextStyle(
                            //                           color: Colors.red,
                            //                           fontSize: 20.sp,
                            //                           fontFamily: 'AppleSDB',
                            //                         ),
                            //                       ),
                            //               ],
                            //             );
                            //           }
                            //         },
                            //       )
                            //     : StreamBuilder<PriceModel>(
                            //         stream: model.getRealtimePrice(
                            //             model.newAddress,
                            //             model.vote.subVotes[idx].issueCode[0]),
                            //         builder: (context, snapshot) {
                            //           var formatVotePct =
                            //               new NumberFormat("##.0%");
                            //           var formatPrice = NumberFormat("#,###");
                            //           var formatReturnPct =
                            //               new NumberFormat("0.00%");
                            //           if (snapshot.data == null) {
                            //             return Container();
                            //           } else {
                            //             PriceModel price0;
                            //             price0 = snapshot.data;
                            //             return StreamBuilder<PriceModel>(
                            //               stream: model.getRealtimePrice(
                            //                   model.newAddress,
                            //                   model.vote.subVotes[idx]
                            //                       .issueCode[1]),
                            //               builder: (context, snapshot1) {
                            //                 if (snapshot1.data == null) {
                            //                   return Container();
                            //                 } else {
                            //                   PriceModel price1;
                            //                   price1 = snapshot1.data;
                            //                   return Row(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.spaceAround,
                            //                     children: <Widget>[
                            //                       Column(
                            //                         children: [
                            //                           Text(
                            //                             model.vote.subVotes[idx]
                            //                                 .voteChoices[0],
                            //                             style: TextStyle(
                            //                               fontSize: 24.sp,
                            //                               fontFamily: 'AppleSDB',
                            //                             ),
                            //                           ),
                            //                           price0.pricePctChange < 0
                            //                               ? Text(
                            //                                   formatPrice
                            //                                           .format(price0
                            //                                               .price)
                            //                                           .toString() +
                            //                                       " (" +
                            //                                       formatReturnPct
                            //                                           .format(price0
                            //                                               .pricePctChange)
                            //                                           .toString() +
                            //                                       ")",
                            //                                   style: TextStyle(
                            //                                     color: Color(
                            //                                         0xFF3485FF),
                            //                                     fontSize: 20.sp,
                            //                                     fontFamily:
                            //                                         'AppleSDB',
                            //                                   ),
                            //                                 )
                            //                               : Text(
                            //                                   formatPrice
                            //                                           .format(price0
                            //                                               .price)
                            //                                           .toString() +
                            //                                       " (+" +
                            //                                       formatReturnPct
                            //                                           .format(price0
                            //                                               .pricePctChange)
                            //                                           .toString() +
                            //                                       ")",
                            //                                   style: TextStyle(
                            //                                     color: Colors.red,
                            //                                     fontSize: 20.sp,
                            //                                     fontFamily:
                            //                                         'AppleSDB',
                            //                                   ),
                            //                                 ),
                            //                         ],
                            //                       ),
                            //                       Column(
                            //                         children: [
                            //                           Text(
                            //                             model.vote.subVotes[idx]
                            //                                 .voteChoices[1],
                            //                             style: TextStyle(
                            //                               fontSize: 24.sp,
                            //                               fontFamily: 'AppleSDB',
                            //                             ),
                            //                           ),
                            //                           price1.pricePctChange < 0
                            //                               ? Text(
                            //                                   formatPrice
                            //                                           .format(price1
                            //                                               .price)
                            //                                           .toString() +
                            //                                       " (" +
                            //                                       formatReturnPct
                            //                                           .format(price1
                            //                                               .pricePctChange)
                            //                                           .toString() +
                            //                                       ")",
                            //                                   style: TextStyle(
                            //                                     color: Color(
                            //                                         0xFF3485FF),
                            //                                     fontSize: 20.sp,
                            //                                     fontFamily:
                            //                                         'AppleSDB',
                            //                                   ),
                            //                                 )
                            //                               : Text(
                            //                                   formatPrice
                            //                                           .format(price1
                            //                                               .price)
                            //                                           .toString() +
                            //                                       " (+" +
                            //                                       formatReturnPct
                            //                                           .format(price1
                            //                                               .pricePctChange)
                            //                                           .toString() +
                            //                                       ")",
                            //                                   style: TextStyle(
                            //                                     color: Colors.red,
                            //                                     fontSize: 20.sp,
                            //                                     fontFamily:
                            //                                         'AppleSDB',
                            //                                   ),
                            //                                 ),
                            //                         ],
                            //                       ),
                            //                     ],
                            //                   );
                            //                 }
                            //               },
                            //             );
                            //           }
                            //         }),
                            // buildSquares(model, idx),
                            SizedBox(height: 8),
                            Container(
                              // color: Colors.amber,
                              // height: 120,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "총 예측 " +
                                        numVoteFormat
                                            .format((model.vote.subVotes[idx]
                                                        .numVoted0 ??
                                                    0) +
                                                (model.vote.subVotes[idx]
                                                        .numVoted1 ??
                                                    0))
                                            .toString(),
                                    style: TextStyle(
                                      fontFamily: 'AppleSDM',
                                      fontSize: 14,
                                    ),
                                  ),
                                  _numOfVoteChart(model, idx),
                                ],
                              ),
                            ),
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
                                        // onChanged: (text) {
                                        //   setState(() {
                                        //     _textLength = text.length;
                                        //   });
                                        // },
                                        validator: (value) {
                                          if (value.length < 1) {
                                            print(value.length);
                                            return "의견을 입력해주세요.";
                                          }
                                          return null;
                                        },
                                        textAlign: TextAlign.start,
                                        keyboardType: TextInputType.text,
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
                                            hintText: '주제에 관한 의견을 말해주세요',
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
                                          print(model.idx);
                                          print(model.userVote.voteSelected);
                                          if (_formKey.currentState
                                              .validate()) {
                                            voteCommentModel = VoteCommentModel(
                                              uid: model.uid,
                                              userName: model.user.userName,
                                              postText:
                                                  _commentInputController.text,
                                              choice: model.userVote
                                                          .voteSelected ==
                                                      null
                                                  ? "선택안함"
                                                  : model.userVote.voteSelected[
                                                              model.idx] ==
                                                          0
                                                      ? "선택안함"
                                                      : model
                                                          .vote
                                                          .subVotes[model.idx]
                                                          .voteChoices[model
                                                                  .userVote
                                                                  .voteSelected[
                                                              model.idx] -
                                                          1],
                                              postDateTime: Timestamp.fromDate(
                                                  DateTime.now()),

                                              // postDateTime: DateTime.now(),
                                            );
                                            print("TAP");
                                            print(voteCommentModel.uid);

                                            FocusScope.of(context).unfocus();
                                            model.postComments(
                                              model.newAddress,
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

  // Widget buildSquares(SubjectCommunityViewModel model, int idx) {
  //   // 각 투표수 가져오기
  //   var numVoted0 = model.vote.subVotes[idx].numVoted0 ?? 1;
  //   var numVoted1 = model.vote.subVotes[idx].numVoted1 ?? 1;

  //   // 투표수 -> 퍼센티지 변환
  //   double vote0Percentage = numVoted0 / (numVoted0 + numVoted1);
  //   double vote1Percentage = numVoted1 / (numVoted0 + numVoted1);

  //   // 차트에 표시할 포맷
  //   var formatVotePct = NumberFormat("##.0%");
  //   var formatReturnPct = NumberFormat("0.00%");

  //   // length가 1이면 상,하 대결. 2이면 종목 대결
  //   int length = model.vote.subVotes[idx].issueCode.length;
  //   Color hexToColor(String code) {
  //     return Color(int.parse(code, radix: 16) + 0xFF0000000);
  //   }

  //   if (length == 1) {
  //     return StreamBuilder(
  //         stream: model.getRealtimePrice(
  //           model.newAddress,
  //           model.vote.subVotes[idx].issueCode[0],
  //         ),
  //         builder: (context, snapshot) {
  //           print("STREAM BUILDING");
  //           if (snapshot.data == null) {
  //             print("SNAP NULL");
  //             return Center(child: Container());
  //           } else {
  //             print("SNAP RECEIVED");
  //             PriceModel price0;
  //             price0 = snapshot.data;
  //             print(model.vote.subVotes[idx].voteChoices[1].toString());
  //             return Stack(children: <Widget>[
  //               Row(
  //                 children: <Widget>[
  //                   Flexible(
  //                     flex: ((deviceWidth - 32) / 40) * numVoted1 - numVoted1 >
  //                             numVoted0
  //                         ? numVoted0
  //                         : (((deviceWidth - 32) / 40) * numVoted1 - numVoted1)
  //                                 .round() +
  //                             1,
  //                     child: Stack(children: <Widget>[
  //                       Container(
  //                         // width: 150,
  //                         height: deviceHeight * .17,
  //                         decoration: BoxDecoration(
  //                           color: Color(0xFFFF3E3E),
  //                           border: Border(
  //                             left: BorderSide(
  //                               //                   <--- left side
  //                               color: Colors.black,
  //                               width: 2.0,
  //                             ),
  //                             top: BorderSide(
  //                               //                    <--- top side
  //                               color: Colors.black,
  //                               width: 2.0,
  //                             ),
  //                             right: BorderSide(
  //                               //                    <--- top side
  //                               color: Colors.black,
  //                               width: 1.0,
  //                             ),
  //                             bottom: BorderSide(
  //                               //                    <--- top side
  //                               color: Colors.black,
  //                               width: 2.0,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
  //                         child: Text(
  //                           model.vote.subVotes[idx].voteChoices[0] +
  //                               " ${(formatVotePct.format(vote0Percentage)).toString()}",
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.white,
  //                           ),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                       // Container(
  //                       //   // 종목 1
  //                       //   height: deviceHeight * .17,
  //                       //   child: Align(
  //                       //     alignment: Alignment.bottomRight,
  //                       //     child: Padding(
  //                       //       padding: const EdgeInsets.fromLTRB(0, 0, 6, 9),
  //                       //       child: Container(
  //                       //         padding: EdgeInsets.symmetric(
  //                       //           horizontal: 6,
  //                       //           vertical: 3,
  //                       //         ),
  //                       //         decoration: BoxDecoration(
  //                       //             color: Color(
  //                       //                 0xFFFCDE34), // 지고 있을 때 종목 컬러랑 같게하고 이기고 있을 때 색 변화주면 됨.
  //                       //             borderRadius: BorderRadius.circular(
  //                       //               30,
  //                       //             )),
  //                       //         child: Container(
  //                       //           padding: EdgeInsets.all(6),
  //                       //           decoration: BoxDecoration(
  //                       //               color: (price0.pricePctChange < 0)
  //                       //                   ? Color(0xFF3485FF)
  //                       //                   : Colors.red,
  //                       //               borderRadius: BorderRadius.circular(
  //                       //                 30,
  //                       //               )),
  //                       //           child: price0.pricePctChange < 0
  //                       //               ? Text(
  //                       //                   formatReturnPct
  //                       //                       .format(price0.pricePctChange)
  //                       //                       .toString(),
  //                       //                   style: TextStyle(
  //                       //                     color: Colors.white,
  //                       //                     fontSize: 20,
  //                       //                   ),
  //                       //                 )
  //                       //               : Text(
  //                       //                   "+" +
  //                       //                       formatReturnPct
  //                       //                           .format(price0.pricePctChange)
  //                       //                           .toString(),
  //                       //                   style: TextStyle(
  //                       //                     color: Colors.white,
  //                       //                     fontSize: 20,
  //                       //                   ),
  //                       //                 ),
  //                       //         ),
  //                       //       ),
  //                       //     ),
  //                       //   ),
  //                       // ),
  //                     ]),
  //                   ),
  //                   Flexible(
  //                     flex: ((deviceWidth - 32) / 40) * numVoted0 - numVoted0 >
  //                             numVoted1
  //                         ? numVoted1
  //                         : (((deviceWidth - 32) / 40) * numVoted0 - numVoted0)
  //                                 .round() -
  //                             1,
  //                     child: Stack(children: <Widget>[
  //                       Container(
  //                         // 종목2
  //                         // width: 150,
  //                         height: deviceHeight * .17,
  //                         decoration: BoxDecoration(
  //                           color: Color(0xFF3485FF),
  //                           border: Border(
  //                             left: BorderSide(
  //                               //                   <--- left side
  //                               color: Colors.black,
  //                               width: 1.0,
  //                             ),
  //                             top: BorderSide(
  //                               //                    <--- top side
  //                               color: Colors.black,
  //                               width: 2.0,
  //                             ),
  //                             right: BorderSide(
  //                               //                    <--- top side
  //                               color: Colors.black,
  //                               width: 2.0,
  //                             ),
  //                             bottom: BorderSide(
  //                               //                    <--- top side
  //                               color: Colors.black,
  //                               width: 2.0,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.fromLTRB(12, 12, 0, 0),
  //                         child: Text(
  //                           model.vote.subVotes[idx].voteChoices[1] +
  //                               " ${(formatVotePct.format(vote1Percentage)).toString()}",
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.white,
  //                           ),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                       // Container(
  //                       //   height: deviceHeight * .17,
  //                       //   child: Align(
  //                       //     alignment: Alignment.bottomRight,
  //                       //     child: Padding(
  //                       //       padding: const EdgeInsets.fromLTRB(0, 0, 6, 9),
  //                       //       child: Container(
  //                       //         padding: EdgeInsets.symmetric(
  //                       //           horizontal: 6,
  //                       //           vertical: 3,
  //                       //         ),
  //                       //         decoration: BoxDecoration(
  //                       //             color: Color(
  //                       //                 0xFFFFE609), // 지고 있을 때 종목 컬러랑 같게하고 이기고 있을 때 색 변화주면 됨.
  //                       //             borderRadius: BorderRadius.circular(
  //                       //               30,
  //                       //             )),
  //                       //         // child: Container(
  //                       //         //   padding: EdgeInsets.all(6),
  //                       //         //   decoration: BoxDecoration(
  //                       //         //       color: (price1.pricePctChange < 0)
  //                       //         //           ? Color(0xFF3485FF)
  //                       //         //           : Colors.red,
  //                       //         //       borderRadius: BorderRadius.circular(
  //                       //         //         30,
  //                       //         //       )),
  //                       //         //   child: price1.pricePctChange < 0
  //                       //         //       ? Text(
  //                       //         //           formatReturnPct
  //                       //         //               .format(price1.pricePctChange)
  //                       //         //               .toString(),
  //                       //         //           style: TextStyle(
  //                       //         //             color: Colors.white,
  //                       //         //             fontSize: 20,
  //                       //         //           ),
  //                       //         //         )
  //                       //         //       : Text(
  //                       //         //           "+" +
  //                       //         //               formatReturnPct
  //                       //         //                   .format(price1.pricePctChange)
  //                       //         //                   .toString(),
  //                       //         //           style: TextStyle(
  //                       //         //             color: Colors.white,
  //                       //         //             fontSize: 20,
  //                       //         //           ),
  //                       //         //         ),
  //                       //         // ),
  //                       //       ),
  //                       //     ),
  //                       //   ),
  //                       // ),
  //                     ]),
  //                   )
  //                 ],
  //               ),
  //               // vs or 가운데 수익률 마크
  //               Positioned(
  //                   // 기기width에서 padding 빼고 vote0이 차지하는 비중 곱한 뒤 vs위젯 width의 절반을 마이너스 offset
  //                   left: vote0Percentage > vote1Percentage
  //                       ? min(
  //                           (deviceWidth - 32) * vote0Percentage - 40 - 2,
  //                           deviceWidth - 32 - 80 - 4,
  //                         )
  //                       : max(2, (deviceWidth - 32) * vote0Percentage - 40 - 2),
  //                   top: (132 / 2) - 20,
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     width: 80,
  //                     height: 40,
  //                     decoration: BoxDecoration(
  //                         color: Colors.black,
  //                         borderRadius: BorderRadius.circular(
  //                           40,
  //                         )),
  //                     child: price0.pricePctChange < 0
  //                         ? Text(
  //                             formatReturnPct
  //                                 .format(price0.pricePctChange)
  //                                 .toString(),
  //                             style: TextStyle(
  //                               color: Color(0xFF3485FF),
  //                               fontSize: 16,
  //                             ),
  //                           )
  //                         : Text(
  //                             "+" +
  //                                 formatReturnPct
  //                                     .format(price0.pricePctChange)
  //                                     .toString(),
  //                             style: TextStyle(
  //                               color: Color(0xFFFF3E3E),
  //                               fontSize: 16,
  //                             ),
  //                           ),
  //                   ))
  //             ]);
  //           }
  //         });
  //   } else {
  //     return StreamBuilder<PriceModel>(
  //         stream: model.getRealtimePrice(
  //           model.newAddress,
  //           model.vote.subVotes[idx].issueCode[0],
  //         ),
  //         builder: (context, snapshot0) {
  //           if (snapshot0.data == null) {
  //             return Center(child: Container());
  //           } else {
  //             PriceModel price0;
  //             price0 = snapshot0.data;
  //             return StreamBuilder<PriceModel>(
  //                 stream: model.getRealtimePrice(
  //                   model.newAddress,
  //                   model.vote.subVotes[idx].issueCode[1],
  //                 ),
  //                 builder: (context, snapshot1) {
  //                   if (snapshot1.data == null) {
  //                     return Center(child: Container());
  //                   } else {
  //                     PriceModel price1;
  //                     price1 = snapshot1.data;
  //                     return Stack(children: <Widget>[
  //                       Row(
  //                         children: <Widget>[
  //                           Flexible(
  //                             // 고급수학 applied
  //                             flex: ((deviceWidth - 32) / 20) * numVoted1 -
  //                                         numVoted1 >
  //                                     numVoted0
  //                                 ? numVoted0
  //                                 : (((deviceWidth - 32) / 20) * numVoted1 -
  //                                             numVoted1)
  //                                         .round() +
  //                                     1,
  //                             child: Stack(
  //                               children: <Widget>[
  //                                 Container(
  //                                   // width: 150,
  //                                   height: 132,
  //                                   decoration: BoxDecoration(
  //                                     color: hexToColor(
  //                                       model.vote.subVotes[idx].colorCode[0],
  //                                     ),
  //                                     border: Border(
  //                                       left: BorderSide(
  //                                         //                   <--- left side
  //                                         color: Colors.black,
  //                                         width: 2.0,
  //                                       ),
  //                                       top: BorderSide(
  //                                         //                    <--- top side
  //                                         color: Colors.black,
  //                                         width: 2.0,
  //                                       ),
  //                                       right: BorderSide(
  //                                         //                    <--- top side
  //                                         color: Colors.black,
  //                                         width: 1.0,
  //                                       ),
  //                                       bottom: BorderSide(
  //                                         //                    <--- top side
  //                                         color: Colors.black,
  //                                         width: 2.0,
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding:
  //                                       const EdgeInsets.fromLTRB(12, 12, 0, 0),
  //                                   child: Text(
  //                                     model.vote.subVotes[idx].voteChoices[0] +
  //                                         " ${(formatVotePct.format(vote0Percentage)).toString()}",
  //                                     style: TextStyle(
  //                                         fontSize: 16,
  //                                         fontWeight: FontWeight.bold),
  //                                     maxLines: model.vote.subVotes[idx]
  //                                                 .voteChoices[0].length >
  //                                             5
  //                                         ? 2
  //                                         : 1,
  //                                     overflow: TextOverflow.ellipsis,
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                           Flexible(
  //                             flex: ((deviceWidth - 32) / 20) * numVoted0 -
  //                                         numVoted0 >
  //                                     numVoted1
  //                                 ? numVoted1
  //                                 : (((deviceWidth - 32) / 20) * numVoted0 -
  //                                             numVoted0)
  //                                         .round() -
  //                                     1,
  //                             child: Stack(children: <Widget>[
  //                               Container(
  //                                 // 종목2
  //                                 // width: 150,
  //                                 height: 132,
  //                                 decoration: BoxDecoration(
  //                                   color: hexToColor(
  //                                     model.vote.subVotes[idx].colorCode[1],
  //                                   ),
  //                                   border: Border(
  //                                     left: BorderSide(
  //                                       //                   <--- left side
  //                                       color: Colors.black,
  //                                       width: 1.0,
  //                                     ),
  //                                     top: BorderSide(
  //                                       //                    <--- top side
  //                                       color: Colors.black,
  //                                       width: 2.0,
  //                                     ),
  //                                     right: BorderSide(
  //                                       //                    <--- top side
  //                                       color: Colors.black,
  //                                       width: 2.0,
  //                                     ),
  //                                     bottom: BorderSide(
  //                                       //                    <--- top side
  //                                       color: Colors.black,
  //                                       width: 2.0,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                               Padding(
  //                                 padding:
  //                                     const EdgeInsets.fromLTRB(12, 12, 0, 0),
  //                                 child: Text(
  //                                   model.vote.subVotes[idx].voteChoices[1] +
  //                                       " ${(formatVotePct.format(vote1Percentage)).toString()}",
  //                                   style: TextStyle(
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.bold),
  //                                   maxLines: model.vote.subVotes[idx]
  //                                               .voteChoices[1].length >
  //                                           5
  //                                       ? 2
  //                                       : 1,
  //                                   overflow: TextOverflow.ellipsis,
  //                                 ),
  //                               ),
  //                             ]),
  //                           )
  //                         ],
  //                       ),
  //                       // vs or 가운데 수익률 마크
  //                       Positioned(
  //                           // 기기width에서 padding 빼고 vote0이 차지하는 비중 곱한 뒤 vs위젯 width의 절반을 마이너스 offset
  //                           left: vote0Percentage > vote1Percentage
  //                               ? min(
  //                                   (deviceWidth - 32) * vote0Percentage -
  //                                       20 -
  //                                       2,
  //                                   deviceWidth - 32 - 40 - 4,
  //                                 )
  //                               : max(
  //                                   2,
  //                                   (deviceWidth - 32) * vote0Percentage -
  //                                       20 -
  //                                       2),
  //                           //  (deviceWidth - 32) * vote0Percentage -
  //                           //             20 <
  //                           //         0
  //                           //     ? 2
  //                           //     : (deviceWidth - 32) * vote0Percentage -
  //                           //                 20 >
  //                           //             deviceWidth - 32 - 40 - 2
  //                           //         ? deviceWidth - 32 - 40 - 2
  //                           //         : (deviceWidth - 32) * vote0Percentage -
  //                           //             20 -
  //                           //             2,
  //                           top: (132 / 2) - 20,
  //                           child: Container(
  //                             alignment: Alignment.center,
  //                             width: 40,
  //                             height: 40,
  //                             decoration: BoxDecoration(
  //                                 color: Colors.black,
  //                                 borderRadius: BorderRadius.circular(
  //                                   40,
  //                                 )),
  //                             child: Text("vs",
  //                                 style: TextStyle(
  //                                   fontSize: 16,
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold,
  //                                 )),
  //                           )),
  //                       Positioned(
  //                         bottom: 0,
  //                         left: 0,
  //                         child: Container(
  //                           // 종목 1
  //                           // height: 60,
  //                           child: Padding(
  //                             padding: const EdgeInsets.fromLTRB(6, 0, 0, 6),
  //                             child: Container(
  //                               padding: EdgeInsets.symmetric(
  //                                 horizontal: 6,
  //                                 vertical: 3,
  //                               ),
  //                               decoration: BoxDecoration(
  //                                   color: price0.pricePctChange >
  //                                           price1.pricePctChange
  //                                       ? Color(0xFFFCDE34)
  //                                       : hexToColor(
  //                                           model.vote.subVotes[idx]
  //                                               .colorCode[0],
  //                                         ), // 지고 있을 때 종목 컬러랑 같게하고 이기고 있을 때 색 변화주면 됨.
  //                                   borderRadius: BorderRadius.circular(
  //                                     30,
  //                                   )),
  //                               child: Container(
  //                                 padding: EdgeInsets.all(6),
  //                                 decoration: BoxDecoration(
  //                                     color: (price0.pricePctChange < 0)
  //                                         ? Color(0xFF3485FF)
  //                                         : Colors.red,
  //                                     borderRadius: BorderRadius.circular(
  //                                       30,
  //                                     )),
  //                                 child: price0.pricePctChange < 0
  //                                     ? Text(
  //                                         formatReturnPct
  //                                             .format(price0.pricePctChange)
  //                                             .toString(),
  //                                         style: TextStyle(
  //                                           color: Colors.white,
  //                                           fontSize: 16,
  //                                         ),
  //                                       )
  //                                     : Text(
  //                                         "+" +
  //                                             formatReturnPct
  //                                                 .format(price0.pricePctChange)
  //                                                 .toString(),
  //                                         style: TextStyle(
  //                                           color: Colors.white,
  //                                           fontSize: 16,
  //                                         ),
  //                                       ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Positioned(
  //                         right: 0,
  //                         bottom: 0,
  //                         child: Container(
  //                           child: Padding(
  //                             padding: const EdgeInsets.fromLTRB(0, 0, 6, 6),
  //                             child: Container(
  //                               padding: EdgeInsets.symmetric(
  //                                 horizontal: 6,
  //                                 vertical: 3,
  //                               ),
  //                               decoration: BoxDecoration(
  //                                   color: price0.pricePctChange <
  //                                           price1.pricePctChange
  //                                       ? Color(0xFFFCDE34)
  //                                       : hexToColor(
  //                                           model.vote.subVotes[idx]
  //                                               .colorCode[1],
  //                                         ), // 지고 있을 때 종목 컬러랑 같게하고 이기고 있을 때 색 변화주면 됨.
  //                                   borderRadius: BorderRadius.circular(
  //                                     30,
  //                                   )),
  //                               child: Container(
  //                                 padding: EdgeInsets.all(6),
  //                                 decoration: BoxDecoration(
  //                                     color: (price1.pricePctChange < 0)
  //                                         ? Color(0xFF3485FF)
  //                                         : Colors.red,
  //                                     borderRadius: BorderRadius.circular(
  //                                       30,
  //                                     )),
  //                                 child: price1.pricePctChange < 0
  //                                     ? Text(
  //                                         formatReturnPct
  //                                             .format(price1.pricePctChange)
  //                                             .toString(),
  //                                         style: TextStyle(
  //                                           color: Colors.white,
  //                                           fontSize: 16,
  //                                         ),
  //                                       )
  //                                     : Text(
  //                                         "+" +
  //                                             formatReturnPct
  //                                                 .format(price1.pricePctChange)
  //                                                 .toString(),
  //                                         style: TextStyle(
  //                                           color: Colors.white,
  //                                           fontSize: 16,
  //                                         ),
  //                                       ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ]);
  //                   }
  //                 });
  //           }
  //         });
  //   }
  // }

  Widget buildCommentList(
    SubjectCommunityViewModel model,
  ) {
    return StreamBuilder<List<VoteCommentModel>>(
        stream: model.getPost(model.newAddress),
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
            } else {
              commentList = beforeCommentList;
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
                          model, commentList[index], commentList, index);
                    }));
          }
        });
  }

  Widget buildColumn(
    SubjectCommunityViewModel model,
    VoteCommentModel voteComment,
    List<VoteCommentModel> commentList,
    int index,
  ) {
    // String avatarImage = "avatar001";
    // model.getAvatar(voteComment.uid);

    // print(model.avatarImage);
    bool isPostLiked = voteComment.likedBy.contains(model.uid);
    print(voteComment.likedBy);
    Duration timeElapsed =
        DateTime.now().difference(voteComment.postDateTime.toDate());

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
                      Row(
                        children: [
                          Text(voteComment.userName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                          SizedBox(
                            width: 8,
                          ),
                          Text(voteComment.choice)
                        ],
                      ),
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
              Row(
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
                            print(model.newAddress.postsSubVoteCollection());
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
                                                    model.newAddress,
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
                                                    model.newAddress,
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
                                          content: Text('이 게시글을 신고/차단하시겠습니까?'),
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
                                                    model.user, voteComment);
                                                setState(() {
                                                  commentList.removeAt(index);
                                                });
                                                // model.logout();
                                              },
                                            )
                                          ],
                                        )
                                      : AlertDialog(
                                          content: Text('이 게시글을 신고/차단하시겠습니까?'),
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
                                                    model.user, voteComment);
                                                setState(() {
                                                  commentList.removeAt(index);
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

  Widget _numOfVoteChart(
    SubjectCommunityViewModel model,
    int idx,
  ) {
    List<VoteChart> data;
    // 차트에 표시할 포맷
    var percenetFormat = NumberFormat("##%");

    // 각 투표수 가져오기
    var numVoted0 = model.vote.subVotes[idx].numVoted0 ?? 0;
    var numVoted1 = model.vote.subVotes[idx].numVoted1 ?? 0;

// print("TOTAL VOTE")
    // 투표수 -> 퍼센티지 변환

    double vote0Percentage = ((numVoted0 + numVoted1) == 0)
        ? 0
        : (numVoted0 / (numVoted0 + numVoted1));
    double vote1Percentage = ((numVoted0 + numVoted1) == 0)
        ? 0
        : (numVoted1 / (numVoted0 + numVoted1));
    print("total VOTE 0" + numVoted0.toString());
    print("VOTE 0 perc" + vote0Percentage.toString());

    // Bar 차트에 들어갈 데이터 오브젝트
    data = [
      VoteChart(
          model.vote.subVotes[idx].voteChoices[0], vote0Percentage, Colors.red),
      VoteChart(model.vote.subVotes[idx].voteChoices[1], vote1Percentage,
          Colors.blue),
    ];

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60,
            // color: Colors.blue,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              margin: EdgeInsets.all(0),
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(
                  fontFamily: 'AppleSDB',
                  fontSize: 18,
                  color: Colors.black,
                ),
                majorTickLines: MajorTickLines(
                  width: 0,
                ),
                axisLine: AxisLine(
                  width: 0,
                ),
                isInversed: true,
                minorGridLines: MinorGridLines(
                  width: 0,
                ),
                majorGridLines: MajorGridLines(
                  width: 0,
                ),
              ),
              primaryYAxis: NumericAxis(
                maximum: 1.0,
                minimum: 0.0,
                minorGridLines: MinorGridLines(
                  width: 0,
                ),
                majorGridLines: MajorGridLines(
                  width: 0,
                ),
                isVisible: false,
              ),
              series: <ChartSeries>[
                BarSeries<VoteChart, String>(
                  dataSource: data,
                  pointColorMapper: (VoteChart chart, _) => chart.color,
                  xValueMapper: (VoteChart chart, _) => chart.name,
                  yValueMapper: (VoteChart chart, _) => chart.votePercentage,
                  isTrackVisible: true,
                  trackColor: Colors.white,
                  trackBorderColor: Colors.grey,
                  trackBorderWidth: 0.2,
                  width: 0.2,
                  spacing: 0.1,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  animationDuration: 1000,
                  // spacing: 1.2,
                )
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        Container(
          height: 60,
          // color: Colors.red,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "${percenetFormat.format(vote0Percentage)}",
                style: TextStyle(
                  fontFamily: 'AppleSDB',
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                "${percenetFormat.format(vote1Percentage)}",
                style: TextStyle(
                  fontFamily: 'AppleSDEB',
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
