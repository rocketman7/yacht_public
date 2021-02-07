import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view_models/notification_list_view_model.dart';
import 'notification_web_view.dart';

class NotificationListView extends StatelessWidget {
  final Function callbackFunc;

  NotificationListView({this.callbackFunc});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationListViewModel>.reactive(
        viewModelBuilder: () =>
            NotificationListViewModel(callbackFunc: callbackFunc),
        builder: (context, model, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  '알림 모아보기',
                  style: TextStyle(
                    fontFamily: 'AppleSDEB',
                    fontSize: 20.sp,
                    letterSpacing: -2.0,
                  ),
                ),
                elevation: 1,
              ),
              backgroundColor: Colors.white,
              body: model.hasError
                  ? Container(
                      child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                    )
                  : model.isBusy
                      ? Container()
                      : SafeArea(
                          child: ListView(
                            children: notificationList(context, model),
                          ),
                        ));
        });
  }
}

List<Widget> notificationList(
    BuildContext context, NotificationListViewModel model) {
  List<Widget> result = [];

  for (int i = 0; i < model.notificationListModel.length; i++) {
    result.add(GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (model.notificationListModel[i].url != null) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => NotificationWebView(
                      model.notificationListModel[i].title,
                      model.notificationListModel[i].url)));
        } else {
          if (model.notificationListModel[i].moreContent != null) {
            model.selectNotification(i);
          } else {}
        }
      },
      child: Padding(
        padding: EdgeInsets.only(top: 12, bottom: 12, left: 16, right: 16),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.notificationListModel[i].title}',
                        maxLines: 100,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'AppleSDB',
                          fontSize: 16.sp,
                          letterSpacing: -0.28,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        model.isSelected[i]
                            ? '${model.notificationListModel[i].moreContent.replaceAll("\\n", "\n")}'
                            : '${model.notificationListModel[i].content}',
                        maxLines: 100,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontSize: 14.sp,
                            letterSpacing: -0.28,
                            fontFamily: 'AppleSDM',
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Text(
                            '${model.notificationTimeStr[i]}',
                            style: TextStyle(
                                fontSize: 12.sp,
                                letterSpacing: -0.28,
                                fontFamily: 'AppleSDM',
                                color: Color(0xFF787878)),
                          ),
                          Spacer(),
                          model.notificationListModel[i].url != null
                              ? Text(
                                  '더 보러 가기',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 12.sp,
                                      letterSpacing: -0.28,
                                      fontFamily: 'AppleSDM',
                                      color: Color(0xFF1EC8CF)),
                                )
                              : model.notificationListModel[i].moreContent !=
                                      null
                                  ? Text(
                                      model.isSelected[i] ? '접기' : '자세한 내용 보기',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 12.sp,
                                          letterSpacing: -0.28,
                                          fontFamily: 'AppleSDM',
                                          color: Color(0xFF1EC8CF)),
                                    )
                                  : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 16.w,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
    result.add(Container(
      height: 1,
      color: Color(0xFFF2F2F2),
    ));
  }

  return result;
}
