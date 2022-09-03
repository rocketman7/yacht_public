import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

import 'yds_color.dart';

BoxDecoration defaultBoxDecoration = BoxDecoration(
  color: yachtDarkGrey,
  borderRadius: BorderRadius.circular(12.w),
);

Container defaultContainer({
  required Widget child,
  double? height,
  EdgeInsets? padding,
}) {
  return Container(
    height: height,
    padding: padding ?? defaultPaddingAll,
    // padding: defaultPaddingAll,
    decoration: defaultBoxDecoration,
    child: child,
  );
}
