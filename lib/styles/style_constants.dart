import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/widgets/appbar_back_button.dart';
import 'size_config.dart';

//// 라이트버전
/// 색
// 색상표

// const Color yachtRed = Color(0xFFEE5076);
const Color blueGrey = Color(0xFF789EC1);
const Color deepBlue = Color(0xFF196AB4);

Color backgroundWhenPopup = Color(0xFF343434).withOpacity(.3);
// 백그라운드
// const primaryBackgroundColor = Color(0xFFFBFAFD);
// 앱 바 백그라운드
Color primaryAppbarBackgroundColor = Color(0xFFFBFAFD).withOpacity(.7);
// 불투명 Glassmorphism 백그라운드
Color glassmorphismBackgroundColor = Color(0xFFFBFAFD).withOpacity(.4);
// 기본 폰트 색
const primaryFontColor = Color(0xFF123A5F);
// 강조하는 핑크색
const primaryPointFontColor = Colors.red;
// 흰 바탕에 쓸 약한 폰트 색
const primaryLightFontColor = Color(0xFF789EC1);
// 활성화된 버튼 색
// const activatedButtonColor = Color(0xFF196AB4);
// 홈모듈박스 바탕색
const homeModuleBoxBackgroundColor = Colors.white;
// 버튼 글씨색
const buttonTextColor = Colors.white;
// 모듈박스 그림자 색
Color boxShadowColor = Color(0xFF38204B).withOpacity(.08);

// k-Bull & Bear & Volume Color
const bullColorKR = Colors.red;
const bearColorKR = seaBlue;
const volumeColor = Color(0xFF789EC1);

Color hexToColorCode(String colorCode) {
  return Color(int.parse(colorCode, radix: 16) + 0xFF000000);
}

/// 패딩
// 텍스트 탑일 때 텍스트 사이즈에 따른 패딩

double reducedPaddingWhenTextIsBelow(double padding, double textSize) {
  return padding - (textSize * 0.2).round().toDouble();
}

double reducedPaddingWhenTextIsBothSide(double padding, double topTextSize, double bottomTextSize) {
  return padding - reducePaddingBothSide(topTextSize, bottomTextSize);
}

double reducePaddingOneSide(double textSize) {
  return (textSize * 0.2).round().toDouble();
}

double reducePaddingBothSide(double topTextSize, double bottomTextSize) {
  return ((topTextSize * 0.2).round() + (bottomTextSize * 0.2).round()).toDouble();
}

EdgeInsets textTopPadding(double textSize) {
  return EdgeInsets.fromLTRB(14.w, (-(textSize * 0.2).round() + 30).w, 14.w, 14.w);
}

EdgeInsets textTopOpenHorizontalPadding(double textSize) {
  // print(textSize);
  // print((textSize * 0.2).round());
  // print((-(textSize * 0.2).round() + 14).h);
  // print(17.h);
  return EdgeInsets.fromLTRB(0, (-(textSize * 0.2).round() + 14).w, 0, 8.w);
}

// EdgeInsets primaryHorizontalPadding = EdgeInsets.symmetric(
//   horizontal: 14.w,
// );

EdgeInsets moduleBoxPadding(double moduleUpperTextSize) {
  return EdgeInsets.fromLTRB(
    14.w,
    (14 - reducePaddingOneSide(moduleUpperTextSize)).w,
    14.w,
    14.w,
  );
}

/// 사이즈드 박스
// 홈-모듈 사이
SizedBox btwHomeModule = SizedBox(
  height: 50.w - reducePaddingOneSide(homeModuleTitleTextStyle.fontSize!),
);

// 홈-모듈-타이틀과 슬라이더 사이
SizedBox btwHomeModuleTitleBox = SizedBox(
  height: 20.w - reducePaddingOneSide(homeModuleTitleTextStyle.fontSize!),
);

// 텍스트 사이
SizedBox btwText(double topTextSize, double bottomTextSize) {
  return SizedBox(
    height: 10.w - reducePaddingBothSide(topTextSize, bottomTextSize),
  );
}

// 홈-모듈-박스 아래 간격
SizedBox belowHomeModule = SizedBox(height: 10.w);

/// 컨테이너 데코레이션
// 홈-모듈박스 데코레이션
BoxDecoration primaryBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12.w),
);
// 모듈박스 그림자
BoxShadow primaryBoxShadow = BoxShadow(
  color: boxShadowColor,
  blurRadius: 12,
  offset: Offset(0, 0),
);
// 불투명 Glassmorphism Container

