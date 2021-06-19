import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:math' as math;

import 'award_view_model.dart';

class AwardView extends StatelessWidget {
  // const AwardView({Key? key}) : super(key: key);
  final AwardViewModel awardViewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    // final awardViewModel = Get.put(AwardViewModel());

    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 100,
        ),
        Text(awardViewModel.awardModels[0].awardStockModels[0].stockName),
        Text(awardViewModel.awardModels[0].awardStockModels[1].stockName),
        Text(awardViewModel.awardModels[0].awardStockModels[2].stockName),
        Text(awardViewModel.awardModels[0].awardStockModels[3].stockName),
        Text(awardViewModel.awardModels[0].awardStockModels[4].stockName),
        Text(awardViewModel.awardModels[0].awardStockModels[5].stockName),
        Text(awardViewModel.awardModels[1].awardStockModels[5].stockName),
        Text(awardViewModel.awardModels[0].awardTitle),
        Text(awardViewModel.awardModels[0].awardDescription),
        Text('${awardViewModel.awardModels[0].totalAwardValue}'),
        PortfolioChart(
          awardModel: awardViewModel.awardModels,
          index: 0,
        ),
      ],
    ));
  }
}

class PortfolioChart extends StatelessWidget {
  final List<AwardModel> awardModel;
  final int index;

  PortfolioChart({required this.awardModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: mainPadding, right: mainPadding),
      child: awardModel[index].awardStockModels.length > 1
          ? Container(
              width: portfolioArcRadius,
              height: portfolioArcRadius,
              child: Stack(
                children: portfolioList(),
              ),
            )
          : GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: mainPadding * 3,
                ),
                decoration: BoxDecoration(
                    color: Color(int.parse(
                        'FF${awardModel[index].awardStockUIModels![0].colorCode}',
                        radix: 16)),
                    borderRadius: BorderRadius.circular(
                      15.0,
                    )),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        '100%',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 36,
                            fontFamily: 'AppleSDEB'),
                      ),
                      SizedBox(
                        height: 0.0,
                      ),
                      Text(
                        awardModel[index].awardStockModels[0].stockName,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'AppleSDM'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  List<Widget> portfolioList() {
    List<Widget> result = [];

    for (int i = 0; i < awardModel[index].awardStockModels.length; i++) {
      result.add(
        GestureDetector(
          onTap: () {},
          child: CustomPaint(
            size: Size(portfolioArcRadius, portfolioArcRadius),
            painter: PortfolioArcChartPainter(
                center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
                color: awardModel[index].awardStockUIModels![i].colorCode,
                percentage1:
                    awardModel[index].awardStockUIModels![i].startPercentage! *
                        100,
                percentage2:
                    awardModel[index].awardStockUIModels![i].endPercentage! *
                        100),
          ),
        ),
      );
    }

    result.add(CustomPaint(
      size: Size(portfolioArcRadius * 0.2, portfolioArcRadius * 0.2),
      painter: PortfolioArcChartPainter(
          center: Offset(portfolioArcRadius / 2, portfolioArcRadius / 2),
          color: 'FFFFFF',
          percentage1: 0,
          percentage2: 100),
    ));

    for (int i = 0; i < awardModel[index].awardStockModels.length; i++) {
      if (awardModel[index].awardStockUIModels![i].legendVisible!)
        result.add(
          Positioned(
            left: awardModel[index]
                .awardStockUIModels![i]
                .portionOffsetFromCenter!
                .dx,
            top: awardModel[index]
                .awardStockUIModels![i]
                .portionOffsetFromCenter!
                .dy,
            child: Text(
              '${awardModel[index].awardStockUIModels![i].roundPercentage}%',
              style: portionTxtStyle,
            ),
          ),
        );
      if (awardModel[index].awardStockUIModels![i].legendVisible!)
        result.add(
          Positioned(
              left: awardModel[index]
                  .awardStockUIModels![i]
                  .stockNameOffsetFromCenter!
                  .dx,
              top: awardModel[index]
                  .awardStockUIModels![i]
                  .stockNameOffsetFromCenter!
                  .dy,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: txtContainerPadding,
                  horizontal: txtContainerPadding,
                ),
                decoration: BoxDecoration(
                    color: Color(int.parse(
                            'FF${awardModel[index].awardStockUIModels![i].colorCode}',
                            radix: 16))
                        .withOpacity(0.8),
                    borderRadius: BorderRadius.circular(
                      5.0,
                    )),
                child: Text(
                  awardModel[index].awardStockModels[i].stockName,
                  style: stockNameTxtStyle,
                ),
              )),
        );
    }

    return result;
  }
}

class PortfolioArcChartPainter extends CustomPainter {
  Offset? center;
  String? color;
  double? percentage1 = 0.0;
  double? percentage2 = 0.0;

  PortfolioArcChartPainter(
      {this.center, this.color, this.percentage1, this.percentage2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(int.parse('FF$color', radix: 16))
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    double arcAngle1 = 2 * math.pi * (percentage1! / 100) - math.pi / 2;
    double arcAngle2 = 2 * math.pi * (percentage2! / 100) - math.pi / 2;
    canvas.drawArc(Rect.fromCircle(center: center!, radius: radius), arcAngle1,
        arcAngle2 - arcAngle1, true, paint);
  }

  @override
  bool shouldRepaint(PortfolioArcChartPainter oldDelegate) {
    return false;
  }

  // @override
  // bool hitTest(Offset position) {
  //   return super.hitTest(position)!;
  //   //   return paint.contains(position);
  // }
}
