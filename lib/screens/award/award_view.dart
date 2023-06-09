import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

import '../../locator.dart';
import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';
import '../../handlers/numbers_handler.dart' as NumbersHandler;

import 'award_detail_view.dart';
import 'award_view_model.dart';
import 'last_award_view.dart';

// 아래 TempHomeView에서
// 1. leagueName 인자 고려하고
// 2. ListView의 children을 합칠 Home에 복사하면 됨.
class AwardView extends StatelessWidget {
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final String leagueName;
  final String leagueEndDateTime;

  final AwardViewModel awardViewModel = Get.put(AwardViewModel());

  AwardView({required this.leagueName, required this.leagueEndDateTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: defaultHorizontalPadding,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("이 달의 상금 주식", style: sectionTitle),
              InkWell(
                onTap: () {
                  _mixpanelService.mixpanel.track('Award Question Mark');
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      // backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
                      // clipBehavior: C/lip.hardEdge,
                      child: yachtManual(context),
                    ),
                  );
                },
                child: Container(
                  width: 36.w,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/icons/question_mark.png',
                      width: 24.w,
                      height: 24.w,
                      color: yachtGrey,
                    ),
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _mixpanelService.mixpanel.track('Previous League');
                  Get.to(() => LastAwardView());
                },
                child: Container(
                  height: 30.w,
                  width: 116.w,
                  decoration: BoxDecoration(color: yachtViolet, borderRadius: BorderRadius.circular(117)),
                  child: Center(
                      child: Row(
                    children: [
                      Spacer(),
                      Text(
                        '지난 리그 보기',
                        style: lastLeagueButtonText,
                      ),
                      SizedBox(
                        width: 7.w,
                      ),
                      Container(width: 10.w, height: 14.w, child: Image.asset('assets/icons/right_arrow_white.png')),
                      Spacer(),
                    ],
                  )),
                ),
              )
            ],
          ),
        ),
        Container(
          // height: 188.w,
          child: GetBuilder<AwardViewModel>(
            // 여기서 init 을 해주니까 위에서 굳이 Get.put 안해줘도 됨
            // init: AwardViewModel(),
            builder: (controller) {
              if (controller.isAllSubLeaguesLoaded)
                return HomeSubLeagueCarouselSlider(leagueName: leagueName, leagueEndDateTime: leagueEndDateTime);
              else
                return Container(
                  height: 188.w,
                );
            },
          ),
        ),
      ],
    );
  }

  Stack yachtManual(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: defaultHorizontalPadding,
          width: double.infinity,
          height: ScreenUtil().screenHeight * .75,
          child: Column(
            children: [
              appBarWithCloseButton(title: "요트 설명서"),
              Expanded(
                child: ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: correctHeight(
                          24.w, yachtInstructionDialogTitle.fontSize, yachtInstructionDialogSubtitle.fontSize),
                    ),
                    Text("상금 주식이란?", style: yachtInstructionDialogSubtitle),
                    SizedBox(
                      height: correctHeight(
                          14.w, yachtInstructionDialogSubtitle.fontSize, yachtInstructionDialogDescription.fontSize),
                    ),
                    Text("제시된 목표에 도달하면 상금으로 지급되는 실제 주식을 말해요. 제시된 상금은 목표에 도달한 다른 사람들과 공평하게 나눠가지게 돼요.",
                        style: yachtInstructionDialogDescription),
                    SizedBox(
                      height: correctHeight(
                          40.w, yachtInstructionDialogSubtitle.fontSize, yachtInstructionDialogDescription.fontSize),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/won_circle.png',
                          width: 22.w,
                          height: 22.w,
                        ),
                        Text(" 주식 잔고가 무엇인가요?", style: yachtInstructionDialogSubtitle),
                      ],
                    ),
                    SizedBox(
                      height: correctHeight(
                          14.w, yachtInstructionDialogSubtitle.fontSize, yachtInstructionDialogDescription.fontSize),
                    ),
                    Text("상금으로 받은 주식들의 가치에요. 내 계좌로 출고하거나 친구에게 선물할 수 있어요.", style: yachtInstructionDialogDescription),
                    SizedBox(
                      height: correctHeight(
                          40.w, yachtInstructionDialogSubtitle.fontSize, yachtInstructionDialogDescription.fontSize),
                    ),
                    Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Image.asset(
                        'assets/icons/yacht_point_circle.png',
                        width: 22.w,
                        height: 22.w,
                      ),
                      Text(" 요트 포인트는 무엇인가요?", style: yachtInstructionDialogSubtitle),
                    ]),
                    SizedBox(
                      height: correctHeight(
                          14.w, yachtInstructionDialogSubtitle.fontSize, yachtInstructionDialogDescription.fontSize),
                    ),
                    Text(
                        "'요트포인트'는 향후 요트샵에서 주식 혹은 굿즈로 교환할 수 있어요. 퀘스트에 성공하거나 때에 따라서는 퀘스트 참여만으로도 획득할 수 있으니 많은 퀘스트에 참여해주세요.",
                        style: yachtInstructionDialogDescription),
                    SizedBox(
                      height: correctHeight(
                          40.w, yachtInstructionDialogSubtitle.fontSize, yachtInstructionDialogDescription.fontSize),
                    ),
                    Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Image.asset(
                        'assets/icons/league_point_circle.png',
                        width: 22.w,
                        height: 22.w,
                      ),
                      Text(" 리그 포인트는 무엇인가요?", style: yachtInstructionDialogSubtitle),
                    ]),
                    SizedBox(
                      height: correctHeight(
                          14.w, yachtInstructionDialogSubtitle.fontSize, yachtInstructionDialogDescription.fontSize),
                    ),
                    Text("월간 리그 순위의 기준이 되는 포인트에요. 퀘스트에 성공하면 얻을 수 있어요. 월간 리그가 종료되고 새로운 리그가 시작될 때 리그포인트는 초기화돼요.",
                        style: yachtInstructionDialogDescription),
                    SizedBox(
                      height: correctHeight(24.w, yachtInstructionDialogDescription.fontSize, 0.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 60.w,
              width: 60.w,
              color: Colors.transparent,
            ),
          ),
        )
      ],
    );
  }
}

