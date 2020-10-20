import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/track_record_view_model.dart';

import '../locator.dart';
import 'constants/size.dart';
import 'widgets/avatar_widget.dart';

class TrackRecordView extends StatefulWidget {
  @override
  _TrackRecordViewState createState() => _TrackRecordViewState();
}

class _TrackRecordViewState extends State<TrackRecordView> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
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
            ),
          );
        } else {
          print("System Util " + 137.h.toString() + "  " + 40.sp.toString());
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 18,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              Navigator.of(_navigationService
                                      .navigatorKey.currentContext)
                                  .pop();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.arrow_back_ios,
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                "나의 지난 예측",
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontFamily: 'AppleSDEB',
                                  // fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 60.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Container(
                      padding: EdgeInsets.all(
                        8.sp,
                      ),
                      height: 137.h,
                      color: Color(0xFF1EC8CF),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: avatarWidget(
                                        model.user.avatarImage ?? 'avatar001',
                                        model.user.item),
                                  ),
                                  SizedBox(
                                    width: 8.sp,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Container(
                                        height: 40.sp,
                                        child: Text(
                                          model.userVote.userVoteStats
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
                                      ),
                                      Text(
                                        "현재 승점",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontFamily: 'AppleSDM',
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 12.sp,
                                      // ),
                                      //
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.sp,
                              ),
                              Text(
                                model.user.userName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontFamily: 'AppleSDB',
                                ),
                              ),
                            ],
                          ),
                          VerticalDivider(
                            color: Colors.white,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "53%",
                                    style: TextStyle(
                                      color: Color(0xFFE96F2B),
                                      fontSize: 40.sp,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "나의 시즌 적중률",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "47%",
                                    style: TextStyle(
                                      color: Color(0xFFE96F2B),
                                      fontSize: 25,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "나의 누적 적중률",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "53%",
                                    style: TextStyle(
                                      color: Color(0xFF3485FF),
                                      fontSize: 40.sp,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "참여자 시즌 적중률",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "47%",
                                    style: TextStyle(
                                      color: Color(0xFF3485FF),
                                      fontSize: 25,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    "참여자 누적 적중률",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.allSeasonVoteList.length,
                            itemBuilder: (context, index) {
                              print("Length" +
                                  model.allSeasonVoteList.length.toString());
                              return buildColumn(model, index);
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildColumn(TrackRecordViewModel model, int eachVoteNumber) {
    TextStyle tableTextStyle = TextStyle(
      fontSize: 15.sp,
      fontFamily: 'AppleSDB',
    );
    TextStyle tableColumnStyle = TextStyle(
      fontSize: 12.sp,
      color: Colors.grey,
      fontFamily: 'AppleSDL',
    );

    print(eachVoteNumber);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 8.sp,
        ),
        Text(
          model.allSeasonVoteList[eachVoteNumber].voteDate.substring(0, 4) +
              "." +
              model.allSeasonVoteList[eachVoteNumber].voteDate.substring(4, 6) +
              "." +
              model.allSeasonVoteList[eachVoteNumber].voteDate.substring(6),
          style: TextStyle(
            fontSize: 20.sp,
            fontFamily: 'DmSans',
            fontWeight: FontWeight.w700,
            letterSpacing: -1.0,
          ),
        ),
        Table(columnWidths: {
          0: FlexColumnWidth(2.0),
          1: FlexColumnWidth(1.0),
          2: FlexColumnWidth(
              1.0), // i want this one to take the rest available space
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
                        model.allSeasonVoteList[eachVoteNumber].subVotes.length,
                        (index)
                            // print(model.allSeasonVoteList[eachVoteNumber].toJson());
                            =>
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                model.allSeasonVoteList[eachVoteNumber]
                                    .subVotes[index].title,
                                style: tableTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))),
              ),
              Column(
                children: List.generate(
                    model.allSeasonVoteList[eachVoteNumber].subVotes.length,
                    (index) {
                  int userVoteIdx = model.allSeasonUserVoteList.indexWhere(
                      (element) =>
                          element.voteDate ==
                          model.allSeasonVoteList[eachVoteNumber].voteDate);
                  print("MATCHING IDX " + userVoteIdx.toString());
                  return Text(
                    userVoteIdx != -1
                        ? model.allSeasonUserVoteList[userVoteIdx]
                                    .voteSelected[index] ==
                                0
                            ? "-"
                            : model.allSeasonUserVoteList[userVoteIdx]
                                        .voteSelected[index] ==
                                    1
                                ? model.allSeasonVoteList[eachVoteNumber]
                                    .subVotes[index].voteChoices[0]
                                    .toString()
                                : model.allSeasonVoteList[eachVoteNumber]
                                    .subVotes[index].voteChoices[1]
                                    .toString()
                        : "-",
                    style: tableTextStyle,
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),
              Column(
                children: List.generate(
                    model.allSeasonVoteList[eachVoteNumber].subVotes.length,
                    (index) {
                  // int userVoteIdx = model.allSeasonUserVoteList.indexWhere(
                  //     (element) =>
                  //         element.voteDate ==
                  //         model.allSeasonVoteList[eachVoteNumber].voteDate);

                  int answerIdx =
                      model.allSeasonVoteList[eachVoteNumber].result[index] - 1;
                  return Text(
                    answerIdx < 0
                        ? "무승부"
                        : model.allSeasonVoteList[eachVoteNumber]
                            .subVotes[index].voteChoices[answerIdx],
                    style: tableTextStyle,
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
