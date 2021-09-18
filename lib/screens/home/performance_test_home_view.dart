import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/subLeague/temp_home_view.dart';

import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../quest/quest_widget.dart';

class PerformanceTestHomeView extends StatelessWidget {
  HomeViewModel homeViewModel = Get.put(HomeViewModel());

  ScrollController _scrollController = ScrollController();
  RxDouble offset = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    List<Widget> homeWidgets = [
      MyAssets(),

      // 이달의 상금 주식
      SizedBox(height: reducedPaddingWhenTextIsBelow(30.w, homeModuleTitleTextStyle.fontSize!)),
      Awards(),
      btwHomeModule,
      NewQuests(homeViewModel: homeViewModel),
      btwHomeModule,
      LiveQuests(),
      // SliverToBoxAdapter(child: SizedBox(height: 100)),
      OldLiveQuests(homeViewModel: homeViewModel),
      // SliverToBoxAdapter(child: Container(height: 200, color: Colors.grey)),
      Admins(homeViewModel: homeViewModel),
    ];

    Size temp = textSizeGet(
        "기간  퀘스트", homeHeaderName.copyWith(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF789EC1)));
    _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    _scrollController.addListener(() {
      // offset obs 값에 scroll controller offset 넣어주기
      _scrollController.offset < 0 ? offset(0) : offset(_scrollController.offset);
      // print(offset);
    });

    return Scaffold(
      body: CustomScrollView(
        semanticChildCount: 3,
        controller: _scrollController,
        slivers: [
          // 앱바
          Obx(
            () => SliverPersistentHeader(
                floating: false,
                pinned: true,
                delegate: _GlassmorphismAppBarDelegate(MediaQuery.of(context).padding, offset.value)),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              return homeWidgets[index];
            }, childCount: homeWidgets.length),
          ),
          // MyAssets(),
          // SliverToBoxAdapter(
          //     child: SizedBox(
          //         height: reducedPaddingWhenTextIsBelow(
          //             30.w, homeModuleTitleTextStyle.fontSize!))),
          // // 이달의 상금 주식
          // Awards(),
          // SliverToBoxAdapter(child: btwHomeModule),
          // NewQuests(homeViewModel: homeViewModel),
          // SliverToBoxAdapter(child: btwHomeModule),
          // LiveQuests(),
          // SliverToBoxAdapter(child: SizedBox(height: 100)),
          // OldLiveQuests(homeViewModel: homeViewModel),
          // SliverToBoxAdapter(child: Container(height: 200, color: Colors.grey)),
          // Admins(homeViewModel: homeViewModel),
        ],
      ),
    );
  }
}

class Admins extends StatelessWidget {
  const Admins({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Get.toNamed('quest', arguments: homeViewModel.allQuests[0]);
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
    );
  }
}

class OldLiveQuests extends StatelessWidget {
  const OldLiveQuests({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        if (homeViewModel.allQuests[0].liveStartDateTime.toDate().isBefore(DateTime.now())) {
                          return Row(
                            children: [
                              index == 0
                                  ? SizedBox(
                                      width: kHorizontalPadding.left,
                                    )
                                  : Container(),
                              InkWell(
                                onTap: () {
                                  Get.toNamed('quest', arguments: homeViewModel.allQuests[0]);
                                },
                                // child: LiveWidget(questModel: homeViewModel.allQuests[0]),
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
    );
  }
}

class LiveQuests extends StatelessWidget {
  const LiveQuests({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: primaryHorizontalPadding,
          // color: Colors.red,
          child: Text("라이브", style: homeModuleTitleTextStyle),
        ),
      ],
    );
  }
}

class NewQuests extends StatelessWidget {
  const NewQuests({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: primaryHorizontalPadding,
          // color: Colors.red,
          child: Text("새로 나온 퀘스트", style: homeModuleTitleTextStyle),
        ),
        // btwHomeModuleTitleSlider,
        Container(
          // color: Colors.amber.withOpacity(.3),
          // height: 340.w,
          child: Obx(() {
            return homeViewModel.allQuests.length == 0 // 로딩 중과 length 0인 걸 구분해야 함
                ? Container(
                    color: Colors.yellow,
                    // height: 340.w,
                  )
                : Container(
                    height: 340.w + 2 * btwHomeModuleTitleBox.height!,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: homeViewModel.newQuests.length,
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
                                  Get.toNamed('quest', arguments: homeViewModel.newQuests[index]);
                                },
                                child: QuestWidget(questModel: homeViewModel.newQuests[index]),
                              ),
                              horizontalSpaceLarge
                            ],
                          );
                        }),
                  );
          }),
        )
      ],
    );
  }
}

class Awards extends StatelessWidget {
  const Awards({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blueGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: primaryHorizontalPadding,
            // color: Colors.red,
            child: Text("이 달의 상금 주식", style: homeModuleTitleTextStyle),
          ),
          btwHomeModuleTitleBox,
          Center(
            child: Container(
              height: 150.w,
              width: 275.w,
              padding: moduleBoxPadding(20.w), // temp
              decoration:
                  primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow], color: homeModuleBoxBackgroundColor),
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
    );
  }
}

class MyAssets extends StatelessWidget {
  const MyAssets({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: offset.w > 100.w ? 0 : 100.w - offset.w,
      height: 100.w,
      color: Colors.blue.withOpacity(.2),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/won_pointBlue_background.svg',
                        width: 20.w,
                        height: 20.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "주식 잔고",
                        style: detailedContentTextStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: reducedPaddingWhenTextIsBelow(14.w, detailedContentTextStyle.fontSize!)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("351,530", style: homeHeaderName.copyWith(fontWeight: FontWeight.w500)),
                      Text(" 원", style: homeHeaderName.copyWith(fontWeight: FontWeight.w300)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(
            color: primaryFontColor.withOpacity(.5),
            indent: 16.w,
            endIndent: 16.w,
          ),
          Expanded(
              child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/yacht_point.svg',
                      width: 20.w,
                      height: 20.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "요트 포인트",
                      style: detailedContentTextStyle,
                    ),
                  ],
                ),
                SizedBox(height: reducedPaddingWhenTextIsBelow(14.w, detailedContentTextStyle.fontSize!)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("351,530", style: homeHeaderName.copyWith(fontWeight: FontWeight.w500)),
                    Text(" 원", style: homeHeaderName.copyWith(fontWeight: FontWeight.w300)),
                  ],
                ),
              ],
            ),
          ))
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
  double get maxExtent => minExtent + kToolbarHeight - 40.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
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
