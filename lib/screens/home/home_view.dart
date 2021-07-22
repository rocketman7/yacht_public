import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/subLeague/temp_home_view.dart';
import 'package:yachtOne/screens/home/live_widget.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_award_card_widget.dart';
import 'quest_widget.dart';

class HomeView extends StatelessWidget {
  HomeViewModel homeViewModel = Get.put(HomeViewModel());

  ScrollController _scrollController = ScrollController();
  RxDouble offset = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    Size temp = textSizeGet(
        "기간  퀘스트",
        homeHeaderName.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xFF789EC1)));
    _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    _scrollController.addListener(() {
      // offset obs 값에 scroll controller offset 넣어주기
      _scrollController.offset < 0
          ? offset(0)
          : offset(_scrollController.offset);
      print(offset);
    });

    print(
        'screen width: ${ScreenUtil().screenWidth} / screen height: ${ScreenUtil().screenHeight}');
    print('20.w is ${20.w}');
    print('20.sp is ${20.sp}');

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          Obx(
            () => SliverPersistentHeader(
                floating: false,
                pinned: true,
                delegate: _GlassmorphismAppBarDelegate(
                    MediaQuery.of(context).padding, offset.value)),
          ),
          // SliverAppBar(
          //   elevation: 0.0, // 스크롤했을 때 SliverAppbar 아래 shadow.
          //   // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          //   backgroundColor: primaryAppbarBackgroundColor,

          //   // textTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
          //   // title: Text("APP TITLE"),
          //   pinned: true,
          //   expandedHeight: 100,
          //   flexibleSpace: FlexibleSpaceBar(
          //     titlePadding: EdgeInsets.fromLTRB(16, 16, 0, 16),
          //     centerTitle: false,
          //     title: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.baseline,
          //       textBaseline: TextBaseline.alphabetic,
          //       children: [
          //         Text(
          //           "장한나",
          //           style: subtitleStyle.copyWith(
          //             color: Colors.black,
          //             // textBaseline: TextBaseline.alphabetic,
          //           ),
          //         ),
          //         Text(
          //           " 님의 요트",
          //           style: detailStyle.copyWith(
          //             color: Colors.grey,
          //             // textBaseline: TextBaseline.alphabetic,
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // 이달의 상금 주식
          SliverToBoxAdapter(
            child: Container(
              // color: Colors.blueGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: priamryHorizontalPadding,
                    // color: Colors.red,
                    child: Text("이 달의 상금 주식", style: homeModuleTitleTextStyle),
                  ),
                  btwHomeModuleTitleBox,
                  Center(
                    child: Container(
                      height: 150.w,
                      width: 275.w,
                      padding: moduleBoxPadding(20.w), // temp
                      decoration: primaryBoxDecoration.copyWith(
                          boxShadow: [primaryBoxShadow],
                          color: homeModuleBoxBackgroundColor),
                      child: Container(
                        // color: Colors.blue,
                        child: Text(
                          "기간 퀘스트 퀘스트 퀘",
                          style: questTermTextStyle,
                        ),
                      ),
                    ),
                  ),
                  belowHomeModule
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: btwHomeModule,
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: priamryHorizontalPadding,
                    // color: Colors.red,
                    child: Text("새로 나온 퀘스트", style: homeModuleTitleTextStyle),
                  ),
                  // btwHomeModuleTitleSlider,
                  Container(
                    // color: Colors.amber.withOpacity(.3),
                    // height: 340.w,
                    child: Obx(() {
                      return homeViewModel.allQuests.length ==
                              0 // 로딩 중과 length 0인 걸 구분해야 함
                          ? Container(
                              color: Colors.yellow,
                              // height: 340.w,
                            )
                          : Container(
                              height: 340.w + 2 * btwHomeModuleTitleBox.height!,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5, //homeViewModel.allQuests.length
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        index == 0
                                            ? SizedBox(
                                                width: kHorizontalPadding.left,
                                              )
                                            : Container(),
                                        InkWell(
                                          onTap: () {
                                            Get.toNamed('quest',
                                                arguments:
                                                    homeViewModel.allQuests[0]);
                                          },
                                          child: QuestWidget(
                                              questModel:
                                                  homeViewModel.allQuests[0]),
                                        ),
                                        horizontalSpaceLarge
                                      ],
                                    );
                                  }),
                            );
                    }),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 90,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              // height: 200,
              // color: Colors.amber,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: kHorizontalPadding,
                    child: Text(
                      "LIVE",
                      style: subtitleStyle,
                    ),
                  ),
                  verticalSpaceMedium,
                  Container(
                    // color: Colors.amber.withOpacity(.3),
                    height: reactiveHeight(280),
                    child: Obx(() {
                      return homeViewModel.allQuests.length == 0
                          ? Container(
                              color: Colors.yellow,
                              height: reactiveHeight(280),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                if (homeViewModel.allQuests[0].startDateTime
                                    .toDate()
                                    .isBefore(DateTime.now())) {
                                  return Row(
                                    children: [
                                      index == 0
                                          ? SizedBox(
                                              width: kHorizontalPadding.left,
                                            )
                                          : Container(),
                                      InkWell(
                                        onTap: () {
                                          Get.toNamed('quest',
                                              arguments:
                                                  homeViewModel.allQuests[0]);
                                        },
                                        child: LiveWidget(
                                            questModel:
                                                homeViewModel.allQuests[0]),
                                      ),
                                      horizontalSpaceLarge
                                    ],
                                  );
                                } else {
                                  return Container(
                                    height: 100,
                                    width: 100,
                                    color: Colors.blue,
                                  );
                                }
                              });
                    }),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.grey,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 1150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text("Go To Stock Info"),
                    onPressed: () {
                      Get.toNamed('stockInfo');
                    },
                  ),
                  ElevatedButton(
                    child: Text("Go To Design System"),
                    onPressed: () {
                      Get.toNamed('designSystem');
                    },
                  ),
                  ElevatedButton(
                    child: Text("Go To Quest View"),
                    onPressed: () {
                      Get.toNamed('quest',
                          arguments: homeViewModel.allQuests[0]);
                    },
                  ),
                  ElevatedButton(
                    child: Text("Count Test"),
                    onPressed: () {
                      print(DateTime.now());
                      FirestoreService().countTest(0);
                    },
                  ),
                  ElevatedButton(
                    child: Text("Go To Award View (Old)"),
                    onPressed: () {
                      Get.toNamed('awardold');
                    },
                  ),
                  HomeAwardCardWidget(),
                  ElevatedButton(
                    child: Text("Go To Temp Home for Sub League View"),
                    onPressed: () {
                      // Get.toNamed('tempHome');
                      Get.to(() => TempHomeView(
                            leagueName: '7월',
                          ));
                    },
                  ),
                  SizedBox(height: 100),
                  Container(
                    height: 200,
                    child: SvgPicture.asset(
                      'assets/icons/newYacht.svg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 100),
                  Container(
                    height: 200,
                    child: SvgPicture.asset(
                      'assets/icons/newYacht2.svg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassmorphismAppBarDelegate extends SliverPersistentHeaderDelegate {
  final EdgeInsets safeAreaPadding;
  final double offset;

  _GlassmorphismAppBarDelegate(this.safeAreaPadding, this.offset);

  @override
  double get minExtent => 60.h + ScreenUtil().statusBarHeight;

  @override
  double get maxExtent => minExtent + kToolbarHeight + 100.w;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Opacity(
          opacity: 0.8,
          child: Container(
            // Don't wrap this in any SafeArea widgets, use padding instead
            // padding: EdgeInsets.only(top: safeAreaPadding.top),
            height: maxExtent,
            color: primaryBackgroundColor,
            child: Padding(
              padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
              child: Center(
                  child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: offset.w > 18.w ? 6.w : 18.w - offset.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "장한나",
                            style: homeHeaderName,
                          ),
                        ),
                        Container(
                          // color: Colors.blue,
                          child: Text(
                            " 님의 요트",
                            style: homeHeaderAfterName,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: offset.w > 100.w ? 0 : 100.w - offset.w,
                    color: Colors.blue,
                  ),
                ],
              )),
            ),
            // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
            // child: Stack(
            //   clipBehavior: Clip.none,
            //   children: <Widget>[
            //     Positioned(
            //       bottom: 0,
            //       left: 0,
            //       right: 0,
            //       child: AppBar(
            //         primary: true,
            //         elevation: 0,
            //         backgroundColor: Colors.transparent,
            //         title: Text("Translucent App Bar"),
            //       ),
            //     )
            // ],
            // ),
          )),
    ));
  }

  @override
  bool shouldRebuild(_GlassmorphismAppBarDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return maxExtent != oldDelegate.maxExtent ||
        minExtent != oldDelegate.minExtent ||
        safeAreaPadding != oldDelegate.safeAreaPadding;
  }
}
