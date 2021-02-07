import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../locator.dart';
import 'constants/size.dart';
import '../models/sharedPreferences_const.dart';
import '../services/sharedPreferences_service.dart';
import '../services/navigation_service.dart';
import '../view_models/portfolio_view_model.dart';

class PortfolioView extends StatefulWidget {
  @override
  _PortfolioViewState createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView>
    with TickerProviderStateMixin {
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  NavigationService _navigationService = locator<NavigationService>();
  AnimationController _chartAnimationController;
  Animation chartAnimation;

  AnimationController _itemAnimationController;
  Animation itemAnimation;

  //튜토리얼 관련된 애들
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();

  GlobalKey tutorialKey1 = GlobalKey();
  GlobalKey tutorialKey2 = GlobalKey();

  void initTutorialTargets() {
    // 여기서 튜토리얼 설명, ui 들을 설정
    targets.add(TargetFocus(
        identify: 'tutorial target 1',
        keyTarget: tutorialKey1,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('상금 포트폴리오',
                        style: TextStyle(
                            fontFamily: 'AppleSDB',
                            color: Colors.black,
                            fontSize: 28.0)),
                  ],
                ),
              )),
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            '이번 시즌 우승 상금을 구성하는 주식 포트폴리오입니다. 우승자가 되어 상금 주식의 주주가 되어보세요!',
                            style: TextStyle(
                                fontFamily: 'AppleSDM',
                                color: Colors.black,
                                fontSize: 18.0))),
                  ],
                ),
              ))
        ],
        enableOverlayTab: true,
        color: Color(0xFF1EC8CF),
        shape: ShapeLightFocus.Circle,
        paddingFocus: 0));
    targets.add(TargetFocus(
        identify: 'tutorial target 2',
        keyTarget: tutorialKey2,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('오늘 우승 상금의 가치는?',
                        style: TextStyle(
                            fontFamily: 'AppleSDB',
                            color: Colors.white,
                            fontSize: 28.0)),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            '매일 변하는 상금의 가치, 오늘은 얼마일까요?\n시즌 시작 이후의 상금 수익률도 함께 확인할 수 있어요!',
                            style: TextStyle(
                                fontFamily: 'AppleSDM',
                                color: Colors.white,
                                fontSize: 18.0))),
                  ],
                ),
              )),
        ],
        enableOverlayTab: true,
        color: Colors.red,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        paddingFocus: -5.0));
  }

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targets,
        colorShadow: Colors.transparent,
        textSkip: "도움말 종료하기",
        opacityShadow: 0.95, onFinish: () {
      _sharedPreferencesService.setSharedPreferencesValue(
          portfolioTutorialKey, true);
    }, onClickSkip: () {
      _sharedPreferencesService.setSharedPreferencesValue(
          portfolioTutorialKey, true);
    })
      ..show();
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }

  @override
  void initState() {
    initTutorialTargets();
    // WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    super.initState();

    _chartAnimationController =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    chartAnimation = Tween<double>(begin: 0.0, end: 100.0)
        .animate(_chartAnimationController);

    _chartAnimationController.addListener(() {
      setState(() {});
    });

    _itemAnimationController =
        AnimationController(duration: Duration(milliseconds: 70), vsync: this);
    itemAnimation =
        Tween<double>(begin: 0.0, end: 100.0).animate(_itemAnimationController);

    _itemAnimationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var returnFormat = NumberFormat("#0.00 %", "en_US");
    return ViewModelBuilder<PortfolioViewModel>.reactive(
        viewModelBuilder: () => PortfolioViewModel(),
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
            if (!_chartAnimationController.isCompleted)
              _chartAnimationController.forward();
            if (_chartAnimationController.isCompleted &&
                !_itemAnimationController.isCompleted)
              _itemAnimationController.forward();
            if (_chartAnimationController.isCompleted &&
                _itemAnimationController.isCompleted) {
              if (!model.portfolioTutorial) {
                WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
              }
            }

            return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                    ),
                    child: Column(
                      children: [
                        Row(
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
                                    Icon(Icons.arrow_back_ios),
                                    Container(width: 30),
                                  ],
                                )),
                            Spacer(),
                            Text(
                              "상금 포트폴리오 구성",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontFamily: 'AppleSDB',
                              ),
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Icon(Icons.arrow_back_ios, color: Colors.white),
                                Container(width: 30),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: showTutorial,
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black38,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 9.0,
                                          right: 8.0,
                                          top: 8.0,
                                          bottom: 8.0),
                                      child: Center(
                                        child: Text('?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: 'AppleSDM')),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 20,
                                    height: 30,
                                    // color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${model.getDateFormChange()} 종가 기준',
                              style: TextStyle(
                                fontFamily: 'DmSans',
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                            child: ListView(
                          children: [
                            SizedBox(
                              height: 40.h,
                            ),
                            Stack(
                              children: [
                                makePortfolioArc(model),
                                !_chartAnimationController.isCompleted
                                    ? AnimatedBuilder(
                                        animation: chartAnimation,
                                        builder: (context, child) {
                                          return CustomPaint(
                                            size: Size(deviceWidth - 64,
                                                deviceWidth - 64),
                                            painter: PortfolioArcChartLoading(
                                                center: Offset(
                                                    (deviceWidth - 64) / 2 + 16,
                                                    (deviceWidth - 64) / 2),
                                                percentage1:
                                                    model.startPercentage[0],
                                                percentage2:
                                                    model.startPercentage[0] +
                                                        chartAnimation.value),
                                          );
                                        })
                                    : Container(),
                                makePortfolioArcLine(model),
                                Center(
                                  key: tutorialKey1,
                                  child: Container(
                                    width: deviceWidth - 64,
                                    height: deviceWidth - 64,
                                    child: Center(
                                        child: Text(
                                      '${model.seasonModel.seasonName}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontFamily: 'AppleSDB'),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            // SizedBox(
                            //   height: 40.h,
                            // ),
                            SizedBox(
                              height: 24.h,
                            ),
                            _itemAnimationController.isCompleted
                                ? makePortfolioItems(model)
                                : Container(),
                          ],
                        )),
                        _itemAnimationController.isCompleted
                            ? Row(
                                key: tutorialKey2,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${model.getPortfolioValue()}원',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4.sp,
                                  ),
                                  Text(
                                    model.getPortfolioReturn() > 0
                                        ? '(+${returnFormat.format(model.getPortfolioReturn())})'
                                        : '(${returnFormat.format(model.getPortfolioReturn())})',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: 'DmSans',
                                        fontWeight: FontWeight.bold,
                                        color: model.getPortfolioReturn() < 0
                                            ? Color(0xFF3485FF)
                                            : Color(0xFFFF3E3E)),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 8.h),
                        _itemAnimationController.isCompleted
                            ? Text(
                                '시즌상금 가치 (누적 수익률)',
                                style: TextStyle(fontSize: 14.sp),
                              )
                            : Container(),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ));
          }
        });
  }
}

