import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/chart/chart_view.dart';
import 'package:yachtOne/screens/quest/quest_view_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:get/get.dart';
import 'package:yachtOne/styles/style_constants.dart';

import 'decision_container.dart';

const double heightForSliverFlexibleSpace =
    kToolbarHeight + 220.0; // 당연히 기기마다 달라져야함. SliverFlexibleSpace를 위한 height
const double paddingForRewardText = 8.0; // 상금 주식 가치 텍스트 위의 패딩(마진)
const Color sliverAppBarColor = Color(0xFFD9D9D9);
const Color backgroundColor = Colors.white;

class QuestView extends StatelessWidget {
  // const QuestView({Key? key}) : super(key: key);

  // final ScrollController _scrollController =
  //     ScrollController(initialScrollOffset: 0.0);

  final stockInfoViewModel = Get.put(StockInfoKRViewModel());
  final questViewModel = Get.put(QuestViewModel());

  double appBarHeight = 0;
  double bottomBarHeight = 0;
  double offset = 0.0;

  @override
  Widget build(BuildContext context) {
    // streamSubscription =
    //     StockInfoKRView.streamController.stream.listen((event) {
    //   offset = event;
    //   localStreamController.add(offset);
    // });

    print("quest view rebuilt");

    // StreamController controller = StockInfoKRView
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
    // ));
    double localOffset = 0.0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Colors.blue, systemNavigationBarColor: Colors.blue),
      child: Scaffold(
        body: Column(
          children: [
            Obx(() {
              double offset = stockInfoViewModel.offset.value;
              double initialHeight = 200;
              appBarHeight = initialHeight - offset < kToolbarHeight + 50
                  ? kToolbarHeight + 50
                  : initialHeight - offset;

              // print(offset);
              // print(200 - appBarHeight);
              // print(snapshot.data);
              return Container(
                padding: EdgeInsets.only(top: kToolbarHeight),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xFF0099C2),
                      Color(0xFF01A1DF),
                      Color(0xFF01C8E5)
                    ])),
                // color: Colors.amber.withOpacity(.2),
                width: double.infinity,
                height: appBarHeight,
                child: GetBuilder<QuestViewModel>(
                    init: QuestViewModel(),
                    builder: (questViewModel) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text(
                          //   "리그 포인트 ${questViewModel.tempQuestModel.pointReward}점",
                          //   style: headingStyle,
                          // ),
                          // SizedBox(
                          //   child: Text(
                          //     "+",
                          //     style: subtitleStyle,
                          //   ),
                          //   // height: verticalSpaceSmall.height,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${toPriceKRW(questViewModel.tempQuestModel.cashReward)}원 + 3점",
                                style: bigTitleStyle.copyWith(
                                    color: Color(0xFFDBE9EE)),
                              ),
                              horizontalSpaceSmall,
                              Container(
                                height: 20,
                                width: 20,
                                // padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[700],
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Center(
                                  child: Text(
                                    "?",
                                    style: contentStyle.copyWith(
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          // verticalSpaceLarge,
                          // Text(
                          //   "${questViewModel.tempQuestModel.title}",
                          //   style: subtitleStyle,
                          // ),
                          verticalSpaceSmall,
                          Obx(
                            () => Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people,
                                      color: Color(0xFFDBE9EE),
                                    ),
                                    horizontalSpaceSmall,
                                    Text(
                                      "${questViewModel.tempQuestModel.count![0]}명 참여",
                                      style: subtitleStyle.copyWith(
                                          color: Color(0xFFDBE9EE)),
                                    ),
                                  ],
                                ),
                                verticalSpaceMedium,
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "예측 마감까지",
                                      style: contentStyle.copyWith(
                                          color: Color(0xFFDBE9EE)),
                                    ),
                                    horizontalSpaceSmall,
                                    Text(
                                      "${questViewModel.timeToEnd.value}",
                                      style: subtitleStyle.copyWith(
                                          color: Color(0xFFDBE9EE)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }),
              );
            }),
            Expanded(
                child: Stack(
              children: [
                Container(
                  // color: Colors.amber.withOpacity(.2),
                  child: ClipRRect(
                    // borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(50),
                    //     topRight: Radius.circular(50)),
                    child: Column(
                      children: [
                        Expanded(child: Container(child: StockInfoKRView())),
                        // Container(
                        //   height: 100,
                        //   color: Colors.yellow,
                        // )
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  double bottomPosition = 0.0;
                  double offset = stockInfoViewModel.offset.value;

                  bottomPosition =
                      (-120 + (offset * 2.5)) > 25 ? 25 : -120 + (offset * 2.5);
                  // print(offset);
                  return Positioned(
                    bottom: bottomPosition,
                    left: 25,
                    child: Align(
                      alignment: Alignment.center,
                      child: DecisionContainer(questViewModel),
                    ),
                  );
                }),
              ],
            )),
          ],
        ),

        // () => CustomScrollView(
        //   controller: stockInfoViewModel.scrollController.value,
        //   slivers: [
        //     SliverAppBar(
        //       expandedHeight: 150, // kToolbarHeight 다음부터의 height을 말함.
        //       backgroundColor: sliverAppBarColor, // 해당 상금 주식의 테마 색이 되어야함.
        //       pinned: true,
        //       elevation: 2, // appBar의 깊이.
        //       // elevation: 0, // appBar의 깊이.
        //       centerTitle: true,
        //       title: Text(
        //         '10,128,400원 - 요트 점수 Top 3',
        //         style: TextStyle(
        //           fontFamily: 'AppleSDL',
        //           fontSize: 18,
        //           letterSpacing: -2.0,
        //           // color: Colors.white,
        //         ),
        //         textAlign: TextAlign.start,
        //       ),
        //       // flexibleSpace: Container(
        //       //   height: 200,
        //       //   color: Colors.blue,
        //       // ),

        //       // flexibleSpace: SafeArea(
        //       //   child: Stack(
        //       //     children: [
        //       //       /*Positioned(
        //       //     top: _calculatePositioned(),
        //       //     child: Container(
        //       //       height: 287.0,
        //       //       width: 300,
        //       //       color: Colors.red,
        //       //     ),
        //       //   ),*/
        //       //       Positioned(
        //       //         top: paddingForRewardText + kToolbarHeight,
        //       //         child: Container(
        //       //           // width: deviceWidth,
        //       //           alignment: Alignment.center,
        //       //           child: Column(
        //       //             children: [
        //       //               Text(
        //       //                 '10,128,400원',
        //       //                 style: TextStyle(
        //       //                     color: Colors.white,
        //       //                     fontSize: 40,
        //       //                     fontFamily: 'AppleSDB'),
        //       //               ),
        //       //               SizedBox(
        //       //                 height: 24.0,
        //       //               ),
        //       //               Container(
        //       //                 height: 50,
        //       //                 // width: deviceWidth,
        //       //                 color: sliverAppBarColor,
        //       //               ),
        //       //               Container(
        //       //                 height: heightForSliverFlexibleSpace -
        //       //                     kToolbarHeight, // 안전하게 이정도. 밑에 영역 크기를 정확히 계산할 수 없으므로 걍 넘겨버린다.
        //       //                 // width: deviceWidth,
        //       //                 color: backgroundColor,
        //       //               ),
        //       //             ],
        //       //           ),
        //       //         ),
        //       //       ),
        //       //       Positioned(
        //       //         top: paddingForRewardText + kToolbarHeight,
        //       //         child: Container(
        //       //           // width: deviceWidth,
        //       //           alignment: Alignment.center,
        //       //           child: Column(
        //       //             children: [
        //       //               Text(
        //       //                 '0,000,000원',
        //       //                 style: TextStyle(
        //       //                     color: Colors.transparent,
        //       //                     fontSize: 40,
        //       //                     fontFamily: 'AppleSDB'),
        //       //               ),
        //       //               SizedBox(
        //       //                 height: 24.0,
        //       //               ),
        //       //               // Container(
        //       //               //   height: 25,
        //       //               //   width: deviceWidth,
        //       //               // ),
        //       //               Row(children: [
        //       //                 SizedBox(
        //       //                   width: 16.0,
        //       //                 ),
        //       //                 Column(
        //       //                   children: [
        //       //                     Container(
        //       //                       height: 25,
        //       //                     ),
        //       //                     Container(
        //       //                       height: 50,
        //       //                       width: 50,
        //       //                       // color: Colors.black,
        //       //                       child: SvgPicture.asset(
        //       //                         'assets/icons/bottom_chat.svg',
        //       //                         width: 50,
        //       //                         height: 50,
        //       //                       ),
        //       //                     ),
        //       //                   ],
        //       //                 ),
        //       //                 Spacer(),
        //       //                 Container(
        //       //                   height: 80,
        //       //                   width: 80,
        //       //                   child: SvgPicture.asset(
        //       //                     'assets/icons/bottom_chat.svg',
        //       //                     width: 80,
        //       //                     height: 80,
        //       //                   ),
        //       //                 ),
        //       //                 Spacer(),
        //       //                 Column(
        //       //                   children: [
        //       //                     Container(
        //       //                       height: 25,
        //       //                     ),
        //       //                     Container(
        //       //                       height: 50,
        //       //                       width: 50,
        //       //                       // color: Colors.black,
        //       //                       child: SvgPicture.asset(
        //       //                         'assets/icons/bottom_chat.svg',
        //       //                         width: 50,
        //       //                         height: 50,
        //       //                       ),
        //       //                     ),
        //       //                   ],
        //       //                 ),
        //       //                 SizedBox(
        //       //                   width: 16.0,
        //       //                 ),
        //       //               ]),
        //       //               SizedBox(
        //       //                 height: 24.0,
        //       //               ),
        //       //               Container(
        //       //                 height: 9.0,
        //       //                 width: 9.0 * 4 + 14.0 * 3,
        //       //                 child: Stack(children: [
        //       //                   Positioned(
        //       //                     top: 0.0,
        //       //                     left: 0.0,
        //       //                     child: Container(
        //       //                       decoration: BoxDecoration(
        //       //                         shape: BoxShape.circle,
        //       //                         color: Color(0xFFC4C4C4),
        //       //                       ),
        //       //                       height: 9.0,
        //       //                       width: 9.0,
        //       //                     ),
        //       //                   ),
        //       //                   Positioned(
        //       //                     top: 0.0,
        //       //                     left: 9.0 * 1 + 14.0 * 1,
        //       //                     child: Container(
        //       //                       decoration: BoxDecoration(
        //       //                         shape: BoxShape.circle,
        //       //                         color: Colors.black,
        //       //                         // color: Color(0xFFC4C4C4),
        //       //                       ),
        //       //                       height: 9.0,
        //       //                       width: 9.0,
        //       //                     ),
        //       //                   ),
        //       //                   Positioned(
        //       //                     top: 0.0,
        //       //                     left: 9.0 * 2 + 14.0 * 2,
        //       //                     child: Container(
        //       //                       decoration: BoxDecoration(
        //       //                         shape: BoxShape.circle,
        //       //                         color: Colors.black,
        //       //                         // color: Color(0xFFC4C4C4),
        //       //                       ),
        //       //                       height: 9.0,
        //       //                       width: 9.0,
        //       //                     ),
        //       //                   ),
        //       //                   Positioned(
        //       //                     top: 0.0,
        //       //                     left: 9.0 * 3 + 14.0 * 3,
        //       //                     child: Container(
        //       //                       decoration: BoxDecoration(
        //       //                         shape: BoxShape.circle,
        //       //                         color: Color(0xFFC4C4C4),
        //       //                       ),
        //       //                       height: 9.0,
        //       //                       width: 9.0,
        //       //                     ),
        //       //                   ),
        //       //                   Positioned(
        //       //                     top: 0.0,
        //       //                     left: 9.0 * 1 + 14.0 * 1 + 4.5,
        //       //                     child: Container(
        //       //                       height: 9.0,
        //       //                       width: 23.0,
        //       //                       color: Colors.black,
        //       //                     ),
        //       //                   ),
        //       //                 ]),
        //       //               ),
        //       //             ],
        //       //           ),
        //       //         ),
        //       //       ),
        //       //       // 앱바를 가리지 않기 위해 덮어씌워주는.
        //       //       Positioned(
        //       //           top: 0.0,
        //       //           child: Opacity(
        //       //             opacity: 1.0,
        //       //             child: Container(
        //       //               height: kToolbarHeight,
        //       //               // width: deviceWidth,
        //       //               color: sliverAppBarColor,
        //       //             ),
        //       //           )),
        //       //       // Positioned(
        //       //       //     top: kToolbarHeight,
        //       //       //     child: Opacity(
        //       //       //         opacity: _calculateOpacity(),
        //       //       //         child: Container(
        //       //       //           height: 1,
        //       //       //           width: deviceWidth,
        //       //       //           color: Colors.black,
        //       //       //         ))),
        //       //       // Positioned(
        //       //       //   top: kToolbarHeight + _calculatePositioned(),
        //       //       //   child: Container(
        //       //       //     height: 32.0,
        //       //       //     width: 100,
        //       //       //     color: Colors.black,
        //       //       //   ),
        //       //       // )
        //       //     ],
        //       //   ),
        //       // ),
        //     ),
        //     // SliverAppBar(),
        //     SliverToBoxAdapter(
        //       child: Container(height: 1000, child: StockInfoKRView()),
        //     )
        //     // Container(
        //     //   height: 100,
        //     //   color: Colors.blueGrey.shade50,
        //     // ),
        //     // Container(height: 600, child: StockInfoKRView()),
        //   ],
        // ),
      ),
    );
  }
}
