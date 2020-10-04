import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:ui';
import 'dart:math' as math;

import 'constants/size.dart';
import '../view_models/portfolio_view_model.dart';

class PortfolioView extends StatefulWidget {
  @override
  _PortfolioViewState createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<PortfolioView>
    with TickerProviderStateMixin {
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
    return ViewModelBuilder<PortfolioViewModel>.reactive(
        viewModelBuilder: () => PortfolioViewModel(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return Scaffold(
              body: Center(
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
            );
          } else {
            if (!_chartAnimationController.isCompleted)
              _chartAnimationController.forward();
            if (_chartAnimationController.isCompleted &&
                !_itemAnimationController.isCompleted)
              _itemAnimationController.forward();

            return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('상금 포트폴리오 구성',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -2.0)),
                  elevation: 0,
                ),
                body: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${model.getDateFormChange()}',
                              style:
                                  TextStyle(fontFamily: 'DmSans', fontSize: 14),
                            ),
                            Container(
                              height: 8,
                              width: 1,
                              color: Color(0xFFD8D8D8),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              '${model.seasonModel.seasonName}',
                              style:
                                  TextStyle(fontFamily: 'DmSans', fontSize: 14),
                            )
                          ],
                        ),
                        Expanded(
                            child: ListView(
                          children: [
                            SizedBox(
                              height: 40,
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
                                  child: Container(
                                    width: deviceWidth - 64,
                                    height: deviceWidth - 64,
                                    child: Center(
                                        child: Text(
                                      '${model.seasonModel.seasonName}',
                                      // '${model.getSeasonUpperCase()}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'DmSans'),
                                    )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            _itemAnimationController.isCompleted
                                ? makePortfolioItems(model)
                                : Container(),
                          ],
                        )),
                        SizedBox(height: 8),
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
                                        letterSpacing: -1.0),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 8),
                        _itemAnimationController.isCompleted
                            ? Text(
                                '시즌상금 가치(전일종가 기준)',
                                style: TextStyle(fontSize: 14),
                              )
                            : Container(),
                        SizedBox(height: 32),
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
        color: '6B6B6B',
      ),
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
    ),
  ));

  result.add(CustomPaint(
    size: Size(portfolioArcRadius, portfolioArcRadius),
    painter: PortfolioArcLine(
      center: Offset(portfolioArcRadius / 2 + 16, portfolioArcRadius / 2),
      color: '6B6B6B',
    ),
  ));

  return result;
}

Widget makePortfolioArc(PortfolioViewModel model) {
  double portfolioArcRadius = deviceWidth - 64;
  const double portfolioArcRadiusCenter = 112;

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
        } else {
          result.add(Row(
            children: [
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
                      width: 8,
                    ),
                    Text(
                      '${model.portfolioModel.subPortfolio[model.orderDrawingItem[i + 1]].stockName}',
                      style: TextStyle(fontSize: 18, fontFamily: 'DmSans'),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      '${model.getInitialRatio(model.orderDrawingItem[i + 1])}',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'DmSans',
                          fontWeight: FontWeight.w600,
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

  PortfolioArcLine({this.center, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(int.parse('FF$color', radix: 16)).withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final double radius = size.width / 2;

    double startAngle = 0;
    final double maxAngle = 2 * math.pi;
    final double space = 2 * math.pi / 200;

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
