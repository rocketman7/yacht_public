import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';

import 'package:yachtOne/screens/quest/quest_view_model.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

class DecisionContainer extends StatefulWidget {
  final QuestViewModel questViewModel;
  const DecisionContainer(
    // Key? key,
    this.questViewModel,
  );

  @override
  _DecisionContainerState createState() => _DecisionContainerState();
}

class _DecisionContainerState extends State<DecisionContainer> {
  // final QuestViewModel questViewModel = widget.questViewModel;

  List<bool> isSelected = List.generate(
    2,
    (index) => false,
  );
  @override
  void initState() {
    super.initState();
  }

  double selectedOpaticy = 0.3;
  double unselectedOpacity = 0.1;

  @override
  Widget build(BuildContext context) {
    QuestModel questModel = widget.questViewModel.tempQuestModel;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(40),
                color: Color(0xFFA8C6D2).withOpacity(.7),
              ),
              width: SizeConfig.screenWidth - 50,
              height: getProportionateScreenHeight(140),
              child: GetBuilder<QuestViewModel>(
                builder: (questViewModel) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      questViewModel.tempQuestModel.title,
                      style: contentStyle.copyWith(
                          fontSize: getProportionateScreenHeight(18),
                          color: Colors.black87),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(2, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              isSelected[index] = !isSelected[index];
                              for (int i = 0; i < isSelected.length; i++) {
                                if (i != index) isSelected[i] = false;
                              }
                            });
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                child: Container(
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: 16, vertical: 8),
                                  // decoration: BoxDecoration(
                                  //   color: bullColorKR.withOpacity(
                                  //       isSelected[index]
                                  //           ? selectedOpaticy
                                  // : unselectedOpacity),
                                  // borderRadius: BorderRadius.circular(60),
                                  child: Image.asset(
                                    'assets/images/secLogo/hana.png',
                                    height: getProportionateScreenHeight(60),
                                    width: getProportionateScreenHeight(60),
                                  ),
                                ),
                              ),
                              verticalSpaceSmall,
                              Text(
                                "삼성전자",
                                style: subtitleStyle.copyWith(
                                    color: isSelected[index]
                                        ? bullColorKR
                                        : Colors.grey),
                              )
                            ],
                          ),
                        );
                      }),
                    ),
                    // InkWell(
                    //     onTap: () {
                    //       HapticFeedback.heavyImpact();
                    //     },
                    //     child: Text(
                    //       "예측 완료하기",
                    //       style: subtitleStyle.copyWith(
                    //           color: isSelected.contains(true)
                    //               ? contentStyle.color
                    //               : Colors.grey),
                    //     )),
                  ],
                ),
              ))),
    );
  }
}
