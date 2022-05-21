import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/community/community_view.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/screens/community/community_widgets.dart';
import 'package:yachtOne/screens/community/new_feed_detail_widget.dart';
import 'package:yachtOne/screens/community/new_feed_widget_controller.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:yachtOne/widgets/like_button.dart';
import '../../handlers/user_tier_handler.dart';
import '../../locator.dart';
import '../../models/community/comment_model.dart';
import 'detail_post_view.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:extended_image/extended_image.dart';

class NewFeedWidget extends GetView {
  final CommunityViewModel communityViewModel;
  final PostModel post;

  NewFeedWidget({Key? key, required this.communityViewModel, required this.post}) : super(key: key);

  @override
  // TODO: implement controller
  get controller => Get.put(NewFeedWidgetController(post), tag: post.postId);

  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  RxBool isTapping = false.obs;
  @override
  Widget build(BuildContext context) {
    // FocusScopeNode currentFocus = FocusScope.of(context);
    List<String> imageUrls = List.generate(controller.post.imageUrlList!.length, (index) => "");

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        // print("feed widget touch");
        // print("hasFocus: ${currentFocus.hasFocus}");
        // WidgetsBinding.instance!.focusManager.primaryFocus?.unfocus();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 피드 헤더. 아바타, 닉네임, 레벨, 추가메뉴 등
          Padding(
            padding: primaryHorizontalPadding,
            child: FeedHeader(post: post, communityViewModel: communityViewModel),
          ),
          // 이미지가 있을 때 이미지 뷰
          SizedBox(height: 4.w),
          (post.imageUrlList == null || post.imageUrlList!.length == 0)
              ? Container()
              : ImagePageView(
                  post: post,
                ),
          SizedBox(height: 4.w),
          // 피드 콘텐츠
          Padding(
            padding: primaryHorizontalPadding,
            child: FeedContentWidget(post: post),
          ),
          SizedBox(height: 4.w),
          // 피드에 각종 버튼 Row
          Padding(
            padding: primaryHorizontalPadding,
            child: LikeButtonWidget(
              post: post,
              communityViewModel: communityViewModel,
              controller: controller,
            ),
          ),
          SizedBox(height: 4.w),
          // 댓글 리스트
          Padding(
            padding: primaryHorizontalPadding,
            child: InkWell(
              onTap: () {
                _mixpanelService.mixpanel.track('Feed Detail', properties: {
                  'Post ID': post.postId,
                  'Post Write DateTime': post.writtenDateTime.toDate().toIso8601String(),
                  'Post Edit DateTime': post.editedDateTime == null
                      ? post.writtenDateTime.toDate().toIso8601String()
                      : post.editedDateTime.toDate().toIso8601String(),
                  'Post Title': post.title ?? "",
                  'Is Pro Post': post.isPro,
                  'Is Notice': post.isNotice,
                  'Post Writer Uid': post.writerUid,
                  'Post Writer User Name': post.writerUserName,
                  'Post Writer Exp': post.writerExp,
                  'Post Has Image': post.imageUrlList == null
                      ? false
                      : post.imageUrlList!.length > 0
                          ? true
                          : false,
                });
                HapticFeedback.lightImpact();
                Get.to(() => NewFeedDetailWidget(
                      post: controller.postRx.value!,
                    ));
              },
              child: CommentList(
                communityViewModel: communityViewModel,
                post: post,
                maxCommentLength: 2,
                controller: controller,
              ),
            ),
          ),
          // SizedBox(height: 6.w),
          // 댓글 남기는 Input 위젯. 일단 보류
          // Padding(
          //   padding: primaryHorizontalPadding,
          //   child: CommentInputWidget(
          //     post: post,
          //     communityViewModel: communityViewModel,
          //     widgetController: controller,
          //   ),
          // )
        ],
      ),
    );
  }

  // Future<String> getImageUrlFromStorage(String imageUrl) async {
  //   return await _firebaseStorageService.downloadImageURL(imageUrl);
  // }
}