Widget makePortfolioArcLine(PortfolioViewModel model) {
  double portfolioArcRadius = deviceWidth - 64;
  double portfolioArcRadiusCenter = 100.sp;

  return Container(
    width: portfolioArcRadius,
    height: portfolioArcRadius,
    child: Stack(
      children: makePortfolioArcLineComponents(
          model, portfolioArcRadius, portfolioArcRadiusCenter),
    ),
  );
}

List<Widget> makePortfolioArcLineComponents(PortfolioViewModel model,
    double portfolioArcRadius, double portfolioArcRadiusCenter) {
  List<Widget> result = [];

  // 경계선 그리는 부분.
  result.add(
    CustomPaint(
      size: Size(
          (portfolioArcRadius - portfolioArcRadiusCenter) / 3 +
              portfolioArcRadiusCenter,
          (portfolioArcRadius - portfolioArcRadiusCenter) / 3 +
              portfolioArcRadiusCenter),
      painter: PortfolioArcLine(
          center: Offset(portfolioArcRadius / 2 + 16, portfolioArcRadius / 2),
          color: '000000',
          standartRadius:
              (portfolioArcRadius - portfolioArcRadiusCenter) / 3 * 2 +
                  portfolioArcRadiusCenter),
    ),
  );

  result.add(CustomPaint(
    size: Size(
        (portfolioArcRadius - portfolioArcRadiusCenter) / 3 * 2 +
            portfolioArcRadiusCenter,
        (portfolioArcRadius - portfolioArcRadiusCenter) / 3 * 2 +
            portfolioArcRadiusCenter),
    painter: PortfolioArcLine(
        center: Offset(portfolioArcRadius / 2 + 16, portfolioArcRadius / 2),
        color: '000000',
        standartRadius:
            (portfolioArcRadius - portfolioArcRadiusCenter) / 3 * 2 +
                portfolioArcRadiusCenter),
  ));

  result.add(CustomPaint(
    size: Size(portfolioArcRadius, portfolioArcRadius),
    painter: PortfolioArcLine(
        center: Offset(portfolioArcRadius / 2 + 16, portfolioArcRadius / 2),
        color: '000000',
        standartRadius:
            (portfolioArcRadius - portfolioArcRadiusCenter) / 3 * 2 +
                portfolioArcRadiusCenter),
  ));

  return result;
}

