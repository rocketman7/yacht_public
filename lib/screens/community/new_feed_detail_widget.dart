import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/screens/community/community_view.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/screens/community/new_feed_widget_controller.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../models/community/post_model.dart';
import '../../repositories/repository.dart';
import 'new_feed_widget.dart';

class NewFeedDetailWidget extends GetView {
  NewFeedDetailWidget({
    Key? key,
    required this.post,
  }) : super(key: key);
  final PostModel post;

  final CommunityViewModel communityViewModel = Get.find<CommunityViewModel>();
  get controller => Get.find<NewFeedWidgetController>(tag: post.postId);
  double bottomBarHeight = ScreenUtil().bottomBarHeight;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: yachtLightGrey,
      appBar: primaryAppBar(""),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: primaryAllPadding,
                  child: FeedHeader(
                    post: controller.postRx.value,
                    communityViewModel: communityViewModel,
                  ),
                ),
                SizedBox(height: 4.w),
                (post.imageUrlList == null || post.imageUrlList!.length == 0)
                    ? SizedBox.shrink()
                    : ImagePageView(
                        post: controller.postRx.value,
                      ),
                SizedBox(height: 4.w),
                Padding(
                  padding: primaryHorizontalPadding,
                  child: FeedDetailContentWidget(post: post),
                ),
                SizedBox(height: 4.w),
                Divider(),
                SizedBox(height: 4.w),
                Padding(
                  padding: primaryHorizontalPadding,
                  child: LikeButtonWidget(communityViewModel: communityViewModel, post: post, controller: controller),
                ),
                SizedBox(height: 4.w),
                Padding(
                  padding: primaryHorizontalPadding,
                  child: CommentList(
                    communityViewModel: communityViewModel,
                    post: controller.postRx.value,
                    maxCommentLength: 100,
                    controller: controller,
                    isDetailComment: true,
                  ),
                ),
                // SizedBox(height: 14.w),
              ],
            ),
          ),
          SizedBox(height: 12.w),
          Padding(
            padding: primaryHorizontalPadding,
            child: Row(
              children: [
                Container(
                    width: 36.w,
                    height: 36.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${userModelRx.value!.avatarImage}.png",
                    )),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: NewCommentInputWidget(
                    post: controller.postRx.value,
                    communityViewModel: communityViewModel,
                    widgetController: controller,
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            print('controller' + controller.isFocused.value.toString());
            return controller.isFocused.value
                ? SizedBox(height: 8.w)
                : SizedBox(
                    height: bottomBarHeight + 14.w,
                  );
          })
        ],
      ),
    );
  }
}

class FeedDetailContentWidget extends StatelessWidget {
  FeedDetailContentWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;
  // final RxInt maxLinesForContent = 3.obs;
  bool hasTextOverflow(String text, TextStyle style,
      {double minWidth = 0, double maxWidth = double.infinity, int maxLines = 2}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: minWidth, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return Linkify(
      onOpen: (link) async {
        if (await canLaunch(link.url)) {
          await launch(link.url);
        } else {
          throw 'Could not launch $link';
        }
      },
      text: post.content,
      style: feedContent.copyWith(fontSize: 16.w),
      linkStyle: feedContent.copyWith(color: yachtBlue),
      maxLines: 1000,
      overflow: TextOverflow.ellipsis,
      // overflow: TextOverflow.,
    );
  }
}
