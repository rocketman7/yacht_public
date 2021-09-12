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

class ProfileView extends GetView<ProfileController> {
  final String uid;

  get controller => Get.put(ProfileController(uid: uid));

  ProfileView({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        // appBar: primaryAppBar('프로필'),
        appBar: AppBar(
          backgroundColor: white,
          toolbarHeight: 60.w,
          title: Text('프로필', style: appBarTitle),
          actions: [
            userModelRx.value!.uid == uid
                ? Row(
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
                : Container(),
          ],
        ),
        body: ListView(children: [
          Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 11.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GetBuilder<ProfileController>(
                      id: 'profile',
                      init: ProfileController(uid: uid),
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
                                  child: controller.isMe
                                      ? Obx(() => Container(
                                          height: 69.w,
                                          width: 69.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: userModelRx.value!.avatarImage != null
                                              ? FutureBuilder<String>(
                                                  future: controller.getImageUrlFromStorage(
                                                      'avatars/${userModelRx.value!.avatarImage!}.png'),
                                                  builder: (context, snapshot) {
                                                    return snapshot.hasData
                                                        ? CachedNetworkImage(
                                                            imageUrl: snapshot.data!,
                                                          )
                                                        : Container();
                                                  })
                                              : Container()))
                                      : Container(
                                          height: 69.w,
                                          width: 69.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: (controller.isUserModelLoaded)
                                              ? controller.user.avatarImage != null
                                                  ? FutureBuilder<String>(
                                                      future: controller.getImageUrlFromStorage(
                                                          'avatars/${controller.user.avatarImage}.png'),
                                                      builder: (context, snapshot) {
                                                        return snapshot.hasData
                                                            ? CachedNetworkImage(
                                                                imageUrl: snapshot.data!,
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
                                              future: controller.getImageUrlFromStorage(tierJellyBeanURL[
                                                  separateStringFromTier(getTierByExp(controller.user.exp))]!),
                                              builder: (context, snapshot) {
                                                return snapshot.hasData
                                                    ? Stack(
                                                        alignment: Alignment.center,
                                                        children: [
                                                          Container(
                                                            width: 78.w,
                                                            child: CachedNetworkImage(
                                                              imageUrl: snapshot.data!,
                                                            ),
                                                          ),
                                                          Text(
                                                            '${tierKorName[separateStringFromTier(getTierByExp(controller.user.exp))]} ${separateIntFromTier(getTierByExp(controller.user.exp))}',
                                                            style: profileTierNameStyle,
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
                          height: correctHeight(5.w, 0.0, profileUserNameStyle.fontSize),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 유저아이디
                                GetBuilder<ProfileController>(
                                  id: 'profile',
                                  builder: (controller) {
                                    if (controller.isUserModelLoaded) {
                                      return controller.isMe
                                          ? Obx(() => Text(
                                                '${userModelRx.value!.userName}',
                                                style: profileUserNameStyle,
                                              ))
                                          : Text(
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
                                      10.w, profileUserNameStyle.fontSize, profileFollowTextStyle.fontSize),
                                ),
                                // 팔로워 숫자 / 팔로잉 숫자
                                Row(
                                  children: [
                                    GetBuilder<ProfileController>(
                                      id: 'profile',
                                      builder: (controller) {
                                        if (controller.isUserModelLoaded) {
                                          return controller.isMe
                                              ? Obx(() => Text(
                                                    userModelRx.value!.followers == null
                                                        ? '0'
                                                        : '${userModelRx.value!.followers!.length}',
                                                    style: profileFollowNumberStyle,
                                                  ))
                                              : Text(
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
                                    Text(
                                      '팔로워',
                                      style: profileFollowTextStyle,
                                    ),
                                    SizedBox(
                                      width: 17.w,
                                    ),
                                    GetBuilder<ProfileController>(
                                      id: 'profile',
                                      builder: (controller) {
                                        if (controller.isUserModelLoaded) {
                                          return controller.isMe
                                              ? Obx(() => Text(
                                                    userModelRx.value!.followings == null
                                                        ? '0'
                                                        : '${userModelRx.value!.followings!.length}',
                                                    style: profileFollowNumberStyle,
                                                  ))
                                              : Text(
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
                                    Text(
                                      '팔로잉',
                                      style: profileFollowTextStyle,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            // *(내 프로필이 아닌 남의 프로필일 경우) 팔로우 버튼
                            GestureDetector(
                              onTap: () {
                                if (Get.find<ProfileController>().isMe) {
                                  Get.to(() => ProfileChangeView());
                                } else {
                                  // 팔로우기능
                                  Get.find<ProfileController>().followSomeoneMethod();
                                }
                              },
                              child: Container(
                                height: 30.w,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(70.0),
                                  border: Border.all(color: primaryButtonBackground, width: 1.5.w),
                                ),
                                child: Center(
                                  child: GetBuilder<ProfileController>(
                                    id: 'profile',
                                    builder: (controller) {
                                      if (controller.isUserModelLoaded) {
                                        if (controller.isMe) {
                                          return Text(
                                            '프로필 수정',
                                            style: profileButtonTextStyle,
                                          );
                                        } else {
                                          return Text(
                                            '팔로우',
                                            style: profileButtonTextStyle,
                                          );
                                          // controller.user.followers != null
                                          // if (controller.user.followers!
                                          //     .contains(
                                          //         userModelRx.value!.uid)) {
                                          //   return Text(
                                          //     '팔로우 중',
                                          //     style: profileButtonTextStyle,
                                          //   );
                                          // } else {
                                          //   return Text(
                                          //     '팔로우',
                                          //     style: profileButtonTextStyle,
                                          //   );
                                          // }
                                        }
                                        // return Text(
                                        //   controller.isMe ? '프로필 수정' : '팔로우',
                                        //   style: profileButtonTextStyle,
                                        // );
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
                                14.w, profileFollowTextStyle.fontSize, subLeagueAwardCommentStyle.fontSize)),
                        // 유저소개글
                        GetBuilder<ProfileController>(
                          id: 'profile',
                          builder: (controller) {
                            if (controller.isUserModelLoaded) {
                              return controller.isMe
                                  ? Obx(() => Text(
                                        userModelRx.value!.intro == null
                                            ? '소개글이 없습니다.'
                                            : '${userModelRx.value!.intro}'.replaceAll('\\n', '\n'),
                                        style: subLeagueAwardCommentStyle.copyWith(letterSpacing: -0.01),
                                      ))
                                  : Text(
                                      controller.user.intro == null
                                          ? '소개글이 없습니다.'
                                          : '${controller.user.intro}'.replaceAll('\\n', '\n'),
                                      style: subLeagueAwardCommentStyle.copyWith(letterSpacing: -0.01),
                                    );
                            } else {
                              return Text(
                                '',
                                style: subLeagueAwardCommentStyle.copyWith(letterSpacing: -0.01),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ],
              )),
          SizedBox(height: correctHeight(35.w, subLeagueAwardCommentStyle.fontSize, profileButtonTextStyle.fontSize)),
          Row(
            children: [
              Flexible(
                  child: Container(
                height: 24.w,
                child: Center(
                  child: Text(
                    '피드/프로',
                    style: profileButtonTextStyle.copyWith(color: 0 == 1 ? profileButtonTextStyle.color : yachtGrey),
                  ),
                ),
              )),
              Flexible(
                  child: Container(
                height: 24.w,
                child: Center(
                  child: Text(
                    '리그',
                    style: profileButtonTextStyle.copyWith(color: 1 == 1 ? profileButtonTextStyle.color : yachtGrey),
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
                          Text('보유 자산', style: subLeagueAwardCommentStyle.copyWith(fontSize: 16.w)),
                          SizedBox(
                            height: correctHeight(10.w, 16.w, subLeagueAwardLabelStyle.fontSize),
                          ),
                          // *보유자산
                          GetBuilder<ProfileController>(
                              id: 'profile',
                              builder: (controller) {
                                if (controller.isMe && controller.isUserModelLoaded) {
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
                                  return Text('???', style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01));
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
                        Text('순위', style: subLeagueAwardCommentStyle.copyWith(fontSize: 16.w)),
                        SizedBox(height: correctHeight(10.w, 16.w, subLeagueAwardLabelStyle.fontSize)),
                        // *현재 리그 순위 및 승점
                        Text(
                          '7143위 | 42점',
                          style: subLeagueAwardLabelStyle.copyWith(letterSpacing: -0.01),
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
                                      future: controller.getEachQuestModel(userQuestModelRx[index]),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        } else {
                                          return InkWell(
                                            onTap: () {
                                              Get.toNamed('/quest', arguments: snapshot.data);
                                            },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        timeStampToStringWithHourMinute(
                                                                snapshot.data!.questEndDateTime) +
                                                            " 마감",
                                                        style: questRecordendDateTime,
                                                      ),
                                                      Text(snapshot.data!.title, style: questRecordTitle),
                                                      SizedBox(
                                                          height: correctHeight(14.w, questRecordTitle.fontSize,
                                                              questRecordSelection.fontSize)),
                                                      Text(
                                                          controller.getUserChioce(
                                                              snapshot.data!, userQuestModelRx[index]),
                                                          style: questRecordSelection),
                                                      // Text(userQuestModelRx[index].selection),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 30.w,
                                                ),
                                                simpleTextContainerLessRadiusButton("퀘스트 보기")
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
          //////// 여기까지는 최신UI 아님
          SizedBox(
            height: 50.w,
          ),
          Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 20.w),
            child: Row(
              children: [
                Text(
                  '즐겨찾기한 종목',
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
          GetBuilder<ProfileController>(
            id: 'favorites',
            builder: (controller) {
              if (controller.isUserModelLoaded && controller.isFavoritesLoaded) {
                // 굳이 이렇게 조건을 중첩한 이유는 그냥 혹시 먼저 뜨게되면 부자연스러울 것 같아서.
                return ProfileViewFavoritesCardWidget();
              } else {
                return Container();
              }
            },
          ),
        ]));
  }
}

class ProfileViewFavoritesCardWidget extends StatelessWidget {
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: profileController.stockModels
          .sublist(0, min(profileController.maxNumOfFavoriteStocks, profileController.stockModels.length))
          .asMap()
          .map((i, element) => MapEntry(
              i,
              Padding(
                padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 10.w),
                child: Container(
                  width: double.infinity,
                  decoration: yachtBoxDecoration,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(14.w),
                        child: Container(
                          height: 50.w,
                          width: 50.w,
                          child: FutureBuilder<String>(
                            future: profileController.getImageUrlFromStorage(profileController.stockModels[i].logoUrl),
                            builder: (_, snapshot) {
                              if (snapshot.hasData) {
                                return Image.network(snapshot.data.toString());
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${profileController.stockModels[i].name}',
                            style: profileFavoritesNameTextStyle,
                          ),
                          SizedBox(
                              height: correctHeight(6.w, profileFavoritesNameTextStyle.fontSize,
                                  profileFavoritesNumberTextStyle.fontSize)),
                          Text(
                              '${toPriceKRW(profileController.stockHistoricalPriceModels[i].close)} (${toPercentageChange((profileController.stockHistoricalPriceModels[i].close - profileController.stockHistoricalPriceModels[i].prevClose) / profileController.stockHistoricalPriceModels[i].prevClose)})',
                              style: profileController.stockHistoricalPriceModels[i].close >=
                                      profileController.stockHistoricalPriceModels[i].prevClose
                                  ? profileFavoritesNumberTextStyle.copyWith(color: yachtRed)
                                  : profileFavoritesNumberTextStyle.copyWith(color: seaBlue)),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.all(14.w),
                        child: Container(
                          height: 50.w,
                          width: 50.w,
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            'assets/icons/favorite_star_active.png',
                            height: 25.w,
                            width: 25.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )))
          .values
          .toList(),
    );
  }
}
