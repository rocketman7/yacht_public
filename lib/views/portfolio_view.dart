import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'dart:ui';
import 'dart:math' as math;

import '../locator.dart';
import 'constants/size.dart';
import '../view_models/portfolio_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PortfolioView extends StatefulWidget {
  @override
  _PortfolioViewState createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView>
    with TickerProviderStateMixin {
  NavigationService _navigationService = locator<NavigationService>();
  AnimationController _chartAnimationController;
  Animation chartAnimation;

  AnimationController _itemAnimationController;
  Animation itemAnimation;

  @override
  void initState() {
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

            return Scaffold(
                backgroundColor: Colors.white,
                body: Stack(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          top: 18.h,
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0),
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
                                        "상금 포트폴리오 구성",
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
                                  width: 52.w,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Container(
                                //   height: 8,
                                //   width: 1,
                                //   color: Color(0xFFD8D8D8),
                                // ),
                                // SizedBox(
                                //   width: 8,
                                // ),
                                // Text(
                                //   '${model.seasonModel.seasonName}',
                                //   style: TextStyle(
                                //     fontFamily: 'AppleSDM',
                                //     fontSize: 16.sp,
                                //   ),
                                // ),

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
                                                        (deviceWidth - 64) / 2 +
                                                            16,
                                                        (deviceWidth - 64) / 2),
                                                    percentage1: model
                                                        .startPercentage[0],
                                                    percentage2:
                                                        model.startPercentage[
                                                                0] +
                                                            chartAnimation
                                                                .value),
                                              );
                                            })
                                        : Container(),
                                    makePortfolioArcLine(model),
                                    Center(
                                      child: Container(
                                        width: deviceWidth - 64,
                                        height: deviceWidth - 64,
                                        child: Center(
                                            child: Text(
                                          '${model.seasonModel.seasonName}',
                                          // '${model.getSeasonUpperCase()}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontFamily: 'AppleSDB'),
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40.h,
                                ),
                                _itemAnimationController.isCompleted
                                    ? makePortfolioItems(model)
                                    : Container(),
                              ],
                            )),
                            // SizedBox(height: 18),
                            _itemAnimationController.isCompleted
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${model.getPortfolioValue()}원',
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontFamily: 'DmSans',
                                          fontWeight: FontWeight.bold,
                                          // letterSpacing: -1.0,
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
                                            color:
                                                model.getPortfolioReturn() > 0
                                                    ? Color(0xFFFF3E3E)
                                                    : Color(0xFF3485FF)),
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
                            // GestureDetector(
                            //   onTap: () {
                            //     var unixTimestamp = DateTime.now();

                            //     print(unixTimestamp);
                            //   },
                            //   // child: Text('dfswe'),
                            // )
                          ],
                        ),
                      ),
                    ),
                    model.portfolioTutorial
                        ? Container()
                        : model.tutorialStatus != 0
                            ? tutorial(model)
                            : Container(),
                  ],
                ));
          }
        });
  }
}

Widget makePortfolioArcLine(PortfolioViewModel model) {
  double portfolioArcRadius = deviceWidth - 64;
  const double portfolioArcRadiusCenter = 112;

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
          color: 'B2B7BE',
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
        color: 'B2B7BE',
        standartRadius:
            (portfolioArcRadius - portfolioArcRadiusCenter) / 3 * 2 +
                portfolioArcRadiusCenter),
  ));

  return result;
}

Widget makePortfolioArc(PortfolioViewModel model) {
  double portfolioArcRadius = deviceWidth - 64;
  double portfolioArcRadiusCenter = 80.sp;

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
    result.add(InkWell(
      onTap: () {
        print('$i 번째 component tap');
      },
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
            center: Offset(portfolioArcRadius / 2 + 16, portfolioArcRadius / 2),
            color: model.portfolioModel.subPortfolio[i].colorCode,
            percentage1: model.startPercentage[i],
            percentage2: model.startPercentage[i + 1]),
      ),
    ));
  }

  result.add(CustomPaint(
    size: Size(portfolioArcRadiusCenter, portfolioArcRadiusCenter),
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
              style: TextStyle(fontSize: 18, fontFamily: 'DmSans'),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].sharesNum}',
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'DmSans',
                  fontWeight: FontWeight.w600,
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
                  style: TextStyle(fontSize: 18, fontFamily: 'DmSans'),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].sharesNum}',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'DmSans',
                      fontWeight: FontWeight.w600,
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
                        fontSize: 18.sp,
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
                          fontSize: 18.sp,
                          fontFamily: 'AppleSDM',
                          height: 1,
                          textBaseline: TextBaseline.alphabetic,
                          // fontWeight: FontWeight.w600,
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
                        fontSize: 18.sp,
                        fontFamily: 'AppleSDM',
                        height: 1,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i + 1]].sharesNum} 주',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'AppleSDM',
                          height: 1,
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
                width: 8,
              ),
              Text(
                '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i]].stockName}',
                style: TextStyle(fontSize: 18, fontFamily: 'DmSans'),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                '${model.getInitialRatio(model.orderDrawingItem[i])}',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'DmSans',
                    fontWeight: FontWeight.w600,
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
    // return oldDelegate.center != center;
    return false;
  }
}

