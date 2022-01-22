import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/screens/auth/auth_check_view.dart';
import 'package:yachtOne/screens/startup/startup_view.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({Key? key}) : super(key: key);

  final MixpanelService _mixpanelService = locator<MixpanelService>();
  List<PageViewModel> onboardingPages = [
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding001.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "주식게임 요트",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "나의 예측이 주식이 된다!\n요트에 대해 함께 알아볼까요?",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding002.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "예측 퀘스트",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "매일 제시되는 흥미진진한\n주식 예측 주제들!\n기업에 대해 공부하고\n예측에 참여하세요.",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding003.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "확실한 보상",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "월간 리그에 참여하고 주식받자!\n진짜 주식으로 교환가능한 요트 포인트,\n그리고 다양한 이벤트를 통한\n추가적인 보상까지!",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding004.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "양질의 커뮤니티",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "하고 싶은 이야기를 주고 받으며\n투자에 대한 시야를 함께 넓혀가요.\n그리고 ‘프로'들만 쓸 수 있는\n요트만의 진짜 프리미엄 컨텐츠!",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding005.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "재미있게 배우는 금융",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "검증된 정보와 금융 지식을\n재미있게 접해보세요!",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding006.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "요트에 탑승하세요!",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "이제 요트를 타고\n투자 항해를 시작해보세요.",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
  ];

  List<PageViewModel> onboardingWidePages = [
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding001_wide.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "주식게임 요트",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "나의 예측이 주식이 된다!\n요트에 대해 함께 알아볼까요?",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding002_wide.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "예측 퀘스트",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "매일 제시되는 흥미진진한\n주식 예측 주제들!\n기업에 대해 공부하고\n예측에 참여하세요.",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding003_wide.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "확실한 보상",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "월간 리그에 참여하고 주식받자!\n진짜 주식으로 교환가능한 요트 포인트,\n그리고 다양한 이벤트를 통한\n추가적인 보상까지!",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding004_wide.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "양질의 커뮤니티",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "하고 싶은 이야기를 주고 받으며\n투자에 대한 시야를 함께 넓혀가요.\n그리고 ‘프로'들만 쓸 수 있는\n요트만의 진짜 프리미엄 컨텐츠!",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding005_wide.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "재미있게 배우는 금융",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "검증된 정보와 금융 지식을\n재미있게 접해보세요!",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
    PageViewModel(
      titleWidget: Image.asset(
        'assets/illusts/onboarding/onboarding006_wide.png',
        fit: BoxFit.fitWidth,
      ),
      bodyWidget: Column(
        children: [
          Text(
            "요트에 탑승하세요!",
            style: onboardingTitle,
          ),
          SizedBox(
            height: correctHeight(
                20.w, onboardingTitle.fontSize, onboardingContent.fontSize),
          ),
          Text(
            "이제 요트를 타고\n투자 항해를 시작해보세요.",
            style: onboardingContent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      decoration: const PageDecoration(
        contentMargin: EdgeInsets.zero,
        bodyTextStyle: TextStyle(color: yachtRed),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    _mixpanelService.mixpanel.track('onboarding');
    double screenRatio = ScreenUtil().screenHeight / ScreenUtil().screenWidth;
    return IntroductionScreen(
      pages: screenRatio > 1.8 ? onboardingWidePages : onboardingPages,
      onDone: () {
        GetStorage().write('hasSeenOnboarding', true);
        Get.off(() => AuthCheckView());
      },
      showSkipButton: true,
      skip: Text(
        "넘어가기",
        style: skipOnboarding,
      ),
      done: Text(
        "항해 시작!",
        style: nextPage,
      ),
      next: Text(
        "다음",
        style: nextPage,
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: yachtRed,
        color: yachtGrey,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
