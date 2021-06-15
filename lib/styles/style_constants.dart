import 'package:flutter/material.dart';
import 'size_config.dart';

const kPrimaryBackGroundColorLight = Colors.white;
// Color(0xFFF1FFE9);
const kPrimaryColor = Color(0xFFFF7643);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

// k-Bull & Bear Color
const bullColorKR = Color(0xFFEB3A4F);
const bearColorKR = Color(0xFF0091D5);

// Volume Color
Color volumeColor = Color(0xFF607D8B).withOpacity(.5);

// Income Statement Bar Chart & Line Chart Color
Color barColor1 = Color(0xFF607D8B).withOpacity(.3);
Color barColor2 = Color(0xFF607D8B).withOpacity(.5);
Color barColor3 = Color(0xFF607D8B).withOpacity(.7);
Color barColor4 = Color(0xFF607D8B).withOpacity(.9);
// Color accLineColor = Color(0xFFFAAC00).withOpacity(.8);

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
const horizontalSpaceExtraLarge = SizedBox(width: 32);
const horizontalSpaceLarge = SizedBox(width: 24);
const horizontalSpaceMedium = SizedBox(width: 16);
const horizontalSpaceSmall = SizedBox(width: 8);
const kHorizontalPadding = EdgeInsets.symmetric(horizontal: 16);
const kSymmetricPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 16);

// Font Style
final headingStyleEN = TextStyle(
  fontSize: getProportionateScreenHeight(27.5),
  fontWeight: FontWeight.w700,
  fontFamily: 'DmSans',
  color: Colors.black,
  letterSpacing: -0.5,
  height: 1.1,
);

final bigTitleStyle = TextStyle(
  fontSize: getProportionateScreenHeight(34),
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  letterSpacing: -0.5,
  height: 1.1,
);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenHeight(26),
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  letterSpacing: -0.5,
  height: 1.1,
);

final titleStyle = TextStyle(
  fontSize: getProportionateScreenHeight(24),
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  letterSpacing: -1,
  height: 1.1,
);

final subtitleStyle = TextStyle(
  fontSize: getProportionateScreenHeight(20),
  fontWeight: FontWeight.w700,
  fontFamily: 'NotoSansKR',
  color: Color(0xff212121),
  letterSpacing: -1,
  height: 1.1,
);

final contentStyle = TextStyle(
    fontSize: getProportionateScreenHeight(16),
    fontWeight: FontWeight.w500,
    fontFamily: 'NotoSansKR',
    letterSpacing: -.5,
    height: 1.1);
final detailStyle = TextStyle(
    fontSize: getProportionateScreenHeight(14),
    fontWeight: FontWeight.w500,
    fontFamily: 'NotoSansKR',
    letterSpacing: -.5,
    height: 1.1);

// 숫자 스타일

final ohlcInfoStyle = TextStyle(
    fontSize: getProportionateScreenHeight(16),
    fontWeight: FontWeight.w400,
    fontFamily: 'NotoSansKR',
    letterSpacing: -0.5,
    height: 1.1);

final ohlcPriceStyle = TextStyle(
    fontSize: getProportionateScreenHeight(18),
    fontWeight: FontWeight.w500,
    fontFamily: 'DmSans',
    letterSpacing: -0.5,
    height: 1.1);

final detailPriceStyle = TextStyle(
    fontSize: getProportionateScreenHeight(16),
    fontWeight: FontWeight.w700,
    fontFamily: 'DmSans',
    letterSpacing: -0.5,
    height: 1.1);

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
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
