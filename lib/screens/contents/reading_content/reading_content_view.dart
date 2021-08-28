import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/reading_content_model.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_view_model.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReadingContentView extends GetView {
  final HomeViewModel homeViewModel;
  ReadingContentView({Key? key, required this.homeViewModel}) : super(key: key);

  @override
  // TODO: implement controller
  get controller => Get.put(ReadingContentViewModel());

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: primaryPaddingSize),
        // color: Colors.red,
        child: Text("읽을 거리", style: sectionTitle),
      ),
      SizedBox(
        height: heightSectionTitleAndBox,
      ),
      SingleChildScrollView(
          clipBehavior: Clip.none,
          scrollDirection: Axis.horizontal,
          child: Obx(() {
            if (controller.readingContents.length > 0) {
              return Row(
                children: List.generate(
                    controller.readingContents.length,
                    (index) => Row(
                          children: [
                            index == 0
                                ? SizedBox(
                                    width: primaryPaddingSize,
                                  )
                                : Container(),
                            InkWell(
                              onTap: () {
                                Get.to(() => ReadingContentWebView(readingContent: controller.readingContents[index]));
                                // await controller.launchUrl(controller.readingContents[index].contentUrl);
                              },
                              child: Container(
                                  child: FutureBuilder<String>(
                                      future: controller
                                          .getImageUrlFromStorage(controller.readingContents[index].thumbnailUrl),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          String imageUrl = snapshot.data!;
                                          return Image.network(
                                            imageUrl,
                                            width: 270.w,
                                            height: 240.w,
                                          );
                                        } else {
                                          return Container(
                                            width: 270.w,
                                            height: 240.w,
                                          );
                                        }
                                      })),
                            ),
                            SizedBox(
                              width: primaryPaddingSize,
                            )
                          ],
                        )),
              );
            } else {
              return Container(
                width: 270.w,
                height: 240.w,
              );
            }
          }))
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
                          backgroundColor: buttonBackgroundPurple,
                          valueColor: AlwaysStoppedAnimation<Color>(yachtViolet),
                        )
                      : Container()),
            ),
            Expanded(
              child: InAppWebView(
                key: webViewKey,
                onProgressChanged: (controller, progress) {
                  print('progress: $progress');
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
