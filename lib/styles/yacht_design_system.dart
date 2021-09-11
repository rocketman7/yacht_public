import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

// BASIC COLORS CODE
const Color yachtBlack = const Color(0xFF101214);
const Color yachtViolet = const Color(0xFF798AE6);
const Color yachtDarkGrey = const Color(0xFF5B6A87);
const Color yachtGrey = const Color(0xFF879098);
const Color yachtRed = const Color(0xFFEE5076);
const Color seaBlue = Color(0xFF489EDD);
const Color primaryButtonText = const Color(0xFFEFF2FA);
const Color primaryButtonBackground = yachtViolet;
const Color secondaryButtonText = yachtViolet;
const Color secondaryButtonBackground = const Color(0xFFEFF2FA);

const Color buttonDisabled = const Color(0xFFE6E6E6);
const Color buttonNormal = const Color(0xFFEFF2FA);
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

// Area graph Color
Color graph0 = Color(0xFF5568CF).withOpacity(.55);
Color graph1 = Color(0xFF55C0CF).withOpacity(.55);
Color graph2 = Color(0xFF9255CF).withOpacity(.55);
Color graph3 = Color(0xFF55CF69).withOpacity(.55);
Color graph4 = Color(0xFF558DCF).withOpacity(.55);

const activatedButtonColor = Color(0xFF196AB4);
Color dividerColor = Color(0xFF94BDE0).withOpacity(0.3);

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
  hintText: "이메일 입력하기",
  hintStyle: emailRegisterFieldHint,
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
  fontSize: 20.w,
  fontWeight: FontWeight.w700,
  color: Colors.white,
  letterSpacing: -1.0,
  height: 1.4,
);

// 홈-상금-상금상세-상금액수
TextStyle subLeagueAwardTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 36.w,
  fontWeight: FontWeight.w700,
  color: Colors.white,
  letterSpacing: -0.25,
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
  fontWeight: FontWeight.w500,
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
  fontWeight: FontWeight.w500,
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
  fontSize: 30.w,
  fontWeight: FontWeight.w700,
  color: Colors.white,
  letterSpacing: -0.25,
  height: 1.4,
);
// 홈-상금박스-상금액수한글
TextStyle awardModuleSliderAmountKoreanTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w300,
  color: Colors.white,
  letterSpacing: 5.75,
  height: 1.4,
);
// 홈-상금박스-상금기한
TextStyle awardModuleSliderEndDateTimeTextStyle = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w300,
  color: Colors.white,
  letterSpacing: -0.25,
  height: 1.4,
);

// 상금박스의 색깔.
const List<Color> awardColors = [
  Color(0xFF87C7EC),
  Color(0xFF489EDD),
  Color(0xFF196AB4),
  // Color(0xFF084176)
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
  color: primaryButtonBackground,
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
  letterSpacing: -1.0,
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
  String text,
) {
  return Container(
    // alignment: Alignment.center,
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
    decoration: BoxDecoration(
      color: primaryButtonText,
      borderRadius: BorderRadius.circular(50),
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: simpleTextButtonStyle,
    ),
  );
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
              color: primaryButtonText,
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

Container simpleTierRRectBox({String tier = "newbie", double? fontSize, double width = 70}) {
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
    case 'grandmaster':
      tierColor = tierGrandMaster;
      tierName = "그랜드마스터";
      break;
    default:
      tierColor = tierNewbie;
  }
  return Container(
    // width: width.w,
    // height: (width / 3.75).w,
    decoration: BoxDecoration(color: tierColor, borderRadius: BorderRadius.circular(50)),
    child: Center(
      child: Text(
        '$tierName',
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
    backgroundColor: white.withOpacity(.5),
    barBlur: 2,
    margin: EdgeInsets.only(top: 60.w),
    duration: const Duration(seconds: 1, milliseconds: 300),
    // animationDuration: const Duration(microseconds: 1000),
  );
}

yachtSnackBarFromBottom(String title) {
  return Get.rawSnackbar(
    messageText: Center(
      child: Text(
        title,
        style: snackBarStyle.copyWith(fontWeight: FontWeight.w500),
      ),
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: white.withOpacity(.5),
    barBlur: 2,
    margin: EdgeInsets.only(bottom: 80.w + SizeConfig.safeAreaBottom),
    duration: const Duration(seconds: 1, milliseconds: 300),
    // animationDuration: const Duration(microseconds: 1000),
  );
}

// 다이얼로그
// yachtDialog(String title)
