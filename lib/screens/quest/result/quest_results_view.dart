import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';

import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/quest/result/quest_result_widget.dart';
import 'package:yachtOne/screens/quest/result/quest_results_view_model.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class QuestResultsView extends StatelessWidget {
  final HomeViewModel homeViewModel;
  QuestResultsView({Key? key, required this.homeViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: primaryHorizontalPadding,
          // color: Colors.red,
          child: Text("퀘스트 결과보기", style: sectionTitle),
        ),
        SizedBox(
          height: heightSectionTitleAndBox,
        ),
        Container(
          // color: Colors.amber.withOpacity(.3),
          // height: 340.w,
          child: Obx(() {
            return (homeViewModel.resultQuests.length == 0) // 로딩 중과 length 0인 걸 구분해야 함
                ? Padding(
                    padding: primaryHorizontalPadding,
                    child: sectionBox(
                      child: Container(
                          child: Image.asset(
                        'assets/illusts/not_exists/no_result.png',
                        width: 232.w,
                        height: 170.w,
                      )
                          // height: 340.w,
                          ),
                    ),
                  )
                : SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(
                      homeViewModel.resultQuests.length,
                      (index) => Row(
                        children: [
                          index == 0
                              ? SizedBox(
                                  width: kHorizontalPadding.left,
                                )
                              : Container(),
                          QuestResultWidget(context: context, questModel: homeViewModel.resultQuests[index]),
                          horizontalSpaceLarge
                        ],
                      ),
                    )),
                  );
          }),
        )
      ],
    );
  }
}
