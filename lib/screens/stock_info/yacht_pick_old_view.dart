import 'dart:ui';

import 'package:animated_digit/animated_digit.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/stock_info/stock_info_new_view.dart';
import 'package:yachtOne/screens/stock_info/yacht_pick_view.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/yacht_design_system/yds_button.dart';
import 'package:yachtOne/yacht_design_system/yds_dialog.dart';
import 'package:yachtOne/yacht_design_system/yds_font.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';
import 'package:yachtOne/yacht_design_system/yds_widget.dart';

import '../../handlers/date_time_handler.dart';
import '../../handlers/numbers_handler.dart';
import '../../locator.dart';
import '../../services/firestore_service.dart';
import '../../styles/size_config.dart';
import '../../styles/yacht_design_system.dart';
import 'stock_info_new_controller.dart';
import 'yacht_pick_old_controller.dart';

class YachtPickOldView extends StatelessWidget {
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    List<Widget> selectWeather = [
      SvgPicture.asset(
        'assets/icons/sunny_grey.svg',
        width: 30.w,
      ),
      SvgPicture.asset(
        'assets/icons/cloudy_grey.svg',
        width: 30.w,
      ),
      SvgPicture.asset(
        'assets/icons/rainy_grey.svg',
        width: 30.w,
      ),
      Text(
        "전체",
        style: body2BoldStyle.copyWith(color: yachtMidGrey),
      )
    ];

    List<String> weatherList = ['sunny', 'cloudy', 'rainy', '전체'];