class LikeButtonWidget extends StatelessWidget {
  LikeButtonWidget({
    Key? key,
    required this.post,
    required this.communityViewModel,
    required this.controller,
  }) : super(key: key);

  final PostModel post;
  final CommunityViewModel communityViewModel;
  final NewFeedWidgetController controller;
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                _mixpanelService.mixpanel.track('Feed Detail', properties: {
                  'Post ID': post.postId,
                  'Post Write DateTime': post.writtenDateTime.toDate().toIso8601String(),
                  'Post Edit DateTime': post.editedDateTime == null
                      ? post.writtenDateTime.toDate().toIso8601String()
                      : post.editedDateTime.toDate().toIso8601String(),
                  'Post Title': post.title ?? "",
                  'Is Pro Post': post.isPro,
                  'Is Notice': post.isNotice,
                  'Post Writer Uid': post.writerUid,
                  'Post Writer User Name': post.writerUserName,
                  'Post Writer Exp': post.writerExp,
                  'Post Has Image': post.imageUrlList == null
                      ? false
                      : post.imageUrlList!.length > 0
                          ? true
                          : false,
                });
                HapticFeedback.lightImpact();
                // HapticFeedback.selectionClick();
                Get.to(() => NewFeedDetailWidget(
                      post: controller.postRx.value!,
                    ));
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/comment.svg',
                    color: yachtBlack,
                    width: 18.w,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                // _mixpanelService.mixpanel
                //     .track('Post Like', properties: {'Like Post ID': post.postId, 'Like Post From Page': "Community"});
                HapticFeedback.lightImpact();
                await controller.toggleLikePost(controller.postRx.value!);
                await controller.reloadThisPost(post);
              },
              child: Row(
                children: [
                  Obx(
                    () => LikeButton(
                      size: 22.w,
                      isLiked: controller.postRx.value!.likedBy == null
                          ? false
                          : controller.postRx.value!.likedBy!.contains(userModelRx.value!.uid),
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 4.w),
        Obx(
          () => Text(
            "좋아요 ${controller.postRx.value!.likedBy == null ? 0 : controller.postRx.value!.likedBy!.length}개",
            style: feedContent,
          ),
        ),
      ],
    );
  }
}

class CommentList extends StatelessWidget {
  CommentList({
    Key? key,
    required this.communityViewModel,
    required this.post,
    required this.maxCommentLength,
    required this.controller,
    this.isDetailComment = false,
  }) : super(key: key);