Widget makePortfolioArc(PortfolioViewModel model) {
  double portfolioArcRadius = deviceWidth - 64;
  double portfolioArcRadiusCenter = 100.sp;

  return Container(
    width: portfolioArcRadius,
    height: portfolioArcRadius,
    child: Stack(
      children: makePortfolioArcComponents(
          model, portfolioArcRadius, portfolioArcRadiusCenter),
    ),
  );
}

List<Widget> makePortfolioArcComponents(PortfolioViewModel model,
    double portfolioArcRadius, double portfolioArcRadiusCenter) {
  List<Widget> result = [];

  for (int i = 0; i < model.portfolioModel.subPortfolio.length; i++) {
    result.add(GestureDetector(
      onTap: () {
        print('$i 번째 component tap');
      },
      child: Container(
        // width: deviceWidth,
        // height: deviceHeight,
        child: CustomPaint(
          size: Size(
              portfolioArcRadiusCenter +
                  (portfolioArcRadius - portfolioArcRadiusCenter) /
                      3 *
                      model.valueIncreaseRatio[i],
              portfolioArcRadiusCenter +
                  (portfolioArcRadius - portfolioArcRadiusCenter) /
                      3 *
                      model.valueIncreaseRatio[i]),
          painter: PortfolioArcChart(
              center:
                  Offset(portfolioArcRadius / 2 + 16, portfolioArcRadius / 2),
              color: model.portfolioModel.subPortfolio[i].colorCode,
              percentage1: model.startPercentage[i],
              percentage2: model.startPercentage[i + 1]),
        ),
      ),
    ));
  }

  // result.add(GestureDetector(
  //   onTap: () {
  //     print('0번째 component tap');
  //   },
  //   child: Container(
  //     // width: deviceWidth,
  //     // height: deviceHeight,
  //     child: CustomPaint(
  //       size: Size(
  //           portfolioArcRadiusCenter +
  //               (portfolioArcRadius - portfolioArcRadiusCenter) /
  //                   3 *
  //                   model.valueIncreaseRatio[0],
  //           portfolioArcRadiusCenter +
  //               (portfolioArcRadius - portfolioArcRadiusCenter) /
  //                   3 *
  //                   model.valueIncreaseRatio[0]),
  //       painter: PortfolioArcChart(
  //           center: Offset(portfolioArcRadius / 2 + 16, portfolioArcRadius / 2),
  //           color: model.portfolioModel.subPortfolio[0].colorCode,
  //           percentage1: model.startPercentage[0],
  //           percentage2: model.startPercentage[0 + 1]),
  //     ),
  //   ),
  // ));

  result.add(CustomPaint(
    size: Size(portfolioArcRadiusCenter - 25, portfolioArcRadiusCenter - 25),
    painter: PortfolioArcChart(
        center: Offset(portfolioArcRadius / 2 + 16, portfolioArcRadius / 2),
        color: 'FFFFFF',
        percentage1: 0,
        percentage2: 100),
  ));

  return result;
}

Widget makePortfolioItems(PortfolioViewModel model) {
  return Column(
    children: makePortfolioItemsColumns(model),
  );
}

