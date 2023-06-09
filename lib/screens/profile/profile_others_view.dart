import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/handlers/user_tier_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/profile/my_feed_view.dart';
import 'package:yachtOne/screens/quest/result/quest_result_widget.dart';
import 'package:yachtOne/screens/ranks/rank_controller.dart';
import 'package:yachtOne/screens/ranks/rank_share_view.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';
import '../../handlers/numbers_handler.dart';
import '../../locator.dart';
import '../../styles/size_config.dart';

import 'asset_view.dart';
import 'asset_view_model.dart';
import 'profile_change_view.dart';
import '../settings/setting_view.dart';
import 'profile_others_view_model.dart';
import 'profile_share_ui.dart';
import 'quest_record_detail_view.dart';

class ProfileOthersView extends GetView<ProfileOthersViewModel> {
  final String uid;
  ProfileOthersView({required this.uid});

  // final ProfileOthersViewModel profileViewModel =
  //     Get.put(ProfileOthersViewModel(uid: 'kakao:1513684681'));

  // get controller => Get.put(ProfileOthersViewModel(uid: uid));

  @override
  Widget build(BuildContext context) {
    final ProfileOthersViewModel profileViewModel = Get.put(ProfileOthersViewModel(uid: uid), tag: uid);

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: primaryAppBar('프로필'),
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
                              return yachtTierInfoPopUp(context, controller.user.exp);
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
                                          ? tierColor[separateStringFromTier(getTierByExp(controller.user.exp))]!
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
                                  child: Container(
                                      height: 69.w,
                                      width: 69.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: (controller.isUserModelLoaded)
                                          ? controller.user.avatarImage != null
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${controller.user.avatarImage}.png",
                                                )
                                              : Container()
                                          : Container())),
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
                                                    "https://storage.googleapis.com/ggook-5fb08.appspot.com/${tierJellyBeanURL[separateStringFromTier(getTierByExp(controller.user.exp))]!}",
                                              ),
                                            ),
                                            Text(
                                              '${tierKorName[separateStringFromTier(getTierByExp(controller.user.exp))]} ${separateIntFromTier(getTierByExp(controller.user.exp))}',
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
                  width: 16.w,
                ),
                Container(
                  width: SizeConfig.screenWidth - 14.w - 14.w - 79.w - 16.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: correctHeight(5.w, 0.0, profileUserNameStyle.fontSize),
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
                                height:
                                    correctHeight(10.w, profileUserNameStyle.fontSize, profileFollowTextStyle.fontSize),
                              ),
                              // 팔로워 숫자 / 팔로잉 숫자
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.find<ProfileOthersViewModel>(tag: uid).user.followers != null &&
                                              Get.find<ProfileOthersViewModel>(tag: uid).user.followers!.length != 0
                                          ? Get.to(() => FollowersNFollowingsView(
                                              isMe: false,
                                              whichfollowersOrfollowings: true,
                                              followersNFollowingsUid:
                                                  Get.find<ProfileOthersViewModel>(tag: uid).user.followers!))
                                          : Get.to(() => NullFollowersNFollowingsView(
                                                whichNULLfollowersOrfollowings: true,
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
                                                controller.user.followers == null
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
                                      Get.find<ProfileOthersViewModel>(tag: uid).user.followings != null &&
                                              Get.find<ProfileOthersViewModel>(tag: uid).user.followings!.length != 0
                                          ? Get.to(() => FollowersNFollowingsView(
                                              isMe: false,
                                              whichfollowersOrfollowings: false,
                                              followersNFollowingsUid:
                                                  Get.find<ProfileOthersViewModel>(tag: uid).user.followings!))
                                          : Get.to(() => NullFollowersNFollowingsView(
                                                whichNULLfollowersOrfollowings: false,
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
                                                controller.user.followings == null
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
                                  await Get.find<ProfileOthersViewModel>(tag: uid).unFollowSomeoneMethod();
                                else
                                  await Get.find<ProfileOthersViewModel>(tag: uid).followSomeoneMethod();

                                Get.find<ProfileOthersViewModel>(tag: uid).reloadUserModel();
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
                                            borderRadius: BorderRadius.circular(70.0),
                                            border: Border.all(color: primaryButtonBackground, width: 1.5.w)),
                                        child: Center(
                                          child: Text('팔로우 중', style: profileButtonTextStyle),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 30.w,
                                        width: 100.w,
                                        decoration: BoxDecoration(
                                            color: primaryButtonBackground,
                                            borderRadius: BorderRadius.circular(70.0),
                                            border: Border.all(color: primaryButtonBackground, width: 1.5.w)),
                                        child: Center(
                                          child:
                                              Text('팔로우', style: profileButtonTextStyle.copyWith(color: Colors.white)),
                                        ),
                                      );
                                    }
                                  } else {
                                    return Container(
                                      height: 30.w,
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(70.0),
                                          border: Border.all(color: primaryButtonBackground, width: 1.5.w)),
                                      child: Center(
                                        child: Text('', style: profileButtonTextStyle),
                                      ),
                                    );
                                  }
                                },
                              ))
                        ],
                      ),
                      SizedBox(
                          height: correctHeight(
                              14.w, profileFollowTextStyle.fontSize, subLeagueAwardCommentStyle.fontSize)),
                      // 유저소개글
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GetBuilder<ProfileOthersViewModel>(
                              id: 'profile',
                              tag: uid,
                              builder: (controller) {
                                if (controller.isUserModelLoaded) {
                                  return Text(
                                    (controller.user.intro == null || controller.user.intro == '')
                                        ? '소개글이 없습니다.'
                                        : '${controller.user.intro}'.replaceAll('\\n', '\n'),
                                    style: subLeagueAwardCommentStyle.copyWith(letterSpacing: -0.01),
                                    maxLines: 3,
                                  );
                                } else {
                                  return Text(
                                    '',
                                    style: subLeagueAwardCommentStyle.copyWith(letterSpacing: -0.01),
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 6.w),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                        backgroundColor: yachtDarkGrey,
                                        insetPadding: defaultHorizontalPadding,
                                        child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                14.w, correctHeight(14.w, 0.0, dialogTitle.fontSize), 14.w, 14.w),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("알림", style: dialogTitle),
                                                SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                                Text("이 유저를 신고하시겠습니까?", style: dialogContent),
                                                Text(
                                                  "신고한 유저는 자동으로 차단되며\n해당 유저의 콘텐츠를 볼 수 없습니다.",
                                                  style: dialogWarning.copyWith(color: yachtLightGrey),
                                                ),
                                                SizedBox(height: correctHeight(24.w, 0.w, dialogContent.fontSize)),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: GestureDetector(
                                                          onTap: () async {
                                                            HapticFeedback.lightImpact();
                                                            await profileViewModel.blockThisUser(uid);
                                                            await profileViewModel.reportThisUserFromProfile(uid);
                                                            Navigator.of(context).pop();
                                                            Get.back();
                                                            yachtSnackBar("유저를 신고/차단하였습니다");
                                                          },
                                                          child: textContainerButtonWithOptions(
                                                            text: "신고하기",
                                                            isDarkBackground: true,
                                                            height: 44.w,
                                                          )),
                                                    ),
                                                    SizedBox(width: 8.w),
                                                    Expanded(
                                                      child: InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).pop();
                                                            // Get.back(closeOverlays: true);
                                                          },
                                                          child: textContainerButtonWithOptions(
                                                              text: "취소", isDarkBackground: false, height: 44.w)),
                                                    )
                                                  ],
                                                )
                                              ],
                                            )));
                                  });
                            },
                            child: Container(
                                width: 60.w,
                                height: 30.w,
                                // color: Colors.blue,
                                child: Text(
                                  " 신고/차단",
                                  style: subLeagueAwardCommentStyle.copyWith(
                                    fontSize: 12.w,
                                    letterSpacing: -0.01,
                                    color: yachtRed,
                                  ),
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )),
        OtherProfileTabBarView(tag: uid),
        // OtherProfileTabBarView(profileOthersViewModel: profileViewModel),
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
  final String tag;
  // final ProfileOthersViewModel profileOthersViewModel;

  const OtherProfileTabBarView({Key? key, required this.tag})
      // const OtherProfileTabBarView({Key? key, required this.profileOthersViewModel})
      : super(key: key);
  @override
  State<OtherProfileTabBarView> createState() => _OtherProfileTabBarViewState();
}

