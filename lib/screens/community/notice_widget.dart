import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import 'community_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'detail_post_view.dart';
import 'new_feed_detail_widget.dart';
import 'new_feed_widget_controller.dart';

class NoticeWidget extends GetView {
  final CommunityViewModel communityViewModel;
  final PostModel post;
  NoticeWidget({Key? key, required this.communityViewModel, required this.post}) : super(key: key);

  final RxBool isTapping = false.obs;
  @override
  // TODO: implement controller
  get controller => Get.put(NewFeedWidgetController(post), tag: post.postId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (_) {
        print('tapup');
        isTapping(false);
        Get.to(() => NewFeedDetailWidget(post: post));
      },
      child: sectionBox(
          child: Container(
        padding: primaryAllPadding,
        width: double.infinity,
        // color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "[공지사항]",
              style: feedWriterName.copyWith(color: yachtRed),
            ),
            SizedBox(
              height: correctHeight(10.w, feedWriterName.fontSize, feedWriterName.fontSize),
            ),
            Text(
              post.title ?? "",
              style: feedWriterName,
            ),
            InkWell(
              onTap: () => Get.to(
                () => DetailPostView(post),
              ),
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: post.content,
                style: feedContent,
                linkStyle: feedContent.copyWith(color: yachtViolet),
                maxLines: (post.imageUrlList == null || post.imageUrlList!.length == 0) ? 3 : 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      )),
    );
  }
}
