import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/reading_content_model.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_view_model.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_see_all_view.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yachtOne/widgets/loading_container.dart';

import '../../../locator.dart';

class ReadingContentView extends GetView<ReadingContentViewModel> {
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  // TODO: implement controller
  get controller => Get.put(ReadingContentViewModel());

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: primaryPaddingSize),
        // color: Colors.red,
        child: Text("요트 매거진", style: sectionTitle),
      ),
      SizedBox(
        height: primaryPaddingSize,
      ),
      Obx(() => controller.readingContents.length > 0
          ? GridView.builder(
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(
                horizontal: 14.w,
              ),
              physics: ClampingScrollPhysics(),
              itemCount: 6,
              shrinkWrap: true,
              // primary: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 14.w,
                childAspectRatio: 166 / 148,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _mixpanelService.mixpanel.track('Yacht Magazine', properties: {
                      'Magazine Title': controller.readingContents[index].title,
                      'Magazine Category': controller.readingContents[index].category,
                      'Magazine Content Url': controller.readingContents[index].contentUrl,
                      'Magazine Thumbnail Url': controller.readingContents[index].thumbnailUrl,
                      'Magazine Update DateTime':
                          controller.readingContents[index].updateDateTime.toDate().toIso8601String(),
                    });
                    Get.to(() => ReadingContentWebView(readingContent: controller.readingContents[index]));
                    // await controller.launchUrl(controller.readingContents[index].contentUrl);
                  },
                  child: Container(
                      // padding: EdgeInsets.all(4.w),
                      decoration: yachtBoxDecoration.copyWith(
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(
                            color: yachtLightBlack,
                            width: 4.w,
                          )),
                      //  BoxDecoration(

                      //     borderRadius: BorderRadius.circular(12.w),
                      //     color: Colors.blue,
                      //     border: Border.all(
                      //       color: yachtBlack,
                      //       width: 4.w,
                      //     )),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://storage.googleapis.com/ggook-5fb08.appspot.com/${controller.readingContents[index].thumbnailUrl}",
                        // width: 270.w,
                        // height: 240.w,
                        filterQuality: FilterQuality.high,
                        progressIndicatorBuilder: (_, __, DownloadProgress progress) {
                          // progress.totalSize
                          // if (progress == null) return child;
                          return LayoutBuilder(builder: (context, constraints) {
                            return LoadingContainer(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              radius: 10.w,
                            );
                          });
                        },
                      )),
                );
              },
            )
          : Container()),
      GestureDetector(
        onTap: () {
          // _mixpanelService.mixpanel.track('Yacht Magazine - See All');
          Get.to(ReadingContentSeeAll());
        },
        child: Padding(
          padding: primaryAllPadding,
          child: Container(
            width: double.infinity,
            height: 50.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              color: yachtDarkGrey,
            ),
            child: Center(
                child: Text(
              "모두 보기",
              style: seeMore.copyWith(
                color: white,
              ),
            )),
          ),
        ),
      )
      // SingleChildScrollView(
      //     clipBehavior: Clip.none,
      //     scrollDirection: Axis.horizontal,
      //     child: Obx(() {
      //       if (controller.readingContents.length > 0) {
      //         return Row(
      //           children: List.generate(
      //               controller.readingContents.length,
      //               (index) => Row(
      //                     children: [
      //                       index == 0
      //                           ? SizedBox(
      //                               width: primaryPaddingSize,
      //                             )
      //                           : Container(),
      //                       InkWell(
      //                         onTap: () {
      //                           _mixpanelService.mixpanel.track('Yacht Magazine', properties: {
      //                             'Magazine Title': controller.readingContents[index].title,
      //                             'Magazine Category': controller.readingContents[index].category,
      //                             'Magazine Content Url': controller.readingContents[index].contentUrl,
      //                             'Magazine Thumbnail Url': controller.readingContents[index].thumbnailUrl,
      //                             'Magazine Update DateTime':
      //                                 controller.readingContents[index].updateDateTime.toDate().toIso8601String(),
      //                           });
      //                           Get.to(() => ReadingContentWebView(readingContent: controller.readingContents[index]));
      //                           // await controller.launchUrl(controller.readingContents[index].contentUrl);
      //                         },
      //                         child: Container(
      //                             child: CachedNetworkImage(
      //                           imageUrl:
      //                               "https://storage.googleapis.com/ggook-5fb08.appspot.com/${controller.readingContents[index].thumbnailUrl}",
      //                           width: 270.w,
      //                           height: 240.w,
      //                           filterQuality: FilterQuality.high,
      //                           progressIndicatorBuilder: (_, __, DownloadProgress progress) {
      //                             // progress.totalSize
      //                             // if (progress == null) return child;
      //                             return LoadingContainer(
      //                               width: 270.w,
      //                               height: 240.w,
      //                               radius: 10.w,
      //                             );
      //                           },
      //                         )),
      //                       ),
      //                       SizedBox(
      //                         width: primaryPaddingSize,
      //                       )
      //                     ],
      //                   )),
      //         );
      //       } else {
      //         return Container(
      //           width: 270.w,
      //           height: 240.w,
      //         );
      //       }
      //     }))
    ]);
  }
}

class ReadingContentWebView extends StatefulWidget {
  final ReadingContentModel readingContent;

  const ReadingContentWebView({Key? key, required this.readingContent}) : super(key: key);

  @override
  _ReadingContentWebViewState createState() => _ReadingContentWebViewState();
}

class _ReadingContentWebViewState extends State<ReadingContentWebView> {
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
      appBar: primaryAppBar(widget.readingContent.title),
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
                initialUrlRequest: URLRequest(url: Uri.parse(widget.readingContent.contentUrl)),
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
