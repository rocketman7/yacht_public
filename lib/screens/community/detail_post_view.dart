import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/style_constants.dart';

import '../../locator.dart';

class DetailPostView extends StatelessWidget {
  final PostModel post;

  DetailPostView({Key? key, required this.post}) : super(key: key);

  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
  final GlobalKey<FormState> _commentFormKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
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
                                          post.writerUserName,
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
                                          feedTimeHandler(
                                              post.writtenDateTime.toDate()),
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
                                    post.title == null
                                        ? Container()
                                        : Text(
                                            post.title!,
                                            style: feedTitle,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    SizedBox(
                                      height: 6.w,
                                    ),
                                    Text(
                                      post.content,
                                      style: feedContent,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),

                                    SizedBox(
                                      height: 10.w,
                                    ),
                                    (post.imageUrlList == null ||
                                            post.imageUrlList!.length == 0)
                                        ? Container()
                                        : Container(
                                            height: 140.w,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount:
                                                    post.imageUrlList!.length,
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
                                                                  post.imageUrlList![
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
                                              Text(post.likedBy == null
                                                  ? 0.toString()
                                                  : post.commentedBy!.length
                                                      .toString()),
                                              SvgPicture.asset(
                                                  'assets/icons/likes.svg'),
                                              Text(post.likedBy == null
                                                  ? 0.toString()
                                                  : post.likedBy!.length
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
                        // if (post.commentedBy != null &&
                        //     post.commentedBy!.length > 0)
                        ...List.generate(50, (index) {
                          return Column(
                            children: [
                              Container(
                                height: 1,
                                width: double.infinity,
                                color: Colors.yellow,
                              ),
                              Container(
                                padding:
                                    moduleBoxPadding(feedDateTime.fontSize!),
                              )
                            ],
                          );
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
          Positioned(
            bottom: 0,
            child: Container(
              height: 76.w,
              width: ScreenUtil().screenWidth,
              child: Padding(
                padding: primaryHorizontalPadding,
                child: Row(
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
                      child: Container(
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [primaryBoxShadow],
                          borderRadius: BorderRadius.circular(5.w),
                        ),
                        // border: Border.all(width: 1, color: Colors.black)),
                        child: TextFormField(
                          onTap: () {
                            print("text field tapped");
                          },
                          controller: _commentController,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(14.w),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              hintText: '답글달기',
                              hintStyle: feedContent),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  Future<String> getImageUrlFromStorage(String imageUrl) async {
    return await _firebaseStorageService.downloadImageURL(imageUrl);
  }
}
