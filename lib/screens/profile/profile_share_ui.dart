import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';

import '../../handlers/numbers_handler.dart';
import '../../models/profile_models.dart';
import '../../models/users/user_model.dart';
import '../../styles/yacht_design_system.dart';
import 'profile_my_view_model.dart';
import 'profile_others_view.dart';

const int maxNumOfFavoriteStocks = 3; // 최초화면에서 즐겨찾기 종목이 최대 몇개 보일 것인지.

// favorite stocks 카드위젯 공통으로 쓴다. 단 로딩된 favoriteStocksModel과 로딩된 favoriteHistoricalStocksModel을 넘겨줘야함
// 또 대부분의 상황에서는 MyViewModel은 떠져있는 상태일 것이므로 find는 MyViewModel걸로 해준다.
class ProfileViewFavoritesCardWidget extends StatelessWidget {
  final List<FavoriteStockModel> favoriteStockModels;
  final List<FavoriteStockHistoricalPriceModel>
      favoriteStockHistoricalPriceModels;

  ProfileViewFavoritesCardWidget(
      {required this.favoriteStockModels,
      required this.favoriteStockHistoricalPriceModels});

  @override
  Widget build(BuildContext context) {
    if (favoriteStockModels.length != 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: favoriteStockModels
            .sublist(0, min(maxNumOfFavoriteStocks, favoriteStockModels.length))
            .asMap()
            .map((i, element) => MapEntry(
                i,
                Padding(
                  padding:
                      EdgeInsets.only(left: 14.w, right: 14.w, bottom: 10.w),
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
                              future: Get.find<ProfileMyViewModel>()
                                  .getImageUrlFromStorage(
                                      favoriteStockModels[i].logoUrl),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  return Image.network(
                                      snapshot.data.toString());
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
                              '${favoriteStockModels[i].name}',
                              style: profileFavoritesNameTextStyle,
                            ),
                            SizedBox(
                                height: correctHeight(
                                    6.w,
                                    profileFavoritesNameTextStyle.fontSize,
                                    profileFavoritesNumberTextStyle.fontSize)),
                            Text(
                                '${toPriceKRW(favoriteStockHistoricalPriceModels[i].close)} (${toPercentageChange((favoriteStockHistoricalPriceModels[i].close - favoriteStockHistoricalPriceModels[i].prevClose) / favoriteStockHistoricalPriceModels[i].prevClose)})',
                                style: favoriteStockHistoricalPriceModels[i]
                                            .close >=
                                        favoriteStockHistoricalPriceModels[i]
                                            .prevClose
                                    ? profileFavoritesNumberTextStyle.copyWith(
                                        color: yachtRed)
                                    : profileFavoritesNumberTextStyle.copyWith(
                                        color: seaBlue)),
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
    } else {
      return Column(
        children: [
          // SizedBox(
          //   height: 50.w,
          // ),
          Center(
            child: Image.asset(
              'assets/illusts/not_exists/no_favorites.png',
              width: 265.w,
              height: 152.w,
            ),
          ),
        ],
      );
    }
  }
}

class FollowersNFollowingsView extends StatelessWidget {
  final isMe;
  final whichfollowersOrfollowings;
  final List<String> followersNFollowingsUid;

  FollowersNFollowingsView(
      {required this.isMe,
      required this.whichfollowersOrfollowings,
      required this.followersNFollowingsUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: white,
          toolbarHeight: 60.w,
          title: Text(whichfollowersOrfollowings ? '팔로워 목록' : '팔로잉 목록',
              style: appBarTitle),
        ),
        body: ListView(children: [
          Column(
            children: followersNFollowingsUid
                .toList()
                .asMap()
                .map((i, element) => MapEntry(
                    i,
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: GestureDetector(
                        onTap: () {
                          if (followersNFollowingsUid[i] !=
                              userModelRx.value!.uid)
                            Get.to(() => ProfileOthersView(
                                uid: followersNFollowingsUid[i]));
                        },
                        child: Column(
                          children: [
                            SizedBox(height: 14.w),
                            FutureBuilder<UserModel>(
                                future: Get.find<ProfileMyViewModel>()
                                    .getOtherUserModel(
                                        followersNFollowingsUid[i]),
                                builder: (_, snapshot) {
                                  return Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey,
                                        ),
                                        height: 36.w,
                                        width: 36.w,
                                        child: snapshot.hasData
                                            ? FutureBuilder<String>(
                                                future: Get.find<
                                                        ProfileMyViewModel>()
                                                    .getImageUrlFromStorage(
                                                        'avatars/${snapshot.data!.avatarImage}.png'),
                                                builder:
                                                    (__, snapshotForImageURL) {
                                                  return snapshotForImageURL
                                                          .hasData
                                                      ? Image.network(
                                                          snapshotForImageURL
                                                              .data
                                                              .toString())
                                                      : Container();
                                                },
                                              )
                                            : Container(),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.hasData
                                                ? '${snapshot.data!.userName}'
                                                : '',
                                            style: profileFollowNickNameStyle,
                                          ),
                                          SizedBox(
                                            height: correctHeight(
                                                4.w,
                                                profileFollowNickNameStyle
                                                    .fontSize,
                                                0.w),
                                          ),
                                          simpleTierRRectBox(
                                            exp: snapshot.hasData
                                                ? snapshot.data!.exp
                                                : 0,
                                          )
                                        ],
                                      ),
                                      Spacer(),
                                      // 나의 && 팔로잉 목록이면 여기서 삭제를 통해서 언팔로우를 할 수 있다.
                                      // 일단 비활성화
                                      // (isMe && !whichfollowersOrfollowings)
                                      //     ? GestureDetector(
                                      //       onTap: () {
                                      //       },
                                      //       child: Container(
                                      //           height: 24.w,
                                      //           width: 50.w,
                                      //           decoration: BoxDecoration(
                                      //               borderRadius:
                                      //                   BorderRadius.circular(70.0),
                                      //               color: buttonNormal),
                                      //           child: Center(
                                      //               child: Text(
                                      //             '삭제',
                                      //             style: profileFollowDeleteStyle,
                                      //           )),
                                      //         ),
                                      //     )
                                      //     : Container()
                                    ],
                                  );
                                }),
                            SizedBox(
                              height: 14.w,
                            ),
                            Container(
                              height: 1.w,
                              width: double.infinity,
                              color: yachtLineColor,
                            )
                          ],
                        ),
                      ),
                    )))
                .values
                .toList(),
          )
        ]));
  }
}

