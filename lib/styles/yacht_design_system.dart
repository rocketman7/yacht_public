import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// BASIC COLORS CODE
const Color yachtBlack = const Color(0xFF101214);
const Color yachtViolet = const Color(0xFF798AE6);
const Color yachtDarkGrey = const Color(0xFF5B6A87);
const Color yachtGrey = const Color(0xFF879098);
const Color yachtRed = const Color(0xFFEE5076);
const Color buttonBackgroundPurple = const Color(0xFFEFF2FA);
const Color buttonTextPurple = const Color(0xFF6073B4);
Color yachtShadow = Color(0xFFCEC4DA).withOpacity(.3);
const yachtLineColor = Color(0xFFE6EAF1);
const Color white = Colors.white;

const Color tierNewbie = Color(0xFFFCE4A8);
const Color tierIntern = Color(0xFFCDE7AC);
const Color tierAmateur = Color(0xFFC2E7F2);
const Color tierPro = Color(0xFFC3C2FF);
const Color tierMaster = Color(0xFFE1BFFC);
const Color tierGrandMaster = Color(0xFFFEB8B8);
Color tierName = yachtBlack.withOpacity(.8);

const primaryBackgroundColor = white;

// 불투명 Glassmorphism 백그라운드
Color glassmorphismBackgroundColor = Color(0xFFFBFAFD).withOpacity(.4);

// Paddings
// Padding, Score 폰트 height 보정
double correctHeight(double originalPadding, upperTextSize, lowerTextSize) {
  return originalPadding - offsetTextHeight(upperTextSize, lowerTextSize);
}

double offsetTextHeight(double upperTextSize, double lowerTextSize) {
  return ((upperTextSize * 0.175).round() + (lowerTextSize * 0.175).round()).toDouble();
}

// 섹션 타이틀과 박스 사이
double heightSectionTitleAndBox = 20.w;
// 섹션 박스들 사이 (주로 horizontal List view)
double widthHorizontalListView = 14.w;
// 첫 섹션과 앱바 사이
// 섹션 안에 패딩
double primaryPaddingSize = 14.w;
EdgeInsets primaryHorizontalPadding = EdgeInsets.symmetric(horizontal: primaryPaddingSize);
EdgeInsets primaryAllPadding = EdgeInsets.all(primaryPaddingSize);
// FONTS

String krFont = 'SCore';
double primaryFontHeight = 1.35;
double contentFontHeight = 1.5;

double heading1Size = 34.w;
double heading2Size = 30.w;
double heading3Size = 22.w;
double heading4Size = 20.w;
double heading5Size = 18.w; // 섹션 타이틀

double bodyBigSize = 16.w;
double bodySmallSize = 14.w;

double captionSize = 12.w;

double smallestSize = 9.w;

// TextStyle heading5Style = TextStyle(
//   fontSize: 18.w,
//   fontWeight: FontWeight.w500,
// );

// TextStyle headlineStyle = TextStyle(
//   fontSize: 30.w,
//   fontWeight: FontWeight.w700,
// );

// TextStyle bodyStyle = TextStyle(
//   fontSize: 16.w,
//   fontWeight: FontWeight.w400,
// );

// TextStyle captionStyle = TextStyle(
//   fontSize: 12.w,
//   fontWeight: FontWeight.w400,
// );

// 앱 바 페이지 타이틀
TextStyle appBarTitle = TextStyle(
  fontFamily: krFont,
  fontSize: heading4Size,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  height: primaryFontHeight,
  letterSpacing: -1.0,
);
// 홈 뷰 섹션 타이틀
TextStyle sectionTitle = TextStyle(
  fontFamily: krFont,
  fontSize: heading5Size,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  height: primaryFontHeight,
  letterSpacing: -1.0,
);
// 보유 자산 이름
TextStyle myAssetTitle = TextStyle(
  fontFamily: krFont,
  fontSize: bodyBigSize,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  height: primaryFontHeight,
  letterSpacing: -1.0,
);
// 보유 자산 금액
TextStyle myAssetAmount = TextStyle(
  fontFamily: krFont,
  fontSize: heading4Size,
  color: yachtBlack,
  fontWeight: FontWeight.w500,
  height: primaryFontHeight,
  letterSpacing: -1.0,
);

