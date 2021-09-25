import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
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
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../handlers/numbers_handler.dart';
import '../../styles/size_config.dart';

import 'asset_view.dart';
import 'asset_view_model.dart';
import 'profile_change_view.dart';
import 'profile_controller.dart';
import '../settings/setting_view.dart';
import 'profile_my_view_model.dart';

class ProfileMyView extends GetView<ProfileMyViewModel> {
  final ProfileMyViewModel profileViewModel = Get.put(ProfileMyViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: white,
          toolbarHeight: 60.w,
          title: Text('프로필', style: appBarTitle),
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => SettingView());
                  },
                  child: Image.asset(
                    'assets/buttons/settings.png',
                    width: 30.w,
                    height: 30.w,
                  ),
                ),
                SizedBox(
                  width: 14.w,
                )
              ],
            )
          ],
        ),
        body: ListView(children: [
          Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 11.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<ProfileMyViewModel>(
                      id: 'profile',
                      builder: (controller) {
                        return Container(
                          width: 79.w,
                          height: 90.w,
                          child: Stack(
                            children: [
                              Container(
                                height: 79.w,
                                width: 79.w,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment(0.0, 0.0),
                                        end: Alignment(0.0, 1.0),
                                        colors: [
                                          (controller.isUserModelLoaded)
                                              ? tierColor[
                                                  separateStringFromTier(
                                                      getTierByExp(userModelRx
                                                          .value!.exp))]!
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
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: primaryBackgroundColor)),
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
                                      child: FutureBuilder<String>(
                                          future: controller.getImageUrlFromStorage(
                                              'avatars/${userModelRx.value!.avatarImage!}.png'),
                                          builder: (context, snapshot) {
                                            return snapshot.hasData
                                                ? CachedNetworkImage(
                                                    imageUrl: snapshot.data!,
                                                  )
                                                : Container();
                                          })))),
                              Positioned(
                                  top: 58.w,
                                  child: (controller.isUserModelLoaded)
                                      ? userModelRx.value!.tier != null
                                          ? FutureBuilder<String>(
                                              future: controller
                                                  .getImageUrlFromStorage(
                                                      tierJellyBeanURL[
                                                          separateStringFromTier(
                                                              getTierByExp(
                                                                  userModelRx
                                                                      .value!
                                                                      .exp))]!),
                                              builder: (context, snapshot) {
                                                return snapshot.hasData
                                                    ? Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Container(
                                                            width: 78.w,
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: snapshot
                                                                  .data!,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${tierKorName[separateStringFromTier(getTierByExp(userModelRx.value!.exp))]} ${separateIntFromTier(getTierByExp(userModelRx.value!.exp))}',
                                                            style:
                                                                profileTierNameStyle,
                                                          ),
                                                        ],
                                                      )
                                                    : Container();
                                              })
                                          : Container()
                                      : Container()),
                            ],
                          ),
                        );
                      }),
                  SizedBox(
                    width: 16.w,
                  ),
                  Container(
                    width: SizeConfig.screenWidth - 14.w - 14.w - 79.w - 16.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: correctHeight(
                              5.w, 0.0, profileUserNameStyle.fontSize),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 유저아이디
                                GetBuilder<ProfileMyViewModel>(
                                  id: 'profile',
                                  builder: (controller) {
                                    if (controller.isUserModelLoaded) {
                                      return Obx(() => Text(
                                            '${userModelRx.value!.userName}',
                                            style: profileUserNameStyle,
                                          ));
                                    } else {
                                      return Text(
                                        '',
                                        style: profileUserNameStyle,
                                      );
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: correctHeight(
                                      10.w,
                                      profileUserNameStyle.fontSize,
                                      profileFollowTextStyle.fontSize),
                                ),
                                // 팔로워 숫자 / 팔로잉 숫자
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        userModelRx.value!.followers != null &&
                                                userModelRx.value!.followers!
                                                        .length !=
                                                    0
                                            ? Get.to(() =>
                                                FollowersNFollowingsView(
                                                    isMe: true,
                                                    whichfollowersOrfollowings:
                                                        true,
                                                    followersNFollowingsUid:
                                                        userModelRx
                                                            .value!.followers!))
                                            : Get.to(() =>
                                                NullFollowersNFollowingsView(
                                                  whichNULLfollowersOrfollowings:
                                                      true,
                                                ));
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            '팔로워 ',
                                            style: profileFollowTextStyle,
                                          ),
                                          GetBuilder<ProfileMyViewModel>(
                                            id: 'profile',
                                            builder: (controller) {
                                              if (controller
                                                  .isUserModelLoaded) {
                                                return Obx(() => Text(
                                                      userModelRx.value!
                                                                  .followers ==
                                                              null
                                                          ? '0'
                                                          : '${userModelRx.value!.followers!.length}',
                                                      style:
                                                          profileFollowNumberStyle,
                                                    ));
                                              } else {
                                                return Text(
                                                  '',
                                                  style:
                                                      profileFollowNumberStyle,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 17.w,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        userModelRx.value!.followings != null &&
                                                userModelRx.value!.followings!
                                                        .length !=
                                                    0
                                            ? Get.to(() =>
                                                FollowersNFollowingsView(
                                                    isMe: true,
                                                    whichfollowersOrfollowings:
                                                        false,
                                                    followersNFollowingsUid:
                                                        userModelRx.value!
                                                            .followings!))
                                            : Get.to(() =>
                                                NullFollowersNFollowingsView(
                                                  whichNULLfollowersOrfollowings:
                                                      false,
                                                ));
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            '팔로잉 ',
                                            style: profileFollowTextStyle,
                                          ),
                                          GetBuilder<ProfileMyViewModel>(
                                            id: 'profile',
                                            builder: (controller) {
                                              if (controller
                                                  .isUserModelLoaded) {
                                                return Obx(() => Text(
                                                      userModelRx.value!
                                                                  .followings ==
                                                              null
                                                          ? '0'
                                                          : '${userModelRx.value!.followings!.length}',
                                                      style:
                                                          profileFollowNumberStyle,
                                                    ));
                                              } else {
                                                return Text(
                                                  '',
                                                  style:
                                                      profileFollowNumberStyle,
                                                );
                                              }
                                            },
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
                                profileViewModel.introChangeController.text =
                                    '';
                                Get.to(() => ProfileChangeView());
                              },
                              child: Container(
                                height: 30.w,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(70.0),
                                  border: Border.all(
                                      color: primaryButtonBackground,
                                      width: 1.5.w),
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
                        SizedBox(
                            height: correctHeight(
                                14.w,
                                profileFollowTextStyle.fontSize,
                                subLeagueAwardCommentStyle.fontSize)),
                        // 유저소개글
                        GetBuilder<ProfileMyViewModel>(
                          id: 'profile',
                          builder: (controller) {
                            if (controller.isUserModelLoaded) {
                              return Obx(() => Text(
                                    (userModelRx.value!.intro == null ||
                                            userModelRx.value!.intro == '')
                                        ? '소개글이 없습니다.'
                                        : '${userModelRx.value!.intro}'
                                            .replaceAll('\\n', '\n'),
                                    style: subLeagueAwardCommentStyle.copyWith(
                                        letterSpacing: -0.01),
                                    maxLines: 3,
                                  ));
                            } else {
                              return Text(
                                '',
                                style: subLeagueAwardCommentStyle.copyWith(
                                    letterSpacing: -0.01),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )),
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
          //   padding: primaryHorizontalPadding,
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
          //                   padding: primaryHorizontalPadding,
          //                   child: Obx(
          //                     () => sectionBox(
          //                         padding: primaryAllPadding,
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
          SizedBox(
            height: 50.w,
          ),
          Padding(
            padding: EdgeInsets.only(left: 14.w, right: 0.w, bottom: 20.w),
            child: Row(
              children: [
                Text(
                  '획득한 뱃지',
                  style: profileHeaderTextStyle,
                ),
                Spacer(),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.to(() => BadgesFullGridView(
                          badges: userModelRx.value!.badges != null
                              ? userModelRx.value!.badges!
                              : [],
                        ));
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28.w,
                      ),
                      Image.asset(
                        'assets/icons/navigate_foward_arrow.png',
                        height: 16.w,
                        width: 9.w,
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
          GetBuilder<ProfileMyViewModel>(
            id: 'profile',
            builder: (controller) {
              if (userModelRx.value!.badges != null &&
                  controller.isUserModelLoaded) {
                return BadgesGridView(
                    isFull: false, badges: userModelRx.value!.badges!);
              } else {
                return BadgesGridView(
                  isFull: false,
                  badges: [],
                );
              }
            },
          ),
          SizedBox(
            height: 50.w,
          ),
        ]));
  }
}

class ProfileTabBarView extends StatefulWidget {
  const ProfileTabBarView({Key? key}) : super(key: key);

  @override
  _ProfileTabBarViewState createState() => _ProfileTabBarViewState();
}

class _ProfileTabBarViewState extends State<ProfileTabBarView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  final ProfileMyViewModel profileViewModel = Get.find<ProfileMyViewModel>();
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
          SizedBox(
              height: correctHeight(35.w, subLeagueAwardCommentStyle.fontSize,
                  profileButtonTextStyle.fontSize)),
          Obx(
            () => TabBar(
              indicatorColor: yachtViolet,
              indicatorWeight: 3.0,
              controller: tabController,
              onTap: (index) {
                if (index == 0) {
                  // myFeedViewModel.getMyFeed(userModelRx.value!.uid);
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
                          color: tabIndex.value == 0
                              ? profileButtonTextStyle.color
                              : yachtGrey),
                    ),
                  ),
                ),
                Container(
                  height: 30.w,
                  child: Center(
                    child: Text(
                      '리그',
                      style: profileButtonTextStyle.copyWith(
                          color: tabIndex.value == 1
                              ? profileButtonTextStyle.color
                              : yachtGrey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // height: 90.w,
            child: ExpandablePageView(
              onPageChanged: (index) {
                if (index == 0) {
                  // myFeedViewModel.getMyFeed(userModelRx.value!.uid);
                }
                tabController.animateTo(index);
              },
              controller: pageController,
              children: [
                MyFeedView(),
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              Get.to(() => AssetView());
                            },
                            child: Container(
                              height: 90.w,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('보유 자산',
                                        style: subLeagueAwardCommentStyle
                                            .copyWith(fontSize: 16.w)),
                                    SizedBox(
                                      height: correctHeight(10.w, 16.w,
                                          subLeagueAwardLabelStyle.fontSize),
                                    ),
                                    // *보유자산
                                    GetBuilder<ProfileMyViewModel>(
                                        id: 'profile',
                                        builder: (controller) {
                                          if (controller.isUserModelLoaded) {
                                            return GetBuilder<AssetViewModel>(
                                                id: 'holdingStocks',
                                                builder: (assetController) {
                                                  if (assetController
                                                      .isHoldingStocksFutureLoad) {
                                                    return Text(
                                                      '${toPriceKRW(assetController.totalHoldingStocksValue + assetController.totalYachtPoint)}원',
                                                      style:
                                                          subLeagueAwardLabelStyle
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      -0.01),
                                                    );
                                                  } else {
                                                    return Text('',
                                                        style:
                                                            subLeagueAwardLabelStyle
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        -0.01));
                                                  }
                                                });
                                          } else {
                                            return Text('???',
                                                style: subLeagueAwardLabelStyle
                                                    .copyWith(
                                                        letterSpacing: -0.01));
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
                        Flexible(
                          child: Container(
                            height: 90.w,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('순위',
                                      style: subLeagueAwardCommentStyle
                                          .copyWith(fontSize: 16.w)),
                                  SizedBox(
                                      height: correctHeight(10.w, 16.w,
                                          subLeagueAwardLabelStyle.fontSize)),
                                  // *현재 리그 순위 및 승점
                                  Text(
                                    '7143위 | 42점',
                                    style: subLeagueAwardLabelStyle.copyWith(
                                        letterSpacing: -0.01),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 1.w,
                      color: dividerColor,
                    ),
                    SizedBox(
                      height: correctHeight(
                          30.w, 0.0, profileHeaderTextStyle.fontSize),
                    ),
                    Padding(
                      padding: primaryHorizontalPadding,
                      child: Row(
                        children: [
                          Text(
                            '퀘스트 참여기록',
                            style: profileHeaderTextStyle,
                          ),
                          Spacer(),
                          Image.asset(
                            'assets/icons/navigate_foward_arrow.png',
                            height: 16.w,
                            width: 9.w,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: correctHeight(
                          20.w, profileHeaderTextStyle.fontSize, 0.0),
                    ),
                    Obx(
                      () => Column(
                        children: List.generate(
                            userQuestModelRx.length,
                            (index) => Column(
                                  children: [
                                    Padding(
                                      padding: primaryHorizontalPadding,
                                      child: Obx(
                                        () => sectionBox(
                                            padding: primaryAllPadding,
                                            child: FutureBuilder<QuestModel>(
                                                future: profileViewModel
                                                    .getEachQuestModel(
                                                        userQuestModelRx[
                                                            index]),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Container();
                                                  } else {
                                                    return InkWell(
                                                      onTap: () {
                                                        Get.toNamed('/quest',
                                                            arguments:
                                                                snapshot.data);
                                                      },
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  timeStampToStringWithHourMinute(snapshot
                                                                          .data!
                                                                          .questEndDateTime) +
                                                                      " 마감",
                                                                  style:
                                                                      questRecordendDateTime,
                                                                ),
                                                                Text(
                                                                    snapshot
                                                                        .data!
                                                                        .title,
                                                                    style:
                                                                        questRecordTitle),
                                                                SizedBox(
                                                                    height: correctHeight(
                                                                        14.w,
                                                                        questRecordTitle
                                                                            .fontSize,
                                                                        questRecordSelection
                                                                            .fontSize)),
                                                                Text(
                                                                    profileViewModel.getUserChioce(
                                                                        snapshot
                                                                            .data!,
                                                                        userQuestModelRx[
                                                                            index]),
                                                                    style:
                                                                        questRecordSelection),
                                                                // Text(userQuestModelRx[index].selection),
                                                              ],
                                                            ),
                                                          ),
                                                          // SizedBox(
                                                          //   width: 30.w,
                                                          // ),
                                                          // simpleTextContainerLessRadiusButton("퀘스트 보기")
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                })),
                                      ),
                                    ),
                                    if (index != userQuestModelRx.length)
                                      SizedBox(
                                        height: 10.w,
                                      )
                                  ],
                                )),
                      ),
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