    return Scaffold(
      backgroundColor: yachtBlack,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryBackgroundColor,
          title: Text(
            "요트 Pick",
            style: appBarTitle,
          )),
      body: GetBuilder<YachtPickOldController>(
          init: YachtPickOldController(),
          builder: (controller) {
            print(controller.currentClosePrices);
            return controller.isModelLoaded
                ? Column(
                    children: [
                      // Container(
                      //   height: 30.w,
                      //   // color: yachtWhite,
                      //   child: Padding(
                      //     padding: defaultHorizontalPadding,
                      //     child: Row(
                      //       // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: List.generate(weatherList.length, (index) {
                      //         return Expanded(
                      //           child: Container(
                      //             child: GestureDetector(
                      //               onTap: () {
                      //                 controller.pickWeather(index);
                      //               },
                      //               child: Obx(
                      //                 () => index == weatherList.length - 1
                      //                     ? Center(
                      //                         child: Text(
                      //                           weatherList[index],
                      //                           style: body2BoldStyle.copyWith(
                      //                             color: index == controller.pickWeather.value ? white : yachtMidGrey,
                      //                           ),
                      //                         ),
                      //                       )
                      //                     : SvgPicture.asset(
                      //                         index == controller.pickWeather.value
                      //                             ? 'assets/icons/${weatherList[index]}.svg'
                      //                             : 'assets/icons/${weatherList[index]}_grey.svg',
                      //                         // color: yachtViolet,
                      //                         width: 30.w,
                      //                       ),
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       }),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 4.w,
                      // ),
                      // Divider(
                      //   color: yachtGrey,
                      // ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    backgroundColor: Colors.transparent,
                                    // shape: RoundedRectangleBorder(
                                    //   borderRadius: BorderRadius.circular(12.w),
                                    // ),
                                    insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
                                    child: Container(
                                      padding: defaultPaddingAll.copyWith(top: 0),
                                      decoration: BoxDecoration(
                                        color: yachtDarkGrey,
                                        borderRadius: BorderRadius.circular(12.w),
                                      ),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 60.w,
                                              child: Center(
                                                child: Text(
                                                  "요트 Pick 수익률이란?",
                                                  style: head3Style.copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "1) ",
                                                  style: body1Style.copyWith(height: 1.4.w),
                                                ),
                                                SvgPicture.asset(
                                                  'assets/icons/sunny.svg',
                                                  width: 20.w,
                                                ),
                                                Text(
                                                  " 분류된 요트 Pick 종목들로 구성",
                                                  style: body1Style.copyWith(height: 1.4.w),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "2) 요트 Pick 공개 직후 다음 영업일 시초가에 \n동일 금액 매수. ",
                                              textAlign: TextAlign.center,
                                              style: body1Style.copyWith(height: 1.4.w),
                                            ),
                                            SizedBox(
                                              height: 16.w,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: confirmDialogButton())
                                          ]),
                                    ),
                                  )
                              //  infoDialog(
                              //   context,
                              //   title: "요트 Pick 수익률이란?",
                              //   info: "1) '맑음'으로 분류된 요트 Pick 종목들로 구성\n2) 요트 Pick 공개 직후 다음 영업일 시초가에 \n동일 금액 매수. ",
                              // ),
                              );
                        },
                        child: Padding(
                          padding: defaultPaddingAll,
                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.w),
                                color: yachtDarkGrey,
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: SvgPicture.asset(
                                      'assets/icons/question_mark.svg',
                                      width: 20.w,
                                      // height: 26.w,
                                      color: yachtLightGrey,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "요트 Pick",
                                            style: bodyP1Style,
                                          ),
                                          SizedBox(width: 4.w),
                                          SvgPicture.asset(
                                            'assets/icons/sunny.svg',
                                            width: 24.w,
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "수익률",
                                            style: bodyP1Style,
                                          ),
                                          // Spacer(),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 12.w,
                                      ),

                                      Center(
                                        child: Obx(
                                          () => AnimatedFlipCounter(
                                            duration:
                                                Duration(milliseconds: !controller.isPriceLoaded.value ? 1000 : 1000),
                                            prefix: controller.sunnyPicksReturn.value >= 0 ? '+' : '',
                                            suffix: '%',
                                            // value: 80.18,
                                            value: !controller.isPriceLoaded.value
                                                ? controller.randomNumber.value * 10
                                                : controller.sunnyPicksReturn.value * 100,
                                            fractionDigits: 2,
                                            // padding: EdgeInsets.all(0),
                                            textStyle: head1Style.copyWith(
                                              fontWeight: FontWeight.w700,
                                              // letterSpacing: -1.2,
                                              color: !controller.isPriceLoaded.value
                                                  ? yachtRed
                                                  : controller.sunnyPicksReturn.value == 0.0
                                                      ? white
                                                      : controller.sunnyPicksReturn.value > 0
                                                          ? yachtRed
                                                          : yachtBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Center(
                                      //   child: Obx(
                                      //     () => AnimatedDigitWidget(
                                      //       duration:
                                      //           Duration(milliseconds: !controller.isPriceLoaded.value ? 1000 : 1000),
                                      //       curve: Curves.linear,
                                      //       prefix: controller.sunnyPicksReturn.value >= 0 ? '+' : '',
                                      //       suffix: '%',
                                      //       // value: 18.18,
                                      //       // autoSize: false,
                                      //       animateAutoSize: false,
                                      //       value: !controller.isPriceLoaded.value
                                      //           ? controller.randomNumber.value * 10
                                      //           : controller.sunnyPicksReturn.value * 100,
                                      //       fractionDigits: 2,
                                      //       // padding: EdgeInsets.all(0),
                                      //       textStyle: head1Style.copyWith(
                                      //         fontWeight: FontWeight.w700,
                                      //         letterSpacing: -1.2.w,
                                      //         color: !controller.isPriceLoaded.value
                                      //             ? yachtRed
                                      //             : controller.sunnyPicksReturn.value == 0.0
                                      //                 ? white
                                      //                 : controller.sunnyPicksReturn.value > 0
                                      //                     ? yachtRed
                                      //                     : yachtBlue,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                      // Obx(
                      //   () => Countup(
                      //     duration: Duration(milliseconds: 500),
                      //     begin: 0,
                      //     end: controller.pickWeather.value.toDouble(),
                      //     precision: 2,
                      //     // fractionDigits: 2,
                      //     style: body1Style,
                      //   ),
                      // ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.stockInfoNewModels!.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _mixpanelService.mixpanel.track('Old Yacht Pick Detail',
                                    properties: {'Stock Name': controller.stockInfoNewModels![index].name});
                                Get.to(() => StockInfoNewView(
                                      stockInfoNewModel: controller.stockInfoNewModels![index],
                                    ));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 14.w),
                                child: Container(
                                  // height: 88.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.w),
                                    color: yachtDarkGrey,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(14.w),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 75.w,
                                            width: 75.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            clipBehavior: Clip.hardEdge,
                                            child: CachedNetworkImage(
                                                imageUrl: 'https://storage.googleapis.com/ggook-5fb08.appspot.com/' +
                                                    controller.stockInfoNewModels![index].logoUrl),
                                          ),
                                          SizedBox(
                                            width: 14.w,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.stockInfoNewModels![index].name,
                                                style: TextStyle(
                                                    fontFamily: krFont,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16.w,
                                                    letterSpacing: 0.0,
                                                    height: 1.0,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 10.w,
                                              ),
                                              // GetBuilder<YachtPickOldController>(
                                              //   builder: (ctlr) {
                                              //     return
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Obx(
                                                    () => controller.isPriceLoaded.value
                                                        ? Text(
                                                            toPriceKRW(controller.currentClosePrices[index].value),
                                                            style: TextStyle(
                                                                fontFamily: krFont,
                                                                fontWeight: FontWeight.w400,
                                                                fontSize: 16.w,
                                                                letterSpacing: 0.0,
                                                                height: 1.0,
                                                                color: Colors.white),
                                                          )

                                                        // Countup(
                                                        //     duration: Duration(milliseconds: 500),
                                                        //     begin: 0,
                                                        //     end: controller.currentClosePrices[index].toDouble(),
                                                        //     precision: 0,
                                                        //     separator: ',',
                                                        //     // fractionDigits: 2,
                                                        //     style: TextStyle(
                                                        //         fontFamily: krFont,
                                                        //         fontWeight: FontWeight.w400,
                                                        //         fontSize: 16.w,
                                                        //         letterSpacing: 0.0,
                                                        //         height: 1.0,
                                                        //         color: Colors.white),
                                                        //   )
                                                        : TextLoadingWidget(
                                                            height: 16.w,
                                                            width: 50.w,
                                                          ),
                                                  ),
                                                  SizedBox(
                                                    height: 4.w,
                                                  ),
                                                  controller.isPriceLoaded.value
                                                      ? Obx(() => Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                // '+1,240(+0.51%)',
                                                                toPriceChangeKRW(
                                                                        controller.currentClosePrices[index].value -
                                                                            controller.previousClosePrices[index]) +
                                                                    ' (' +
                                                                    toPercentageChange(
                                                                        controller.currentClosePrices[index].value /
                                                                                controller.previousClosePrices[index] -
                                                                            1) +
                                                                    ')',
                                                                style: TextStyle(
                                                                    fontFamily: krFont,
                                                                    fontWeight: FontWeight.w400,
                                                                    fontSize: 14.w,
                                                                    letterSpacing: 0.0,
                                                                    height: 1.0,
                                                                    color: controller.currentClosePrices[index].value -
                                                                                controller.previousClosePrices[index] >
                                                                            0
                                                                        ? yachtRed
                                                                        : controller.currentClosePrices[index].value -
                                                                                    controller
                                                                                        .previousClosePrices[index] ==
                                                                                0
                                                                            ? white
                                                                            : yachtBlue),
                                                              ),
                                                            ],
                                                          ))
                                                      : TextLoadingWidget(
                                                          height: 14.w,
                                                          width: 80.w,
                                                        ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 6.w,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    // '요트픽 ' +
                                                    //     timeStampToShortShortString(
                                                    //         controller.stockInfoNewModels![index].updateTime) +
                                                    //     ' 대비',
                                                    'Pick 이후',
                                                    style: TextStyle(
                                                        fontFamily: krFont,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 14.w,
                                                        letterSpacing: 0.0,
                                                        height: 1.0,
                                                        color: yachtLightGrey),
                                                  ),
                                                  SizedBox(height: 4.w),
                                                  Obx(() => Row(
                                                        children: [
                                                          controller.isPriceLoaded.value
                                                              ? Text(
                                                                  toPriceChangeKRW(
                                                                          controller.currentClosePrices[index].value -
                                                                              controller.yachtPickOpenPrices[index]) +
                                                                      ' (' +
                                                                      toPercentageChange(controller
                                                                                  .currentClosePrices[index].value /
                                                                              controller.yachtPickOpenPrices[index] -
                                                                          1) +
                                                                      ')',
                                                                  style: TextStyle(
                                                                      fontFamily: krFont,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 14.w,
                                                                      letterSpacing: 0.0,
                                                                      height: 1.0,
                                                                      color: controller
                                                                                      .currentClosePrices[index].value -
                                                                                  controller
                                                                                      .yachtPickOpenPrices[index] >
                                                                              0
                                                                          ? yachtRed
                                                                          : controller.currentClosePrices[index].value -
                                                                                      controller
                                                                                          .yachtPickOpenPrices[index] ==
                                                                                  0
                                                                              ? white
                                                                              : yachtBlue),
                                                                )
                                                              : TextLoadingWidget(
                                                                  height: 14.w,
                                                                  width: 80.w,
                                                                ),
                                                        ],
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ]),
                                        Spacer(),
                                        Column(
                                          // mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Center(
                                              child: SvgPicture.asset(
                                                'assets/icons/${controller.stockInfoNewModels![index].yachtView.last.view}.svg',
                                                width: 26.w,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.w,
                                            ),
                                            Text(
                                              '업데이트 날짜',
                                              style: sub1Style.copyWith(color: yachtLightGrey),
                                            ),
                                            SizedBox(
                                              height: 4.w,
                                            ),
                                            Text(
                                              timeStampToShorterString(
                                                  controller.stockInfoNewModels![index].yachtView.last.viewDate),
                                              style: body2Style,
                                            ),
                                            SizedBox(
                                              height: 8.w,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container();
          }),
    );
  }
}
