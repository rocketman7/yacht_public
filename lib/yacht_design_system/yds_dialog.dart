import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/yacht_design_system/yds_button.dart';
import 'package:yachtOne/yacht_design_system/yds_color.dart';
import 'package:yachtOne/yacht_design_system/yds_font.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

Dialog infoDialog(
  BuildContext context, {
  String? title,
  String? info,
  String? subInfo,
}) {
  return Dialog(
    backgroundColor: Colors.transparent,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(12.w),
    // ),
    insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
    child: Container(
      padding: defaultPaddingAll.copyWith(top: 0),
      decoration: BoxDecoration(
        color: yachtDarkGrey,
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          height: 60.w,
          child: Center(
            child: Text(
              title ?? "알림",
              style: head3Style.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        info != null
            ? Text(
                info,
                textAlign: TextAlign.center,
                style: body1Style.copyWith(height: 1.4.w),
              )
            : SizedBox.shrink(),
        subInfo != null
            ? Column(
                children: [
                  SizedBox(
                    height: 8.w,
                  ),
                  Text(
                    subInfo,
                    style: bodyP2Style.copyWith(height: 1.4.w),
                  ),
                ],
              )
            : SizedBox.shrink(),
        SizedBox(
          height: 16.w,
        ),
        GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: confirmDialogButton())
      ]),
    ),
  );
}
