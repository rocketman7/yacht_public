import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/quest/live/live_widget.dart';
import 'package:yachtOne/screens/quest/live/new_live_controller.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class NewLiveWidget extends StatelessWidget {
  const NewLiveWidget({Key? key, required this.questModel}) : super(key: key);

  final QuestModel questModel;

  @override
  Widget build(BuildContext context) {
    final NewLiveController controller = Get.put(
      NewLiveController(questModel: questModel),
      tag: questModel.questId,
    );
    return sectionBox(
        padding: primaryAllPadding,
        width: 232.w,
        // height: 250.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LiveCardHeader(questModel: questModel),
            Column(
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
            ),

            Divider(
              thickness: 1.w,
              height: 20.w,
            ),
            (controller.questModel.selectMode == "pickone" || controller.questModel.selectMode == "order")
                ? Column(
                    // "pickone || order 일 때"
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("현재 1위", style: TextStyle(color: yachtGrey, fontSize: 12.w)),
                      Text(
                        controller.investAddresses[controller.winnerIndex.value].name,
                        style: stockPriceTextStyle.copyWith(
                          fontSize: 18.w,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Obx(
                        () => Text(
                          toPriceKRW(controller
                                  .livePricesOfThisQuest[controller.winnerIndex.value].value.chartPrices.last.close ??
                              0),
                          style: stockPriceTextStyle.copyWith(
                            fontSize: 22.w,
                          ),
                        ),
                      ),

                      // Text(
                      //   controller.livePricesOfThisQuest[controller.getWinnerIndex()].value.chartPrices.last.toString(),
                      //   style: stockPriceTextStyle.copyWith(
                      //     fontSize: 22.w,
                      //   ),
                      // ),
                    ],
                  )
                :
                // "updown 일 때"
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("현재 주가", style: TextStyle(color: yachtGrey, fontSize: 12.w)),
                      Text(
                        controller.investAddresses[controller.winnerIndex.value].name,
                        style: stockPriceTextStyle.copyWith(
                          fontSize: 18.w,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Obx(
                        () => Text(
                          toPriceKRW(controller
                                  .livePricesOfThisQuest[controller.winnerIndex.value].value.chartPrices.last.close ??
                              0),
                          style: stockPriceTextStyle.copyWith(
                            fontSize: 22.w,
                          ),
                        ),
                      ),
                      controller.questModel.investAddresses![controller.winnerIndex.value].basePrice == null
                          ? Container()
                          :
                          // Text(
                          //     toPriceKRW(
                          //         controller.questModel.investAddresses![controller.getWinnerIndex()].basePrice!),
                          //     style: stockPriceTextStyle.copyWith(
                          //       fontSize: 22.w,
                          //     ),
                          //   ),
                          Text(
                              controller.getPickoneByBasePrice()
                                  ? '실시간 결과: ${controller.questModel.choices![0]}'
                                  : '실시간 결과: ${controller.questModel.choices![1]}',
                            ),
                      // Text(controller.getPickoneByBasePrice().toString()),
                      // Text(controller.questModel.investAddresses![0].basePrice.toString())
                    ],
                  ),
            // Container(
            //   // height: 80.w,
            //   // color: Colors.blue,
            //   child: Obx(
            //     () => Column(
            //       children: List.generate(controller.investmentModelLength, (index) {
            //         return Text(
            //           controller.livePricesOfThisQuest[index].value.chartPrices.last.normalizedClose.toString(),
            //         );
            //       })

            //       // Text(controller.livePricesOfThisQuest[1].value.chartPrices.last.toString()),
            //       ,
            //     ),
            //   ),
            // ),
            // Text(controller.investAddresses[0].basePrice.toString()),

            Divider(
              height: 20.w,
              thickness: 1.w,
            ),
            Column(
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
                          color: yachtBlack,
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
                          color: yachtPaleGrey,
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                        child: Obx(() => controller.isUserAlreadyDone.value
                            ? Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Text("나의 선택"),
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
                          flex: controller.questModel.choiceCounts == null
                              ? 1
                              : controller.questModel.choiceCounts![index],
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
                                    width: 4.w,
                                  ),
                                  Obx(
                                    () => Stack(clipBehavior: Clip.none, children: [
                                      Text(
                                        controller.questModel.choices![index],
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
                                      ? Text("0%")
                                      : Text(toSimplePercentage(
                                          controller.questModel.choiceCounts![index] / controller.questModel.counts)),
                                ],
                              )
                            ],
                          )),
                )
              ],
            )
          ],
        ));
  }
}
