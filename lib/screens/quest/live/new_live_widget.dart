import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
          children: [
            LiveCardHeader(questModel: questModel),
            Divider(
              thickness: 1.w,
            ),
            Placeholder(
              fallbackHeight: 80.w,
              color: Colors.blue,
            ),
            Divider(
              thickness: 1.w,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("유저 예측 현황"),
                    Text("나의 선택"),
                  ],
                ),
                Container(
                  height: 24.w,
                  color: yachtDarkPurple,
                ),
                SizedBox(
                  height: 8.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      controller.investmentModelLength + 1,
                      (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 14.w,
                                    height: 14.w,
                                    color: Colors.lightBlue,
                                  ),
                                  SizedBox(
                                    width: 4.w,
                                  ),
                                  Text(
                                    controller.questModel.choices![index],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("14%"),
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
