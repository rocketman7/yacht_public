import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/stock_info/news/news_view_model.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class NewsView extends GetView<NewsViewModel> {
  final StockAddressModel stockAddressModel;
  NewsView({
    required this.stockAddressModel,
  });

  @override
  // TODO: implement controller
  NewsViewModel get controller => Get.put(NewsViewModel(stockAddressModel));

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  controller.title, // viewModel의 데이터를 바로 쓸 수 있음
                  style: questTitleTextStyle,
                ),
                SizedBox(
                  height: controller.newsList.length == 0
                      ? reducedPaddingWhenTextIsBelow(
                          20.w, detailedContentTextStyle.fontSize!)
                      : 20.w,
                ),
                controller.newsList.length == 0
                    ? Text(
                        "뉴스가 없습니다",
                        style: detailedContentTextStyle,
                      )
                    : Container(),
                ...List.generate(controller.newsList.length, (index) {
                  return buildNewsWidget(index);
                }),
                controller.newsList.length != 0
                    ? Align(
                        alignment: Alignment.centerRight,
                        child: Obx(
                          () => Text(
                            "${controller.corporationName} 뉴스 더보기",
                            style: detailedContentTextStyle.copyWith(
                                color: deepBlue,
                                fontSize: 14.w,
                                fontWeight: FontWeight.w600),
                          ),
                        ))
                    : Container()
              ],
            ),
    );
  }

  Column buildNewsWidget(int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => NewsWebView(
                  url: controller.newsList[index].newsUrl,
                ));
          },
          child: Container(
            height: 84.w,
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  child: controller.isLoading.value
                      ? Container()
                      : Column(
                          // mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.newsList[index].title,
                              style: detailedContentTextStyle.copyWith(
                                  fontWeight: FontWeight.w500),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Text(
                                  controller.newsList[index].dateTime
                                      .toDate()
                                      .toString(),
                                  style: detailedContentTextStyle.copyWith(
                                      fontSize: 12.w,
                                      fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  controller.newsList[index].newspaper,
                                  style: detailedContentTextStyle.copyWith(
                                      fontSize: 12.w,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ],
                        ),
                )),
                SizedBox(
                  width: 10.w,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.w),
                  child: Container(
                    height: 84.w,
                    width: 84.w,
                    color: Colors.yellow[200],
                    // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                    child: controller.newsList[index].imageUrl == null
                        ? Container()
                        : Image.network(
                            controller.newsList[index].imageUrl!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 20.w,
          color: dividerColor,
        )
      ],
    );
  }
}

class NewsWebView extends StatefulWidget {
  final String url;

  const NewsWebView({Key? key, required this.url}) : super(key: key);

  @override
  _NewsWebViewState createState() => _NewsWebViewState();
}

class _NewsWebViewState extends State<NewsWebView> {
  final GlobalKey webViewKey = GlobalKey();
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
      ));

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      key: webViewKey,
      initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
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
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
      // shouldOverrideUrlLoading: (controller, navigationAction) async {
      //   var uri = navigationAction.request.url!;

      //   if (!["http", "https", "file", "chrome", "data", "javascript", "about"]
      //       .contains(uri.scheme)) {
      //     if (await canLaunch(url)) {
      //       // Launch the App
      //       await launch(
      //         url,
      //       );
      //       // and cancel the request
      //       return NavigationActionPolicy.CANCEL;
      //     }
      //   }

      //   return NavigationActionPolicy.ALLOW;
      // },
      // onLoadStop: (controller, url) async {
      //   pullToRefreshController.endRefreshing();
      //   setState(() {
      //     this.url = url.toString();
      //     urlController.text = this.url;
      //   });
      // },
      // onLoadError: (controller, url, code, message) {
      //   pullToRefreshController.endRefreshing();
      // },
      // onProgressChanged: (controller, progress) {
      //   if (progress == 100) {
      //     pullToRefreshController.endRefreshing();
      //   }
      //   setState(() {
      //     this.progress = progress / 100;
      //     urlController.text = this.url;
      //   });
      // },
      // onUpdateVisitedHistory: (controller, url, androidIsReload) {
      //   setState(() {
      //     this.url = url.toString();
      //     urlController.text = this.url;
      //   });
      // },
      onConsoleMessage: (controller, consoleMessage) {
        print(consoleMessage);
      },
    );
  }
}
