import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/quest/live/live_widget_controller.dart';
import 'package:yachtOne/screens/quest/time_counter_widget.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../locator.dart';
import 'live/new_live_controller.dart';
import 'live/new_live_detail_view.dart';
import 'live/new_live_widget.dart';
import 'new_quest_widget.dart';

class NewLiveQuestWidget extends StatelessWidget {
  final QuestModel questModel;
  const NewLiveQuestWidget({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = 232.w;
    double _height = 344.w;

    // print('this user: $userQuestModel');
    return SquareQuestWidget(
      width: _width,
      height: _height,
      questModel: questModel,
    );
  }
}

class SquareQuestWidget extends StatelessWidget {
  final double width;
  final double height;
  final QuestModel questModel;

  SquareQuestWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.questModel,
  }) : super(key: key);

  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    final NewLiveController controller = Get.put(
      NewLiveController(questModel: questModel),
      tag: questModel.questId,
    );
    return GestureDetector(
      onTap: () {
        _mixpanelService.mixpanel.track('Live Quest', properties: {
          'New Quest ID': questModel.questId,
          'New Quest League ID': questModel.leagueId,
          'New Quest Title': questModel.title,
          'New Quest Category': questModel.category,
          'New Quest Select Mode': questModel.selectMode,
        });

        Get.to(
          () => NewLiveDetailView(
            questModel: questModel,
            controller: controller,
          ),
          // transition: Transition.downToUp,
        );
      },
      child: Padding(
          padding: primaryHorizontalPadding,
          child: Container(
            padding: primaryAllPadding,
            decoration: BoxDecoration(color: yachtDarkGrey, borderRadius: BorderRadius.circular(12.w)),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        basicInfoButtion(
                          "LIVE",
                          textColor: yachtRed,
                          buttonColor: Colors.black,
                        ),
                        SizedBox(width: 6.w),
                        (userQuestModelRx.length > 0 &&
                                userQuestModelRx.where((i) => i.questId == questModel.questId).isNotEmpty)
                            ? basicInfoButtion(
                                "참여완료",
                                buttonColor: yachtGrey,
                                textColor: yachtMidGrey,
                              )
                            : basicInfoButtion(
                                "미참여",
                                buttonColor: yachtGrey,
                              ),
                        SizedBox(width: 6.w),
                        basicInfoButtion(
                          "",
                          child: LiveTimeCounterWidget(
                            questModel: questModel,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/jogabi.svg',
                          width: 20.w,
                          height: 20.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${questModel.itemNeeded}개',
                          style: TextStyle(
                            color: white,
                            fontSize: 16.w,
                            // height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.w),
                // NewQuestHeader(questModel: questModel),
                // SizedBox(height: 8.w),
                PickoneLivePriceWidget(controller: controller),
                // (questModel.selectMode == "pickone" || questModel.selectMode == "order")
                //     // "pickone" 이나 "order" 일 때
                //     ? PickoneLivePriceWidget(controller: controller)
                //     // "updown 일 때"
                //     : UpdownLivePriceWidget(controller: controller),
              ],
            ),
          )),
    );

    // Stack(
    //   children: [
    //     // 퀘스트 카드 배경 일러스트
    //     Container(
    //       padding: EdgeInsets.all(16.w),
    //       // color: Colors.pink.withOpacity(.5),
    //       height: height,
    //       width: width,
    //       decoration: primaryBoxDecoration.copyWith(
    //         boxShadow: [primaryBoxShadow],
    //         color: homeModuleBoxBackgroundColor,
    //       ),
    //       child: Stack(
    //         alignment: Alignment(0, 0.3),
    //         children: [
    //           // SvgPicture.asset(
    //           //   'assets/illusts/quest/updown01.svg',
    //           //   width: 175.w,
    //           //   height: 160.w,
    //           // ),
    //           // SvgPicture.asset(
    //           //   'assets/illusts/quest/updown02.svg',
    //           //   width: 200.w,
    //           //   height: 106.w,
    //           // ),
    //         ],
    //       ),
    //     ),

    //     // 타이틀 내용 표시하는 부분
    //     Container(
    //         padding: moduleBoxPadding(questTermTextStyle.fontSize!),
    //         // color: Colors.pink.withOpacity(.5),
    //         height: height,
    //         width: width,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: [
    //             QuestCardHeader(questModel: questModel), // QuestCard내의 헤더부분
    //           ],
    //         )),
    //     Positioned(
    //       bottom: 0,
    //       child: Container(
    //         // color: Colors.blue,
    //         height: height,
    //         width: width,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             Padding(
    //               padding: primaryHorizontalPadding,
    //               child: QuestCardRewards(questModel: questModel),
    //             ),
    //             SizedBox(
    //               height: 20.w,
    //             ),
    //             Obx(() => Container(
    //                 height: 40.w,
    //                 width: double.infinity,
    //                 decoration: BoxDecoration(
    //                     color: Color(0xFFDCE9F4),
    //                     borderRadius: BorderRadius.only(
    //                         bottomLeft: Radius.circular(12.w),
    //                         bottomRight: Radius.circular(12.w))),
    //                 child: Center(
    //                   child: Text(
    //                     (userQuestModel.value == null || // 유저퀘스트모델 자체가 없거나
    //                             userQuestModel.value!.selectDateTime ==
    //                                 null) // 유저퀘스트모델 참여 기록이 없으면
    //                         ? "퀘스트 참여하기"
    //                         : "이미 참여한 퀘스트",
    //                     style: cardButtonTextStyle,
    //                   ),
    //                 )))
    //           ],
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}

