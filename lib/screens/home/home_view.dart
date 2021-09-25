import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/reading_content_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/auth/auth_check_view.dart';
import 'package:yachtOne/screens/auth/kakao_firebase_auth_api.dart';
import 'package:yachtOne/screens/auth/login_view.dart';
import 'package:yachtOne/screens/award/award_view.dart';
import 'package:yachtOne/screens/contents/dictionary/dictionary_view.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_view.dart';
import 'package:yachtOne/screens/contents/today_market/today_market_view.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/quest/live/live_quest_view.dart';
import 'package:yachtOne/screens/profile/asset_view.dart';
import 'package:yachtOne/screens/profile/asset_view_model.dart';
import 'package:yachtOne/screens/quest/result/quest_results_view.dart';
import 'package:yachtOne/screens/ranks/rank_share_view.dart';
import 'package:yachtOne/screens/subLeague/temp_home_view.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import '../../locator.dart';

import '../quest/quest_widget.dart';

class HomeView extends StatelessWidget {
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  AuthService _authService = locator<AuthService>();
  final KakaoFirebaseAuthApi _kakaoApi = KakaoFirebaseAuthApi();
  ScrollController _scrollController = ScrollController();
  RxDouble offset = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    List<Widget> homeWidgets = [
      MyAssets(),
      // sign out 임시
      InkWell(
        onTap: () {
          // Get.off(() => AuthCheckView());
          _authService.auth.signOut();
          userModelRx.value = null;
          userQuestModelRx.value = [];
          _kakaoApi.signOut();
          print("signout");
          // showDialog(
          //   context: context,
          //   builder: (context) => yachtTierInfoPopUp(
          //     context,
          //     2140,
          //   ),
          // );
        },
        child: Container(
            // color: Colors.blue,
            width: 300.w,
            height: correctHeight(30.w, sectionTitle.fontSize!, 0.0)),
      ),
      // 이달의 상금 주식
      AwardView(leagueName: "9월 리그", leagueEndDateTime: "2021년 9월 30일까지"),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      NewQuests(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      LiveQuestView(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      QuestResultsView(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      RankHomeWidget(),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      ReadingContentView(
          homeViewModel: homeViewModel), // showingHome 변수 구분해서 넣는 게
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      TodayMarketView(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      DictionaryView(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(80.w, 0.0, sectionTitle.fontSize)),

      // SliverToBoxAdapter(child: SizedBox(height: 100)),
      // OldLiveQuests(homeViewModel: homeViewModel),
      // SliverToBoxAdapter(child: Container(height: 200, color: Colors.grey)),
      // Admins(homeViewModel: homeViewModel),
    ];

    _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    _scrollController.addListener(() {
      // offset obs 값에 scroll controller offset 넣어주기
      _scrollController.offset < 0
          ? offset(0)
          : offset(_scrollController.offset);
      // print(_scrollController.offset);
    });

    // print(
    //     'screen width: ${ScreenUtil().screenWidth} / screen height: ${ScreenUtil().screenHeight} / ratio: ${(ScreenUtil().screenHeight / ScreenUtil().screenWidth)}');

    if (userQuestModelRx.length != 0)
      print('내가 참여한 퀘스트: ${userQuestModelRx[0].selectDateTime != null} ');

    final RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    void _onRefresh() async {
      _refreshController.refreshCompleted();
    }

    return Scaffold(
      body: RefreshConfiguration(
        enableScrollWhenRefreshCompleted: true,
        child: SmartRefresher(
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 앱바
              Obx(
                () => SliverPersistentHeader(
                    floating: false,
                    pinned: true,
                    // 홈 뷰 앱바 구현
                    delegate: _GlassmorphismAppBarDelegate(
                        MediaQuery.of(context).padding,
                        offset.value,
                        homeViewModel)),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
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
        ),
      ),
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
    final MixpanelService _mixpanelService = locator<MixpanelService>();
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
                  child: Text("새로 나온 퀘스트",
                      style: sectionTitle.copyWith(height: 1.0))),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _mixpanelService.mixpanel.track('Ad view');
                  if (userModelRx.value!.rewardedCnt! < maxRewardedAds) {
                    adsViewDialog(context);
                  } else {
                    maxRewardedAdsDialog(context);
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
                      decoration: jogabiButtonBoxDecoration
                          .copyWith(boxShadow: [primaryBoxShadow]),
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
                              userModelRx.value == null
                                  ? 0.toString()
                                  : userModelRx.value!.item.toString(),
                              style: questTermTextStyle.copyWith(
                                  color: Color(0xFF4D6A87),
                                  fontWeight: FontWeight.w600),
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
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
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
          return (homeViewModel.newQuests.length ==
                  0) // 로딩 중과 length 0인 걸 구분해야 함
              ? Container(
                  width: 232.w,
                  height: 344.w,
                  child: Image.asset('assets/illusts/not_exists/no_quest.png'),
                  // height: 340.w,
                )
              : SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(
                          homeViewModel.newQuests.length,
                          (index) => Row(
                                children: [
                                  index == 0
                                      ? SizedBox(
                                          width: kHorizontalPadding.left,
                                        )
                                      : Container(),
                                  InkWell(
                                    onTap: () {
                                      homeViewModel.newQuests[index]
                                                  .selectMode ==
                                              'survey'
                                          ? Get.toNamed('/survey',
                                              arguments: homeViewModel
                                                  .newQuests[index])
                                          : Get.toNamed('/quest',
                                              arguments: homeViewModel
                                                  .newQuests[index]);
                                    },
                                    child: QuestWidget(
                                        questModel:
                                            homeViewModel.newQuests[index]),
                                  ),
                                  SizedBox(width: primaryPaddingSize),
                                ],
                              ))));
        })
      ],
    );
  }
}

