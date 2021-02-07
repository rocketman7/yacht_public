import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NotificationWebView extends StatefulWidget {
  final String title;
  final String url;

  NotificationWebView(this.title, this.url);
  @override
  _NotificationWebViewState createState() => _NotificationWebViewState();
}

class _NotificationWebViewState extends State<NotificationWebView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AutoSizeText(
            '${widget.title}',
            maxLines: 1,
            style: TextStyle(
              fontFamily: 'AppleSDEB',
              fontSize: 20.sp,
              letterSpacing: -2.0,
            ),
          ),
          elevation: 1,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: WebView(
            initialUrl: '${widget.url}',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ));
  }
}