class NullFollowersNFollowingsView extends StatelessWidget {
  final whichNULLfollowersOrfollowings;

  NullFollowersNFollowingsView({required this.whichNULLfollowersOrfollowings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: white,
          toolbarHeight: 60.w,
          title: Text(whichNULLfollowersOrfollowings ? '팔로워 목록' : '팔로잉 목록',
              style: appBarTitle),
        ),
        body: Center(
          child: Image.asset(
            whichNULLfollowersOrfollowings
                ? 'assets/illusts/not_exists/no_followers.png'
                : 'assets/illusts/not_exists/no_followings.png',
            width: 265.w,
            height: 215.w,
          ),
        ));
  }
}

// 여기서 뱃지들을 관리해준다. DB에 엄한 뱃지들 목록을 적어봐야 소용 없음.
// DB 유저모델 badges 들은 직접 채점해서 넣어주는 식으로 하고
// badge 이름 과 asset 내 png 파일 이름을 동일하게 맞춰주자
List<String> localBadges = [
  'attend30', // '출석30회',
  'attend60', // '출석60회',
  'attend100', // '출석100회',
  'attend180', // '출석180회',
  'ads100', // '광고시청100회',
  'ads200', // '광고시청200회',
  'ads300', // '광고시청300회',
  'ads400', // '광고시청400회',
  'invite1', // '친구초대1명',
  'invite3', // '친구초대3명',
  'invite6', // '친구초대6명',
  'invite10', // '친구초대10명',
  'communityfirstcontent', // '커뮤니티첫게시글작성',
  'comment3', // '댓글3개작성',
  'liketake10', // '좋아요10개받기',
  'likegive10', // '좋아요10개누르기',
  'stockcomment3', //'개별종목코멘트3개',
  'takecomment10', // '내댓글에답글10개이상',
  'hashtag', //'해쉬태그사용',
  'todaymarket20', // '오늘의시장글 20개',
  'todaymarket60', // '오늘의시장글 60개',
  'view5', // '읽을거리 5개',
  'voca20', // '금융시사용어 20개',
  'winner', // '월간리그 우승',
  'stocktake1', // '주식1주수령',
  '1give', //'1주선물주기',
  '1take', //'1주선물받기',
  'rewardtostock', // '리워드포인트로주식교환',
  'link1', // '링크1회',
  'link3', // '링크3회',
  'link5', // '링크5회',
  'link10', // '링크10회',
  'favorite5', // '종목즐찾5개',
  'account', // '증권계좌 인증',
  'followings10', //'팔로잉 10명',
  'followings30', //'팔로잉 30명',
  'followings70', //'팔로잉 70명',
  'followings100', //'팔로잉 100명',
  'followers10', // '팔로워 10명',
  'followers30', // '팔로워 10명',
  'followers70', // '팔로워 10명',
  'followers100', // '팔로워 10명',
  'ggookuser', // '기존꾸욱유저',
  'ggookwinner', // '우승자출신',
  'survey', // '서베이완료',
];

class BadgesGridView extends StatelessWidget {
  final List<String> badges;

  BadgesGridView({required this.badges});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 14.w, right: 14.w),
      child: Container(
        width: double.infinity,
        decoration: yachtBoxDecoration,
        child: Padding(
          padding:
              EdgeInsets.only(left: 14.w, right: 14.w, top: 20.w, bottom: 20.w),
          child: Column(
            children: List.generate(
                (localBadges.length - 1) ~/ 4 + 1, // 한 줄에 네 개씩 들어가므로~
                (i) {
              return Column(
                children: [
                  Row(
                      children: List.generate(4, (j) {
                    if (i * 4 + j < localBadges.length) {
                      return Row(
                        children: [
                          Container(
                            height: 76.w,
                            width: 76.w,
                            child: Image.asset(badges
                                    .contains(localBadges[i * 4 + j])
                                ? 'assets/badges/${localBadges[i * 4 + j]}.png'
                                : 'assets/badges/${localBadges[i * 4 + j]}_none.png'),
                          ),
                          (j != 4 - 1)
                              ? SizedBox(
                                  width: 5.w,
                                )
                              : SizedBox(
                                  width: 0.w,
                                ),
                        ],
                      );
                    } else {
                      return Container(height: 76.w, width: 76.w);
                    }
                  })),
                  SizedBox(
                    height: 12.w,
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
