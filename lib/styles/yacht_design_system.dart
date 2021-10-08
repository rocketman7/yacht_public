import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yachtOne/handlers/user_tier_handler.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

// BASIC COLORS CODE
const Color yachtBlack = const Color(0xFF101214);
const Color yachtViolet = const Color(0xFF798AE6);
const Color yachtViolet80 = const Color(0xFF586DE0);
const Color yachtDarkPurple = const Color(0xFF6073B4);
const Color yachtDarkGrey = const Color(0xFF5B6A87);
const Color yachtGrey = const Color(0xFF879098);
const Color yachtLightGrey = const Color(0xFFE6EAF1);
const Color yachtRed = const Color(0xFFEE5076);
const Color yachtBlue = Color(0xFF4A99E2);
const Color yachtYellow = Color(0xFFFFAD4C);
const Color yachtYellowBackGround = Color(0xFFFFF1D5);
const Color yachtGreen = Color(0xFF61CCA6);
const Color yachtGreenBackGround = Color(0xFFE6F7F1);
const Color primaryButtonText = const Color(0xFFEFF2FA);
const Color primaryButtonBackground = yachtViolet;
const Color secondaryButtonText = yachtViolet;
const Color secondaryButtonBackground = const Color(0xFFEFF2FA);
const Color commentBackground = Color(0xFFFCFCFC);

// k-Bull & Bear & Volume Color
const bullColorKR = yachtRed;
const bearColorKR = yachtBlue;
const volumeColor = yachtGrey;

Color thinDivider = Color(0xFF879098).withOpacity(.05);

const Color buttonDisabled = const Color(0xFFE6E6E6);
const Color buttonNormal = const Color(0xFFEFF2FA);
Color yachtShadow = Color(0xFFCEC4DA).withOpacity(.3);
const Color yachtLine = Color(0xFFE6EAF1);
const Color white = Colors.white;

const Color tierNewbie = Color(0xFFFCE4A8);
const Color tierIntern = Color(0xFFCDE7AC);
const Color tierAmateur = Color(0xFFC2E7F2);
const Color tierPro = Color(0xFFC3C2FF);
const Color tierMaster = Color(0xFFE1BFFC);
const Color tierGrandMaster = Color(0xFFFEB8B8);
Color tierName = yachtBlack.withOpacity(.8);

// Area graph Color
Color graph0 = Color(0xFF5568CF).withOpacity(.55);
Color graph1 = Color(0xFF55C0CF).withOpacity(.55);
Color graph2 = Color(0xFF9255CF).withOpacity(.55);
Color graph3 = Color(0xFF55CF69).withOpacity(.55);
Color graph4 = Color(0xFF558DCF).withOpacity(.55);

// Area 차트에 쓰일 색상들
final List<double> stops = <double>[0.0, 1.0];

final List<Color> liveAreaColor0 = <Color>[graph0, graph0.withOpacity(0.05)];
final List<Color> liveAreaColor1 = <Color>[graph1, graph1.withOpacity(0.05)];
final List<Color> liveAreaColor2 = <Color>[graph2, graph2.withOpacity(0.05)];
final List<Color> liveAreaColor3 = <Color>[graph3, graph3.withOpacity(0.05)];
final List<Color> liveAreaColor4 = <Color>[graph4, graph4.withOpacity(0.05)];

// FastLine Graph Color
const Color lineChart0 = Color(0xFF856EC8);
const Color lineChart1 = Color(0xFF2599BE);
const Color lineChart2 = Color(0xFF90CC10);
const Color lineChart3 = Color(0xFFFFB800);
const Color lineChart4 = Color(0xFFD04B00);
const List<Color> lineChartColors = [
  lineChart0,
  lineChart1,
  lineChart2,
  lineChart3,
  lineChart4,
];

const activatedButtonColor = Color(0xFF196AB4);
Color dividerColor = Color(0xFF94BDE0).withOpacity(0.3);

const primaryBackgroundColor = white;

// 불투명 Glassmorphism 백그라운드
Color glassmorphismBackgroundColor = Color(0xFFFBFAFD).withOpacity(.4);

// Tier

// 티어정보별로 색깔을 가지고 있는다.
Map<String, Color> tierColor = {
  'newbie': tierNewbie,
  'intern': tierIntern,
  'amateur': tierAmateur,
  'pro': tierPro,
  'master': tierMaster,
  'grandmaster': tierGrandMaster,
};

// 티어별 스토리지 주소를 갖고 있는다.
Map<String, String> tierJellyBeanURL = {
  'newbie': 'tier/newbie.png',
  'intern': 'tier/intern.png',
  'amateur': 'tier/amateur.png',
  'pro': 'tier/pro.png',
  'master': 'tier/master.png',
  'grandmaster': 'tier/grandmaster.png',
};

