import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

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
  fontSize: 16.w,
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
      body: Stack(
        children: [
          CarouselSlider(
              items: [
                Container(
                  height: ScreenUtil().screenHeight,
                  child: Column(children: [
                    SizedBox(
                      height: screenRatio > 1.8 ? 108.w : 108.w,
                    ),
                    Container(
                      height: screenRatio > 1.8 ? 420.w : 420.w,
                      width: screenRatio > 1.8 ? 375.w : 375.w,
                      child: Image.asset(
                        screenRatio > 1.8
                            ? 'assets/illusts/onboarding/onboarding1.png'
                            : 'assets/illusts/onboarding/onboarding1.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: screenRatio > 1.8 ? 60.w : 60.w,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24.w,
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
                          width: 24.w,
                        ),
                        Text(
                          '유망한 종목을 예측하여 보상을 받으세요!',
                          style: onboardingSubTextStyle,
                        )
                      ],
                    ),
                  ]),
                ),
                Container(
                  height: ScreenUtil().screenHeight,
                  child: Column(children: [
                    SizedBox(
                      height: screenRatio > 1.8 ? 108.w : 108.w,
                    ),
                    Container(
                      height: screenRatio > 1.8 ? 420.w : 420.w,
                      width: screenRatio > 1.8 ? 375.w : 375.w,
                      child: Image.asset(
                        screenRatio > 1.8
                            ? 'assets/illusts/onboarding/onboarding2.png'
                            : 'assets/illusts/onboarding/onboarding2.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: screenRatio > 1.8 ? 60.w : 60.w,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24.w,
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
                          width: 24.w,
                        ),
                        Text(
                          '의견을 나누고, 정보를 얻을 수 있어요.',
                          style: onboardingSubTextStyle,
                        )
                      ],
                    ),
                  ]),
                ),
                Container(
                  height: ScreenUtil().screenHeight,
                  child: Column(children: [
                    SizedBox(
                      height: screenRatio > 1.8 ? 108.w : 70.w,
                    ),
                    Container(
                      height: screenRatio > 1.8 ? 420.w : 420.w,
                      width: screenRatio > 1.8 ? 375.w : 375.w,
                      child: Image.asset(
                        screenRatio > 1.8
                            ? 'assets/illusts/onboarding/onboarding3.png'
                            : 'assets/illusts/onboarding/onboarding3.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: screenRatio > 1.8 ? 60.w : 60.w,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 24.w,
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
                          width: 24.w,
                        ),
                        Text(
                          '단순 정보를 넘어 전문가의 인사이트를 공유해요.',
                          style: onboardingSubTextStyle,
                        )
                      ],
                    ),
                  ]),
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
                  autoPlayCurve: Curves.fastLinearToSlowEaseIn)),
          Positioned(
            top: ScreenUtil().screenHeight - 20.w - 60.w - ScreenUtil().bottomBarHeight / 2,
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w),
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
                  width: ScreenUtil().screenWidth - 24.w * 2,
                  child: Center(
                      child: Text(
                    '시작하기',
                    style: onboardingButtonTextStyle,
                  )),
                ),
              ),
            ),
          ),
          Positioned(
              top: ScreenUtil().statusBarHeight + 14.w,
              right: 14.w,
              child: Row(
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
                                  color: index == page.value ? Color(0xFF00FFB7) : white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6.w,
                            )
                          ],
                        )),
              ))
        ],
      ),
    );
  }
}
