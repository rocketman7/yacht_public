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

class YachtPickOldController extends GetxController {
  List<StockInfoNewModel>? stockInfoNewModels;

  FirestoreService _firestoreService = locator<FirestoreService>();

  bool isModelLoaded = false;

  List<num> currentClosePrices = <num>[]; // 가장 가까운 영업일의 cycle D 히스토리컬 프라이스 종가
  List<num> previousClosePrices = <num>[]; // 그 전 영업일의 cycle D 히스토리컬 프라이스 종가
  List<num> yachtPickClosePrices = <num>[]; // 요트픽한 가장 가까운 전 영업일 cycle D 히스토리컬 프라이스 종가

  @override
  void onInit() async {
    stockInfoNewModels = await _firestoreService.getOldYachtPicks();

    currentClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0);
    previousClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0);
    yachtPickClosePrices = List.generate(stockInfoNewModels!.length, (index) => 0);

    await getPrices();

    isModelLoaded = true;

    update();

    super.onInit();
  }

  getPrices() async {
    for (int i = 0; i < stockInfoNewModels!.length; i++) {
      currentClosePrices[i] = await _firestoreService.getClosePrice(
        stockInfoNewModels![i].code,
        previousBusinessDay(
          DateTime.now(),
        ),
      );
    }

    for (int i = 0; i < stockInfoNewModels!.length; i++) {
      previousClosePrices[i] = await _firestoreService.getClosePrice(
        stockInfoNewModels![i].code,
        previousBusinessDay(previousBusinessDay(
          DateTime.now(),
        )),
      );
    }

    for (int i = 0; i < stockInfoNewModels!.length; i++) {
      yachtPickClosePrices[i] = await _firestoreService.getClosePrice(
        stockInfoNewModels![i].code,
        previousBusinessDay(
          stockInfoNewModels![i].updateTime.toDate(),
        ),
      );
    }
  }
}

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
                                        Text(
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
                                        ),
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