// 티어별 네임을 갖고 있는다. 경험지에 따른 레벨도 갖고 있는다. 위 색깔, 스토리지 주소, 아래는 모두 admin에 있는게 나을 듯?
Map<String, String> tierKorName = {
  'newbie': '뉴비',
  'intern': '인턴',
  'amateur': '아마추어',
  'pro': '프로',
  'master': '마스터',
  'grandmaster': '그랜드마스터',
};

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
String krFontW400 = 'Default';
double primaryFontHeight = 1.35;
double contentFontHeight = 1.5;

double heading1Size = 34.w;
double heading2Size = 30.w;
double heading3Size = 24.w;
double heading4Size = 20.w;
double heading5Size = 18.w; // 섹션 타이틀

double bodyBigSize = 16.w;
double bodySmallSize = 14.w;

double captionSize = 12.w;

double smallestSize = 9.w;

//// TextField InputDecoration
// 이메일 가입 데코레이션
InputDecoration emailRegisterInputDecoration = InputDecoration(
  isDense: true,
  // isCollapsed: true,
  contentPadding: EdgeInsets.symmetric(vertical: 14.w),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: yachtGrey),
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: yachtGrey),
  ),
  errorStyle: emailRegisterFieldHint.copyWith(
    color: yachtRed,
    fontFamily: krFont,
    fontWeight: FontWeight.w500,
  ),
  hintText: "이메일을 입력해주세요.",
  hintStyle: emailRegisterFieldHint,
);

/// 기업 정보
// 기업 이름
TextStyle stockInfoNameTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 22.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 차트 메인 가격
TextStyle stockPriceTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 30.w,
  fontWeight: FontWeight.w600,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 퀘스트 타이틀
TextStyle questTitleTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 스탯 각 제목
TextStyle stockInfoStatsTitle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 자세한 내용 쓰는 텍스트
TextStyle detailedContentTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

//// 온보딩
// 타이틀
TextStyle onboardingTitle = TextStyle(
  fontFamily: krFont,
  fontSize: heading3Size,
  fontWeight: FontWeight.w500,
  color: primaryButtonBackground,
  height: primaryFontHeight,
  letterSpacing: -1.0,
);
// 컨텐트
TextStyle onboardingContent = TextStyle(
  fontFamily: krFont,
  fontSize: heading4Size,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  height: 1.5,
  letterSpacing: -1.0,
);
// 다음
TextStyle nextPage = TextStyle(
  fontFamily: krFont,
  fontSize: bodySmallSize,
  fontWeight: FontWeight.w500,
  color: yachtRed,
  height: primaryFontHeight,
  letterSpacing: -1.0,
);
// 스킵
TextStyle skipOnboarding = TextStyle(
  fontFamily: krFont,
  fontSize: bodySmallSize,
  fontWeight: FontWeight.w300,
  color: yachtGrey.withOpacity(.5),
  height: primaryFontHeight,
  letterSpacing: -1.0,
);

// 소셜로그인 타이틀
TextStyle socialLogin = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 이메일 가입
// 타이틀
TextStyle emailRegisterTitle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 24.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
// 필드 이름
TextStyle emailRegisterFieldName = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w500,
  color: yachtViolet,
  letterSpacing: -1.0,
  height: 1.4,
);

// 필드 힌트
TextStyle emailRegisterFieldHint = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w300,
  color: yachtGrey,
  letterSpacing: -1.0,
  height: 1.4,
);

// 필드 힌트
TextStyle emailRegisterFieldInstruction = TextStyle(
  fontFamily: 'Default',
  fontSize: 14.w,
  // fontWeight: FontWeight.w300,
  color: yachtGrey,
  letterSpacing: -1.0,
  height: 1.4,
);

//// 프로필 페이지
// 닉네임
TextStyle profileTierNameStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 9.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -0.01,
  height: primaryFontHeight,
);

// 닉네임
TextStyle profileUserNameStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 20.w,
  fontWeight: FontWeight.w700,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);

// 팔로워, 팔로잉 숫자
TextStyle profileFollowNumberStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w700,
  color: yachtBlack,
  letterSpacing: -0.01,
  height: primaryFontHeight,
);

// 팔로워,팔로잉 글자
TextStyle profileFollowTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w400,
  color: yachtBlack,
  letterSpacing: -0.01,
  height: primaryFontHeight,
);

// 팔로워,팔로잉페이지 닉네임
TextStyle profileFollowNickNameStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w400,
  color: yachtBlack,
  letterSpacing: -0.5,
  height: primaryFontHeight,
);

// 팔로워,팔로잉페이지 삭제버튼텍스트
TextStyle profileFollowDeleteStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 13.w,
  fontWeight: FontWeight.w400,
  color: yachtViolet,
  letterSpacing: -0.1,
  height: primaryFontHeight,
);