List<Widget> makePortfolioItemsColumns(PortfolioViewModel model) {
  List<Widget> result = [];

  for (int i = 0; i < model.portfolioModel.subPortfolio.length; i++) {
    if (model.drawingMaxLength[i]) {
      result.add(Container(
        height: 32.h,
        width: (deviceWidth - 32.h),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(int.parse(
                      'FF${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].colorCode}',
                      radix: 16))),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].stockName}',
              style: TextStyle(
                fontSize: 17.sp,
                height: 1,
                fontFamily: 'AppleSDM',
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].sharesNum}주',
              style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: 'AppleSDM',
                  height: 1,
                  textBaseline: TextBaseline.alphabetic,
                  color: Color(int.parse(
                      'FF${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].colorCode}',
                      radix: 16))),
            ),
          ],
        ),
      ));
    } else {
      if (i + 1 < model.portfolioModel.subPortfolio.length) {
        if (model.drawingMaxLength[i + 1]) {
          result.add(Container(
            height: 32,
            width: (deviceWidth - 32),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(int.parse(
                          'FF${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].colorCode}',
                          radix: 16))),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].stockName}',
                  style: TextStyle(
                    fontSize: 17.sp,
                    height: 1,
                    fontFamily: 'AppleSDM',
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].sharesNum}주',
                  style: TextStyle(
                      fontSize: 17.sp,
                      fontFamily: 'AppleSDM',
                      height: 1,
                      textBaseline: TextBaseline.alphabetic,
                      color: Color(int.parse(
                          'FF${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].colorCode}',
                          radix: 16))),
                ),
              ],
            ),
          ));
        } else {
          result.add(Row(
            children: [
              Container(
                height: 32,
                width: (deviceWidth - 32) / 2 - 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(
                              'FF${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].colorCode}',
                              radix: 16))),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].stockName}',
                      style: TextStyle(
                        fontSize: 17.sp,
                        height: 1,
                        fontFamily: 'AppleSDM',
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].sharesNum}주',
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: 'AppleSDM',
                          height: 1,
                          textBaseline: TextBaseline.alphabetic,
                          color: Color(int.parse(
                              'FF${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].colorCode}',
                              radix: 16))),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                height: 32,
                width: (deviceWidth - 32) / 2 - 10,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(
                              'FF${model.portfolioModel.subPortfolio[model.orderDrawingItem[i + 1]].colorCode}',
                              radix: 16))),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i + 1]].stockName}',
                      style: TextStyle(
                        fontSize: 17.sp,
                        height: 1,
                        fontFamily: 'AppleSDM',
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i + 1]].sharesNum}주',
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontFamily: 'AppleSDM',
                          height: 1,
                          textBaseline: TextBaseline.alphabetic,
                          color: Color(int.parse(
                              'FF${model.portfolioModel.subPortfolio[model.orderDrawingItem[i + 1]].colorCode}',
                              radix: 16))),
                    ),
                  ],
                ),
              ),
            ],
          ));

          i += 1;
        }
      } else {
        result.add(Container(
          height: 32,
          width: (deviceWidth - 32),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(int.parse(
                        'FF${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].colorCode}',
                        radix: 16))),
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].stockName}',
                style: TextStyle(
                  fontSize: 17.sp,
                  height: 1,
                  fontFamily: 'AppleSDM',
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].sharesNum}주',
                style: TextStyle(
                    fontSize: 17.sp,
                    fontFamily: 'AppleSDM',
                    height: 1,
                    textBaseline: TextBaseline.alphabetic,
                    color: Color(int.parse(
                        'FF${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].colorCode}',
                        radix: 16))),
              ),
            ],
          ),
        ));
      }
    }
  }

  return result;
}

class PortfolioArcChart extends CustomPainter {
  Offset center;
  String color;
  double percentage1 = 0;
  double percentage2 = 0;

  PortfolioArcChart(
      {this.center, this.color, this.percentage1, this.percentage2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(int.parse('FF$color', radix: 16))
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    if (percentage1 != 100) percentage1 = percentage1 % 100;
    if (percentage2 != 100) percentage2 = percentage2 % 100;

    if (percentage1 > percentage2) {
      double arcAngle1 = 2 * math.pi * (percentage1 / 100);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle1,
          2 * math.pi - arcAngle1, true, paint);

      double arcAngle2 = 2 * math.pi * (percentage2 / 100);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          2 * math.pi, arcAngle2, true, paint);
    } else {
      double arcAngle1 = 2 * math.pi * (percentage1 / 100);
      double arcAngle2 = 2 * math.pi * (percentage2 / 100);
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle1,
          arcAngle2 - arcAngle1, true, paint);
    }
  }

  @override
  bool shouldRepaint(PortfolioArcChart oldDelegate) {
    return false;
  }

  @override
  bool hitTest(Offset position) {
    // TODO: implement hitTest
    return super.hitTest(position);
  }

  // @override
  // bool hitTest(Offset position) {
  //   return paint.contains(position);
  // }
}

class PortfolioArcLine extends CustomPainter {
  Offset center;
  String color;
  double standartRadius;

  PortfolioArcLine({this.center, this.color, this.standartRadius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(int.parse('FF$color', radix: 16)).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final double radius = size.width / 2;

    double startAngle = 0;
    final double maxAngle = 2 * math.pi;
    final double space = 2 * math.pi / 200 * (standartRadius / size.width);

    while (startAngle < maxAngle) {
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startAngle, space, false, paint);

      startAngle += 2 * space;
    }
  }

  @override
  bool shouldRepaint(PortfolioArcLine oldDelegate) {
    return false;
  }
}

class PortfolioArcChartLoading extends CustomPainter {
  Offset center;
  double percentage1 = 0;
  double percentage2 = 0;

  PortfolioArcChartLoading({this.center, this.percentage1, this.percentage2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    double arcAngle1 = 2 * math.pi * (percentage1 / 100);
    double arcAngle2 = 2 * math.pi * (percentage2 / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle1,
        arcAngle2 - arcAngle1, true, paint);

    paint..color = Colors.white;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), arcAngle2,
        2 * math.pi - arcAngle2 + arcAngle1, true, paint);
  }

  @override
  bool shouldRepaint(PortfolioArcChartLoading oldDelegate) {
    return true;
  }
}