class PortfolioArcLine extends CustomPainter {
  Offset center;
  String color;
  double standartRadius;

  PortfolioArcLine({this.center, this.color, this.standartRadius});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(int.parse('FF$color', radix: 16)).withOpacity(0.3)
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

// 튜토리얼
Widget tutorial(PortfolioViewModel model) {
  return GestureDetector(
    onTap: () {
      model.tutorialStepProgress();
    },
    child: SafeArea(
      child: (model.tutorialStatus - model.tutorialTotalStep == 0)
          ? Stack(
              children: [
                // ClipPath(
                //   clipper: TutorialClipper1(),
                //   child: Container(
                //     width: deviceWidth,
                //     height: deviceHeight,
                //     decoration: BoxDecoration(
                //         border: Border.all(width: 1, color: Colors.amber),
                //         color: Colors.black38),
                //   ),
                // ),
                // Column(
                //   children: [
                //     Container(
                //       width: deviceWidth,
                //       height: 90,
                //       decoration: BoxDecoration(
                //           border: Border.all(width: 1, color: Colors.amber),
                //           color: Colors.black38),
                //     ),
                //     Container(
                //       width: deviceWidth,
                //       height: 450,
                //       decoration: BoxDecoration(
                //           border: Border.all(width: 1, color: Colors.amber),
                //           color: Colors.white10),
                //     ),
                //     Container(
                //       width: deviceWidth,
                //       height: 200,
                //       decoration: BoxDecoration(
                //           border: Border.all(width: 1, color: Colors.amber),
                //           color: Colors.black38),
                //     )
                //   ],
                // ),
                Container(
                  width: deviceWidth,
                  height: deviceHeight,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.amber),
                      color: Colors.black38),
                ),
                Column(
                  children: [
                    Text('1A가',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'DmSans',
                            color: Colors.transparent)),
                    SizedBox(height: 44),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(
                            '이번 시즌 우승상금으로 선택된 포트폴리오예요.',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE81B1B),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset:
                                    Offset(1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                        Container(),
                      ],
                    ),
                  ],
                )
              ],
            )
          : Stack(
              children: [
                // ClipPath(
                //   clipper: TutorialClipper2(),
                //   child: Container(
                //     width: deviceWidth,
                //     height: deviceHeight,
                //     decoration: BoxDecoration(
                //         border: Border.all(width: 1, color: Colors.amber),
                //         color: Colors.black38),
                //   ),
                // ),
                // Column(
                //   children: [
                //     Container(
                //       width: deviceWidth,
                //       height: deviceHeight - 240,
                //       decoration: BoxDecoration(
                //           border: Border.all(width: 1, color: Colors.amber),
                //           color: Colors.black38),
                //     ),
                //     Container(
                //         width: deviceWidth,
                //         height: 90,
                //         decoration: BoxDecoration(
                //             border: Border.all(width: 1, color: Colors.amber),
                //             color: Colors.black12))
                //   ],
                // ),

                Container(
                  width: deviceWidth,
                  height: deviceHeight,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.amber),
                      color: Colors.black38),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('1A가',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'DmSans',
                            color: Colors.transparent)),
                    SizedBox(height: 44),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Text(
                        '매일 변하는 상금가치, 오늘은 얼마일까요?',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFE81B1B),
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(1, 1), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 48),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '1A가',
                          style: TextStyle(
                              fontSize: 28,
                              fontFamily: 'DmSans',
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1.0,
                              color: Colors.transparent),
                        ),
                      ],
                    ),
                    Text('1A가',
                        style:
                            TextStyle(fontSize: 14, color: Colors.transparent)),
                  ],
                )
              ],
            ),
    ),
  );
}

class TutorialClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTWH(0, 90, size.width, 100 + deviceWidth - 100))
      // ..addOval(Rect.fromCircle(
      //     center: Offset(size.width - 44, size.height - 44), radius: 40))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TutorialClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTWH(0, deviceHeight - 235, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
