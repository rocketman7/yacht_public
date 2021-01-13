import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/services/timezone_service.dart';

import '../locator.dart';
import 'constants/holiday.dart';
import 'constants/size.dart';
import 'widgets/customized_lite_rolling_switch/customized_lite_rolling_switch.dart';

import 'package:stacked/stacked.dart';

import 'package:yachtOne/view_models/lunchtime_event_view_model.dart';

class LunchtimeEventView extends StatefulWidget {
  @override
  _LunchtimeEventViewState createState() => _LunchtimeEventViewState();
}

class _LunchtimeEventViewState extends State<LunchtimeEventView> {
  UserVoteModel userVote;

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
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => LunchtimeEventViewModel(),
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
            List<int> prediction = List.generate(
                model.lunchtimeVoteModel.subVotes.length, (index) => 1);
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
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          SizedBox(
                            height: 12,
                          ),
                          Container(
                            height: deviceHeight * .1,
                            // color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "예측 마감까지",
                                      style: TextStyle(
                                        fontFamily: 'AppleSDM',
                                        fontSize: 17.sp,
                                        color: Color(0xFF3E3E3E),

                                        // fontWeight: FontWeight.w500,
                                        letterSpacing: -1,
                                        height: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
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
                            height: 12,
                          ),
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
                              Container(
                                width: 80,
                                child: Center(
                                  child: Text(
                                    "종가 예측",
                                    // style: tableColumnStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
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
                                  bool isIndex = model.lunchtimeVoteModel
                                          .subVotes[index].indexOrStocks ==
                                      "index";
                                  TextStyle _contentStyle = TextStyle(
                                      fontFamily: 'AppleSDB', fontSize: 18);
                                  return Container(
                                    // height: 70,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 5,
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
                                              Text("85,000"),
                                              SizedBox(
                                                height: 10,
                                              )
                                            ],
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
                                        Center(
                                          child: Container(
                                            // color: Colors.yellow,
                                            // width: 80,
                                            height: 30,
                                            child: CustomizedLiteRollingSwitch(
                                              //initial value
                                              value: true,

                                              textOn: '상승',
                                              textOff: '하락',
                                              colorOn: Color(0xFFFF3E3E),
                                              colorOff: Color(0xFF3485FF),
                                              iconOn: Icons.arrow_upward,
                                              iconOff: Icons.arrow_downward,
                                              textSize: 14.0,
                                              onChanged: (bool state) {
                                                prediction[index] =
                                                    state == true ? 1 : 2;
                                                //Use it to manage the different states
                                                print(
                                                    'Current State of SWITCH IS: $state');
                                                print(prediction);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              model.userVote.voteSelected = prediction;
                              model.userVote.isVoted = true;
                              model.addUserVote(model.uid, model.userVote);
                            },
                            child: Container(
                              height: deviceHeight * .1,
                              width: double.infinity,
                              color: Colors.yellow,
                              child: Center(
                                  child: Text(
                                "종가 예측완료!",
                                style: TextStyle(fontSize: 20),
                              )),
                            ),
                          )
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
      return endTime.difference(_timezoneService.koreaTime(DateTime.now()));
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

    return RichText(
      text: TextSpan(
          text: strDurationHM.toString(),
          style: TextStyle(
            fontFamily: 'DmSans',
            color: diff.inHours < 1 ? Color(0xFFE41818) : Color(0xFF3E3E3E),
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: -.5,
          ),
          children: <TextSpan>[
            TextSpan(
                text: strDurationSec.toString(),
                style: TextStyle(
                  fontFamily: 'DmSans',
                  color:
                      diff.inHours < 1 ? Color(0xFFE41818) : Color(0xFFC1C1C1),
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -.5,
                ))
          ]),
    );
  }
}
