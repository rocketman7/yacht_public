import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_font.dart';

BorderRadius defaultBorderRadius = BorderRadius.circular(8.w);

Container confirmDialogButton({String? text}) {
  return Container(
    height: 50.w,
    decoration: BoxDecoration(
      borderRadius: defaultBorderRadius,
      color: yachtViolet,
    ),
    child: Center(
        child: Text(
      text ?? "확인",
      style: body1Style,
    )),
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
            ? simpleTextButtonStyle.copyWith(color: yachtLightGrey, fontSize: heading5Size)
            : simpleTextButtonStyle.copyWith(fontSize: heading5Size, color: primaryButtonText),
      ),
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
      borderRadius: BorderRadius.circular(8.w),
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

Container simpleTextContainerButton(
  String text, {
  Widget? child,
}) {
  return Container(
      // alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
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

// Basic Info Button
Container basicInfoButtion(
  String text, {
  Widget? loadingWidget,
  Color? buttonColor,
  Color? textColor,
  Widget? child,
}) {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: 8.w,
      vertical: 4.w,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4.w),
      color: buttonColor ?? yachtGrey,
    ),
    child: child ??
        Text(
          text,
          style: TextStyle(
            color: textColor ?? white,
            fontWeight: FontWeight.w700,
          ),
        ),
  );
}
