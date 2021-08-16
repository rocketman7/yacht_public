import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../locator.dart';
import 'detail_post_view.dart';

class FeedWidget extends StatelessWidget {
  final CommunityViewModel communityViewModel;
  final PostModel post;
  FeedWidget({Key? key, required this.communityViewModel, required this.post})
      : super(key: key);

  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(
        () => DetailPostView(post),
      ),
      child: Container(
        padding: moduleBoxPadding(feedDateTime.fontSize!),
        decoration:
            primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: yachtRed),
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                            borderRadius: BorderRadius.circular(20.w)),
                      ),
                      Spacer(),
                      Text(
                        feedTimeHandler(post.writtenDateTime.toDate()),
                        // x초전, x분 전, 일정 이후면 날짜로
                        style: feedDateTime,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      SvgPicture.asset('assets/icons/show_more.svg')
                    ],
                  ),
                  SizedBox(
                      height: reducedPaddingWhenTextIsBothSide(
                          6.w, feedUserName.fontSize!, feedTitle.fontSize!)),
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
                  (post.imageUrlList == null || post.imageUrlList!.length == 0)
                      ? Container()
                      : Container(
                          height: 140.w,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: post.imageUrlList!.length,
                              itemBuilder: (_, index) {
                                return Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.w),
                                        child: FutureBuilder<String>(
                                            future: getImageUrlFromStorage(
                                                post.imageUrlList![index]),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container(
                                                  height: 140.w,
                                                  width: 140.w,
                                                  color: Colors.yellow,
                                                );
                                              } else {
                                                return Image.network(
                                                  snapshot.data!,
                                                  height: 140.w,
                                                  width: 140.w,
                                                  fit: BoxFit.cover,
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
                  SizedBox(height: 28.w),
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
                            Text(post.likedBy == null
                                ? 0.toString()
                                : post.commentedBy!.length.toString()),
                            SvgPicture.asset('assets/icons/likes.svg'),
                            Text(post.likedBy == null
                                ? 0.toString()
                                : post.likedBy!.length.toString()),
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
    );
  }

  Future<String> getImageUrlFromStorage(String imageUrl) async {
    return await _firebaseStorageService.downloadImageURL(imageUrl);
  }
}
