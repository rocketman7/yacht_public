import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/user_tier_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/profile/my_feed_view.dart';
import 'package:yachtOne/screens/profile/my_feed_view_model.dart';
import 'package:yachtOne/screens/profile/profile_others_view.dart';
import 'package:yachtOne/screens/profile/profile_share_ui.dart';
import 'package:yachtOne/screens/quest/result/quest_result_widget.dart';
import 'package:yachtOne/screens/ranks/rank_controller.dart';
import 'package:yachtOne/screens/ranks/rank_share_view.dart';
import 'package:yachtOne/screens/yacht_store/yacht_store_view.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';
import '../../handlers/numbers_handler.dart';
import '../../locator.dart';
import '../../styles/size_config.dart';

import '../award/last_award_view.dart';
import '../quest/new_result_quest_widget.dart';
import 'asset_view.dart';
import 'asset_view_model.dart';
import 'profile_change_view.dart';
import '../settings/setting_view.dart';
import 'profile_my_view_model.dart';
import 'quest_record_detail_view.dart';

class ProfileMyView extends GetView<ProfileMyViewModel> {
  final ProfileMyViewModel profileViewModel = Get.find<ProfileMyViewModel>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final RankController rankController = Get.put(RankController());
  RxDouble offset = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileViewModel.scrollController.addListener(() {
        // offset obs 값에 scroll controller offset 넣어주기
        profileViewModel.scrollController.offset < 0 ? offset(0) : offset(profileViewModel.scrollController.offset);
        // print(_scrollController.offset);
      });
    });
    return Scaffold(
        body: CustomScrollView(
      controller: profileViewModel.scrollController,
      slivers: [
        Obx(
          () => SliverPersistentHeader(
            floating: false,
            pinned: true,
            delegate: YachtPrimaryAppBarDelegate(
                offset: offset.value,
                tabTitle: userModelRx.value!.userName,
                buttonWidget: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _mixpanelService.mixpanel.track('Setting');
                    Get.to(() => SettingView());
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 14.w,
                      ),
                      Image.asset(
                        'assets/buttons/settings.png',
                        width: 30.w,
                        height: 30.w,
                        color: yachtWhite,
                      ),
                    ],
                  ),
                )),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 11.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GetBuilder<ProfileMyViewModel>(
                      id: 'profile',
                      builder: (controller) {
                        return GestureDetector(
                          onTap: () => showDialog(
                              context: context,
                              builder: (context) {
                                return yachtTierInfoPopUp(context, userModelRx.value!.exp);
                              }),
                          child: Container(
                            width: 79.w,
                            height: 90.w,
                            child: Stack(
                              children: [
                                Container(
                                  height: 79.w,
                                  width: 79.w,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient:
                                          LinearGradient(begin: Alignment(0.0, 0.0), end: Alignment(0.0, 1.0), colors: [
                                        (controller.isUserModelLoaded)
                                            ? tierColor[separateStringFromTier(getTierByExp(userModelRx.value!.exp))]!
                                            : tierColor['newbie']!,
                                        primaryBackgroundColor
                                      ])),
                                ),
                                Positioned(
                                  left: 1.w,
                                  top: 1.w,
                                  child: Container(
                                      height: 77.w,
                                      width: 77.w,
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: primaryBackgroundColor)),
                                ),
                                Positioned(
                                    left: 5.w,
                                    top: 5.w,
                                    child: Obx(() => Container(
                                        height: 69.w,
                                        width: 69.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: userModelRx.value!.avatarImage != null
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${userModelRx.value!.avatarImage!}.png",
                                              )
                                            : Container()))),
                                Positioned(
                                    top: 58.w,
                                    child: (controller.isUserModelLoaded)
                                        ? Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                width: 78.w,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "https://storage.googleapis.com/ggook-5fb08.appspot.com/${tierJellyBeanURL[separateStringFromTier(getTierByExp(userModelRx.value!.exp))]!}",
                                                ),
                                              ),
                                              Text(
                                                '${tierKorName[separateStringFromTier(getTierByExp(userModelRx.value!.exp))]} ${separateIntFromTier(getTierByExp(userModelRx.value!.exp))}',
                                                style: profileTierNameStyle,
                                              ),
                                            ],
                                          )
                                        : Container()),
                              ],
                            ),
                          ),
                        );
                      }),
                  SizedBox(
                    width: 30.w,
                  ),
                  Expanded(
                    child: Container(
                      // width: SizeConfig.screenWidth - 14.w - 14.w - 79.w - 16.w,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 유저아이디
                              // GetBuilder<ProfileMyViewModel>(
                              //   id: 'profile',
                              //   builder: (controller) {
                              //     if (controller.isUserModelLoaded) {
                              //       return Obx(() => Text(
                              //             '${userModelRx.value!.userName}',
                              //             style: profileUserNameStyle,
                              //           ));
                              //     } else {
                              //       return Text(
                              //         '',
                              //         style: profileUserNameStyle,
                              //       );
                              //     }
                              //   },
                              // ),
                              // SizedBox(
                              //   height: correctHeight(
                              //       10.w, profileUserNameStyle.fontSize, profileFollowTextStyle.fontSize),
                              // ),
                              // 팔로워 숫자 / 팔로잉 숫자
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      userModelRx.value!.followers != null && userModelRx.value!.followers!.length != 0
                                          ? Get.to(() => FollowersNFollowingsView(
                                              isMe: true,
                                              whichfollowersOrfollowings: true,
                                              followersNFollowingsUid: userModelRx.value!.followers!))
                                          : Get.to(() => NullFollowersNFollowingsView(
                                                whichNULLfollowersOrfollowings: true,
                                              ));
                                    },
                                    child: Column(
                                      children: [
                                        GetBuilder<ProfileMyViewModel>(
                                          id: 'profile',
                                          builder: (controller) {
                                            if (controller.isUserModelLoaded) {
                                              return Obx(() => Text(
                                                    userModelRx.value!.followers == null
                                                        ? '0'
                                                        : '${userModelRx.value!.followers!.length}',
                                                    style: profileFollowNumberStyle,
                                                  ));
                                            } else {
                                              return Text(
                                                '',
                                                style: profileFollowNumberStyle,
                                              );
                                            }
                                          },
                                        ),
                                        SizedBox(height: 2.w),
                                        Text(
                                          '팔로워 ',
                                          style: profileFollowTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      userModelRx.value!.followings != null &&
                                              userModelRx.value!.followings!.length != 0
                                          ? Get.to(() => FollowersNFollowingsView(
                                              isMe: true,
                                              whichfollowersOrfollowings: false,
                                              followersNFollowingsUid: userModelRx.value!.followings!))
                                          : Get.to(() => NullFollowersNFollowingsView(
                                                whichNULLfollowersOrfollowings: false,
                                              ));
                                    },
                                    child: Column(
                                      children: [
                                        GetBuilder<ProfileMyViewModel>(
                                          id: 'profile',
                                          builder: (controller) {
                                            if (controller.isUserModelLoaded) {
                                              return Obx(() => Text(
                                                    userModelRx.value!.followings == null
                                                        ? '0'
                                                        : '${userModelRx.value!.followings!.length}',
                                                    style: profileFollowNumberStyle,
                                                  ));
                                            } else {
                                              return Text(
                                                '',
                                                style: profileFollowNumberStyle,
                                              );
                                            }
                                          },
                                        ),
                                        SizedBox(height: 2.w),
                                        Text(
                                          '팔로잉 ',
                                          style: profileFollowTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              profileViewModel.nameChangeController.text = '';
                              profileViewModel.introChangeController.text = '';
                              Get.to(() => ProfileChangeView());
                            },
                            child: Container(
                              height: 30.w,
                              width: 100.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70.0),
                                border: Border.all(color: primaryButtonBackground, width: 1.5.w),
                              ),
                              child: Center(
                                child: GetBuilder<ProfileMyViewModel>(
                                  id: 'profile',
                                  builder: (controller) {
                                    if (controller.isUserModelLoaded) {
                                      return Text(
                                        '프로필 수정',
                                        style: profileButtonTextStyle,
                                      );
                                    } else {
                                      return Text(
                                        '',
                                        style: profileButtonTextStyle,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // SizedBox(
                      //     height: correctHeight(
                      //         14.w, profileFollowTextStyle.fontSize, subLeagueAwardCommentStyle.fontSize)),
                    ),
                  ),
                ],
              )),
          SizedBox(height: 8.w),
          // 유저소개글
          Padding(
            padding: defaultHorizontalPadding,
            child: GetBuilder<ProfileMyViewModel>(
              id: 'profile',
              builder: (controller) {
                if (controller.isUserModelLoaded) {
                  return Obx(() => Text(
                        (userModelRx.value!.intro == null || userModelRx.value!.intro == '')
                            ? '소개글이 없습니다.'
                            : '${userModelRx.value!.intro}'.replaceAll('\\n', '\n'),
                        style: subLeagueAwardCommentStyle.copyWith(letterSpacing: -0.01),
                        maxLines: 3,
                      ));
                } else {
                  return Text(
                    '',
                    style: subLeagueAwardCommentStyle.copyWith(letterSpacing: -0.01),
                  );
                }
              },
            ),
          ),
          ProfileTabBarView(),
          // SizedBox(height: correctHeight(35.w, subLeagueAwardCommentStyle.fontSize, profileButtonTextStyle.fontSize)),
          // Row(
          //   children: [
          //     Flexible(
          //         child: Container(
          //       height: 24.w,
          //       child: Center(
          //         child: Text(
          //           '피드',
          //           style: profileButtonTextStyle.copyWith(color: 0 == 1 ? profileButtonTextStyle.color : yachtGrey),
          //         ),
          //       ),
          //     )),
          //     Flexible(
          //         child: Container(
          //       height: 24.w,
          //       child: Center(
          //         child: Text(
          //           '리그',
          //           style: profileButtonTextStyle.copyWith(color: 1 == 1 ? profileButtonTextStyle.color : yachtGrey),
          //         ),
          //       ),
          //     )),
          //   ],
          // ),

          // Container(
          //   height: 7.5.w,
          //   width: SizeConfig.screenWidth,
          //   child: Stack(
          //     children: [
          //       Positioned(
          //         top: 6.5.w,
          //         child: Container(
          //           height: 1.w,
          //           width: SizeConfig.screenWidth,
          //           color: dividerColor,
          //         ),
          //       ),
          //       Positioned(
          //         top: 4.0.w,
          //         child: Container(
          //           height: 3.w,
          //           width: SizeConfig.screenWidth / 2,
          //           color: 0 == 1 ? primaryButtonBackground : Colors.transparent,
          //         ),
          //       ),
          //       Positioned(
          //         top: 4.0.w,
          //         left: SizeConfig.screenWidth / 2,
          //         child: Container(
          //           height: 3.w,
          //           width: SizeConfig.screenWidth / 2,
          //           color: 1 == 1 ? primaryButtonBackground : Colors.transparent,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // Row(
          //   children: [
          //     Flexible(
          //       child: InkWell(
          //         onTap: () {
          //           Get.to(() => AssetView());
          //         },
          //         child: Container(
          //           height: 90.w,
          //           child: Center(
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //                 Text('보유 자산', style: subLeagueAwardCommentStyle.copyWith(fontSize: 16.w)),
          //                 SizedBox(
          //                   height: correctHeight(10.w, 16.w, subLeagueAwardLabelStyle.fontSize),
          //                 ),
          //                 // *보유자산
          //                 GetBuilder<ProfileMyViewModel>(
          //                     id: 'profile',
          //                     builder: (controller) {
          //                       if (controller.isUserModelLoaded) {
          //                         return GetBuilder<AssetViewModel>(
          //                             id: 'holdingStocks',
          //                             builder: (assetController) {
          //                               if (assetController.isHoldingStocksFutureLoad) {
          //                                 return Text(
          //                                   '${toPriceKRW(assetController.totalHoldingStocksValue + assetController.totalYachtPoint)}원',
          //                                   style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
          //                                 );
          //                               } else {
          //                                 return Text('',
          //                                     style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01));
          //                               }
          //                             });
          //                       } else {
          //                         return Text('???', style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01));
          //                       }
          //                     }),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //     Container(
          //       width: 1.w,
          //       height: 90.w,
          //       color: dividerColor,
          //     ),
          //     Flexible(
          //       child: Container(
          //         height: 90.w,
          //         child: Center(
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               Text('순위', style: subLeagueAwardCommentStyle.copyWith(fontSize: 16.w)),
          //               SizedBox(height: correctHeight(10.w, 16.w, subLeagueAwardLabelStyle.fontSize)),
          //               // *현재 리그 순위 및 승점
          //               Text(
          //                 '7143위 | 42점',
          //                 style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // Container(
          //   height: 1.w,
          //   color: dividerColor,
          // ),
          // SizedBox(
          //   height: correctHeight(30.w, 0.0, profileHeaderTextStyle.fontSize),
          // ),
          // Padding(
          //   padding: defaultHorizontalPadding,
          //   child: Row(
          //     children: [
          //       Text(
          //         '퀘스트 참여기록',
          //         style: profileHeaderTextStyle,
          //       ),
          //       Spacer(),
          //       Image.asset(
          //         'assets/icons/navigate_foward_arrow.png',
          //         height: 16.w,
          //         width: 9.w,
          //       )
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: correctHeight(20.w, profileHeaderTextStyle.fontSize, 0.0),
          // ),
          // Obx(
          //   () => Column(
          //     children: List.generate(
          //         userQuestModelRx.length,
          //         (index) => Column(
          //               children: [
          //                 Padding(
          //                   padding: defaultHorizontalPadding,
          //                   child: Obx(
          //                     () => sectionBox(
          //                         padding: defaultPaddingAll,
          //                         child: FutureBuilder<QuestModel>(
          //                             future: controller.getEachQuestModel(userQuestModelRx[index]),
          //                             builder: (context, snapshot) {
          //                               if (!snapshot.hasData) {
          //                                 return Container();
          //                               } else {
          //                                 return InkWell(
          //                                   onTap: () {
          //                                     Get.toNamed('/quest', arguments: snapshot.data);
          //                                   },
          //                                   child: Row(
          //                                     crossAxisAlignment: CrossAxisAlignment.start,
          //                                     children: [
          //                                       Expanded(
          //                                         child: Column(
          //                                           crossAxisAlignment: CrossAxisAlignment.start,
          //                                           mainAxisAlignment: MainAxisAlignment.start,
          //                                           children: [
          //                                             Text(
          //                                               timeStampToStringWithHourMinute(
          //                                                       snapshot.data!.questEndDateTime) +
          //                                                   " 마감",
          //                                               style: questRecordendDateTime,
          //                                             ),
          //                                             Text(snapshot.data!.title, style: questRecordTitle),
          //                                             SizedBox(
          //                                                 height: correctHeight(14.w, questRecordTitle.fontSize,
          //                                                     questRecordSelection.fontSize)),
          //                                             Text(
          //                                                 controller.getUserChioce(
          //                                                     snapshot.data!, userQuestModelRx[index]),
          //                                                 style: questRecordSelection),
          //                                             // Text(userQuestModelRx[index].selection),
          //                                           ],
          //                                         ),
          //                                       ),
          //                                       // SizedBox(
          //                                       //   width: 30.w,
          //                                       // ),
          //                                       // simpleTextContainerLessRadiusButton("퀘스트 보기")
          //                                     ],
          //                                   ),
          //                                 );
          //                               }
          //                             })),
          //                   ),
          //                 ),
          //                 if (index != userQuestModelRx.length)
          //                   SizedBox(
          //                     height: 10.w,
          //                   )
          //               ],
          //             )),
          //   ),
          // ),
          // 일단 1차는 즐겨찾기 빼고
          // SizedBox(
          //   height: 50.w,
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 20.w),
          //   child: Row(
          //     children: [
          //       Text(
          //         '즐겨찾기한 종목',
          //         style: profileHeaderTextStyle,
          //       ),
          //       Spacer(),
          //       Image.asset(
          //         'assets/icons/navigate_foward_arrow.png',
          //         height: 16.w,
          //         width: 9.w,
          //       )
          //     ],
          //   ),
          // ),
          // GetBuilder<ProfileMyViewModel>(
          //   id: 'favorites',
          //   builder: (controller) {
          //     if (controller.isUserModelLoaded &&
          //         controller.isFavoritesLoaded) {
          //       // 굳이 이렇게 조건을 중첩한 이유는 그냥 혹시 먼저 뜨게되면 부자연스러울 것 같아서.
          //       return ProfileViewFavoritesCardWidget(
          //           favoriteStockModels: controller.favoriteStockModels,
          //           favoriteStockHistoricalPriceModels:
          //               controller.favoriteStockHistoricalPriceModels);
          //     } else {
          //       return Container();
          //     }
          //   },
          // ),
        ])),
      ],
    ));
  }
}

