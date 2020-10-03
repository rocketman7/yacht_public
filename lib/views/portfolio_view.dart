import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:ui';
import 'dart:math' as math;

import 'constants/size.dart';
import '../models/portfolio_model.dart';
import '../view_models/portfolio_view_model.dart';

class PortfolioView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PortfolioViewModel>.reactive(
        viewModelBuilder: () => PortfolioViewModel(),
        builder: (context, model, child) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                // centerTitle: false,
                centerTitle: true,
                title: Text('상금 포트폴리오 구성',
                    // textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -2.0)),
                elevation: 0,
              ),
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? FlareActor(
                          'assets/images/Loading.flr',
                          animation: 'loading',
                        )
                      : SafeArea(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 4),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${model.getDateFormChange()}',
                                      style: TextStyle(
                                          fontFamily: 'DmSans', fontSize: 14),
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
                                      style: TextStyle(
                                          fontFamily: 'DmSans', fontSize: 14),
                                    )
                                  ],
                                ),
                                Expanded(
                                    child: ListView(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                    ),
                                    makePortfolioArc(
                                        model, model.portfolioModel),
                                    SizedBox(
                                      height: 24,
                                    ),
                                    makePortfolioItems(
                                        model, model.portfolioModel),
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
        });
  }
}

Widget makePortfolioArc(
    PortfolioViewModel model, PortfolioModel portfolioModel) {
  double portfolioArcWidth = deviceWidth - 64;
  double portfolioArcHeight = deviceWidth - 64;

  return Container(
    width: portfolioArcWidth,
    height: portfolioArcHeight,
    child: Stack(
      children: [
        CustomPaint(
          size: Size(portfolioArcWidth, portfolioArcHeight),
          painter: PortfolioArcChart(
              center:
                  Offset(portfolioArcWidth / 2 + 16, portfolioArcHeight / 2),
              color: portfolioModel.subPortfolio[0].colorCode,
              percentage1: model.startPercentage[0],
              percentage2: model.startPercentage[1]),
        ),
        CustomPaint(
          size: Size(portfolioArcWidth - 20, portfolioArcHeight - 20),
          painter: PortfolioArcChart(
              center:
                  Offset(portfolioArcWidth / 2 + 16, portfolioArcHeight / 2),
              color: portfolioModel.subPortfolio[1].colorCode,
              percentage1: model.startPercentage[1],
              percentage2: model.startPercentage[2]),
        ),
        CustomPaint(
          size: Size(portfolioArcWidth - 80, portfolioArcHeight - 80),
          painter: PortfolioArcChart(
              center:
                  Offset(portfolioArcWidth / 2 + 16, portfolioArcHeight / 2),
              color: portfolioModel.subPortfolio[2].colorCode,
              percentage1: model.startPercentage[2],
              percentage2: model.startPercentage[3]),
        ),
        CustomPaint(
          size: Size(portfolioArcWidth - 45, portfolioArcHeight - 45),
          painter: PortfolioArcChart(
              center:
                  Offset(portfolioArcWidth / 2 + 16, portfolioArcHeight / 2),
              color: portfolioModel.subPortfolio[3].colorCode,
              percentage1: model.startPercentage[3],
              percentage2: model.startPercentage[4]),
        ),
        CustomPaint(
          size: Size(112, 112),
          painter: PortfolioArcChart(
              center:
                  Offset(portfolioArcWidth / 2 + 16, portfolioArcHeight / 2),
              color: 'FFFFFF',
              percentage1: 0,
              percentage2: 100),
        ),
        Center(
            child: Text(
          '${model.getSeasonUpperCase()}',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'DmSans'),
        ))
      ],
    ),
  );
}

Widget makePortfolioItems(
    PortfolioViewModel model, PortfolioModel portfolioModel) {
  return Text('항목별로 들어올 부분');
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
    return oldDelegate.percentage1 != percentage1;
  }
}
