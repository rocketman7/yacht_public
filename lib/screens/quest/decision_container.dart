import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';

import 'package:yachtOne/screens/quest/quest_view_model.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

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

  double selectedOpaticy = 0;
  double unselectedOpacity = .5;

  @override
  Widget build(BuildContext context) {
    // QuestModel questModel = widget.questViewModel.tempQuestModel;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
              padding: kHorizontalPadding,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(40),
                color: Color(0xFFA8C6D2).withOpacity(.7),
              ),
              width: SizeConfig.screenWidth - 50,
              height: reactiveHeight(140),
              child: GetBuilder<QuestViewModel>(
                builder: (questViewModel) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AutoSizeText(
                      questViewModel.questModel.title,
                      style: contentStyle.copyWith(
                        fontSize: reactiveHeight(18),
                        color: Colors.black.withOpacity(.75),
                      ),
                      maxLines: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(questViewModel.questModel.investAddresses.length, (index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              isSelected[index] = !isSelected[index];
                              for (int i = 0; i < isSelected.length; i++) {
                                if (i != index) isSelected[i] = false;
                              }
                            });
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              HeroDialogRoute(
                                builder: (BuildContext context) {
                                  return FinalDecisionDialog(questViewModel: questViewModel, index: index);
                                },
                              ),
                            );
                            // Get.defaultDialog(
                            //     title: "TITlE",
                            //     content: Container(
                            //       child: Hero(
                            //         tag: "select",
                            //         child: Image.asset(
                            //           'assets/images/secLogo/hana.png',
                            //           height: getProportionateScreenHeight(60),
                            //           width: getProportionateScreenHeight(60),
                            //         ),
                            //       ),
                            //     ));
                          },
                          child: Column(
                            children: [
                              GetBuilder(
                                init: QuestViewModel(questViewModel.questModel),
                                builder: (_) => Container(
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: 16, vertical: 8),
                                  // decoration: BoxDecoration(
                                  //   color: bullColorKR.withOpacity(
                                  //       isSelected[index]
                                  //           ? selectedOpaticy
                                  // : unselectedOpacity),
                                  // borderRadius: BorderRadius.circular(60),
                                  child: Hero(
                                    tag: index.toString(),
                                    child: questViewModel.logoImage[index],
                                  ),
                                ),
                              ),
                              // ClipRRect(
                              //   borderRadius: BorderRadius.circular(60),
                              //   child: Container(
                              //     height: getProportionateScreenHeight(60),
                              //     width: getProportionateScreenHeight(60),
                              //     color: Colors.black.withOpacity(
                              //         isSelected[index]
                              //             ? selectedOpaticy
                              //             : unselectedOpacity),
                              //   ),
                              // ),

                              verticalSpaceSmall,
                              Hero(
                                tag: '${index}_name',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: AutoSizeText(
                                    questViewModel.questModel.choices == null
                                        ? questViewModel.questModel.investAddresses[index].name
                                        : "상승",
                                    style: subtitleStyle.copyWith(color: Colors.black.withOpacity(.75)
                                        // isSelected[index]
                                        // ? bullColorKR
                                        // : Colors.grey
                                        ),
                                  ),
                                ),
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

class FinalDecisionDialog extends StatelessWidget {
  final QuestViewModel questViewModel;
  final int index;
  const FinalDecisionDialog({
    Key? key,
    required this.index,
    required this.questViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      // title: Text('You are my hero.'),
      child: Container(
        padding: dialogPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        height: 200,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            AutoSizeText(
              questViewModel.questModel.selectInstruction,
              maxLines: 2,
              style: subtitleStyle.copyWith(fontWeight: FontWeight.w700, color: Colors.black.withOpacity(.7)),
            ),
            // verticalSpaceSmall,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: index.toString(),
                  child: questViewModel.logoImage[index],
                ),
                horizontalSpaceMedium,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: '${index}_name',
                      child: Material(
                        type: MaterialType.transparency,
                        child: AutoSizeText(
                          questViewModel.questModel.choices == null
                              ? questViewModel.questModel.investAddresses[index].name
                              : "상승",
                          style: subtitleStyle,
                        ),
                      ),
                    ),
                    verticalSpaceExtraSmall,
                    Text(
                      "선택을 확정하시겠어요?",
                      maxLines: 2,
                      style: contentStyle,
                    ),
                  ],
                )
              ],
            ),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: bullColorKR.withOpacity(.4),
                      ),
                      child: Center(
                        child: Text(
                          "취소",
                          style: confirmStyle.copyWith(color: Colors.white.withOpacity(.8)),
                        ),
                      )),
                ),
                horizontalSpaceMedium,
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: bullColorKR,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                offset: Offset(3, 3),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ]),
                      child: Center(
                        child: Text(
                          "확인",
                          style: confirmStyle.copyWith(color: Colors.white.withOpacity(.9)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),

      // Container(
      //   child: Hero(
      //     tag: index.toString(),
      //     child: Image.asset(
      //       'assets/images/secLogo/hana.png',
      //       height:
      //           getProportionateScreenHeight(
      //               60),
      //       width: getProportionateScreenHeight(
      //           60),
      //     ),
      //   ),
      // ),
      // actions: <Widget>[
      //   ElevatedButton(
      //     child: new Text('RAD!'),
      //     onPressed: Navigator.of(context).pop,
      //   ),
      // ],
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({required this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 550);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => null;
}
