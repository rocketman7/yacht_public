import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/reading_content_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/award/award_view.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_view.dart';
import 'package:yachtOne/screens/contents/today_market/today_market_view.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/subLeague/temp_home_view.dart';
import 'package:yachtOne/screens/home/live_widget.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import '../../locator.dart';

import 'quest_widget.dart';

class HomeView extends StatelessWidget {
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  AuthService _authService = locator<AuthService>();

  ScrollController _scrollController = ScrollController();
  RxDouble offset = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    List<Widget> homeWidgets = [
      MyAssets(),
      // sign out 임시
      InkWell(
        onTap: () {
          _authService.auth.signOut();
          // homeViewModel.dispose();
          Get.reset();
          print("signout");
        },
        child: Container(
            // color: Colors.blue,
            width: 300.w,
            height: correctHeight(30.w, sectionTitle.fontSize!, 0.0)),
      ),
      // 이달의 상금 주식
      AwardView(leagueName: "9월 리그", leagueEndDateTime: "20210930"),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      NewQuests(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      LiveQuests(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      QuestResults(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      ReadingContentView(homeViewModel: homeViewModel), // showingHome 변수 구분해서 넣는 게
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      TodayMarketView(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(150.w, 0.0, sectionTitle.fontSize)),
      // SliverToBoxAdapter(child: SizedBox(height: 100)),
      // OldLiveQuests(homeViewModel: homeViewModel),
      // SliverToBoxAdapter(child: Container(height: 200, color: Colors.grey)),
      Admins(homeViewModel: homeViewModel),
    ];

    _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    _scrollController.addListener(() {
      // offset obs 값에 scroll controller offset 넣어주기
      _scrollController.offset < 0 ? offset(0) : offset(_scrollController.offset);
      // print(offset);
    });

    print('screen width: ${ScreenUtil().screenWidth} / screen height: ${ScreenUtil().screenHeight}');

    if (userQuestModelRx.length != 0) print('내가 참여한 퀘스트: ${userQuestModelRx[0].selectDateTime != null} ');

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // 앱바
          Obx(
            () => SliverPersistentHeader(
                floating: false,
                pinned: true,
                // 홈 뷰 앱바 구현
                delegate: _GlassmorphismAppBarDelegate(MediaQuery.of(context).padding, offset.value, homeViewModel)),
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
          //             30.w, sectionTitle.fontSize!))),
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

class QuestResults extends StatelessWidget {
  final HomeViewModel homeViewModel;
  const QuestResults({Key? key, required this.homeViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: primaryHorizontalPadding,
          // color: Colors.red,
          child: Text("퀘스트 결과보기", style: sectionTitle),
        ),
        SizedBox(
          height: heightSectionTitleAndBox,
        ),
        Container(
          // color: Colors.amber.withOpacity(.3),
          // height: 340.w,
          child: Obx(() {
            return (homeViewModel.allQuests.length == 0) // 로딩 중과 length 0인 걸 구분해야 함
                ? Container(
                    color: Colors.yellow,
                    // height: 340.w,
                  )
                : SingleChildScrollView(
                    clipBehavior: Clip.none,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(
                      5,
                      (index) => Row(
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
                              child: Container(
                                height: 180.w,
                                width: 232.w,
                                decoration: primaryBoxDecoration.copyWith(
                                  boxShadow: [primaryBoxShadow],
                                  color: homeModuleBoxBackgroundColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: moduleBoxPadding(questTermTextStyle.fontSize!),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            // '${questModel.category} 퀘스트',
                                            '일간 퀘스트',
                                            style: subheadingStyle,
                                          ),
                                          SizedBox(height: 6.w),
                                          Text(
                                            '${homeViewModel.allQuests[0].title}',
                                            style: sectionTitle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.dialog(Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding: EdgeInsets.all(16.w),
                                            child: Container(
                                              // height: 400.w,
                                              decoration: primaryBoxDecoration.copyWith(
                                                color: homeModuleBoxBackgroundColor,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height: 60.w,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        // Text("x"),
                                                        Text(
                                                          "퀘스트 결과보기",
                                                          style: questTitleTextStyle,
                                                        ),
                                                        // Text("x"),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 1.w,
                                                    width: double.infinity,
                                                    color: Color(0xFF94BDE0).withOpacity(.5),
                                                  ),
                                                  Container(
                                                    padding: moduleBoxPadding(questTermTextStyle.fontSize!),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    // '${questModel.category} 퀘스트',
                                                                    '일간 퀘스트',
                                                                    style: questTermTextStyle,
                                                                  ),
                                                                  SizedBox(
                                                                      height: reducedPaddingWhenTextIsBothSide(
                                                                          18.w,
                                                                          questTermTextStyle.fontSize!,
                                                                          questTitleTextStyle.fontSize!)),
                                                                  Text(
                                                                    '${homeViewModel.allQuests[0].title}',
                                                                    style: questTitleTextStyle,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SvgPicture.asset(
                                                              'assets/icons/quest_success.svg',
                                                              width: 72.w,
                                                              height: 72.w,
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 20.w,
                                                        ),
                                                        Container(
                                                          height: 66.w,
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            // mainAxisAlignment:
                                                            //     MainAxisAlignment
                                                            //         .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    children: [
                                                                      Text("나의 선택",
                                                                          style: smallSubtitleTextStyle.copyWith(
                                                                              fontWeight: FontWeight.w300)),
                                                                      Text(
                                                                        "상승",
                                                                        style: questTitleTextStyle.copyWith(
                                                                            fontSize: 24.w),
                                                                      )
                                                                    ]),
                                                              ),
                                                              VerticalDivider(
                                                                thickness: 1.w,
                                                                color: Color(0xFF94BDE0).withOpacity(.5),
                                                              ),
                                                              Expanded(
                                                                child: Column(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    mainAxisSize: MainAxisSize.max,
                                                                    children: [
                                                                      Text("결과",
                                                                          style: smallSubtitleTextStyle.copyWith(
                                                                              fontWeight: FontWeight.w300)),
                                                                      Text(
                                                                        "상승",
                                                                        style: questTitleTextStyle.copyWith(
                                                                            fontSize: 24.w),
                                                                      )
                                                                    ]),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: reducedPaddingWhenTextIsBelow(
                                                                30.w, smallSubtitleTextStyle.fontSize!)),
                                                        Text("퀘스트 성공 보상", style: smallSubtitleTextStyle),
                                                        SizedBox(
                                                          height: reducedPaddingWhenTextIsBothSide(
                                                              20.w, smallSubtitleTextStyle.fontSize!, 0),
                                                        ),
                                                        Column(
                                                          children: [
                                                            Row(children: [
                                                              Row(children: [
                                                                SvgPicture.asset(
                                                                  'assets/icons/league_point.svg',
                                                                  width: 27.w,
                                                                  height: 27.w,
                                                                ),
                                                                SizedBox(
                                                                  width: 6.w,
                                                                ),
                                                                Text("승점", style: questRewardTextStyle)
                                                              ])
                                                            ]),
                                                            SizedBox(
                                                              height: 14.w,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    SvgPicture.asset(
                                                                      'assets/icons/yacht_point.svg',
                                                                      width: 27.w,
                                                                      height: 27.w,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 6.w,
                                                                    ),
                                                                    Text("요트 포인트", style: questRewardTextStyle),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 14.w,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Obx(() => Text(
                                                                    'exp testing ${userModelRx.value!.exp.toString()}',
                                                                    style: questRewardTextStyle)),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )));
                                        // Get.defaultDialog(
                                        //     title: '',
                                        //     titleStyle:
                                        //         TextStyle(fontSize: 0),
                                        //     content: Container(
                                        //       height: 40.w,
                                        //       width: 40.w,
                                        //       color: Colors.blue,
                                        //     ));
                                      },
                                      child: Container(
                                          height: 40.w,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Color(0xFFDCE9F4),
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(12.w),
                                                  bottomRight: Radius.circular(12.w))),
                                          child: Center(
                                            child: Text(
                                              "결과 보기",
                                              style: cardButtonTextStyle,
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              )),
                          horizontalSpaceLarge
                        ],
                      ),
                    )),
                  );
          }),
        )
      ],
    );
  }
}

class LiveQuests extends StatelessWidget {
  final HomeViewModel homeViewModel;
  const LiveQuests({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("live quest view built");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: primaryPaddingSize),
          // color: Colors.red,
          child: Text("퀘스트 생중계", style: sectionTitle),
        ),
        SizedBox(
          height: heightSectionTitleAndBox,
        ),
        Obx(() {
          return (homeViewModel.allQuests.length == 0) // 로딩 중과 length 0인 걸 구분해야 함
              ? Container(
                  color: Colors.yellow,
                  // height: 340.w,
                )
              : SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(
                          5,
                          (index) => Row(
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
                                    child: LiveWidget(
                                      questModel: homeViewModel.allQuests[0],
                                    ),
                                  ),
                                  horizontalSpaceLarge
                                ],
                              )))

                  //     'user quest model length: ${userQuestModelRx == null}');

                  );
        })
      ],
    );
  }
}