  final CommunityViewModel communityViewModel;
  final PostModel post;
  final int maxCommentLength;
  final NewFeedWidgetController controller;
  final bool isDetailComment;
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CommentModel>>(
        stream: communityViewModel.getCommentStream(post),
        initialData: [],
        builder: (context, snapshot) {
          if (snapshot.data!.length == 0) {
            return Container();
          } else {
            List<CommentModel> comments = snapshot.data!;
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ...List.generate(
                min(comments.length, maxCommentLength),
                (index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              maxLines: isDetailComment ? 1000 : 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: '${comments[index].writerUserName}   ',
                                  style: feedWriterName.copyWith(fontWeight: FontWeight.w600, height: 1.4),
                                  children: [
                                    TextSpan(
                                      text: '${comments[index].content}',
                                      style: feedContent,
                                    )
                                  ]),
                            ),
                            SizedBox(
                              height: 3.w,
                            ),
                            isDetailComment
                                ? Row(
                                    children: [
                                      Text(
                                        feedTimeHandler(comments[index].writtenDateTime.toDate()),
                                        style: feedDateTime,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      (comments[index].likedBy != null && comments[index].likedBy!.length > 0)
                                          ? Text(
                                              "좋아요 ${comments[index].likedBy!.length}개",
                                              style: feedDateTime,
                                            )
                                          : SizedBox.shrink()
                                    ],
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.w),
                        child: SizedBox(
                          // color: Colors.black12,
                          // height: 30.w,
                          width: 26.w,
                          child:
                              (comments[index].writerUid == (userModelRx.value == null ? "" : userModelRx.value!.uid))
                                  ? GestureDetector(
                                      onTap: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                insetPadding: EdgeInsets.fromLTRB(32.w, 20.w, 32.w, 20.w),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10.w),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(14.w, 0.w, 14.w, 14.w),
                                                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                                                    // TITLE
                                                    SizedBox(
                                                      height: 50.w,
                                                      child: Center(
                                                          child: Text(
                                                        "알림",
                                                        style: dialogTitle,
                                                      )),
                                                    ),
                                                    // CONTENT
                                                    Text(
                                                      "댓글을 삭제하시겠습니까?",
                                                      style: dialogContent,
                                                    ),
                                                    SizedBox(
                                                      height: 12.w,
                                                    ),
                                                    // BUTTONS
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: GestureDetector(
                                                          onTap: () async {
                                                            await communityViewModel.deleteComment(comments[index]);
                                                          },
                                                          child: Container(
                                                              height: 50.w,
                                                              decoration: BoxDecoration(
                                                                  color: yachtViolet,
                                                                  borderRadius: BorderRadius.circular(8.w)),
                                                              child: Center(
                                                                child: Text(
                                                                  "삭제",
                                                                  style: dialogChoice.copyWith(
                                                                    color: white,
                                                                  ),
                                                                ),
                                                              )),
                                                        )),
                                                        SizedBox(width: 14.w),
                                                        Expanded(
                                                          child: GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Container(
                                                                  height: 50.w,
                                                                  decoration: BoxDecoration(
                                                                    color: buttonDisabled,
                                                                    borderRadius: BorderRadius.circular(8.w),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      "취소",
                                                                      style: dialogChoice.copyWith(
                                                                        color: yachtViolet,
                                                                      ),
                                                                    ),
                                                                  ))),
                                                        ),
                                                      ],
                                                    )
                                                  ]),
                                                ),
                                              );
                                            });
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/delete.svg',
                                        width: 16.w,
                                        height: 16.w,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        await controller.toggleLikeComment(controller.postRx.value!, comments[index]);
                                        await controller.reloadThisPost(controller.postRx.value!);
                                      },
                                      child: LikeButton(
                                        size: 16.w,
                                        isLiked: comments[index].likedBy == null
                                            ? false
                                            : comments[index].likedBy!.contains(userModelRx.value!.uid),
                                      ),
                                    ),
                        ),
                      )
                    ],
                  );
                },
              ),
              SizedBox(height: 6.w),
              if (comments.length > maxCommentLength)
                GestureDetector(
                  onTap: () {
                    _mixpanelService.mixpanel.track('Feed Detail', properties: {
                      'Post ID': post.postId,
                      'Post Write DateTime': post.writtenDateTime.toDate().toIso8601String(),
                      'Post Edit DateTime': post.editedDateTime == null
                          ? post.writtenDateTime.toDate().toIso8601String()
                          : post.editedDateTime.toDate().toIso8601String(),
                      'Post Title': post.title ?? "",
                      'Is Pro Post': post.isPro,
                      'Is Notice': post.isNotice,
                      'Post Writer Uid': post.writerUid,
                      'Post Writer User Name': post.writerUserName,
                      'Post Writer Exp': post.writerExp,
                      'Post Has Image': post.imageUrlList == null
                          ? false
                          : post.imageUrlList!.length > 0
                              ? true
                              : false,
                    });
                    Get.to(() => NewFeedDetailWidget(
                          post: controller.postRx.value!,
                        ));
                  },
                  child: Text(
                    "댓글 ${comments.length}개 모두 보기",
                    style: feedWriterName.copyWith(
                      color: yachtViolet,
                    ),
                  ),
                )
            ]);
          }
        });
  }
}

