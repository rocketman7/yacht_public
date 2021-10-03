import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/user_tier_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/quest/result/quest_results_view_model.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class QuestResultWidget extends StatelessWidget {
  final BuildContext context;
  final QuestModel questModel;

  QuestResultWidget({
    Key? key,
    required this.context,
    required this.questModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // QuestResultsViewModel questResultViewModel = Get.put(QuestResultsViewModel(questModel));

    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => ResultDialog(
                  questModel: questModel,
                ));
      },
      child: Container(
        height: 180.w,
        width: 232.w,
        decoration: primaryBoxDecoration.copyWith(
          boxShadow: [primaryBoxShadow],
          color: homeModuleBoxBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: moduleBoxPadding(questTermTextStyle.fontSize!),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // '${questModel.category} 퀘스트',
                    questModel.category,
                    style: subheadingStyle,
                  ),
                  SizedBox(height: 6.w),
                  Text(
                    '${questModel.title}',
                    style: sectionTitle,
                  ),
                  // Spacer(),
                  // Obx(
                  //   () => Text(
                  //     questResultViewModel.timeToEnd.value, // temp
                  //     style: questTimerStyle,
                  //   ),
                  // ),
                  SizedBox(
                    height: correctHeight(7.w, sectionTitle.fontSize, questTimerStyle.fontSize),
                  ),
                  SizedBox(
                    height: correctHeight(10.w, questTimerStyle.fontSize, questRewardTextStyle.fontSize),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/manypeople.svg',
                        width: 17.w,
                        color: yachtBlack,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '${questModel.counts}',
                        // '${questModel.counts!.fold<int>(0, (previous, current) => previous + current)}',
                        style: questRewardAmoutStyle.copyWith(fontSize: captionSize),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
                height: 40.w,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: yachtViolet,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(12.w), bottomRight: Radius.circular(12.w))),
                child: Center(
                  child: Text(
                    "결과 확인",
                    style: buttonTitleStyle,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ResultDialog extends StatefulWidget {
  const ResultDialog({
    Key? key,
    required this.questModel,
    this.otherUserQuestModel,
    this.otherUserExp,
    // required this.questResultViewModel,
  }) : super(key: key);

  final QuestModel questModel;
  final UserQuestModel? otherUserQuestModel;
  final int? otherUserExp;

  @override
  State<ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends State<ResultDialog> {
  @override
  void initState() {
    // print('init');
    super.initState();
  }

  @override
  void dispose() {
    // print('dispose');
    Get.delete<QuestResultsViewModel>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuestResultsViewModel questResultViewModel = Get.put(QuestResultsViewModel(
      questModel: widget.questModel,
      otherUserQuestModel: widget.otherUserQuestModel,
      otherUserExp: widget.otherUserExp,
    ));

    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.w),
        child: Container(
          // height: 400.w,
          decoration: primaryBoxDecoration.copyWith(
            color: homeModuleBoxBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: primaryHorizontalPadding,
                height: 60.w,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text("x"),
                    Flexible(child: Container()),
                    Center(
                      child: Text(
                        "퀘스트 결과보기",
                        style: dialogTitle,
                      ),
                    ),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          questResultViewModel.onClose();
                        },
                        child: Container(
                          // width: 25.w,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Image.asset(
                              'assets/buttons/close.png',
                              width: 16.w,
                              height: 16.w,
                            ),
                          ),
                        ),
                      ),
                    )
                    // Text("x"),
                  ],
                ),
              ),
              Container(
                padding: moduleBoxPadding(dialogTitle.fontSize!),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // '${questModel.category} 퀘스트',
                                widget.questModel.category,
                                style: questTerm,
                              ),
                              SizedBox(height: correctHeight(8.w, questTerm.fontSize, questTitle.fontSize)),
                              Text(
                                '${widget.questModel.title}',
                                style: questTitle,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Image.asset(
                          questResultViewModel.thisUserQuestModel.value == null
                              ? 'assets/icons/quest_not_joined.png'
                              : questResultViewModel.thisUserQuestModel.value!.hasSucceeded == null
                                  ? 'assets/icons/quest_waiting.png'
                                  : !questResultViewModel.thisUserQuestModel.value!.hasSucceeded!
                                      ? 'assets/icons/quest_failed.png'
                                      : 'assets/icons/quest_success.png',
                          width: 72.w,
                          height: 72.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment:
                        //     MainAxisAlignment
                        //         .spaceBetween,
                        children: [
                          Text("나의 선택", style: questTerm),
                          questResultViewModel.thisUserQuestModel.value == null
                              ? Text(
                                  "미참여",
                                  style: questTitle.copyWith(
                                    fontSize: 24.w,
                                    color: yachtGrey,
                                  ),
                                )
                              : Text(
                                  questResultViewModel.showUserSelection(
                                      questResultViewModel.thisUserQuestModel.value!, widget.questModel),
                                  style: questTitle.copyWith(
                                      fontSize: widget.questModel.selectMode == "order" ? 18.w : 24.w),
                                ),
                          SizedBox(height: 14.w),
                          Text("결과", style: questTerm.copyWith(color: yachtViolet)),
                          Text(
                            widget.questModel.showResults(),
                            style: questTitle.copyWith(fontSize: 24.w, color: yachtViolet),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: reducedPaddingWhenTextIsBelow(30.w, smallSubtitleTextStyle.fontSize!)),
                    Obx(
                      () => questResultViewModel.thisUserQuestModel.value != null
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 96,
                                  child: Column(
                                    children: [
                                      Container(
                                          width: double.infinity,
                                          height: 39.w,
                                          color: buttonNormal,
                                          child: Center(
                                            child: Text(
                                              "퀘스트 보상",
                                              style: questResultRewardTitle,
                                            ),
                                          )),
                                      Container(
                                          width: double.infinity,
                                          height: 39.w,
                                          // color: buttonNormal,
                                          child: Center(
                                            child: Text(
                                              "참여 보상",
                                              style: questResultRewardTitle.copyWith(
                                                fontFamily: krFont,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                      Container(
                                          width: double.infinity,
                                          height: 39.w,
                                          // color: buttonNormal,
                                          child: Center(
                                            child: Text(
                                              "성공 보상",
                                              style: questResultRewardTitle.copyWith(
                                                fontFamily: krFont,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Flexible(
                                  flex: 109,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 39.w,
                                        color: yachtYellowBackGround,
                                        child: SvgPicture.asset(
                                          'assets/icons/league_point.svg',
                                          width: 27.w,
                                          height: 27.w,
                                        ),
                                      ),
                                      Container(
                                          width: double.infinity,
                                          height: 39.w,
                                          // color: buttonNormal,
                                          child: Center(
                                            child: Text(
                                              "${questResultViewModel.thisUserQuestModel.value == null ? 0 : questResultViewModel.thisUserQuestModel.value!.leaguePointParticipationRewarded ?? "-"}",
                                              style: questResultRewardTitle.copyWith(
                                                  fontFamily: krFont, fontWeight: FontWeight.w500, color: yachtYellow),
                                            ),
                                          )),
                                      Container(
                                          width: double.infinity,
                                          height: 39.w,
                                          // color: buttonNormal,
                                          child: Center(
                                            child: Text(
                                              "${questResultViewModel.thisUserQuestModel.value == null ? 0 : questResultViewModel.thisUserQuestModel.value!.leaguePointSuccessRewarded ?? "-"}",
                                              style: questResultRewardTitle.copyWith(
                                                  fontFamily: krFont, fontWeight: FontWeight.w500, color: yachtYellow),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Flexible(
                                  flex: 109,
                                  child: Column(
                                    children: [
                                      Container(
                                        color: yachtGreenBackGround,
                                        width: double.infinity,
                                        height: 39.w,
                                        child: Image.asset(
                                          'assets/icons/yacht_point_circle.png',
                                          width: 27.w,
                                          height: 27.w,
                                        ),
                                      ),
                                      Container(
                                          width: double.infinity,
                                          height: 39.w,
                                          // color: buttonNormal,
                                          child: Center(
                                            child: Text(
                                              "${questResultViewModel.thisUserQuestModel.value == null ? 0 : questResultViewModel.thisUserQuestModel.value!.yachtPointParticipationRewarded ?? "-"}",
                                              style: questResultRewardTitle.copyWith(
                                                  fontFamily: krFont, fontWeight: FontWeight.w500, color: yachtGreen),
                                            ),
                                          )),
                                      Container(
                                          width: double.infinity,
                                          height: 39.w,
                                          // color: buttonNormal,
                                          child: Center(
                                            child: Text(
                                              "${questResultViewModel.thisUserQuestModel.value == null ? 0 : questResultViewModel.thisUserQuestModel.value!.yachtPointSuccessRewarded ?? "-"}",
                                              style: questResultRewardTitle.copyWith(
                                                  fontFamily: krFont, fontWeight: FontWeight.w500, color: yachtGreen),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                    SizedBox(
                      height: reducedPaddingWhenTextIsBothSide(20.w, smallSubtitleTextStyle.fontSize!, 0),
                    ),
                    Column(
                      children: [
                        // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        //   Row(children: [
                        //     SvgPicture.asset(
                        //       'assets/icons/league_point.svg',
                        //       width: 27.w,
                        //       height: 27.w,
                        //     ),
                        //     SizedBox(
                        //       width: 6.w,
                        //     ),
                        //     Text("리그 포인트", style: questTerm.copyWith(fontWeight: FontWeight.w500))
                        //   ]),
                        //   Text((questResultViewModel.thisUserQuestModel.value!.leaguePointRewarded ?? 0).toString()),
                        // ]),
                        // SizedBox(
                        //   height: 14.w,
                        // ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Image.asset(
                        //           'assets/icons/yacht_point_circle.png',
                        //           width: 27.w,
                        //           height: 27.w,
                        //         ),
                        //         SizedBox(
                        //           width: 6.w,
                        //         ),
                        //         Text("요트 포인트", style: questTerm.copyWith(fontWeight: FontWeight.w500)),
                        //       ],
                        //     ),
                        //     Row(
                        //       children: [
                        //         Text('(+${questResultViewModel.thisUserQuestModel.value!.yachtPointRewarded ?? 0})'),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // SizedBox(
                        //   height: 14.w,
                        // ),
                        Obx(() => questResultViewModel.thisUserQuestModel.value != null
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      simpleTierRRectBox(
                                          exp: widget.otherUserExp ?? userModelRx.value!.exp,
                                          fontSize: 14.w,
                                          width: 104.w),
                                      Obx(
                                        () => questResultViewModel.thisUserQuestModel.value != null
                                            ? Text(
                                                '경험치 보상 +${(questResultViewModel.thisUserQuestModel.value!.expSuccessRewarded ?? 0) + (questResultViewModel.thisUserQuestModel.value!.expParticipationRewarded ?? 0)}',
                                                style: questRewardTextStyle.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: yachtDarkGrey,
                                                ),
                                              )
                                            : Container(),
                                        //  Row(
                                        //   children: [
                                        //     questResultViewModel.thisUserQuestModel.value == null
                                        //         ? Text(
                                        //             '+0',
                                        //             style: questRewardTextStyle,
                                        //           )
                                        //         : Row(
                                        //             children: [
                                        //               Text(
                                        //                 '${userModelRx.value!.exp - (questResultViewModel.thisUserQuestModel.value!.expRewarded ?? 0)}',
                                        //                 style: questRewardTextStyle,
                                        //               ),
                                        //               Text(
                                        //                 '(+${questResultViewModel.thisUserQuestModel.value!.expRewarded.toString()}) ',
                                        //                 style: questRewardTextStyle.copyWith(
                                        //                   color: yachtViolet,
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //     Text(
                                        //       '/ ${getNextTierExp(userModelRx.value!.exp) - getBeforeTierExp(userModelRx.value!.exp)}',
                                        //       style: questRewardTextStyle,
                                        //     ),
                                        //   ],
                                        // ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6.w),
                                  Obx(() => questResultViewModel.thisUserQuestModel.value != null
                                      ? Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 14.w,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.w),
                                                color: yachtLine,
                                              ),
                                            ),
                                            Container(
                                              height: 12.w,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    flex: questResultViewModel.expBarAfterReward.value,
                                                    child: AnimatedContainer(
                                                      duration: Duration(seconds: 1),
                                                      width: double.infinity,
                                                      height: 12.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20.w),
                                                        color: yachtDarkGrey,
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                      flex: questResultViewModel.expBarEnd.value -
                                                          questResultViewModel.expBarAfterReward.value,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 12.w,
                                                      ))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              height: 12.w,
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                    flex: questResultViewModel.expBarBeforeReward.value,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 12.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20.w),
                                                        color: white,
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                      flex: questResultViewModel.expBarEnd.value -
                                                          questResultViewModel.expBarBeforeReward.value,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: 12.w,
                                                      ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container()),
                                ],
                              )
                            : Container()),
                        SizedBox(
                          height: 14.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            questResultViewModel.dispose();
                          },
                          child: textContainerButtonWithOptions(
                            text: "확인",
                            fontSize: 20.w,
                            isDarkBackground: true,
                            height: 50.w,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
