import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';
import '../../handlers/numbers_handler.dart' as NumbersHandler;

import 'award_view_model.dart';

// 아래 TempHomeView에서
// 1. leagueName 인자 고려하고
// 2. ListView의 children을 합칠 Home에 복사하면 됨.
class AwardView extends StatelessWidget {
  final String leagueName;
  final String leagueEndDateTime;

  AwardView({required this.leagueName, required this.leagueEndDateTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: primaryHorizontalPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("이 달의 상금 주식", style: sectionTitle),
              InkWell(
                onTap: () {
                  Get.dialog(
                    Dialog(
                      // backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.all(16.w),
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        width: ScreenUtil().screenWidth * .12,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("요트 설명서"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 40.w,
                  // height: 30.w,
                  // color: Colors.blue,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      'assets/icons/question_mark.png',
                      width: 24.w,
                      height: 24.w,
                      color: yachtGrey,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        GetBuilder<AwardViewModel>(
          // 여기서 init 을 해주니까 위에서 굳이 Get.put 안해줘도 됨
          init: AwardViewModel(),
          builder: (controller) {
            return HomeSubLeagueCarouselSlider(leagueEndDateTime: leagueEndDateTime);
          },
        ),
      ],
    );
  }
}

class HomeSubLeagueCarouselSlider extends StatelessWidget {
  final String leagueEndDateTime;

  HomeSubLeagueCarouselSlider({required this.leagueEndDateTime});

  final AwardViewModel _awardViewModel = Get.put(AwardViewModel());
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0.0.w,
          top: 0.0.w,
          child: Container(
            height: 180.0.w, //= 카드높이150.w + 위마진20.w + 아래마진10.w
            width: SizeConfig.screenWidth,
            color: primaryBackgroundColor,
          ),
        ),
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: _awardViewModel.allSubLeagues.length,
          itemBuilder: (context, index, realIndex) {
            return Column(
              children: [
                SizedBox(
                  height: 20.0.w,
                ),
                GestureDetector(
                  onTap: () {
                    // 중앙에 있는 카드를 클릭하면 세부페이지로 가지만(if), 옆에 있는 카드를 클릭하면(else) 그 카드를 중앙에 위치시키는 애니메이션을 실행하는게 훨씬 자연스럽다.
                    if (index == _awardViewModel.pageIndexForHomeUI.value) {
                      // 이렇게 rx변수를 홈용 / 디테일페이지용으로 나누어 관리해야 애니메잇이 분리되는걸 막을 수 있음
                      _awardViewModel.pageIndexForUI.value = _awardViewModel.pageIndexForHomeUI.value;

                      // main에 등록한 getpage를 써야 바인딩 포함
                      Get.toNamed('subLeague');
                    } else
                      _carouselController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 450),
                        curve: Curves.ease,
                      );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        primaryBoxShadow,
                      ],
                      color: _awardViewModel.colorIndex(index),
                    ),
                    width: 275.0.w,
                    height: 150.0.w,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 9.0.w
                          // -
                          //     reducePaddingOneSide(
                          //         awardModuleSliderTitleTextStyle.fontSize!)
                          ,
                        ),
                        Text(
                          '${_awardViewModel.allSubLeagues[index].name}',
                          style: awardModuleSliderTitleTextStyle,
                        ),
                        SizedBox(
                          height: 13.0.w
                          // -
                          //     reducePaddingOneSide(
                          //         awardModuleSliderTitleTextStyle.fontSize!) -
                          //     reducePaddingOneSide(
                          //         awardModuleSliderAmountTextStyle.fontSize!)
                          ,
                        ),
                        //원인지 달러인지 등도 나중에는 구분해줘야할 듯
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Image.asset(
                              'assets/icons/won_mark.png',
                              height: 34.w,
                              width: 34.w,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5.0.w),
                            Text('${NumbersHandler.toPriceKRW(_awardViewModel.allSubLeagues[index].totalValue)}',
                                style: awardModuleSliderAmountTextStyle),
                            Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: 3.0.w,
                        ),
                        Text(
                          '상금 약 ${NumbersHandler.parseNumberKRWtoApproxiKorean(_awardViewModel.allSubLeagues[index].totalValue)}',
                          style: awardModuleSliderAmountKoreanTextStyle.copyWith(
                              color: awardModuleSliderAmountKoreanTextStyle.color!.withOpacity(0.3)),
                        ),
                        SizedBox(
                          height: 4.0.w,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 17.w,
                            ),
                            Flexible(
                              child: Container(
                                height: 1.w,
                                color: awardModuleSliderAmountKoreanTextStyle.color!.withOpacity(0.3),
                              ),
                            ),
                            Container(
                              width: 17.w,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 9.0.w - reducePaddingOneSide(awardModuleSliderEndDateTimeTextStyle.fontSize!),
                        ),
                        Text(
                          leagueEndDateTime,
                          style: awardModuleSliderEndDateTimeTextStyle,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          options: CarouselOptions(
              aspectRatio: SizeConfig.screenWidth / 180.w, // 이렇게하면 정확히 우리가 원하는 비율 나옴. 180 = 150 + 위마진20 + 아래마진10
              disableCenter: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              viewportFraction: 275.w / SizeConfig.screenWidth, // 이렇게하면 screenWidth 중 정확히 275.w만큼 중앙의 캐러셀 슬라이드가 화면을 차지
              onPageChanged: (index, _) {
                _awardViewModel.pageIndexForHomeUI = index.obs;
              }),
        ),
      ],
    );
  }
}

class HomeSubLeagueCarouselSliderForLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.w,
      width: SizeConfig.screenWidth,
      color: primaryBackgroundColor,
      child: Center(
          child: Text(
        '파도애니메이션? 여튼 기본 로딩 애니메이션 필요',
        style: awardModuleSliderTitleTextStyle.copyWith(color: primaryFontColor),
      )),
    );
  }
}
