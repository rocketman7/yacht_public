import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:yachtOne/screens/profile/profile_my_view.dart';
import 'package:yachtOne/screens/profile/profile_others_view.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:yachtOne/widgets/like_button.dart';
import 'package:yachtOne/widgets/loading_container.dart';
import '../../handlers/user_tier_handler.dart';
import '../../locator.dart';
import 'detail_post_view.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:extended_image/extended_image.dart';

class NewFeedWidget extends StatelessWidget {
  final CommunityViewModel communityViewModel;
  final PostModel post;

  NewFeedWidget({Key? key, required this.communityViewModel, required this.post}) : super(key: key);

  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  RxBool isTapping = false.obs;
  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = List.generate(post.imageUrlList!.length, (index) => "");
    return GestureDetector(
      // onTapCancel: () {
      //   print('tapcancel');
      //   isTapping(false);
      // },
      // onTapDown: (_) {
      //   print('tapdown');
      //   isTapping(true);
      // },
      // onTapUp: (_) {
      //   print('tapup');
      //   isTapping(false);
      //   Get.to(() => DetailPostView(post));
      // },
      child: Obx(() {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          // padding: moduleBoxPadding(feedDateTime.fontSize!),
          decoration: primaryBoxDecoration.copyWith(
              // boxShadow: [primaryBoxShadow],
              color: isTapping.value ? yachtGrey.withOpacity(.2) : primaryBoxDecoration.color),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: primaryHorizontalPadding,
                child: Container(
                  // color: Colors.amber[50],
                  child: FeedHeader(post: post),
                ),
              ),
              SizedBox(height: 4.w),
              (post.imageUrlList == null || post.imageUrlList!.length == 0)
                  ? Container()
                  : ImagePageView(
                      post: post,
                    ),
              SizedBox(height: 4.w),
              Padding(
                padding: primaryHorizontalPadding,
                child: Container(
                  // color: Colors.black12,
                  child: AutoSizeText(
                    post.content,
                    maxLines: 3,
                    // overflow: TextOverflow.,
                    overflowReplacement: Text(
                      post.content,
                      maxLines: 3,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.w),
              Padding(
                padding: primaryHorizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _mixpanelService.mixpanel.track('Post Like',
                                properties: {'Like Post ID': post.postId, 'Like Post From Page': "Community"});
                            HapticFeedback.lightImpact();
                            communityViewModel.toggleLikeComment(post);
                            communityViewModel.reloadPost();
                          },
                          child: Row(
                            children: [
                              LikeButton(
                                size: 20.w,
                                isLiked: post.likedBy == null ? false : post.likedBy!.contains(userModelRx.value!.uid),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/comment.svg',
                              color: yachtBlack,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 6.w),
                    Text(
                      "좋아요 ${post.likedBy == null ? 0 : post.likedBy!.length}개",
                      style: feedWriterName,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6.w),
              Padding(
                padding: primaryHorizontalPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${userModelRx.value!.avatarImage}.png",
                        )

                        // child: CachedNetworkImage(
                        //   imageUrl:
                        //       "https://firebasestorage.googleapis.com/v0/b/ggook-5fb08.appspot.com/o/avatars%2F002.png?alt=media&token=68d48250-0831-4daa-b0c9-3f10608fb24c",
                        // )
                        ),
                    SizedBox(width: 4.w),
                    Text(
                      "댓글 남기기",
                      style: feedContent.copyWith(
                        color: yachtGrey,
                        height: 1.2.w,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  // Future<String> getImageUrlFromStorage(String imageUrl) async {
  //   return await _firebaseStorageService.downloadImageURL(imageUrl);
  // }
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
        Container(
          height: 350.w,
          color: Colors.amber,
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
  }) : super(key: key);

  final PostModel post;

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
                      getTierByExp(post.writerExp ?? 0),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 18.w,
              // height: 30.w,
              color: Colors.transparent,
              child: SvgPicture.asset(
                'assets/icons/show_more.svg',
                color: yachtBlack,
              ),
            ),
            SizedBox(height: 4.w),
            Text(
              feedTimeHandler(post.writtenDateTime.toDate()),
              // x초전, x분 전, 일정 이후면 날짜로
              style: feedDateTime,
            ),
          ],
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