class NewQuests extends StatelessWidget {
  final HomeViewModel homeViewModel;
  const NewQuests({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: primaryHorizontalPadding,
          // color: Colors.red,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  // color: Colors.blue,
                  child: Text("새로 나온 퀘스트", style: sectionTitle.copyWith(height: 1.0))),
              Spacer(),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
                    decoration: jogabiButtonBoxDecoration.copyWith(boxShadow: [primaryBoxShadow]),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/jogabi.svg',
                          height: 18.w,
                          width: 18.w,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Obx(() {
                          print("item changed");
                          return Text(
                            userModelRx.value == null ? 0.toString() : userModelRx.value!.item.toString(),
                            style: questTermTextStyle.copyWith(color: Color(0xFF4D6A87), fontWeight: FontWeight.w600),
                          );
                        })
                      ],
                    ),
                  ),
                  Positioned(
                    right: -10.w,
                    top: -10.w,
                    child: Container(
                      padding: EdgeInsets.all(3.5.w),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                      height: 20.w,
                      width: 20.w,
                      child: SvgPicture.asset(
                        'assets/buttons/add.svg',
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 10.w,
              )
            ],
          ),
        ),
        SizedBox(
          height: heightSectionTitleAndBox,
        ),
        // btwHomeModuleTitleSlider,
        Obx(() {
          return (homeViewModel.allQuests.length == 0) // 로딩 중과 length 0인 걸 구분해야 함
              ? Container(
                  color: Colors.yellow,
                  // height: 340.w,
                )
              : SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(
                          5,
                          (index) => Row(
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
                                    child: QuestWidget(questModel: homeViewModel.allQuests[0]),
                                  ),
                                  SizedBox(width: primaryPaddingSize),
                                ],
                              ))));
          // ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: 5, //homeViewModel.allQuests.length
          //     itemBuilder: (context, index) {
          //       // print(
          //       //     'user quest model length: ${userQuestModelRx == null}');

          //       return Row(
          //         children: [
          //           index == 0
          //               ? SizedBox(
          //                   width: kHorizontalPadding.left,
          //                 )
          //               : Container(),
          //           InkWell(
          //             onTap: () {
          //               Get.toNamed('quest',
          //                   arguments: homeViewModel.allQuests[0]);
          //             },
          //             child: QuestWidget(
          //                 questModel: homeViewModel.allQuests[0]),
          //           ),
          //           horizontalSpaceLarge
          //         ],
          //       );
          //     });
        })
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
    print('award view built');
    return Container(
      // color: Colors.blueGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: primaryHorizontalPadding,
            // color: Colors.red,
            child: Text("이 달의 상금 주식", style: sectionTitle),
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
                        style: myAssetTitle,
                      ),
                    ],
                  ),
                  SizedBox(height: reducedPaddingWhenTextIsBelow(14.w, detailedContentTextStyle.fontSize!)),
                  RichText(
                      text: TextSpan(text: "351,530", style: myAssetAmount, children: [
                    TextSpan(text: " 원", style: myAssetAmount.copyWith(fontWeight: FontWeight.w300))
                  ])),
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
                      style: myAssetTitle,
                    ),
                  ],
                ),
                SizedBox(height: reducedPaddingWhenTextIsBelow(14.w, detailedContentTextStyle.fontSize!)),
                RichText(
                    text: TextSpan(
                        text: "351,530",
                        style: myAssetAmount,
                        children: [TextSpan(text: " 원", style: myAssetAmount.copyWith(fontWeight: FontWeight.w300))])),
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
  final HomeViewModel homeViewModel;

  _GlassmorphismAppBarDelegate(this.safeAreaPadding, this.offset, this.homeViewModel);

  @override
  double get minExtent => 60.h + ScreenUtil().statusBarHeight;

  @override
  double get maxExtent => minExtent + kToolbarHeight - 40.h;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        // Don't wrap this in any SafeArea widgets, use padding instead
        // padding: EdgeInsets.only(top: safeAreaPadding.top),
        height: maxExtent,
        color: primaryBackgroundColor.withOpacity(.8),
        child: Padding(
          padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
          child: Center(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Obx(
                () => Text(
                  userModelRx.value == null ? "" : userModelRx.value!.userName,
                  style: appBarTitle.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )),
              Container(
                // color: Colors.blue,
                child: Text(
                  " 님의 요트",
                  style: appBarTitle,
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
      ),
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

class Admins extends StatelessWidget {
  const Admins({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    print("admin view built");
    return Container(
      height: 850,
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
              FirestoreService().countTest(0);
            },
          ),
          ElevatedButton(
            child: Text("Go To Award View (Old)"),
            onPressed: () {
              Get.toNamed('awardold');
            },
          ),
          // HomeAwardCardWidget(),
          ElevatedButton(
            child: Text("Go To Temp Home for Sub League View"),
            onPressed: () {
              // Get.toNamed('tempHome');
              Get.to(() => TempHomeView(
                    leagueName: '7월',
                  ));
            },
          ),
        ],
      ),
    );
  }
}
