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

import '../../locator.dart';
import 'community_view_model.dart';
import 'detail_post_view_model.dart';

class DetailPostView extends GetView {
  final PostModel post;

  // DetailPostView({
  //   Key? key,
  // }) : super(key: key);

  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  DetailPostView(this.post);
  // final GlobalKey<FormState> _commentFormKey = GlobalKey<FormState>();
  // final _commentController = TextEditingController();

  // CommunityView에서 argument로 넘긴 PostModel을 바로 viewModel로 보냄.

  // CommunityViewModel communityViewModel = Get.put(CommunityViewModel());

  @override
  Widget build(BuildContext context) {
    DetailPostViewModel detailPostViewModel =
        Get.put(DetailPostViewModel(post));
    return Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: Colors.blue[50],
                ),
                SizedBox(height: 14.w),
                Padding(
                  padding: primaryHorizontalPadding,
                  child: Container(
                    decoration: primaryBoxDecoration
                        .copyWith(boxShadow: [primaryBoxShadow]),
                    child: Column(
                      children: [
                        Container(
                          padding: moduleBoxPadding(feedDateTime.fontSize!),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: yachtRed),
                                width: 36.w,
                                height: 36.w,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          detailPostViewModel
                                              .post.writerUserName,
                                          style: feedUserName,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Container(
                                          height: 16.w,
                                          width: 60.w,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFfce4a8),
                                              borderRadius:
                                                  BorderRadius.circular(20.w)),
                                        ),
                                        Spacer(),
                                        Text(
                                          feedTimeHandler(detailPostViewModel
                                              .post.writtenDateTime
                                              .toDate()),
                                          // x초전, x분 전, 일정 이후면 날짜로
                                          style: feedDateTime,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        SvgPicture.asset(
                                            'assets/icons/show_more.svg')
                                      ],
                                    ),
                                    SizedBox(
                                        height:
                                            reducedPaddingWhenTextIsBothSide(
                                                6.w,
                                                feedUserName.fontSize!,
                                                feedTitle.fontSize!)),
                                    detailPostViewModel.post.title == null
                                        ? Container()
                                        : Text(
                                            detailPostViewModel.post.title!,
                                            style: feedTitle,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    SizedBox(
                                      height: 6.w,
                                    ),
                                    Text(
                                      detailPostViewModel.post.content,
                                      style: feedContent,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    SizedBox(
                                      height: 10.w,
                                    ),
                                    (detailPostViewModel.post.imageUrlList ==
                                                null ||
                                            detailPostViewModel.post
                                                    .imageUrlList!.length ==
                                                0)
                                        ? Container()
                                        : Container(
                                            height: 140.w,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: detailPostViewModel
                                                    .post.imageUrlList!.length,
                                                itemBuilder: (_, index) {
                                                  return Row(
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.w),
                                                          child: FutureBuilder<
                                                                  String>(
                                                              future: getImageUrlFromStorage(
                                                                  detailPostViewModel
                                                                          .post
                                                                          .imageUrlList![
                                                                      index]),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (!snapshot
                                                                    .hasData) {
                                                                  return Container(
                                                                    height:
                                                                        140.w,
                                                                    width:
                                                                        140.w,
                                                                    color: Colors
                                                                        .yellow,
                                                                  );
                                                                } else {
                                                                  return Image
                                                                      .network(
                                                                    snapshot
                                                                        .data!,
                                                                    height:
                                                                        140.w,
                                                                    width:
                                                                        140.w,
                                                                    fit: BoxFit
                                                                        .cover,
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

                                    SizedBox(
                                      height: 10.w,
                                    ),
                                    feedHashTagContainer("#경제지식"),
                                    //hashTag 길이에 따라 dynamic하게
                                    SizedBox(
                                      height: 28.w,
                                    ),
                                    Container(
                                      // height: 30.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/icons/comment.svg'),
                                              SizedBox(
                                                width: 4.w,
                                              ),
                                              Text(detailPostViewModel
                                                          .post.likedBy ==
                                                      null
                                                  ? 0.toString()
                                                  : detailPostViewModel
                                                      .post.commentedBy!.length
                                                      .toString()),
                                              SvgPicture.asset(
                                                  'assets/icons/likes.svg'),
                                              Text(detailPostViewModel
                                                          .post.likedBy ==
                                                      null
                                                  ? 0.toString()
                                                  : detailPostViewModel
                                                      .post.likedBy!.length
                                                      .toString()),
                                              SvgPicture.asset(
                                                  'assets/icons/share.svg'),
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
                        FutureBuilder<List<CommentModel>>(
                            future: detailPostViewModel
                                .getComments(detailPostViewModel.post),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              } else {
                                if (snapshot.data!.length == 0) {
                                  return Container(
                                      // child: Text("댓글이 없습니다"),
                                      );
                                }
                                List<CommentModel> comments = snapshot.data!;
                                return ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: comments.length,
                                    itemBuilder: (_, index) {
                                      // 코멘트 컨테이너
                                      return InkWell(
                                        onTap: () {
                                          detailPostViewModel.mentionTo(
                                              "@${comments[index].writerUserName}");
                                          print(detailPostViewModel
                                              .mentionTo.value.length);
                                        },
                                        child: Container(
                                          color: Color(0xFFFCFCFC),
                                          padding: moduleBoxPadding(
                                              feedDateTime.fontSize!),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: yachtRed),
                                                width: 36.w,
                                                height: 36.w,
                                              ),
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          comments[index]
                                                              .writerUserName,
                                                          style: feedUserName,
                                                        ),
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        Container(
                                                          height: 16.w,
                                                          width: 60.w,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xFFfce4a8),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.w)),
                                                        ),
                                                        Spacer(),
                                                        Text(
                                                          feedTimeHandler(
                                                              comments[index]
                                                                  .writtenDateTime
                                                                  .toDate()),
                                                          // x초전, x분 전, 일정 이후면 날짜로
                                                          style: feedDateTime,
                                                        ),
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        SvgPicture.asset(
                                                            'assets/icons/show_more.svg')
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            reducedPaddingWhenTextIsBothSide(
                                                                6.w,
                                                                feedUserName
                                                                    .fontSize!,
                                                                feedTitle
                                                                    .fontSize!)),
                                                    SizedBox(
                                                      height: 6.w,
                                                    ),
                                                    Text(
                                                      comments[index].content,
                                                      style: feedContent,
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }
                            }),
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
                            onChanged: (value) {
                              // commentController.
                            },
                            decoration: InputDecoration(
                                prefixIcon: Text(
                                    '${widget.detailPostViewModel.mentionTo.value} '),
                                prefixIconConstraints:
                                    BoxConstraints(minWidth: 0, minHeight: 0),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14.w, vertical: 8.w),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                hintText: widget.detailPostViewModel.mentionTo
                                            .value.length >
                                        0
                                    ? ""
                                    : widget.detailPostViewModel.hintText.value,
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
                                  await widget.detailPostViewModel
                                      .uploadComment(widget.post,
                                          commentController.value.text);
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
