import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/handlers/object_handler.dart';
import 'package:yachtOne/screens/community/community_view.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/screens/community/new_feed_widget_controller.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_font.dart';
import 'package:any_link_preview/any_link_preview.dart';
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
  get controller => Get.put(NewFeedWidgetController(post), tag: post.postId);

  // get controller =>
  double bottomBarHeight = ScreenUtil().bottomBarHeight;

  List<String> linkableStringInContent = [];
  int elementIndex = 0;
  @override
  Widget build(BuildContext context) {
    while (elementIndex < linkify(post.content).length) {
      if (linkify(post.content)[elementIndex] is LinkableElement) {
        linkableStringInContent.add(linkify(post.content)[elementIndex].text);
      }
      elementIndex++;
    }
    return Scaffold(
      // backgroundColor: yachtLightBlack,
      appBar: primaryAppBar(""),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: primaryAllPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${post.writerAvatarUrl}.png",
                          )),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FeedHeader(
                              post: controller.postRx.value,
                              communityViewModel: communityViewModel,
                            ),
                            SizedBox(height: 6.w),
                            FeedDetailContentWidget(post: post),
                            SizedBox(height: 4.w),
                            // RichText(
                            //     text: TextSpan(
                            //         children: linkify(post.content).map<InlineSpan>(
                            //   (e) {
                            //     if (e is LinkableElement) {
                            //       linkableStringInContent.add(e.text);
                            //       print('linkableStringInContent:$linkableStringInContent');
                            //       return TextSpan(text: e.text);
                            //     } else {
                            //       return TextSpan(text: "");
                            //     }
                            //   },
                            // ).toList())),
                            linkableStringInContent.length > 0
                                ? AnyLinkPreview(
                                    link: 'https://${linkableStringInContent[0]}',
                                    // bodyMaxLines: 1,
                                    backgroundColor: yachtGrey,
                                    titleStyle: TextStyle(
                                      color: white,
                                      fontSize: 15.w,
                                    ),
                                    bodyStyle: TextStyle(
                                      color: yachtLightGrey,
                                    ),
                                  )
                                : SizedBox.shrink(),
                            // AnyLinkPreview(link: 'https://' + 'naver.me/FuWftEBY'),
                            SizedBox(height: 8.w),
                            (post.imageUrlList == null || post.imageUrlList!.length == 0)
                                ? SizedBox.shrink()
                                : ImagePageView(
                                    post: controller.postRx.value,
                                  ),
                            SizedBox(height: 8.w),
                            LikeButtonWidget(
                                communityViewModel: communityViewModel, post: post, controller: controller),
                            SizedBox(height: 4.w),
                            CommentList(
                              communityViewModel: communityViewModel,
                              post: controller.postRx.value,
                              maxCommentLength: 100,
                              controller: controller,
                              isDetailComment: true,
                            ),
                          ],
                        ),
                      ),
                    ],
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
      style: bodyP2LightStyle.copyWith(fontSize: 16.w),
      linkStyle: bodyP2LightStyle.copyWith(color: const Color(0xFF00EAFF)),
      maxLines: 1000,
      overflow: TextOverflow.ellipsis,
      // overflow: TextOverflow.,
    );
  }
}