// 버튼글자
TextStyle profileButtonTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: primaryButtonBackground,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);

//헤더
TextStyle profileHeaderTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);

// 즐겨찾기종목 종목명
TextStyle profileFavoritesNameTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);

//즐겨찾기종목 종목명
TextStyle profileFavoritesNumberTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);

// 수정 페이지
TextStyle profileChangeTitleTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);
TextStyle profileChangeContentTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w400,
  color: yachtBlack,
  letterSpacing: -0.01,
  height: primaryFontHeight,
);
TextStyle profileChangeButtonTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 20.w,
  fontWeight: FontWeight.w500,
  color: primaryButtonBackground,
  letterSpacing: -1.0,
  height: primaryFontHeight,
);
TextStyle profileAvatarChangeTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: 0,
  height: primaryFontHeight,
);

//// 상금
// 상금 액수
// 홈-상금-상금상세-상금타이틀
TextStyle subLeagueTitleTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w400,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 홈-상금-상금상세-상금액수
TextStyle subLeagueAwardTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 40.w,
  fontWeight: FontWeight.w500,
  color: yachtDarkGrey,
  letterSpacing: -1.0,
  height: 1.4,
);

// 상금박스-상금액수한글
TextStyle awardAmountKoreanTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 24.w,
  fontWeight: FontWeight.w300,
  color: yachtViolet.withOpacity(0.3),
  letterSpacing: 3,
  height: 1.4,
);

// 홈-상금-상금상세-설명
TextStyle subLeagueAwardDescriptionStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 홈-상금-상금상세-룰
TextStyle subLeagueAwardRulesStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w400,
  color: yachtGrey,
  letterSpacing: -1.0,
  height: 1.4,
);

// 홈-상금-상금상세-포트폴리오포션텍스트
TextStyle subLeagueAwardPortionStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 22.w,
  fontWeight: FontWeight.w600,
  color: yachtBlack,
  letterSpacing: 0.0,
  height: 1.4,
);

// 홈-상금-상금상세-포트폴리오네임텍스트
TextStyle subLeagueAwardStockNameStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: 0.0,
  height: 1.4,
);

// 홈-상금-상금상세-포트폴리오라벨 텍스트
TextStyle subLeagueAwardLabelStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w400,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 홈-상금-상금상세-포트폴리오코멘트 텍스트
TextStyle subLeagueAwardCommentStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 홈-상금박스-상금액수
TextStyle awardModuleSliderAmountTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 34.w,
  fontWeight: FontWeight.w500,
  color: yachtDarkGrey,
  letterSpacing: -1.0,
  height: 1.4,
);
// 홈-상금박스-상금액수한글
TextStyle awardModuleSliderAmountKoreanTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w300,
  color: yachtViolet,
  letterSpacing: 3,
  height: 1.4,
);
// 홈-상금박스-상금기한
TextStyle awardModuleSliderEndDateTimeTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -0.25,
  height: 1.4,
);
// 홈-섹션박스-헤더
TextStyle awardModuleTitleTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 상금박스의 색깔.
const List<List<Color>> awardColors = [
  [Color(0xFFCFEAF9), Color(0xFFE7EBFF)],
  [Color(0xFFCFD8F9), Color(0xFFDDF1FF)],
  [Color(0xFFE3E1FB), Color(0xFFDDE3FF)],
];
// 포트폴리오 색깔.
const List<Color> portfolioColors = [
  Color(0xFF798AE6),
  Color(0xFF79A5E6),
  Color(0xFF79D2E6),
  Color(0xFF79E6CC),
];

//// 홈
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
  color: buttonNormal,
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
  color: primaryButtonBackground,
  letterSpacing: -0.5,
  height: primaryFontHeight,
);

// 퀘스트 결과
TextStyle questResultRewardTitle = TextStyle(
  fontSize: bodySmallSize,
  // fontWeight: FontWeight.w500,
  fontFamily: 'Default',
  color: yachtBlack,
  letterSpacing: -0.5,
  height: primaryFontHeight,
);

TextStyle questRewardTextStyle = TextStyle(
  fontSize: bodyBigSize,
  fontWeight: FontWeight.w600,
  fontFamily: krFont,
  color: yachtBlack,
  letterSpacing: -0.5,
  height: primaryFontHeight,
);

//// 커뮤니티 스타일
/// 커뮤니티 메인
// 피드 작성자
TextStyle feedWriterName = TextStyle(
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
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
  color: primaryButtonBackground,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle feedDateTime = TextStyle(
  fontFamily: 'SCore',
  fontSize: 10.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -0.5,
  height: 1.4,
);

TextStyle feedCommentLikeCount = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -.5,
  height: 1.4,
);

