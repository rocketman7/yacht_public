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
  AnimationController _animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation =
        Tween<double>(begin: 0.0, end: 100.0).animate(_animationController);

    _animationController.addListener(() {
      setState(() {
        print(animation.value);
      });
    });

    // _animationController.repeat();
    _animationController.forward();
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
                              '${model.getSeasonUpperCase()}',
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
                                // CustomPaint(
                                //   size:
                                //       Size(deviceWidth - 64, deviceWidth - 64),
                                //   painter: PortfolioArcChartLoading(
                                //       center: Offset(
                                //           (deviceWidth - 64) / 2 + 16,
                                //           (deviceWidth - 64) / 2),
                                //       percentage1: 0,
                                //       percentage2: 50),
                                // ),
                                Center(
                                  child: Container(
                                    width: deviceWidth - 64,
                                    height: deviceWidth - 64,
                                    child: Center(
                                        child: Text(
                                      '${model.getSeasonUpperCase()}',
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
                            makePortfolioItems(model),
                          ],
                        )),
                        SizedBox(height: 8),
                        Row(
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
                        ),
                        SizedBox(height: 8),
                        Text(
                          '시즌상금 가치(전일종가 기준)',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                ));
          }
        });
  }
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
    result.add(CustomPaint(
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

Widget makePortfolioItems(PortfolioViewModel model) {
  return Column(
    children: makePortfolioItemsColumns(model),
  );
}

List<Widget> makePortfolioItemsColumns(PortfolioViewModel model) {
  List<Widget> result = [];
  int lastI = 0;

  for (int i = 0; i < model.portfolioModel.subPortfolio.length - 1; i += 2) {
    if (!model.drawingMaxLength[i + 1]) {
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

      lastI = i;
    }
  }

  for (int i = lastI + 2; i < model.portfolioModel.subPortfolio.length; i++) {
    result.add(Row(
      children: [
        Container(
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
        ),
        Spacer(),
      ],
    ));
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

    double radius = size.width / 2;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0,
        2 * math.pi, false, paint);
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
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    // double arcAngle1 = 2 * math.pi * (percentage1 / 100);
    double arcAngle2 = 2 * math.pi * (percentage2 / 100);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 0,
        arcAngle2, true, paint);
    // -math.pi / 2, arcAngle, true, paint);
  }

  @override
  bool shouldRepaint(PortfolioArcChartLoading oldDelegate) {
    return false;
  }
}
