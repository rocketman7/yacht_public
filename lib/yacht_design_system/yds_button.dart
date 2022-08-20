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
