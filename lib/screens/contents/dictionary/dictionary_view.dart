import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/dictionary_model.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DictionaryView extends StatelessWidget {
  final HomeViewModel homeViewModel;
  const DictionaryView({Key? key, required this.homeViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: primaryHorizontalPadding,
          // color: Colors.red,
          child: Text("금융 백과사전", style: sectionTitle),
        ),
        SizedBox(
          height: heightSectionTitleAndBox,
        ),
        Padding(
          padding: primaryAllPadding,
          child: sectionBox(
              // padding: primaryAllPadding,
              child: Column(
            children: List.generate(
                homeViewModel.dictionaries.length,
                (index) => InkWell(
                      onTap: () {
                        Get.to(() => DictionaryWebView(dictionaryModel: homeViewModel.dictionaries[index]));
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: primaryAllPadding,
                            child: Row(
                              children: [
                                FutureBuilder<String>(
                                    future: homeViewModel
                                        .getImageUrlFromStorage(homeViewModel.dictionaries[index].imageUrl),
                                    builder: (context, snapshot) {
                                      return !snapshot.hasData
                                          ? Container(
                                              height: 50.w,
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5.w),
                                                color: white,
                                              ),
                                            )
                                          : Container(
                                              height: 50.w,
                                              width: 50.w,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5.w),
                                                // color: yachtRed,
                                              ),
                                              child: Image.network(
                                                snapshot.data!,
                                              ),
                                            );
                                    }),
                                SizedBox(width: 14.w),
                                Text(homeViewModel.dictionaries[index].title,
                                    style: dictionaryKeyword.copyWith(
                                      fontFamily: 'Default',
                                      // fontWeight: FontWeight.w400,
                                    ))
                              ],
                            ),
                          ),
                          (index != (homeViewModel.dictionaries.length - 1))
                              ? Container(
                                  height: 1,
                                  color: thinDivider,
                                )
                              : Container()
                        ],
                      ),
                    )),
          )),
        ),
      ],
    );
  }
}

class DictionaryWebView extends StatefulWidget {
  final DictionaryModel dictionaryModel;

  const DictionaryWebView({Key? key, required this.dictionaryModel}) : super(key: key);

  @override
  _DictionaryWebViewState createState() => _DictionaryWebViewState();
}

class _DictionaryWebViewState extends State<DictionaryWebView> {
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
      appBar: primaryAppBar(widget.dictionaryModel.title),
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
                initialUrlRequest: URLRequest(url: Uri.parse(widget.dictionaryModel.dictionaryUrl)),
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
