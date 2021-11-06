import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import '../../handlers/numbers_handler.dart' as NumbersHandler;

import '../../styles/yacht_design_system.dart';
import 'last_award_detail_view.dart';
import 'last_award_view_model.dart';

class LastAwardView extends StatelessWidget {
  final LastAwardViewModel _lastAwardViewModel = Get.put(LastAwardViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: newPrimaryAppBarForOnlyLastLeaguesScreen('지난 리그 보기'),
      body: ListView(
        children: [
          SizedBox(
            height: 64.w + 8.w,
          ),
          // GestureDetector(
          //     onTap: () {
          //       _lastAwardViewModel.orderMethod(0, 0);
          //     },
          //     child: Container(
          //       height: 24.w,
          //       width: 200.w,
          //       color: Colors.red,
          //     )),
          GetBuilder<LastAwardViewModel>(
            builder: (controller) {
              if (controller.isAllLastSubLeaguesLoaded) {
                return Column(
                    children: controller.orderLastSubLeagues
                        .asMap()
                        .map((i, element) => MapEntry(
                            i,
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 14.w, right: 14.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => LastAwardDetailView(
                                          lastSubLeague: controller
                                              .orderLastSubLeagues[i]));
                                    },
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 347.w,
                                          height: 185.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: buttonNormal,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: yachtShadow,
                                                  blurRadius: 8.w,
                                                  spreadRadius: 1.w,
                                                )
                                              ],
                                              border: Border.all(
                                                color: yachtViolet
                                                    .withOpacity(0.05),
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
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Color(0xFFFDFEFF)
                                                          .withOpacity(0),
                                                      Color(0xFFFDFEFF)
                                                          .withOpacity(1),
                                                      Color(0xFFFDFEFF)
                                                          .withOpacity(0),
                                                    ],
                                                  ),
                                                  color: Color(0xFFFDFEFF)
                                                      .withOpacity(.5))),
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
                                                      '${controller.orderLastSubLeagues[i].name}',
                                                      style:
                                                          lastLeagueViewAwardTitleText,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10.w - 2.w,
                                                ),
                                                Padding(
                                                  // padding: EdgeInsets.only(left: 24.w, right: 24.w),
                                                  padding: EdgeInsets.only(
                                                      left: 8.w, right: 8.w),
                                                  child: Container(
                                                    height: 1.w,
                                                    decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                          colors: [
                                                            Color(0xFF798AE6)
                                                                .withOpacity(0),
                                                            Color(0xFF798AE6)
                                                                .withOpacity(
                                                                    0.5),
                                                            Color(0xFF798AE6)
                                                                .withOpacity(0),
                                                          ],
                                                        ),
                                                        color: Color(0xFF798AE6)
                                                            .withOpacity(0.3)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 16.w - 6.w,
                                                ),
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
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
                                                            color:
                                                                yachtDarkGrey),
                                                      ),
                                                      SizedBox(width: 7.0.w),
                                                      Container(
                                                        // color: Colors.grey,
                                                        child: Text(
                                                          '${NumbersHandler.toPriceKRW(controller.orderLastSubLeagues[i].totalValue!)}',
                                                          style:
                                                              lastLeagueViewAwardAmountText
                                                                  .copyWith(
                                                                      height:
                                                                          1.05),
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                    ]),
                                                SizedBox(
                                                    height: 8.w + 1.w + 1.w),
                                                Container(
                                                  // color: Colors.grey,
                                                  child: Text(
                                                      '상금 약 ${NumbersHandler.parseNumberKRWtoApproxiKorean(controller.orderLastSubLeagues[i].totalValue!)}',
                                                      style:
                                                          lastLeagueViewAwardKoreanAmountText),
                                                ),
                                                SizedBox(height: 8.w - 2.w),
                                                Padding(
                                                  // padding: EdgeInsets.only(left: 24.w, right: 24.w),
                                                  padding: EdgeInsets.only(
                                                      left: 8.w, right: 8.w),
                                                  child: Container(
                                                    height: 1.w,
                                                    decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                          colors: [
                                                            Color(0xFF798AE6)
                                                                .withOpacity(0),
                                                            Color(0xFF798AE6)
                                                                .withOpacity(
                                                                    0.5),
                                                            Color(0xFF798AE6)
                                                                .withOpacity(0),
                                                          ],
                                                        ),
                                                        color: Color(0xFF798AE6)
                                                            .withOpacity(0.3)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 11.w + 1.w,
                                                ),
                                                Container(
                                                  // color: Colors.grey,
                                                  child: Text(
                                                    '${controller.orderLastSubLeagues[i].leagueEndDateTime}',
                                                    style:
                                                        lastLeagueViewAwardDateText,
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
                                  ),
                                ),
                                SizedBox(
                                  height: 14.w,
                                ),
                              ],
                            )))
                        .values
                        .toList());
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

