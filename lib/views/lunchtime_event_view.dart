import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:yachtOne/view_models/lunchtime_event_view_model.dart';

class LunchtimeEventView extends StatefulWidget {
  @override
  _LunchtimeEventViewState createState() => _LunchtimeEventViewState();
}

class _LunchtimeEventViewState extends State<LunchtimeEventView> {
  @override
  Widget build(BuildContext context) {
    //나중에 아래 Screen Util initial 주석처리
    ScreenUtil.init(context,
        designSize: Size(375, 812), allowFontScaling: true);
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => LunchtimeEventViewModel(),
        builder: (context, model, child) {
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
                          '오늘 종가가 제시된 기준 가격보다\n상승할지 하락할지 예측해보세요!\n모든 종목의 방향을 맞추면 \nxxxx 1주를 드립니다.',
                          // "10월 12일 신성이엔지와 SK하이닉스중 더 많이 상승할 종목을 선택해주세요",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            letterSpacing: -0.5,
                            fontFamily: 'AppleSDM',
                          ),
                          maxLines: 4,
                          // fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 80,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "종목명",
                                // style: tableColumnStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "기준 가격",
                                // style: tableColumnStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "종가 예측",
                                // style: tableColumnStyle,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: ListView.builder(
                              itemCount: model.lunchtimeVoteList.length,
                              itemBuilder: (context, index) {
                                TextStyle _contentStyle = TextStyle(
                                    fontFamily: 'AppleSDB', fontSize: 20);
                                return Container(
                                  // height: 70,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              model.lunchtimeVoteList[index]
                                                  .name,
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
                                        flex: 1,
                                        child: Text(
                                          model.lunchtimeVoteList[index]
                                              .basePrice
                                              .toString(),
                                          style: _contentStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: ToggleSwitch(
                                          fontSize: 14,
                                          minHeight: 30,
                                          minWidth: 50.0,
                                          cornerRadius: 10.0,
                                          activeBgColor: Colors.cyan,
                                          activeFgColor: Colors.white,
                                          inactiveBgColor: Colors.grey,
                                          inactiveFgColor: Colors.white,
                                          labels: ['상승', '하락'],
                                          // icons: [
                                          //   FontAwesomeIcons.check,
                                          //   FontAwesomeIcons.times
                                          // ],
                                          onToggle: (index) {
                                            print('switched to: $index');
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          color: Colors.yellow,
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
        });
  }
}
