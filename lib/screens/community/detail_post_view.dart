import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/community/comment_model.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/community/community_widgets.dart';
import 'package:yachtOne/screens/community/feed_widget.dart';
import 'package:yachtOne/screens/profile/profile_my_view.dart';
import 'package:yachtOne/screens/profile/profile_others_view.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/widgets/like_button.dart';
import 'package:yachtOne/widgets/loading_container.dart';

import '../../locator.dart';
import 'community_view_model.dart';
import 'detail_post_view_model.dart';
import 'package:render_metrics/render_metrics.dart';

class DetailPostView extends GetView<DetailPostViewModel> {
  final PostModel post;

  // DetailPostView({
  //   Key? key,
  // }) : super(key: key);
  final MixpanelService _mixpanelService = locator<MixpanelService>();

  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  DetailPostView(this.post);
  // final GlobalKey<FormState> _commentFormKey = GlobalKey<FormState>();
  // final _commentController = TextEditingController();

  // CommunityView에서 argument로 넘긴 PostModel을 바로 viewModel로 보냄.

  ScrollController _scrollController = ScrollController();
  CommunityViewModel communityViewModel = Get.find<CommunityViewModel>();
  RxDouble bottomSpace = 76.0.w.obs;
  @override
  Widget build(BuildContext context) {
    DetailPostViewModel detailPostViewModel = Get.put(DetailPostViewModel(post));
    List<String> imageUrls = List.generate(detailPostViewModel.post.imageUrlList!.length, (index) => "");
    return Scaffold(
      appBar: post.isNotice ? primaryAppBar("공지사항") : primaryAppBar("피드"),
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: 14.w),
                Padding(
                  padding: primaryHorizontalPadding,
                  child: Container(
                    decoration: primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow]),
                    child: Column(
                      children: [
                        Container(
                          padding: moduleBoxPadding(feedDateTime.fontSize!),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 아바타 이미지 임시
                              post.isNotice
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () {
                                        if (post.writerUid != userModelRx.value!.uid) {
                                          _mixpanelService.mixpanel.track('Profile From Feed', properties: {
                                            'Feed Profile Name': post.writerUserName,
                                            'Feed Profile UID': post.writerUid,
                                            'Feed Post ID': post.postId,
                                          });
                                          Get.to(() => ProfileOthersView(uid: post.writerUid));
                                        }
                                        // else
                                        // Get.to(() => ProfileMyView());
                                      },
                                      child: Container(
                                          width: 36.w,
                                          height: 36.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${post.writerAvatarUrl}.png",
                                          )

                                          // child: CachedNetworkImage(
                                          //   imageUrl:
                                          //       "https://firebasestorage.googleapis.com/v0/b/ggook-5fb08.appspot.com/o/avatars%2F002.png?alt=media&token=68d48250-0831-4daa-b0c9-3f10608fb24c",
                                          // )
                                          ),
                                    ),
                              post.isNotice
                                  ? Container()
                                  : SizedBox(
                                      width: 6.w,
                                    ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    post.isNotice
                                        ? Text(
                                            "[공지사항]",
                                            style: feedWriterName.copyWith(color: yachtRed),
                                          )
                                        : Container(
                                            height: 36.w,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      detailPostViewModel.post.writerUserName,
                                                      style: feedWriterName,
                                                    ),
                                                    SizedBox(
                                                      width: 8.w,
                                                    ),
                                                    // 티어 컨테이너
                                                    GestureDetector(
                                                        onTap: () => showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return yachtTierInfoPopUp(context, post.writerExp ?? 0);
                                                            }),
                                                        child: simpleTierRRectBox(
                                                            exp: detailPostViewModel.post.writerExp ?? 0)),
                                                    Spacer(),
                                                    PopupMenuButton(
                                                      padding: EdgeInsets.symmetric(horizontal: 4),
                                                      child: Row(children: [
                                                        SizedBox(
                                                          width: 8.w,
                                                        ),
                                                        Container(
                                                          width: 14.w,
                                                          height: 16.w,
                                                          // color: Colors.blue[50],
                                                          child: SvgPicture.asset(
                                                            'assets/icons/show_more.svg',
                                                            color: yachtBlack,
                                                          ),
                                                        ),
                                                      ]),
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
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              14.w,
                                                                              correctHeight(
                                                                                  14.w, 0.0, dialogTitle.fontSize),
                                                                              14.w,
                                                                              14.w),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(10.w)),
                                                                          child: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text("알림", style: dialogTitle),
                                                                              SizedBox(
                                                                                  height: correctHeight(
                                                                                      14.w, 0.0, dialogTitle.fontSize)),
                                                                              SizedBox(
                                                                                  height: correctHeight(24.w, 0.w,
                                                                                      dialogContent.fontSize)),
                                                                              Text("정말 삭제하시겠습니까?",
                                                                                  style: dialogContent),
                                                                              Text(
                                                                                "삭제 후 되돌릴 수 없습니다.",
                                                                                style: dialogWarning,
                                                                              ),
                                                                              SizedBox(
                                                                                  height: correctHeight(24.w, 0.w,
                                                                                      dialogContent.fontSize)),
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: GestureDetector(
                                                                                        onTap: () async {
                                                                                          HapticFeedback.lightImpact();
                                                                                          await communityViewModel
                                                                                              .deletePost(post);
                                                                                          await communityViewModel
                                                                                              .getPost();
                                                                                          await detailPostViewModel
                                                                                              .getComments(post);
                                                                                          Navigator.of(context).pop();
                                                                                          Get.back();
                                                                                          yachtSnackBar("피드가 삭제되었습니다");
                                                                                        },
                                                                                        child:
                                                                                            textContainerButtonWithOptions(
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
                                                                                        child:
                                                                                            textContainerButtonWithOptions(
                                                                                                text: "아니오",
                                                                                                isDarkBackground: false,
                                                                                                height: 44.w)),
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
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              14.w,
                                                                              correctHeight(
                                                                                  14.w, 0.0, dialogTitle.fontSize),
                                                                              14.w,
                                                                              14.w),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(10.w)),
                                                                          child: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text("알림", style: dialogTitle),
                                                                              SizedBox(
                                                                                  height: correctHeight(
                                                                                      14.w, 0.0, dialogTitle.fontSize)),
                                                                              SizedBox(
                                                                                  height: correctHeight(24.w, 0.w,
                                                                                      dialogContent.fontSize)),
                                                                              Text("유저를 차단하시겠습니까?",
                                                                                  style: dialogContent),
                                                                              // Text(
                                                                              //   "삭제 후 되돌릴 수 없습니다.",
                                                                              //   style: dialogWarning,
                                                                              // ),
                                                                              SizedBox(
                                                                                  height: correctHeight(24.w, 0.w,
                                                                                      dialogContent.fontSize)),
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: GestureDetector(
                                                                                        onTap: () async {
                                                                                          HapticFeedback.lightImpact();
                                                                                          await communityViewModel
                                                                                              .blockThisUser(
                                                                                                  post.writerUid);
                                                                                          await communityViewModel
                                                                                              .reloadPost();
                                                                                          Navigator.of(context).pop();
                                                                                          yachtSnackBar("유저를 차단하였습니다");
                                                                                        },
                                                                                        child:
                                                                                            textContainerButtonWithOptions(
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
                                                                                        child:
                                                                                            textContainerButtonWithOptions(
                                                                                                text: "아니오",
                                                                                                isDarkBackground: false,
                                                                                                height: 44.w)),
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
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              14.w,
                                                                              correctHeight(
                                                                                  14.w, 0.0, dialogTitle.fontSize),
                                                                              14.w,
                                                                              14.w),
                                                                          decoration: BoxDecoration(
                                                                              borderRadius:
                                                                                  BorderRadius.circular(10.w)),
                                                                          child: Column(
                                                                            mainAxisSize: MainAxisSize.min,
                                                                            children: [
                                                                              Text("알림", style: dialogTitle),
                                                                              SizedBox(
                                                                                  height: correctHeight(24.w, 0.w,
                                                                                      dialogContent.fontSize)),
                                                                              Text("이 글을 신고하시겠습니까?",
                                                                                  style: dialogContent),
                                                                              Text(
                                                                                "신고한 유저는 자동으로 차단됩니다.",
                                                                                style: dialogWarning.copyWith(
                                                                                    color: yachtDarkGrey),
                                                                              ),
                                                                              SizedBox(
                                                                                  height: correctHeight(24.w, 0.w,
                                                                                      dialogContent.fontSize)),
                                                                              Row(
                                                                                children: [
                                                                                  Expanded(
                                                                                    child: GestureDetector(
                                                                                        onTap: () async {
                                                                                          HapticFeedback.lightImpact();
                                                                                          await communityViewModel
                                                                                              .blockThisUser(
                                                                                                  post.writerUid);
                                                                                          await communityViewModel
                                                                                              .reportThisUser(post);
                                                                                          await communityViewModel
                                                                                              .reloadPost();
                                                                                          Navigator.of(context).pop();
                                                                                          yachtSnackBar(
                                                                                              "유저를 신고/차단하였습니다");
                                                                                        },
                                                                                        child:
                                                                                            textContainerButtonWithOptions(
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
                                                                                        child:
                                                                                            textContainerButtonWithOptions(
                                                                                                text: "취소",
                                                                                                isDarkBackground: false,
                                                                                                height: 44.w)),
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
                                                      itemBuilder: (context) {
                                                        return post.writerUid == userModelRx.value!.uid
                                                            ? communityMyShowMore
                                                            : communityShowMore;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 4.w),
                                                Text(
                                                  feedTimeHandler(detailPostViewModel.post.writtenDateTime.toDate()),
                                                  // x초전, x분 전, 일정 이후면 날짜로
                                                  style: feedDateTime,
                                                ),
                                              ],
                                            ),
                                          ),
                                    SizedBox(
                                        height: reducedPaddingWhenTextIsBothSide(
                                            6.w, feedUserName.fontSize!, feedTitle.fontSize!)),
                                    detailPostViewModel.post.title == null
                                        ? Container()
                                        : Column(
                                            children: [
                                              SizedBox(
                                                height: 6.w,
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  post.isPro
                                                      ? Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal: 8.w, vertical: 1.w),
                                                                decoration: BoxDecoration(
                                                                  color: yachtRed,
                                                                  borderRadius: BorderRadius.circular(20.w),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "PRO",
                                                                    style: TextStyle(
                                                                      fontSize: 11.w,
                                                                      fontWeight: FontWeight.w500,
                                                                      color: white,
                                                                      height: 1.4,
                                                                    ),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                )),
                                                            SizedBox(
                                                              width: 4.w,
                                                            )
                                                          ],
                                                        )
                                                      : Container(),
                                                  Text(
                                                    post.title!,
                                                    style: feedTitle,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                    SizedBox(
                                      height: 2.w,
                                    ),
                                    Obx(
                                      () => Linkify(
                                        onOpen: (link) async {
                                          if (await canLaunch(link.url)) {
                                            await launch(link.url);
                                          } else {
                                            throw 'Could not launch $link';
                                          }
                                        },
                                        text: detailPostViewModel.thisPost.value.content,
                                        style: feedContent,
                                        linkStyle: feedContent.copyWith(color: yachtViolet),
                                        maxLines: 50,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.w,
                                    ),
                                    (detailPostViewModel.post.imageUrlList == null ||
                                            detailPostViewModel.post.imageUrlList!.length == 0)
                                        ? Container()
                                        : Column(
                                            children: [
                                              Container(
                                                height: 140.w,
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: detailPostViewModel.post.imageUrlList!.length,
                                                    itemBuilder: (_, index) {
                                                      return Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(5.w),
                                                            child: InkWell(
                                                              onTap: () {
                                                                _mixpanelService.mixpanel
                                                                    .track('Image From Post', properties: {
                                                                  'Image From Post ID': post.postId,
                                                                  'Image From Post Write DateTime':
                                                                      post.writtenDateTime.toDate().toIso8601String(),
                                                                  'Image From Post Edit DateTime': post
                                                                              .editedDateTime ==
                                                                          null
                                                                      ? post.writtenDateTime.toDate().toIso8601String()
                                                                      : post.editedDateTime.toDate().toIso8601String(),
                                                                  'Image From Post Title': post.title ?? "",
                                                                  'Image From Is Pro Post': post.isPro,
                                                                  'Image From Is Notice': post.isNotice,
                                                                  'Image From Post Writer Uid': post.writerUid,
                                                                  'Image From Post Writer User Name':
                                                                      post.writerUserName,
                                                                  'Image From Post Writer Exp': post.writerExp,
                                                                  'Image From Page': "Post Detail",
                                                                });
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (context) =>
                                                                        buildPhotoPageView(context, index, imageUrls));
                                                                // Get.dialog(buildPhotoPageView(
                                                                //     index, imageUrls, detailPostViewModel));
                                                              },
                                                              child: CachedNetworkImage(
                                                                imageUrl:
                                                                    "https://storage.googleapis.com/ggook-5fb08.appspot.com/${detailPostViewModel.post.imageUrlList![index]}",
                                                                height: 140.w,
                                                                width: 140.w,
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 4.w,
                                                          ),
                                                        ],
                                                      );
                                                    }),
                                              ),
                                              SizedBox(height: 8.w),
                                            ],
                                          ),
                                    (detailPostViewModel.post.hashTags == null ||
                                            detailPostViewModel.post.hashTags!.length == 0)
                                        ? Container()
                                        : Wrap(
                                            spacing: 4.w,
                                            runSpacing: 4.w,
                                            children: List.generate(
                                              // detailPostViewModel.post.hashTags!.length,
                                              5,
                                              (index) {
                                                return feedHashTagContainer('경제지식');
                                              },
                                            )),

                                    //hashTag 길이에 따라 dynamic하게
                                    SizedBox(
                                      height: 14.w,
                                    ),
                                    Container(
                                      // height: 30.w,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Container(
                                                  // color: Colors.blue,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children: [
                                                      SvgPicture.asset('assets/icons/comment.svg', color: yachtBlack),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                      Obx(() => Text(
                                                            detailPostViewModel.comments.length.toString(),
                                                            style: feedCommentLikeCount,
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    _mixpanelService.mixpanel.track('Post Like', properties: {
                                                      'Like Post ID': post.postId,
                                                      'Like Post From Page': "Post Detail"
                                                    });
                                                    HapticFeedback.lightImpact();
                                                    await detailPostViewModel.toggleLikeComment(post);
                                                    await detailPostViewModel.getThisPost(post);
                                                    await communityViewModel.reloadPost();
                                                  },
                                                  child: Obx(
                                                    () => Row(
                                                      children: [
                                                        LikeButton(
                                                          size: 20.w,
                                                          isLiked: detailPostViewModel.thisPost.value.likedBy == null
                                                              ? false
                                                              : detailPostViewModel.thisPost.value.likedBy!
                                                                  .contains(userModelRx.value!.uid),
                                                        ),
                                                        SizedBox(
                                                          width: 8.w,
                                                        ),
                                                        Text(
                                                          detailPostViewModel.thisPost.value.likedBy == null
                                                              ? 0.toString()
                                                              : detailPostViewModel.thisPost.value.likedBy!.length
                                                                  .toString(),
                                                          style: feedCommentLikeCount,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(child: SvgPicture.asset('assets/icons/share.svg', color: white)),
                                              Container(
                                                width: 3,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => detailPostViewModel.comments.length == 0
                              ? Container()
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: detailPostViewModel.comments.length,
                                  itemBuilder: (_, index) {
                                    // 코멘트 컨테이너
                                    return Column(
                                      children: [
                                        Container(
                                          height: 1.w,
                                          color: yachtLightGrey,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            detailPostViewModel
                                                .replyToCommentId("${detailPostViewModel.comments[index].commentId}");
                                            detailPostViewModel
                                                .replyToUserUid("${detailPostViewModel.comments[index].writerUid}");
                                            detailPostViewModel.replyToUserName(
                                                "${detailPostViewModel.comments[index].writerUserName}");
                                          },
                                          child: Container(
                                            padding: moduleBoxPadding(feedDateTime.fontSize!),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (detailPostViewModel.comments[index].writerUid !=
                                                        userModelRx.value!.uid)
                                                      Get.to(() => ProfileOthersView(
                                                          uid: detailPostViewModel.comments[index].writerUid));
                                                    // else
                                                    // Get.to(() => ProfileMyView());
                                                  },
                                                  child: Container(
                                                      width: 36.w,
                                                      height: 36.w,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${detailPostViewModel.comments[index].writerAvatarUrl}.png",
                                                      )

                                                      // child: CachedNetworkImage(
                                                      //   imageUrl:
                                                      //       "https://firebasestorage.googleapis.com/v0/b/ggook-5fb08.appspot.com/o/avatars%2F002.png?alt=media&token=68d48250-0831-4daa-b0c9-3f10608fb24c",
                                                      // )
                                                      ),
                                                ),
                                                SizedBox(
                                                  width: 6.w,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            detailPostViewModel.comments[index].writerUserName,
                                                            style: feedWriterName,
                                                          ),
                                                          SizedBox(
                                                            width: 4.w,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () => showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return yachtTierInfoPopUp(
                                                                      context, post.writerExp ?? 0);
                                                                }),
                                                            child: simpleTierRRectBox(
                                                                exp:
                                                                    detailPostViewModel.comments[index].writerExp ?? 0),
                                                          ),
                                                          Spacer(),
                                                          PopupMenuButton(
                                                            padding: EdgeInsets.symmetric(horizontal: 4),
                                                            child: Row(children: [
                                                              Text(
                                                                feedTimeHandler(detailPostViewModel
                                                                    .comments[index].writtenDateTime
                                                                    .toDate()),
                                                                // x초전, x분 전, 일정 이후면 날짜로
                                                                style: feedDateTime,
                                                              ),
                                                              SizedBox(
                                                                width: 8.w,
                                                              ),
                                                              Container(
                                                                width: 14.w,
                                                                height: 16.w,
                                                                // color: Colors.blue[50],
                                                                child: SvgPicture.asset(
                                                                  'assets/icons/show_more.svg',
                                                                  color: yachtBlack,
                                                                ),
                                                              ),
                                                            ]),
                                                            onSelected: (value) {
                                                              switch (value) {
                                                                case 'delete':
                                                                  showDialog(
                                                                      context: context,
                                                                      builder: (context) {
                                                                        return Dialog(
                                                                            insetPadding: primaryHorizontalPadding,
                                                                            child: Container(
                                                                                padding: EdgeInsets.fromLTRB(
                                                                                    14.w,
                                                                                    correctHeight(14.w, 0.0,
                                                                                        dialogTitle.fontSize),
                                                                                    14.w,
                                                                                    14.w),
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(10.w)),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text("알림", style: dialogTitle),
                                                                                    SizedBox(
                                                                                        height: correctHeight(14.w, 0.0,
                                                                                            dialogTitle.fontSize)),
                                                                                    SizedBox(
                                                                                        height: correctHeight(24.w, 0.w,
                                                                                            dialogContent.fontSize)),
                                                                                    Text("정말 삭제하시겠습니까?",
                                                                                        style: dialogContent),
                                                                                    Text(
                                                                                      "삭제 후 되돌릴 수 없습니다.",
                                                                                      style: dialogWarning,
                                                                                    ),
                                                                                    SizedBox(
                                                                                        height: correctHeight(24.w, 0.w,
                                                                                            dialogContent.fontSize)),
                                                                                    Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: GestureDetector(
                                                                                              onTap: () async {
                                                                                                HapticFeedback
                                                                                                    .lightImpact();
                                                                                                await detailPostViewModel
                                                                                                    .deleteComment(
                                                                                                        detailPostViewModel
                                                                                                                .comments[
                                                                                                            index]);
                                                                                                await communityViewModel
                                                                                                    .getPost();
                                                                                                await detailPostViewModel
                                                                                                    .getComments(post);
                                                                                                Navigator.of(context)
                                                                                                    .pop();
                                                                                                yachtSnackBar(
                                                                                                    "댓글이 삭제되었습니다");
                                                                                              },
                                                                                              child:
                                                                                                  textContainerButtonWithOptions(
                                                                                                text: "예",
                                                                                                isDarkBackground: true,
                                                                                                height: 44.w,
                                                                                              )),
                                                                                        ),
                                                                                        SizedBox(width: 8.w),
                                                                                        Expanded(
                                                                                          child: InkWell(
                                                                                              onTap: () {
                                                                                                Navigator.of(context)
                                                                                                    .pop();
                                                                                                // Get.back(closeOverlays: true);
                                                                                              },
                                                                                              child:
                                                                                                  textContainerButtonWithOptions(
                                                                                                      text: "아니오",
                                                                                                      isDarkBackground:
                                                                                                          false,
                                                                                                      height: 44.w)),
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
                                                                                padding: EdgeInsets.fromLTRB(
                                                                                    14.w,
                                                                                    correctHeight(14.w, 0.0,
                                                                                        dialogTitle.fontSize),
                                                                                    14.w,
                                                                                    14.w),
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(10.w)),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text("알림", style: dialogTitle),
                                                                                    SizedBox(
                                                                                        height: correctHeight(14.w, 0.0,
                                                                                            dialogTitle.fontSize)),
                                                                                    SizedBox(
                                                                                        height: correctHeight(24.w, 0.w,
                                                                                            dialogContent.fontSize)),
                                                                                    Text("유저를 차단하시겠습니까?",
                                                                                        style: dialogContent),
                                                                                    // Text(
                                                                                    //   "삭제 후 되돌릴 수 없습니다.",
                                                                                    //   style: dialogWarning,
                                                                                    // ),
                                                                                    SizedBox(
                                                                                        height: correctHeight(24.w, 0.w,
                                                                                            dialogContent.fontSize)),
                                                                                    Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: GestureDetector(
                                                                                              onTap: () async {
                                                                                                HapticFeedback
                                                                                                    .lightImpact();
                                                                                                await communityViewModel
                                                                                                    .blockThisUser(
                                                                                                        post.writerUid);
                                                                                                await communityViewModel
                                                                                                    .reloadPost();
                                                                                                Navigator.of(context)
                                                                                                    .pop();
                                                                                                yachtSnackBar(
                                                                                                    "유저를 차단하였습니다");
                                                                                              },
                                                                                              child:
                                                                                                  textContainerButtonWithOptions(
                                                                                                text: "예",
                                                                                                isDarkBackground: true,
                                                                                                height: 44.w,
                                                                                              )),
                                                                                        ),
                                                                                        SizedBox(width: 8.w),
                                                                                        Expanded(
                                                                                          child: InkWell(
                                                                                              onTap: () {
                                                                                                Navigator.of(context)
                                                                                                    .pop();
                                                                                                // Get.back(closeOverlays: true);
                                                                                              },
                                                                                              child:
                                                                                                  textContainerButtonWithOptions(
                                                                                                      text: "아니오",
                                                                                                      isDarkBackground:
                                                                                                          false,
                                                                                                      height: 44.w)),
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
                                                                                padding: EdgeInsets.fromLTRB(
                                                                                    14.w,
                                                                                    correctHeight(14.w, 0.0,
                                                                                        dialogTitle.fontSize),
                                                                                    14.w,
                                                                                    14.w),
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius:
                                                                                        BorderRadius.circular(10.w)),
                                                                                child: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Text("알림", style: dialogTitle),
                                                                                    SizedBox(
                                                                                        height: correctHeight(24.w, 0.w,
                                                                                            dialogContent.fontSize)),
                                                                                    Text("이 글을 신고하시겠습니까?",
                                                                                        style: dialogContent),
                                                                                    Text(
                                                                                      "신고한 유저는 자동으로 차단됩니다.",
                                                                                      style: dialogWarning.copyWith(
                                                                                          color: yachtDarkGrey),
                                                                                    ),
                                                                                    SizedBox(
                                                                                        height: correctHeight(24.w, 0.w,
                                                                                            dialogContent.fontSize)),
                                                                                    Row(
                                                                                      children: [
                                                                                        Expanded(
                                                                                          child: GestureDetector(
                                                                                              onTap: () async {
                                                                                                HapticFeedback
                                                                                                    .lightImpact();
                                                                                                await communityViewModel
                                                                                                    .blockThisUser(
                                                                                                        post.writerUid);
                                                                                                await communityViewModel
                                                                                                    .reportThisUser(
                                                                                                        post);
                                                                                                await communityViewModel
                                                                                                    .reloadPost();
                                                                                                Navigator.of(context)
                                                                                                    .pop();
                                                                                                yachtSnackBar(
                                                                                                    "유저를 신고/차단하였습니다");
                                                                                              },
                                                                                              child:
                                                                                                  textContainerButtonWithOptions(
                                                                                                text: "신고하기",
                                                                                                isDarkBackground: true,
                                                                                                height: 44.w,
                                                                                              )),
                                                                                        ),
                                                                                        SizedBox(width: 8.w),
                                                                                        Expanded(
                                                                                          child: InkWell(
                                                                                              onTap: () {
                                                                                                Navigator.of(context)
                                                                                                    .pop();
                                                                                                // Get.back(closeOverlays: true);
                                                                                              },
                                                                                              child:
                                                                                                  textContainerButtonWithOptions(
                                                                                                      text: "취소",
                                                                                                      isDarkBackground:
                                                                                                          false,
                                                                                                      height: 44.w)),
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
                                                            itemBuilder: (context) {
                                                              return detailPostViewModel.comments[index].writerUid ==
                                                                      userModelRx.value!.uid
                                                                  ? commentMyShowMore
                                                                  : communityShowMore;
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          height: reducedPaddingWhenTextIsBothSide(
                                                              6.w, feedUserName.fontSize!, feedTitle.fontSize!)),
                                                      SizedBox(
                                                        height: 2.w,
                                                      ),
                                                      // Text(
                                                      //   (comments[index].isReply)
                                                      //       ? "@${comments[index].replyToUserName} " +
                                                      //           comments[index]
                                                      //               .content
                                                      //       : comments[index]
                                                      //           .content,
                                                      //   style: feedContent,
                                                      //   maxLines: 3,
                                                      //   overflow:
                                                      //       TextOverflow.ellipsis,
                                                      // ),
                                                      RichText(
                                                          text: TextSpan(
                                                              text: (detailPostViewModel.comments[index].isReply)
                                                                  ? "@${detailPostViewModel.comments[index].replyToUserName} "
                                                                  : "",
                                                              style: feedContent.copyWith(color: yachtViolet),
                                                              children: [
                                                            TextSpan(
                                                                text: detailPostViewModel.comments[index].content,
                                                                style: feedContent)
                                                          ]))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                        )
                      ],
                    ),
                  ),
                ),
                Obx(() => SizedBox(
                      height: bottomSpace.value,
                    ))
              ],
            ),
          ),

          // 답글 다는 곳

          CommentInput(
            post: detailPostViewModel.post,
            detailPostViewModel: detailPostViewModel,
            communityViewModel: communityViewModel,
            scrollController: _scrollController,
            bottomSpace: bottomSpace,
            // commentController: commentController,

            // commentFormKey: _commentFormKey,
          ),
        ]),
      ),
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

  // Dialog buildPhotoPageView(int index, List<String> imageUrls, DetailPostViewModel detailPostViewModel) {
  //   return Dialog(
  //     backgroundColor: Colors.transparent,
  //     clipBehavior: Clip.hardEdge,
  //     insetPadding: EdgeInsets.symmetric(horizontal: 0),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: ScreenUtil().screenWidth * .12,
  //           height: 200,
  //           // width: 20,
  //         ),
  //         Expanded(
  //           child: Container(
  //             // padding: EdgeInsets.symmetric(horizontal: 10.w),
  //             // width: double.infinity,
  //             child: ExpandablePageView.builder(
  //               controller: PageController(initialPage: index),
  //               itemCount: post.imageUrlList!.length,
  //               itemBuilder: (context, index) {
  //                 return Container(
  //                   padding: EdgeInsets.symmetric(horizontal: 8.w),
  //                   child: (imageUrls[index] == "")
  //                       ?
  //                       // image주소 로딩못했을 때만 퓨쳐빌더로
  //                       ClipRRect(
  //                           borderRadius: BorderRadius.circular(14.w),
  //                           child: Container(
  //                             width: ScreenUtil().screenWidth * .75,
  //                             child: CachedNetworkImage(
  //                               imageUrl:
  //                                   "https://storage.googleapis.com/ggook-5fb08.appspot.com/${detailPostViewModel.post.imageUrlList![index]}",
  //                               fit: BoxFit.fitWidth,
  //                             ),
  //                           ),
  //                         )
  //                       : ClipRRect(
  //                           borderRadius: BorderRadius.circular(14.w),
  //                           child: Container(
  //                             width: ScreenUtil().screenWidth * .75,
  //                             child: CachedNetworkImage(
  //                               imageUrl: imageUrls[index],
  //                               fit: BoxFit.fitWidth,
  //                             ),
  //                           ),
  //                         ),
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //         Container(
  //           width: ScreenUtil().screenWidth * .12,
  //           height: 200,
  //           // width: 20,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class CommentInput extends StatefulWidget {
  CommentInput({
    Key? key,
    required PostModel post,
    required DetailPostViewModel detailPostViewModel,
    required CommunityViewModel communityViewModel,
    required ScrollController scrollController,
    required RxDouble bottomSpace,
  })  : post = post,
        detailPostViewModel = detailPostViewModel,
        communityViewModel = communityViewModel,
        scrollController = scrollController,
        bottomSpace = bottomSpace,
        super(key: key);

  final DetailPostViewModel detailPostViewModel;
  final CommunityViewModel communityViewModel;
  final ScrollController scrollController;
  final RxDouble bottomSpace;
  final PostModel post;

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  late final FocusNode _focusNode;
  late final TextEditingController commentController;
  RxBool isFocused = false.obs;

  final renderManager = RenderParametersManager<dynamic>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {});
    _focusNode = FocusNode();
    commentController = TextEditingController();
    _focusNode.addListener(() {
      isFocused(_focusNode.hasFocus);
      if (_focusNode.hasFocus)
        // 코멘트 컨트롤러 값이 변하지 않아도 포커스 노드가 열려있을 때에도 댓글창 높이를 가져와야 하므로
        // 그런데 댓글창이 모두 커진 후에 받아와야 하기 때문에 WidgetsBinding을 해준다
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          widget.bottomSpace(renderManager.getRenderData('inputField')!.height);
        });
    });

    commentController.addListener(() {
      // child의 Render data를 id값으로 받아온다
      // height 값을 bottomSpace Rx값으로 넣어줘서 댓글창 높이에 따라
      // 아래 여백을 dynamic하게 바꿔준다
      // 코멘트 컨트롤러에 값이 변할 때마다
      widget.bottomSpace(renderManager.getRenderData('inputField')!.height);
    });

    // commentController.addListener(() {
    //   print('baseoffset: ${commentController.selection.baseOffset}');
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> commentFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // FocusScope.of(context).requestFocus(_focusNode);

    return Form(
      key: commentFormKey,
      child: Positioned(
        bottom: 0,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            // child의 Render data를 id값으로 받아온다
            child: RenderMetricsObject(
              id: 'inputField',
              manager: renderManager,
              child: Container(
                  // height: 76.w,
                  color: Colors.white.withOpacity(.50),
                  width: ScreenUtil().screenWidth,
                  child: Obx(
                    () => Padding(
                      padding: primaryHorizontalPadding.copyWith(
                          top: widget.detailPostViewModel.replyToUserName.value.length > 0 ? 0 : 14.w, bottom: 14.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          widget.detailPostViewModel.replyToUserName.value.length > 0
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 36.w + 4.w, vertical: 4.w),
                                      child: InkWell(
                                          onTap: () {
                                            widget.detailPostViewModel.replyToCommentId("");
                                            widget.detailPostViewModel.replyToUserUid("");
                                            widget.detailPostViewModel.replyToUserName("");
                                          },
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  ' ${widget.detailPostViewModel.replyToUserName.value} 님에게 답글',
                                                  style: feedContent.copyWith(color: yachtViolet, fontSize: 14.w),
                                                ),
                                                SizedBox(
                                                  width: 4.w,
                                                ),
                                                Image.asset(
                                                  'assets/icons/delete_in_textfield_outline.png',
                                                  width: 14.w,
                                                ),
                                                SizedBox(
                                                  width: 6.w,
                                                )
                                              ]))),
                                )
                              : Container(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: 36.w,
                                  height: 36.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${userModelRx.value!.avatarImage!}.png",
                                  )
                                  // child: CachedNetworkImage(
                                  //   imageUrl:
                                  //       "https://firebasestorage.googleapis.com/v0/b/ggook-5fb08.appspot.com/o/avatars%2F002.png?alt=media&token=68d48250-0831-4daa-b0c9-3f10608fb24c",
                                  // )
                                  ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Expanded(
                                child: Obx(
                                  () => Container(
                                    // height: isFocused.value ? 36.w : 36.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [primaryBoxShadow],
                                      borderRadius: BorderRadius.circular(5.w),
                                    ),
                                    // border: Border.all(width: 1, color: Colors.black)),
                                    child: TextFormField(
                                      focusNode: _focusNode,
                                      controller: commentController,
                                      validator: (value) {
                                        if (value!.length < 4) {
                                          return '4자 이상 글을 올려주세요.';
                                        } else {
                                          return null;
                                        }
                                      },
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                          // prefixIcon: widget.detailPostViewModel.replyToUserName.value.length > 0
                                          //     ? InkWell(
                                          //         onTap: () {
                                          //           widget.detailPostViewModel.replyToCommentId("");
                                          //           widget.detailPostViewModel.replyToUserUid("");
                                          //           widget.detailPostViewModel.replyToUserName("");
                                          //         },
                                          //         child: Row(
                                          //             mainAxisSize: MainAxisSize.min,
                                          //             crossAxisAlignment: CrossAxisAlignment.center,
                                          //             children: [
                                          //               Text(
                                          //                 ' @${widget.detailPostViewModel.replyToUserName.value}',
                                          //                 style: feedContent.copyWith(color: yachtViolet),
                                          //               ),
                                          //               SizedBox(
                                          //                 width: 4.w,
                                          //               ),
                                          //               Image.asset(
                                          //                 'assets/icons/delete_in_textfield.png',
                                          //                 width: 20.w,
                                          //               ),
                                          //               SizedBox(
                                          //                 width: 6.w,
                                          //               )
                                          //             ]))
                                          //     : Text(" "),
                                          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w),
                                          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                          hintText:
                                              // widget.detailPostViewModel.replyToUserName.value.length > 0
                                              //     ? ""
                                              //     :
                                              widget.detailPostViewModel.hintText.value,
                                          hintStyle: feedContent),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4.w,
                          ),
                          Obx(() => isFocused.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(height: 4.w),
                                    GestureDetector(
                                        onTap: () async {
                                          if (commentFormKey.currentState!.validate() &&
                                              !widget.detailPostViewModel.isUploadingNewPost.value) {
                                            _mixpanelService.mixpanel.track('Comment Upload', properties: {
                                              'New Comment Writer Uid': userModelRx.value!.uid,
                                              'New Comment Writer User Name': userModelRx.value!.userName,
                                              'Post Uid To Comment': widget.post.postId,
// 'Reply To UserName':,
// 'Reply To Uid':,
// 'Reply To Commnet Id':,
                                            });
                                            HapticFeedback.lightImpact();
                                            widget.detailPostViewModel.isUploadingNewPost(true);
                                            await widget.detailPostViewModel
                                                .uploadComment(widget.post, commentController.value.text);
                                            await widget.detailPostViewModel.getComments(widget.post);
                                            widget.scrollController
                                                .jumpTo(widget.scrollController.position.maxScrollExtent);
                                            commentController.clear();
                                            _focusNode.unfocus();
                                            await widget.communityViewModel.reloadPost();
                                            widget.detailPostViewModel.isUploadingNewPost(false);
                                          }
                                        },
                                        child: widget.detailPostViewModel.isUploadingNewPost.value
                                            ? simpleTextContainerButton("답글 달기",
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 1.4.w,
                                                  color: yachtViolet,
                                                ))
                                            : simpleTextContainerButton("답글 달기")),
                                  ],
                                )
                              : Container())
                        ],
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
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
    DetailPostViewModel detailPostViewModel = Get.put(DetailPostViewModel(post));
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
                          print("OKAY");
                          print(_contentController.value.text);
                          await _communityViewModel.editPost(post, _contentController.value.text);
                          await _communityViewModel.getPost();
                          await detailPostViewModel.getThisPost(post);
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