class FeedContentWidget extends StatelessWidget {
  FeedContentWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;
  final RxInt maxLinesForContent = 3.obs;
  final RxBool isMaxLineExtended = false.obs;
  bool hasTextOverflow(String text, TextStyle style,
      {double minWidth = 0, double maxWidth = double.infinity, int maxLines = 3}) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: minWidth, maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
            _mixpanelService.mixpanel.track('Feed Detail', properties: {
              'Post ID': post.postId,
              'Post Write DateTime': post.writtenDateTime.toDate().toIso8601String(),
              'Post Edit DateTime': post.editedDateTime == null
                  ? post.writtenDateTime.toDate().toIso8601String()
                  : post.editedDateTime.toDate().toIso8601String(),
              'Post Title': post.title ?? "",
              'Is Pro Post': post.isPro,
              'Is Notice': post.isNotice,
              'Post Writer Uid': post.writerUid,
              'Post Writer User Name': post.writerUserName,
              'Post Writer Exp': post.writerExp,
              'Post Has Image': post.imageUrlList == null
                  ? false
                  : post.imageUrlList!.length > 0
                      ? true
                      : false,
            });
            Get.to(() => NewFeedDetailWidget(post: post));
          },
          child: Stack(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Linkify(
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
                maxLines: maxLinesForContent.value,
                overflow: TextOverflow.ellipsis,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(1),
                    Colors.white,
                  ], stops: [
                    0,
                    0.2,
                    1
                  ])),
                  // color: Colors.white,
                  child: GestureDetector(
                    behavior: HitTestBehavior.deferToChild,
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      // 텍스트 최종 길이에 따라서 더보기 누를 때 다르게 반응
                      if (hasTextOverflow(
                        post.content,
                        feedContent,
                        maxLines: 10,
                      )) {
                        _mixpanelService.mixpanel.track('Feed Detail', properties: {
                          'Post ID': post.postId,
                          'Post Write DateTime': post.writtenDateTime.toDate().toIso8601String(),
                          'Post Edit DateTime': post.editedDateTime == null
                              ? post.writtenDateTime.toDate().toIso8601String()
                              : post.editedDateTime.toDate().toIso8601String(),
                          'Post Title': post.title ?? "",
                          'Is Pro Post': post.isPro,
                          'Is Notice': post.isNotice,
                          'Post Writer Uid': post.writerUid,
                          'Post Writer User Name': post.writerUserName,
                          'Post Writer Exp': post.writerExp,
                          'Post Has Image': post.imageUrlList == null
                              ? false
                              : post.imageUrlList!.length > 0
                                  ? true
                                  : false,
                        });
                        Get.to(() => NewFeedDetailWidget(post: post));
                        print("TOO LONG");
                      } else {
                        if (!isMaxLineExtended.value) {
                          maxLinesForContent(6);
                          isMaxLineExtended(!isMaxLineExtended.value);
                        } else {
                          maxLinesForContent(3);
                          isMaxLineExtended(!isMaxLineExtended.value);
                        }
                      }
                    },
                    child: (hasTextOverflow(
                      post.content,
                      feedContent,
                      maxLines: maxLinesForContent.value,
                    ))
                        ? isMaxLineExtended.value
                            ? SizedBox.shrink()
                            : Text("      ... 더보기")
                        : SizedBox.shrink(),
                  ),
                ),
              ),
            ],
          ),
          //  ExtendedText(
          //   post.content,
          //   maxLines: maxLinesForContent.value,
          //   style: feedContent,
          //   overflowWidget: TextOverflowWidget(
          //     child: GestureDetector(
          //         behavior: HitTestBehavior.deferToChild,
          //         onTap: () {
          //           // 텍스트 최종 길이에 따라서 더보기 누를 때 다르게 반응
          //           if (hasTextOverflow(
          //             post.content,
          //             feedContent,
          //             maxLines: 10,
          //           )) {
          //             Get.to(() => NewFeedDetailWidget(post: post));
          //             print("TOO LONG");
          //           } else {
          //             maxLinesForContent(6);
          //           }
          //         },
          //         child: Text("  ...더보기")),
          //   ),
          // ),
        ));
  }
}