// 섹션 버튼 타이틀
TextStyle buttonTitleStyle = TextStyle(
  fontFamily: krFont,
  fontSize: bodyBigSize,
  color: buttonTextPurple,
  fontWeight: FontWeight.w500,
  height: primaryFontHeight,
  letterSpacing: -0.1,
);

// 퀘스트 카드 내에 기간 표시
TextStyle subheadingStyle = TextStyle(
  fontSize: 14.w,
  color: yachtBlack,
  fontWeight: FontWeight.w300,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);

TextStyle jogabiNumberStyle = TextStyle(
  fontSize: 14.w,
  fontWeight: FontWeight.w600,
  color: yachtBlack,
  height: primaryFontHeight,
);

// 퀘스트 타이머
TextStyle questTimerStyle = TextStyle(
  fontSize: bodySmallSize,
  fontWeight: FontWeight.w500,
  color: yachtViolet,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);

// 섹션 박스 리워드
TextStyle questRewardAmoutStyle = TextStyle(
  fontSize: bodyBigSize,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);

// 긴 컨텐트 스타일
TextStyle contentStyle = TextStyle(
  fontSize: bodySmallSize,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);

// 심플 텍스트 버튼 스타일
TextStyle simpleTextButtonStyle = TextStyle(
  fontSize: bodySmallSize,
  fontWeight: FontWeight.w500,
  color: buttonTextPurple,
  letterSpacing: -0.5,
  height: primaryFontHeight,
);

//// 커뮤니티 스타일
/// 커뮤니티 메인
// 피드 작성자
TextStyle feedWriterName = TextStyle(
  fontSize: 14.w,
  fontWeight: FontWeight.w200,
  color: yachtBlack,
  letterSpacing: -0.5,
  height: primaryFontHeight,
);

TextStyle feedTitle = TextStyle(
  fontSize: bodySmallSize,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);

TextStyle feedContent = TextStyle(
  fontSize: 16.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: contentFontHeight,
);

TextStyle feedHashTag = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w300,
  color: buttonTextPurple,
  letterSpacing: -1.0,
  height: 1.4,
);

/// 세부 포스트 페이지
// 세부 포스트에서 사이즈 1픽셀 확대
TextStyle feedTitleDetail = feedTitle.copyWith(fontSize: 15.w);
TextStyle feedContentDetail = feedContent.copyWith(fontSize: 15.w);

// 티어관련텍스트
TextStyle simpleTierStyle = TextStyle(
  fontSize: 10.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w600,
  color: tierName,
  letterSpacing: -0.5,
  height: 1.4,
);

TextStyle snackBarStyle = TextStyle(
  fontSize: bodyBigSize,
  fontFamily: krFont,
  fontWeight: FontWeight.w600,
  color: yachtBlack,
  letterSpacing: -0.5,
  height: 1.4,
);

// ICONS

// BUTTONS
Container simpleTextContainerButton(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
    decoration: BoxDecoration(
      color: buttonBackgroundPurple,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
      text,
      style: simpleTextButtonStyle,
    ),
  );
}

// CONTAINERS
// 기본 섹션 박스
Container sectionBox({
  double? height,
  double? width,
  EdgeInsets? padding,
  required Widget child,
}) {
  return Container(
    height: height,
    width: width,
    padding: padding ?? EdgeInsets.all(0),
    decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12.w), boxShadow: [
      BoxShadow(
        color: yachtShadow,
        blurRadius: 8.w,
        spreadRadius: 1.w,
      )
    ]),
    child: child,
  );
}