class _OtherProfileTabBarViewState extends State<OtherProfileTabBarView> with SingleTickerProviderStateMixin {
  late TabController tabController;
  late PageController pageController;
  final RankController rankController = Get.find<RankController>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  void initState() {
    print('otherProfileTabBarView init');
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
    final ProfileOthersViewModel profileOthersViewModel = Get.find<ProfileOthersViewModel>(tag: widget.tag);
    // widget.profileOthersViewModel;

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
                        color: tabIndex.value == 0 ? profileButtonTextStyle.color : yachtGrey),
                  ),
                ),
              ),
              Container(
                height: 30.w,
                child: Center(
                  child: Text(
                    '활동',
                    style: profileButtonTextStyle.copyWith(
                        color: tabIndex.value == 1 ? profileButtonTextStyle.color : yachtGrey),
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
            // key: UniqueKey(), => 얘 하면 피드 디테일뷰>다시 복귀하면 피드탭이 아니라 활동탭으로 돌아가는 버그 발생
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
                            _mixpanelService.mixpanel.track(
                              'My Asset',
                              properties: {'My Asset Tap From': "유저 프로필-보유자산"},
                            );
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
                                  Text('보유 자산', style: subLeagueAwardCommentStyle.copyWith(fontSize: 16.w)),
                                  SizedBox(
                                    height: correctHeight(10.w, 16.w, subLeagueAwardLabelStyle.fontSize),
                                  ),
                                  Text(
                                    '??? 원',
                                    style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
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
                                  future: rankController.getOtherUserRanks(profileOthersViewModel.uid),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return InkWell(
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
                                                    height:
                                                        correctHeight(10.w, 16.w, subLeagueAwardLabelStyle.fontSize)),
                                                // *현재 리그 순위 및 승점
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      snapshot.data![0]['todayRank'] == null
                                                          ? ""
                                                          : snapshot.data![0]['todayRank']! != 0
                                                              ? '${snapshot.data![0]['todayRank']!}위 |'
                                                              : '없음 |',
                                                      style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
                                                    ),
                                                    Text(
                                                      ' ${snapshot.data![0]['todayPoint'] ?? 0}',
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
                                      );
                                    } else {
                                      return Container(
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
                                                    '- | ',
                                                    style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
                                                  ),
                                                  Text(
                                                    '-',
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
                    height: correctHeight(30.w, 0.0, profileHeaderTextStyle.fontSize),
                  ),
                  Padding(
                    padding: defaultHorizontalPadding,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Get.to(() => QuestRecordOthersDetailView(tag: widget.tag));
                      },
                      child: Row(
                        children: [
                          Text(
                            '퀘스트 참여기록',
                            style: profileHeaderTextStyle,
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Container(
                                width: 8.w,
                              ),
                              Image.asset(
                                'assets/icons/navigate_foward_arrow.png',
                                height: 16.w,
                                width: 9.w,
                                color: yachtWhite,
                              ),
                              Container(
                                width: 14.w,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: correctHeight(20.w, profileHeaderTextStyle.fontSize, 0.0),
                  ),
                  Obx(() => profileOthersViewModel.otherUserQuestModels.length == 0
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
                          : QuestRecordOthersView(isFullView: false, tag: widget.tag)
                      // Column(
                      //     children: List.generate(
                      //         min(
                      //             profileOthersViewModel
                      //                 .otherUserQuestModels.length,
                      //             3),
                      //         (index) => Column(
                      //               children: [
                      //                 Padding(
                      //                   padding: defaultHorizontalPadding,
                      //                   child: Obx(
                      //                     () => sectionBox(
                      //                         padding: defaultPaddingAll,
                      //                         child: FutureBuilder<
                      //                                 QuestModel>(
                      //                             future: profileOthersViewModel
                      //                                 .getEachQuestModel(
                      //                                     profileOthersViewModel
                      //                                             .otherUserQuestModels[
                      //                                         index]),
                      //                             builder: (context,
                      //                                 snapshot) {
                      //                               if (!snapshot
                      //                                   .hasData) {
                      //                                 return Container();
                      //                               } else {
                      //                                 return InkWell(
                      //                                   onTap: () {
                      //                                     // showDialog(
                      //                                     //     context: context,
                      //                                     //     builder: (context) => ResultDialog(
                      //                                     //           questModel: snapshot.data!,
                      //                                     //           otherUserQuestModel: profileOthersViewModel
                      //                                     //               .otherUserQuestModels[index],
                      //                                     //           otherUserExp: profileOthersViewModel.user.exp,
                      //                                     //         ));

                      //                                     // Get.toNamed('/quest',
                      //                                     //     arguments:
                      //                                     //         snapshot.data);
                      //                                   },
                      //                                   child: Row(
                      //                                     crossAxisAlignment:
                      //                                         CrossAxisAlignment
                      //                                             .start,
                      //                                     children: [
                      //                                       Expanded(
                      //                                         child:
                      //                                             Column(
                      //                                           crossAxisAlignment:
                      //                                               CrossAxisAlignment
                      //                                                   .start,
                      //                                           mainAxisAlignment:
                      //                                               MainAxisAlignment
                      //                                                   .start,
                      //                                           children: [
                      //                                             Text(
                      //                                               timeStampToStringWithHourMinute(snapshot.data!.questEndDateTime) +
                      //                                                   " 마감",
                      //                                               style:
                      //                                                   questRecordendDateTime,
                      //                                             ),
                      //                                             Text(
                      //                                                 snapshot
                      //                                                     .data!.title,
                      //                                                 style:
                      //                                                     questRecordTitle),
                      //                                             SizedBox(
                      //                                                 height: correctHeight(
                      //                                                     14.w,
                      //                                                     questRecordTitle.fontSize,
                      //                                                     questRecordSelection.fontSize)),
                      //                                             Text(
                      //                                                 profileOthersViewModel.getUserChioce(snapshot.data!,
                      //                                                     profileOthersViewModel.otherUserQuestModels[index]),
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
                      //                 if (index !=
                      //                     min(
                      //                             profileOthersViewModel
                      //                                 .otherUserQuestModels
                      //                                 .length,
                      //                             3) -
                      //                         1)
                      //                   SizedBox(
                      //                     height: 10.w,
                      //                   )
                      //               ],
                      //             )),
                      //   ),
                      ),
                  SizedBox(
                    height: 50.w,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 14.w, right: 0.w, bottom: 20.w),
                  //   child: GestureDetector(
                  //     behavior: HitTestBehavior.opaque,
                  //     onTap: () {
                  //       profileOthersViewModel.user.badges == null
                  //           ? Get.to(() => BadgesFullGridView(
                  //                 badges: [],
                  //               ))
                  //           : Get.to(() => BadgesFullGridView(
                  //                 badges: profileOthersViewModel.user.badges!,
                  //               ));
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
                  // GetBuilder<ProfileOthersViewModel>(
                  //     id: 'profile',
                  //     tag: widget.tag,
                  //     // init: ProfileOthersViewModel(
                  //     //     uid: profileOthersViewModel.uid),
                  //     builder: (controller) {
                  //       return (!controller.isUserModelLoaded ||
                  //               controller.user.badges == null ||
                  //               controller.user.badges!.length == 0)
                  //           ? BadgesGridView(isFull: false, badges: [])
                  //           : BadgesGridView(
                  //               isFull: false,
                  //               badges: controller.user.badges!,
                  //             );
                  //     }),

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

class QuestRecordOthersView extends StatelessWidget {
  final bool isFullView;
  final String tag;
  final int maxNum = 3;

  QuestRecordOthersView({required this.isFullView, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          isFullView
              ? Get.find<ProfileOthersViewModel>(tag: tag).otherUserQuestModels.length
              : min(Get.find<ProfileOthersViewModel>(tag: tag).otherUserQuestModels.length, maxNum),
          (index) => Column(
                children: [
                  Padding(
                    padding: defaultHorizontalPadding,
                    child: Obx(
                      () => sectionBox(
                          padding: defaultPaddingAll,
                          child: FutureBuilder<QuestModel>(
                              future: Get.find<ProfileOthersViewModel>(tag: tag).getEachQuestModel(
                                  Get.find<ProfileOthersViewModel>(tag: tag).otherUserQuestModels[index]),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      // showDialog(
                                      //     context: context,
                                      //     builder: (context) => ResultDialog(
                                      //           questModel: snapshot.data!,
                                      //         ));

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
                                                style: questRecordendDateTime,
                                              ),
                                              SizedBox(height: 6.w),
                                              Text(snapshot.data!.title, style: questRecordTitle),
                                              SizedBox(
                                                  height: correctHeight(
                                                      14.w, questRecordTitle.fontSize, questRecordSelection.fontSize)),
                                              Text(
                                                  Get.find<ProfileOthersViewModel>(tag: tag).getUserChioce(
                                                      snapshot.data!,
                                                      Get.find<ProfileOthersViewModel>(tag: tag)
                                                          .otherUserQuestModels[index]),
                                                  style: questRecordSelection),
                                              // Text(userQuestModelRx[index].selection),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            // Spacer(),
                                            Container(
                                              // alignment: Alignment.bottomCenter,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 5.w,
                                              ),
                                              decoration: BoxDecoration(
                                                color: buttonNormal,
                                                borderRadius: BorderRadius.circular(8.w),
                                              ),

                                              // height: 300,
                                              child: Center(
                                                child: Text(
                                                  snapshot.data!.results == null
                                                      ? "진행 중"
                                                      : Get.find<ProfileOthersViewModel>(tag: tag)
                                                                  .otherUserQuestModels[index]
                                                                  .hasSucceeded ==
                                                              true
                                                          ? "예측 성공"
                                                          : "예측 실패",
                                                  style: questRecordSelection.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: snapshot.data!.results == null
                                                        ? yachtBlack
                                                        : Get.find<ProfileOthersViewModel>(tag: tag)
                                                                    .otherUserQuestModels[index]
                                                                    .hasSucceeded ==
                                                                true
                                                            ? yachtRed
                                                            : yachtGrey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 5.w,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius: BorderRadius.circular(8.w),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "예측 실패",
                                                  style: questRecordSelection.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
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
