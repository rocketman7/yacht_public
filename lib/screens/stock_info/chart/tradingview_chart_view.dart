import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/stock_info/chart/tradingview_chart_view_model.dart';
import 'package:yachtOne/screens/stock_info/yacht_pick_view.dart';

class TradingViewChartView extends StatelessWidget {
  TradingViewChartView({Key? key, required this.investAddressModel}) : super(key: key);

  final InvestAddressModel investAddressModel;
  final TradingViewChartViewModel tradingviewChartViewModel = Get.put(TradingViewChartViewModel());
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400.w,
        child: FutureBuilder<String>(
            future: tradingviewChartViewModel.getTradingViewUrl(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? KeepAliveWebViewForTVChart(
                      // url: "https://63130e679c4ac346f072c737--cosmic-swan-b4e1b1.netlify.app/?${investAddressModel.issueCode}",
                      // url: "https://63130e679c4ac346f072c737--cosmic-swan-b4e1b1.netlify.app/?FTCH",
                      url: '${snapshot.data}?${investAddressModel.issueCode}',
                    )
                  : SizedBox.shrink();
            }));
  }
}

class KeepAliveWebViewForTVChart extends StatefulWidget {
  final String url;
  const KeepAliveWebViewForTVChart({Key? key, required this.url}) : super(key: key);
  @override
  State<KeepAliveWebViewForTVChart> createState() => _KeepAliveWebViewState();
}

class _KeepAliveWebViewState extends State<KeepAliveWebViewForTVChart> with AutomaticKeepAliveClientMixin {
  bool isPageFinishied = false;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          backgroundColor: Color(0xFF101214),
          initialUrl: widget.url,
          // gestureRecognizers: Set()
          //   ..add(Factory<EagerGestureRecognizer>(
          //       () => EagerGestureRecognizer())),
          javascriptMode: JavascriptMode.unrestricted,
          zoomEnabled: false,
          onWebViewCreated: (_) {
            // print(‘onWebViewCreated’ + _.toString());
          },
          onPageStarted: (_) {
            // print(‘onPageStarted’ + _.toString());
          },
          onProgress: (_) {
            // print(‘onProgress’ + _.toString());
          },
          onPageFinished: (_) {
            // print(‘onPageFinished’ + _.toString());
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
            : Container()
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}


// class TestViewView extends StatelessWidget {
//   const TestViewView({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(children: [
//         Container(
//           height: 400.w,
//           color: Colors.white,
//         ),
//         Container(
//           height: 400.w,
//           color: Colors.black,
//         ),
//         TradingviewChartView(),
//         Container(
//           height: 400.w,
//           color: Colors.red,
//         ),
//         Container(
//           height: 400.w,
//           color: Colors.black,
//         ),
//       ]),
//     );
//   }
// }