class ProfileTabBarView extends StatefulWidget {
  const ProfileTabBarView({Key? key}) : super(key: key);

  @override
  _ProfileTabBarViewState createState() => _ProfileTabBarViewState();
}

class _ProfileTabBarViewState extends State<ProfileTabBarView> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  final ProfileMyViewModel profileViewModel = Get.find<ProfileMyViewModel>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  // final RankController rankController = Get.find<RankController>();
  // final MyFeedViewModel myFeedViewModel = Get.find<MyFeedViewModel>();
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    pageController = PageController(initialPage: 1);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  RxInt tabIndex = 1.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: correctHeight(35.w, subLeagueAwardCommentStyle.fontSize, profileButtonTextStyle.fontSize)),
          Obx(
            () => TabBar(
              indicatorColor: yachtViolet,
              indicatorWeight: 3.0,
              controller: tabController,
              onTap: (index) {
                if (index == 0) {
                  _mixpanelService.mixpanel.track('Feed History');
                  // myFeedViewModel.getMyFeed(userModelRx.value!.uid);
                } else {
                  _mixpanelService.mixpanel.track('User Activity');
                }
                tabIndex(index);
                pageController.jumpToPage(index);
              },
              tabs: [
                Container(
                  height: 30.w,
                  child: Center(
                    child: Text(
                      '피드',
                      style: profileButtonTextStyle.copyWith(
                        fontSize: 16.w,
                        color: tabIndex.value == 0 ? profileButtonTextStyle.color : yachtLightGrey,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 30.w,
                  child: Center(
                    child: Text(
                      '활동',
                      style: profileButtonTextStyle.copyWith(
                        fontSize: 16.w,
                        color: tabIndex.value == 1 ? profileButtonTextStyle.color : yachtLightGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
              top: BorderSide(width: 1.0, color: dividerColor),
            )),
            // height: 90.w,
            child: ExpandablePageView(
              onPageChanged: (index) {
                if (index == 0) {
                  // myFeedViewModel.getMyFeed(userModelRx.value!.uid);
                }
                tabIndex(index);
                tabController.animateTo(index);
              },
              controller: pageController,
              children: [
                MyFeedView(userModelRx.value!.uid),
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              _mixpanelService.mixpanel.track(
                                'My Asset',
                                properties: {'My Asset Tap From': "마이 페이지-보유 자산"},
                              );
                              Get.to(() => AssetView());
                            },
                            child: Container(
                              height: 90.w,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('보유 자산', style: subLeagueAwardCommentStyle.copyWith(fontSize: 16.w)),
                                    SizedBox(
                                      height: correctHeight(10.w, 16.w, subLeagueAwardLabelStyle.fontSize),
                                    ),
                                    // *보유자산
                                    GetBuilder<ProfileMyViewModel>(
                                        id: 'profile',
                                        builder: (controller) {
                                          if (controller.isUserModelLoaded) {
                                            return GetBuilder<AssetViewModel>(
                                                id: 'holdingStocks',
                                                builder: (assetController) {
                                                  if (assetController.isHoldingStocksFutureLoad) {
                                                    return Text(
                                                      '${toPriceKRW(assetController.totalHoldingStocksValue + assetController.totalYachtPoint)}원',
                                                      style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
                                                    );
                                                  } else {
                                                    return Text('',
                                                        style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01));
                                                  }
                                                });
                                          } else {
                                            return Text('???',
                                                style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01));
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1.w,
                          height: 90.w,
                          color: dividerColor,
                        ),
                        GetBuilder<RankController>(
                            id: 'ranks',
                            init: RankController(),
                            builder: (rankController) {
                              return Flexible(
                                child: InkWell(
                                  onTap: () {
                                    // 메인리그는 무조건 인덱스가 0이라는 가정이 들어가있음
                                    Get.to(() => AllRankerView(
                                          leagueIndex: 0,
                                        ));
                                  },
                                  child: Container(
                                    height: 90.w,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text('순위', style: subLeagueAwardCommentStyle.copyWith(fontSize: 16.w)),
                                          SizedBox(
                                              height: correctHeight(10.w, 16.w, subLeagueAwardLabelStyle.fontSize)),
                                          // *현재 리그 순위 및 승점
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                rankController.myRanksAndPoint[0]['todayRank'] == null
                                                    ? ""
                                                    : rankController.myRanksAndPoint[0]['todayRank']! != 0
                                                        ? '${rankController.myRanksAndPoint[0]['todayRank']!}위 |'
                                                        : '없음 |',
                                                style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
                                              ),
                                              Text(
                                                ' ${rankController.myRanksAndPoint[0]['todayPoint'] ?? 0}',
                                                style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
                                              ),
                                              Text(
                                                '점',
                                                style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
                                              ),
                                            ],
                                          ),

                                          // GetBuilder(builder: (context) {
                                          //   return Text(
                                          //     '7143위 | 42점',
                                          //     style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
                                          //   );
                                          // }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                    Container(
                      height: 1.w,
                      color: dividerColor,
                    ),
                    SizedBox(
                      height: correctHeight(30.w, 0.0, profileHeaderTextStyle.fontSize),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 14.w),
                      // padding: defaultHorizontalPadding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '퀘스트 참여기록',
                            style: profileHeaderTextStyle,
                          ),
                          Spacer(),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              _mixpanelService.mixpanel.track('Previous League');
                              Get.to(() => LastAwardView());
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 18.w,
                                ),
                                basicActionButtion(
                                  '지난 리그 보기',
                                  wider: true,
                                  buttonColor: yachtGrey,
                                  textColor: yachtWhite,
                                ),
                                SizedBox(
                                  width: 14.w,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: correctHeight(20.w, profileHeaderTextStyle.fontSize, 0.0),
                    ),
                    Obx(() => userQuestModelRx.length == 0
                        ? Padding(
                            padding: defaultHorizontalPadding,
                            child: Container(
                              padding: defaultPaddingAll,
                              width: double.infinity,
                              decoration:
                                  BoxDecoration(color: yachtDarkGrey, borderRadius: BorderRadius.circular(12.w)),
                              child: Center(
                                child: Text(
                                  "퀘스트에 참여한 기록이 없어요.",
                                  style: TextStyle(
                                    color: yachtLightGrey,
                                    fontSize: 16.w,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              QuestRecordView(
                                isFullView: false,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _mixpanelService.mixpanel.track('Quest Record Detail');
                                  Get.to(() => QuestRecordDetailView());
                                },
                                child: Padding(
                                  padding: defaultPaddingAll,
                                  child: Container(
                                    width: double.infinity,
                                    height: 50.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.w),
                                      color: yachtDarkGrey,
                                    ),
                                    child: Center(
                                        child: Text(
                                      "모두 보기",
                                      style: seeMore.copyWith(
                                        color: yachtWhite,
                                      ),
                                    )),
                                  ),
                                ),
                              )
                            ],
                          )),
                    // Obx(() => userQuestModelRx.length == 0
                    //     ? Image.asset(
                    //         'assets/illusts/not_exists/no_quest_done.png',
                    //         height: 150.w)
                    //     : QuestRecordView(
                    //         isFullView: false,
                    //       )),
                    SizedBox(
                      height: 50.w,
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 14.w, right: 0.w, bottom: 20.w),
                    //   child: GestureDetector(
                    //     behavior: HitTestBehavior.opaque,
                    //     onTap: () {
                    //       _mixpanelService.mixpanel.track('Badge Detail');
                    //       Get.to(() => BadgesFullGridView(
                    //             badges: userModelRx.value!.badges != null ? userModelRx.value!.badges! : [],
                    //           ));
                    //     },
                    //     child: Row(
                    //       children: [
                    //         Text(
                    //           '획득한 뱃지',
                    //           style: profileHeaderTextStyle,
                    //         ),
                    //         Spacer(),
                    //         Row(
                    //           children: [
                    //             SizedBox(
                    //               width: 28.w,
                    //             ),
                    //             Image.asset(
                    //               'assets/icons/navigate_foward_arrow.png',
                    //               height: 16.w,
                    //               width: 9.w,
                    //             ),
                    //             SizedBox(
                    //               width: 14.w,
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // GetBuilder<ProfileMyViewModel>(
                    //   id: 'profile',
                    //   builder: (controller) {
                    //     if (userModelRx.value!.badges != null && controller.isUserModelLoaded) {
                    //       return BadgesGridView(isFull: false, badges: userModelRx.value!.badges!);
                    //     } else {
                    //       return BadgesGridView(
                    //         isFull: false,
                    //         badges: [],
                    //       );
                    //     }
                    //   },
                    // ),
                    SizedBox(
                      height: 100.w,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class QuestRecordView extends StatelessWidget {
  final bool isFullView;
  final int maxNum = 3;

  QuestRecordView({required this.isFullView});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          isFullView ? userQuestModelRx.length : min(userQuestModelRx.length, maxNum),
          (index) => Column(
                children: [
                  Padding(
                    padding: defaultHorizontalPadding,
                    child: Obx(
                      () => sectionBox(
                          padding: defaultPaddingAll,
                          child: FutureBuilder<QuestModel>(
                              future: Get.find<ProfileMyViewModel>().getEachQuestModel(userQuestModelRx[index]),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => NewResultDialog(
                                                questModel: snapshot.data!,
                                                // questResultViewModel: ,
                                              ));

                                      // Get.toNamed('/quest',
                                      //     arguments:
                                      //         snapshot.data);
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                timeStampToStringWithHourMinute(snapshot.data!.questEndDateTime) +
                                                    " 마감",
                                                style: questRecordendDateTime.copyWith(
                                                  color: yachtLightGrey,
                                                ),
                                              ),
                                              SizedBox(height: 6.w),
                                              Text(snapshot.data!.title, style: questRecordTitle),
                                              SizedBox(
                                                  height: correctHeight(
                                                      14.w, questRecordTitle.fontSize, questRecordSelection.fontSize)),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '나의 예측',
                                                          style: questTitle.copyWith(
                                                            fontSize: 14.w,
                                                            color: yachtLightGrey,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8.w),
                                                        SizedBox(
                                                          height: 2.w,
                                                        ),
                                                        Text(
                                                            Get.find<ProfileMyViewModel>()
                                                                .getUserChioce(snapshot.data!, userQuestModelRx[index]),
                                                            style: questRecordSelection.copyWith(
                                                              fontSize: 16.w,
                                                            )),

                                                        // SizedBox(
                                                        //   width: 30.w,
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '결과',
                                                          style: questTitle.copyWith(
                                                            fontSize: 14.w,
                                                            color: yachtLightGrey,
                                                          ),
                                                        ),
                                                        // Spacer(),
                                                        Text(
                                                          snapshot.data!.results == null
                                                              ? "진행 중"
                                                              : userQuestModelRx[index].hasSucceeded == true
                                                                  ? "예측 성공"
                                                                  : "예측 실패",
                                                          style: questRecordSelection.copyWith(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 16.w,
                                                            color: snapshot.data!.results == null
                                                                ? yachtMidGrey
                                                                : userQuestModelRx[index].hasSucceeded == true
                                                                    ? yachtRed
                                                                    : yachtMidGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // Text(userQuestModelRx[index].selection),
                                            ],
                                          ),
                                        ),

                                        // simpleTextContainerLessRadiusButton("퀘스트 보기")
                                      ],
                                    ),
                                  );
                                }
                              })),
                    ),
                  ),
                  if (index !=
                      min(userQuestModelRx.length,
                              isFullView ? userQuestModelRx.length : min(userQuestModelRx.length, maxNum)) -
                          1)
                    SizedBox(
                      height: 10.w,
                    )
                ],
              )),
    );
  }
}
