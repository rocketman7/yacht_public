import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/user_tier_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../handlers/numbers_handler.dart';
import '../../styles/size_config.dart';

import 'asset_view.dart';
import 'asset_view_model.dart';
import 'profile_change_view.dart';
import 'profile_controller.dart';
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
        Get.put(ProfileOthersViewModel(uid: uid));

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
                                            ? tierColor[separateStringFromTier(
                                                getTierByExp(
                                                    controller.user.exp))]!
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
                                    ? controller.user.tier != null
                                        ? FutureBuilder<String>(
                                            future: controller
                                                .getImageUrlFromStorage(
                                                    tierJellyBeanURL[
                                                        separateStringFromTier(
                                                            getTierByExp(
                                                                controller.user
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
                              GetBuilder<ProfileOthersViewModel>(
                                id: 'profile',
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
                                      controller.user.followers != null &&
                                              controller
                                                      .user.followers!.length !=
                                                  0
                                          ? Get.to(() =>
                                              FollowersNFollowingsView(
                                                  isMe: false,
                                                  whichfollowersOrfollowings:
                                                      true,
                                                  followersNFollowingsUid:
                                                      controller
                                                          .user.followers!))
                                          : Get.to(() =>
                                              NullFollowersNFollowingsView(
                                                whichNULLfollowersOrfollowings:
                                                    true,
                                              ));
                                    },
                                    child: Row(
                                      children: [
                                        GetBuilder<ProfileOthersViewModel>(
                                          id: 'profile',
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
                                        Text(
                                          '팔로워',
                                          style: profileFollowTextStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 17.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.user.followings != null &&
                                              controller.user.followings!
                                                      .length !=
                                                  0
                                          ? Get.to(() =>
                                              FollowersNFollowingsView(
                                                  isMe: false,
                                                  whichfollowersOrfollowings:
                                                      false,
                                                  followersNFollowingsUid:
                                                      controller
                                                          .user.followings!))
                                          : Get.to(() =>
                                              NullFollowersNFollowingsView(
                                                whichNULLfollowersOrfollowings:
                                                    false,
                                              ));
                                    },
                                    child: Row(
                                      children: [
                                        GetBuilder<ProfileOthersViewModel>(
                                          id: 'profile',
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
                                        Text(
                                          '팔로잉',
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
                          // *(내 프로필이 아닌 남의 프로필일 경우) 팔로우 버튼
                          GestureDetector(
                              onTap: () async {
                                if (profileViewModel.isFollowing)
                                  await Get.find<ProfileOthersViewModel>()
                                      .unFollowSomeoneMethod();
                                else
                                  await Get.find<ProfileOthersViewModel>()
                                      .followSomeoneMethod();

                                Get.find<ProfileOthersViewModel>()
                                    .reloadUserModel();
                              },
                              child: GetBuilder<ProfileOthersViewModel>(
                                id: 'profile',
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
                                          child: Text('팔로잉',
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
                        builder: (controller) {
                          if (controller.isUserModelLoaded) {
                            return Text(
                              controller.user.intro == null
                                  ? '소개글이 없습니다.'
                                  : '${controller.user.intro}'
                                      .replaceAll('\\n', '\n'),
                              style: subLeagueAwardCommentStyle.copyWith(
                                  letterSpacing: -0.01),
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
        SizedBox(
            height: correctHeight(35.w, subLeagueAwardCommentStyle.fontSize,
                profileButtonTextStyle.fontSize)),
        Row(
          children: [
            Flexible(
                child: Container(
              height: 24.w,
              child: Center(
                child: Text(
                  '피드/프로',
                  style: profileButtonTextStyle.copyWith(
                      color: 0 == 1 ? profileButtonTextStyle.color : yachtGrey),
                ),
              ),
            )),
            Flexible(
                child: Container(
              height: 24.w,
              child: Center(
                child: Text(
                  '리그',
                  style: profileButtonTextStyle.copyWith(
                      color: 1 == 1 ? profileButtonTextStyle.color : yachtGrey),
                ),
              ),
            )),
          ],
        ),
        Container(
          height: 7.5.w,
          width: SizeConfig.screenWidth,
          child: Stack(
            children: [
              Positioned(
                top: 6.5.w,
                child: Container(
                  height: 1.w,
                  width: SizeConfig.screenWidth,
                  color: dividerColor,
                ),
              ),
              Positioned(
                top: 4.0.w,
                child: Container(
                  height: 3.w,
                  width: SizeConfig.screenWidth / 2,
                  color: 0 == 1 ? primaryButtonBackground : Colors.transparent,
                ),
              ),
              Positioned(
                top: 4.0.w,
                left: SizeConfig.screenWidth / 2,
                child: Container(
                  height: 3.w,
                  width: SizeConfig.screenWidth / 2,
                  color: 1 == 1 ? primaryButtonBackground : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Flexible(
              child: Container(
                height: 90.w,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('보유 자산',
                          style: subLeagueAwardCommentStyle.copyWith(
                              fontSize: 16.w)),
                      SizedBox(
                        height: correctHeight(
                            10.w, 16.w, subLeagueAwardLabelStyle.fontSize),
                      ),
                      Text('???',
                          style: subLeagueAwardLabelStyle.copyWith(
                              letterSpacing: -0.01)),
                    ],
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
                          style: subLeagueAwardCommentStyle.copyWith(
                              fontSize: 16.w)),
                      SizedBox(
                          height: correctHeight(
                              10.w, 16.w, subLeagueAwardLabelStyle.fontSize)),
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
          height: correctHeight(30.w, 0.0, profileHeaderTextStyle.fontSize),
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
          height: correctHeight(20.w, profileHeaderTextStyle.fontSize, 0.0),
        ),
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
      ]),
    );
  }
}
