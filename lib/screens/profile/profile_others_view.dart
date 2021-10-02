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
import 'package:yachtOne/screens/quest/result/quest_result_widget.dart';
import 'package:yachtOne/screens/ranks/rank_controller.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../handlers/numbers_handler.dart';
import '../../styles/size_config.dart';

import 'asset_view.dart';
import 'asset_view_model.dart';
import 'profile_change_view.dart';
import '../settings/setting_view.dart';
import 'profile_others_view_model.dart';
import 'profile_share_ui.dart';

class ProfileOthersView extends GetView<ProfileOthersViewModel> {
  final String uid;
  ProfileOthersView({required this.uid});

  // final ProfileOthersViewModel profileViewModel =
  //     Get.put(ProfileOthersViewModel(uid: 'kakao:1513684681'));

  // get controller => Get.put(ProfileOthersViewModel(uid: uid));

  @override
  Widget build(BuildContext context) {
    final ProfileOthersViewModel profileViewModel =
        Get.put(ProfileOthersViewModel(uid: uid), tag: uid);

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: white,
        toolbarHeight: 60.w,
        title: Text('프로필', style: appBarTitle),
      ),
      body: ListView(children: [
        Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 11.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<ProfileOthersViewModel>(
                    id: 'profile',
                    tag: uid,
                    builder: (controller) {
                      return GestureDetector(
                        onTap: () => showDialog(
                            context: context,
                            builder: (context) {
                              return yachtTierInfoPopUp(
                                  context, controller.user.exp);
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
                                    gradient: LinearGradient(
                                        begin: Alignment(0.0, 0.0),
                                        end: Alignment(0.0, 1.0),
                                        colors: [
                                          (controller.isUserModelLoaded)
                                              ? tierColor[
                                                  separateStringFromTier(
                                                      getTierByExp(controller
                                                          .user.exp))]!
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
                                  child: Container(
                                      height: 69.w,
                                      width: 69.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: (controller.isUserModelLoaded)
                                          ? controller.user.avatarImage != null
                                              ? FutureBuilder<String>(
                                                  future: controller
                                                      .getImageUrlFromStorage(
                                                          'avatars/${controller.user.avatarImage}.png'),
                                                  builder: (context, snapshot) {
                                                    return snapshot.hasData
                                                        ? CachedNetworkImage(
                                                            imageUrl:
                                                                snapshot.data!,
                                                          )
                                                        : Container();
                                                  })
                                              : Container()
                                          : Container())),
                              Positioned(
                                  top: 58.w,
                                  child: (controller.isUserModelLoaded)
                                      ? FutureBuilder<String>(
                                          future:
                                              controller.getImageUrlFromStorage(
                                                  tierJellyBeanURL[
                                                      separateStringFromTier(
                                                          getTierByExp(
                                                              controller.user
                                                                  .exp))]!),
                                          builder: (context, snapshot) {
                                            return snapshot.hasData
                                                ? Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Container(
                                                        width: 78.w,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              snapshot.data!,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${tierKorName[separateStringFromTier(getTierByExp(controller.user.exp))]} ${separateIntFromTier(getTierByExp(controller.user.exp))}',
                                                        style:
                                                            profileTierNameStyle,
                                                      ),
                                                    ],
                                                  )
                                                : Container();
                                          })
                                      : Container()),
                            ],
                          ),
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
                              GetBuilder<ProfileOthersViewModel>(
                                id: 'profile',
                                tag: uid,
                                builder: (controller) {
                                  if (controller.isUserModelLoaded) {
                                    return Text(
                                      '${controller.user.userName}',
                                      style: profileUserNameStyle,
                                    );
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
                                      Get.find<ProfileOthersViewModel>(tag: uid)
                                                      .user
                                                      .followers !=
                                                  null &&
                                              Get.find<ProfileOthersViewModel>(
                                                          tag: uid)
                                                      .user
                                                      .followers!
                                                      .length !=
                                                  0
                                          ? Get.to(() => FollowersNFollowingsView(
                                              isMe: false,
                                              whichfollowersOrfollowings: true,
                                              followersNFollowingsUid: Get.find<
                                                          ProfileOthersViewModel>(
                                                      tag: uid)
                                                  .user
                                                  .followers!))
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
                                        GetBuilder<ProfileOthersViewModel>(
                                          id: 'profile',
                                          tag: uid,
                                          builder: (controller) {
                                            if (controller.isUserModelLoaded) {
                                              return Text(
                                                controller.user.followers ==
                                                        null
                                                    ? '0'
                                                    : '${controller.user.followers!.length}',
                                                style: profileFollowNumberStyle,
                                              );
                                            } else {
                                              return Text(
                                                '',
                                                style: profileFollowNumberStyle,
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
                                      Get.find<ProfileOthersViewModel>(tag: uid)
                                                      .user
                                                      .followings !=
                                                  null &&
                                              Get.find<ProfileOthersViewModel>(
                                                          tag: uid)
                                                      .user
                                                      .followings!
                                                      .length !=
                                                  0
                                          ? Get.to(() => FollowersNFollowingsView(
                                              isMe: false,
                                              whichfollowersOrfollowings: false,
                                              followersNFollowingsUid: Get.find<
                                                          ProfileOthersViewModel>(
                                                      tag: uid)
                                                  .user
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
                                        GetBuilder<ProfileOthersViewModel>(
                                          id: 'profile',
                                          tag: uid,
                                          builder: (controller) {
                                            if (controller.isUserModelLoaded) {
                                              return Text(
                                                controller.user.followings ==
                                                        null
                                                    ? '0'
                                                    : '${controller.user.followings!.length}',
                                                style: profileFollowNumberStyle,
                                              );
                                            } else {
                                              return Text(
                                                '',
                                                style: profileFollowNumberStyle,
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
                          // *(내 프로필이 아닌 남의 프로필일 경우) 팔로우 버튼
                          GestureDetector(
                              onTap: () async {
                                if (profileViewModel.isFollowing)
                                  await Get.find<ProfileOthersViewModel>(
                                          tag: uid)
                                      .unFollowSomeoneMethod();
                                else
                                  await Get.find<ProfileOthersViewModel>(
                                          tag: uid)
                                      .followSomeoneMethod();

                                Get.find<ProfileOthersViewModel>(tag: uid)
                                    .reloadUserModel();
                              },
                              child: GetBuilder<ProfileOthersViewModel>(
                                id: 'profile',
                                tag: uid,
                                builder: (controller) {
                                  if (controller.isUserModelLoaded) {
                                    if (controller.isFollowing) {
                                      return Container(
                                        height: 30.w,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(70.0),
                                            border: Border.all(
                                                color: primaryButtonBackground,
                                                width: 1.5.w)),
                                        child: Center(
                                          child: Text('팔로우 중',
                                              style: profileButtonTextStyle),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 30.w,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            color: primaryButtonBackground,
                                            borderRadius:
                                                BorderRadius.circular(70.0),
                                            border: Border.all(
                                                color: primaryButtonBackground,
                                                width: 1.5.w)),
                                        child: Center(
                                          child: Text('팔로우',
                                              style: profileButtonTextStyle
                                                  .copyWith(
                                                      color: Colors.white)),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Container(
                                      height: 30.w,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(70.0),
                                          border: Border.all(
                                              color: primaryButtonBackground,
                                              width: 1.5.w)),
                                      child: Center(
                                        child: Text('',
                                            style: profileButtonTextStyle),
                                      ),
                                    );
                                  }
                                },
                              ))
                        ],
                      ),
                      SizedBox(
                          height: correctHeight(
                              14.w,
                              profileFollowTextStyle.fontSize,
                              subLeagueAwardCommentStyle.fontSize)),
                      // 유저소개글
                      GetBuilder<ProfileOthersViewModel>(
                        id: 'profile',
                        tag: uid,
                        builder: (controller) {
                          if (controller.isUserModelLoaded) {
                            return Text(
                              (controller.user.intro == null ||
                                      controller.user.intro == '')
                                  ? '소개글이 없습니다.'
                                  : '${controller.user.intro}'
                                      .replaceAll('\\n', '\n'),
                              style: subLeagueAwardCommentStyle.copyWith(
                                  letterSpacing: -0.01),
                              maxLines: 3,
                            );
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
        OtherProfileTabBarView(profileOthersViewModel: profileViewModel),
        // SizedBox(
        //     height: correctHeight(35.w, subLeagueAwardCommentStyle.fontSize,
        //         profileButtonTextStyle.fontSize)),
        // Row(
        //   children: [
        //     Flexible(
        //         child: Container(
        //       height: 24.w,
        //       child: Center(
        //         child: Text(
        //           '피드/프로',
        //           style: profileButtonTextStyle.copyWith(
        //               color: 0 == 1 ? profileButtonTextStyle.color : yachtGrey),
        //         ),
        //       ),
        //     )),
        //     Flexible(
        //         child: Container(
        //       height: 24.w,
        //       child: Center(
        //         child: Text(
        //           '리그',
        //           style: profileButtonTextStyle.copyWith(
        //               color: 1 == 1 ? profileButtonTextStyle.color : yachtGrey),
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
        //       child: Container(
        //         height: 90.w,
        //         child: Center(
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             crossAxisAlignment: CrossAxisAlignment.center,
        //             children: [
        //               Text('보유 자산',
        //                   style: subLeagueAwardCommentStyle.copyWith(
        //                       fontSize: 16.w)),
        //               SizedBox(
        //                 height: correctHeight(
        //                     10.w, 16.w, subLeagueAwardLabelStyle.fontSize),
        //               ),
        //               Text('???',
        //                   style: subLeagueAwardLabelStyle.copyWith(
        //                       letterSpacing: -0.01)),
        //             ],
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
        //               Text('순위',
        //                   style: subLeagueAwardCommentStyle.copyWith(
        //                       fontSize: 16.w)),
        //               SizedBox(
        //                   height: correctHeight(
        //                       10.w, 16.w, subLeagueAwardLabelStyle.fontSize)),
        //               // *현재 리그 순위 및 승점
        //               Text(
        //                 '7143위 | 42점',
        //                 style: subLeagueAwardLabelStyle.copyWith(
        //                     letterSpacing: -0.01),
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
        //                             future: controller.getEachQuestModel(
        //                                 userQuestModelRx[index]),
        //                             builder: (context, snapshot) {
        //                               if (!snapshot.hasData) {
        //                                 return Container();
        //                               } else {
        //                                 return InkWell(
        //                                   onTap: () {
        //                                     Get.toNamed('/quest',
        //                                         arguments: snapshot.data);
        //                                   },
        //                                   child: Row(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.start,
        //                                     children: [
        //                                       Expanded(
        //                                         child: Column(
        //                                           crossAxisAlignment:
        //                                               CrossAxisAlignment
        //                                                   .start,
        //                                           mainAxisAlignment:
        //                                               MainAxisAlignment.start,
        //                                           children: [
        //                                             Text(
        //                                               timeStampToStringWithHourMinute(
        //                                                       snapshot.data!
        //                                                           .questEndDateTime) +
        //                                                   " 마감",
        //                                               style:
        //                                                   questRecordendDateTime,
        //                                             ),
        //                                             Text(snapshot.data!.title,
        //                                                 style:
        //                                                     questRecordTitle),
        //                                             SizedBox(
        //                                                 height: correctHeight(
        //                                                     14.w,
        //                                                     questRecordTitle
        //                                                         .fontSize,
        //                                                     questRecordSelection
        //                                                         .fontSize)),
        //                                             Text(
        //                                                 controller.getUserChioce(
        //                                                     snapshot.data!,
        //                                                     userQuestModelRx[
        //                                                         index]),
        //                                                 style:
        //                                                     questRecordSelection),
        //                                             // Text(userQuestModelRx[index].selection),
        //                                           ],
        //                                         ),
        //                                       ),
        //                                       SizedBox(
        //                                         width: 30.w,
        //                                       ),
        //                                       simpleTextContainerLessRadiusButton(
        //                                           "퀘스트 보기")
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
        // GetBuilder<ProfileOthersViewModel>(
        //   id: 'favorites',
        //   builder: (controller) {
        //     if (controller.isUserModelLoaded && controller.isFavoritesLoaded) {
        //       // 굳이 이렇게 조건을 중첩한 이유는 그냥 혹시 먼저 뜨게되면 부자연스러울 것 같아서.
        //       return ProfileViewFavoritesCardWidget(
        //         favoriteStockModels: controller.favoriteStockModels,
        //         favoriteStockHistoricalPriceModels:
        //             controller.favoriteStockHistoricalPriceModels,
        //       );
        //     } else {
        //       return Container();
        //     }
        //   },
        // ),
        SizedBox(
          height: 50.w,
        ),
        // Padding(
        //   padding: EdgeInsets.only(left: 14.w, right: 0.w, bottom: 20.w),
        //   child: Row(
        //     children: [
        //       Text(
        //         '획득한 뱃지',
        //         style: profileHeaderTextStyle,
        //       ),
        //       Spacer(),
        //       GestureDetector(
        //         behavior: HitTestBehavior.opaque,
        //         onTap: () {
        //           Get.to(() => BadgesFullGridView(
        //                 badges: Get.find<ProfileOthersViewModel>(tag: uid).user.badges != null
        //                     ? Get.find<ProfileOthersViewModel>(tag: uid).user.badges!
        //                     : [],
        //               ));
        //         },
        //         child: Row(
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
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        // GetBuilder<ProfileOthersViewModel>(
        //   id: 'profile',
        //   tag: uid,
        //   builder: (controller) {
        //     if (controller.isUserModelLoaded && controller.user.badges != null) {
        //       return BadgesGridView(isFull: false, badges: controller.user.badges!);
        //     } else {
        //       return BadgesGridView(
        //         isFull: false,
        //         badges: [],
        //       );
        //     }
        //   },
        // ),
        // SizedBox(
        //   height: 50.w,
        // ),
      ]),
    );
  }
}

class OtherProfileTabBarView extends StatefulWidget {
  final ProfileOthersViewModel profileOthersViewModel;

  const OtherProfileTabBarView({Key? key, required this.profileOthersViewModel})
      : super(key: key);
  @override
  State<OtherProfileTabBarView> createState() => _OtherProfileTabBarViewState();
}

class _OtherProfileTabBarViewState extends State<OtherProfileTabBarView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  final RankController rankController = Get.find<RankController>();

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
    final ProfileOthersViewModel profileOthersViewModel =
        widget.profileOthersViewModel;
    // TODO: implement build
    return Container(
      child: Column(children: [
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
                    '활동',
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
          decoration: BoxDecoration(
              border: Border(
            top: BorderSide(width: 1.0, color: dividerColor),
          )),
          // height: 90.w,
          child: ExpandablePageView(
            key: UniqueKey(),
            onPageChanged: (index) {
              if (index == 0) {
                // myFeedViewModel.getMyFeed(userModelRx.value!.uid);
              }
              tabIndex(index);
              tabController.animateTo(index);
            },
            controller: pageController,
            children: [
              // MyFeedView(),
              MyFeedView(profileOthersViewModel.uid),
              Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            yachtSnackBar("다른 유저의 보유 자산은 볼 수 없어요.");
                            // Get.to(() => AssetView());
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
                                  Text(
                                    '??? 원',
                                    style: subLeagueAwardLabelStyle.copyWith(
                                        letterSpacing: -0.01),
                                  ),
                                  // *보유자산
                                  // GetBuilder<ProfileOthersViewModel>(
                                  //     id: 'profile',
                                  //     builder: (controller) {
                                  //       if (controller.isUserModelLoaded) {
                                  //         return GetBuilder<AssetViewModel>(
                                  //             id: 'holdingStocks',
                                  //             builder: (assetController) {
                                  //               if (assetController.isHoldingStocksFutureLoad) {
                                  //                 return Text(
                                  //                   '${toPriceKRW(assetController.totalHoldingStocksValue + assetController.totalYachtPoint)}원',
                                  //                   style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
                                  //                 );
                                  //               } else {
                                  //                 return Text('',
                                  //                     style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01));
                                  //               }
                                  //             });
                                  //       } else {
                                  //         return Text('???',
                                  //             style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01));
                                  //       }
                                  //     }),
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
                              child: FutureBuilder<List<Map<String, int>>>(
                                  future: rankController.getOtherUserRanks(
                                      profileOthersViewModel.uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        height: 90.w,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('순위',
                                                  style:
                                                      subLeagueAwardCommentStyle
                                                          .copyWith(
                                                              fontSize: 16.w)),
                                              SizedBox(
                                                  height: correctHeight(
                                                      10.w,
                                                      16.w,
                                                      subLeagueAwardLabelStyle
                                                          .fontSize)),
                                              // *현재 리그 순위 및 승점
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    snapshot.data![0]
                                                                ['todayRank'] ==
                                                            null
                                                        ? ""
                                                        : snapshot.data![0][
                                                                    'todayRank']! !=
                                                                0
                                                            ? '${snapshot.data![0]['todayRank']!}위 |'
                                                            : '없음 |',
                                                    style:
                                                        subLeagueAwardLabelStyle
                                                            .copyWith(
                                                                letterSpacing:
                                                                    -0.01),
                                                  ),
                                                  Text(
                                                    ' ${snapshot.data![0]['todayPoint'] ?? 0}',
                                                    style:
                                                        subLeagueAwardLabelStyle
                                                            .copyWith(
                                                                letterSpacing:
                                                                    -0.01),
                                                  ),
                                                  Text(
                                                    '점',
                                                    style:
                                                        subLeagueAwardLabelStyle
                                                            .copyWith(
                                                                letterSpacing:
                                                                    -0.01),
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
                                      );
                                    } else {
                                      return Container(
                                        height: 90.w,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('순위',
                                                  style:
                                                      subLeagueAwardCommentStyle
                                                          .copyWith(
                                                              fontSize: 16.w)),
                                              SizedBox(
                                                  height: correctHeight(
                                                      10.w,
                                                      16.w,
                                                      subLeagueAwardLabelStyle
                                                          .fontSize)),
                                              // *현재 리그 순위 및 승점
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '- | ',
                                                    style:
                                                        subLeagueAwardLabelStyle
                                                            .copyWith(
                                                                letterSpacing:
                                                                    -0.01),
                                                  ),
                                                  Text(
                                                    '-',
                                                    style:
                                                        subLeagueAwardLabelStyle
                                                            .copyWith(
                                                                letterSpacing:
                                                                    -0.01),
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
                                      );
                                      ;
                                    }
                                  }),
                            );
                          }),
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
                    () =>
                        profileOthersViewModel.otherUserQuestModels.length == 0
                            ? Image.asset(
                                'assets/illusts/not_exists/no_quest_done.png',
                                height: 150.w)
                            : Column(
                                children: List.generate(
                                    profileOthersViewModel
                                        .otherUserQuestModels.length,
                                    (index) => Column(
                                          children: [
                                            Padding(
                                              padding: primaryHorizontalPadding,
                                              child: Obx(
                                                () => sectionBox(
                                                    padding: primaryAllPadding,
                                                    child: FutureBuilder<
                                                            QuestModel>(
                                                        future: profileOthersViewModel
                                                            .getEachQuestModel(
                                                                profileOthersViewModel
                                                                        .otherUserQuestModels[
                                                                    index]),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Container();
                                                          } else {
                                                            return InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            ResultDialog(
                                                                              questModel: snapshot.data!,
                                                                            ));

                                                                // Get.toNamed('/quest',
                                                                //     arguments:
                                                                //         snapshot.data);
                                                              },
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          timeStampToStringWithHourMinute(snapshot.data!.questEndDateTime) +
                                                                              " 마감",
                                                                          style:
                                                                              questRecordendDateTime,
                                                                        ),
                                                                        Text(
                                                                            snapshot
                                                                                .data!.title,
                                                                            style:
                                                                                questRecordTitle),
                                                                        SizedBox(
                                                                            height: correctHeight(
                                                                                14.w,
                                                                                questRecordTitle.fontSize,
                                                                                questRecordSelection.fontSize)),
                                                                        Text(
                                                                            profileOthersViewModel.getUserChioce(snapshot.data!,
                                                                                profileOthersViewModel.otherUserQuestModels[index]),
                                                                            style: questRecordSelection),
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
                                            if (index !=
                                                userQuestModelRx.length)
                                              SizedBox(
                                                height: 10.w,
                                              )
                                          ],
                                        )),
                              ),
                  ),
                  SizedBox(
                    height: 50.w,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 14.w, right: 0.w, bottom: 20.w),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        profileOthersViewModel.user.badges == null
                            ? Get.to(() => BadgesFullGridView(
                                  badges: [],
                                ))
                            : Get.to(() => BadgesFullGridView(
                                  badges: profileOthersViewModel.user.badges!,
                                ));
                      },
                      child: Row(
                        children: [
                          Text(
                            '획득한 뱃지',
                            style: profileHeaderTextStyle,
                          ),
                          Spacer(),
                          Row(
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
                          )
                        ],
                      ),
                    ),
                  ),
                  GetBuilder<ProfileOthersViewModel>(
                      id: 'profile',
                      init: ProfileOthersViewModel(
                          uid: profileOthersViewModel.uid),
                      builder: (controller) {
                        return (!controller.isUserModelLoaded ||
                                controller.user.badges == null ||
                                controller.user.badges!.length == 0)
                            ? BadgesGridView(isFull: false, badges: [])
                            : BadgesGridView(
                                isFull: false,
                                badges: controller.user.badges!,
                              );
                      }),

                  // (controller.user.badges != null && controller.isUserModelLoaded)
                  //   ? BadgesGridView(isFull: false, badges: controller.user.badges!)
                  //   : BadgesGridView(
                  //       isFull: false,
                  //       badges: [],
                  //     );

                  SizedBox(
                    height: 50.w,
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
