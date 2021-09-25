import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/screens/community/detail_post_view.dart';
import 'package:yachtOne/screens/profile/my_feed_view_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class MyFeedView extends GetView<MyFeedViewModel> {
  const MyFeedView({Key? key}) : super(key: key);
  @override
  // TODO: implement controller
  MyFeedViewModel get controller => Get.put(MyFeedViewModel());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.w),
        Padding(
          padding: primaryHorizontalPadding,
          child: Row(
            children: [
              Text(
                '피드 내역',
                style: profileHeaderTextStyle,
              ),
              Spacer(),
              Image.asset(
                'assets/icons/navigate_foward_arrow.png',
                height: 16.w,
                width: 9.w,
              ),
            ],
          ),
        ),
        SizedBox(height: 8.w),
        Obx(
          () => Container(
              // height: 140.w,

              child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: min(controller.userPosts.length, 3),
            itemBuilder: (_, index) {
              return FutureBuilder<PostModel>(
                  future: controller.getPost(controller.userPosts[index].postId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      return Padding(
                        padding: primaryHorizontalPadding,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => DetailPostView(snapshot.data!));
                              },
                              child: sectionBox(
                                  width: double.infinity,
                                  padding: primaryAllPadding,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        timeStampToStringWithHourMinute(snapshot.data!.writtenDateTime),
                                        style: questRecordendDateTime,
                                      ),
                                      snapshot.data!.title != null
                                          ? Text(
                                              snapshot.data!.title!,
                                              style: feedTitle,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : Container(),
                                      Text(
                                        snapshot.data!.content,
                                        style: feedContent,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(height: 8.w),
                          ],
                        ),
                      );
                    }
                  });
            },
          )),
        ),
      ],
    );
  }
}
