import 'package:flutter/material.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import 'community_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeWidget extends StatelessWidget {
  final CommunityViewModel communityViewModel;
  final PostModel post;
  NoticeWidget({Key? key, required this.communityViewModel, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return sectionBox(
        child: Container(
      padding: primaryAllPadding,
      width: double.infinity,
      // color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "[중요 공지]",
            style: feedWriterName.copyWith(color: yachtRed),
          ),
          SizedBox(
            height: correctHeight(10.w, feedWriterName.fontSize, feedWriterName.fontSize),
          ),
          Text(
            post.title ?? "",
            style: feedWriterName,
          ),
          Text(
            post.content,
            style: feedContent,
          ),
        ],
      ),
    ));
  }
}
