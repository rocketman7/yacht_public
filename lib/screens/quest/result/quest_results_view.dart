import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/quest/result/quest_results_view_model.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestResultsView extends StatelessWidget {
  final HomeViewModel homeViewModel;
  QuestResultsView({Key? key, required this.homeViewModel}) : super(key: key);

  QuestResultsViewModel questResultsViewModel = Get.put(QuestResultsViewModel());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: primaryHorizontalPadding,
          // color: Colors.red,
          child: Text("퀘스트 결과보기", style: sectionTitle),
        ),
        SizedBox(
          height: heightSectionTitleAndBox,
        ),
        Container(
          // color: Colors.amber.withOpacity(.3),
          // height: 340.w,
          child: Obx(() {
            return (homeViewModel.resultQuests.length == 0) // 로딩 중과 length 0인 걸 구분해야 함
                ? Container(
                    child: Image.asset(
                    'assets/illusts/not_exists/no_result.png',
                    width: 232.w,
                    height: 170.w,
                  )
                    // height: 340.w,
                    )
                : SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(
                      homeViewModel.resultQuests.length,
                      (index) => Row(
                        children: [
                          index == 0
                              ? SizedBox(
                                  width: kHorizontalPadding.left,
                                )
                              : Container(),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
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
                                                              homeViewModel.resultQuests[index].category,
                                                              style: questTerm,
                                                            ),
                                                            SizedBox(
                                                                height: correctHeight(
                                                                    8.w, questTerm.fontSize, questTitle.fontSize)),
                                                            Text(
                                                              '${homeViewModel.resultQuests[index].title}',
                                                              style: questTitle,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Image.asset(
                                                        'assets/icons/quest_success.png',
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
                                                        Text(
                                                          "상승",
                                                          style: questTitle.copyWith(fontSize: 24.w),
                                                        ),
                                                        SizedBox(height: 14.w),
                                                        Text("결과", style: questTerm.copyWith(color: yachtViolet)),
                                                        Text(
                                                          homeViewModel.resultQuests[index].showResults(),
                                                          style:
                                                              questTitle.copyWith(fontSize: 24.w, color: yachtViolet),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: reducedPaddingWhenTextIsBelow(
                                                          30.w, smallSubtitleTextStyle.fontSize!)),
                                                  Text("퀘스트 성공 보상", style: questTitle),
                                                  SizedBox(
                                                    height: reducedPaddingWhenTextIsBothSide(
                                                        20.w, smallSubtitleTextStyle.fontSize!, 0),
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(children: [
                                                        Row(children: [
                                                          SvgPicture.asset(
                                                            'assets/icons/league_point.svg',
                                                            width: 27.w,
                                                            height: 27.w,
                                                          ),
                                                          SizedBox(
                                                            width: 6.w,
                                                          ),
                                                          Text("리그 포인트",
                                                              style: questTerm.copyWith(fontWeight: FontWeight.w500))
                                                        ])
                                                      ]),
                                                      SizedBox(
                                                        height: 14.w,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Image.asset(
                                                                'assets/icons/yacht_point_circle.png',
                                                                width: 27.w,
                                                                height: 27.w,
                                                              ),
                                                              SizedBox(
                                                                width: 6.w,
                                                              ),
                                                              Text("요트 포인트",
                                                                  style:
                                                                      questTerm.copyWith(fontWeight: FontWeight.w500)),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 14.w,
                                                      ),
                                                      Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              simpleTierRRectBox(
                                                                  exp: userModelRx.value!.exp, fontSize: 14.w),
                                                              Obx(() => Text(
                                                                  'exp testing ${userModelRx.value!.exp.toString()}',
                                                                  style: questRewardTextStyle)),
                                                            ],
                                                          ),
                                                          SizedBox(height: 6.w),
                                                          Container(
                                                            height: 14.w,
                                                            width: double.infinity,
                                                            decoration: BoxDecoration(
                                                              color: yachtViolet,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 14.w,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).pop();
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
                                      )));
                              // Get.defaultDialog(
                              //     title: '',
                              //     titleStyle:
                              //         TextStyle(fontSize: 0),
                              //     content: Container(
                              //       height: 40.w,
                              //       width: 40.w,
                              //       color: Colors.blue,
                              //     ));
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
                                          homeViewModel.resultQuests[index].category,
                                          style: subheadingStyle,
                                        ),
                                        SizedBox(height: 6.w),
                                        Text(
                                          '${homeViewModel.resultQuests[index].title}',
                                          style: sectionTitle,
                                        ),
                                        // Spacer(),
                                        Text(
                                          "01시간 24분 뒤 마감", // temp
                                          style: questTimerStyle,
                                        ),
                                        SizedBox(
                                          height: correctHeight(7.w, sectionTitle.fontSize, questTimerStyle.fontSize),
                                        ),
                                        SizedBox(
                                          height: correctHeight(
                                              10.w, questTimerStyle.fontSize, questRewardTextStyle.fontSize),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/manypeople.svg',
                                              width: 17.w,
                                              color: yachtBlack,
                                            ),
                                            SizedBox(width: 4.w),
                                            homeViewModel.resultQuests[index].counts == null
                                                ? Text(
                                                    '0',
                                                    style: questRewardAmoutStyle.copyWith(fontSize: captionSize),
                                                  )
                                                : Text(
                                                    '${homeViewModel.resultQuests[index].counts!.fold<int>(0, (previous, current) => previous + current)}',
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
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(12.w), bottomRight: Radius.circular(12.w))),
                                      child: Center(
                                        child: Text(
                                          "결과 확인",
                                          style: buttonTitleStyle,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          horizontalSpaceLarge
                        ],
                      ),
                    )),
                  );
          }),
        )
      ],
    );
  }
}
