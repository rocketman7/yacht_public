import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../styles/yacht_design_system.dart';

import 'yacht_store_controller.dart';
import 'yacht_store_local_DB.dart';

class YachtStoreView extends StatelessWidget {
  final YachtStoreController yachtStoreController = Get.put(YachtStoreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: yachtStoreController.scrollController,
        slivers: [
          Obx(() => SliverPersistentHeader(
                floating: false,
                pinned: true,
                delegate: YachtStoreAppBarDelegate(
                    offset: yachtStoreController.offset.value,
                    tabTitle: '요트 포인트 스토어',
                    buttonWidget: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 14.w,
                          ),
                          Image.asset(
                            'assets/buttons/exit.png',
                            width: 30.w,
                            height: 30.w,
                          ),
                        ],
                      ),
                    )),
              )),
          Obx(() => SliverPersistentHeader(
                pinned: true,
                delegate: YachtStoreSectionHeaderDelegate(
                    offset: yachtStoreController.offset.value,
                    child: Container(
                      height: 150.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 8.w, bottom: 8.w),
                            child: Container(
                              decoration: BoxDecoration(color: yachtPaleGreen, borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.all(14.w),
                                child: Container(
                                  height: 24.w,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '나의 요트 포인트',
                                        style: yachtStoreTextStyle,
                                      ),
                                      Spacer(),
                                      Image.asset(
                                        'assets/icons/yachtGem.png',
                                        width: 24.w,
                                        height: 24.w,
                                      ),
                                      Text(
                                        '250,000원',
                                        style: yachtStoreTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              height: 74.w,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: yachtStoreCategories.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        SizedBox(
                                          width: 14.w,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              yachtStoreController.categorySelect(index);
                                            },
                                            child: Obx(
                                              () => Container(
                                                width: 80.w,
                                                height: 74.w,
                                                decoration: BoxDecoration(
                                                  color: index == yachtStoreController.categoryIndex.value
                                                      ? yachtPaleGrey.withOpacity(0.3)
                                                      : Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      yachtStoreCategories[index].categoryImgDir,
                                                      width: 50.w,
                                                      height: 50.w,
                                                    ),
                                                    Container(
                                                      height: 20.w,
                                                      child: Text(
                                                        '${yachtStoreCategories[index].categoryName}',
                                                        style: yachtStoreCategoryTextStyle.copyWith(
                                                            color: index == yachtStoreController.categoryIndex.value
                                                                ? yachtGreen
                                                                : yachtGrey),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 4.w,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          width: index == yachtStoreCategories.length - 1 ? 14.w : 0.w,
                                        )
                                      ],
                                    );
                                  })),
                          SizedBox(
                            height: 8.w - 1.w,
                          ),
                          Container(
                            height: 1.w,
                            color: yachtLightGrey,
                          )
                        ],
                      ),
                    ),
                    height: 150.w),
              )),
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
              children: [
                Container(
                  height: 400.w,
                  color: Colors.red,
                ),
                Container(
                  height: 400.w,
                  color: Colors.blue,
                ),
                Container(
                  height: 400.w,
                  color: Colors.grey,
                ),
              ],
            )
          ])),
        ],
      ),
    );
  }
}

// 요트 스토어 전용 앱바 extends YachtPrimaryAppBarDelegate
class YachtStoreAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double offset;
  final String tabTitle;
  final Widget? buttonWidget;
  YachtStoreAppBarDelegate({
    required this.offset,
    required this.tabTitle,
    this.buttonWidget,
  });

  @override
  double get minExtent => 52.w + ScreenUtil().statusBarHeight;

  @override
  double get maxExtent => minExtent + 38.w;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return maxExtent != oldDelegate.maxExtent || minExtent != oldDelegate.minExtent;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double opacity = offset > 30.w ? 1 : offset / 30.w;
    return ClipRect(
      child: Container(
        height: maxExtent,
        color: primaryBackgroundColor,
        child: Column(
          children: [
            SizedBox(height: ScreenUtil().statusBarHeight),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    primaryPaddingSize,
                    0,
                    primaryPaddingSize,
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
                              style: appBarTitle.copyWith(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w600,
                                color: appBarTitle.color!.withOpacity(
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
                                  style: appBarTitle.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: appBarTitle.color!.withOpacity(
                                        1 - opacity,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      buttonWidget != null
                          ? Positioned(
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
      ),
    );
  }
}

class YachtStoreSectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double offset;
  final Widget child;
  final double height;

  YachtStoreSectionHeaderDelegate({required this.offset, required this.child, required this.height});

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    double topPadding = offset < 38.w ? 14.w : max(14.w - (offset - 38.w), 0.w);

    return ClipRect(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            height: topPadding,
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: child,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => height + 14.w;

  @override
  double get minExtent => height;

  @override
  // bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return offset > 38.w || offset < 52.w;
  }
}

class YachtStoreGoodsCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
