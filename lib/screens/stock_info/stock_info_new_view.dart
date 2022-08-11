import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:universal_io/io.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:yachtOne/models/stock_info_new_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_new_controller.dart';
import 'package:yachtOne/styles/size_config.dart';

import '../../styles/yacht_design_system.dart';
import 'yacht_pick_view.dart';

final stockNameTextStyle = TextStyle(
  fontSize: 20.w,
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  color: Colors.white,
  letterSpacing: 0.0,
  height: 1.0,
);

final categorySelectTextStyle = TextStyle(
  fontSize: 16.w,
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  color: white,
  letterSpacing: 0.0,
  height: 1.2,
);
final categoryGeneralTextStyle = TextStyle(
  fontSize: 16.w,
  fontWeight: FontWeight.w400,
  fontFamily: 'NotoSansKR',
  color: Colors.white,
  letterSpacing: 0.0,
  height: 1.2,
);

final loadingTextStyle = TextStyle(
  fontSize: 14.w,
  fontWeight: FontWeight.w400,
  fontFamily: 'NotoSansKR',
  color: yachtGrey,
  letterSpacing: 0.0,
  height: 1.2,
);

class TempLoadingContainer extends StatefulWidget {
  final double? height;
  final double? width;
  final double radius;
  TempLoadingContainer({
    Key? key,
    this.height,
    this.width,
    required this.radius,
  }) : super(key: key);

  @override
  _TempLoadingContainerState createState() => _TempLoadingContainerState();
}

class _TempLoadingContainerState extends State<TempLoadingContainer> {
  RxDouble animator = 0.0.obs;
  @override
  void initState() {
    int i = 0;
    Timer timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      animator(sin((pi / 180) * i).abs());
      i++;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            height: widget.height ?? double.infinity,
            width: widget.width ?? double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.6),
                    Colors.white.withOpacity(0.2),
                  ],
                  stops: [0.0, animator.value, 1.0],
                )),
          ),
        ),
      ],
    );
  }
}

class KeepAliveWebView extends StatefulWidget {
  final String url;

  const KeepAliveWebView({Key? key, required this.url}) : super(key: key);

  @override
  State<KeepAliveWebView> createState() => _KeepAliveWebViewState();
}

class _KeepAliveWebViewState extends State<KeepAliveWebView> with AutomaticKeepAliveClientMixin {
  bool isPageFinishied = false;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          backgroundColor: Color(0xFF101214),
          initialUrl: widget.url,
          gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
          javascriptMode: JavascriptMode.unrestricted,
          zoomEnabled: false,
          onWebViewCreated: (_) {
            print('onWebViewCreated' + _.toString());
          },
          onPageStarted: (_) {
            print('onPageStarted' + _.toString());
          },
          onProgress: (_) {
            print('onProgress' + _.toString());
          },
          onPageFinished: (_) {
            print('onPageFinished' + _.toString());
            setState(() {
              isPageFinishied = true;
            });
          },
        ),
        !isPageFinishied
            ? Positioned(
                top: ScreenUtil().screenHeight / 2 - ScreenUtil().statusBarHeight - 140.w - 30.w,
                left: 0.w,
                child: YachtWebLoadingAnimation())
            // 아래는 임시 로딩 코드
            // ? Positioned(
            //     top: ScreenUtil().screenHeight / 2 -
            //         ScreenUtil().statusBarHeight -
            //         140.w -
            //         30.w -
            //         textSizeGet('잠시만 기다려주세요.', loadingTextStyle).height,
            //     left: ScreenUtil().screenWidth / 2 -
            //         textSizeGet('잠시만 기다려주세요.', loadingTextStyle).width / 2,
            //     child: Column(
            //       children: [
            //         Container(
            //           height: 60.w,
            //           width: 60.w,
            //           child: LayoutBuilder(builder: (context, constraints) {
            //             return Stack(
            //               children: [
            //                 Container(
            //                   height: 60.w,
            //                   width: 60.w,
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(20.w),
            //                   ),
            //                   clipBehavior: Clip.hardEdge,
            //                   child: Image.asset(
            //                     'assets/logos/yacht_app_logo.png',
            //                     width: 60.w,
            //                     height: 60.w,
            //                   ),
            //                 ),
            //                 TempLoadingContainer(
            //                   width: constraints.maxWidth,
            //                   height: constraints.maxHeight,
            //                   radius: 20.w,
            //                 ),
            //               ],
            //             );
            //           }),
            //         ),
            //         SizedBox(
            //           height: 4.w,
            //         ),
            //         Text('잠시만 기다려주세요.', style: loadingTextStyle)
            //       ],
            //     ),
            //   )
            : Container()
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class StockInfoNewView extends StatefulWidget {
  final StockInfoNewModel stockInfoNewModel;

  const StockInfoNewView({required this.stockInfoNewModel});

  @override
  State<StockInfoNewView> createState() => _StockInfoNewViewState();
}

