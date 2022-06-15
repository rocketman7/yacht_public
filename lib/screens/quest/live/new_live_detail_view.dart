import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/screens/quest/live/new_live_controller.dart';
import 'package:yachtOne/screens/quest/live/new_live_widget.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../quest_view.dart';

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    NewLiveDetailHeader(
                      questModel: questModel,
                    ),
                    Divider(
                      thickness: 1.w,
                      height: 20.w,
                      color: yachtGrey,
                    ),
                    QuestStatistics(
                      controller: controller,
                    ),
                    Divider(
                      thickness: 1.w,
                      height: 20.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                          controller.investmentModelLength,
                          (index) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.investAddresses[index].name,
                                    style: stockPriceTextStyle.copyWith(
                                      fontSize: 18.w,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      toPriceKRW(
                                          controller.livePricesOfThisQuest[index].value.chartPrices.last.close ?? 0),
                                      style: stockPriceTextStyle.copyWith(
                                        fontSize: 22.w,
                                      ),
                                    ),
                                  ),
                                  (index != controller.investmentModelLength - 1)
                                      ? Divider(
                                          height: 20.w,
                                        )
                                      : Container()
                                ],
                              )),
                    ),
                    SizedBox(
                      height: 40.w,
                    ),
                    QuestDescription(
                      questModel: questModel,
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    // (controller.questModel.selectMode == "pickone" || controller.questModel.selectMode == "order")
                    //     ? PickoneOrderLivePriceWidget(controller: controller)
                    //     :
                    //     // "updown 일 때"
                    //     UpdownLivePriceWidget(controller: controller),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 30.w,
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
            color: yachtLightGrey,
            fontSize: 14.w,
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
