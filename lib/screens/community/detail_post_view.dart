import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/community/comment_model.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../locator.dart';
import 'community_view_model.dart';
import 'detail_post_view_model.dart';

class DetailPostView extends GetView {
  final PostModel post;

  // DetailPostView({
  //   Key? key,
  // }) : super(key: key);

  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  DetailPostView(this.post);
  // final GlobalKey<FormState> _commentFormKey = GlobalKey<FormState>();
  // final _commentController = TextEditingController();

  // CommunityView에서 argument로 넘긴 PostModel을 바로 viewModel로 보냄.

  // CommunityViewModel communityViewModel = Get.put(CommunityViewModel());

  @override
  Widget build(BuildContext context) {
    DetailPostViewModel detailPostViewModel = Get.put(DetailPostViewModel(post));
    List<String> imageUrls = List.generate(detailPostViewModel.post.imageUrlList!.length, (index) => "");
    return Scaffold(
      appBar: primaryAppBar("피드"),
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          SingleChildScrollView(
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
                              Container(
                                  width: 36.w,
                                  height: 36.w,
                                  child: CachedNetworkImage(
                                    imageUrl: "https://firebasestorage.googleapis.com/v0/b/ggook-5fb08.appspot.com/o/avatars%2F002.png?alt=media&token=68d48250-0831-4daa-b0c9-3f10608fb24c",
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
                                          detailPostViewModel.post.writerUserName,
                                          style: feedWriterName,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        // 티어 컨테이너
                                        simpleTierRRectBox(tier: "newbie"),
                                        Spacer(),
                                        Text(
                                          feedTimeHandler(detailPostViewModel.post.writtenDateTime.toDate()),
                                          // x초전, x분 전, 일정 이후면 날짜로
                                          style: feedDateTime,
                                        ),
                                        SizedBox(
                                          width: 8.w,
                                        ),
                                        SvgPicture.asset('assets/icons/show_more.svg')
                                      ],
                                    ),
                                    SizedBox(height: reducedPaddingWhenTextIsBothSide(6.w, feedUserName.fontSize!, feedTitle.fontSize!)),
                                    detailPostViewModel.post.title == null
                                        ? Container()
                                        : Text(
                                            detailPostViewModel.post.title!,
                                            style: feedTitle,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    SizedBox(
                                      height: 2.w,
                                    ),
                                    Text(
                                      detailPostViewModel.post.content,
                                      style: feedContent,
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    SizedBox(
                                      height: 8.w,
                                    ),
                                    (detailPostViewModel.post.imageUrlList == null || detailPostViewModel.post.imageUrlList!.length == 0)
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
                                                              child: FutureBuilder<String>(
                                                                  future: getImageUrlFromStorage(detailPostViewModel.post.imageUrlList![index]),
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
                                    (detailPostViewModel.post.hashTags == null || detailPostViewModel.post.hashTags!.length == 0)
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
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset('assets/icons/comment.svg'),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              Text(detailPostViewModel.post.likedBy == null ? 0.toString() : detailPostViewModel.post.commentedBy!.length.toString()),
                                              SvgPicture.asset('assets/icons/likes.svg'),
                                              Text(detailPostViewModel.post.likedBy == null ? 0.toString() : detailPostViewModel.post.likedBy!.length.toString()),
                                              SvgPicture.asset('assets/icons/share.svg'),
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
                                    return InkWell(
                                      onTap: () {
                                        detailPostViewModel.replyToCommentId("${detailPostViewModel.comments[index].commentId}");
                                        detailPostViewModel.replyToUserUid("${detailPostViewModel.comments[index].writerUid}");
                                        detailPostViewModel.replyToUserName("${detailPostViewModel.comments[index].writerUserName}");
                                      },
                                      child: Container(
                                        color: primaryBackgroundColor,
                                        padding: moduleBoxPadding(feedDateTime.fontSize!),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: 36.w,
                                                height: 36.w,
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://firebasestorage.googleapis.com/v0/b/ggook-5fb08.appspot.com/o/avatars%2F002.png?alt=media&token=68d48250-0831-4daa-b0c9-3f10608fb24c",
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
                                                        detailPostViewModel.comments[index].writerUserName,
                                                        style: feedWriterName,
                                                      ),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                      simpleTierRRectBox(tier: "newbie"),
                                                      Spacer(),
                                                      Text(
                                                        feedTimeHandler(detailPostViewModel.comments[index].writtenDateTime.toDate()),
                                                        // x초전, x분 전, 일정 이후면 날짜로
                                                        style: feedDateTime,
                                                      ),
                                                      SizedBox(
                                                        width: 8.w,
                                                      ),
                                                      SvgPicture.asset('assets/icons/show_more.svg')
                                                    ],
                                                  ),
                                                  SizedBox(height: reducedPaddingWhenTextIsBothSide(6.w, feedUserName.fontSize!, feedTitle.fontSize!)),
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
                                                          text: (detailPostViewModel.comments[index].isReply) ? "@${detailPostViewModel.comments[index].replyToUserName} " : "",
                                                          style: feedContent.copyWith(color: Colors.blue),
                                                          children: [TextSpan(text: detailPostViewModel.comments[index].content, style: feedContent)]))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 76.w,
                )
              ],
            ),
          ),
          // 답글 다는 곳

          CommentInput(
            post: detailPostViewModel.post,
            detailPostViewModel: detailPostViewModel,
            // commentController: commentController,

            // commentFormKey: _commentFormKey,
          )
        ]),
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

class CommentInput extends StatefulWidget {
  CommentInput({
    Key? key,
    required PostModel post,
    required DetailPostViewModel detailPostViewModel,
  })  : post = post,
        detailPostViewModel = detailPostViewModel,
        super(key: key);

  final DetailPostViewModel detailPostViewModel;
  final PostModel post;

  @override
  _CommentInputState createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  late final FocusNode _focusNode;
  late final TextEditingController commentController;
  RxBool isFocused = false.obs;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _focusNode = FocusNode();
    commentController = TextEditingController();
    _focusNode.addListener(() {
      isFocused(_focusNode.hasFocus);
      print(isFocused);
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
        child: Container(
          // height: 76.w,
          color: Colors.blue.withOpacity(.12),
          width: ScreenUtil().screenWidth,
          child: Padding(
            padding: primaryHorizontalPadding.copyWith(top: 14.w, bottom: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Container(
                      height: 36.w,
                      width: 36.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Expanded(
                      child: Obx(
                        () => Container(
                          height: isFocused.value ? 90.w : 36.w,
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
                            decoration: InputDecoration(
                                prefixIcon: widget.detailPostViewModel.replyToUserName.value.length > 0 ? Text('@${widget.detailPostViewModel.replyToUserName.value} ') : Text(" "),
                                prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                hintText: widget.detailPostViewModel.replyToUserName.value.length > 0 ? "" : widget.detailPostViewModel.hintText.value,
                                hintStyle: feedContent),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(() => isFocused.value
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 4.w),
                          GestureDetector(
                              onTap: () async {
                                if (commentFormKey.currentState!.validate()) {
                                  await widget.detailPostViewModel.uploadComment(widget.post, commentController.value.text);
                                  await widget.detailPostViewModel.getComments(widget.post);
                                  commentController.clear();
                                  _focusNode.unfocus();
                                }
                              },
                              child: Text("답글 달기")),
                        ],
                      )
                    : Container())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
