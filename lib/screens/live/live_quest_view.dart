import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/live/live_quest_view_model.dart';
import 'package:yachtOne/screens/live/live_widget.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class LiveQuestView extends StatelessWidget {
  final HomeViewModel homeViewModel;

  LiveQuestView({Key? key, required this.homeViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("live quest view built");
    final LiveQuestViewModel liveQuestViewModel = Get.put(LiveQuestViewModel(homeViewModel: homeViewModel));

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
          return (homeViewModel.liveQuests.length == 0) // 로딩 중과 length 0인 걸 구분해야 함
              ? Container(
                  color: Colors.yellow,
                  // height: 340.w,
                )
              : SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(
                          homeViewModel.liveQuests.length,
                          (index) => Row(
                                children: [
                                  index == 0
                                      ? SizedBox(
                                          width: primaryHorizontalPadding.left,
                                        )
                                      : Container(),
                                  LiveWidget(
                                    liveQuestIndex: 0,
                                    questModel: homeViewModel.liveQuests[index],
                                  ),
                                  SizedBox(height: 24),
                                ],
                              )))

                  //     'user quest model length: ${userQuestModelRx == null}');

                  );
        })
      ],
    );
  }
}
