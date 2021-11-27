import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/yacht_design_system.dart';
import 'profile_my_view.dart';
import 'profile_others_view.dart';

class QuestRecordDetailView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: newPrimaryAppBar('퀘스트 참여 기록'),
      body: ListView(
        children: [
          SizedBox(
            height: 14.w,
          ),
          QuestRecordView(
            isFullView: true,
          )
        ],
      ),
    );
  }
}

class QuestRecordOthersDetailView extends StatelessWidget {
  final String tag;

  QuestRecordOthersDetailView({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: newPrimaryAppBar('퀘스트 참여 기록'),
      body: ListView(
        children: [
          SizedBox(
            height: 14.w,
          ),
          QuestRecordOthersView(
            isFullView: true,
            tag: tag,
          )
        ],
      ),
    );
  }
}