class _StockInfoNewViewState extends State<StockInfoNewView> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StockInfoNewController stockInfoNewController =
        Get.put(StockInfoNewController(stockInfoNewModel: widget.stockInfoNewModel));

    // return Scaffold(
    //   backgroundColor: Color(0xFF101214),
    return Scaffold(
      backgroundColor: yachtBlack,
      appBar: AppBar(
          backgroundColor: primaryBackgroundColor,
          title: Text(
            stockInfoNewController.stockInfoNewModel.name,
            style: appBarTitle,
          )),
      // body: Column(
      //   children: [
      //     SizedBox(
      //       height: ScreenUtil().statusBarHeight,
      //     ),
      //     // 디자인 수정 필요
      //     SizedBox(
      //       height: 40.w,
      //       child: Row(children: [
      //         SizedBox(
      //           width: 8.w,
      //         ),
      //         BackButton(
      //           color: Colors.white,
      //         ),
      //         Spacer(),
      //       ]),
      //     ),
      //     Center(
      //       child: Container(
      //         decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      //         clipBehavior: Clip.hardEdge,
      //         width: 40.w,
      //         height: 40.w,
      //         child: CachedNetworkImage(
      //             imageUrl: 'https://storage.googleapis.com/ggook-5fb08.appspot.com/' +
      //                 stockInfoNewController.stockInfoNewModel.logoUrl),
      //       ),
      //     ),
      //     SizedBox(
      //       height: 10.w,
      //     ),
      //     Center(
      //       child: Text(
      //         stockInfoNewController.stockInfoNewModel.name,
      //         style: stockNameTextStyle,
      //       ),
      //     ),
      body: Column(
        children: [
          SizedBox(
            height: 20.w,
          ),
          Obx(
            () => Row(
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        stockInfoNewController.selectTab(0);
                      },
                      child: Container(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                '종목 소개',
                                style: stockInfoNewController.index.value == 0
                                    ? categorySelectTextStyle
                                    : categoryGeneralTextStyle,
                              ),
                              SizedBox(
                                height: 13.w,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 6.w,
                                  right: 6.w,
                                ),
                                child: Container(
                                  height: 4.w,
                                  // width: 75.w,
                                  color:
                                      stockInfoNewController.index.value == 0 ? Color(0xFF4A2EFF) : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                // Flexible(
                //     fit: FlexFit.tight,
                //     child: GestureDetector(
                //       behavior: HitTestBehavior.opaque,
                //       onTap: () {
                //         stockInfoNewController.selectTab(1);
                //       },
                //       child: Container(
                //         child: Center(
                //           child: Column(
                //             children: [
                //               Text(
                //                 '퀘스트',
                //                 style: stockInfoNewController.index.value == 1
                //                     ? categorySelectTextStyle
                //                     : categoryGeneralTextStyle,
                //               ),
                //               SizedBox(
                //                 height: 4.w,
                //               ),
                //               Container(
                //                 height: 2.w,
                //                 // width: 75.w,
                //                 color: stockInfoNewController.index.value == 1
                //                     ? Color(0xFF4A2EFF)
                //                     : Colors.transparent,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     )),
                // Flexible(
                //     fit: FlexFit.tight,
                //     child: GestureDetector(
                //       behavior: HitTestBehavior.opaque,
                //       onTap: () {
                //         stockInfoNewController.selectTab(2);
                //       },
                //       child: Container(
                //         child: Center(
                //           child: Column(
                //             children: [
                //               Text(
                //                 '차트',
                //                 style: stockInfoNewController.index.value == 2
                //                     ? categorySelectTextStyle
                //                     : categoryGeneralTextStyle,
                //               ),
                //               SizedBox(
                //                 height: 4.w,
                //               ),
                //               Container(
                //                 height: 2.w,
                //                 // width: 75.w,
                //                 color: stockInfoNewController.index.value == 2
                //                     ? Color(0xFF4A2EFF)
                //                     : Colors.transparent,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     )),
                // Flexible(
                //     fit: FlexFit.tight,
                //     child: GestureDetector(
                //       behavior: HitTestBehavior.opaque,
                //       onTap: () {
                //         stockInfoNewController.selectTab(3);
                //       },
                //       child: Container(
                //         child: Center(
                //           child: Column(
                //             children: [
                //               Text(
                //                 '뉴스, 의견',
                //                 style: stockInfoNewController.index.value == 3
                //                     ? categorySelectTextStyle
                //                     : categoryGeneralTextStyle,
                //               ),
                //               SizedBox(
                //                 height: 4.w,
                //               ),
                //               Container(
                //                 height: 2.w,
                //                 // width: 75.w,
                //                 color: stockInfoNewController.index.value == 3
                //                     ? Color(0xFF4A2EFF)
                //                     : Colors.transparent,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     )),
              ],
            ),
          ),
          Container(
            height: 1.w,
            color: Color(0xFF1A1C1E),
          ),
          Expanded(
            child: PageView(
              controller: stockInfoNewController.pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(child: KeepAliveWebView(url: stockInfoNewController.stockInfoNewModel.descriptionUrl)),
                // Container(
                //   height: 400.w,
                //   color: Color(0xFF101214),
                // ),
                // Container(
                //   height: 400.w,
                //   color: Color(0xFF101214),
                // ),
                // SingleChildScrollView(
                //   child: Column(
                //     children: [
                //       Container(
                //         height: 400.w,
                //         color: Color(0xFF101214),
                //       ),
                //       Container(
                //         height: 400.w,
                //         color: Colors.yellow,
                //       ),
                //       Container(
                //         height: 400.w,
                //         color: Color(0xFF101214),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// class KeepAliveWebView extends StatefulWidget {
//   final String url;

//   const KeepAliveWebView({Key? key, required this.url}) : super(key: key);

//   @override
//   State<KeepAliveWebView> createState() => _KeepAliveWebViewState(url);
// }

// class _KeepAliveWebViewState extends State<KeepAliveWebView>
//     with AutomaticKeepAliveClientMixin {
//   final String url;

//   _KeepAliveWebViewState(this.url);

//   @override
//   // ignore: must_call_super
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: url,
//       gestureRecognizers: Set()
//         ..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
//       javascriptMode: JavascriptMode.unrestricted,
//       // onWebViewCreated: (controller) async {
//       //   _webViewController = controller;
//       // },
//       zoomEnabled: false,
//     );
//   }

//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
// }

// class StockInfoNewView extends StatefulWidget {
//   final String tag;

//   const StockInfoNewView({required this.tag});

//   @override
//   State<StockInfoNewView> createState() => _StockInfoNewViewState();
// }

// class _StockInfoNewViewState extends State<StockInfoNewView> {
//   // WebViewController? _webViewController;
//   // double _webViewHeight = 1;

//   // PageController pageController = PageController(initialPage: 0);
//   // int index = 0;

//   @override
//   void initState() {
//     super.initState();
//     // Enable virtual display.
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();
//   }

//   @override
//   void dispose() {
//     // pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     StockInfoNewController stockInfoNewController =
//         Get.put(StockInfoNewController(tag: widget.tag), tag: widget.tag);

//     return Scaffold(
//       backgroundColor: Color(0xFF101214),
//       body: Column(
//         children: [
//           SizedBox(
//             height: ScreenUtil().statusBarHeight,
//           ),
//           SizedBox(
//             height: 40.w,
//           ),
//           Center(
//             child: Container(
//               decoration:
//                   BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//               width: 40.w,
//               height: 40.w,
//             ),
//           ),
//           SizedBox(
//             height: 10.w,
//           ),
//           Center(
//             child: Text(
//               stockName,
//               style: stockNameTextStyle,
//             ),
//           ),
//           SizedBox(
//             height: 20.w,
//           ),
//           Obx(
//             () => Row(
//               children: [
//                 Flexible(
//                     fit: FlexFit.tight,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {
//                         // setState(() {
//                         //   index = 0;
//                         //   pageController.jumpToPage(index);
//                         // });
//                         stockInfoNewController.selectTab(0);
//                       },
//                       child: Container(
//                         child: Center(
//                           child: Column(
//                             children: [
//                               Text(
//                                 '종목 소개',
//                                 style: stockInfoNewController.index.value == 0
//                                     ? categorySelectTextStyle
//                                     : categoryGeneralTextStyle,
//                               ),
//                               SizedBox(
//                                 height: 4.w,
//                               ),
//                               Container(
//                                 height: 2.w,
//                                 width: 75.w,
//                                 color: stockInfoNewController.index.value == 0
//                                     ? Color(0xFF4A2EFF)
//                                     : Colors.transparent,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )),
//                 Flexible(
//                     fit: FlexFit.tight,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {
//                         stockInfoNewController.selectTab(1);
//                       },
//                       child: Container(
//                         child: Center(
//                           child: Column(
//                             children: [
//                               Text(
//                                 '퀘스트',
//                                 style: stockInfoNewController.index.value == 1
//                                     ? categorySelectTextStyle
//                                     : categoryGeneralTextStyle,
//                               ),
//                               SizedBox(
//                                 height: 4.w,
//                               ),
//                               Container(
//                                 height: 2.w,
//                                 width: 75.w,
//                                 color: stockInfoNewController.index.value == 1
//                                     ? Color(0xFF4A2EFF)
//                                     : Colors.transparent,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )),
//                 Flexible(
//                     fit: FlexFit.tight,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {
//                         stockInfoNewController.selectTab(2);
//                       },
//                       child: Container(
//                         child: Center(
//                           child: Column(
//                             children: [
//                               Text(
//                                 '차트',
//                                 style: stockInfoNewController.index.value == 2
//                                     ? categorySelectTextStyle
//                                     : categoryGeneralTextStyle,
//                               ),
//                               SizedBox(
//                                 height: 4.w,
//                               ),
//                               Container(
//                                 height: 2.w,
//                                 width: 75.w,
//                                 color: stockInfoNewController.index.value == 2
//                                     ? Color(0xFF4A2EFF)
//                                     : Colors.transparent,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )),
//                 Flexible(
//                     fit: FlexFit.tight,
//                     child: GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {
//                         stockInfoNewController.selectTab(3);
//                       },
//                       child: Container(
//                         child: Center(
//                           child: Column(
//                             children: [
//                               Text(
//                                 '뉴스, 의견',
//                                 style: stockInfoNewController.index.value == 3
//                                     ? categorySelectTextStyle
//                                     : categoryGeneralTextStyle,
//                               ),
//                               SizedBox(
//                                 height: 4.w,
//                               ),
//                               Container(
//                                 height: 2.w,
//                                 width: 75.w,
//                                 color: stockInfoNewController.index.value == 3
//                                     ? Color(0xFF4A2EFF)
//                                     : Colors.transparent,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     )),
//               ],
//             ),
//           ),
//           Container(
//             height: 1.w,
//             color: Color(0xFF1A1C1E),
//           ),
//           Expanded(
//             child: PageView(
//               controller: stockInfoNewController.pageController,
//               physics: NeverScrollableScrollPhysics(),
//               children: [
//                 Container(
//                     color: Colors.teal,
//                     child: KeepAliveWebView(
//                         url:
//                             'https://brave-cinnamon-fa9.notion.site/Hyundai-Motors-the-best-automobile-8abdde04fe074615bc962b22bc5a10eb')
//                     // WebView(
//                     //   initialUrl:
//                     //       'https://brave-cinnamon-fa9.notion.site/Hyundai-Motors-the-best-automobile-8abdde04fe074615bc962b22bc5a10eb',
//                     //   gestureRecognizers: Set()
//                     //     ..add(Factory<EagerGestureRecognizer>(
//                     //         () => EagerGestureRecognizer())),
//                     //   javascriptMode: JavascriptMode.unrestricted,
//                     //   onWebViewCreated: (controller) async {
//                     //     _webViewController = controller;
//                     //   },
//                     //   zoomEnabled: false,
//                     // ),
//                     ),
//                 Container(
//                   height: 400.w,
//                   color: Colors.yellow,
//                 ),
//                 Container(
//                   height: 400.w,
//                   color: Colors.blue,
//                 ),
//                 SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Container(
//                         height: 400.w,
//                         color: Colors.blue,
//                       ),
//                       Container(
//                         height: 400.w,
//                         color: Colors.yellow,
//                       ),
//                       Container(
//                         height: 400.w,
//                         color: Colors.blue,
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//           // Expanded(
//           //     child: index == 0
//           //         ? Container(
//           //             color: Colors.teal,
//           //             child: WebView(
//           //               initialUrl:
//           //                   'https://brave-cinnamon-fa9.notion.site/Hyundai-Motors-the-best-automobile-8abdde04fe074615bc962b22bc5a10eb',
//           //               gestureRecognizers: Set()
//           //                 ..add(Factory<EagerGestureRecognizer>(
//           //                     () => EagerGestureRecognizer())),
//           //               javascriptMode: JavascriptMode.unrestricted,
//           //               onWebViewCreated: (controller) async {
//           //                 _webViewController = controller;
//           //               },
//           //               zoomEnabled: false,
//           //             ),
//           //           )
//           //         : index == 1
//           //             ? Container(
//           //                 color: Colors.green,
//           //               )
//           //             : index == 2
//           //                 ? Container(
//           //                     color: Colors.blue,
//           //                   )
//           //                 : SingleChildScrollView(
//           //                     child: Column(
//           //                       children: [
//           //                         Container(
//           //                           height: 400.w,
//           //                           color: Colors.white,
//           //                         ),
//           //                         Container(
//           //                           height: 400.w,
//           //                           color: Colors.blue,
//           //                         ),
//           //                         Container(
//           //                           height: 400.w,
//           //                           color: Colors.teal,
//           //                         ),
//           //                         Container(
//           //                           height: 400.w,
//           //                           color: Colors.yellow,
//           //                         ),
//           //                       ],
//           //                     ),
//           //                   ))
//           ////
//           // Container(
//           //   height: 12000,
//           //   child: WebView(
//           //     initialUrl:
//           //         'https://brave-cinnamon-fa9.notion.site/2048a548dfcc46119e011288c729baf1',
//           //     // 'https://blog.naver.com/bjun119/222743677596',
//           //     // gestureRecognizers: Set()
//           //     //   ..add(Factory<EagerGestureRecognizer>(
//           //     //       () => EagerGestureRecognizer())),
//           //     javascriptMode: JavascriptMode.unrestricted,
//           //     onPageFinished: (String url) => _onPageFinished(context, url),
//           //     onWebViewCreated: (controller) async {
//           //       _webViewController = controller;
//           //     },
//           //     zoomEnabled: false,
//           //   ),
//           // ),
//         ],
//       ),
//     );
//     // return Scaffold(
//     //   backgroundColor: Color(0xFF101214),
//     //   body: CustomScrollView(
//     //     slivers: [
//     //       // SliverPersistentHeader(),
//     //       SliverList(
//     //           delegate: SliverChildListDelegate([
//     //         SizedBox(
//     //           height: ScreenUtil().statusBarHeight,
//     //         ),
//     //         SizedBox(
//     //           height: 40.w,
//     //         ),
//     //         Center(
//     //           child: GestureDetector(
//     //             onTap: () {
//     //               test(
//     //                   'https://brave-cinnamon-fa9.notion.site/2048a548dfcc46119e011288c729baf1');
//     //             },
//     //             child: Container(
//     //               decoration: BoxDecoration(
//     //                   color: Colors.white, shape: BoxShape.circle),
//     //               width: 40.w,
//     //               height: 40.w,
//     //             ),
//     //           ),
//     //         ),
//     //         SizedBox(
//     //           height: 10.w,
//     //         ),
//     //         Center(
//     //           child: Text(
//     //             stockName,
//     //             style: stockNameTextStyle,
//     //           ),
//     //         ),
//     //         SizedBox(
//     //           height: 20.w,
//     //         ),
//     //         Row(
//     //           children: [
//     //             Flexible(
//     //                 fit: FlexFit.tight,
//     //                 child: Container(
//     //                   child: Center(
//     //                     child: Column(
//     //                       children: [
//     //                         Text(
//     //                           '종목 소개',
//     //                           style: categorySelectTextStyle,
//     //                         ),
//     //                         SizedBox(
//     //                           height: 4.w,
//     //                         ),
//     //                         Container(
//     //                           height: 2.w,
//     //                           width: 75.w,
//     //                           color: 1 == 1
//     //                               ? Color(0xFF4A2EFF)
//     //                               : Colors.transparent,
//     //                         ),
//     //                       ],
//     //                     ),
//     //                   ),
//     //                 )),
//     //             Flexible(
//     //                 fit: FlexFit.tight,
//     //                 child: Container(
//     //                   child: Center(
//     //                     child: Column(
//     //                       children: [
//     //                         Text(
//     //                           '종목 소개',
//     //                           style: categoryGeneralTextStyle,
//     //                         ),
//     //                         SizedBox(
//     //                           height: 4.w,
//     //                         ),
//     //                         Container(
//     //                           height: 2.w,
//     //                           width: 75.w,
//     //                           color: 1 == 0
//     //                               ? Color(0xFF4A2EFF)
//     //                               : Colors.transparent,
//     //                         ),
//     //                       ],
//     //                     ),
//     //                   ),
//     //                 )),
//     //             Flexible(
//     //                 fit: FlexFit.tight,
//     //                 child: Container(
//     //                   child: Center(
//     //                     child: Column(
//     //                       children: [
//     //                         Text(
//     //                           '종목 소개',
//     //                           style: categoryGeneralTextStyle,
//     //                         ),
//     //                         SizedBox(
//     //                           height: 4.w,
//     //                         ),
//     //                         Container(
//     //                           height: 2.w,
//     //                           width: 75.w,
//     //                           color: 1 == 0
//     //                               ? Color(0xFF4A2EFF)
//     //                               : Colors.transparent,
//     //                         ),
//     //                       ],
//     //                     ),
//     //                   ),
//     //                 )),
//     //             Flexible(
//     //                 fit: FlexFit.tight,
//     //                 child: Container(
//     //                   child: Center(
//     //                     child: Column(
//     //                       children: [
//     //                         Text(
//     //                           '종목 소개',
//     //                           style: categoryGeneralTextStyle,
//     //                         ),
//     //                         SizedBox(
//     //                           height: 4.w,
//     //                         ),
//     //                         Container(
//     //                           height: 2.w,
//     //                           width: 75.w,
//     //                           color: 1 == 0
//     //                               ? Color(0xFF4A2EFF)
//     //                               : Colors.transparent,
//     //                         ),
//     //                       ],
//     //                     ),
//     //                   ),
//     //                 )),
//     //           ],
//     //         ),
//     //         Container(
//     //           height: 1.w,
//     //           color: Color(0xFF1A1C1E),
//     //         ),
//     //         Container(
//     //           height: 12000,
//     //           child: WebView(
//     //             initialUrl:
//     //                 'https://brave-cinnamon-fa9.notion.site/2048a548dfcc46119e011288c729baf1',
//     //             // 'https://blog.naver.com/bjun119/222743677596',
//     //             // gestureRecognizers: Set()
//     //             //   ..add(Factory<EagerGestureRecognizer>(
//     //             //       () => EagerGestureRecognizer())),
//     //             javascriptMode: JavascriptMode.unrestricted,
//     //             onPageFinished: (String url) => _onPageFinished(context, url),
//     //             onWebViewCreated: (controller) async {
//     //               _webViewController = controller;
//     //             },
//     //             zoomEnabled: false,
//     //           ),
//     //         ),
//     //       ])),
//     //     ],
//     //   ),
//     // );
//   }
// }

/*class StockInfoNewView extends StatefulWidget {
  @override
  State<StockInfoNewView> createState() => _StockInfoNewViewState();
}

class _StockInfoNewViewState extends State<StockInfoNewView> {
  // GlobalKey webViewKey = GlobalKey();

  // InAppWebViewController? webViewController;

  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //   crossPlatform: InAppWebViewOptions(
  //     useShouldOverrideUrlLoading: true,
  //     mediaPlaybackRequiresUserGesture: false,
  //   ),
  //   android: AndroidInAppWebViewOptions(
  //     useHybridComposition: true,
  //   ),
  //   ios: IOSInAppWebViewOptions(
  //     allowsInlineMediaPlayback: true,
  //   ),
  // );
  WebViewController? _webViewController;
  double _webViewHeight = 1;

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  Future<void> _onPageFinished(BuildContext context, String url) async {
    double newHeight = double.parse(
      await _webViewController!.runJavascriptReturningResult(
          "document.documentElement.scrollHeight;"),
      // .evaluateJavascript("document.documentElement.scrollHeight;"),
    );

    setState(() {
      print(newHeight);
      _webViewHeight = newHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF101214),
          systemOverlayStyle: SystemUiOverlayStyle(
            // Status bar color
            statusBarColor: Color(0xFF101214),
            // Status bar brightness (optional)
            statusBarIconBrightness:
                Brightness.light, // For Android (light icons)
            statusBarBrightness: Brightness.dark, // For iOS (light icons)
          ),
        ),
        body:
            // CustomScrollView(slivers: [
            //   SliverList(
            //     delegate: SliverChildListDelegate([
            //       Container(height: 100, color: Colors.green),
            //       Container(
            //         height: _webViewHeight,
            //         child: WebView(
            //           initialUrl: 'https://blog.naver.com/bjun119/222743677596',
            //           // 'https://brave-cinnamon-fa9.notion.site/2048a548dfcc46119e011288c729baf1',
            //           // gestureRecognizers: Set()
            //           //   ..add(Factory<EagerGestureRecognizer>(
            //           //       () => EagerGestureRecognizer())),
            //           javascriptMode: JavascriptMode.unrestricted,
            //           onPageFinished: (String url) => _onPageFinished(context, url),
            //           onWebViewCreated: (controller) async {
            //             _webViewController = controller;
            //           },
            //           // onPageStarted: (_) {
            //           //   print(_ + ' _onPageStarted');
            //           // },
            //           // onPageFinished: (_) {
            //           //   print(_ + ' _onPageFinished');
            //           // },
            //           // onProgress: (_) {
            //           //   print(_.toString() + ' _onProgress');
            //           // },
            //         ),
            //       ),
            //       Container(height: 100, color: Colors.yellow),
            //     ]),
            //   ),
            // ])
            SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    _onPageFinished(context,
                        'https://brave-cinnamon-fa9.notion.site/2048a548dfcc46119e011288c729baf1');
                  },
                  child: Container(height: 100, color: Colors.green)),
              Container(
                height: 4000,
                child: WebView(
                  initialUrl:
                      'https://brave-cinnamon-fa9.notion.site/2048a548dfcc46119e011288c729baf1',
                  // 'https://blog.naver.com/bjun119/222743677596',
                  // gestureRecognizers: Set()
                  //   ..add(Factory<EagerGestureRecognizer>(
                  //       () => EagerGestureRecognizer())),
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (String url) => _onPageFinished(context, url),
                  onWebViewCreated: (controller) async {
                    _webViewController = controller;
                  },
                  // onPageStarted: (_) {
                  //   print(_ + ' _onPageStarted');
                  // },
                  // onPageFinished: (_) {
                  //   print(_ + ' _onPageFinished');
                  // },
                  // onProgress: (_) {
                  //   print(_.toString() + ' _onProgress');
                  // },
                ),
              ),
              Container(height: 100, color: Colors.yellow),
            ],
          ),
        ));
  }
}
*/