// 아래 기본 형태 텍스트 버튼이 있는 섹션 박스
Container sectionBoxWithBottomButton({
  double? height,
  double? width,
  EdgeInsets? padding,
  String? buttonTitle,
  // Function? onTap,
  required Widget child,
}) {
  return Container(
    height: height,
    width: width,
    // padding: padding,
    decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(12.w), boxShadow: [
      BoxShadow(
        color: yachtShadow,
        blurRadius: 8.w,
        spreadRadius: 1.w,
      )
    ]),
    child: Column(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: padding!,
            child: child,
          ),
        ),
        Container(
          height: 44.w,
          width: double.infinity,
          decoration: BoxDecoration(
              color: buttonBackgroundPurple,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.w), bottomRight: Radius.circular(12.w))),
          child: Center(
            child: Text(
              buttonTitle!,
              style: buttonTitleStyle,
            ),
          ),
        )
      ],
    ),
  );
}

Container simpleTierRRectBox({required String tier, double width = 70}) {
  late Color tierColor;
  late String tierName;
  switch (tier) {
    case 'newbie':
      tierColor = tierNewbie;
      tierName = "뉴비";
      break;
    case 'intern':
      tierColor = tierIntern;
      tierName = "인턴";
      break;
    case 'amateur':
      tierColor = tierAmateur;
      tierName = "아마추어";
      break;
    case 'pro':
      tierColor = tierPro;
      tierName = "프로";
      break;
    case 'master':
      tierColor = tierMaster;
      tierName = "마스터";
      break;
    case 'grandMaster':
      tierColor = tierGrandMaster;
      tierName = "그랜드마스터";
      break;
    default:
      tierColor = tierNewbie;
  }
  return Container(
    width: width.w,
    height: (width / 3.75).w,
    decoration: BoxDecoration(color: tierColor, borderRadius: BorderRadius.circular(50)),
    child: Center(
      child: Text(
        '$tierName 3',
        style: simpleTierStyle.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
  );
}

ClipRect glassmorphismContainer({required Widget child}) {
  return ClipRect(
    child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(color: glassmorphismBackgroundColor, borderRadius: BorderRadius.circular(10.w)),
          child: child,
        )),
  );
}

// 백버튼과 타이틀이 있는 기본 앱 바
AppBar primaryAppBar(String title) {
  return AppBar(
    backgroundColor: white,
    toolbarHeight: 60.w,
    title: Text(title, style: appBarTitle),
  );
}

// 해쉬태그 컨테이너
Container feedHashTagContainer(String hashTag) => Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
      decoration: BoxDecoration(
        color: buttonBackgroundPurple,
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Text(
        hashTag,
        style: feedHashTag,
      ),
    );

yachtSnackBar(String title) {
  return Get.rawSnackbar(
    messageText: Center(
      child: Text(
        title,
        style: snackBarStyle,
      ),
    ),
    snackPosition: SnackPosition.TOP,
    backgroundColor: white.withOpacity(.5),
    barBlur: 2,
    margin: EdgeInsets.only(top: 60.w),
    duration: const Duration(seconds: 1, milliseconds: 100),
    // animationDuration: const Duration(microseconds: 1000),
  );
}

List<PopupMenuItem> communityShowMore = [
  PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    // value: index,
    height: 20.w,
    child: Container(
        child: Center(
            child: Text(
      '차단',
      style: contentStyle,
    ))),
  ),
  PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    // value: index,
    height: 20.w,
    child: Container(
        child: Center(
            child: Text(
      '신고',
      style: contentStyle,
    ))),
  ),
];

List<PopupMenuItem> communityMyShowMore = [
  PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    // value: index,
    height: 20.w,
    value: Container(
      color: Colors.red,
    ),
    child: Container(
        child: Center(
            child: Text(
      '수정',
      style: contentStyle,
    ))),
  ),
  PopupMenuItem(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    // value: index,
    height: 20.w,
    value: 'delete',
    child: Container(
        child: Center(
            child: Text(
      '삭제',
      style: contentStyle,
    ))),
  ),
];