// 금융백과사전
TextStyle dictionaryKeyword = TextStyle(
  fontFamily: 'SCore',
  fontSize: heading5Size,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 더보기
TextStyle moreText = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w300,
  color: yachtGrey,
  letterSpacing: 0.0,
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
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -0.5,
  height: 1.4,
);

//// 다이얼로그
// 제목
TextStyle dialogTitle = TextStyle(
  fontSize: heading5Size,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -0.5,
  height: 1.4,
);

TextStyle dialogContent = TextStyle(
  fontSize: heading5Size,
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -0.5,
  height: 1.4,
);

TextStyle dialogWarning = TextStyle(
  fontSize: heading5Size,
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  color: yachtRed,
  letterSpacing: -0.5,
  height: 1.4,
);

// 퀘스트카드 및 퀘스트 세부 페이지
TextStyle questDescription = TextStyle(
  fontSize: bodyBigSize,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle questTerm = TextStyle(
  fontSize: bodyBigSize,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle questTitle = TextStyle(
  fontSize: heading5Size,
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle adsWarningTitle = TextStyle(
  fontSize: 16.w,
  fontFamily: 'SCore',
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: 0.0,
  height: 1.4,
);
TextStyle adsWarningText = TextStyle(
  fontSize: 18.w,
  fontFamily: 'SCore',
  fontWeight: FontWeight.w400,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle adsWarningButton = TextStyle(
  fontFamily: 'SCore',
  fontSize: 20.w,
  fontWeight: FontWeight.w500,
  color: Color(0xFFEFF2FA),
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle settingTitle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle settingContent = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle settingLogout = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w300,
  color: yachtGrey,
  decoration: TextDecoration.underline,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle accountWarning = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w400,
  color: primaryButtonBackground,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle yachtChoiceBoxName = TextStyle(
  fontSize: bodyBigSize,
  fontFamily: krFontW400,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle yachtChoiceReOrderableListTitle = TextStyle(
  fontSize: heading5Size,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 마이페이지-퀘스트참여기록
TextStyle questRecordendDateTime = TextStyle(
  fontSize: 12.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle questRecordTitle = TextStyle(
  fontSize: bodyBigSize,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle accountVerificationTitle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle accountVerificationContent = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w400,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle accountButtonText = TextStyle(
  fontFamily: 'SCore',
  fontSize: 20.w,
  fontWeight: FontWeight.w500,
  color: Color(0xFFEFF2FA),
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle authNumText = TextStyle(
  fontFamily: 'SCore',
  fontSize: 20.w,
  fontWeight: FontWeight.w500,
  color: Colors.white,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle settingFriendsCodeDialogTitle = TextStyle(
  fontSize: 18.w,
  fontFamily: 'SCore',
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: 0.0,
  height: 1.4,
);
TextStyle settingFriendsCodeDialogContent = TextStyle(
  fontSize: 18.w,
  fontFamily: 'SCore',
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle settingFriendsCodeStyle = TextStyle(
  fontSize: 18.w,
  fontFamily: 'SCore',
  fontWeight: FontWeight.w300,
  color: yachtGrey,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle settingFriendsCodeButton1 = TextStyle(
  fontSize: 16.w,
  fontFamily: 'SCore',
  fontWeight: FontWeight.w500,
  color: buttonNormal,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle settingFriendsCodeButton2 = TextStyle(
  fontSize: 16.w,
  fontFamily: 'SCore',
  fontWeight: FontWeight.w500,
  color: yachtViolet,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle questRecordSelection = TextStyle(
  fontSize: bodySmallSize,
  fontFamily: krFont,
  fontWeight: FontWeight.w600,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 요트 설명서 다이얼로그
TextStyle yachtInstructionDialogTitle = TextStyle(
  fontSize: heading5Size,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle yachtInstructionDialogSubtitle = TextStyle(
  fontSize: heading5Size,
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle yachtInstructionDialogDescription = TextStyle(
  fontSize: bodyBigSize,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 뱃지 설명서 다이얼로그
TextStyle yachtBadgesDialogTitle = TextStyle(
  fontSize: 18.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: 0.0,
  height: 1.4,
);
TextStyle yachtBadgesDescriptionDialogTitle = TextStyle(
  fontSize: 18.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle yachtBadgesDescriptionDialogContent = TextStyle(
  fontSize: 16.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
// 출고 다이얼로그
TextStyle yachtDeliveryDialogTitle = TextStyle(
  fontSize: 16.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: 0.0,
  height: 1.4,
);
TextStyle yachtDeliveryDialogText = TextStyle(
  fontSize: 18.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle yachtDeliveryDialogText2 = TextStyle(
  fontSize: 18.w,
  fontFamily: krFontW400,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle yachtDeliveryDialogButtonText = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w500,
  color: buttonNormal,
  letterSpacing: -1.0,
  height: 1.4,
);
// 랭킹뷰
TextStyle rankMainText = TextStyle(
  fontFamily: krFont,
  fontSize: 18.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle rankNameText = TextStyle(
  fontFamily: krFontW400,
  fontSize: 18.w,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle rankMainBoldText = TextStyle(
  fontFamily: krFont,
  fontSize: 18.w,
  fontWeight: FontWeight.w600,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle rankDescriptionBoldText = TextStyle(
  fontFamily: krFont,
  fontSize: 16.w,
  fontWeight: FontWeight.w600,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle rankDescriptionMainText = TextStyle(
  fontFamily: krFont,
  fontSize: 16.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle rankDescriptionContentText = TextStyle(
  fontFamily: krFontW400,
  fontSize: 14.w,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle notExistsText = TextStyle(
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  fontSize: 16.w,
  color: yachtDarkGrey,
  letterSpacing: -1.0,
  height: 1.4,
);
//알림뷰
TextStyle notificationCategory = TextStyle(
  fontSize: 14.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle notificationContent = TextStyle(
  fontSize: 14.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle notificationContentForDetail = TextStyle(
  fontSize: 16.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

// 튜토리얼 설명 텍스트
TextStyle tutorialDescriptionStyle = TextStyle(
  fontSize: 16.w,
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  color: yachtViolet,
  letterSpacing: -1.0,
  height: 1.4,
);

// Survey
// Survey Title
TextStyle surveyTitle = TextStyle(
  fontSize: heading4Size,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle surveySelection = TextStyle(
  fontSize: heading5Size,
  fontFamily: krFont,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);

TextStyle pickManyCircleName = TextStyle(
  fontSize: bodySmallSize,
  fontFamily: krFont,
  fontWeight: FontWeight.w500,
  color: yachtViolet,
  letterSpacing: -1.0,
  height: 1.4,
);

// BUTTONS
Container simpleTextContainerButton(
  String text, {
  Widget? child,
}) {
  return Container(
      // alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
      decoration: BoxDecoration(
        color: primaryButtonText,
        borderRadius: BorderRadius.circular(50),
      ),
      child: child == null
          ? Text(
              text,
              textAlign: TextAlign.center,
              style: simpleTextButtonStyle,
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: simpleTextButtonStyle.copyWith(color: Colors.transparent),
                ),
                Positioned(
                  child: SizedBox(
                    height: simpleTextButtonStyle.fontSize,
                    width: simpleTextButtonStyle.fontSize,
                    child: child,
                  ),
                ),
              ],
            ));
}

Container simpleTextContainerLessRadiusButton(
  String text,
) {
  return Container(
    // alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
    decoration: BoxDecoration(
      color: primaryButtonText,
      borderRadius: BorderRadius.circular(4.w),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: simpleTextButtonStyle,
    ),
  );
}

Container textContainerButtonWithOptions({
  required String text,
  required bool isDarkBackground,
  double? fontSize,
  EdgeInsets? padding,
  double? height,
}) {
  return Container(
    height: height,
    padding: padding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
    decoration: BoxDecoration(
      color: isDarkBackground ? primaryButtonBackground : primaryButtonText,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Text(
        text,
        style: isDarkBackground
            ? simpleTextButtonStyle.copyWith(color: primaryButtonText, fontSize: fontSize ?? bodyBigSize)
            : simpleTextButtonStyle.copyWith(fontSize: fontSize ?? bodyBigSize),
      ),
    ),
  );
}

Container bigTextContainerButton({
  required String text,
  required bool isDisabled,
  double? height,
}) {
  return Container(
    height: height,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
    decoration: BoxDecoration(
      color: isDisabled ? buttonDisabled : primaryButtonBackground,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Center(
      child: Text(
        text,
        style: isDisabled
            ? simpleTextButtonStyle.copyWith(color: yachtGrey, fontSize: heading5Size)
            : simpleTextButtonStyle.copyWith(fontSize: heading5Size, color: primaryButtonText),
      ),
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

// 기본 박스 데코레이션
BoxDecoration yachtBoxDecoration = BoxDecoration(color: white, borderRadius: BorderRadius.circular(12.w), boxShadow: [
  BoxShadow(
    color: yachtShadow,
    blurRadius: 8.w,
    spreadRadius: 1.w,
  )
]);

// 퀘스트 선택지 박스 데코레이션
BoxDecoration yachtChoiceBoxDecoration =
    BoxDecoration(color: white, borderRadius: BorderRadius.circular(10.w), boxShadow: [
  BoxShadow(
    color: yachtShadow,
    blurRadius: 8.w,
    spreadRadius: 1.w,
  )
]);

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
              color: yachtViolet,
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

Container secondarySectionBoxWithBottomButton({
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
              color: buttonNormal,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.w), bottomRight: Radius.circular(12.w))),
          child: Center(
            child: Text(
              buttonTitle!,
              style: buttonTitleStyle.copyWith(color: yachtViolet),
            ),
          ),
        )
      ],
    ),
  );
}

class SectionBoxWithBottomButtonAndBorder extends StatefulWidget {
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final String? buttonTitle;
  final Widget child;

  const SectionBoxWithBottomButtonAndBorder(
      {Key? key, this.height, this.width, this.padding, this.buttonTitle, required this.child})
      : super(key: key);

  @override
  _SectionBoxWithBottomButtonAndBorderState createState() => _SectionBoxWithBottomButtonAndBorderState();
}

class _SectionBoxWithBottomButtonAndBorderState extends State<SectionBoxWithBottomButtonAndBorder> {
  RxDouble animator = 0.0.obs;
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    int i = 0;

    timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      animator(cos((pi / 180) * 9 * i).abs());
      i++;
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: widget.height,
        width: widget.width,
        // padding: padding,
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(14.w),
            boxShadow: [
              BoxShadow(
                color: yachtShadow,
                blurRadius: 8.w,
                spreadRadius: 1.w,
              )
            ],
            border: Border.all(
              width: 2.w,
              color: yachtViolet.withOpacity(animator.value),
            )),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: widget.padding!,
                child: widget.child,
              ),
            ),
            Container(
              height: 44.w,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: yachtViolet,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(12.w), bottomRight: Radius.circular(12.w))),
              child: Center(
                child: Text(
                  widget.buttonTitle!,
                  style: buttonTitleStyle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Container sectionBoxWithBottomButtonAndBorder({
//   double? height,
//   double? width,
//   EdgeInsets? padding,
//   String? buttonTitle,
//   // Function? onTap,
//   required Widget child,
// }) {

//   return Container(
//     height: height,
//     width: width,
//     // padding: padding,
//     decoration: BoxDecoration(
//         color: white,
//         borderRadius: BorderRadius.circular(14.w),
//         boxShadow: [
//           BoxShadow(
//             color: yachtShadow,
//             blurRadius: 8.w,
//             spreadRadius: 1.w,
//           )
//         ],
//         border: Border.all(
//           width: 2.w,
//           color: yachtViolet.withOpacity(animator.value),
//         )),
//     child: Column(
//       // mainAxisSize: MainAxisSize.max,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Padding(
//             padding: padding!,
//             child: child,
//           ),
//         ),
//         Container(
//           height: 44.w,
//           width: double.infinity,
//           decoration: BoxDecoration(
//               color: yachtViolet,
//               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12.w), bottomRight: Radius.circular(12.w))),
//           child: Center(
//             child: Text(
//               buttonTitle!,
//               style: buttonTitleStyle,
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }

Container simpleTierRRectBox({int exp = 0, double? fontSize, double width = 70}) {
  String tierName = getTierByExp(exp);
  String tierTitle = separateStringFromTier(tierName);
  // String tierTitle = "intern";
  int tierLevel = separateIntFromTier(tierName);
  // switch (tierTitle) {
  //   case 'newbie':
  //     tierColor = tierNewbie;
  //     // tierName = "뉴비";
  //     break;
  //   case 'intern':
  //     tierColor = tierIntern;
  //     // tierName = "인턴";
  //     break;
  //   case 'amateur':
  //     tierColor = tierAmateur;
  //     // tierName = "아마추어";
  //     break;
  //   case 'pro':
  //     tierColor = tierPro;
  //     // tierName = "프로";
  //     break;
  //   case 'master':
  //     tierColor = tierMaster;
  //     // tierName = "마스터";
  //     break;
  //   case 'grandmaster':
  //     tierColor = tierGrandMaster;
  //     // tierName = "그랜드마스터";
  //     break;
  //   default:
  //   // tierColor = tierNewbie;
  // }
  return Container(
    padding: EdgeInsets.symmetric(
        vertical: fontSize == null ? 3.w : (fontSize / 4),
        horizontal: tierKorName[tierTitle]!.length >= 6
            ? 8.w
            : tierKorName[tierTitle]!.length >= 4
                ? 8.w
                : 12.w),
    // width: width.w,
    // height: (width / 3.75).w,
    decoration: BoxDecoration(color: tierColor[tierTitle], borderRadius: BorderRadius.circular(50)),
    child: Center(
      child: Text(
        '${tierKorName[tierTitle]} $tierLevel',
        style: simpleTierStyle.copyWith(fontSize: fontSize, fontWeight: FontWeight.w500),
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

AppBar primaryAppBarWithoutBackButton(String title) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: white,
    toolbarHeight: 60.w,
    title: Text(title, style: appBarTitle),
  );
}

Container appBarWithCloseButton({required String title, double? height}) {
  return Container(
    height: height ?? 60.w,
    color: white,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(),
        ),
        Center(child: Text(title, style: appBarTitle.copyWith(fontFamily: 'Default'))),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              'assets/icons/exit.png',
              width: 14.w,
              height: 14.w,
              color: yachtBlack,
            ),
          ),
        )
      ],
    ),
  );
}

Container appBarWithoutCloseButton({required String title, double? height}) {
  return Container(
    height: height ?? 60.w,
    color: white,
    child: Center(child: Text(title, style: appBarTitle.copyWith(fontFamily: 'Default'))),
  );
}

// 해쉬태그 컨테이너
Container feedHashTagContainer(String hashTag) => Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
      decoration: BoxDecoration(
        color: primaryButtonText,
        borderRadius: BorderRadius.circular(4.w),
      ),
      child: Text(
        hashTag,
        style: feedHashTag,
      ),
    );

Container socialLoginContainer({
  required Widget logo,
  required Widget title,
  required Color loginBackgroundColor,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 44.w),
    height: 60.w,
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.w),
      color: loginBackgroundColor,
    ),
    child: Row(
      children: [logo, Expanded(child: Center(child: title))],
    ),
  );
}

yachtSnackBar(String title) {
  return Get.rawSnackbar(
    messageText: Center(
      child: Text(
        title,
        style: snackBarStyle.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    snackPosition: SnackPosition.TOP,
    backgroundColor: white.withOpacity(.7),
    barBlur: 2,
    margin: EdgeInsets.only(top: 60.w),
    duration: const Duration(seconds: 1, milliseconds: 300),
    // animationDuration: const Duration(microseconds: 1000),
  );
}

yachtSnackBarFromBottom(
  String title, {
  int? longerDuration,
}) {
  return Get.rawSnackbar(
    messageText: Center(
      child: Text(
        title,
        style: snackBarStyle.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: white.withOpacity(.7),
    barBlur: 2,
    margin: EdgeInsets.only(bottom: 80.w + SizeConfig.safeAreaBottom),
    duration: Duration(milliseconds: longerDuration ?? 1300),
    // animationDuration: const Duration(microseconds: 1000),
  );
}

// 다이얼로그
// yachtDialog(String title)
Dialog yachtTierInfoPopUp(BuildContext context, int thisUserExp) {
  String thisUserTierTitle = separateStringFromTier(getTierByExp(thisUserExp));
  print(thisUserTierTitle);
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.w),
    ),
    insetPadding: primaryHorizontalPadding,
    child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(primaryPaddingSize, 0.0, primaryPaddingSize, primaryPaddingSize),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              appBarWithCloseButton(title: "티어"),
              SizedBox(height: correctHeight(8.w, 0.0, 0.0)),
              Column(children: [
                Row(
                  children: [
                    Expanded(child: Center(child: Text("티어 엠블럼", style: feedTitle))),
                    Expanded(child: Center(child: Text("필요 경험치", style: feedTitle)))
                  ],
                ),
                SizedBox(height: correctHeight(10.w, feedTitle.fontSize, 0.0)),
                ...List.generate(
                    tierSystemModelRx.value == null ? 0 : getOnlyTierTitle(tierSystemModelRx.value!.tierNames).length,
                    (index) {
                  bool isThisUserBelongthisTier =
                      getOnlyTierTitle(tierSystemModelRx.value!.tierNames)[index] == thisUserTierTitle;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          Container(
                            // color:
                            //     isThisUserBelongthisTier ? Colors.blue.withOpacity(.2) : Colors.yellow.withOpacity(.2),
                            height: 60.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Container(
                                        child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 120.w,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://storage.googleapis.com/ggook-5fb08.appspot.com/${tierJellyBeanURL[getOnlyTierTitle(tierSystemModelRx.value!.tierNames)[index]]!}",
                                        ),
                                      ),
                                      Text(
                                        '${tierKorName[getOnlyTierTitle(tierSystemModelRx.value!.tierNames)[index]]}',
                                        style: feedTitle,
                                      ),
                                    ],
                                  ),
                                ))),
                                Expanded(
                                  child: Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        index == 0
                                            ? 0.toString()
                                            : index == getOnlyTierTitle(tierSystemModelRx.value!.tierNames).length - 1
                                                ? "상위 1%"
                                                : getExpNeededForEachTierTitle(tierSystemModelRx.value!.tierNames,
                                                        tierSystemModelRx.value!.tierStops)[index - 1]
                                                    .toString(),
                                        style: buttonTitleStyle.copyWith(color: yachtBlack),
                                      ),
                                      Text(
                                        index == getOnlyTierTitle(tierSystemModelRx.value!.tierNames).length - 1
                                            ? ""
                                            : " ~ ",
                                        style: buttonTitleStyle.copyWith(color: yachtBlack),
                                      ),
                                      Text(
                                        index == getOnlyTierTitle(tierSystemModelRx.value!.tierNames).length - 2
                                            ? ""
                                            : index == getOnlyTierTitle(tierSystemModelRx.value!.tierNames).length - 1
                                                ? " "
                                                : getExpNeededForEachTierTitle(tierSystemModelRx.value!.tierNames,
                                                        tierSystemModelRx.value!.tierStops)[index]
                                                    .toString(),
                                        style: buttonTitleStyle.copyWith(color: yachtBlack),
                                      ),
                                    ],
                                  )),
                                )
                              ],
                            ),
                          ),
                          isThisUserBelongthisTier
                              ? Container(
                                  // width: 40,
                                  height: 1.w,
                                  color: yachtViolet,
                                )
                              : Container(),
                        ],
                      ),
                      Positioned.fill(
                        top: -60.w,
                        child: isThisUserBelongthisTier
                            ? Container(
                                // width: 300,
                                child: Row(children: [
                                  Expanded(
                                      child: Container(
                                    height: 1.w,
                                    color: yachtViolet,
                                  )),
                                  Padding(
                                    padding: primaryHorizontalPadding,
                                    child: Text(
                                      '현재 티어',
                                      style: TextStyle(
                                        color: yachtViolet,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: 1.w,
                                    color: yachtViolet,
                                  )),
                                ]),
                              )
                            : Container(),
                      ),
                    ],
                  );
                })
              ])
            ],
          ),
        )),
  );
}

//// 잡 위젯
// Dashed Line
Container dashedLine({
  required bool isVertical,
  required double length,
  required double dashedLength,
  required double thickness,
  required Color color,
}) {
  int numberOfDashes = length ~/ (dashedLength * 6 / 4);
  return Container(
    child: Column(
      children: List.generate(numberOfDashes * 2, (index) {
        return index % 2 == 0
            ? Container(
                height: dashedLength,
                width: thickness,
                color: color,
              )
            : Container(
                height: dashedLength / 2,
                width: thickness,
                color: Colors.transparent,
              );
      }),
    ),
  );
}

CustomHeader reloadHeader(bool isTopOfScreen) {
  RxString footer = "당겨서 새로고침".obs;
  return CustomHeader(
      builder: (_, status) {
        // status = RefreshStatus.
        return Container(
          height: isTopOfScreen ? SizeConfig.safeAreaTop + 20.w : 20.w,
          // color: Colors.blue,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              footer.value,
              style: TextStyle(fontSize: 14, fontFamily: 'Default'),
            ),
          ),
        );
      },
      height: isTopOfScreen ? SizeConfig.safeAreaTop + 20.w : 20.w,
      onModeChange: (mode) {
        if (mode == RefreshStatus.idle) {
          footer("당겨서 새로고침");
        } else if (mode == RefreshStatus.canRefresh) {
          footer("놓아주세요");
        } else if (mode == RefreshStatus.refreshing) {
          footer("새로고치는 중...");
        } else if (mode == RefreshStatus.completed) {
          footer("완료!");
        }
      });
}

