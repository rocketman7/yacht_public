import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/services/timezone_service.dart';
import 'package:yachtOne/views/chart_forall_view.dart';

import '../locator.dart';
import 'chart_for_lunchtime_view.dart';
import 'constants/holiday.dart';
import 'constants/size.dart';
import 'widgets/customized_lite_rolling_switch/customized_lite_rolling_switch.dart';

import 'package:stacked/stacked.dart';

import 'package:yachtOne/view_models/lunchtime_event_view_model.dart';

class LunchtimeEventView extends StatefulWidget {
  final String lunchEventBaseDate;

  LunchtimeEventView(this.lunchEventBaseDate);
  @override
  _LunchtimeEventViewState createState() => _LunchtimeEventViewState();
}

class _LunchtimeEventViewState extends State<LunchtimeEventView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final TimezoneService _timezoneService = locator<TimezoneService>();
  UserVoteModel userVote;
  String lunchEventBaseDate;
  @override
  Widget build(BuildContext context) {
    var formatPrice = NumberFormat("#,###");
    var formatIndex = NumberFormat("#,###.00");
    Size size = MediaQuery.of(context).size;
    deviceHeight = size.height;
    deviceWidth = size.width;
    //나중에 아래 Screen Util initial 주석처리
    ScreenUtil.init(context,
        designSize: Size(375, 812), allowFontScaling: true);

    TextStyle _contentStyle = TextStyle(fontFamily: 'AppleSDB', fontSize: 18);

    return ViewModelBuilder.reactive(
        viewModelBuilder: () =>
            LunchtimeEventViewModel(widget.lunchEventBaseDate),
        builder: (context, model, child) {
          if (model.isBusy) {
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                        Color(0xFFC000C5),
                        Color(0xFFFF0057),
                        Color(0xFFFAA15E),
                        Color(0xFF91E0FD),
                        Color(0xFF91E0FD),
                        Color(0xFF2D5BFF)
                      ],
                          stops: [
                        0.0,
                        0.167,
                        0.333,
                        0.55,
                        0.8,
                        1.0,
                      ])),
                ),
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
            );
          } else {
            // List<int> prediction = model.userVote.voteSelected ??
            //     List.generate(
            //         model.lunchtimeVoteModel.subVotes.length, (index) => 1);
            DateTime endTime =
                model.lunchtimeVoteModel.voteEndDateTime.toDate();

            bool isEnded =
                endTime.isAfter(_timezoneService.koreaTime(DateTime.now()));
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                          Color(0xFFC000C5),
                          Color(0xFFFF0057),
                          Color(0xFFFAA15E),
                          Color(0xFF91E0FD),
                          Color(0xFF91E0FD),
                          Color(0xFF2D5BFF)
                        ],
                            stops: [
                          0.0,
                          0.167,
                          0.333,
                          0.55,
                          0.8,
                          1.0,
                        ])),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Navigator.of(_navigationService
                                        .navigatorKey.currentContext)
                                    .pop();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                  Container(width: 30),
                                ],
                              )),
                          AutoSizeText(
                            '점심시간 종가 예측 이벤트',
                            // "10월 12일 신성이엔지와 SK하이닉스중 더 많이 상승할 종목을 선택해주세요",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.sp,
                              letterSpacing: -0.5,
                              fontFamily: 'AppleSDB',
                            ),
                            maxLines: 3,
                            // fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          AutoSizeText(
                            '오늘 종가가 제시된 기준 가격보다\n상승할지 하락할지 예측해보세요!',
                            // "10월 12일 신성이엔지와 SK하이닉스중 더 많이 상승할 종목을 선택해주세요",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              letterSpacing: -0.5,
                              fontFamily: 'AppleSDM',
                            ),
                            maxLines: 2,
                            // fontWeight: FontWeight.w700),
                          ),
                          AutoSizeText(
                            model.lunchtimeVoteModel.voteNotice
                                .replaceAll("\\n", "\n"),
                            // "10월 12일 신성이엔지와 SK하이닉스중 더 많이 상승할 종목을 선택해주세요",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              letterSpacing: -0.5,
                              fontFamily: 'AppleSDM',
                            ),
                            maxLines: 2,
                            // fontWeight: FontWeight.w700),
                          ),
                          AutoSizeText(
                            '종가가 기준 가격과 같을 경우, 해당 종목은 정답처리 됩니다.',
                            // "10월 12일 신성이엔지와 SK하이닉스중 더 많이 상승할 종목을 선택해주세요",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14.sp,
                              letterSpacing: -0.5,
                              fontFamily: 'AppleSDM',
                            ),
                            maxLines: 1,
                            // fontWeight: FontWeight.w700),
                          ),
                          // AutoSizeText(
                          //   '오늘의 종가가 기준가격과 같으면, \n해당 종목 예측은 성공입니다.',
                          //   // "10월 12일 신성이엔지와 SK하이닉스중 더 많이 상승할 종목을 선택해주세요",
                          //   style: TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 18.sp,
                          //     letterSpacing: -0.5,
                          //     fontFamily: 'AppleSDM',
                          //   ),
                          //   maxLines: 2,
                          //   // fontWeight: FontWeight.w700),
                          // ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 40,
                            // color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    TopContainer(model),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      padding: EdgeInsets.all(4),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.all(
                                      //         Radius.circular(100.0)),
                                      //     color: Color(0xFF1EC8CF),
                                      //     border: Border.all(
                                      //         color: Colors.white,
                                      //         width: 2)),
                                      child: SvgPicture.asset(
                                        'assets/icons/dog_foot.svg',
                                        color: Color(0xFF1EC8CF),
                                        height: 14,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      (model.user.item == null)
                                          ? 0.toString()
                                          : (model.user.item).toString(),
                                      style: TextStyle(
                                        fontSize: 17,
                                        letterSpacing: -1.0,
                                        fontFamily: 'AppleSDB',
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          // Table(
                          //   columnWidths: {
                          //     0: FlexColumnWidth(2.0),
                          //     1: FlexColumnWidth(1.5),
                          //     2: FlexColumnWidth(1.5)
                          //   },
                          //   children: [
                          //     TableRow(
                          //       children: [
                          //         Text(
                          //           "종목명",
                          //           // style: tableColumnStyle,
                          //           textAlign: TextAlign.left,
                          //         ),
                          //         Text(
                          //           "기준 가격",
                          //           // style: tableColumnStyle,
                          //           textAlign: TextAlign.center,
                          //         ),
                          //         Align(
                          //           alignment: Alignment.center,
                          //           child: Text(
                          //             "종가 예측",
                          //             // style: tableColumnStyle,
                          //             textAlign: TextAlign.center,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //     TableRow(children: [
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       ),
                          //       SizedBox(
                          //         height: 10,
                          //       )
                          //     ]),
                          //     TableRow(children: [
                          //       Align(
                          //         alignment: Alignment.centerLeft,
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: List.generate(
                          //               model.lunchtimeVoteModel.subVotes
                          //                   .length, (index) {
                          //             bool isIndex = model.lunchtimeVoteModel
                          //                     .subVotes[index].indexOrStocks ==
                          //                 "index";
                          //             return Column(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: [
                          //                 AutoSizeText(
                          //                   model.lunchtimeVoteModel
                          //                       .subVotes[index].name,
                          //                   style: _contentStyle,
                          //                   textAlign: TextAlign.left,
                          //                 ),
                          //                 StreamBuilder(
                          //                   stream: model.getRealtimePrice(
                          //                       model.address,
                          //                       model.lunchtimeVoteModel
                          //                           .subVotes[index].issueCode),
                          //                   builder: (context, snapshot) {
                          //                     if (snapshot.data == null) {
                          //                       return Center(
                          //                           child: Container());
                          //                     } else {
                          //                       PriceModel price0;
                          //                       price0 = snapshot.data;
                          //                       return price0.pricePctChange < 0
                          //                           ? Text(
                          //                               isIndex
                          //                                   ? (formatIndex
                          //                                       .format(price0
                          //                                           .price)
                          //                                       .toString())
                          //                                   : (formatPrice
                          //                                       .format(price0
                          //                                           .price)
                          //                                       .toString()),
                          //                               style: TextStyle(
                          //                                 color:
                          //                                     Color(0xFF3485FF),
                          //                                 fontSize: 16,
                          //                               ),
                          //                             )
                          //                           : Text(
                          //                               isIndex
                          //                                   ? formatIndex
                          //                                       .format(price0
                          //                                           .price)
                          //                                       .toString()
                          //                                   : formatPrice
                          //                                       .format(price0
                          //                                           .price)
                          //                                       .toString(),
                          //                               style: TextStyle(
                          //                                 color:
                          //                                     Color(0xFFFF3E3E),
                          //                                 fontSize: 16,
                          //                                 height: 1,
                          //                               ),
                          //                             );
                          //                     }
                          //                   },
                          //                 ),
                          //               ],
                          //             );
                          //           }),
                          //         ),
                          //       ),
                          //       Column(
                          //         children: List.generate(
                          //             model.lunchtimeVoteModel.subVotes.length,
                          //             (index) {
                          //           bool isIndex = model.lunchtimeVoteModel
                          //                   .subVotes[index].indexOrStocks ==
                          //               "index";
                          //           return Column(
                          //             children: [
                          //               AutoSizeText(
                          //                 isIndex
                          //                     ? formatIndex
                          //                         .format(model
                          //                             .lunchtimeVoteModel
                          //                             .subVotes[index]
                          //                             .basePrice)
                          //                         .toString()
                          //                     : formatPrice
                          //                         .format(model
                          //                             .lunchtimeVoteModel
                          //                             .subVotes[index]
                          //                             .basePrice)
                          //                         .toString(),
                          //                 style: _contentStyle,
                          //                 textAlign: TextAlign.center,
                          //               ),
                          //               Text(
                          //                 " ",
                          //                 style: TextStyle(
                          //                   color: Color(0xFFFF3E3E),
                          //                   fontSize: 16,
                          //                   height: 1,
                          //                 ),
                          //               )
                          //             ],
                          //           );
                          //         }),
                          //       ),
                          //       Align(
                          //         alignment: Alignment.centerRight,
                          //         child: Column(
                          //           crossAxisAlignment: CrossAxisAlignment.end,
                          //           children: List.generate(
                          //               model.lunchtimeVoteModel.subVotes
                          //                   .length, (index) {
                          //             UserVoteModel userVote = model.userVote;
                          //             // 예측 버튼 활성화 해야하는지 여부
                          //             bool isEnabled = model.isEnabled;
                          //             return Column(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.end,
                          //               children: [
                          //                 Container(
                          //                   // color: Colors.yellow,
                          //                   // width: 80,
                          //                   height: 30,
                          //                   child: CustomizedLiteRollingSwitch(
                          //                     //initial value
                          //                     value:
                          //                         userVote.voteSelected == null
                          //                             ? true
                          //                             : userVote.voteSelected[
                          //                                         index] ==
                          //                                     1
                          //                                 ? true
                          //                                 : false,

                          //                     textOn: '상승',
                          //                     textOff: '하락',
                          //                     colorOn: Color(0xFFFF3E3E),
                          //                     colorOff: Color(0xFF3485FF),
                          //                     iconOn: Icons.arrow_upward,
                          //                     iconOff: Icons.arrow_downward,
                          //                     textSize: 14.0,
                          //                     isEnabled: isEnabled,
                          //                     onChanged: (bool state) {
                          //                       if (userVote.voteSelected ==
                          //                           null) {
                          //                         prediction[index] =
                          //                             state == true ? 1 : 2;
                          //                         //Use it to manage the different states
                          //                         print(
                          //                             'Current State of SWITCH IS: $state');
                          //                         print(prediction);
                          //                       }
                          //                     },
                          //                   ),
                          //                 ),
                          //                 Text(
                          //                   " ",
                          //                   style: TextStyle(
                          //                     color: Color(0xFFFF3E3E),
                          //                     fontSize: 16,
                          //                     height: 1,
                          //                   ),
                          //                 )
                          //               ],
                          //             );
                          //           }),
                          //         ),
                          //       )
                          //     ]),
                          //   ],
                          // ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  "종목명",
                                  // style: tableColumnStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  "기준 가격",
                                  // style: tableColumnStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Spacer(),
                              model.lunchtimeVoteModel.isShowingResult
                                  ? Container(
                                      // color: Colors.blue,
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                          "종가 예측",
                                          // style: tableColumnStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      // color: Colors.blue,
                                      width: 80,
                                      child: Center(
                                        child: Text(
                                          "종가 예측",
                                          // style: tableColumnStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                              model.lunchtimeVoteModel.isShowingResult
                                  ? Spacer()
                                  : Container(),
                              model.lunchtimeVoteModel.isShowingResult
                                  ? Container(
                                      // color: Colors.blue,
                                      width: 60,
                                      child: Center(
                                        child: Text(
                                          "결과",
                                          // style: tableColumnStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: ListView.builder(
                                itemCount:
                                    model.lunchtimeVoteModel.subVotes.length,
                                itemBuilder: (context, index) {
                                  // 인덱스인지 종목인지 체크
                                  bool isIndex = model.lunchtimeVoteModel
                                          .subVotes[index].indexOrStocks ==
                                      "index";
                                  // 유저보트 모델 가져와서 예측 기록 체크
                                  UserVoteModel userVote = model.userVote;
                                  // 예측 버튼 활성화 해야하는지 여부
                                  bool isEnabled = model.isEnabled;

                                  TextStyle _contentStyle = TextStyle(
                                      fontFamily: 'AppleSDB', fontSize: 18);
                                  return Container(
                                    // color: Colors.blue,
                                    // height: 70,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: GestureDetector(
                                            onTap: () {
                                              callNewModalBottomSheet(
                                                  context,
                                                  model
                                                      .lunchtimeVoteModel
                                                      .subVotes[index]
                                                      .issueCode,
                                                  model
                                                      .lunchtimeVoteModel
                                                      .subVotes[index]
                                                      .indexOrStocks,
                                                  model.address);
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                AutoSizeText(
                                                  model.lunchtimeVoteModel
                                                      .subVotes[index].name,
                                                  style: _contentStyle,
                                                  textAlign: TextAlign.left,
                                                ),
                                                StreamBuilder(
                                                  stream: model.getRealtimePrice(
                                                      model.address,
                                                      model
                                                          .lunchtimeVoteModel
                                                          .subVotes[index]
                                                          .issueCode),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data == null) {
                                                      return Center(
                                                          child: Container());
                                                    } else {
                                                      PriceModel price0;
                                                      price0 = snapshot.data;
                                                      return price0
                                                                  .pricePctChange <
                                                              0
                                                          ? Text(
                                                              isIndex
                                                                  ? (formatIndex
                                                                      .format(price0
                                                                          .price)
                                                                      .toString())
                                                                  : (formatPrice
                                                                      .format(price0
                                                                          .price)
                                                                      .toString()),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF3485FF),
                                                                fontSize: 16,
                                                              ),
                                                            )
                                                          : Text(
                                                              isIndex
                                                                  ? formatIndex
                                                                      .format(price0
                                                                          .price)
                                                                      .toString()
                                                                  : formatPrice
                                                                      .format(price0
                                                                          .price)
                                                                      .toString(),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFFFF3E3E),
                                                                fontSize: 16,
                                                                height: 1,
                                                              ),
                                                            );
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: AutoSizeText(
                                            isIndex
                                                ? formatIndex
                                                    .format(model
                                                        .lunchtimeVoteModel
                                                        .subVotes[index]
                                                        .basePrice)
                                                    .toString()
                                                : formatPrice
                                                    .format(model
                                                        .lunchtimeVoteModel
                                                        .subVotes[index]
                                                        .basePrice)
                                                    .toString(),
                                            style: _contentStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Spacer(),
                                        model.lunchtimeVoteModel.isShowingResult
                                            ? Container(
                                                width: 60,
                                                child: Center(
                                                    child: model.userVote
                                                                .voteSelected ==
                                                            null
                                                        ? Text("예측 안 함")
                                                        : model.userVote.voteSelected[
                                                                    index] ==
                                                                0
                                                            ? Text("-")
                                                            : model.userVote.voteSelected[
                                                                        index] ==
                                                                    1
                                                                ? Icon(
                                                                    Icons
                                                                        .arrow_upward,
                                                                    color: Color(
                                                                        0xFFFF3E3E),
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .arrow_downward,
                                                                    color: Color(
                                                                        0xFF3485FF),
                                                                  )))
                                            : Center(
                                                child: Container(
                                                  // color: Colors.yellow,
                                                  // width: 80,
                                                  height: 30,
                                                  child:
                                                      CustomizedLiteRollingSwitch(
                                                    //initial value
                                                    value: model.prediction[
                                                                index] ==
                                                            1
                                                        ? true
                                                        : false,

                                                    // userVote
                                                    //             .voteSelected ==
                                                    //         null
                                                    //     ? true
                                                    //     : userVote.voteSelected[
                                                    //                 index] ==
                                                    //             1
                                                    //         ? true
                                                    //         : false,

                                                    textOn: '상승',
                                                    textOff: '하락',
                                                    colorOn: Color(0xFFFF3E3E),
                                                    colorOff: Color(0xFF3485FF),
                                                    iconOn: Icons.arrow_upward,
                                                    iconOff:
                                                        Icons.arrow_downward,
                                                    textSize: 14.0,
                                                    isEnabled: isEnabled,
                                                    onChanged: (bool state) {
                                                      if (userVote
                                                              .voteSelected ==
                                                          null) {
                                                        model.prediction[
                                                                index] =
                                                            state == true
                                                                ? 1
                                                                : 2;
                                                        //Use it to manage the different states
                                                        print(
                                                            'Current State of SWITCH IS: $state');
                                                        print(model.prediction);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                        model.lunchtimeVoteModel.isShowingResult
                                            ? Spacer()
                                            : Container(),
                                        model.lunchtimeVoteModel.isShowingResult
                                            ? Container(
                                                width: 60,
                                                child: Center(
                                                    child: model.lunchtimeVoteModel
                                                                .result ==
                                                            null
                                                        ? Text("Not yet")
                                                        : model.lunchtimeVoteModel
                                                                        .result[
                                                                    index] ==
                                                                0
                                                            ? Icon(
                                                                Icons
                                                                    .horizontal_rule_rounded,
                                                              )
                                                            : model.lunchtimeVoteModel
                                                                            .result[
                                                                        index] ==
                                                                    1
                                                                ? Icon(
                                                                    Icons
                                                                        .arrow_upward,
                                                                    color: Color(
                                                                        0xFFFF3E3E),
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .arrow_downward,
                                                                    color: Color(
                                                                        0xFF3485FF),
                                                                  )),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () async {
                              await model.getLunchtimeVoteModel(model.address);
                              if (!model.checkIfInVotingTime()) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("예측이 마감되었습니다."),
                                      );
                                    });
                              } else if (model.userVote.voteSelected != null) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("이미 예측에 참여했습니다."),
                                      );
                                    });
                              } else if (model.user.item < 5) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("꾸욱 아이템이 부족합니다."),
                                      );
                                    });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      String btnLabel = "확인";
                                      String btnLabelCancel = "취소";
                                      String title = "종가 예측을 확정할까요?";

                                      return Platform.isAndroid
                                          ? MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      textScaleFactor: 1.0),
                                              child: AlertDialog(
                                                title: Text(title),
                                                content: Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: Text(
                                                            "제시된 기준 가격 대비",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'AppleSDM',
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                            )),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Container(
                                                        // height: double.maxFinite,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: List.generate(
                                                              model
                                                                  .lunchtimeVoteModel
                                                                  .subVotes
                                                                  .length,
                                                              (index) {
                                                            //       return Container(
                                                            // child:
                                                            return Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      model
                                                                          .lunchtimeVoteModel
                                                                          .subVotes[
                                                                              index]
                                                                          .name,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis),
                                                                  model.prediction[
                                                                              index] ==
                                                                          1
                                                                      ? Icon(
                                                                          Icons
                                                                              .arrow_upward,
                                                                          color:
                                                                              Color(0xFFFF3E3E),
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .arrow_downward,
                                                                          color:
                                                                              Color(0xFF3485FF),
                                                                        )
                                                                ],
                                                              ),
                                                            );
                                                            //   );
                                                          }),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      model.notifyListeners();
                                                    },
                                                    child: Text(
                                                      btnLabelCancel,
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      model.userVote
                                                              .voteSelected =
                                                          model.prediction;
                                                      model.userVote.isVoted =
                                                          true;
                                                      model.addUserVote(
                                                          model.uid,
                                                          model.userVote);
                                                      model.isEnabled = false;
                                                      model.updateUserItem(-5);
                                                      model.notifyListeners();
                                                      Navigator.pop(context);
                                                      // showDialog(
                                                      //     context: context,
                                                      //     builder: (context) {
                                                      //       return AlertDialog(
                                                      //         title: Text("예측완료 "),
                                                      //       );
                                                      //     });
                                                    },
                                                    child: Text(btnLabel),
                                                  )
                                                ],
                                              ),
                                            )
                                          : MediaQuery(
                                              data: MediaQuery.of(context)
                                                  .copyWith(
                                                      textScaleFactor: 1.0),
                                              child: CupertinoAlertDialog(
                                                title: Text(title),
                                                content: Container(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 10),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    10.0),
                                                        child: Text(
                                                            "제시된 기준 가격 대비",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'AppleSDM',
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                            )),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Container(
                                                        // height: double.maxFinite,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: List.generate(
                                                              model
                                                                  .lunchtimeVoteModel
                                                                  .subVotes
                                                                  .length,
                                                              (index) {
                                                            //       return Container(
                                                            // child:
                                                            return Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10.0),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      model
                                                                          .lunchtimeVoteModel
                                                                          .subVotes[
                                                                              index]
                                                                          .name,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis),
                                                                  model.prediction[
                                                                              index] ==
                                                                          1
                                                                      ? Icon(
                                                                          Icons
                                                                              .arrow_upward,
                                                                          color:
                                                                              Color(0xFFFF3E3E),
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .arrow_downward,
                                                                          color:
                                                                              Color(0xFF3485FF),
                                                                        )
                                                                ],
                                                              ),
                                                            );
                                                            //   );
                                                          }),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  CupertinoDialogAction(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      model.notifyListeners();
                                                    },
                                                    child: Text(
                                                      btnLabelCancel,
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                  CupertinoDialogAction(
                                                    onPressed: () {
                                                      model.userVote
                                                              .voteSelected =
                                                          model.prediction;
                                                      model.userVote.isVoted =
                                                          true;
                                                      model.addUserVote(
                                                          model.uid,
                                                          model.userVote);
                                                      model.isEnabled = false;
                                                      model.updateUserItem(-5);
                                                      model.notifyListeners();
                                                      Navigator.pop(context);
                                                      // showDialog(
                                                      //     context: context,
                                                      //     builder: (context) {
                                                      //       return AlertDialog(
                                                      //         title: Text("예측완료 "),
                                                      //       );
                                                      //     });
                                                    },
                                                    child: Text(btnLabel),
                                                  )
                                                ],
                                              ),
                                            );
                                    });

                                // model.userVote.voteSelected = prediction;
                                // model.userVote.isVoted = true;
                                // model.addUserVote(model.uid, model.userVote);
                                // model.isEnabled = false;
                                // model.notifyListeners();
                                // showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return AlertDialog(
                                //         title: Text("예측완료 "),
                                //       );
                                //     });
                              }
                            },
                            child: model.lunchtimeVoteModel.isShowingResult
                                ? Container()
                                : Container(
                                    height: 60,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(.1),
                                            offset: Offset(0, 4.0),
                                            blurRadius: 8.0,
                                          )
                                        ],
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(
                                          10,
                                        ))),
                                    // color: Colors.black,
                                    child: Center(
                                        child: model.checkingTimeFromServer
                                            ? CircularProgressIndicator(
                                                // valueColor: Colors.black,
                                                )
                                            : Text(
                                                !model.checkIfInVotingTime()
                                                    ? "예측 마감"
                                                    : model.userVote
                                                                .voteSelected !=
                                                            null
                                                        ? "이미 예측에 참여했습니다"
                                                        : "종가 예측하기 (꾸욱 5개 소모)",
                                                style: TextStyle(
                                                    height: 1,
                                                    fontSize: 23,
                                                    fontFamily: 'AppleSDB',
                                                    color: Colors.white))),
                                  ),
                          ),
                          SizedBox(height: 10),
                          // Row(
                          //   children: [
                          //     Text(
                          //       "삼성전자",
                          //       // style: tableColumnStyle,
                          //       textAlign: TextAlign.center,
                          //     ),
                          //     Text(
                          //       "85,500",
                          //       // style: tableColumnStyle,
                          //       textAlign: TextAlign.center,
                          //     ),
                          //     Text(
                          //       "상승",
                          //       // style: tableColumnStyle,
                          //       textAlign: TextAlign.center,
                          //     ),
                          //   ],
                          // )

                          // Table(
                          //   columnWidths: {
                          //     0: FlexColumnWidth(2.0),
                          //     1: FlexColumnWidth(2.0),
                          //     2: FlexColumnWidth(1.0)
                          //     // i want this one to take the rest available space
                          //   },
                          //   children: [
                          //     TableRow(children: [
                          //       Text(
                          //         "종목명",
                          //         // style: tableColumnStyle,
                          //         textAlign: TextAlign.center,
                          //       ),
                          //       Text(
                          //         "기준 가격",
                          //         // style: tableColumnStyle,
                          //         textAlign: TextAlign.center,
                          //       ),
                          //       Text(
                          //         "종가 예측",
                          //         // style: tableColumnStyle,
                          //         textAlign: TextAlign.center,
                          //       ),
                          //     ]),
                          //     TableRow(children: [
                          //       Column(
                          //         children: List.generate(
                          //           7,
                          //           (index) => Text(
                          //             "삼성전자",
                          //             style: TextStyle(
                          //               fontSize: 20,
                          //               fontFamily: 'AppleSDM',
                          //             ),
                          //             textAlign: TextAlign.center,
                          //           ),
                          //         ),
                          //       ),
                          //       Column(
                          //         children: List.generate(
                          //           7,
                          //           (index) => Text(
                          //             "85,500",
                          //             style: TextStyle(
                          //               fontSize: 20,
                          //               fontFamily: 'AppleSDM',
                          //             ),
                          //             textAlign: TextAlign.center,
                          //           ),
                          //         ),
                          //       ),
                          //       Column(
                          //         children: List.generate(
                          //           7,
                          //           (index) => Text(
                          //             "상승",
                          //             style: TextStyle(
                          //               fontSize: 20,
                          //               fontFamily: 'AppleSDM',
                          //             ),
                          //             textAlign: TextAlign.center,
                          //           ),
                          //         ),
                          //       )

                          //       // Text(
                          //       //   "85,500",
                          //       //   style: TextStyle(fontSize: 20),
                          //       //   textAlign: TextAlign.center,
                          //       // ),

                          //       // Text(
                          //       //   "상승",
                          //       //   style: TextStyle(fontSize: 20),
                          //       //   textAlign: TextAlign.center,
                          //       // ),
                          //     ])
                          //   ],
                          // )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        });
  }

  Future callNewModalBottomSheet(BuildContext context, String issueCode,
      String indexOrStocks, DatabaseAddressModel address) {
    ScrollController controller;
    StreamController scrollStreamCtrl = StreamController<double>();
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (
          context,
        ) =>
            StreamBuilder<double>(
                stream: scrollStreamCtrl.stream,
                initialData: 0,
                builder: (context, snapshot) {
                  double offset = snapshot.data;

                  if (offset < -140) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => Navigator.pop(context));
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 30,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 55,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Color(0xFFEBEBEB),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Container(
                        height: offset < 0
                            ? (deviceHeight * .83) + offset
                            : deviceHeight * .83,
                        child: ChartForLunchtimeView(scrollStreamCtrl,
                            issueCode, indexOrStocks, address),
                      ),
                    ],
                  );
                }));
  }
}

