import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/today_market_model.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
// import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/yacht_design_system/yds_appbar.dart';
import 'package:yachtOne/yacht_design_system/yds_color.dart';
import 'package:yachtOne/yacht_design_system/yds_container.dart';
import 'package:yachtOne/yacht_design_system/yds_font.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

import '../../../locator.dart';
import 'today_market_view_model.dart';

class TodayMarketView extends GetView<TodayMarketViewModel> {
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
        // SizedBox(height: 14.w),
        Container(
          height: 20.w,
          // color: Colors.blue,
        ),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: primaryPaddingSize),
        //   // color: Colors.red,
        //   child: Text("오늘의 시장", style: sectionTitle),
        // ),
        // SizedBox(
        //   height: heightSectionTitleAndBox,
        // ),
        Padding(
          padding: defaultHorizontalPadding,
          child: defaultContainer(
              height: 184.w,
              // width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: defaultPaddingSize),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Flexible(
                      child: SizedBox(
                        // height: 160.w,
                        child: PageView.builder(
                            itemCount: controller.todayMarkets.length,
                            controller: pageController,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  _mixpanelService.mixpanel.track('Today Market', properties: {
                                    'Today Market Category': controller.todayMarkets[index].category,
                                    'Today Market Title': controller.todayMarkets[index].title,
                                    'Today Market Url': controller.todayMarkets[index].newsUrl,
                                    'Today Market DateTime':
                                        controller.todayMarkets[index].dateTime.toDate().toIso8601String(),
                                    'Today Market Newspapaer': controller.todayMarkets[index].newspaper,
                                    'Today Market Image Url': controller.todayMarkets[index].imageUrl ?? "",
                                  });
                                  _mixpanelService.mixpanel.flush();
                                  Get.to(() => TodayMarketWebView(todayMarket: controller.todayMarkets[index]));
                                },
                                child: Container(
                                  clipBehavior: Clip.none,
                                  padding: defaultHorizontalPadding,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '#${controller.todayMarkets[index].category}',
                                        style: body2Style.copyWith(
                                          color: yachtBlue,
                                          fontWeight: FontWeight.w500,
                                          // height: 1.1,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20.w,
                                      ),
                                      Text(controller.todayMarkets[index].title,
                                          style: head2Style.copyWith(
                                            height: 1.4,
                                          )),
                                      SizedBox(
                                        height: 12.w,
                                      ),
                                      Text(
                                        controller.todayMarkets[index].summary ?? "",
                                        style: body2Style.copyWith(height: 1.4),
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
                                      color: controller.newsIndex.value == index ? yachtWhite : yachtMidGrey,
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
        //   padding: defaultHorizontalPadding,
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
        //                         padding: defaultHorizontalPadding,
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
      appBar: defaultAppBar(widget.todayMarket.category),
      backgroundColor: yachtBlack,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Container(
                  padding: EdgeInsets.all(10.0),
                  child: progessPercent.value < 1.0
                      ? LinearProgressIndicator(
                          value: progessPercent.value,
                          backgroundColor: yachtLightGrey,
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
