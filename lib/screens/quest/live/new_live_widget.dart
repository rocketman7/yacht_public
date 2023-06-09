import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/quest/live/live_widget.dart';
import 'package:yachtOne/screens/quest/live/new_live_controller.dart';
import 'package:yachtOne/screens/quest/live/new_live_detail_view.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

class NewLiveWidget extends StatelessWidget {
  const NewLiveWidget({Key? key, required this.questModel}) : super(key: key);

  final QuestModel questModel;

  @override
  Widget build(BuildContext context) {
    final NewLiveController controller = Get.put(
      NewLiveController(questModel: questModel),
      tag: questModel.questId,
    );
    return GestureDetector(
      onTap: () {
        Get.to(
          () => NewLiveDetailView(
            questModel: questModel,
            controller: controller,
          ),
          // transition: Transition.downToUp,
        );
      },
      child: sectionBox(
          padding: defaultPaddingAll,
          width: 232.w,
          // height: 250.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LiveCardHeader(questModel: questModel),
              NewLiveHeader(questModel: questModel),

              Divider(
                thickness: 1.w,
                height: 20.w,
              ),
              (controller.questModel.selectMode == "pickone" || controller.questModel.selectMode == "order")
                  // "pickone" 이나 "order" 일 때
                  ? PickoneOrderLivePriceWidget(controller: controller)
                  // "updown 일 때"
                  : UpdownLivePriceWidget(controller: controller),
              Divider(
                height: 20.w,
                thickness: 1.w,
              ),
              QuestStatistics(controller: controller),
              SizedBox(
                height: 14.w,
              ),
              Container(
                width: double.infinity,
                height: 44.w,
                decoration: BoxDecoration(
                  color: yachtViolet,
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: Center(
                  child: Text(
                    "자세히 보기",
                    style: buttonTitleStyle.copyWith(height: 1.4),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class UpdownLivePriceWidget extends StatelessWidget {
  const UpdownLivePriceWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final NewLiveController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.investAddresses[controller.winnerIndex.value].name,
          style: stockPriceTextStyle.copyWith(
            fontSize: 18.w,
            fontWeight: FontWeight.w400,
          ),
        ),
        Obx(
          () => Text(
            toPriceKRW(
                controller.livePricesOfThisQuest[controller.winnerIndex.value].value.chartPrices.last.close ?? 0),
            style: stockPriceTextStyle.copyWith(
              fontSize: 22.w,
            ),
          ),
        ),
        // updown에 base price가 있는지 체크
        controller.questModel.investAddresses![controller.winnerIndex.value].basePrice == null
            ? Container()
            : Obx(
                () {
                  return Text(
                    controller.getPickoneByBasePrice()
                        ? '실시간 결과: ${controller.questModel.choices![0]}'
                        : '실시간 결과: ${controller.questModel.choices![1]}',
                  );
                },
              )
        // Text(controller.getPickoneByBasePrice().toString()),
        // Text(controller.questModel.investAddresses![0].basePrice.toString())
      ],
    );
  }
}

class PickoneOrderLivePriceWidget extends StatelessWidget {
  const PickoneOrderLivePriceWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final NewLiveController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      // "pickone || order 일 때"
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text("현재 1위", style: TextStyle(color: yachtGrey, fontSize: 12.w)),
        Obx(
          () => Text(
            controller.investAddresses[controller.winnerIndex.value].name,
            style: stockPriceTextStyle.copyWith(
              fontSize: 18.w,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Obx(
          () => Text(
            toPriceKRW(
                controller.livePricesOfThisQuest[controller.winnerIndex.value].value.chartPrices.last.close ?? 0),
            style: stockPriceTextStyle.copyWith(
              fontSize: 22.w,
            ),
          ),
        ),
        Obx(
          () => Text(
            '실시간 결과: ${controller.investAddresses[controller.winnerIndex.value].name}',
          ),
        )
        // Text(
        //   controller.livePricesOfThisQuest[controller.getWinnerIndex()].value.chartPrices.last.toString(),
        //   style: stockPriceTextStyle.copyWith(
        //     fontSize: 22.w,
        //   ),
        // ),
      ],
    );
  }
}

class QuestStatistics extends StatelessWidget {
  const QuestStatistics({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final NewLiveController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/manypeople.svg',
                  width: 17.w,
                  color: yachtWhite,
                ),
                SizedBox(width: 4.w),
                controller.questModel.counts == null
                    ? Text(
                        '0',
                        style: questRewardAmoutStyle.copyWith(fontSize: captionSize),
                      )
                    : Text(
                        '${controller.questModel.counts}',
                        // '${questModel.counts!.fold<int>(0, (previous, current) => previous + current)}',
                        style: questRewardAmoutStyle.copyWith(fontSize: captionSize),
                      ),
              ],
            ),
            Container(
                padding: EdgeInsets.fromLTRB(6.w, 2.w, 11.w, 2.w),
                decoration: BoxDecoration(
                  color: yachtDarkGrey,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                child: Obx(() => controller.isUserAlreadyDone.value
                    ? Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Text(
                            "나의 선택",
                            style: TextStyle(
                              fontSize: 14.w,
                              color: yachtWhite,
                            ),
                          ),
                          Positioned(
                            right: -5.w,
                            top: 2.w,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: yachtRed,
                              ),
                              width: 5.w,
                              height: 5.w,
                            ),
                          )
                        ],
                      )
                    : Text("참여 안함"))),
          ],
        ),
        SizedBox(
          height: 10.w,
        ),
        Row(
          children: List.generate(
              controller.questModel.choices!.length,
              (index) => Flexible(
                  flex: controller.questModel.choiceCounts == null ? 1 : controller.questModel.choiceCounts![index],
                  child: Container(
                    height: 12.w,
                    color: graphColors[index],
                  ))),
        ),
        SizedBox(
          height: 10.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              controller.questModel.choices!.length,
              (index) => Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.bottomCenter,
                            width: 14.w,
                            height: 14.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1.w),
                              color: graphColors[index],
                            ),
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Obx(
                            () => Stack(clipBehavior: Clip.none, children: [
                              Text(
                                controller.questModel.choices![index],
                                style: TextStyle(
                                  fontSize: 14.w,
                                  color: yachtLightGrey,
                                ),
                              ),
                              (controller.isUserAlreadyDone.value && controller.userQuestChoice[0] == index)
                                  ? Positioned(
                                      right: -5.w,
                                      top: 2.w,
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: yachtRed,
                                        ),
                                        width: 5.w,
                                        height: 5.w,
                                      ),
                                    )
                                  : Container(),
                            ]),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          controller.questModel.choiceCounts == null
                              ? Text(
                                  "0%",
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    color: yachtLightGrey,
                                  ),
                                )
                              : Text(
                                  toSimplePercentage(
                                      controller.questModel.choiceCounts![index] / controller.questModel.counts),
                                  style: TextStyle(
                                    fontSize: 14.w,
                                    color: yachtLightGrey,
                                  ),
                                ),
                        ],
                      )
                    ],
                  )),
        )
      ],
    );
  }
}

class NewLiveHeader extends StatelessWidget {
  const NewLiveHeader({
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
          maxLines: 1,
        ),
        Text(
          questModel.title,
          style: questTitleTextStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
