import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/quest/live/live_detail_view.dart';
import 'package:yachtOne/screens/quest/live/live_quest_view_model.dart';
import 'package:yachtOne/screens/quest/live/live_widget.dart';
import 'package:yachtOne/screens/quest/live/new_live_widget.dart';

import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

class LiveQuestView extends StatelessWidget {
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();

  @override
  Widget build(BuildContext context) {
    print("live quest view built");
    // print(homeViewModel.liveQuests);
    final LiveQuestViewModel liveQuestViewModel = Get.put(
      LiveQuestViewModel(
          // homeViewModel: homeViewModel,
          ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: primaryPaddingSize),
          // color: Colors.red,
          child: Text("퀘스트 생중계", style: sectionTitle),
        ),
        SizedBox(
          height: heightSectionTitleAndBox,
        ),
        Obx(() {
          // print(homeViewModel.liveQuests.length);
          if (!homeViewModel.isGettingQuests.value) {
            if (homeViewModel.liveQuests.length == 0) // 로딩 중과 length 0인 걸 구분해야 함
            {
              return Padding(
                padding: defaultHorizontalPadding,
                child: sectionBox(
                  width: 232.w,
                  height: 180.w,
                  child: Image.asset('assets/illusts/not_exists/no_live.png'),

                  // height: 340.w,
                ),
              );
            } else {
              // print("live quest view rebuilt");
              return SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(
                          homeViewModel.liveQuests.length,
                          // 1,
                          (index) => Row(
                                children: [
                                  index == 0
                                      ? SizedBox(
                                          width: defaultHorizontalPadding.left,
                                        )
                                      : Container(),
                                  NewLiveWidget(questModel: homeViewModel.liveQuests[index]),
                                  SizedBox(width: primaryPaddingSize),
                                ],
                              )

                          //     Row(
                          //   children: [
                          //     index == 0
                          //         ? SizedBox(
                          //             width: .left,
                          //           )
                          //         : Container(),
                          //     Obx(
                          //       () => liveQuestViewModel.isLiveLoading.value
                          //           ? Container(
                          //               // color: Colors.blue,
                          //               height: 100,
                          //               width: 100,
                          //             )
                          //           : LiveWidget(
                          //               questModel: homeViewModel.liveQuests[index],
                          //               liveQuestIndex: index,
                          //             ),
                          //     ),
                          //     SizedBox(width: widthHorizontalListView),
                          //   ],
                          // ),
                          ))

                  //     'user quest model length: ${userQuestModelRx == null}');

                  );
            }
          } else {
            return Container();
          }
        })
      ],
    );
  }
}
