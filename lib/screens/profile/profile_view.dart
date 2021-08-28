import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../handlers/numbers_handler.dart';
import '../../styles/size_config.dart';

import 'asset_view.dart';
import 'asset_view_model.dart';
import 'profile_controller.dart';
import 'stocks_delivery_view.dart';

class ProfileView extends StatelessWidget {
  final String uid;

  ProfileView({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: primaryAppBar('프로필'),
        body: ListView(children: [
          Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w, top: 11.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // *아바타이미지, *티어정보
                  Stack(
                    children: [
                      Container(
                        height: 79.5.w,
                        width: 79.5.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 1.w,
                              // *티어정보
                              color: Color(0xFF8A64A8),
                            )),
                      ),
                      GetBuilder<ProfileController>(
                          id: 'profile',
                          init: ProfileController(uid: uid),
                          builder: (controller) {
                            return Positioned(
                                left: 5.w,
                                top: 5.w,
                                child: Container(
                                    height: 69.5.w,
                                    width: 69.5.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // color: Colors.blueGrey.withOpacity(0.4),
                                    ),
                                    child: (controller.isUserModelLoaded)
                                        ? controller.user.avatarImage != null
                                            ? FutureBuilder<String>(
                                                future: controller.getImageUrlFromStorage(controller.user.avatarImage!),
                                                builder: (context, snapshot) {
                                                  return snapshot.hasData
                                                      ? CachedNetworkImage(
                                                          imageUrl: snapshot.data!,
                                                        )
                                                      : Container();
                                                })
                                            : Container()
                                        : Container()));
                          }),
                    ],
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Container(
                    width: SizeConfig.screenWidth - 14.w - 14.w - 79.5.w - 16.w,
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
                                      10.w, profileUserNameStyle.fontSize, profileFollowTextStyle.fontSize),
                                ),
                                // 팔로워 숫자 / 팔로잉 숫자
                                Row(
                                  children: [
                                    GetBuilder<ProfileController>(
                                      id: 'profile',
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
                                    SizedBox(width: 4.w),
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
                                print('click');
                                // Get.to(() => AssetView());
                                Get.to(() => StocksDeliveryView());
                              },
                              child: Container(
                                height: 30.w,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(70.0),
                                  border: Border.all(color: activatedButtonColor, width: 1.5.w),
                                ),
                                child: Center(
                                  child: GetBuilder<ProfileController>(
                                    id: 'profile',
                                    builder: (controller) {
                                      if (controller.isUserModelLoaded) {
                                        return Text(
                                          controller.isMe ? '프로필 수정' : '팔로우',
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
                                14.w, profileFollowTextStyle.fontSize, subLeagueAwardCommentStyle.fontSize)),
                        // 유저소개글
                        GetBuilder<ProfileController>(
                          id: 'profile',
                          builder: (controller) {
                            if (controller.isUserModelLoaded) {
                              return Text(
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
                    color: 0 == 1 ? activatedButtonColor : Colors.transparent,
                  ),
                ),
                Positioned(
                  top: 4.0.w,
                  left: SizeConfig.screenWidth / 2,
                  child: Container(
                    height: 3.w,
                    width: SizeConfig.screenWidth / 2,
                    color: 1 == 1 ? activatedButtonColor : Colors.transparent,
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
                            future: profileController.getLogoUrl(profileController.stockModels[i].logoUrl),
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