AppBar newPrimaryAppBarForOnlyLastLeaguesScreen(String title) {
  final LastAwardViewModel _lastAwardViewModel = Get.find<LastAwardViewModel>();

  return AppBar(
    backgroundColor: Colors.transparent,
    systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: yachtBlack),
    toolbarHeight: 60.w,
    flexibleSpace: Container(
      height: SizeConfig.safeAreaTop + 60.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
              top: 0.w,
              left: 0.w,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    height: SizeConfig.safeAreaTop + 60.w + 64.w,
                    width: SizeConfig.screenWidth,
                    color: primaryBackgroundColor.withOpacity(.65),
                  ),
                ),
              )),
          Positioned(
            top: SizeConfig.safeAreaTop + 60.w,
            left: 0.w,
            child: Container(
              height: 64.w,
              width: SizeConfig.screenWidth,
              child: Column(
                children: [
                  SizedBox(
                    height: 14.w,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 14.w,
                      ),
                      !_lastAwardViewModel.isLeagueCategorySelect.value
                          ? GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                print('aaaaasas');
                              },
                              child: Container(
                                height: 36.w,
                                width: 169.w,
                                decoration: primaryBoxDecoration.copyWith(
                                    // color: Colors.grey,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color(0xFFCEC4DA).withOpacity(0.3),
                                        blurRadius: 8.w,
                                        spreadRadius: 1.w,
                                        offset: Offset(0, 0),
                                      ),
                                    ], borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 10.w + 18.w + 10.w,
                                    ),
                                    Container(
                                      width: 121.w - 18.w - 10.w,
                                      child: Center(
                                          child: Text(
                                        '${leagueCategory[_lastAwardViewModel.selectedLeagueCategoryIndex.value]}',
                                        style: lastLeagueViewCategoryText,
                                      )),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    SizedBox(
                                      height: 18.w,
                                      width: 18.w,
                                      child: Image.asset(
                                          'assets/icons/ic_ arrow_L.png'),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : GetBuilder<LastAwardViewModel>(
                              id: 'leagueCategory',
                              builder: (controller) {
                                return Container(
                                  height: 36.w,
                                  width: 169.w,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Positioned(
                                        top: 0.w,
                                        left: 0.w,
                                        child: Container(
                                          // height: 36.w * 5,
                                          height: 36.w * leagueCategory.length,
                                          width: 169.w,
                                          decoration: primaryBoxDecoration
                                              .copyWith(
                                                  boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFFCEC4DA)
                                                      .withOpacity(0.3),
                                                  blurRadius: 8.w,
                                                  spreadRadius: 1.w,
                                                  offset: Offset(0, 0),
                                                ),
                                              ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                          child: Column(
                                              children: leagueCategory
                                                  .asMap()
                                                  .map((i, element) => MapEntry(
                                                        i,
                                                        GestureDetector(
                                                          onTap: () {
                                                            print('aaaaaaa');
                                                          },
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    12.w - 5.w,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 10
                                                                            .w +
                                                                        18.w +
                                                                        10.w,
                                                                  ),
                                                                  Container(
                                                                    width: 121
                                                                            .w -
                                                                        18.w -
                                                                        10.w,
                                                                    child: Center(
                                                                        child: Container(
                                                                      // color: Colors
                                                                      //     .grey,
                                                                      child:
                                                                          Text(
                                                                        '${leagueCategory[i]}',
                                                                        style:
                                                                            lastLeagueViewCategoryText,
                                                                      ),
                                                                    )),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10.w,
                                                                  ),
                                                                  i == 0
                                                                      ? SizedBox(
                                                                          height:
                                                                              18.w,
                                                                          width:
                                                                              18.w,
                                                                          child:
                                                                              Image.asset('assets/icons/ic_ arrow_L.png'),
                                                                        )
                                                                      : Container(
                                                                          height:
                                                                              18.w,
                                                                          width:
                                                                              18.w,
                                                                        ),
                                                                  SizedBox(
                                                                    width: 10.w,
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    11.w - 5.w,
                                                              ),
                                                              i !=
                                                                      leagueCategory
                                                                              .length -
                                                                          1
                                                                  ? Container(
                                                                      height:
                                                                          1.w,
                                                                      color:
                                                                          yachtLightGrey,
                                                                    )
                                                                  : Container()
                                                            ],
                                                          ),
                                                        ),
                                                      ))
                                                  .values
                                                  .toList()),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                      SizedBox(
                        width: 9.w,
                      ),
                      Container(
                        height: 36.w,
                        width: 169.w,
                        decoration: primaryBoxDecoration.copyWith(boxShadow: [
                          BoxShadow(
                            color: Color(0xFFCEC4DA).withOpacity(0.3),
                            blurRadius: 8.w,
                            spreadRadius: 1.w,
                            offset: Offset(0, 0),
                          ),
                        ], borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              width: 121.w,
                              child: Center(
                                  child: Text(
                                '상금 높은 순',
                                style: lastLeagueViewCategoryText,
                              )),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            SizedBox(
                              height: 18.w,
                              width: 18.w,
                              child:
                                  Image.asset('assets/icons/ic_ arrow_L.png'),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14.w,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
    title: Text(title, style: newAppBarTitle),
  );
}

TextStyle lastLeagueViewCategoryText = TextStyle(
  fontSize: 16.w,
  fontFamily: 'IBMPlex',
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle lastLeagueViewAwardTitleText = TextStyle(
  fontSize: 20.w,
  fontFamily: 'IBMPlex',
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.0,
);

TextStyle lastLeagueViewAwardAmountText = TextStyle(
  fontSize: 40.w,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w600,
  color: yachtDarkGrey,
  letterSpacing: -1.0,
  height: 1.0,
);

TextStyle lastLeagueViewAwardKoreanAmountText = TextStyle(
  fontSize: 24.w,
  fontFamily: 'IBMPlex',
  fontWeight: FontWeight.w300,
  color: yachtViolet.withOpacity(0.3),
  letterSpacing: -1.0,
  height: 1.0,
);

TextStyle lastLeagueViewAwardDateText = TextStyle(
  fontSize: 14.w,
  fontFamily: 'IBMPlex',
  fontWeight: FontWeight.w300,
  color: yachtBlack.withOpacity(0.5),
  letterSpacing: -0.25,
  height: 1.0,
);

TextStyle lastLeagueDetailViewAwardDescriptionText = TextStyle(
  fontSize: 18.w,
  fontFamily: 'IBMPlex',
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle lastLeagueDetailViewAwardRulesText = TextStyle(
  fontSize: 12.w,
  fontFamily: 'IBMPlex',
  // fontWeight: FontWeight.w500,
  color: yachtGrey,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle lastLeagueDetailViewTitleText = TextStyle(
  fontSize: 16.w,
  fontFamily: 'IBMPlex',
  fontWeight: FontWeight.w600,
  color: yachtDarkGrey,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle lastLeagueDetailViewAmountText = TextStyle(
  fontSize: 16.w,
  fontFamily: 'IBMPlex',
  fontWeight: FontWeight.w600,
  color: yachtBlue,
  letterSpacing: 0.0,
  height: 1.75,
);
