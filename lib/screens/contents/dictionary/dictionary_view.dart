import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/dictionary_model.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';
import '../../../locator.dart';
import 'dictionary_view_model.dart';

class DictionaryView extends StatelessWidget {
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final dictionaryViewModel = Get.put(DictionaryViewModel());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: defaultHorizontalPadding,
          // color: Colors.red,
          child: Text("금융 백과사전", style: sectionTitle),
        ),
        SizedBox(
          height: primaryPaddingSize,
        ),
        Padding(
          padding: defaultHorizontalPadding,
          child: sectionBox(
            // padding: defaultPaddingAll,
            child: Obx(() => Column(
                  children: List.generate(
                      dictionaryViewModel.dictionaries.length,
                      (index) => InkWell(
                            onTap: () {
                              _mixpanelService.mixpanel.track('Dictionary', properties: {
                                'Dictionary Title': dictionaryViewModel.dictionaries[index].title,
                                'Dictionary Image Url': dictionaryViewModel.dictionaries[index].imageUrl,
                                'Dictionary Url': dictionaryViewModel.dictionaries[index].dictionaryUrl,
                                'Dictionary Update DateTime':
                                    dictionaryViewModel.dictionaries[index].updateDateTime.toDate().toIso8601String(),
                              });
                              Get.to(() => DictionaryWebView(dictionaryModel: dictionaryViewModel.dictionaries[index]));
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: defaultPaddingAll,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 50.w,
                                        width: 50.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.w),
                                          // color: yachtRed,
                                        ),
                                        child: Image.network(
                                          "https://storage.googleapis.com/ggook-5fb08.appspot.com/${dictionaryViewModel.dictionaries[index].imageUrl}",
                                        ),
                                      ),
                                      SizedBox(width: 14.w),
                                      Text(
                                        dictionaryViewModel.dictionaries[index].title,
                                        style: dictionaryKeyword,
                                      )
                                    ],
                                  ),
                                ),
                                (index != (dictionaryViewModel.dictionaries.length - 1))
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
