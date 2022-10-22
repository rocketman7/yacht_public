import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yachtOne/screens/stock_info/yacht_pick_view.dart';
import 'package:yachtOne/yacht_design_system/yds_color.dart';

class TempWebView extends StatelessWidget {
  const TempWebView({Key? key, required this.url}) : super(key: key);

  final String url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yachtBlack,
      body: KeepAliveWebView(url: url),
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
