import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/quest/time_counter_widget.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';
import '../../locator.dart';

class NewQuestWidget extends StatelessWidget {
  final QuestModel questModel;
  NewQuestWidget({
    Key? key,
    required this.questModel,
  }) : super(key: key);
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    double _width = 232.w;
    double _height = 344.w;

    return GestureDetector(
      onTap: () {
        _mixpanelService.mixpanel.track('New Quest', properties: {
          'New Quest ID': questModel.questId,
          'New Quest League ID': questModel.leagueId,
          'New Quest Title': questModel.title,
          'New Quest Category': questModel.category,
          'New Quest Select Mode': questModel.selectMode,
        });
        questModel.selectMode == 'survey'
            ? Get.toNamed('/survey', arguments: questModel)
            : questModel.selectMode == 'tutorial'
                ? Get.toNamed('/tutorial', arguments: questModel)
                : Get.toNamed('/quest', arguments: questModel);
      },
      child: Obx(() =>
          // 참여한 퀘스트
          Padding(
            padding: defaultHorizontalPadding,
            child: Container(
              padding: defaultPaddingAll,
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
                            "New",
                            buttonColor: yachtWhite,
                            textColor: yachtViolet,
                          ),
                          SizedBox(width: 6.w),
                          (userQuestModelRx.length > 0 &&
                                  userQuestModelRx.where((i) => i.questId == questModel.questId).isNotEmpty)
                              ? basicInfoButtion(
                                  "참여완료",
                                  buttonColor: yachtGrey,
                                  textColor: yachtMidGrey,
                                )
                              : SizedBox.shrink(),
                          SizedBox(width: 6.w),
                          basicInfoButtion(
                            "",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: yachtWhite,
                                  size: 16.w,
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                TimeCounterWidget(
                                  questModel: questModel,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/jogabi_without_circle.svg',
                            width: 24.w,
                            height: 24.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${questModel.itemNeeded}개',
                            style: TextStyle(
                              color: yachtWhite,
                              fontSize: 16.w,
                              // height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 8.w),
                  NewQuestHeader(questModel: questModel)
                ],
              ),
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
    //               padding: defaultHorizontalPadding,
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

class NewQuestHeader extends StatelessWidget {
  const NewQuestHeader({
    Key? key,
    required this.questModel,
    this.actionButton = true,
  }) : super(key: key);

  final QuestModel questModel;
  final bool actionButton;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${questModel.title}',
          style: TextStyle(
            color: yachtWhite,
            fontSize: 18.w,
            // fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.w),
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/manypeople.svg',
              width: 17.w,
              color: yachtWhite,
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
        SizedBox(height: 8.w),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            questModel.yachtPointSuccessReward == null
                ? SizedBox.shrink()
                : Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/gem.svg',
                        width: 24.w,
                        height: 24.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${toPriceKRW((questModel.yachtPointSuccessReward ?? 0) + (questModel.yachtPointParticipationReward ?? 0))}원',
                        style: questRewardAmoutStyle,
                      ),
                      SizedBox(width: 6.w),
                      (questModel.isYachtPointOneOfN == null)
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.w),
                              decoration: BoxDecoration(
                                color: buttonDisabled,
                                borderRadius: BorderRadius.circular(20.w),
                              ),
                              child: Text("1/N",
                                  style: TextStyle(
                                      color: yachtBlack, fontSize: 12.w, fontWeight: FontWeight.w600, height: 1.4)),
                            )
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
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.w),
                                  decoration: BoxDecoration(
                                    color: buttonDisabled,
                                    borderRadius: BorderRadius.circular(20.w),
                                  ),
                                  child: Text("1/N",
                                      style: TextStyle(
                                          color: yachtBlack, fontSize: 12.w, fontWeight: FontWeight.w600, height: 1.4)),
                                )
                    ],
                  ),
            SizedBox(
              width: 20.w,
            ),
            (questModel.leaguePointSuccessReward == null || questModel.leaguePointSuccessReward == 0)
                ? SizedBox.shrink()
                : Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/trophy.svg',
                        width: 24.w,
                        height: 24.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${toPriceKRW((questModel.leaguePointSuccessReward ?? 0) + (questModel.yachtPointParticipationReward ?? 0))}점',
                        style: questRewardAmoutStyle,
                      ),
                    ],
                  ),
            Spacer(),
            actionButton
                ? (userQuestModelRx.length > 0 &&
                        userQuestModelRx.where((i) => i.questId == questModel.questId).isNotEmpty)
                    ? basicActionButtion(
                        '변경하기',
                        buttonColor: yachtMidGrey,
                        textColor: yachtLightGrey,
                        wider: true,
                        fontSize: 16.w,
                      )
                    : basicActionButtion(
                        '참여하기',
                        buttonColor: yachtViolet,
                        wider: true,
                        fontSize: 16.w,
                      )
                : SizedBox.shrink()
          ],
        )
      ],
    );
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