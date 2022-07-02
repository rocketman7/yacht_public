import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/stock_info/yacht_pick_view.dart';

import '../../locator.dart';
import '../../services/firestore_service.dart';
import '../../styles/size_config.dart';
import '../../styles/yacht_design_system.dart';
import 'stock_info_new_controller.dart';

class YachtPickOldController extends GetxController {
  List<StockInfoNewModel>? stockInfoNewModels;

  FirestoreService _firestoreService = locator<FirestoreService>();

  bool isModelLoaded = false;

  @override
  void onInit() async {
    stockInfoNewModels = await _firestoreService.getOldYachtPicks();

    isModelLoaded = true;

    update();

    super.onInit();
  }
}

class YachtPickOldView extends StatelessWidget {
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
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 14.w, right: 14.w, bottom: 14.w),
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
                                  Container(
                                    alignment: Alignment.center,
                                    height: 60.w,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            'https://storage.googleapis.com/ggook-5fb08.appspot.com/' +
                                                controller
                                                    .stockInfoNewModels![index]
                                                    .logoUrl),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    children: [
                                      Text('현대차'),
                                      Text('현대차'),
                                      Row(
                                        children: [
                                          Text('현대차'),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text('현대차'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('현대차'),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text('현대차'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Text('2022-06-2023')
                                ]),
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