class PickoneLivePriceWidget extends StatelessWidget {
  const PickoneLivePriceWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final NewLiveController controller;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      ...List.generate(controller.investmentModelLength, (index) {
        return Expanded(
          child: Container(
            // color: yachtBlue.withOpacity(.5),
            padding: EdgeInsets.only(right: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.w),
                Text(
                  controller.questModel.investAddresses![index].name,
                  style: stockPriceTextStyle.copyWith(
                    fontSize: 18.w,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                Obx(
                  () => Text(
                    toPriceKRW(controller.todayCurrentPrices[index]),
                    style: stockPriceTextStyle.copyWith(
                      fontSize: 26.w,
                    ),
                  ),
                ),

                // SizedBox(
                //   width: 2.w,
                // ),
                // Spacer(),
                // SizedBox(width: 4.w),

                Row(
                  children: [
                    Obx(
                      () => Text(
                        controller.getStandardPriceDone.value
                            ? toPriceKRW(
                                controller.todayCurrentPrices[index] - controller.yesterdayClosePrices[index],
                              )
                            : '-',
                        style: stockPriceTextStyle.copyWith(
                            fontSize: 14.w,
                            height: .8,
                            color: controller.todayCurrentPrices[index] - controller.yesterdayClosePrices[index] > 0
                                ? yachtRed
                                : controller.todayCurrentPrices[index] == controller.yesterdayClosePrices[index]
                                    ? white
                                    : yachtBlue),
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Obx(
                      () => Text(
                        controller.getStandardPriceDone.value
                            ? '(${toPercentageChange((controller.todayCurrentPrices[index] / controller.yesterdayClosePrices[index]) - 1)})'
                            : '',
                        // maxFontSize: 18.w,
                        // minFontSize: 12.w,
                        maxLines: 1,
                        style: stockPriceTextStyle.copyWith(
                            fontSize: 14.w,
                            height: .8,
                            color: controller.todayCurrentPrices[index] - controller.yesterdayClosePrices[index] > 0
                                ? yachtRed
                                : controller.todayCurrentPrices[index] == controller.yesterdayClosePrices[index]
                                    ? white
                                    : yachtBlue),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.questModel.investAddresses![0].basePrice == null
                          ? "기준일 ${dateTimeToString(controller.questModel.liveStartDateTime.toDate(), 4)} 대비"
                          : "기준가 ${toPriceKRW(controller.questModel.investAddresses![0].basePrice!)} 대비",
                      style: TextStyle(
                        color: yachtLightGrey,
                        fontSize: 14.w,
                      ),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            controller.getStandardPriceDone.value
                                ? toPriceKRW(
                                    controller.todayCurrentPrices[index] -
                                        (controller.questModel.investAddresses![index].basePrice ??
                                            controller.beforeLiveStartDateClosePrices[index]),
                                  )
                                : '-',
                            style: stockPriceTextStyle.copyWith(
                                fontSize: 14.w,
                                color: controller.todayCurrentPrices[index] -
                                            controller.beforeLiveStartDateClosePrices[index] >
                                        0
                                    ? yachtRed
                                    : controller.todayCurrentPrices[index] ==
                                            controller.beforeLiveStartDateClosePrices[index]
                                        ? white
                                        : yachtBlue),
                          ),
                          SizedBox(
                            width: 2.w,
                          ),
                          Text(
                            controller.getStandardPriceDone.value
                                ? '(${toPercentageChange((controller.todayCurrentPrices[index] / controller.beforeLiveStartDateClosePrices[index]) - 1)})'
                                : '',
                            style: stockPriceTextStyle.copyWith(
                              fontSize: 14.w,
                              color: controller.todayCurrentPrices[index] -
                                          controller.beforeLiveStartDateClosePrices[index] >
                                      0
                                  ? yachtRed
                                  : controller.todayCurrentPrices[index] ==
                                          controller.beforeLiveStartDateClosePrices[index]
                                      ? white
                                      : yachtBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // index == 0

                    // : SizedBox.shrink(),
                  ],
                )
              ],
            ),
          ),
        );
      }),
      controller.investmentModelLength == 1
          ? Expanded(
              child: Container(),
            )
          : SizedBox.shrink()
    ]);
  }
}

class QuestImage extends StatelessWidget {
  const QuestImage({
    Key? key,
    required this.questModel,
    // required FirebaseStorageService firebaseStorageService,
  }) : super(key: key);

  final QuestModel questModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82.w,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.w),
          color: questModel.themeColor == null ? Color(0xFFFFF3D3) : hexToColorCode(questModel.themeColor!)),
      // QuestModel 데이터가 imageUrl을 가지고 있으면 이미지 다운 받아서 표시
      child: Center(
          child: questModel.imageUrl == null
              ? Container()
              : Image.network(
                  "https://storage.googleapis.com/ggook-5fb08.appspot.com/${questModel.imageUrl!}",
                  height: 70.w,
                  // width: 50.w,
                  // fit: BoxFit.fitHeight,
                )),
    );
  }
}