// var glassMorphismDecoration =
// ClipRect glassmorphismContainer({required Widget child}) {
//   return ClipRect(
//     child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//         child: Container(
//           padding: EdgeInsets.all(6.w),
//           decoration: BoxDecoration(
//               color: glassmorphismBackgroundColor,
//               borderRadius: BorderRadius.circular(10.w)),
//           child: child,
//         )),
//   );
// }

//// 폰트
/// 홈
// 홈-헤더-닉네임
TextStyle homeHeaderName = TextStyle(
  fontFamily: 'SCore',
  fontSize: 20.w,
  fontWeight: FontWeight.w700,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);
// 홈-헤더-닉네임뒤에
TextStyle homeHeaderAfterName = TextStyle(
  fontFamily: 'SCore',
  fontSize: 20.w,
  fontWeight: FontWeight.w300,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);
// 홈-섹션박스-헤더
TextStyle homeModuleTitleTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w600,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle smallSubtitleTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w400,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);
// 홈-상금박스-상금헤더
TextStyle awardModuleSliderTitleTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w400,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 홈-퀘스트박스-기간헤더
TextStyle questTermTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w300,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);
// 홈-퀘스트모듈-퀘스트박스-타이틀
TextStyle questTitleTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w500,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);

// 홈-퀘스트모듈-퀘스트박스-남은시간
TextStyle questTimeLeftTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w600,
  color: primaryPointFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);

// 홈-퀘스트모듈-퀘스트박스-리워드
// TextStyle questRewardTextStyle = TextStyle(
//   fontFamily: 'SCore',
//   fontSize: 16.w,
//   fontWeight: FontWeight.w500,
//   color: primaryFontColor,
//   letterSpacing: -1.0,
//   height: 1.4,
// );
// 홈-퀘스트모듈-퀘스트박스-참여자수
TextStyle questCountTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w700,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);

// 버튼 안에 들어가는 텍스트
TextStyle buttonTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w600,
  color: buttonTextColor,
  letterSpacing: -1.0,
  height: 1.4,
);

// 납작한 버튼 텍스트
TextStyle cardButtonTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: Color(0xFF335B80),
  letterSpacing: -1.0,
  height: 1.4,
);

// 자세한 내용 쓰는 텍스트
TextStyle detailedContentTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w300,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);

/// 기업 정보
// 기업 이름
TextStyle stockInfoNameTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 22.w,
  fontWeight: FontWeight.w500,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);
// 차트 메인 가격
TextStyle stockPriceTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 30.w,
  fontWeight: FontWeight.w600,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);

// 차트 세부 가격 변동 텍스트 // 차트 토글 버튼 텍스트
TextStyle stockPriceChangeTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle stockInfoStatsTitle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);

// 가장 작은 텍스트 스타일
TextStyle mostDetailedContentTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 10.w,
  fontWeight: FontWeight.w500,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);

//// 커뮤니티
/// 피드 박스
// 날짜 표시

// TextStyle feedTitle = TextStyle(
//   fontFamily: 'SCore',
//   fontSize: 14.w,
//   fontWeight: FontWeight.w500,
//   color: primaryFontColor,
//   letterSpacing: -1.0,
//   height: 1.4,
// );

// TextStyle feedContent = TextStyle(
//   fontFamily: 'SCore',
//   fontSize: 14.w,
//   fontWeight: FontWeight.w300,
//   color: primaryFontColor,
//   letterSpacing: -1.0,
//   height: 1.4,
// );

TextStyle feedUserName = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w400,
  color: primaryFontColor,
  letterSpacing: -1.0,
  height: 1.4,
);

//// 버튼 컴포넌트들
// 기본 버튼
// Container primaryButtonContainer(Text buttonText) {
//   return Container(
//     height: 42.w,
//     width: double.infinity,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(50.w),
//       color: activatedButtonColor,
//     ),
//     child: Center(child: buttonText),
//   );
// }

// 차트 토글 버튼
Container chartToggleButton({required Widget child, required bool isSelected, required Color color}) {
  return Container(
      // width: 50.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(7.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.w),
      child: child);
}

// 조가비 아이템 버튼 박스 Decoration
BoxDecoration jogabiButtonBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20.w),
);

///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
///
const kSecondaryColor = Color(0xFF979797);

const kAnimationDuration = Duration(milliseconds: 200);

// Income Statement Bar Chart & Line Chart Color
Color barColor1 = Color(0xFF607D8B).withOpacity(.3);
Color barColor2 = Color(0xFF607D8B).withOpacity(.5);
Color barColor3 = Color(0xFF607D8B).withOpacity(.7);
Color barColor4 = Color(0xFF607D8B).withOpacity(.9);
// Color accLineColor = Color(0xFFFAAC00).withOpacity(.8);