class CommentInputWidget extends StatelessWidget {
  CommentInputWidget({
    Key? key,
    required this.post,
    required this.communityViewModel,
    required this.widgetController,
  }) : super(key: key);
  final PostModel post;
  final CommunityViewModel communityViewModel;
  final TextEditingController _commentController = TextEditingController();
  final NewFeedWidgetController widgetController;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormFieldState> _key = GlobalKey<FormFieldState>();

    // print(_commmentInputController.commentFocusNode.hasPrimaryFocus);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Obx(
                () => Center(
                  child: TextFormField(
                    key: _key,
                    onTap: () {
                      // FocusNode focusNode = FocusScope.of(context);
                      // if (focusNode.canRequestFocus) {
                      //   focusNode.requestFocus();
                      // }
                      // _commmentInputController.commentFocusNode.requestFocus(_commmentInputController.commentFocusNode);

                      HapticFeedback.lightImpact();
                    },
                    focusNode: widgetController.commentFocusNode,
                    controller: _commentController,
                    minLines: 1,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.center,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      // prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      isDense: true,
                      filled: true,
                      fillColor: widgetController.isFocused.value ? yachtPaleGrey : yachtPaleGrey,
                      contentPadding: EdgeInsets.fromLTRB(8.w, 8.w, 40.w, 8.w),
                      // prefixText:
                      // prefixStyle: TextStyle(color: yachtBlack),
                      // prefixIcon: _commmentInputController.isFocused.value
                      //     ? Text(
                      //         '  ${userModelRx.value!.userName}  ',
                      //         style: TextStyle(color: yachtBlack),
                      //       )
                      //     : SizedBox.shrink(),
                      // prefixIconConstraints: BoxConstraints(minWidth: 8.w, minHeight: 0),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                      hintText: "댓글 남기기",
                      hintStyle: feedContent.copyWith(
                        color: yachtGrey,
                        height: 1.2.w,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: widgetController.isFocused.value,
                  child: Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () async {
                          HapticFeedback.heavyImpact();
                          await communityViewModel.uploadComment(
                            post,
                            _commentController.text,
                          );
                          _commentController.clear();
                          widgetController.commentFocusNode.unfocus();
                          print("게시");
                        },
                        child: SizedBox(
                          // height: double.infinity,
                          width: 40.w,
                          child: Text(
                            "게시",
                            style: feedWriterName.copyWith(
                              color: yachtViolet,
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ImagePageView extends StatelessWidget {
  ImagePageView({
    Key? key,
    required this.post,
  }) : super(key: key);

  final PostModel post;
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final RxInt imagePageIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350.w,
          child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: post.imageUrlList!.length,
              onPageChanged: (index) {
                imagePageIndex(index);
              },
              itemBuilder: (_, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(5.w),
                        child: InkWell(
                          onTap: () {
                            _mixpanelService.mixpanel.track('Image From Post', properties: {
                              'Image From Post ID': post.postId,
                              'Image From Post Write DateTime': post.writtenDateTime.toDate().toIso8601String(),
                              'Image From Post Edit DateTime': post.editedDateTime == null
                                  ? post.writtenDateTime.toDate().toIso8601String()
                                  : post.editedDateTime.toDate().toIso8601String(),
                              'Image From Post Title': post.title ?? "",
                              'Image From Is Pro Post': post.isPro,
                              'Image From Is Notice': post.isNotice,
                              'Image From Post Writer Uid': post.writerUid,
                              'Image From Post Writer User Name': post.writerUserName,
                              'Image From Post Writer Exp': post.writerExp,
                              'Image From Page': "Community",
                            });
                            // print(imageUrls);
                            // showDialog(
                            // context: context, builder: (context) => buildPhotoPageView(context, index, imageUrls));
                          },
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://storage.googleapis.com/ggook-5fb08.appspot.com/${post.imageUrlList![index]}",
                            height: ScreenUtil().screenWidth,
                            width: ScreenUtil().screenWidth,
                            fit: BoxFit.contain,
                          ),
                        )),
                  ],
                );
              }),
        ),
        SizedBox(height: 4.w),
        post.imageUrlList!.length == 1
            ? Container()
            : Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(post.imageUrlList!.length, (index) {
                    return Row(
                      children: [
                        Container(
                          height: 4.w,
                          width: 4.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (index == imagePageIndex.value) ? yachtViolet : yachtLightGrey,
                          ),
                        ),
                        (index < post.imageUrlList!.length) ? SizedBox(width: 4.w) : Container(),
                      ],
                    );
                  }),
                ))
      ],
    );
  }

  Dialog buildPhotoPageView(BuildContext context, int index, List<String> imageUrls) {
    return Dialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      child: Column(children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(14.w),
            alignment: Alignment.topLeft,
            // height: 100,
            // color: Colors.white,
            child: Image.asset(
              'assets/icons/pic_close.png',
              width: 24.w,
              height: 24.w,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              // GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   onTap: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: Container(
              //     width: ScreenUtil().screenWidth * .10,
              //     height: 200,
              //     // width: 20,
              //   ),
              // ),
              Expanded(
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 10.w),
                  // width: double.infinity,
                  child: GestureDetector(
                    onTap: () {
                      print('tap');
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: ExtendedImageGesturePageView.builder(
                        controller: ExtendedPageController(
                          initialPage: index,
                          viewportFraction: 1.0,
                        ),
                        itemCount: post.imageUrlList!.length,
                        itemBuilder: (context, index) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(14.w),
                              child: ExtendedImage.network(
                                "https://storage.googleapis.com/ggook-5fb08.appspot.com/${post.imageUrlList![index]}",
                                fit: BoxFit.fitWidth,
                                mode: ExtendedImageMode.gesture,
                                shape: BoxShape.rectangle,
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(20.w),
                                initGestureConfigHandler: (state) {
                                  return GestureConfig(
                                    minScale: 0.9,
                                    animationMinScale: 0.7,
                                    maxScale: 3.0,
                                    animationMaxScale: 3.5,
                                    speed: 1.0,
                                    inertialSpeed: 100.0,
                                    initialScale: 1.0,
                                    inPageView: true,
                                    initialAlignment: InitialAlignment.center,
                                  );
                                },
                              ));
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   onTap: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: Container(
              //     width: ScreenUtil().screenWidth * .10,
              //     height: 200,
              //     // width: 20,
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          height: 14.w,
        ),
      ]),
    );
  }
}

