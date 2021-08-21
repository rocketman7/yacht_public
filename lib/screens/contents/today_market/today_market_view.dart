import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'today_market_view_model.dart';

class TodayMarketView extends GetView {
  final HomeViewModel homeViewModel;
  TodayMarketView({Key? key, required this.homeViewModel}) : super(key: key);

  @override
  // TODO: implement controller
  get controller => Get.put(TodayMarketViewModel());
  @override
  Widget build(BuildContext context) {
    PageController pageController =
        PageController(keepPage: true, initialPage: controller.newsIndex.value);

    pageController.addListener(() {
      controller.newsIndex(pageController.page!.round());
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: primaryPaddingSize),
          // color: Colors.red,
          child: Text("오늘의 시장", style: sectionTitle),
        ),
        SizedBox(
          height: heightSectionTitleAndBox,
        ),
        Padding(
          padding: primaryHorizontalPadding,
          child: sectionBox(
              height: 184.w,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: primaryPaddingSize),
              child: Column(
                children: [
                  Obx(
                    () => Flexible(
                      child: PageView.builder(
                          itemCount: controller.todayMarkets.length,
                          controller: pageController,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                await controller.launchUrl(
                                    controller.todayMarkets[index].newsUrl);
                              },
                              child: Container(
                                padding: primaryHorizontalPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#${controller.todayMarkets[index].category}',
                                      style: subheadingStyle.copyWith(
                                          color: yachtViolet,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: correctHeight(
                                          20.w,
                                          subheadingStyle.fontSize,
                                          sectionTitle.fontSize),
                                    ),
                                    Text(controller.todayMarkets[index].title,
                                        style: sectionTitle.copyWith(
                                            height: 1.35)),
                                    SizedBox(
                                      height: correctHeight(
                                          14.w,
                                          sectionTitle.fontSize,
                                          contentStyle.fontSize),
                                    ),
                                    Text(
                                      controller.todayMarkets[index].summary,
                                      style: contentStyle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                          controller.todayMarkets.length,
                          (index) => Row(
                                children: [
                                  Container(
                                    height: 6.w,
                                    width: 6.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: controller.newsIndex.value == index
                                          ? yachtDarkGrey
                                          : buttonBackgroundPurple,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ))))
                ],
              )),
        ),
        SizedBox(
          height: 10.w,
        ),
        Padding(
          padding: primaryHorizontalPadding,
          child: sectionBox(
              height: 184.w,
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: primaryPaddingSize),
              child: Column(
                children: [
                  Obx(
                    () => Flexible(
                      child: PageView.builder(
                          itemCount: controller.todayMarkets.length,
                          controller: pageController,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                await controller.launchUrl(
                                    controller.todayMarkets[index].newsUrl);
                              },
                              child: Container(
                                padding: primaryHorizontalPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#${controller.todayMarkets[index].category}',
                                      style: subheadingStyle.copyWith(
                                          color: yachtViolet,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: correctHeight(
                                          20.w,
                                          subheadingStyle.fontSize,
                                          sectionTitle.fontSize),
                                    ),
                                    Text(controller.todayMarkets[index].title,
                                        style: sectionTitle.copyWith(
                                            height: 1.35)),
                                    SizedBox(
                                      height: correctHeight(
                                          14.w,
                                          sectionTitle.fontSize,
                                          contentStyle.fontSize),
                                    ),
                                    Text(
                                      controller.todayMarkets[index].summary,
                                      style: contentStyle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                  Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                          controller.todayMarkets.length,
                          (index) => Row(
                                children: [
                                  Container(
                                    height: 6.w,
                                    width: 6.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: controller.newsIndex.value == index
                                          ? yachtDarkGrey
                                          : buttonBackgroundPurple,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ))))
                ],
              )),
        ),
      ],
    );
  }
}