class HomeSubLeagueCarouselSlider extends StatelessWidget {
  final String leagueName;
  final String leagueEndDateTime;
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  HomeSubLeagueCarouselSlider({required this.leagueName, required this.leagueEndDateTime});

  final AwardViewModel _awardViewModel = Get.find<AwardViewModel>();
  // final AwardViewModel _awardViewModel = Get.put(AwardViewModel());
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 188.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0.0.w,
            top: 0.0.w,
            child: Container(
              height: 188.w, //= 카드높이150.w + 위마진20.w + 아래마진10.w
              width: SizeConfig.screenWidth,
              // color: Colors.blue,
            ),
          ),
          Container(
            height: 188.w,
            child: CarouselSlider.builder(
              carouselController: _carouselController,
              itemCount: _awardViewModel.allSubLeagues.length,
              itemBuilder: (context, index, realIndex) {
                return Column(
                  children: [
                    SizedBox(
                      height: 20.0.w,
                      // color: Colors.yellow,
                    ),
                    GestureDetector(
                      onTap: () {
                        // 중앙에 있는 카드를 클릭하면 세부페이지로 가지만(if), 옆에 있는 카드를 클릭하면(else) 그 카드를 중앙에 위치시키는 애니메이션을 실행하는게 훨씬 자연스럽다.
                        if (index == _awardViewModel.pageIndexForHomeUI.value) {
                          // 이렇게 rx변수를 홈용 / 디테일페이지용으로 나누어 관리해야 애니메잇이 분리되는걸 막을 수 있음
                          _awardViewModel.pageIndexForUI.value = _awardViewModel.pageIndexForHomeUI.value;

                          // main에 등록한 getpage를 써야 바인딩 포함
                          // Get.toNamed('subLeague');
                          // print(leagueModel.value!.openLeague);
                          // print(leagueName);
                          // print('${_awardViewModel.allSubLeagues[index].name}');
                          _mixpanelService.mixpanel.track(
                            'Award Detail',
                            properties: {
                              'Award Detail League ID': leagueModel.value!.openLeague,
                              'Award Detail League Name': leagueName,
                              'Award Detail Sub League Name': '${_awardViewModel.allSubLeagues[index].name}',
                            },
                          );
                          Get.to(() => AwardDetailView(
                                leagueName: leagueName,
                                leagueEndDateTime: leagueEndDateTime,
                              ));
                        } else
                          _carouselController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.ease,
                          );
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  primaryBoxShadow,
                                ],
                                // color: _awardViewModel.colorIndex(index),
                                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                                  _awardViewModel.colorIndex(index, 0),
                                  _awardViewModel.colorIndex(index, 1),
                                  _awardViewModel.colorIndex(index, 0),
                                ])),
                            width: 275.0.w,
                            height: 158.w, // 뭔진 모르겠는데 자꾸 8픽셀이 오버플로우남..,
                          ),
                          Positioned(
                            top: 5.w,
                            left: 5.w,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  // color: Colors.white.withOpacity(0.7),
                                  gradient:
                                      LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
                                    Color(0xFFFDFEFF).withOpacity(0),
                                    Color(0xFFFDFEFF).withOpacity(1),
                                    Color(0xFFFDFEFF).withOpacity(0),
                                  ])),
                              width: 275.0.w - 10.w,
                              height: 148.w, // 뭔진 모르겠는데 자꾸 8픽셀이 오버플로우남..,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: yachtShadow,
                              //     blurRadius: 8.w,
                              //     spreadRadius: 1.w,
                              //   )
                              // ],
                            ),
                            // color: Colors.purple.withOpacity(.3),
                            width: 275.0.w,
                            height: 158.w,
                            // 뭔진 모르겠는데 자꾸 8픽셀이 오버플로우남..,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SizedBox(height: correctHeight(16.w, 0.w, awardModuleSliderTitleTextStyle.fontSize)),
                                Text(
                                  '${_awardViewModel.allSubLeagues[index].name}',
                                  style: awardModuleSliderTitleTextStyle,
                                ),
                                SizedBox(height: correctHeight(10.w, awardModuleSliderTitleTextStyle.fontSize, 0.w)),
                                Padding(
                                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                                  child: Container(
                                    height: 1.w,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF798AE6).withOpacity(0),
                                        Color(0xFF798AE6).withOpacity(0.5),
                                        Color(0xFF798AE6).withOpacity(0),
                                      ],
                                    )),
                                  ),
                                ),
                                SizedBox(height: correctHeight(8.w, 0.w, awardModuleSliderAmountTextStyle.fontSize)),
                                // //원인지 달러인지 등도 나중에는 구분해줘야할 듯
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    Image.asset('assets/icons/won_mark.png',
                                        height: 34.w, width: 34.w, color: yachtDarkGrey),
                                    SizedBox(width: 4.0.w),
                                    Text('${NumbersHandler.toPriceKRW(_awardViewModel.totalCurrentValue[index])}',
                                        style: awardModuleSliderAmountTextStyle),
                                    Spacer(),
                                  ],
                                ),
                                // SizedBox(
                                //     height: correctHeight(9.w, awardModuleSliderAmountTextStyle.fontSize,
                                //         awardModuleSliderAmountKoreanTextStyle.fontSize)),
                                Text(
                                  '상금 약 ${NumbersHandler.parseNumberKRWtoApproxiKorean(_awardViewModel.totalCurrentValue[index])}',
                                  style: awardModuleSliderAmountKoreanTextStyle.copyWith(
                                      color: awardModuleSliderAmountKoreanTextStyle.color!.withOpacity(0.3)),
                                ),
                                SizedBox(
                                    height: correctHeight(8.w, awardModuleSliderAmountKoreanTextStyle.fontSize, 0.w)),
                                Padding(
                                  padding: EdgeInsets.only(left: 12.w, right: 12.w),
                                  child: Container(
                                    height: 1.w,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Color(0xFF798AE6).withOpacity(0),
                                        Color(0xFF798AE6).withOpacity(0.5),
                                        Color(0xFF798AE6).withOpacity(0),
                                      ],
                                    )),
                                  ),
                                ),

                                SizedBox(
                                    height: correctHeight(10.w, 0.w, awardModuleSliderEndDateTimeTextStyle.fontSize)),
                                Text(
                                  leagueEndDateTime,
                                  style: awardModuleSliderEndDateTimeTextStyle.copyWith(
                                      color: awardModuleSliderEndDateTimeTextStyle.color!.withOpacity(0.5)),
                                ),
                                // Spacer(),
                                // SizedBox(
                                //     height: correctHeight(12.w, 0.w, awardModuleSliderEndDateTimeTextStyle.fontSize)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              options: CarouselOptions(
                  aspectRatio: SizeConfig.screenWidth /
                      188.w, // 이렇게하면 정확히 우리가 원하는 비율 나옴. 180 = 150 + 위마진20 + 아래마진10 + 8.w, // 뭔진 모르겠는데 자꾸 8픽셀이 오버플로우남..
                  disableCenter: true,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction:
                      275.w / SizeConfig.screenWidth, // 이렇게하면 screenWidth 중 정확히 275.w만큼 중앙의 캐러셀 슬라이드가 화면을 차지
                  onPageChanged: (index, _) {
                    _awardViewModel.pageIndexForHomeUI = index.obs;
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
