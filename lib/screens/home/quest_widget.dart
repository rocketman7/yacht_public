import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

class QuestWidget extends StatelessWidget {
  final QuestModel questModel;
  const QuestWidget({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _side = getProportionateScreenHeight(170);
    double _headerHeight = getProportionateScreenHeight(40);
    double _thickness = getProportionateScreenHeight(7);

    return
        //  SquareQuestWidget(
        //   side: _side,
        //   headerHeight: _headerHeight,
        //   questModel: questModel,
        // );

        CircleQuestWidget(
      side: _side,
      thickness: _thickness,
      headerHeight: _headerHeight,
      questModel: questModel,
    );
  }
}

class SquareQuestWidget extends StatelessWidget {
  const SquareQuestWidget({
    Key? key,
    required double side,
    required double headerHeight,
    required this.questModel,
  })  : _side = side,
        _headerHeight = headerHeight,
        super(key: key);

  final double _side;
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
                borderRadius: BorderRadius.circular(20),

                // shape: BoxShape.circle,
                color: Color(0xFF01C8E5),
              ),
            ),

            // 타이틀 내용 표시하는 부분
            Container(
              // color: Colors.pink.withOpacity(.5),
              height: _headerHeight,
              width: _side,

              decoration: BoxDecoration(
                  color: Color(0xff5399E0),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Center(
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
                padding: EdgeInsets.only(top: _headerHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "${toPriceKRW(questModel.cashReward)}원",
                      style: titleStyle.copyWith(
                          color: Colors.black.withOpacity(.75)),
                    ),
                    Divider(
                      color: Colors.white,
                    ),
                    Text(
                      "${toPriceKRW(questModel.pointReward)}점 ",
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
                padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
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
    print("timer rebuilt");
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
