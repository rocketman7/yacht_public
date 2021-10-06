import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/today_market_model.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../locator.dart';
import 'today_market_view_model.dart';

class TodayMarketView extends GetView<TodayMarketViewModel> {
  final HomeViewModel homeViewModel;
  TodayMarketView({Key? key, required this.homeViewModel}) : super(key: key);
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  // TODO: implement controller
  get controller => Get.put(TodayMarketViewModel());
  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(keepPage: true, initialPage: controller.newsIndex.value);

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
                              onTap: () {
                                _mixpanelService.mixpanel.track('home-TodayMarket-TodayMarketWebView',
                                    properties: {'todayMarketTitle': controller.todayMarkets[index].title});
                                Get.to(() => TodayMarketWebView(todayMarket: controller.todayMarkets[index]));
                              },
                              child: Container(
                                padding: primaryHorizontalPadding,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#${controller.todayMarkets[index].category}',
                                      style: subheadingStyle.copyWith(color: yachtViolet, fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: correctHeight(20.w, subheadingStyle.fontSize, sectionTitle.fontSize),
                                    ),
                                    Text(controller.todayMarkets[index].title,
                                        style: sectionTitle.copyWith(height: 1.35)),
                                    SizedBox(
                                      height: correctHeight(14.w, sectionTitle.fontSize, contentStyle.fontSize),
                                    ),
                                    Text(
                                      controller.todayMarkets[index].summary ?? "",
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
                                      color: controller.newsIndex.value == index ? yachtDarkGrey : primaryButtonText,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                ],
                              ))))
                ],
              )),
        ),
        // SizedBox(
        //   height: 10.w,
        // ),
        // Padding(
        //   padding: primaryHorizontalPadding,
        //   child: sectionBox(
        //       height: 184.w,
        //       width: double.infinity,
        //       padding: EdgeInsets.symmetric(vertical: primaryPaddingSize),
        //       child: Column(
        //         children: [
        //           Obx(
        //             () => Flexible(
        //               child: PageView.builder(
        //                   itemCount: controller.todayMarkets.length,
        //                   controller: pageController,
        //                   itemBuilder: (context, index) {
        //                     return InkWell(
        //                       onTap: () async {
        //                         await controller.launchUrl(controller.todayMarkets[index].newsUrl);
        //                       },
        //                       child: Container(
        //                         padding: primaryHorizontalPadding,
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           mainAxisAlignment: MainAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               '#${controller.todayMarkets[index].category}',
        //                               style: subheadingStyle.copyWith(color: yachtViolet, fontWeight: FontWeight.w400),
        //                             ),
        //                             SizedBox(
        //                               height: correctHeight(20.w, subheadingStyle.fontSize, sectionTitle.fontSize),
        //                             ),
        //                             Text(controller.todayMarkets[index].title,
        //                                 style: sectionTitle.copyWith(height: 1.35)),
        //                             SizedBox(
        //                               height: correctHeight(14.w, sectionTitle.fontSize, contentStyle.fontSize),
        //                             ),
        //                             Text(
        //                               controller.todayMarkets[index].summary,
        //                               style: contentStyle,
        //                               maxLines: 2,
        //                               overflow: TextOverflow.ellipsis,
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     );
        //                   }),
        //             ),
        //           ),
        //           Obx(() => Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               mainAxisSize: MainAxisSize.max,
        //               children: List.generate(
        //                   controller.todayMarkets.length,
        //                   (index) => Row(
        //                         children: [
        //                           Container(
        //                             height: 6.w,
        //                             width: 6.w,
        //                             decoration: BoxDecoration(
        //                               shape: BoxShape.circle,
        //                               color:
        //                                   controller.newsIndex.value == index ? yachtDarkGrey : buttonBackgroundPurple,
        //                             ),
        //                           ),
        //                           SizedBox(width: 8.w),
        //                         ],
        //                       ))))
        //         ],
        //       )),
        // ),
      ],
    );
  }
}

class TodayMarketWebView extends StatefulWidget {
  final TodayMarketModel todayMarket;

  const TodayMarketWebView({Key? key, required this.todayMarket}) : super(key: key);

  @override
  _TodayMarketWebViewState createState() => _TodayMarketWebViewState();
}

class _TodayMarketWebViewState extends State<TodayMarketWebView> {
  final GlobalKey webViewKey = GlobalKey();
  RxDouble progessPercent = 0.0.obs;

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(widget.todayMarket.category),
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Container(
                  padding: EdgeInsets.all(10.0),
                  child: progessPercent.value < 1.0
                      ? LinearProgressIndicator(
                          value: progessPercent.value,
                          backgroundColor: primaryButtonText,
                          valueColor: AlwaysStoppedAnimation<Color>(yachtViolet),
                        )
                      : Container()),
            ),
            Expanded(
              child: InAppWebView(
                key: webViewKey,
                onProgressChanged: (controller, progress) {
                  // print('progress: $progress');
                  progessPercent(progress / 100);
                },
                initialUrlRequest: URLRequest(url: Uri.parse(widget.todayMarket.newsUrl)),
                initialOptions: options,

                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                // onLoadStart: (controller, url) {
                //   setState(() {
                //     this.url = url.toString();
                //     urlController.text = this.url;
                //   });
                // },
                androidOnPermissionRequest: (controller, origin, resources) async {
                  return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                },
                // shouldOverrideUrlLoading: (controller, navigationAction) async {

                onConsoleMessage: (controller, consoleMessage) {
                  // print(consoleMessage);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
