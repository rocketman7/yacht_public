import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/community/community_view.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import '../../locator.dart';
import 'detail_post_view.dart';

class FeedWidget extends StatelessWidget {
  final CommunityViewModel communityViewModel;
  final PostModel post;
  FeedWidget({Key? key, required this.communityViewModel, required this.post}) : super(key: key);

  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = List.generate(post.imageUrlList!.length, (index) => "");
    return Container(
      padding: moduleBoxPadding(feedDateTime.fontSize!),
      decoration: primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아바타 이미지 임시
          Container(
              width: 36.w,
              height: 36.w,
              child: CachedNetworkImage(
                imageUrl:
                    "https://firebasestorage.googleapis.com/v0/b/ggook-5fb08.appspot.com/o/avatars%2F002.png?alt=media&token=68d48250-0831-4daa-b0c9-3f10608fb24c",
              )),
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
                      post.writerUserName,
                      style: feedWriterName,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    simpleTierRRectBox(tier: "newbie"),
                    Spacer(),
                    PopupMenuButton(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(children: [
                        Text(
                          feedTimeHandler(post.writtenDateTime.toDate()),
                          // x초전, x분 전, 일정 이후면 날짜로
                          style: feedDateTime,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Container(
                          width: 14.w,
                          height: 16.w,
                          color: Colors.blue[50],
                          child: SvgPicture.asset('assets/icons/show_more.svg'),
                        ),
                      ]),
                      onSelected: (value) {
                        Get.bottomSheet(
                            EditingMyPost(
                              // contentFormKey: _contentFormKey,
                              // contentController: _contentController,
                              communityViewModel: communityViewModel,
                              post: post,
                            ),
                            isScrollControlled: true,
                            ignoreSafeArea: false, // add this
                            enterBottomSheetDuration: Duration(seconds: 3));
                      },
                      itemBuilder: (context) {
                        return post.writerUid == userModelRx.value!.uid ? communityMyShowMore : communityShowMore;
                      },
                    ),
                  ],
                ),
                SizedBox(height: reducedPaddingWhenTextIsBothSide(6.w, feedUserName.fontSize!, feedTitle.fontSize!)),
                post.title == null
                    ? Container()
                    : Text(
                        post.title!,
                        style: feedTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                SizedBox(
                  height: 2.w,
                ),
                InkWell(
                  onTap: () => Get.to(
                    () => DetailPostView(post),
                  ),
                  child: Text(
                    post.content,
                    style: feedContent,
                    maxLines: (post.imageUrlList == null || post.imageUrlList!.length == 0) ? 3 : 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 8.w,
                ),
                (post.imageUrlList == null || post.imageUrlList!.length == 0)
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            height: 140.w,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.imageUrlList!.length,
                                itemBuilder: (_, index) {
                                  return Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(5.w),
                                          child: FutureBuilder<String>(
                                              future: getImageUrlFromStorage(post.imageUrlList![index]),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return Container(
                                                    height: 140.w,
                                                    width: 140.w,
                                                    color: Colors.yellow,
                                                  );
                                                } else {
                                                  imageUrls[index] = snapshot.data!;
                                                  return InkWell(
                                                    onTap: () {
                                                      print(imageUrls);
                                                      Get.dialog(buildPhotoPageView(index, imageUrls));
                                                    },
                                                    child: CachedNetworkImage(
                                                      imageUrl: imageUrls[index],
                                                      height: 140.w,
                                                      width: 140.w,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  );
                                                }
                                              })),
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
                (post.hashTags == null || post.hashTags!.length == 0)
                    ? Container()
                    : Wrap(
                        spacing: 4.w,
                        runSpacing: 4.w,
                        children: List.generate(
                          post.hashTags!.length,
                          // 5,
                          (index) {
                            return feedHashTagContainer(post.hashTags![index]);
                          },
                        )),
                SizedBox(height: 14.w),
                Container(
                  // height: 30.w,
                  // color: Colors.yellow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () => Get.to(
                                () => DetailPostView(post),
                              ),
                              child: Container(
                                // color: Colors.blue,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SvgPicture.asset('assets/icons/comment.svg'),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Text(post.likedBy == null ? 0.toString() : post.commentedBy!.length.toString()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/likes.svg'),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(post.likedBy == null ? 0.toString() : post.likedBy!.length.toString()),
                              ],
                            ),
                          ),
                          Flexible(child: SvgPicture.asset('assets/icons/share.svg')),
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
    );
  }

  Dialog buildPhotoPageView(int index, List<String> imageUrls) {
    return Dialog(
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: [
          Container(
            width: ScreenUtil().screenWidth * .12,
            height: 200,
            // width: 20,
          ),
          Expanded(
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 10.w),
              // width: double.infinity,
              child: ExpandablePageView.builder(
                controller: PageController(initialPage: index),
                itemCount: post.imageUrlList!.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: (imageUrls[index] == "")
                        ?
                        // image주소 로딩못했을 때만 퓨쳐빌더로
                        FutureBuilder<String>(
                            future: getImageUrlFromStorage(post.imageUrlList![index]),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                  height: 140.w,
                                  width: 140.w,
                                  // color: Colors.yellow,
                                );
                              } else {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(14.w),
                                  child: Container(
                                    width: ScreenUtil().screenWidth * .75,
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                );
                              }
                            })
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(14.w),
                            child: Container(
                              width: ScreenUtil().screenWidth * .75,
                              child: CachedNetworkImage(
                                imageUrl: imageUrls[index],
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: ScreenUtil().screenWidth * .12,
            height: 200,
            // width: 20,
          ),
        ],
      ),
    );
  }

  Future<String> getImageUrlFromStorage(String imageUrl) async {
    return await _firebaseStorageService.downloadImageURL(imageUrl);
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
                          print("OKAY");
                          print(_contentController.value.text);
                          await _communityViewModel.editPost(post, _contentController.value.text);
                          await _communityViewModel.getPost();
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
