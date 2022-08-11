import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/stock_info/stock_info_new_view.dart';
import 'package:yachtOne/screens/stock_info/yacht_pick_view.dart';
import 'package:yachtOne/services/mixpanel_service.dart';

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
    return Scaffold(
      backgroundColor: yachtBlack,
      appBar: AppBar(
          backgroundColor: primaryBackgroundColor,
          title: Text(
            "지난 요트 Pick",
            style: appBarTitle,
          )),
      body: GetBuilder<YachtPickOldController>(
          init: YachtPickOldController(),
          builder: (controller) {
            return controller.isModelLoaded
                ? ListView.builder(
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
                                      width: 10.w,
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
                                          height: 4.w,
                                        ),
                                        GetBuilder<YachtPickOldController>(
                                          builder: (ctlr) {
                                            return ctlr.isPriceLoaded
                                                ? Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        toPriceKRW(controller.currentClosePrices[index]),
                                                        // '36,200',
                                                        style: TextStyle(
                                                            fontFamily: krFont,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 16.w,
                                                            letterSpacing: 0.0,
                                                            height: 1.0,
                                                            color: Colors.white),
                                                      ),
                                                      SizedBox(
                                                        height: 2.w,
                                                      ),
                                                      Text(
                                                        // '+1,240(+0.51%)',
                                                        toPriceKRW(controller.currentClosePrices[index] -
                                                                controller.previousClosePrices[index]) +
                                                            '(' +
                                                            toPercentageChange(controller.currentClosePrices[index] /
                                                                    controller.previousClosePrices[index] -
                                                                1) +
                                                            ')',
                                                        style: TextStyle(
                                                            fontFamily: krFont,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 12.w,
                                                            letterSpacing: 0.0,
                                                            height: 1.0,
                                                            color: controller.currentClosePrices[index] -
                                                                        controller.previousClosePrices[index] >
                                                                    0
                                                                ? yachtRed
                                                                : controller.currentClosePrices[index] -
                                                                            controller.previousClosePrices[index] ==
                                                                        0
                                                                    ? white
                                                                    : yachtBlue),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        '0',
                                                        style: TextStyle(
                                                            fontFamily: krFont,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 16.w,
                                                            letterSpacing: 0.0,
                                                            height: 1.0,
                                                            color: Colors.white),
                                                      ),
                                                      SizedBox(
                                                        height: 2.w,
                                                      ),
                                                      Text(
                                                        '+0(+0.00%)',
                                                        style: TextStyle(
                                                            fontFamily: krFont,
                                                            fontWeight: FontWeight.w400,
                                                            fontSize: 12.w,
                                                            letterSpacing: 0.0,
                                                            height: 1.0,
                                                            color: white),
                                                      ),
                                                    ],
                                                  );
                                          },
                                        ),
                                        SizedBox(
                                          height: 9.w,
                                        ),
                                        Text(
                                          '요트픽 ' +
                                              timeStampToShortShortString(
                                                  controller.stockInfoNewModels![index].updateTime) +
                                              ' 대비',
                                          style: TextStyle(
                                              fontFamily: krFont,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.w,
                                              letterSpacing: 0.0,
                                              height: 1.0,
                                              color: yachtLightGrey),
                                        ),
                                        SizedBox(
                                          height: 2.w,
                                        ),
                                        GetBuilder<YachtPickOldController>(builder: (ctlr) {
                                          return ctlr.isPriceLoaded
                                              ? Text(
                                                  toPriceKRW(controller.currentClosePrices[index] -
                                                          controller.yachtPickClosePrices[index]) +
                                                      '(' +
                                                      toPercentageChange(controller.currentClosePrices[index] /
                                                              controller.yachtPickClosePrices[index] -
                                                          1) +
                                                      ')',
                                                  style: TextStyle(
                                                      fontFamily: krFont,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12.w,
                                                      letterSpacing: 0.0,
                                                      height: 1.0,
                                                      color: controller.currentClosePrices[index] -
                                                                  controller.yachtPickClosePrices[index] >
                                                              0
                                                          ? yachtRed
                                                          : controller.currentClosePrices[index] -
                                                                      controller.yachtPickClosePrices[index] ==
                                                                  0
                                                              ? white
                                                              : yachtBlue),
                                                )
                                              : Text(
                                                  '+0',
                                                  style: TextStyle(
                                                      fontFamily: krFont,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 12.w,
                                                      letterSpacing: 0.0,
                                                      height: 1.0,
                                                      color: white),
                                                );
                                        }),
                                      ],
                                    ),
                                  ]),
                                  Spacer(),
                                  Text(
                                    timeStampToShortString(controller.stockInfoNewModels![index].updateTime),
                                    style: TextStyle(
                                        fontFamily: krFont,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.w,
                                        letterSpacing: 0.0,
                                        height: 1.0,
                                        color: yachtLightGrey),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container();
          }),
    );
  }
}
