import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/screens/ranks/rank_share_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/widgets/appbar_back_button.dart';

import 'dart:math' as math;

import '../../locator.dart';
import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';
import '../../handlers/numbers_handler.dart' as NumbersHandler;

import 'award_view_model.dart';
import 'last_award_detail_view.dart';
import 'last_award_view.dart';

class AwardDetailView extends StatelessWidget {
  final String leagueName;
  final String leagueEndDateTime;

  AwardDetailView({required this.leagueName, required this.leagueEndDateTime});

  final AwardViewModel _awardViewModel = Get.find<AwardViewModel>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();

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
                  Obx(() => Stack(
                        children: [
                          Container(
                            width: SizeConfig.screenWidth - 28.w,
                            height: 185.w + 22.w,
                            decoration: primaryBoxDecoration.copyWith(
                              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                _awardViewModel.colorIndex(_awardViewModel.pageIndexForUI.value, 0),
                                _awardViewModel.colorIndex(_awardViewModel.pageIndexForUI.value, 1),
                                _awardViewModel.colorIndex(_awardViewModel.pageIndexForUI.value, 0),
                              ]),
                            ),
                          ),
                          Positioned(
                            top: 6.w,
                            left: 8.w,
                            child: Container(
                              width: SizeConfig.screenWidth - 28.w - 16.w,
                              height: 185.w + 22.w - 12.w,
                              decoration: primaryBoxDecoration.copyWith(
                                gradient:
                                    LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                                  Color(0xFFFDFEFF).withOpacity(0),
                                  Color(0xFFFDFEFF).withOpacity(1),
                                  Color(0xFFFDFEFF).withOpacity(0),
                                ]),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: correctHeight(20.w, 0.w, subLeagueTitleTextStyle.fontSize),
                                ),
                                Text(
                                  '${_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].name}',
                                  style: subLeagueTitleTextStyle,
                                ),
                                SizedBox(
                                  height: correctHeight(12.w, subLeagueTitleTextStyle.fontSize, 0.w),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 23.w, right: 23.w),
                                  child: Container(
                                    height: 1.w,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF798AE6).withOpacity(0),
                                        Color(0xFF798AE6).withOpacity(0.5),
                                        Color(0xFF798AE6).withOpacity(0),
                                      ],
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  height: correctHeight(12.w, 0.w, subLeagueAwardTextStyle.fontSize),
                                ),
                                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _awardViewModel.pageNavigateToLeft();
                                      _mixpanelService.mixpanel.track(
                                        'Award Detail Swipe',
                                        properties: {
                                          'Award Detail Swipe Page To Sub League Name': _awardViewModel
                                              .allSubLeagues[_awardViewModel.pageIndexForUI.value].name
                                              .toString(),
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 18.w,
                                        ),
                                        Container(
                                          child: Center(
                                            child: _awardViewModel.pageIndexForUI.value == 0
                                                ? Container(
                                                    height: 24.w,
                                                    width: 24.w,
                                                  )
                                                : Image.asset(
                                                    'assets/icons/award_left_arrow.png',
                                                    height: 24.w,
                                                    width: 24.w,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Image.asset('assets/icons/won_mark.png',
                                      height: 42.w, width: 42.w, color: yachtDarkGrey),
                                  SizedBox(width: 7.0.w),
                                  Text(
                                    '${NumbersHandler.toPriceKRW(_awardViewModel.totalCurrentValue[_awardViewModel.pageIndexForUI.value])}',
                                    style: subLeagueAwardTextStyle,
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _awardViewModel.pageNavigateToRight();
                                      _mixpanelService.mixpanel.track(
                                        'Award Detail Swipe',
                                        properties: {
                                          'Award Detail Swipe Page To Sub League Name': _awardViewModel
                                              .allSubLeagues[_awardViewModel.pageIndexForUI.value].name
                                              .toString(),
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 18.w,
                                        ),
                                        Container(
                                          child: Center(
                                            child: _awardViewModel.pageIndexForUI.value ==
                                                    _awardViewModel.allSubLeagues.length - 1
                                                ? Container(
                                                    height: 24.w,
                                                    width: 24.w,
                                                  )
                                                : Image.asset(
                                                    'assets/icons/award_right_arrow.png',
                                                    height: 24.w,
                                                    width: 24.w,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                ]),
                                SizedBox(height: correctHeight(16.w, subLeagueAwardTextStyle.fontSize, 0.w)),
                                Text(
                                    '상금 약 ${NumbersHandler.parseNumberKRWtoApproxiKorean(_awardViewModel.totalCurrentValue[_awardViewModel.pageIndexForUI.value])}',
                                    style: awardAmountKoreanTextStyle),
                                SizedBox(
                                  height: correctHeight(10.w, awardAmountKoreanTextStyle.fontSize, 0.w),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 23.w, right: 23.w),
                                  child: Container(
                                    height: 1.w,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF798AE6).withOpacity(0),
                                        Color(0xFF798AE6).withOpacity(0.5),
                                        Color(0xFF798AE6).withOpacity(0),
                                      ],
                                    )),
                                  ),
                                ),
                                SizedBox(
                                  height: correctHeight(11.w, 0.w,
                                      awardModuleSliderEndDateTimeTextStyle.copyWith(fontSize: 14.w).fontSize),
                                ),
                                // 얘는 리그 필드?에서 받아와야할듯. leageu name 처럼.
                                Text(
                                  '$leagueEndDateTime',
                                  style: awardModuleSliderEndDateTimeTextStyle.copyWith(
                                      fontSize: 14.w,
                                      color: awardModuleSliderEndDateTimeTextStyle.color!.withOpacity(0.5)),
                                ),
                                SizedBox(
                                  height: correctHeight(17.w,
                                      awardModuleSliderEndDateTimeTextStyle.copyWith(fontSize: 14.w).fontSize, 0.w),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 10.w),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => PrimaryWebView(
                          title: '요트 퀘스트 규정집',
                          url: 'https://brave-cinnamon-fa9.notion.site/Rule-Book-65f390c24fbe4b4bbf1b95011419c0f7'));
                      //아래는 테스트코드들이므로 반드시 주석처리
                      // Get.to(() => LastAwardDetailView());
                      // _awardViewModel.testLastLeaguesDB();
                      // Get.to(() => LastAwardView());
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("요트 퀘스트 규정집 보러가기",
                                style: TextStyle(
                                  fontSize: 14.w,
                                  fontWeight: FontWeight.w300,
                                  color: yachtDarkGrey,
                                  height: 1.4,
                                )),
                            Icon(
                              Icons.chevron_right,
                              size: 20.w,
                              color: yachtDarkGrey,
                            )
                          ],
                        ),
                        SizedBox(height: correctHeight(20.w, 0.w, subLeagueAwardDescriptionStyle.fontSize)),
                      ],
                    ),
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
                      height: correctHeight(
                          12.w, subLeagueAwardDescriptionStyle.fontSize, subLeagueAwardRulesStyle.fontSize)),
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
                    height: correctHeight(50.w, subLeagueAwardRulesStyle.fontSize, awardModuleTitleTextStyle.fontSize),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 14.0.w),
                    child: Text(
                      '상금 주식 포트폴리오',
                      style: awardModuleTitleTextStyle,
                    ),
                  ),
                  SizedBox(height: correctHeight(20.w, awardModuleTitleTextStyle.fontSize, 0.w)),
                  Padding(
                    padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w, bottom: 18.0.w),
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
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 6.w,
                                      ),
                                      Container(
                                        width: 347.w,
                                        child: Row(
                                          children: [
                                            Spacer(),
                                            Text('종목 더보기',
                                                style: subLeagueAwardLabelStyle.copyWith(
                                                    fontWeight: FontWeight.w300, color: yachtGrey)),
                                            SizedBox(
                                              width: 4.w,
                                            ),
                                            Image.asset('assets/icons/drop_down_arrow.png',
                                                width: 12.w, color: yachtGrey),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.w,
                                      ),
                                      Container(
                                        height: 1.w,
                                        width: double.infinity,
                                        color: yachtLightGrey,
                                      ),
                                    ],
                                  )),
                            )
                          : Padding(
                              padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  _awardViewModel.moreStockOrCancel(_awardViewModel.pageIndexForUI.value);
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 6.w,
                                    ),
                                    Container(
                                      width: 347.w,
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Text('닫기',
                                              style: subLeagueAwardLabelStyle.copyWith(
                                                  fontWeight: FontWeight.w300, color: yachtGrey)),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Image.asset('assets/icons/drop_down_cancel_arrow.png',
                                              width: 12.w, color: yachtGrey),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.w,
                                    ),
                                    Container(
                                      height: 1.w,
                                      width: double.infinity,
                                      color: yachtLightGrey,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                  SizedBox(
                    height: 40.w - reducePaddingOneSide(awardModuleTitleTextStyle.fontSize!),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 14.0.w),
                    child: Text(
                      '코멘트 by 요트',
                      style: awardModuleTitleTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: 20.5.w - reducePaddingOneSide(subLeagueAwardCommentStyle.fontSize!),
                  ),
                  Obx(() => Padding(
                        padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                        child: Text(
                          '${_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].comment}'
                              .replaceAll('\\n', '\n'),
                          style: subLeagueAwardCommentStyle,
                        ),
                      )),
                  SizedBox(
                    height: 40.w - reducePaddingOneSide(awardModuleTitleTextStyle.fontSize!),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 14.0.w, right: 14.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(child: Text('랭킹', style: awardModuleTitleTextStyle)),
                        Spacer(),
                        GestureDetector(
                            onTap: () {
                              _mixpanelService.mixpanel.track('League Ranking', properties: {
                                'Sub League Index': _awardViewModel.pageIndexForUI.value,
                              });
                              Get.to(() => AllRankerView(
                                    leagueIndex: _awardViewModel.pageIndexForUI.value,
                                  ));
                            },
                            child: Row(
                              children: [
                                Text(
                                  '더 보기',
                                  style: moreText,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                SizedBox(
                                  height: 12.w,
                                  width: 8.w,
                                  child: Image.asset('assets/icons/right_arrow_grey.png'),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.w,
                  ),
                  Obx(() => RankShareView(
                        leagueIndex: _awardViewModel.pageIndexForUI.value,
                        isFullView: false,
                      )),
                  // SizedBox(
                  //   height: 14.w,
                  // ),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '* ',
                      style: lastLeagueDetailViewAwardRulesText,
                    ),
                    Container(
                      width: SizeConfig.screenWidth -
                          28.w -
                          31.w -
                          textSizeGet('* ', lastLeagueDetailViewAwardRulesText).width,
                      child: Text(
                        '${rules[i]}'.replaceAll('\\n', '\n'),
                        style: lastLeagueDetailViewAwardRulesText,
                      ),
                    ),
                  ],
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
          children: [
            Container(
              height: 1.w,
              width: double.infinity,
              color: yachtLightGrey,
            ),
            SizedBox(height: correctHeight(9.w, 0.w, subLeagueAwardLabelTotalValueTextStyle.fontSize)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('총 상금', style: subLeagueAwardLabelTotalTextStyle),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                  '${NumbersHandler.toPriceKRW(_awardViewModel.totalCurrentValue[_awardViewModel.pageIndexForUI.value])}원',
                  style: subLeagueAwardLabelTotalValueTextStyle,
                ),
                Spacer(),
                Text(
                    '${plusOrminusSymbol(_awardViewModel.totalCurrentValue[_awardViewModel.pageIndexForUI.value], _awardViewModel.totalValue[_awardViewModel.pageIndexForUI.value])}${NumbersHandler.toPriceKRW(_awardViewModel.totalCurrentValue[_awardViewModel.pageIndexForUI.value] - _awardViewModel.totalValue[_awardViewModel.pageIndexForUI.value])} (${NumbersHandler.toPercentageChange((_awardViewModel.totalCurrentValue[_awardViewModel.pageIndexForUI.value] - _awardViewModel.totalValue[_awardViewModel.pageIndexForUI.value]) / _awardViewModel.totalValue[_awardViewModel.pageIndexForUI.value])})',
                    style: subLeagueAwardLabelPLTextStyle.copyWith(
                        color: plusOrminusColor(_awardViewModel.totalCurrentValue[_awardViewModel.pageIndexForUI.value],
                            _awardViewModel.totalValue[_awardViewModel.pageIndexForUI.value]))),
              ],
            ),
            SizedBox(height: correctHeight(6.w, subLeagueAwardLabelTotalValueTextStyle.fontSize, 0.w)),
            Container(
              height: 1.w,
              width: double.infinity,
              color: yachtLightGrey,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks
                  .asMap()
                  .map((i, element) => MapEntry(
                      i,
                      (_awardViewModel.isMaxLabel[_awardViewModel.pageIndexForUI.value] == labelState.NEED_MIN &&
                                  i < labelMaxNum) ||
                              (_awardViewModel.isMaxLabel[_awardViewModel.pageIndexForUI.value] ==
                                  labelState.NEED_MAX) ||
                              (_awardViewModel.isMaxLabel[_awardViewModel.pageIndexForUI.value] == labelState.NONEED)
                          ? GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                Get.to(() => Scaffold(
                                      appBar: primaryAppBar(_awardViewModel
                                          .allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i].name),
                                      body: SingleChildScrollView(
                                        child: Padding(
                                          padding: primaryHorizontalPadding,
                                          child: StockInfoKRView(
                                              investAddressModel: _awardViewModel
                                                  .allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i]
                                                  .toInvestAddressModel()),
                                        ),
                                      ),
                                    ));
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: correctHeight(9.w, 0.w, subLeagueAwardLabelStockTextStyle.fontSize),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: (i < portfolioColors.length)
                                              ? portfolioColors[i]
                                              : portfolioColors[portfolioColors.length - 1].withOpacity(
                                                  math.max(1.0 - 0.4 * (i - portfolioColors.length + 1), 0.0)),
                                          borderRadius: BorderRadius.circular(2.0),
                                        ),
                                        height: 25.w,
                                        width: 25.w,
                                      ),
                                      SizedBox(
                                        width:
                                            textSizeGet('총 상금', subLeagueAwardLabelTotalTextStyle).width - 25.w + 4.w,
                                      ),
                                      Container(
                                        width: SizeConfig.screenWidth -
                                            14.w -
                                            14.w -
                                            textSizeGet('총 상금', subLeagueAwardLabelTotalTextStyle).width -
                                            4.w -
                                            14.w -
                                            14.w,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '${_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i].name}',
                                                  style: subLeagueAwardLabelStockTextStyle,
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i].sharesNum}주',
                                                  style: subLeagueAwardLabelStockTextStyle,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '${NumbersHandler.toPriceKRW(_awardViewModel.getStockCurrentTotalValue(_awardViewModel.pageIndexForUI.value, i))}원',
                                                  style: subLeagueAwardLabelStockPriceTextStyle,
                                                ),
                                                Spacer(),
                                                Text(
                                                  '${plusOrminusSymbol(_awardViewModel.getStockCurrentTotalValue(_awardViewModel.pageIndexForUI.value, i), _awardViewModel.getStockStandardTotalValue(_awardViewModel.pageIndexForUI.value, i))}${NumbersHandler.toPriceKRW(_awardViewModel.getStockCurrentTotalValue(_awardViewModel.pageIndexForUI.value, i) - _awardViewModel.getStockStandardTotalValue(_awardViewModel.pageIndexForUI.value, i))} (${NumbersHandler.toPercentageChange((_awardViewModel.getStockCurrentTotalValue(_awardViewModel.pageIndexForUI.value, i) - _awardViewModel.getStockStandardTotalValue(_awardViewModel.pageIndexForUI.value, i)) / _awardViewModel.getStockStandardTotalValue(_awardViewModel.pageIndexForUI.value, i))})',
                                                  style: subLeagueAwardLabelPLTextStyle.copyWith(
                                                      color: plusOrminusColor(
                                                          _awardViewModel.getStockCurrentTotalValue(
                                                              _awardViewModel.pageIndexForUI.value, i),
                                                          _awardViewModel.getStockStandardTotalValue(
                                                              _awardViewModel.pageIndexForUI.value, i))),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: correctHeight(6.w, subLeagueAwardLabelPLTextStyle.fontSize, 0.w),
                                  ),
                                  Container(
                                    height: 1.w,
                                    width: double.infinity,
                                    color: yachtLightGrey,
                                  ),
                                ],
                              ),
                            )
                          // Column(
                          //     children: [
                          //       GestureDetector(
                          //         behavior: HitTestBehavior.opaque,
                          //         onTap: () {
                          //           Get.to(() => Scaffold(
                          //                 appBar: primaryAppBar(_awardViewModel
                          //                     .allSubLeagues[_awardViewModel
                          //                         .pageIndexForUI.value]
                          //                     .stocks[i]
                          //                     .name),
                          //                 body: SingleChildScrollView(
                          //                   child: Padding(
                          //                     padding: primaryHorizontalPadding,
                          //                     child: StockInfoKRView(
                          //                         investAddressModel:
                          //                             _awardViewModel
                          //                                 .allSubLeagues[
                          //                                     _awardViewModel
                          //                                         .pageIndexForUI
                          //                                         .value]
                          //                                 .stocks[i]
                          //                                 .toInvestAddressModel()),
                          //                   ),
                          //                 ),
                          //               ));
                          //         },
                          //         child:
                          //         Row(
                          //           children: [
                          //             Container(
                          //               decoration: BoxDecoration(
                          //                 color: (i < portfolioColors.length)
                          //                     ? portfolioColors[i]
                          //                     : portfolioColors[
                          //                             portfolioColors.length -
                          //                                 1]
                          //                         .withOpacity(math.max(
                          //                             1.0 -
                          //                                 0.4 *
                          //                                     (i -
                          //                                         portfolioColors
                          //                                             .length +
                          //                                         1),
                          //                             0.0)),
                          //                 borderRadius:
                          //                     BorderRadius.circular(2.0),
                          //               ),
                          //               height: 18.w,
                          //               width: 18.w,
                          //             ),
                          //             SizedBox(
                          //               width: 6.w,
                          //             ),
                          //             Text(
                          //               '${_awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i].name}',
                          //               style: subLeagueAwardLabelStyle,
                          //             ),
                          //             SizedBox(
                          //               width: 6.w,
                          //             ),
                          //             Flexible(
                          //               child: Container(
                          //                 height: 1.w,
                          //                 color: yachtBlack,
                          //               ),
                          //             ),
                          //             SizedBox(
                          //               width: 6.w,
                          //             ),
                          //             SizedBox(
                          //               width: textSizeGet('000%',
                          //                       subLeagueAwardLabelStyle)
                          //                   .width,
                          //               child: Text(
                          //                 '${_awardViewModel.subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].roundPercentage}%',
                          //                 style: subLeagueAwardLabelStyle,
                          //                 textAlign: TextAlign.end,
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         height: 10.w,
                          //       ),
                          //     ],
                          //   )
                          : Container()))
                  .values
                  .toList(),
            ),
          ],
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
              color: (i < portfolioColors.length)
                  ? portfolioColors[i]
                  : portfolioColors[portfolioColors.length - 1]
                      .withOpacity(math.max(1.0 - 0.4 * (i - portfolioColors.length + 1), 0.0)),
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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.to(() => Scaffold(
                      appBar: primaryAppBar(
                          _awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i].name),
                      body: SingleChildScrollView(
                        child: Padding(
                          padding: primaryHorizontalPadding,
                          child: StockInfoKRView(
                              investAddressModel: _awardViewModel
                                  .allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i]
                                  .toInvestAddressModel()),
                        ),
                      ),
                    ));
                // 주식 세부페이지로 가는 네비게잇 필요
                // print(i);
              },
              child: Text(
                '${_awardViewModel.subLeaguePortfolioUIModels[_awardViewModel.pageIndexForUI.value][i].roundPercentage}%',
                style: subLeagueAwardPortionStyle,
              ),
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
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.to(() => Scaffold(
                        appBar: primaryAppBar(
                            _awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i].name),
                        body: SingleChildScrollView(
                          child: Padding(
                            padding: primaryHorizontalPadding,
                            child: StockInfoKRView(
                                investAddressModel: _awardViewModel
                                    .allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i]
                                    .toInvestAddressModel()),
                          ),
                        ),
                      ));
                  // 주식 세부페이지로 가는 네비게잇 필요
                  // print(i);
                },
                child: Container(
                  child: Text(
                    _awardViewModel.allSubLeagues[_awardViewModel.pageIndexForUI.value].stocks[i].name,
                    style: subLeagueAwardStockNameStyle,
                  ),
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
      // ..color = color!
      ..shader = RadialGradient(
        colors: [
          color!,
          color!.withOpacity(0.5),
        ],
      ).createShader(Rect.fromCircle(
        center: center!,
        radius: size.width / 2,
      ))
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

String plusOrminusSymbol(double a, double b) {
  if (a > b)
    return '+';
  else if (a == b)
    return '';
  else
    return '';
}

Color plusOrminusColor(double a, double b) {
  if (a > b)
    return yachtRed;
  else if (a == b)
    return yachtBlack;
  else
    return yachtBlue;
}