class MyAssets extends StatelessWidget {
  final AssetViewModel _assetViewModel = Get.find<AssetViewModel>();
  // final AssetViewModel _assetViewModel = Get.put(AssetViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: offset.w > 100.w ? 0 : 100.w - offset.w,
      height: 100.w,
      child: GestureDetector(
        onTap: () {
          Get.to(() => AssetView());
        },
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
                    SizedBox(
                        height: reducedPaddingWhenTextIsBelow(
                            14.w, detailedContentTextStyle.fontSize!)),
                    GetBuilder<AssetViewModel>(
                        id: 'holdingStocks',
                        builder: (controller) {
                          return RichText(
                              text: TextSpan(
                                  text: controller.isHoldingStocksFutureLoad
                                      ? "${toPriceKRW(_assetViewModel.totalHoldingStocksValue)}"
                                      : "0",
                                  style: myAssetAmount,
                                  children: [
                                TextSpan(
                                    text: " 원",
                                    style: myAssetAmount.copyWith(
                                        fontWeight: FontWeight.w300))
                              ]));
                        }),
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
                      Image.asset(
                        'assets/icons/yacht_point_circle.png',
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
                  SizedBox(
                      height: reducedPaddingWhenTextIsBelow(
                          14.w, detailedContentTextStyle.fontSize!)),
                  GetBuilder<AssetViewModel>(
                      id: 'holdingStocks',
                      builder: (controller) {
                        return RichText(
                            text: TextSpan(
                                text: controller.isHoldingStocksFutureLoad
                                    ? "${toPriceKRW(_assetViewModel.totalYachtPoint)}"
                                    : "0",
                                style: myAssetAmount,
                                children: [
                              TextSpan(
                                  text: " 원",
                                  style: myAssetAmount.copyWith(
                                      fontWeight: FontWeight.w300))
                            ]));
                      }),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class _GlassmorphismAppBarDelegate extends SliverPersistentHeaderDelegate {
  final EdgeInsets safeAreaPadding;
  final double offset;
  final HomeViewModel homeViewModel;

  _GlassmorphismAppBarDelegate(
      this.safeAreaPadding, this.offset, this.homeViewModel);

  @override
  double get minExtent => 60.h + ScreenUtil().statusBarHeight;

  @override
  double get maxExtent => minExtent + kToolbarHeight - 40.h;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        // Don't wrap this in any SafeArea widgets, use padding instead
        // padding: EdgeInsets.only(top: safeAreaPadding.top),
        height: maxExtent,
        color: primaryBackgroundColor.withOpacity(.65),
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