class TopContainer extends StatefulWidget {
  final LunchtimeEventViewModel viewModel;

  TopContainer(
    this.viewModel,
  );
  @override
  _TopContainerState createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {
  final TimezoneService _timezoneService = locator<TimezoneService>();
  Timer _timer;
  LunchtimeEventViewModel viewModel;
  DateTime nowFromNetwork;

  @override
  void dispose() {
    super.dispose();
    // dispose는 Navigator pushNamed에는 호출되지 않지만 백 버튼에는 호출됨.
    // 백 버튼에 아래를 호출하지 않으면 dispose 됐는데 setState한다고 오류뜸

    if (_timer.isActive) {
      _timer.cancel();
    }
    // isDisposed = true;
  }

  @override
  void initState() {
    super.initState();
    // Future getTimeFromNetwork() async {
    //   nowFromNetwork = await NTP.now();
    // }

    // defines a timer
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      // await model.renewTime();
      // // await model.renewTime();
      // nowFromNetwork = model.nowFromNetwork;
      // // getTimeFromNetwork();
      // // print("TIMER");
      // print("MODEL TIME" + model.nowFromNetwork.toString());

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    viewModel = widget.viewModel;
    Duration getTimeLeft(LunchtimeEventViewModel viewModel) {
      // DateTime today = strToDate(viewModel.address.date);
      // DateTime seoulMarketEnd = tz.TZDateTime(_timezoneService.seoul,
      //     today.year, today.month, today.day, 15, 30, 0);
      // DateTime marketEnd = seoulMarketEnd;
      // // tz.TZDateTime.from(seoulMarketEnd, _timezoneService.seoul);
      DateTime endTime = viewModel.lunchtimeVoteModel.voteEndDateTime.toDate();

      // DateTime nowFromNetwork = model.now;
      // model.renewTimeFromNetwork();
      // DateTime temp = DateTime(2020, 11, 22, 15, 52, 20);
      return _timezoneService
          .koreaTime(endTime)
          .difference(_timezoneService.koreaTime(DateTime.now()));
      // timeLeftArr = diffFinal.split(":");
      // return diffFinal;
    }

    Duration diff = getTimeLeft(viewModel).inSeconds < 0
        ? Duration(hours: 0, minutes: 0, seconds: 0)
        : getTimeLeft(viewModel);
    String strDurationHM =
        "${diff.inHours.toString().padLeft(2, '0')}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:";
    String strDurationSec =
        "${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
    var seoul = tz.getLocation('Asia/Seoul');

    // if (diff.inSeconds == 0 && model.address.isVoting == true) {
    //   _timer.cancel();
    //   model.getAllModel(model.uid);
    //   // widget.checkVoteTime();
    //   // model.isVoteAvailable();
    // }

    return diff == Duration(hours: 0, minutes: 0, seconds: 0)
        ? Row(
            children: [
              Text(
                "점심시간 종가 예측",
                style: TextStyle(
                  fontFamily: 'AppleSDM',
                  fontSize: 20.sp,
                  color: Color(0xFF3E3E3E),

                  // fontWeight: FontWeight.w500,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              viewModel.lunchtimeVoteModel.isShowingResult
                  ? Text(
                      " 결과 발표!",
                      style: TextStyle(
                        fontFamily: 'AppleSDB',
                        fontSize: 20.sp,
                        color: Color(0xFFE41818),

                        // fontWeight: FontWeight.w500,
                        letterSpacing: -1,
                        height: 1,
                      ),
                    )
                  : Text(
                      " 마감!",
                      style: TextStyle(
                        fontFamily: 'AppleSDM',
                        fontSize: 20.sp,
                        color: Color(0xFFE41818),

                        // fontWeight: FontWeight.w500,
                        letterSpacing: -1,
                        height: 1,
                      ),
                    ),
            ],
          )
        : Row(
            children: [
              Text(
                "예측 마감까지",
                style: TextStyle(
                  fontFamily: 'AppleSDM',
                  fontSize: 20.sp,
                  color: Color(0xFF3E3E3E),

                  // fontWeight: FontWeight.w500,
                  letterSpacing: -1,
                  height: 1,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              RichText(
                text: TextSpan(
                    text: strDurationHM.toString(),
                    style: TextStyle(
                      fontFamily: 'DmSans',
                      color: diff.inHours < 1
                          ? Color(0xFFE41818)
                          : Color(0xFF3E3E3E),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -.5,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: strDurationSec.toString(),
                          style: TextStyle(
                            fontFamily: 'DmSans',
                            color: diff.inHours < 1
                                ? Color(0xFFE41818)
                                : Colors.black45,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -.5,
                          ))
                    ]),
              ),
            ],
          );
  }
}