class PrimaryWebView extends StatelessWidget {
  final String title;
  final String url;
  PrimaryWebView({Key? key, required this.title, required this.url}) : super(key: key);
  final GlobalKey webViewKey = GlobalKey();
  final RxDouble progessPercent = 0.0.obs;

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar(title),
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Container(
                  padding: EdgeInsets.all(10.0),
                  child: progessPercent.value < 1.0
                      ? LinearProgressIndicator(
                          value: progessPercent.value,
                          backgroundColor: primaryButtonText,
                          valueColor: AlwaysStoppedAnimation<Color>(yachtViolet),
                        )
                      : Container()),
            ),
            Expanded(
              child: InAppWebView(
                key: webViewKey,
                onProgressChanged: (controller, progress) {
                  // print('progress: $progress');
                  progessPercent(progress / 100);
                },
                initialUrlRequest: URLRequest(url: Uri.parse(url)),
                initialOptions: options,

                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                // onLoadStart: (controller, url) {
                //   setState(() {
                //     this.url = url.toString();
                //     urlController.text = this.url;
                //   });
                // },
                androidOnPermissionRequest: (controller, origin, resources) async {
                  return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
                },
                // shouldOverrideUrlLoading: (controller, navigationAction) async {

                onConsoleMessage: (controller, consoleMessage) {
                  // print(consoleMessage);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
