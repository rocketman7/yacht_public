import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/models/last_subLeague_model.dart';
import 'package:yachtOne/screens/ranks/rank_share_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import 'dart:math' as math;

import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';
import '../../handlers/numbers_handler.dart' as NumbersHandler;

import 'award_detail_view.dart';
import 'award_view_model.dart';
import 'last_award_detail_view_model.dart';
import 'last_award_view.dart';

class LastAwardDetailView extends StatelessWidget {
  LastAwardDetailView({required this.lastSubLeague});

  final LastSubLeagueModel lastSubLeague;

  @override
  Widget build(BuildContext context) {
    final LastAwardDetailViewModel lastAwardDetailViewModel =
        Get.put(LastAwardDetailViewModel(lastSubLeague: lastSubLeague));

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: newPrimaryAppBar("지난 리그 자세히 보기"),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(14.0.w),
            child: GetBuilder<LastAwardDetailViewModel>(builder: (controller) {
              return Container(
                width: double.infinity,
                decoration: primaryBoxDecoration.copyWith(
                    // color: Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFCEC4DA).withOpacity(0.3),
                        blurRadius: 8.w,
                        spreadRadius: 1.w,
                        offset: Offset(0, 0),
                      ),
                    ], borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 347.w,
                          height: 185.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: buttonNormal,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: yachtShadow,
                              //     blurRadius: 8.w,
                              //     spreadRadius: 1.w,
                              //   )
                              // ],
                              border: Border.all(
                                color: yachtViolet.withOpacity(0.05),
                                width: 1.w,
                              )),
                        ),
                        Positioned(
                          top: 6.w,
                          left: 8.w,
                          child: Container(
                              width: 331.w,
                              height: 173.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFFDFEFF).withOpacity(0),
                                      Color(0xFFFDFEFF).withOpacity(1),
                                      Color(0xFFFDFEFF).withOpacity(0),
                                    ],
                                  ),
                                  color: Color(0xFFFDFEFF).withOpacity(.5))),
                        ),
                        Positioned(
                          top: 0.w,
                          left: 0.w,
                          child: Container(
                            width: 347.w,
                            height: 185.w,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 21.w + 1.w,
                                ),
                                Center(
                                  child: Container(
                                    child: Text(
                                      '${controller.lastSubLeague.name}',
                                      style: lastLeagueViewAwardTitleText,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.w - 2.w,
                                ),
                                Padding(
                                  // padding: EdgeInsets.only(left: 24.w, right: 24.w),
                                  padding:
                                      EdgeInsets.only(left: 8.w, right: 8.w),
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
                                        ),
                                        color:
                                            Color(0xFF798AE6).withOpacity(0.3)),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.w - 6.w,
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Spacer(),
                                      Container(
                                        // color: Colors.grey,
                                        child: Image.asset(
                                            'assets/icons/won_mark.png',
                                            height: 30.w,
                                            width: 36.w,
                                            color: yachtDarkGrey),
                                      ),
                                      SizedBox(width: 7.0.w),
                                      Container(
                                        // color: Colors.grey,
                                        child: Text(
                                          '${NumbersHandler.toPriceKRW(controller.lastSubLeague.totalValue!)}',
                                          style: lastLeagueViewAwardAmountText
                                              .copyWith(height: 1.05),
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                    ]),
                                SizedBox(height: 8.w + 1.w + 1.w),
                                Container(
                                  // color: Colors.grey,
                                  child: Text(
                                      '상금 약 ${NumbersHandler.parseNumberKRWtoApproxiKorean(controller.lastSubLeague.totalValue!)}',
                                      style:
                                          lastLeagueViewAwardKoreanAmountText),
                                ),
                                SizedBox(height: 8.w - 2.w),
                                Padding(
                                  // padding: EdgeInsets.only(left: 24.w, right: 24.w),
                                  padding:
                                      EdgeInsets.only(left: 8.w, right: 8.w),
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
                                        ),
                                        color:
                                            Color(0xFF798AE6).withOpacity(0.3)),
                                  ),
                                ),
                                SizedBox(
                                  height: 11.w + 1.w,
                                ),
                                Container(
                                  // color: Colors.grey,
                                  child: Text(
                                    '${controller.lastSubLeague.leagueEndDateTime}',
                                    style: lastLeagueViewAwardDateText,
                                  ),
                                ),
                                SizedBox(
                                  height: 17.w - 2.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.w),
                    Padding(
                      padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${controller.lastSubLeague.description}'
                              .replaceAll('\\n', '\n'),
                          style: lastLeagueDetailViewAwardDescriptionText,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: correctHeight(
                            12.w,
                            lastLeagueDetailViewAwardDescriptionText.fontSize,
                            subLeagueAwardRulesStyle.fontSize)),
                    Padding(
                      padding: EdgeInsets.only(left: 15.5.w, right: 15.5.w),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: SubLeagueViewDetailRulesTextWidget(
                          rules: controller.lastSubLeague.rules,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: correctHeight(
                          50.w,
                          subLeagueAwardRulesStyle.fontSize,
                          lastLeagueDetailViewAwardRulesText.fontSize),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 14.0.w),
                      child: Text(
                        '리그 수상 내역',
                        style: lastLeagueDetailViewTitleText,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 14.w, right: 13.w),
                      child: Container(
                        height: 200.w,
                        width: 320.w,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 77.w,
                              left: 0.w,
                              child: Container(
                                width: 92.w,
                                height: 123.w,
                                decoration:
                                    primaryBoxDecoration.copyWith(boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFCEC4DA).withOpacity(0.3),
                                    blurRadius: 8.w,
                                    spreadRadius: 1.w,
                                    offset: Offset(0, 0),
                                  ),
                                ], borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            Positioned(
                              top: 49.w,
                              left: 19.w,
                              child: Image.asset(
                                'assets/icons/silver_medal.png',
                                height: 54.w,
                                width: 54.w,
                              ),
                            ),
                            Positioned(
                              top: 104.w,
                              left: 27.w,
                              child: Image.asset(
                                'assets/icons/no_medal.png',
                                height: 38.w,
                                width: 38.w,
                              ),
                            ),
                            Positioned(
                                top: 168.w,
                                left: 8.w,
                                child: Container(
                                    height: 24.w,
                                    width: 76.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(45),
                                        color: Color(0xFFECF3FF)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Image.asset(
                                          'assets/icons/won_mark_two.png',
                                          height: 11.79.w,
                                          width: 15.w,
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        ),
                                        Container(
                                          width: 40.w,
                                          child: AutoSizeText(
                                            '68,000',
                                            maxLines: 1,
                                            minFontSize: 5.w,
                                            style:
                                                lastLeagueDetailViewAmountText
                                                    .copyWith(fontSize: 14.w),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 9.w,
                                        // ),
                                      ],
                                    ))),
                            Positioned(
                              top: 40.w,
                              left: 104.w,
                              child: Container(
                                width: 120.w,
                                height: 160.w,
                                decoration:
                                    primaryBoxDecoration.copyWith(boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFCEC4DA).withOpacity(0.3),
                                    blurRadius: 8.w,
                                    spreadRadius: 1.w,
                                    offset: Offset(0, 0),
                                  ),
                                ], borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            Positioned(
                              top: 0.w,
                              left: 124.w,
                              child: Image.asset(
                                'assets/icons/gold_medal.png',
                                height: 80.w,
                                width: 80.w,
                              ),
                            ),
                            Positioned(
                              top: 81.w,
                              left: 140.w,
                              child: Image.asset(
                                'assets/icons/no_medal.png',
                                height: 48.w,
                                width: 48.w,
                              ),
                            ),
                            Positioned(
                                top: 162.w,
                                left: 114.w,
                                child: Container(
                                    height: 30.w,
                                    width: 101.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(45),
                                        color: Color(0xFFECF3FF)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Image.asset(
                                          'assets/icons/won_mark_two.png',
                                          height: 12.82.w,
                                          width: 17.w,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Container(
                                          width: 62.w,
                                          child: AutoSizeText(
                                            '243,000',
                                            maxLines: 1,
                                            minFontSize: 5.w,
                                            style:
                                                lastLeagueDetailViewAmountText
                                                    .copyWith(fontSize: 16.w),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 9.w,
                                        // ),
                                      ],
                                    ))),
                            Positioned(
                              top: 88.w,
                              left: 236.w,
                              child: Container(
                                width: 84.w,
                                height: 112.w,
                                decoration:
                                    primaryBoxDecoration.copyWith(boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFCEC4DA).withOpacity(0.3),
                                    blurRadius: 8.w,
                                    spreadRadius: 1.w,
                                    offset: Offset(0, 0),
                                  ),
                                ], borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            Positioned(
                              top: 64.w,
                              left: 255.w,
                              child: Image.asset(
                                'assets/icons/bronze_medal.png',
                                height: 45.w,
                                width: 45.w,
                              ),
                            ),
                            Positioned(
                              top: 110.w,
                              left: 261.w,
                              child: Image.asset(
                                'assets/icons/no_medal.png',
                                height: 33.w,
                                width: 33.w,
                              ),
                            ),
                            Positioned(
                                top: 166.w,
                                left: 242.w,
                                child: Container(
                                    height: 26.w,
                                    width: 72.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(45),
                                        color: Color(0xFFECF3FF)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        Image.asset(
                                          'assets/icons/won_mark_two.png',
                                          height: 9.81.w,
                                          width: 13.w,
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Container(
                                          width: 42.w,
                                          child: AutoSizeText(
                                            '33,000',
                                            maxLines: 1,
                                            minFontSize: 5.w,
                                            style:
                                                lastLeagueDetailViewAmountText
                                                    .copyWith(fontSize: 12.w),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 9.w,
                                        // ),
                                      ],
                                    ))),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.w,
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 14.0.w),
                    //   child: Text(
                    //     '상금 주식 포트폴리오',
                    //     style: lastLeagueDetailViewTitleText,
                    //   ),
                    // ),
                    // SizedBox(
                    //     height: correctHeight(
                    //         20.w, lastLeagueDetailViewTitleText.fontSize, 0.w)),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       left: 14.0.w, right: 14.0.w, bottom: 18.0.w),
                    //   child: Container(
                    //     height: SizeConfig.screenWidth - 14.0.w * 4,
                    //     width: SizeConfig.screenWidth - 14.0.w * 4,
                    //     color: Colors.white,
                    //     child: PortfolioChart(),
                    //   ),
                    // ),
                    // Padding(
                    //     padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                    //     child: PortfolioLabel()),

                    // // _awardViewModel.isMaxLabel[
                    // //             _awardViewModel.pageIndexForUI.value] ==
                    // //         labelState.NONEED
                    // //     ? Container()
                    // //     :
                    // // _awardViewModel.isMaxLabel[
                    // //             _awardViewModel.pageIndexForUI.value] ==
                    // //         labelState.NEED_MIN
                    // //     ?
                    // Padding(
                    //   padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                    //   child: GestureDetector(
                    //       behavior: HitTestBehavior.opaque,
                    //       onTap: () {
                    //         // _awardViewModel.moreStockOrCancel(
                    //         //     _awardViewModel.pageIndexForUI.value);
                    //       },
                    //       child: Column(
                    //         children: [
                    //           SizedBox(
                    //             height: 6.w,
                    //           ),
                    //           Container(
                    //             width: 347.w,
                    //             child: Row(
                    //               children: [
                    //                 Spacer(),
                    //                 Text('종목 더보기',
                    //                     style:
                    //                         subLeagueAwardLabelStyle.copyWith(
                    //                             fontWeight: FontWeight.w300,
                    //                             color: yachtGrey)),
                    //                 SizedBox(
                    //                   width: 4.w,
                    //                 ),
                    //                 Image.asset(
                    //                     'assets/icons/drop_down_arrow.png',
                    //                     width: 12.w,
                    //                     color: yachtGrey),
                    //                 Spacer(),
                    //               ],
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             height: 5.w,
                    //           ),
                    //           Container(
                    //             height: 1.w,
                    //             width: double.infinity,
                    //             color: yachtLightGrey,
                    //           ),
                    //         ],
                    //       )),

                    //   // : Padding(
                    //   //     padding:
                    //   //         EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                    //   //     child: GestureDetector(
                    //   //       behavior: HitTestBehavior.opaque,
                    //   //       onTap: () {
                    //   //         // _awardViewModel.moreStockOrCancel(
                    //   //         //     _awardViewModel.pageIndexForUI.value);
                    //   //       },
                    //   //       child: Column(
                    //   //         children: [
                    //   //           SizedBox(
                    //   //             height: 6.w,
                    //   //           ),
                    //   //           Container(
                    //   //             width: 347.w,
                    //   //             child: Row(
                    //   //               children: [
                    //   //                 Spacer(),
                    //   //                 Text('닫기',
                    //   //                     style: subLeagueAwardLabelStyle
                    //   //                         .copyWith(
                    //   //                             fontWeight:
                    //   //                                 FontWeight.w300,
                    //   //                             color: yachtGrey)),
                    //   //                 SizedBox(
                    //   //                   width: 4.w,
                    //   //                 ),
                    //   //                 Image.asset(
                    //   //                     'assets/icons/drop_down_cancel_arrow.png',
                    //   //                     width: 12.w,
                    //   //                     color: yachtGrey),
                    //   //                 Spacer(),
                    //   //               ],
                    //   //             ),
                    //   //           ),
                    //   //           SizedBox(
                    //   //             height: 5.w,
                    //   //           ),
                    //   //           Container(
                    //   //             height: 1.w,
                    //   //             width: double.infinity,
                    //   //             color: yachtLightGrey,
                    //   //           ),
                    //   //         ],
                    //   //       ),
                    //   //     ),
                    //   //   )
                    // ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
