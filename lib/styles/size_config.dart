import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double safeAreaTop;
  static late double safeAreaBottom;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
    safeAreaTop = _mediaQueryData.padding.top;
    safeAreaBottom = _mediaQueryData.padding.bottom;
  }
}

// Get the proportionate height as per screen size
double reactiveHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double reactiveWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use

  return (inputWidth / 375.0) * screenWidth;
}

// text size get 함수. 공통적으로 쓸 수 있으므로 나중에 다른 폴더 / 다른 파일에 넣고 활용
// text 와 textStyle 을 넣으면 Text Widget의 크기가 얼마일지 Size 형식으로 반환해준다.
Size textSizeGet(String txt, TextStyle txtStyle) {
  return (TextPainter(
          text: TextSpan(text: txt, style: txtStyle),
          maxLines: 1,
          textDirection: TextDirection.ltr)
        ..layout())
      .size;
}
