import 'dart:ui';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'package:yachtOne/services/navigation_service.dart';

import 'package:yachtOne/view_models/last_season_portfolio_view_model.dart';
import 'package:yachtOne/view_models/winner_view_model.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import '../locator.dart';
import 'constants/size.dart';

class LastSeasonPortfolioView extends StatefulWidget {
  final WinnerViewModel? winnerViewModel;
  LastSeasonPortfolioView(this.winnerViewModel);
  @override
  _LastSeasonPortfolioViewState createState() =>
      _LastSeasonPortfolioViewState();
}

class _LastSeasonPortfolioViewState extends State<LastSeasonPortfolioView>
    with TickerProviderStateMixin {
  WinnerViewModel? winnerViewModel;
  NavigationService? _navigationService = locator<NavigationService>();
  late AnimationController _chartAnimationController;
  late Animation chartAnimation;

  late AnimationController _itemAnimationController;
  Animation? itemAnimation;

  @override
  void initState() {
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
    winnerViewModel = widget.winnerViewModel;
    if (!_chartAnimationController.isCompleted)
      _chartAnimationController.forward();
    if (_chartAnimationController.isCompleted &&
        !_itemAnimationController.isCompleted)
      _itemAnimationController.forward();

    winnerViewModel = widget.winnerViewModel;
    var returnFormat = NumberFormat("#0.00 %", "en_US");
    return ViewModelBuilder<LastSeasonPortfolioViewModel>.reactive(
        viewModelBuilder: () => LastSeasonPortfolioViewModel(winnerViewModel),
        builder: (context, model, child) {
          if (model.isBusy) {
            return Scaffold(
              body: Container(
                height: deviceHeight,
                width: deviceWidth,
                child: Stack(
                  children: [
                    Positioned(
                      top: deviceHeight! / 2 - 100,
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
                                  Navigator.of(_navigationService!
                                          .navigatorKey.currentContext!)
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
                              model.seasonModel!.seasonName! + " 최종 상금 내역",
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
                            Spacer(),
                            Text(
                              '시즌 종료일 종가 기준',
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
                                            size: Size(deviceWidth! - 64,
                                                deviceWidth! - 64),
                                            painter: PortfolioArcChartLoading(
                                                center: Offset(
                                                    (deviceWidth! - 64) / 2 + 16,
                                                    (deviceWidth! - 64) / 2),
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
                                  child: Container(
                                    width: deviceWidth! - 64,
                                    height: deviceWidth! - 64,
                                    child: Center(
                                        child: Text(
                                      '${model.seasonModel!.seasonName}',
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

Widget makePortfolioArcLine(LastSeasonPortfolioViewModel model) {
  double portfolioArcRadius = deviceWidth! - 64;
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

List<Widget> makePortfolioArcLineComponents(LastSeasonPortfolioViewModel model,
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

Widget makePortfolioArc(LastSeasonPortfolioViewModel model) {
  double portfolioArcRadius = deviceWidth! - 64;
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

List<Widget> makePortfolioArcComponents(LastSeasonPortfolioViewModel model,
    double portfolioArcRadius, double portfolioArcRadiusCenter) {
  List<Widget> result = [];

  for (int i = 0; i < model.portfolioModel!.subPortfolio!.length; i++) {
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
              color: model.portfolioModel!.subPortfolio![i].colorCode,
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

Widget makePortfolioItems(LastSeasonPortfolioViewModel model) {
  return Column(
    children: makePortfolioItemsColumns(model),
  );
}

List<Widget> makePortfolioItemsColumns(LastSeasonPortfolioViewModel model) {
  List<Widget> result = [];

  for (int i = 0; i < model.portfolioModel!.subPortfolio!.length; i++) {
    if (model.drawingMaxLength[i]) {
      result.add(Container(
        height: 32.h,
        width: (deviceWidth! - 32.h),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(int.parse(
                      'FF${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].colorCode}',
                      radix: 16))),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              '${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].stockName}',
              style: TextStyle(
                fontSize: 18.sp,
                height: 1,
                fontFamily: 'AppleSDM',
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              '${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].sharesNum}주',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontFamily: 'AppleSDM',
                  height: 1,
                  textBaseline: TextBaseline.alphabetic,
                  color: Color(int.parse(
                      'FF${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].colorCode}',
                      radix: 16))),
            ),
          ],
        ),
      ));
    } else {
      if (i + 1 < model.portfolioModel!.subPortfolio!.length) {
        if (model.drawingMaxLength[i + 1]) {
          result.add(Container(
            height: 32,
            width: (deviceWidth! - 32),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(int.parse(
                          'FF${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].colorCode}',
                          radix: 16))),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].stockName}',
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
                  '${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].sharesNum}주',
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: 'AppleSDM',
                      height: 1,
                      textBaseline: TextBaseline.alphabetic,
                      color: Color(int.parse(
                          'FF${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].colorCode}',
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
                width: (deviceWidth! - 32) / 2 - 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(
                              'FF${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].colorCode}',
                              radix: 16))),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].stockName}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        height: 1,
                        fontFamily: 'AppleSDM',
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].sharesNum}주',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'AppleSDM',
                          height: 1,
                          textBaseline: TextBaseline.alphabetic,
                          color: Color(int.parse(
                              'FF${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].colorCode}',
                              radix: 16))),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                height: 32,
                width: (deviceWidth! - 32) / 2 - 10,
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(int.parse(
                              'FF${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i + 1]].colorCode}',
                              radix: 16))),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i + 1]].stockName}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        height: 1,
                        fontFamily: 'AppleSDM',
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i + 1]].sharesNum}주',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'AppleSDM',
                          height: 1,
                          textBaseline: TextBaseline.alphabetic,
                          color: Color(int.parse(
                              'FF${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i + 1]].colorCode}',
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
          width: (deviceWidth! - 32),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(int.parse(
                        'FF${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].colorCode}',
                        radix: 16))),
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                '${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].stockName}',
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
                '${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].sharesNum}주',
                style: TextStyle(
                    fontSize: 17.sp,
                    fontFamily: 'AppleSDM',
                    height: 1,
                    textBaseline: TextBaseline.alphabetic,
                    color: Color(int.parse(
                        'FF${model.portfolioModel!.subPortfolio![model.orderDrawingItem[i]].colorCode}',
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
  Offset? center;
  String? color;
  double? percentage1 = 0;
  double? percentage2 = 0;

  PortfolioArcChart(
      {this.center, this.color, this.percentage1, this.percentage2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(int.parse('FF$color', radix: 16))
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    if (percentage1 != 100) percentage1 = percentage1! % 100;
    if (percentage2 != 100) percentage2 = percentage2! % 100;

    if (percentage1! > percentage2!) {
      double arcAngle1 = 2 * math.pi * (percentage1! / 100);
      canvas.drawArc(Rect.fromCircle(center: center!, radius: radius), arcAngle1,
          2 * math.pi - arcAngle1, true, paint);

      double arcAngle2 = 2 * math.pi * (percentage2! / 100);
      canvas.drawArc(Rect.fromCircle(center: center!, radius: radius),
          2 * math.pi, arcAngle2, true, paint);
    } else {
      double arcAngle1 = 2 * math.pi * (percentage1! / 100);
      double arcAngle2 = 2 * math.pi * (percentage2! / 100);
      canvas.drawArc(Rect.fromCircle(center: center!, radius: radius), arcAngle1,
          arcAngle2 - arcAngle1, true, paint);
    }
  }

  @override
  bool shouldRepaint(PortfolioArcChart oldDelegate) {
    return false;
  }

  @override
  bool? hitTest(Offset position) {
    // TODO: implement hitTest
    return super.hitTest(position);
  }

  // @override
  // bool hitTest(Offset position) {
  //   return paint.contains(position);
  // }
}

class PortfolioArcLine extends CustomPainter {
  Offset? center;
  String? color;
  double? standartRadius;

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
    final double space = 2 * math.pi / 200 * (standartRadius! / size.width);

    while (startAngle < maxAngle) {
      canvas.drawArc(Rect.fromCircle(center: center!, radius: radius),
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
  Offset? center;
  double? percentage1 = 0;
  double? percentage2 = 0;

  PortfolioArcChartLoading({this.center, this.percentage1, this.percentage2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    double arcAngle1 = 2 * math.pi * (percentage1! / 100);
    double arcAngle2 = 2 * math.pi * (percentage2! / 100);

    canvas.drawArc(Rect.fromCircle(center: center!, radius: radius), arcAngle1,
        arcAngle2 - arcAngle1, true, paint);

    paint..color = Colors.white;

    canvas.drawArc(Rect.fromCircle(center: center!, radius: radius), arcAngle2,
        2 * math.pi - arcAngle2 + arcAngle1, true, paint);
  }

  @override
  bool shouldRepaint(PortfolioArcChartLoading oldDelegate) {
    return true;
  }
}