// 기본 앱 바
// AppBar primaryAppBar(String title) => AppBar(
//       // backgroundColor: primaryBackgroundColor,
//       // leading: AppBarBackButton(),
//       title: Text(
//         title,
//         style: homeHeaderAfterName,
//       ),
//       toolbarHeight: 60.w,
//       elevation: 0,
//       // bottom: PreferredSize(
//       //     child: Container(
//       //       color: Color(0xFF94BDE0).withOpacity(0.3),
//       //       // 피그마에서는 opacity 0.5 인데 0.5로하면 너무 진한 느낌이 나서..
//       //       // color: Color(0xFF94BDE0).withOpacity(0.5),
//       //       height: 1.0,
//       //     ),
//       //     preferredSize: Size.fromHeight(1.0)),
//     );

// Button Color
const toggleButtonColor = Color(0xFFE8EAF6);
const termToggleButtonColor = Color(0xFF6e608b);
const termToggleSelectedTextColor = Color(0xffe6f2f2);
const termToggleNotSelectedTextColor = Colors.black87;
// Spacing
const verticalSpaceExtraLarge = SizedBox(height: 32);
const verticalSpaceLarge = SizedBox(height: 24);
const verticalSpaceMedium = SizedBox(height: 16);
const verticalSpaceSmall = SizedBox(height: 8);
const verticalSpaceExtraSmall = SizedBox(height: 4);
const horizontalSpaceExtraLarge = SizedBox(width: 32);
const horizontalSpaceLarge = SizedBox(width: 24);
const horizontalSpaceMedium = SizedBox(width: 16);
const horizontalSpaceSmall = SizedBox(width: 8);
const kHorizontalPadding = EdgeInsets.symmetric(horizontal: 16);
const kSymmetricPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 16);
const dialogPadding = EdgeInsets.symmetric(horizontal: 32, vertical: 20);

// Font Style
final headingStyleEN = TextStyle(
  fontSize: reactiveHeight(27.5),
  fontWeight: FontWeight.w700,
  fontFamily: 'DmSans',
  color: Colors.black,
  letterSpacing: -0.5,
  height: 1.1,
);

final bigHeadingStyle = TextStyle(
  fontSize: reactiveHeight(34),
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  letterSpacing: -0.5,
  height: 1.1,
);

final headingStyle = TextStyle(
  fontSize: reactiveHeight(26),
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  letterSpacing: -0.5,
  height: 1.1,
);

final titleStyle = TextStyle(
  fontSize: reactiveHeight(24),
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  letterSpacing: -1,
  height: 1.1,
);

final subtitleStyle = TextStyle(
  fontSize: reactiveHeight(20),
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  color: Color(0xff212121),
  letterSpacing: -1,
  height: 1.1,
);

final confirmStyle = TextStyle(
  fontSize: reactiveHeight(18),
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  color: Color(0xff212121),
  letterSpacing: -1,
  height: 1.1,
);

// final contentStyle = TextStyle(
//     fontSize: reactiveHeight(16),
//     fontWeight: FontWeight.w500,
//     fontFamily: 'NotoSansKR',
//     letterSpacing: -.5,
//     height: 1.1);

final detailStyle = TextStyle(
    fontSize: reactiveHeight(14),
    fontWeight: FontWeight.w500,
    fontFamily: 'NotoSansKR',
    letterSpacing: -.5,
    height: 1.1);

// 숫자 스타일
final ohlcInfoStyle = TextStyle(
    fontSize: reactiveHeight(16),
    fontWeight: FontWeight.w400,
    fontFamily: 'NotoSansKR',
    letterSpacing: -0.5,
    height: 1.1);

final ohlcPriceStyle = TextStyle(
    fontSize: reactiveHeight(18), fontWeight: FontWeight.w500, fontFamily: 'DmSans', letterSpacing: -0.5, height: 1.1);

final detailPriceStyle = TextStyle(
    fontSize: reactiveHeight(16), fontWeight: FontWeight.w700, fontFamily: 'DmSans', letterSpacing: -0.5, height: 1.1);

Container toggleButton(Widget child, Color color) {
  return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(70),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: child);
}

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

// final otpInputDecoration = InputDecoration(
//   contentPadding:
//       EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
//   border: outlineInputBorder(),
//   focusedBorder: outlineInputBorder(),
//   enabledBorder: outlineInputBorder(),
// );

// OutlineInputBorder outlineInputBorder() {
//   return OutlineInputBorder(
//     borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
//     borderSide: BorderSide(color: kTextColor),
//   );
// }


