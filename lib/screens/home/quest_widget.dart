import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestWidget extends StatelessWidget {
  final QuestModel questModel;
  const QuestWidget({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = 232.w;
    double _height = 338.w;

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
  final UserQuestModel? userQuestModel;

  const SquareQuestWidget(
      {Key? key,
      required this.width,
      required this.height,
      required this.questModel,
      this.userQuestModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 이 위젯에 해당하는 userQuestModel을 확인하고 userQuestModel에 넣어준다
    final Rxn<UserQuestModel> userQuestModel = Rxn<UserQuestModel>();
    // RxBool isUserQuestDone = false.obs;
    userQuestModelRx.listen((value) {
      // print('userQuestModelRx listening: $value');
      // print(value == null);
      if (value.isNotEmpty) {
        var temp = value.where((i) => i.questId == questModel.questId).first;
        userQuestModel(temp);
        // print('userQuestModel $userQuestModel');
      }
    });
    return Stack(
      children: [
        // 퀘스트 카드 배경 일러스트
        Container(
          padding: EdgeInsets.all(16.w),
          // color: Colors.pink.withOpacity(.5),
          height: height,
          width: width,
          decoration: primaryBoxDecoration.copyWith(
            boxShadow: [primaryBoxShadow],
            color: homeModuleBoxBackgroundColor,
          ),
          child: Stack(
            alignment: Alignment(0, 0.3),
            children: [
              // SvgPicture.asset(
              //   'assets/illusts/quest/updown01.svg',
              //   width: 175.w,
              //   height: 160.w,
              // ),
              // SvgPicture.asset(
              //   'assets/illusts/quest/updown02.svg',
              //   width: 200.w,
              //   height: 106.w,
              // ),
            ],
          ),
        ),

        // 타이틀 내용 표시하는 부분
        Container(
            padding: moduleBoxPadding(questTermTextStyle.fontSize!),
            // color: Colors.pink.withOpacity(.5),
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                QuestCardHeader(questModel: questModel), // QuestCard내의 헤더부분
              ],
            )),
        Positioned(
          bottom: 0,
          child: Container(
            // color: Colors.blue,
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: primaryHorizontalPadding,
                  child: QuestCardRewards(questModel: questModel),
                ),
                SizedBox(
                  height: 20.w,
                ),
                Obx(() => Container(
                    height: 40.w,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFFDCE9F4),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12.w),
                            bottomRight: Radius.circular(12.w))),
                    child: Center(
                      child: Text(
                        (userQuestModel.value == null || // 유저퀘스트모델 자체가 없거나
                                userQuestModel.value!.selectDateTime ==
                                    null) // 유저퀘스트모델 참여 기록이 없으면
                            ? "퀘스트 참여하기"
                            : "이미 참여한 퀘스트",
                        style: cardButtonTextStyle,
                      ),
                    )))
              ],
            ),
          ),
        )
      ],
    );
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        glassmorphismContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/manypeople.svg',
                    width: 20.w,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${questModel.counts!.fold<int>(0, (previous, current) => previous + current)}',
                    style: questRewardTextStyle,
                  )
                ],
              ),
              SizedBox(
                height: 6.w,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/yacht_point.svg',
                    width: 24.w,
                    height: 24.w,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${toPriceKRW(questModel.cashReward)}원',
                    style: questRewardTextStyle,
                  )
                ],
              ),
              SizedBox(
                height: 6.w,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/league_point.svg',
                    width: 24.w,
                    height: 24.w,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${questModel.pointReward}점',
                    style: questRewardTextStyle,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
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
                  '일간 퀘스트',
                  style: questTermTextStyle,
                ),
                Container(
                  width: textSizeGet("5개 소모", questTermTextStyle).width +
                      18.w +
                      4.w,
                  child: Row(
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
                        "5개 소모", // 퀘스트 모델 데이터랑 연동 되어야 함
                        style: questTermTextStyle.copyWith(
                            color: primaryFontColor),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
                height: reducedPaddingWhenTextIsBothSide(
                    18.w,
                    questTermTextStyle.fontSize!,
                    questTitleTextStyle.fontSize!)),
            Text(
              '${questModel.title}',
              style: questTitleTextStyle,
            )
          ],
        ),
        btwText(
          questTitleTextStyle.fontSize!,
          questTimeLeftTextStyle.fontSize!,
        ),
        Text(
          "01시간 24분 뒤 마감", // temp
          style: questTimeLeftTextStyle,
        )
      ],
    );
  }
}

class CircleQuestWidget extends StatelessWidget {
  const CircleQuestWidget({
    Key? key,
    required double side,
    required double thickness,
    required double headerHeight,
    required this.questModel,
  })  : _side = side,
        _thickness = thickness,
        _headerHeight = headerHeight,
        super(key: key);

  final double _side;
  final double _thickness;
  final double _headerHeight;
  final QuestModel questModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // 테두리 포함한 서클
            Container(
              width: _side,
              height: _side,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(.5),
                  width: _thickness,
                ),
                shape: BoxShape.circle,
                color: Color(0xFF01C8E5),
              ),
            ),
            // 타이틀 헤더 컨테이너
            ClipOval(
              child: Container(
                // padding: EdgeInsets.all(5),
                width: _side,
                height: _side,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  // color: Color(0xFF01C8E5),
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF01A1DF),
                      width: _headerHeight,
                    ),
                  ),
                ),
                // child: Container(
                //   color: Colors.amber,
                // ),
              ),
            ),

            // 타이틀 내용 표시하는 부분
            Container(
              // color: Colors.pink.withOpacity(.5),
              height: _headerHeight,
              width: _side,
              child: Center(
                // heightFactor: _headerHeight,
                child: Text(
                  questModel.category,
                  style: contentStyle.copyWith(
                      color: Colors.white.withOpacity(.9),
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            Container(
              height: _side,
              width: _side,
              child: Padding(
                padding: EdgeInsets.only(top: reactiveHeight(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${toPriceKRW(questModel.cashReward)}원",
                      style: titleStyle.copyWith(
                          color: Colors.black.withOpacity(.75)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        verticalSpaceMedium,
        QuestTimer(questModel: questModel)
      ],
    );
  }
}

// 퀘스트 남은 시간 표기하는 Stateful Widget
class QuestTimer extends StatefulWidget {
  final QuestModel questModel;
  const QuestTimer({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  @override
  _QuestTimerState createState() => _QuestTimerState();
}

class _QuestTimerState extends State<QuestTimer> {
  Timer? _everySecond;
  Rx<Duration> _timeLeft = Duration(
    hours: 0,
    minutes: 0,
    seconds: 0,
  ).obs;

  void timeLeft(DateTime dateTime) {
    _everySecond = Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      Duration duration = dateTime.difference(now);
      // print(duration);
      _timeLeft(duration);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timeLeft(widget.questModel.endDateTime.toDate());
  }

  @override
  void dispose() {
    _everySecond!.cancel();
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.questModel);
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.timer_rounded),
            // horizontalSpaceSmall,
            SizedBox(width: 4),
            Text(
              countDown(_timeLeft.value),
              style: contentStyle,
            ),
          ],
        ));
  }
}
