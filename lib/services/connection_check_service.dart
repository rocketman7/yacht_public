import 'dart:async';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectionCheckService {
  StreamSubscription<DataConnectionStatus> listener;
  var internetStatus = "Unknown";
  var contentmessage = "Unknown";

  void _showDialog(String title, String content, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text(title),
                  content: Text(content),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text("닫기"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )
              : AlertDialog(
                  title: Text(title),
                  content: Text(content),
                  actions: <Widget>[
                      FlatButton(
                        child: Text("닫기"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]);
        });
  }

  checkConnection(BuildContext context) async {
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          // internetStatus = "Connected to the Internet";
          // contentmessage = "Connected to the Internet";
          // _showDialog(internetStatus, contentmessage, context);
          break;
        case DataConnectionStatus.disconnected:
          internetStatus = "인터넷 연결이 끊겼습니다.";
          contentmessage = "인터넷 연결 상태를 확인해주세요.\n문제가 지속될 시 앱을 재실행해주세요.";
          _showDialog(internetStatus, contentmessage, context);
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }
}
