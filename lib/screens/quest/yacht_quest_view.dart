import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../locator.dart';
import '../../repositories/repository.dart';
import '../../services/mixpanel_service.dart';
import '../../styles/style_constants.dart';
import '../../styles/yacht_design_system.dart';
import '../home/home_view_model.dart';
import 'new_live_quest_widget.dart';
import 'new_quest_widget.dart';
import 'new_result_quest_widget.dart';

class YachtQuestView extends StatelessWidget {
  final HomeViewModel homeViewModel;
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  YachtQuestView({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: primaryHorizontalPadding,
          // color: Colors.red,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  // color: Colors.blue,
                  child: Text("요트 퀘스트", style: sectionTitle.copyWith(height: 1.0))),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _mixpanelService.mixpanel.track('Jogabi Get');
                  if (userModelRx.value!.rewardedCnt! < maxRewardedAds) {
                    adsViewDialog(context);
                  } else {
                    maxRewardedAdsDialog(context);
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
                      decoration: jogabiButtonBoxDecoration.copyWith(boxShadow: [primaryBoxShadow]),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/jogabi.svg',
                            height: 24.w,
                            width: 24.w,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Obx(() {
                            // print("item changed");
                            return Text(
                              userModelRx.value == null ? 0.toString() : userModelRx.value!.item.toString(),
                              style: questTermTextStyle.copyWith(color: white, fontWeight: FontWeight.w600),
                            );
                          })
                        ],
                      ),
                    ),
                    Positioned(
                      right: -10.w,
                      top: -10.w,
                      child: Container(
                        padding: EdgeInsets.all(3.5.w),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                        height: 20.w,
                        width: 20.w,
                        child: SvgPicture.asset(
                          'assets/buttons/add.svg',
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              )
            ],
          ),
        ),
        SizedBox(
          height: heightSectionTitleAndBox,
        ),
        // btwHomeModuleTitleSlider,
        Obx(() {
          return Column(children: [
            (homeViewModel.newQuests.length == 0) // 로딩 중과 length 0인 걸 구분해야 함
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: primaryHorizontalPadding,
                        child: Container(
                          padding: primaryAllPadding,
                          width: double.infinity,
                          decoration: BoxDecoration(color: yachtDarkGrey, borderRadius: BorderRadius.circular(12.w)),
                          child: Center(
                            child: Text(
                              "참여 가능한 퀘스트가 없어요.",
                              style: TextStyle(
                                color: yachtLightGrey,
                                fontSize: 16.w,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: primaryPaddingSize),
                    ],
                  )
                : SizedBox.shrink(),
            ...List.generate(
                homeViewModel.newQuests.length,
                (index) => Column(
                      children: [
                        index == 0
                            ? SizedBox(
                                height: primaryPaddingSize,
                              )
                            : Container(),
                        InkWell(
                          onTap: () {
                            _mixpanelService.mixpanel.track('New Quest', properties: {
                              'New Quest ID': homeViewModel.newQuests[index].questId,
                              'New Quest League ID': homeViewModel.newQuests[index].leagueId,
                              'New Quest Title': homeViewModel.newQuests[index].title,
                              'New Quest Category': homeViewModel.newQuests[index].category,
                              'New Quest Select Mode': homeViewModel.newQuests[index].selectMode,
                            });
                            homeViewModel.newQuests[index].selectMode == 'survey'
                                ? Get.toNamed('/survey', arguments: homeViewModel.newQuests[index])
                                : homeViewModel.newQuests[index].selectMode == 'tutorial'
                                    ? Get.toNamed('/tutorial', arguments: homeViewModel.newQuests[index])
                                    : Get.toNamed('/quest', arguments: homeViewModel.newQuests[index]);
                          },
                          child: NewQuestWidget(
                            questModel: homeViewModel.newQuests[index],
                          ),
                        ),
                        SizedBox(height: primaryPaddingSize),
                      ],
                    )),
            ...List.generate(
                homeViewModel.liveQuests.length,
                // 1,
                (index) => Column(
                      children: [
                        // index == 0
                        //     ? SizedBox(
                        //         height: primaryPaddingSize,
                        //       )
                        //     : Container(),
                        InkWell(
                          onTap: () {
                            // _mixpanelService.mixpanel.track('Live Quest', properties: {
                            //   'New Quest ID': homeViewModel.newQuests[index].questId,
                            //   'New Quest League ID': homeViewModel.newQuests[index].leagueId,
                            //   'New Quest Title': homeViewModel.newQuests[index].title,
                            //   'New Quest Category': homeViewModel.newQuests[index].category,
                            //   'New Quest Select Mode': homeViewModel.newQuests[index].selectMode,
                            // });
                            // homeViewModel.newQuests[index].selectMode == 'survey'
                            //     ? Get.toNamed('/survey', arguments: homeViewModel.newQuests[index])
                            //     : homeViewModel.newQuests[index].selectMode == 'tutorial'
                            //         ? Get.toNamed('/tutorial', arguments: homeViewModel.newQuests[index])
                            //         : Get.toNamed('/quest', arguments: homeViewModel.newQuests[index]);
                          },
                          child: NewLiveQuestWidget(
                            questModel: homeViewModel.liveQuests[index],
                          ),
                        ),
                        SizedBox(height: primaryPaddingSize),
                      ],
                    )),
            ...List.generate(
                homeViewModel.resultQuests.length,
                (index) => Column(
                      children: [
                        // index == 0
                        //     ? SizedBox(
                        //         height: primaryPaddingSize,
                        //       )
                        //     : Container(),
                        NewResultQuestWidget(
                          questModel: homeViewModel.resultQuests[index],
                        ),

                        SizedBox(height: primaryPaddingSize),
                      ],
                    ))
          ]);
        })
      ],
    );
  }
}
