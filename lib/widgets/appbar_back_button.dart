import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 앱 바 백버튼 기본. appbar => leading : AppBarBackButton()
class AppBarBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.back();
      },
      child: Container(
        // color: Colors.grey,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/navigate_back_arrow.svg',
            height: 30.w,
            width: 30.w,
          ),
        ),
      ),
    );
  }
}
