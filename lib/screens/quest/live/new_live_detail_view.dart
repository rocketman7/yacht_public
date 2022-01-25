import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/quest/live/new_live_controller.dart';
import 'package:yachtOne/screens/quest/live/new_live_widget.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class NewLiveDetailView extends StatelessWidget {
  const NewLiveDetailView({
    Key? key,
    required this.questModel,
    required this.controller,
  }) : super(key: key);
  final QuestModel questModel;
  final NewLiveController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: primaryBackgroundColor,
              pinned: true,
              title: Text(
                "퀘스트 생중계",
                style: appBarTitle,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: primaryAllPadding,
                child: sectionBox(
                  padding: primaryAllPadding,
                  child: Column(
                    children: [
                      NewLiveDetailHeader(
                        questModel: questModel,
                      ),
                      Divider(
                        thickness: 1.w,
                        height: 20.w,
                      ),
                      QuestStatistics(
                        controller: controller,
                      ),
                      Divider(
                        thickness: 1.w,
                        height: 20.w,
                      ),
                      Column(
                        children: [],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    ));
  }
}

class NewLiveDetailHeader extends StatelessWidget {
  const NewLiveDetailHeader({
    Key? key,
    required this.questModel,
  }) : super(key: key);

  final QuestModel questModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${dateTimeToStringShortened(questModel.liveStartDateTime)} ~ ${dateTimeToStringShortened(questModel.liveEndDateTime)}',
          style: TextStyle(
            color: yachtViolet,
            fontSize: 12.w,
          ),
          // maxLines: 1,
        ),
        Text(
          questModel.title,
          style: questTitleTextStyle,
          maxLines: 100,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