class FeedHeader extends StatelessWidget {
  const FeedHeader({
    Key? key,
    required this.post,
    required this.communityViewModel,
  }) : super(key: key);

  final PostModel post;
  final CommunityViewModel communityViewModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${post.writerAvatarUrl}.png",
                )),
            SizedBox(width: 4.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  post.writerUserName,
                  style: TextStyle(
                    fontSize: 14.w,
                    fontWeight: FontWeight.w600,
                    wordSpacing: -.5,
                    height: 1.2,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      tierSystemModelRx
                          .value!.tierKorNameMap[separateStringFromTier(getTierByExp(post.writerExp ?? 0))]!,
                      style: TextStyle(
                        fontSize: 12.w,
                        fontWeight: FontWeight.w400,
                        color: yachtGrey,
                        wordSpacing: -.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        PopupMenuButton(
          itemBuilder: (context) {
            return post.writerUid == userModelRx.value!.uid ? communityMyShowMore : communityShowMore;
            //  : communityShowMore;
          },
          onSelected: (value) {
            switch (value) {
              case 'edit':
                Get.bottomSheet(
                  EditingMyPost(
                    // contentFormKey: _contentFormKey,
                    // contentController: _contentController,
                    communityViewModel: communityViewModel,
                    post: post,
                  ),
                  isScrollControlled: true,
                  ignoreSafeArea: false, // add this
                );
                break;
              case 'delete':
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          insetPadding: primaryHorizontalPadding,
                          child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(14.w, correctHeight(14.w, 0.0, dialogTitle.fontSize), 14.w, 14.w),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("알림", style: dialogTitle),
                                  SizedBox(height: correctHeight(14.w, 0.0, dialogTitle.fontSize)),
                                  SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                  Text("정말 삭제하시겠습니까?", style: dialogContent),
                                  Text(
                                    "삭제 후 되돌릴 수 없습니다.",
                                    style: dialogWarning,
                                  ),
                                  SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                            onTap: () async {
                                              HapticFeedback.lightImpact();
                                              await communityViewModel.deletePost(post);
                                              await communityViewModel.reloadPost();
                                              Navigator.of(context).pop();
                                              yachtSnackBar("피드가 삭제되었습니다");
                                            },
                                            child: textContainerButtonWithOptions(
                                              text: "예",
                                              isDarkBackground: true,
                                              height: 44.w,
                                            )),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              // Get.back(closeOverlays: true);
                                            },
                                            child: textContainerButtonWithOptions(
                                                text: "아니오", isDarkBackground: false, height: 44.w)),
                                      )
                                    ],
                                  )
                                ],
                              )));
                    });
                break;
              case 'block':
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          insetPadding: primaryHorizontalPadding,
                          child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(14.w, correctHeight(14.w, 0.0, dialogTitle.fontSize), 14.w, 14.w),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("알림", style: dialogTitle),
                                  SizedBox(height: correctHeight(14.w, 0.0, dialogTitle.fontSize)),
                                  SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                  Text("유저를 차단하시겠습니까?", style: dialogContent),
                                  // Text(
                                  //   "삭제 후 되돌릴 수 없습니다.",
                                  //   style: dialogWarning,
                                  // ),
                                  SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                            onTap: () async {
                                              HapticFeedback.lightImpact();
                                              await communityViewModel.blockThisUser(post.writerUid);
                                              await communityViewModel.reloadPost();
                                              Navigator.of(context).pop();
                                              yachtSnackBar("유저를 차단하였습니다");
                                            },
                                            child: textContainerButtonWithOptions(
                                              text: "예",
                                              isDarkBackground: true,
                                              height: 44.w,
                                            )),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              // Get.back(closeOverlays: true);
                                            },
                                            child: textContainerButtonWithOptions(
                                                text: "아니오", isDarkBackground: false, height: 44.w)),
                                      )
                                    ],
                                  )
                                ],
                              )));
                    });
                break;
              case 'report':
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                          insetPadding: primaryHorizontalPadding,
                          child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(14.w, correctHeight(14.w, 0.0, dialogTitle.fontSize), 14.w, 14.w),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("알림", style: dialogTitle),
                                  SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                  Text("이 글을 신고하시겠습니까?", style: dialogContent),
                                  Text(
                                    "신고한 유저는 자동으로 차단됩니다.",
                                    style: dialogWarning.copyWith(color: yachtDarkGrey),
                                  ),
                                  SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                            onTap: () async {
                                              HapticFeedback.lightImpact();
                                              await communityViewModel.blockThisUser(post.writerUid);
                                              await communityViewModel.reportThisUser(post);
                                              await communityViewModel.reloadPost();
                                              Navigator.of(context).pop();
                                              yachtSnackBar("유저를 신고/차단하였습니다");
                                            },
                                            child: textContainerButtonWithOptions(
                                              text: "신고하기",
                                              isDarkBackground: true,
                                              height: 44.w,
                                            )),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              // Get.back(closeOverlays: true);
                                            },
                                            child: textContainerButtonWithOptions(
                                                text: "취소", isDarkBackground: false, height: 44.w)),
                                      )
                                    ],
                                  )
                                ],
                              )));
                    });
                break;
              default:
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 18.w,
                height: 10.w,
                color: Colors.transparent,
                child: SvgPicture.asset(
                  'assets/icons/show_more.svg',
                  color: yachtBlack,
                ),
              ),
              SizedBox(height: 8.w),
              Text(
                feedTimeHandler(post.writtenDateTime.toDate()),
                // x초전, x분 전, 일정 이후면 날짜로
                style: feedDateTime,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class EditingMyPost extends StatelessWidget {
  EditingMyPost({
    Key? key,
    required CommunityViewModel communityViewModel,
    required PostModel post,
  })  : _communityViewModel = communityViewModel,
        post = post,
        super(key: key);

  final GlobalKey<FormState> _contentFormKey = GlobalKey<FormState>();
  TextEditingController _contentController = TextEditingController();
  final PostModel post;
  final CommunityViewModel _communityViewModel;

  @override
  Widget build(BuildContext context) {
    _contentController = TextEditingController(text: post.content);
    return Column(
      children: [
        Container(
          color: primaryBackgroundColor,
          height: MediaQuery.of(context).padding.top,
        ),
        Container(
          height: 60,
          padding: primaryHorizontalPadding,
          color: primaryBackgroundColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset('assets/icons/exit.png', width: 14.w, height: 14.w, color: yachtBlack)),
                ),
              ),
              Text(
                "나의 글 수정하기",
                style: appBarTitle,
              ),
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () async {
                        if (_contentFormKey.currentState!.validate()) {
                          // print("OKAY");
                          print(_contentController.value.text);
                          await _communityViewModel.editPost(post, _contentController.value.text);
                          await _communityViewModel.reloadPost();

                          Get.back();
                          yachtSnackBar("성공적으로 수정 되었어요.");
                        }
                      },
                      child: simpleTextContainerButton("올리기")),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 52.w,
          width: double.infinity,
          decoration: BoxDecoration(
              color: primaryBackgroundColor,
              border: Border(
                bottom: BorderSide(color: Colors.black.withOpacity(.05), width: 1.w),
                top: BorderSide(color: Colors.black.withOpacity(.05), width: 1.w),
              )),
          child: Center(child: Text("피드", style: sectionTitle)),
        ),
        Form(
          key: _contentFormKey,
          child: Expanded(
            child: Container(
                color: primaryBackgroundColor,
                child: Column(
                  children: [
                    Expanded(
                      child: TextFormField(
                        // autofocus: true,
                        controller: _contentController,
                        validator: (value) {
                          if (value!.length < 4) {
                            return '4자 이상 글을 올려주세요.';
                          } else {
                            return null;
                          }
                        },
                        maxLines: null,
                        decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(14.w),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: '글을 입력해주세요.',
                            hintStyle: feedContent.copyWith(color: feedContent.color!.withOpacity(.5))),
                      ),
                    ),
                    // 업로드한 이미지 미리보기하는 부분
                    Obx(() {
                      if (_communityViewModel.images!.length == 0) {
                        return Container();
                      } else {
                        print(_communityViewModel.images![0]);
                        return Container(
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(color: Colors.black.withOpacity(.05), width: 1.w),
                          )),
                          height: 100.w,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _communityViewModel.images!.length,
                              itemBuilder: (_, index) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 14.w,
                                    ),
                                    Stack(children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(16.w),
                                        child: Image.file(
                                          File(_communityViewModel.images![index].path),
                                          height: 100.w,
                                          width: 100.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 10.w,
                                        right: 10.w,
                                        child: InkWell(
                                            onTap: () => _communityViewModel.images!.removeAt(index),
                                            child: Container(
                                              height: 20.w,
                                              width: 20.w,
                                              // color: Colors.red,
                                              child: Image.asset('assets/icons/deletePhoto.png'),
                                            )),
                                      ),
                                    ]),
                                  ],
                                );
                              }),
                        );
                      }
                    }),
                    Container(
                      height: 40.w,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: primaryBackgroundColor,
                          border: Border(
                            bottom: BorderSide(color: Colors.black.withOpacity(.05), width: 1.w),
                            top: BorderSide(color: Colors.black.withOpacity(.05), width: 1.w),
                          )),
                      // color: Colors.yellow,
                      child: GestureDetector(
                        onTap: () async {
                          await _communityViewModel.getImageFromDevice();
                          print('image length: ${_communityViewModel.images!.length}');
                        },
                        child: Padding(
                          padding: primaryHorizontalPadding,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/upload_photo.svg',
                                height: 18.w,
                                width: 18.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
