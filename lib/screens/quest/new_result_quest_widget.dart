import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/screens/quest/result/quest_results_view_model.dart';
import 'package:yachtOne/screens/quest/time_counter_widget.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';
import '../../models/quest_model.dart';
import '../../styles/yacht_design_system.dart';
import 'new_quest_widget.dart';

class NewResultQuestWidget extends StatelessWidget {
  NewResultQuestWidget({Key? key, required this.questModel}) : super(key: key);
  final QuestModel questModel;
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    final QuestResultsViewModel questResultViewModel =
        Get.put(QuestResultsViewModel(questModel: questModel), tag: questModel.questId);
    return InkWell(
      onTap: () {
        _mixpanelService.mixpanel.track('Quest Result', properties: {
          'New Quest ID': questModel.questId,
          'New Quest League ID': questModel.leagueId,
          'New Quest Title': questModel.title,
          'New Quest Category': questModel.category,
          'New Quest Select Mode': questModel.selectMode,
        });
        showDialog(context: context, builder: (context) => NewResultDialog(questModel: questModel));
      },
      child: Padding(
        padding: defaultHorizontalPadding,
        child: Container(
          padding: defaultPaddingAll,
          decoration: BoxDecoration(color: yachtDarkGrey, borderRadius: BorderRadius.circular(12.w)),
          width: double.infinity,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    basicInfoButtion(
                      "결과 발표",
                      buttonColor: yachtGrey,
                      textColor: yachtWhite,
                    ),
                    SizedBox(width: 6.w),
                    // basicInfoButtion(
                    //   "참여마감",
                    //   buttonColor: yachtGrey,
                    //   textColor: yachtLightGrey,
                    // ),
                    // SizedBox(width: 4.w),
                    // basicInfoButtion(
                    //   "",
                    //   child: TimeCounterWidget(
                    //     questModel: questModel,
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.w),
            Text(
              '${questModel.title}',
              style: TextStyle(
                color: yachtWhite,
                fontSize: 18.w,
              ),
            ),
            SizedBox(height: 8.w),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/manypeople.svg',
                  width: 17.w,
                  color: yachtWhite,
                ),
                SizedBox(width: 4.w),
                questModel.counts == null
                    ? Text(
                        '0',
                        style: questRewardAmoutStyle.copyWith(fontSize: captionSize),
                      )
                    : Text(
                        '${questModel.counts}',
                        // '${questModel.counts!.fold<int>(0, (previous, current) => previous + current)}',
                        style: questRewardAmoutStyle.copyWith(fontSize: captionSize),
                      )
              ],
            ),
            SizedBox(height: 8.w),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '나의 예측',
                        style: questTitle.copyWith(
                          fontSize: 14.w,
                          color: yachtLightGrey,
                        ),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      questResultViewModel.thisUserQuestModel.value == null
                          ? Text(
                              "미참여",
                              style: questTitle.copyWith(
                                fontSize: 20.w,
                                color: yachtWhite,
                              ),
                            )
                          : Text(
                              questResultViewModel.showUserSelection(
                                  questResultViewModel.thisUserQuestModel.value!, questModel),
                              style: questTitle.copyWith(
                                fontSize: 20.w,
                                color: yachtWhite,
                              ),
                            ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '결과',
                        style: questTitle.copyWith(
                          fontSize: 14.w,
                          color: yachtLightGrey,
                        ),
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                      Text(
                        questResultViewModel.thisUserQuestModel.value == null
                            ? questModel.showResults()
                            : questResultViewModel.thisUserQuestModel.value!.hasSucceeded == null
                                ? "결과 대기 중"
                                : !questResultViewModel.thisUserQuestModel.value!.hasSucceeded!
                                    ? "예측 실패"
                                    : "예측 성공!",
                        style: questTitle.copyWith(
                          fontSize: 20.w,
                          color: questResultViewModel.thisUserQuestModel.value == null
                              ? white
                              : questResultViewModel.thisUserQuestModel.value!.hasSucceeded == null
                                  ? yachtMidGrey
                                  : !questResultViewModel.thisUserQuestModel.value!.hasSucceeded!
                                      ? yachtMidGrey
                                      : yachtRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}

class NewResultDialog extends StatelessWidget {
  const NewResultDialog({Key? key, required this.questModel}) : super(key: key);
  final QuestModel questModel;
  @override
  Widget build(BuildContext context) {
    QuestResultsViewModel questResultViewModel = Get.put(
        QuestResultsViewModel(
          questModel: questModel,
        ),
        tag: questModel.questId);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16.w),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          color: yachtDarkGrey,
        ),
        padding: defaultPaddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Flexible(child: Container()),
                Text(
                  "퀘스트 결과보기",
                  style: dialogTitle.copyWith(color: yachtWhite),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      // width: 25.w,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          'assets/buttons/close.png',
                          width: 12.w,
                          height: 12.w,
                          color: yachtWhite,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 14.w),
            NewQuestHeader(
              questModel: questModel,
              actionButton: false,
            ),
            SizedBox(height: 14.w),
            Container(
              padding: defaultPaddingAll,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.w),
                color: yachtGrey,
              ),
              child: Column(children: [
                Text(
                  "나의 선택",
                  style: TextStyle(
                    color: yachtLightGrey,
                  ),
                ),
                SizedBox(
                  height: 8.w,
                ),
                questResultViewModel.thisUserQuestModel.value == null
                    ? Text(
                        "미참여",
                        style: questTitle.copyWith(
                          fontSize: 24.w,
                          color: yachtWhite,
                        ),
                      )
                    : Text(
                        questResultViewModel.showUserSelection(
                            questResultViewModel.thisUserQuestModel.value!, questModel),
                        style: questTitle.copyWith(
                          color: yachtWhite,
                          fontSize: questModel.selectMode == "order" ? 18.w : 24.w,
                        ),
                      )
              ]),
            ),
            SizedBox(height: 4.w),
            Container(
              padding: defaultPaddingAll,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.w),
                color: yachtGrey,
              ),
              child: Column(children: [
                Text(
                  "결과",
                  style: TextStyle(
                    color: yachtLightGrey,
                  ),
                ),
                SizedBox(
                  height: 8.w,
                ),
                Text(
                  questResultViewModel.thisUserQuestModel.value == null
                      ? questModel.showResults()
                      : questResultViewModel.thisUserQuestModel.value!.hasSucceeded == null
                          ? "결과 대기 중"
                          : !questResultViewModel.thisUserQuestModel.value!.hasSucceeded!
                              ? "예측 실패"
                              : "예측 성공!",
                  style: questTitle.copyWith(
                    fontSize: 20.w,
                    color: questResultViewModel.thisUserQuestModel.value == null
                        ? white
                        : questResultViewModel.thisUserQuestModel.value!.hasSucceeded == null
                            ? yachtMidGrey
                            : !questResultViewModel.thisUserQuestModel.value!.hasSucceeded!
                                ? yachtMidGrey
                                : yachtRed,
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
