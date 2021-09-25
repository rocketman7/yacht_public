import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:yachtOne/styles/yacht_design_system.dart';

import 'notification_view_model.dart';

class NotificationView extends StatelessWidget {
  final NotificationViewModel notificationViewModel =
      Get.put(NotificationViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: white,
        toolbarHeight: 60.w,
        title: Text('알림', style: appBarTitle),
      ),
      body: GetBuilder<NotificationViewModel>(
        id: 'notificationList',
        builder: (controller) {
          return controller.isNotificationListLoaded
              ? ListView.builder(
                  itemCount: controller.notificationList.length,
                  itemBuilder: (_, i) {
                    return InkWell(
                      onTap: () {
                        if (controller.notificationList[i].url != '') {
                          //url이 있으면 두가지로 나뉜다.
                          //1. 인터넷주소이면 웹뷰로 ㄱ
                          //2. 인터넷주소가 아니면 페이지 이동 ㄱ
                          //아직 구현 안함
                        } else {
                          //url이 없고 moreContent가 있다면 세부 페이지로 이동.
                          if (controller.notificationList[i].moreContent !=
                              '') {
                            Get.to(() => NotificationDetailView(
                                  category:
                                      controller.notificationList[i].category!,
                                  content:
                                      controller.notificationList[i].content,
                                  moreContent: controller
                                      .notificationList[i].moreContent!,
                                ));
                          } else {}
                          //url도 없고 moreContent도 없다면 아무 반응 x
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 14.w, right: 14.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: controller.notificationList[i].category !=
                                      ''
                                  ? correctHeight(
                                      20.w, 0.w, notificationCategory.fontSize)
                                  : 6.w,
                            ),
                            Text(
                              '${controller.notificationList[i].category}',
                              style: notificationCategory,
                            ),
                            SizedBox(
                              height: correctHeight(
                                  10.w,
                                  controller.notificationList[i].category != ''
                                      ? notificationCategory.fontSize
                                      : 0.w,
                                  notificationContent.fontSize),
                            ),
                            Text(
                              '${controller.notificationList[i].content}',
                              style: notificationContent,
                            ),
                            SizedBox(
                              height: correctHeight(
                                  16.w, notificationContent.fontSize, 0.w),
                            ),
                            Container(
                                height: 1.w,
                                width: 375.w - 28.w,
                                color: yachtLine)
                          ],
                        ),
                      ),
                    );
                  })
              : Container(
                  color: Colors.black,
                );
        },
      ),
    );
  }
}

class NotificationDetailView extends StatelessWidget {
  final String category;
  final String content;
  final String moreContent;

  NotificationDetailView(
      {required this.category,
      required this.content,
      required this.moreContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: white,
        toolbarHeight: 60.w,
        title: Text(category, style: appBarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 14.w, right: 14.w),
        child: ListView(
          children: [
            SizedBox(
              height: correctHeight(20.w, 0.w, notificationCategory.fontSize),
            ),
            category != ''
                ? Text(
                    category,
                    style: notificationCategory,
                  )
                : Container(),
            category != ''
                ? SizedBox(
                    height: correctHeight(10.w, notificationCategory.fontSize,
                        notificationContentForDetail.fontSize),
                  )
                : Container(),
            Text(
              content,
              style: notificationContentForDetail,
            ),
            SizedBox(
              height: correctHeight(10.w, notificationContentForDetail.fontSize,
                  notificationContent.fontSize),
            ),
            Text(
              moreContent,
              style: notificationContent,
            ),
          ],
        ),
      ),
    );
  }
}
