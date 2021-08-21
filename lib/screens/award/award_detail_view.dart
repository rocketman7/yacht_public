import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/widgets/appbar_back_button.dart';

import 'dart:math' as math;

import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';
import '../../handlers/numbers_handler.dart' as NumbersHandler;

import 'award_view_model.dart';

class AwardDetailView extends StatelessWidget {
  final AwardViewModel _awardViewModel = Get.find<AwardViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: primaryAppBar("상금 주식 자세히 보기"),
      //  AppBar(
      //   backgroundColor: primaryBackgroundColor,
      //   leading: AppBarBackButton(),
      //   title: Text(
      //     '상금 주식 자세히 보기',
      //     style: homeHeaderAfterName,
      //   ),
      //   toolbarHeight: 60.w,
      // bottom: PreferredSize(
      //     child: Container(
      //       color: Color(0xFF94BDE0).withOpacity(0.3),
      //       // 피그마에서는 opacity 0.5 인데 0.5로하면 너무 진한 느낌이 나서..
      //       // color: Color(0xFF94BDE0).withOpacity(0.5),
      //       height: 1.0,
      //     ),
      //     preferredSize: Size.fromHeight(1.0)),
      // ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(14.0.w),
            child: Container(
              width: double.infinity,
              decoration:
                  primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow], color: homeModuleBoxBackgroundColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Container(
                        width: double.infinity,
                        // height: 300.w,
                        decoration: primaryBoxDecoration.copyWith(
                            color: _awardViewModel.colorIndex(_awardViewModel.pageIndexForUI.value),
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 14.w - reducePaddingOneSide(homeModuleTitleTextStyle.fontSize!),
                            ),
                            Text(
                              '${_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].name}',
                              style: subLeagueTitleTextStyle,
                            ),
                            SizedBox(
                              height: 30.w - reducePaddingOneSide(homeModuleTitleTextStyle.fontSize!),
                            ),
                            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                              SizedBox(
                                width: 14.w,
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _awardViewModel.pageNavigateToLeft();
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 12.w,
                                    ),
                                    Container(
                                      child: Center(
                                        child: Obx(() => Image.asset(
                                              'assets/icons/award_left_arrow.png',
                                              height: 30.w,
                                              width: 30.w,
                                              color: _awardViewModel.pageIndexForUI.value == 0
                                                  ? Colors.transparent
                                                  : primaryFontColor,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Image.asset(
                                'assets/icons/won_mark.png',
                                height: 34.w,
                                width: 34.w,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5.0.w),
                              Text(
                                '${NumbersHandler.toPriceKRW(_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].totalValue)}',
                                style: subLeagueAwardTextStyle,
                              ),
                              Spacer(),
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _awardViewModel.pageNavigateToRight();
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 12.w,
                                    ),
                                    Container(
                                      child: Center(
                                        child: Obx(() => Image.asset(
                                              'assets/icons/award_right_arrow.png',
                                              height: 30.w,
                                              width: 30.w,
                                              color: _awardViewModel.pageIndexForUI.value ==
                                                      _awardViewModel.allSubLeagues.length - 1
                                                  ? Colors.transparent
                                                  : primaryFontColor,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 14.w,
                              ),
                            ]),
                            SizedBox(height: 10.w),
                            Text(
                              '상금 약 ${NumbersHandler.parseNumberKRWtoApproxiKorean(_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].totalValue)}',
                              style: awardModuleSliderAmountKoreanTextStyle.copyWith(
                                  fontSize: 22.w,
                                  color: awardModuleSliderAmountKoreanTextStyle.color!.withOpacity(0.3)),
                            ),
                            SizedBox(
                              height: 4.0.w,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 17.w,
                                ),
                                Flexible(
                                  child: Container(
                                    height: 1.w,
                                    color: awardModuleSliderAmountKoreanTextStyle.color!.withOpacity(0.3),
                                  ),
                                ),
                                Container(
                                  width: 17.w,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0.w -
                                  reducePaddingOneSide(
                                      awardModuleSliderEndDateTimeTextStyle.copyWith(fontSize: 14.w).fontSize!),
                            ),
                            // 얘는 리그 필드?에서 받아와야할듯. leageu name 처럼.
                            Text(
                              '2021년 06월 30일까지',
                              style: awardModuleSliderEndDateTimeTextStyle.copyWith(fontSize: 14.w),
                            ),
                            SizedBox(
                              height: 10.0.w -
                                  reducePaddingOneSide(
                                      awardModuleSliderEndDateTimeTextStyle.copyWith(fontSize: 14.w).fontSize!),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 30.w - reducePaddingOneSide(subLeagueAwardDescriptionStyle.fontSize!),
                  ),
                  Obx(() => Padding(
                        padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].description}'
                                .replaceAll('\\n', '\n'),
                            style: subLeagueAwardDescriptionStyle,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 8.w - reducePaddingOneSide(subLeagueAwardDescriptionStyle.fontSize!),
                  ),
                  Obx(() => Padding(
                        padding: EdgeInsets.only(left: 15.5.w, right: 15.5.w),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: SubLeagueViewDetailRulesTextWidget(
                            rules: _awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].rules,
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 40.w - reducePaddingOneSide(homeModuleTitleTextStyle.fontSize!),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 14.0.w),
                    child: Text(
                      '상금 주식 포트폴리오',
                      style: homeModuleTitleTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: 10.w - reducePaddingOneSide(homeModuleTitleTextStyle.fontSize!),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w, bottom: 14.0.w),
                    child: Container(
                      height: SizeConfig.screenWidth - 14.0.w * 4,
                      width: SizeConfig.screenWidth - 14.0.w * 4,
                      color: Colors.white,
                      child: PortfolioChart(),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w), child: PortfolioLabel()),
                  Obx(() => _awardViewModel.isMaxLabel[_awardViewModel.pageIndexForUI.value] == labelState.NONEED
                      ? Container()
                      : _awardViewModel.isMaxLabel[_awardViewModel.pageIndexForUI.value] == labelState.NEED_MIN
                          ? Padding(
                              padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _awardViewModel.moreStockOrCancel(_awardViewModel.pageIndexForUI.value);
                                },
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        height: 1.w,
                                        color: primaryLightFontColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Text('더보기',
                                        style: subLeagueAwardLabelStyle.copyWith(
                                            fontWeight: FontWeight.w300, color: primaryLightFontColor)),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Image.asset('assets/icons/drop_down_arrow.png',
                                        width: 12.w, color: primaryLightFontColor),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Flexible(
                                      child: Container(
                                        height: 1.w,
                                        color: primaryLightFontColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _awardViewModel.moreStockOrCancel(_awardViewModel.pageIndexForUI.value);
                                },
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        height: 1.w,
                                        color: primaryLightFontColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Text('닫기',
                                        style: subLeagueAwardLabelStyle.copyWith(
                                            fontWeight: FontWeight.w300, color: primaryLightFontColor)),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Image.asset('assets/icons/drop_down_cancel_arrow.png',
                                        width: 12.w, color: primaryLightFontColor),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Flexible(
                                      child: Container(
                                        height: 1.w,
                                        color: primaryLightFontColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                  SizedBox(
                    height: 40.w - reducePaddingOneSide(homeModuleTitleTextStyle.fontSize!),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 14.0.w),
                    child: Text(
                      '요트선장 코멘트',
                      style: homeModuleTitleTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: 20.5.w - reducePaddingOneSide(subLeagueAwardCommentStyle.fontSize!),
                  ),
                  Obx(() => Padding(
                        padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                        child: Text(
                          '${_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].comment}',
                          style: subLeagueAwardCommentStyle,
                        ),
                      )),
                  SizedBox(
                    height: 40.w - reducePaddingOneSide(homeModuleTitleTextStyle.fontSize!),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 14.0.w),
                    child: Text(
                      '랭킹',
                      style: homeModuleTitleTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubLeagueViewDetailRulesTextWidget extends StatelessWidget {
  final List<String> rules;

  SubLeagueViewDetailRulesTextWidget({required this.rules});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rules
          .asMap()
          .map((i, element) => MapEntry(
                i,
                Text(
                  '*${rules[i]}',
                  style: subLeagueAwardRulesStyle,
                ),
              ))
          .values
          .toList(),
    );
  }
}

class PortfolioLabel extends StatelessWidget {
  final AwardViewModel _awardViewModel = Get.find<AwardViewModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks
              .asMap()
              .map((i, element) => MapEntry(
                  i,
                  (_awardViewModel.isMaxLabel[_awardViewModel.pageIndexForUI.value] == labelState.NEED_MIN &&
                              i < labelMaxNum) ||
                          (_awardViewModel.isMaxLabel[_awardViewModel.pageIndexForUI.value] == labelState.NEED_MAX) ||
                          (_awardViewModel.isMaxLabel[_awardViewModel.pageIndexForUI.value] == labelState.NONEED)
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: _awardViewModel
                                        .colorIndex(_awardViewModel.pageIndexForUI.value)
                                        .withOpacity(math.max(1.0 - 0.1 * i, 0.0)),
                                    borderRadius: BorderRadius.circular(2.0),
                                  ),
                                  height: 18.w,
                                  width: 18.w,
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  '${_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i].name}',
                                  style: subLeagueAwardLabelStyle,
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Flexible(
                                  child: Container(
                                    height: 1.w,
                                    color: primaryFontColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                    '${_awardViewModel.subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].roundPercentage}%',
                                    style: subLeagueAwardLabelStyle),
                              ],
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                          ],
                        )
                      : Container()))
              .values
              .toList(),
        ));
  }
}

class PortfolioChart extends StatelessWidget {
  final AwardViewModel _awardViewModel = Get.find<AwardViewModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: _awardViewModel.portfolioArcRadius,
          height: _awardViewModel.portfolioArcRadius,
          child: Stack(
            children: portfolioList(),
          ),
        ));
  }

  List<Widget> portfolioList() {
    List<Widget> result = [];

    for (int i = 0; i < _awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks.length; i++) {
      result.add(
        GestureDetector(
          onTap: () {},
          child: CustomPaint(
            size: Size(_awardViewModel.portfolioArcRadius, _awardViewModel.portfolioArcRadius),
            painter: PortfolioArcChartPainter(
              center: Offset(_awardViewModel.portfolioArcRadius / 2, _awardViewModel.portfolioArcRadius / 2),
              color: _awardViewModel
                  .colorIndex(_awardViewModel.pageIndexForUI.value)
                  .withOpacity(math.max(1.0 - 0.1 * i, 0.0)),
              percentage1:
                  _awardViewModel.subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].startPercentage! *
                      100,
              percentage2:
                  _awardViewModel.subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].endPercentage! *
                      100,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < _awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks.length; i++) {
      if (_awardViewModel.subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].legendVisible!)
        result.add(
          Positioned(
            left: _awardViewModel
                .subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].portionOffsetFromCenter!.dx,
            top: _awardViewModel
                .subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].portionOffsetFromCenter!.dy,
            child: Text(
              '${_awardViewModel.subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].roundPercentage}%',
              style: subLeagueAwardPortionStyle,
            ),
          ),
        );
      if (_awardViewModel.subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].legendVisible!)
        result.add(
          Positioned(
              left: _awardViewModel
                  .subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].stockNameOffsetFromCenter!.dx,
              top: _awardViewModel
                  .subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].stockNameOffsetFromCenter!.dy,
              child: Container(
                child: Text(
                  _awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i].name,
                  style: subLeagueAwardStockNameStyle,
                ),
              )),
        );
    }

    return result;
  }
}

class PortfolioArcChartPainter extends CustomPainter {
  Offset? center;
  Color? color;
  double? percentage1 = 0.0;
  double? percentage2 = 0.0;

  PortfolioArcChartPainter({this.center, this.color, this.percentage1, this.percentage2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color!
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    double arcAngle1 = 2 * math.pi * (percentage1! / 100) - math.pi / 2;
    double arcAngle2 = 2 * math.pi * (percentage2! / 100) - math.pi / 2;
    canvas.drawArc(Rect.fromCircle(center: center!, radius: radius), arcAngle1, arcAngle2 - arcAngle1, true, paint);
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
