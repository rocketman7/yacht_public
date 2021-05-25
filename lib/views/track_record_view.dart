import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/track_record_view_model.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../locator.dart';
import 'constants/size.dart';
import 'widgets/avatar_widget.dart';

class TrackRecordView extends StatefulWidget {
  @override
  _TrackRecordViewState createState() => _TrackRecordViewState();
}

class _TrackRecordViewState extends State<TrackRecordView> {
  final NavigationService? _navigationService = locator<NavigationService>();
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
    final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
    // ScreenUtil.init(context,
    //     designSize: Size(375, 812), allowFontScaling: false);
    return ViewModelBuilder<TrackRecordViewModel>.reactive(
      viewModelBuilder: () => TrackRecordViewModel(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return Scaffold(
            body: Container(
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
            ),
          );
        } else {
          print("System Util " + 137.h.toString() + "  " + 40.sp.toString());

          return Scaffold(
            body: WillPopScope(
              onWillPop: _onWillPop,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "나의 예측기록",
                              style: TextStyle(
                                fontFamily: 'AppleSDEB',
                                fontSize: 32.sp,
                                letterSpacing: -2.0,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: FutureBuilder<List<String?>>(
                                  future: model.getAllSeasonList(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(color: Colors.blue);
                                    } else {
                                      List<String?>? seasonList = snapshot.data;
                                      return Container(
                                        height: 40,
                                        // width: 90,
                                        // color: Colors.blue,
                                        child: DropdownButton<String>(
                                          value: model.showingSeasonName,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 24,
                                          elevation: 8,
                                          style: TextStyle(color: Colors.black),
                                          underline: Container(
                                              // height: 2,
                                              // color: Colors.deepPurpleAccent,
                                              ),
                                          onChanged: (String? newValue) {
                                            _mixpanelService!.mixpanel.track(
                                                'Other Season Record',
                                                properties: {
                                                  'Season': newValue
                                                });
                                            model.renewAddress(newValue);
                                            // showingSeasonName = newValue;
                                          },
                                          items: seasonList!
                                              .map<DropdownMenuItem<String>>(
                                                  (String? value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value!),
                                            );
                                          }).toList(),
                                        ),
                                      );
                                    }
                                  }),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        // height: 150.h,
                        color: Color(0xFF1EC8CF),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              // width: deviceWidth / 3,
                              flex: 3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: avatarWidget(
                                            model.user!.avatarImage ??
                                                'avatar001',
                                            model.user!.item),
                                      ),
                                      SizedBox(
                                        width: 8.sp,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8.sp,
                                  ),
                                  AutoSizeText(
                                    model.user!.userName!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.sp,
                                      fontFamily: 'AppleSDB',
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                children: [
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        model.userVote!.userVoteStats!
                                                    .currentWinPoint ==
                                                null
                                            ? 0.toString()
                                            : model.userVote!.userVoteStats!
                                                .currentWinPoint
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40.sp,
                                          fontFamily: 'DmSans',
                                          height: 1,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: true,
                                      ),
                                      Text(
                                        "현재 승점",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: 'AppleSDM',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                children: [
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Text(
                                        model.myRank == 0
                                            ? "-"
                                            : model
                                                .returnDigitFormat(model.myRank)
                                                .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40.sp,
                                          fontFamily: 'DmSans',
                                          height: 1,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        softWrap: true,
                                      ),
                                      Text(
                                        "현재 순위",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: 'AppleSDM',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.sp,
                          ),
                          child: model.isChangingSeason
                              ? Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: model.allSeasonVoteList.length,
                                  itemBuilder: (context, index) {
                                    print("Length" +
                                        model.allSeasonVoteList.length
                                            .toString());
                                    return buildColumn(model, index);
                                  }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildColumn(TrackRecordViewModel model, int eachVoteNumber) {
    // eachVoteNumber = 모든 시즌 보트 리스트의 넘버링
    TextStyle tableSubjectTextStyle = TextStyle(
      fontSize: 15.sp,
      fontFamily: 'AppleSDL',
    );
    TextStyle tableVoteTextStyle = TextStyle(
      fontSize: 15.sp,
      fontFamily: 'AppleSDM',
    );
    TextStyle tableColumnStyle = TextStyle(
      fontSize: 12.sp,
      color: Colors.grey,
      fontFamily: 'AppleSDL',
    );

    print(eachVoteNumber);
    int userVoteIdx = model.allSeasonUserVoteList.indexWhere((element) =>
        element.voteDate == model.allSeasonVoteList[eachVoteNumber].voteDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.sp,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model.allSeasonVoteList[eachVoteNumber].voteDate!
                      .substring(0, 4) +
                  "." +
                  model.allSeasonVoteList[eachVoteNumber].voteDate!
                      .substring(4, 6) +
                  "." +
                  model.allSeasonVoteList[eachVoteNumber].voteDate!
                      .substring(6),
              style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'DmSans',
                // fontWeight: FontWeight.,
                letterSpacing: -1.0,
              ),
            ),
            Row(
              children: [
                userVoteIdx == -1
                    ? Container()
                    : model.allSeasonUserVoteList[userVoteIdx].score == null
                        ? Container()
                        : model.allSeasonUserVoteList[userVoteIdx].score == 0
                            ? Container()
                            : model.allSeasonUserVoteList[userVoteIdx].score! <
                                    0
                                ? Container(
                                    height: 13.h,
                                    width: 13.h,
                                    child: SvgPicture.asset(
                                      'assets/icons/arrow_down_icon.svg',
                                      color: Colors.blue,
                                    ),
                                  )
                                : Container(
                                    height: 13.h,
                                    width: 13.h,
                                    child: SvgPicture.asset(
                                      'assets/icons/arrow_up_icon.svg',
                                      color: Colors.red,
                                    ),
                                  ),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                  userVoteIdx == -1
                      ? "0"
                      : model.allSeasonUserVoteList[userVoteIdx].score == null
                          ? "-"
                          : model.allSeasonUserVoteList[userVoteIdx].score!
                              .abs()
                              .toString(),
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'DmSans',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.0,
                      color: userVoteIdx == -1
                          ? Colors.black
                          : model.allSeasonUserVoteList[userVoteIdx].score ==
                                  null
                              ? Colors.black
                              : model.allSeasonUserVoteList[userVoteIdx]
                                          .score ==
                                      0
                                  ? Colors.black
                                  : model.allSeasonUserVoteList[userVoteIdx]
                                              .score! <
                                          0
                                      ? Colors.blue
                                      : Colors.red),
                ),
              ],
            )
          ],
        ),
        Table(columnWidths: {
          0: FlexColumnWidth(2.0),
          1: FlexColumnWidth(1.0),
          2: FlexColumnWidth(1.0),

          // i want this one to take the rest available space
        }, children: [
          TableRow(
            children: [
              Text(
                "예측 주제",
                style: tableColumnStyle,
                textAlign: TextAlign.left,
              ),
              Text(
                "나의 투표",
                style: tableColumnStyle,
                textAlign: TextAlign.center,
              ),
              Text(
                "결과",
                style: tableColumnStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          TableRow(
            children: [
              Align(
                // alignment: Alignment.centerLeft,
                child: Column(
                    children: List.generate(
                        model
                            .allSeasonVoteList[eachVoteNumber].subVotes!.length,
                        (index)
                            // print(model.allSeasonVoteList[eachVoteNumber].toJson());
                            =>
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                model.allSeasonVoteList[eachVoteNumber]
                                    .subVotes![index].title!,
                                style: tableSubjectTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))),
              ),
              Column(
                children: List.generate(
                    model.allSeasonVoteList[eachVoteNumber].subVotes!.length,
                    (index) {
                  int userVoteIdx = model.allSeasonUserVoteList.indexWhere(
                      (element) =>
                          element.voteDate ==
                          model.allSeasonVoteList[eachVoteNumber].voteDate);
                  print("MATCHING IDX " + userVoteIdx.toString());
                  return Text(
                    userVoteIdx != -1
                        ? model.allSeasonUserVoteList[userVoteIdx]
                                    .voteSelected ==
                                null
                            ? "-"
                            : model.allSeasonUserVoteList[userVoteIdx]
                                        .voteSelected![index] ==
                                    0
                                ? "-"
                                : model.allSeasonUserVoteList[userVoteIdx]
                                            .voteSelected![index] ==
                                        1
                                    ? model.allSeasonVoteList[eachVoteNumber]
                                        .subVotes![index].voteChoices![0]
                                        .toString()
                                    : model.allSeasonVoteList[eachVoteNumber]
                                        .subVotes![index].voteChoices![1]
                                        .toString()
                        : "-",
                    style: tableVoteTextStyle,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),
              Column(
                children: List.generate(
                    model.allSeasonVoteList[eachVoteNumber].subVotes!.length,
                    (index) {
                  // int userVoteIdx = model.allSeasonUserVoteList.indexWhere(
                  //     (element) =>
                  //         element.voteDate ==
                  //         model.allSeasonVoteList[eachVoteNumber].voteDate);
                  // print("RESULT" +
                  //     model.allSeasonVoteList[eachVoteNumber].result.length
                  //         .toString());
                  // // return Text(")"); //

                  int answerIdx = model.allSeasonVoteList[eachVoteNumber]
                              .result!.length ==
                          0
                      ? -1
                      : model.allSeasonVoteList[eachVoteNumber].result![index];

                  return Text(
                    answerIdx < 0
                        ? "-"
                        : answerIdx == 0
                            ? "무승부"
                            : model.allSeasonVoteList[eachVoteNumber]
                                .subVotes![index].voteChoices![answerIdx - 1],
                    style: tableVoteTextStyle,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              )
            ],
          )
        ]),
        SizedBox(
          height: 8.sp,
        ),
        Divider(),
      ],
    );
  }
}

// class _TrackRecordViewState extends State<TrackRecordView> {
//   final NavigationService _navigationService = locator<NavigationService>();

//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
//     // ScreenUtil.init(context,
//     //     designSize: Size(375, 812), allowFontScaling: false);
//     return ViewModelBuilder<TrackRecordViewModel>.reactive(
//       viewModelBuilder: () => TrackRecordViewModel(),
//       builder: (context, model, child) {
//         if (model.isBusy) {
//           return Scaffold(
//             body: Container(
//               height: deviceHeight,
//               width: deviceWidth,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: deviceHeight / 2 - 100,
//                     child: Container(
//                       height: 100,
//                       width: deviceWidth,
//                       child: FlareActor(
//                         'assets/images/Loading.flr',
//                         animation: 'loading',
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         } else {
//           print("System Util " + 137.h.toString() + "  " + 40.sp.toString());
//           return Scaffold(
//             body: WillPopScope(
//               onWillPop: () async {
//                 _navigatorKey.currentState.maybePop();
//                 return false;
//               },
//               child: SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     top: 20,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     // crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: <Widget>[
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Text(
//                           "나의 예측기록",
//                           style: TextStyle(
//                             fontFamily: 'AppleSDEB',
//                             fontSize: 32.sp,
//                             letterSpacing: -2.0,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 16.h,
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 8.w,
//                           vertical: 4.h,
//                         ),
//                         // height: 150.h,
//                         color: Color(0xFF1EC8CF),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           // crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.topCenter,
//                                       child: avatarWidget(
//                                           model.user.avatarImage ?? 'avatar001',
//                                           model.user.item),
//                                     ),
//                                     SizedBox(
//                                       width: 8.sp,
//                                     ),
//                                     Column(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       mainAxisSize: MainAxisSize.max,
//                                       children: <Widget>[
//                                         Text(
//                                           model.userVote.userVoteStats
//                                                       .currentWinPoint ==
//                                                   null
//                                               ? 0.toString()
//                                               : model.userVote.userVoteStats
//                                                   .currentWinPoint
//                                                   .toString(),
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 40.sp,
//                                             fontFamily: 'DmSans',
//                                             height: 1,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                           softWrap: true,
//                                         ),

//                                         Text(
//                                           "현재 승점",
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 14.sp,
//                                             fontFamily: 'AppleSDM',
//                                           ),
//                                         ),
//                                         // SizedBox(
//                                         //   height: 12.sp,
//                                         // ),
//                                         //
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 8.sp,
//                                 ),
//                                 AutoSizeText(
//                                   model.user.userName,
//                                   style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 22.sp,
//                                     fontFamily: 'AppleSDB',
//                                   ),
//                                   maxLines: 1,
//                                 ),
//                               ],
//                             ),
//                             VerticalDivider(
//                               color: Colors.white,
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Column(
//                                   // mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "-",
//                                       style: TextStyle(
//                                         color: Color(0xFFE96F2B),
//                                         fontSize: 36.sp,
//                                         fontFamily: 'DmSans',
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       "나의 시즌 적중률",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12.sp,
//                                         fontFamily: 'DmSans',
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   // mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "-",
//                                       style: TextStyle(
//                                         color: Color(0xFFE96F2B),
//                                         fontSize: 20.sp,
//                                         fontFamily: 'DmSans',
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       "나의 누적 적중률",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12.sp,
//                                         fontFamily: 'DmSans',
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: <Widget>[
//                                 Column(
//                                   // mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "-",
//                                       style: TextStyle(
//                                         color: Color(0xFF3485FF),
//                                         fontSize: 36.sp,
//                                         fontFamily: 'DmSans',
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       "참여자 시즌 적중률",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12.sp,
//                                         fontFamily: 'DmSans',
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   // mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "-",
//                                       style: TextStyle(
//                                         color: Color(0xFF3485FF),
//                                         fontSize: 20.sp,
//                                         fontFamily: 'DmSans',
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     Text(
//                                       "참여자 누적 적중률",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 12.sp,
//                                         fontFamily: 'DmSans',
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 8.sp),
//                       Flexible(
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 16.sp,
//                           ),
//                           child: ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: model.allSeasonVoteList.length,
//                               itemBuilder: (context, index) {
//                                 print("Length" +
//                                     model.allSeasonVoteList.length.toString());
//                                 return buildColumn(model, index);
//                               }),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget buildColumn(TrackRecordViewModel model, int eachVoteNumber) {
//     TextStyle tableSubjectTextStyle = TextStyle(
//       fontSize: 15.sp,
//       fontFamily: 'AppleSDL',
//     );
//     TextStyle tableVoteTextStyle = TextStyle(
//       fontSize: 15.sp,
//       fontFamily: 'AppleSDM',
//     );
//     TextStyle tableColumnStyle = TextStyle(
//       fontSize: 12.sp,
//       color: Colors.grey,
//       fontFamily: 'AppleSDL',
//     );

//     print(eachVoteNumber);
//     int userVoteIdx = model.allSeasonUserVoteList.indexWhere((element) =>
//         element.voteDate == model.allSeasonVoteList[eachVoteNumber].voteDate);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 8.sp,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               model.allSeasonVoteList[eachVoteNumber].voteDate.substring(0, 4) +
//                   "." +
//                   model.allSeasonVoteList[eachVoteNumber].voteDate
//                       .substring(4, 6) +
//                   "." +
//                   model.allSeasonVoteList[eachVoteNumber].voteDate.substring(6),
//               style: TextStyle(
//                 fontSize: 20.sp,
//                 fontFamily: 'DmSans',
//                 // fontWeight: FontWeight.,
//                 letterSpacing: -1.0,
//               ),
//             ),
//             Row(
//               children: [
//                 userVoteIdx == -1
//                     ? Container()
//                     : model.allSeasonUserVoteList[userVoteIdx].score == null
//                         ? Container()
//                         : model.allSeasonUserVoteList[userVoteIdx].score == 0
//                             ? Container()
//                             : model.allSeasonUserVoteList[userVoteIdx].score < 0
//                                 ? Container(
//                                     height: 13.h,
//                                     width: 13.h,
//                                     child: SvgPicture.asset(
//                                       'assets/icons/arrow_down_icon.svg',
//                                       color: Colors.blue,
//                                     ),
//                                   )
//                                 : Container(
//                                     height: 13.h,
//                                     width: 13.h,
//                                     child: SvgPicture.asset(
//                                       'assets/icons/arrow_up_icon.svg',
//                                       color: Colors.red,
//                                     ),
//                                   ),
//                 SizedBox(
//                   width: 4.w,
//                 ),
//                 Text(
//                   userVoteIdx == -1
//                       ? "0"
//                       : model.allSeasonUserVoteList[userVoteIdx].score == null
//                           ? "-"
//                           : model.allSeasonUserVoteList[userVoteIdx].score
//                               .abs()
//                               .toString(),
//                   style: TextStyle(
//                       fontSize: 20.sp,
//                       fontFamily: 'DmSans',
//                       fontWeight: FontWeight.w700,
//                       letterSpacing: -1.0,
//                       color: userVoteIdx == -1
//                           ? Colors.black
//                           : model.allSeasonUserVoteList[userVoteIdx].score ==
//                                   null
//                               ? Colors.black
//                               : model.allSeasonUserVoteList[userVoteIdx]
//                                           .score ==
//                                       0
//                                   ? Colors.black
//                                   : model.allSeasonUserVoteList[userVoteIdx]
//                                               .score <
//                                           0
//                                       ? Colors.blue
//                                       : Colors.red),
//                 ),
//               ],
//             )
//           ],
//         ),
//         Table(columnWidths: {
//           0: FlexColumnWidth(2.0),
//           1: FlexColumnWidth(1.0),
//           2: FlexColumnWidth(
//               1.0), // i want this one to take the rest available space
//         }, children: [
//           TableRow(
//             children: [
//               Text(
//                 "예측 주제",
//                 style: tableColumnStyle,
//                 textAlign: TextAlign.left,
//               ),
//               Text(
//                 "나의 투표",
//                 style: tableColumnStyle,
//                 textAlign: TextAlign.center,
//               ),
//               Text(
//                 "결과",
//                 style: tableColumnStyle,
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           TableRow(
//             children: [
//               Align(
//                 // alignment: Alignment.centerLeft,
//                 child: Column(
//                     children: List.generate(
//                         model.allSeasonVoteList[eachVoteNumber].subVotes.length,
//                         (index)
//                             // print(model.allSeasonVoteList[eachVoteNumber].toJson());
//                             =>
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 model.allSeasonVoteList[eachVoteNumber]
//                                     .subVotes[index].title,
//                                 style: tableSubjectTextStyle,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ))),
//               ),
//               Column(
//                 children: List.generate(
//                     model.allSeasonVoteList[eachVoteNumber].subVotes.length,
//                     (index) {
//                   int userVoteIdx = model.allSeasonUserVoteList.indexWhere(
//                       (element) =>
//                           element.voteDate ==
//                           model.allSeasonVoteList[eachVoteNumber].voteDate);
//                   print("MATCHING IDX " + userVoteIdx.toString());
//                   return Text(
//                     userVoteIdx != -1
//                         ? model.allSeasonUserVoteList[userVoteIdx]
//                                     .voteSelected[index] ==
//                                 0
//                             ? "-"
//                             : model.allSeasonUserVoteList[userVoteIdx]
//                                         .voteSelected[index] ==
//                                     1
//                                 ? model.allSeasonVoteList[eachVoteNumber]
//                                     .subVotes[index].voteChoices[0]
//                                     .toString()
//                                 : model.allSeasonVoteList[eachVoteNumber]
//                                     .subVotes[index].voteChoices[1]
//                                     .toString()
//                         : "-",
//                     style: tableVoteTextStyle,
//                     overflow: TextOverflow.ellipsis,
//                   );
//                 }),
//               ),
//               Column(
//                 children: List.generate(
//                     model.allSeasonVoteList[eachVoteNumber].subVotes.length,
//                     (index) {
//                   // int userVoteIdx = model.allSeasonUserVoteList.indexWhere(
//                   //     (element) =>
//                   //         element.voteDate ==
//                   //         model.allSeasonVoteList[eachVoteNumber].voteDate);
//                   // print("RESULT" +
//                   //     model.allSeasonVoteList[eachVoteNumber].result.length
//                   //         .toString());
//                   // // return Text(")"); //

//                   int answerIdx =
//                       model.allSeasonVoteList[eachVoteNumber].result.length == 0
//                           ? -1
//                           : model
//                               .allSeasonVoteList[eachVoteNumber].result[index];

//                   return Text(
//                     answerIdx < 0
//                         ? "-"
//                         : answerIdx == 0
//                             ? "무승부"
//                             : model.allSeasonVoteList[eachVoteNumber]
//                                 .subVotes[index].voteChoices[answerIdx - 1],
//                     style: tableVoteTextStyle,
//                     overflow: TextOverflow.ellipsis,
//                   );
//                 }),
//               )
//             ],
//           )
//         ]),
//         SizedBox(
//           height: 8.sp,
//         ),
//         Divider(),
//       ],
//     );
//   }
// }
