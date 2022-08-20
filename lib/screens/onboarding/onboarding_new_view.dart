import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

import '../../locator.dart';
import '../../services/mixpanel_service.dart';
import '../auth/auth_check_view.dart';

final onboardingMainTextStyle = TextStyle(
  fontSize: 24.w,
  fontWeight: FontWeight.w500,
  fontFamily: 'NotoSansKR',
  color: Colors.white,
  letterSpacing: -0.5,
  height: 1.5,
);
final onboardingSubTextStyle = TextStyle(
  fontSize: 18.w,
  fontWeight: FontWeight.w500,
  fontFamily: 'NotoSansKR',
  color: Colors.white,
  letterSpacing: -0.5,
  height: 1.5,
);
final onboardingButtonTextStyle = TextStyle(
  fontSize: 18.w,
  fontWeight: FontWeight.w400,
  fontFamily: 'NotoSansKR',
  color: Colors.white,
  letterSpacing: 0.0,
  height: 1.1,
);

class NewOnboardingView extends StatefulWidget {
  const NewOnboardingView({Key? key}) : super(key: key);

  @override
  State<NewOnboardingView> createState() => _NewOnboardingViewState();
}

class _NewOnboardingViewState extends State<NewOnboardingView> {
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final RxInt page = 0.obs;
  @override
  Widget build(BuildContext context) {
    // carouselController.
    _mixpanelService.mixpanel.track('onboarding');
    double screenRatio = ScreenUtil().screenHeight / ScreenUtil().screenWidth;
    return Scaffold(
      backgroundColor: Color(0xFF101214),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: ScreenUtil().statusBarHeight + 14.w,
          ),
          Padding(
            padding: defaultHorizontalPadding,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: List.generate(
                  3,
                  (index) => Row(
                        children: [
                          Obx(
                            () => Container(
                              width: 8.w,
                              height: 8.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == page.value ? Color(0xFF00FFB7) : yachtWhite,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 6.w,
                          )
                        ],
                      )),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: ScreenUtil().screenWidth,
              child: CarouselSlider(
                  items: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   height: screenRatio > 1.8 ? 108.w : 108.w,
                        // ),
                        Container(
                          // color: Colors.white,
                          // height: screenRatio > 1.8 ? 420.w : 420.w,
                          // width: screenRatio > 1.8 ? 375.w : 375.w,
                          child: Image.asset(
                            screenRatio > 1.8
                                ? 'assets/illusts/onboarding/onboarding1.png'
                                : 'assets/illusts/onboarding/onboarding_mini_1.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        SizedBox(
                          height: 14.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 14.w,
                            ),
                            Text(
                              '흥미진진한\n주식 예측 퀘스트',
                              style: onboardingMainTextStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 14.w,
                            ),
                            Text(
                              '유망한 종목을 예측하고 \n보상을 받으세요!',
                              style: onboardingSubTextStyle,
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            screenRatio > 1.8
                                ? 'assets/illusts/onboarding/onboarding2.png'
                                : 'assets/illusts/onboarding/onboarding_mini_2.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(
                          height: 14.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 14.w,
                            ),
                            Text(
                              '주식에 대한 이야기를\n주고 받을 수 있는 커뮤니티',
                              style: onboardingMainTextStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 14.w,
                            ),
                            Text(
                              '의견을 나누고, \n정보를 얻을 수 있어요.',
                              style: onboardingSubTextStyle,
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Image.asset(
                            screenRatio > 1.8
                                ? 'assets/illusts/onboarding/onboarding3.png'
                                : 'assets/illusts/onboarding/onboarding_mini_3.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                        SizedBox(
                          height: 14.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 14.w,
                            ),
                            Text(
                              '전문가가 직접 발행하는\n금융 학습 컨텐츠',
                              style: onboardingMainTextStyle,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.w,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 14.w,
                            ),
                            Text(
                              '단순 정보를 넘어 \n전문가의 인사이트를 공유해요.',
                              maxLines: 2,
                              style: onboardingSubTextStyle,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                  options: CarouselOptions(
                    onPageChanged: (index, reason) {
                      page(index);
                    },
                    autoPlay: true,
                    viewportFraction: 1.0,
                    aspectRatio: ScreenUtil().screenWidth / ScreenUtil().screenHeight,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 500),
                    autoPlayCurve: Curves.fastLinearToSlowEaseIn,
                    pauseAutoPlayOnTouch: true,
                  )),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 14.w,
              right: 14.w,
              bottom: ScreenUtil().bottomBarHeight + 14.w,
            ),
            child: GestureDetector(
              onTap: () {
                GetStorage().write('hasSeenNewOnboarding', true);
                Get.off(() => AuthCheckView());
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  color: Color(0xFF4A2EFF),
                ),
                height: 60.w,
                // width: ScreenUtil().screenWidth - 24.w * 2,
                child: Center(
                    child: Text(
                  '시작하기',
                  style: onboardingButtonTextStyle.copyWith(
                    fontSize: 20.w,
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