class QuestCardHeader extends StatelessWidget {
  const QuestCardHeader({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  final QuestModel questModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // '${questModel.category} 퀘스트',
                  questModel.category,
                  style: questTerm,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/jogabi.svg',
                      height: 18.w,
                      width: 18.w,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      "${questModel.itemNeeded}개", // 퀘스트 모델 데이터랑 연동 되어야 함
                      style: jogabiNumberStyle.copyWith(fontSize: 13.w),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 6.w),
            Text(
              '${questModel.title}',
              style: questTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        SizedBox(
          height: correctHeight(10.w, sectionTitle.fontSize, questTimerStyle.fontSize),
        ),
        TimeToEndCounter(
          questModel: questModel,
        ),
        SizedBox(
          height: correctHeight(10.w, questTimerStyle.fontSize, questRewardTextStyle.fontSize),
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/manypeople.svg',
              width: 17.w,
              color: yachtBlack,
            ),
            SizedBox(width: 4.w),
            questModel.counts == null
                ? Text(
                    '0',
                    style: questRewardAmoutStyle.copyWith(fontSize: captionSize),
                  )
                : Text(
                    '${questModel.counts}',
                    // '${questModel.counts!.fold<int>(0, (previous, current) => previous + current)}',
                    style: questRewardAmoutStyle.copyWith(fontSize: captionSize),
                  )
          ],
        ),
      ],
    );
  }
}

