import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/screens/community/detail_post_view.dart';
import 'package:yachtOne/screens/profile/my_feed_view_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';
import '../community/new_feed_detail_widget.dart';

class MyFeedView extends GetView<MyFeedViewModel> {
  final String uid;
  const MyFeedView(this.uid, {Key? key}) : super(key: key);

  // TODO: implement controller
  @override
  Widget build(BuildContext context) {
    MyFeedViewModel myFeedViewModel = Get.put(MyFeedViewModel(uid), tag: uid);
    return Column(
      children: [
        SizedBox(height: 14.w),
        Obx(
          () => myFeedViewModel.userPosts.length > 0
              ? Container(
                  child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: min(myFeedViewModel.userPosts.length, 50),
                  itemBuilder: (_, index) {
                    return FutureBuilder<PostModel>(
                        future: myFeedViewModel.getPost(myFeedViewModel.userPosts[index].postId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            return Padding(
                              padding: defaultHorizontalPadding,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.to(() => NewFeedDetailWidget(post: snapshot.data!));
                                    },
                                    child: sectionBox(
                                        width: double.infinity,
                                        padding: defaultPaddingAll,
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
                                  SizedBox(height: 12.w),
                                ],
                              ),
                            );
                          }
                        });
                  },
                ))
              : Container(
                  height: 170.w,
                  width: double.infinity,
                  child: Image.asset('assets/illusts/not_exists/no_feed.png'),
                ),
        ),
      ],
    );
  }
}
