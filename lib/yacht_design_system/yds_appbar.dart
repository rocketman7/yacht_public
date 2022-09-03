// 왼쪽 상단에 타이틀 띄우고 스크롤 내릴 때 타이틀 사라지며 가운데에 작게 나타나는 앱바
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/yacht_design_system/yds_color.dart';
import 'package:yachtOne/yacht_design_system/yds_font.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

class YachtPrimaryAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double offset;
  final String tabTitle;
  final Widget? buttonWidget;
  final String? buttonPosition;
  YachtPrimaryAppBarDelegate({
    required this.offset,
    required this.tabTitle,
    this.buttonWidget,
    this.buttonPosition,
  });

  @override
  double get minExtent => 52.w + ScreenUtil().statusBarHeight;

  @override
  double get maxExtent => minExtent + 38.w;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return maxExtent != oldDelegate.maxExtent || minExtent != oldDelegate.minExtent;
    // ||
    // safeAreaPadding != oldDelegate.safeAreaPadding;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double opacity = offset > 30.w ? 1 : offset / 30.w;
    // TODO: implement build
    // print(offset);
    return ClipRect(
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            // color: Colors.blue,
            // Don't wrap this in any SafeArea widgets, use padding instead
            // padding: EdgeInsets.only(top: safeAreaPadding.top),

            height: maxExtent,
            color: yachtBlack.withOpacity(.65),
            // color: Colors.blue.withOpacity(.65),

            child: Column(
              children: [
                SizedBox(height: ScreenUtil().statusBarHeight),
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        defaultPaddingSize,
                        0,
                        defaultPaddingSize,
                        0,
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tabTitle,
                                  style: head3Style.copyWith(
                                    fontSize: 18.w,
                                    fontWeight: FontWeight.w600,
                                    color: yachtWhite.withOpacity(
                                      opacity,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      tabTitle,
                                      style: head2Style.copyWith(
                                          // fontWeight: FontWeight.w600,
                                          color: yachtWhite.withOpacity(
                                        1 - opacity,
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          buttonWidget != null
                              ? buttonPosition == 'left'
                                  ? Positioned(
                                      top: 12.w,
                                      left: 0,
                                      child: buttonWidget!,
                                    )
                                  : buttonPosition == 'right-center'
                                      ? Align(
                                          alignment: Alignment(1, 1 - opacity),
                                          // top: 12.w,
                                          // bottom: 0,
                                          // right: 0,
                                          child: buttonWidget!,
                                        )
                                      : Positioned(
                                          top: 12.w,
                                          right: 0,
                                          child: buttonWidget!,
                                        )
                              : Container(),
                        ],
                      )),
                ),
              ],
            ),
          )),
    );
  }
}

// 백버튼과 타이틀이 있는 기본 앱 바
AppBar defaultAppBar(String title) {
  return AppBar(
    backgroundColor: yachtBlack,
    toolbarHeight: 60.w,
    title: Text(title, style: head3Style.copyWith(fontWeight: FontWeight.w700)),
  );
}