class TimeToEndCounter extends StatefulWidget {
  final QuestModel questModel;
  TimeToEndCounter({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  @override
  State<TimeToEndCounter> createState() => _TimeToEndCounterState();
}

class _TimeToEndCounterState extends State<TimeToEndCounter> {
  // 타이머 1초마다 작동
  Timer? _everySecond;
  // 남은 시간 보여줌
  RxString timeToEnd = "".obs;
  DateTime now = DateTime.now();

  @override
  void initState() {
    _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {
      now = DateTime.now();
      timeLeft();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    if (_everySecond != null && _everySecond!.isActive) _everySecond!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void timeLeft() {
    if (widget.questModel.questEndDateTime == null) {
      timeToEnd("마감시한 없음");
    } else {
      Duration timeLeft = widget.questModel.questEndDateTime.toDate().difference(now);
      if (timeLeft.inSeconds > 0) {
        timeToEnd('${countDown(timeLeft)} 뒤 마감');
      } else {
        {
          timeToEnd('마감되었습니다');
        }
      }
    }
    // return countDown(timeLeft);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Text(
          timeToEnd.value, // temp
          style: questTimerStyle,
        ));
  }
}

class QuestCardRewards extends StatelessWidget {
  const QuestCardRewards({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  final QuestModel questModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 6.w,
        ),
        Container(
          // color: Colors.blue[100],
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/yacht_point_circle.png',
                width: 24.w,
                height: 24.w,
              ),
              SizedBox(width: 6.w),
              questModel.yachtPointSuccessReward == null
                  ? Container()
                  : Row(
                      // color: Colors.red[50],
                      children: [
                          Text(
                            '${toPriceKRW((questModel.yachtPointSuccessReward ?? 0) + (questModel.yachtPointParticipationReward ?? 0))}원',
                            style: questRewardAmoutStyle.copyWith(height: 1.35),
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          (questModel.isYachtPointOneOfN == null)
                              ? Text("n빵")
                              : !questModel.isYachtPointOneOfN!
                                  ? Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
                                      decoration: BoxDecoration(
                                        color: buttonDisabled,
                                        borderRadius: BorderRadius.circular(20.w),
                                      ),
                                      child: Text("ALL",
                                          style: TextStyle(
                                              color: yachtDarkGrey,
                                              fontSize: 12.w,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: krFont,
                                              height: 1.4)),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.w),
                                      decoration: BoxDecoration(
                                        color: buttonDisabled,
                                        borderRadius: BorderRadius.circular(20.w),
                                      ),
                                      child: Text("1/N",
                                          style: TextStyle(
                                              color: yachtDarkGrey,
                                              fontSize: 12.w,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: krFont,
                                              height: 1.4)),
                                    )
                        ])
            ],
          ),
        ),
        SizedBox(
          height: 6.w,
        ),
        Container(
          // color: Colors.blue[100],
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/league_point.svg',
                width: 24.w,
                height: 24.w,
              ),
              SizedBox(width: 6.w),
              Container(
                // color: Colors.red[50],
                child: Text(
                  '${(questModel.leaguePointSuccessReward ?? 0) + (questModel.leaguePointParticipationReward ?? 0)}점',
                  style: questRewardAmoutStyle.copyWith(height: 1.35),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

// 퀘스트 남은 시간 표기하는 Stateful Widget
// class QuestTimer extends StatefulWidget {
//   final QuestModel questModel;
//   const QuestTimer({
//     Key? key,
//     required this.questModel,
//   }) : super(key: key);

//   @override
//   _QuestTimerState createState() => _QuestTimerState();
// }

// class _QuestTimerState extends State<QuestTimer> {
//   Timer? _everySecond;
//   Rx<Duration> _timeLeft = Duration(
//     hours: 0,
//     minutes: 0,
//     seconds: 0,
//   ).obs;

//   void timeLeft(DateTime dateTime) {
//     _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {
//       DateTime now = DateTime.now();
//       Duration duration = dateTime.difference(now);
//       _timeLeft(duration);
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     timeLeft(widget.questModel.questEndDateTime.toDate());
//   }

//   @override
//   void dispose() {
//     _everySecond!.cancel();
//     // TODO: implement dispose

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print(widget.questModel);
//     return Obx(() => Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(Icons.timer_rounded),
//             // horizontalSpaceSmall,
//             SizedBox(width: 4),
//             Text(
//               countDown(_timeLeft.value),
//               style: contentStyle,
//             ),
//           ],
//         ));
//   }
// }



// class CircleQuestWidget extends StatelessWidget {
//   const CircleQuestWidget({
//     Key? key,
//     required double side,
//     required double thickness,
//     required double headerHeight,
//     required this.questModel,
//   })  : _side = side,
//         _thickness = thickness,
//         _headerHeight = headerHeight,
//         super(key: key);

//   final double _side;
//   final double _thickness;
//   final double _headerHeight;
//   final QuestModel questModel;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Stack(
//           children: [
//             // 테두리 포함한 서클
//             Container(
//               width: _side,
//               height: _side,
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: Colors.white.withOpacity(.5),
//                   width: _thickness,
//                 ),
//                 shape: BoxShape.circle,
//                 color: Color(0xFF01C8E5),
//               ),
//             ),
//             // 타이틀 헤더 컨테이너
//             ClipOval(
//               child: Container(
//                 // padding: EdgeInsets.all(5),
//                 width: _side,
//                 height: _side,
//                 decoration: BoxDecoration(
//                   // shape: BoxShape.circle,
//                   // color: Color(0xFF01C8E5),
//                   border: Border(
//                     top: BorderSide(
//                       color: Color(0xFF01A1DF),
//                       width: _headerHeight,
//                     ),
//                   ),
//                 ),
//                 // child: Container(
//                 //   color: Colors.amber,
//                 // ),
//               ),
//             ),

//             // 타이틀 내용 표시하는 부분
//             Container(
//               // color: Colors.pink.withOpacity(.5),
//               height: _headerHeight,
//               width: _side,
//               child: Center(
//                 // heightFactor: _headerHeight,
//                 child: Text(
//                   questModel.category,
//                   style: contentStyle.copyWith(
//                       color: Colors.white.withOpacity(.9),
//                       fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ),
//             Container(
//               height: _side,
//               width: _side,
//               child: Padding(
//                 padding: EdgeInsets.only(top: reactiveHeight(20)),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "${toPriceKRW(questModel.cashReward)}원",
//                       style: titleStyle.copyWith(
//                           color: Colors.black.withOpacity(.75)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//         verticalSpaceMedium,
//         QuestTimer(questModel: questModel)
//       ],
//     );
//   }
// }