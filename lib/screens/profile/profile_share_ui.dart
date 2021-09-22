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
const int maxNumOfBadges = 4 * 3; // 최초화면에서 획득한 뱃지가 최대 몇개 보일 것인지

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
                          print(followersNFollowingsUid[i]);

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

// ***위 뱃지 리스트와 동일한 순서로!
List<Map<String, String>> localBadgesDescription = [
  {'title': '성실한 항해사', 'description': '출석 30회'},
  {'title': '성실한 항해사', 'description': '출석 60회'},
  {'title': '성실한 항해사', 'description': '출석 100회'},
  {'title': '가장 성실한 항해사', 'description': '출석 180회'},
  {'title': '요트에 부는 바람', 'description': '광고 시청 100회'},
  {'title': '요트에 부는 바람', 'description': '광고 시청 200회'},
  {'title': '요트에 부는 바람', 'description': '광고 시청 300회'},
  {'title': '요트에 부는 큰 바람', 'description': '광고 시청 400회'},
  {'title': '종이 초대장', 'description': '친구 1명 초대하기'},
  {'title': '구리빛 초대장', 'description': '친구 3명 초대하기'},
  {'title': '은빛 초대장', 'description': '친구 6 초대하기'},
  {'title': '황금 초대장', 'description': '친구 10명 이상 초대하기'},
  {'title': '처음 낸 목소리', 'description': '커뮤니티 첫 게시글 작성'},
  {'title': '소중한 소통', 'description': '댓글 3개 작성'},
  {'title': '좋은 사람', 'description': '좋아요 10개 받기'},
  {'title': '유쾌한 친구', 'description': '좋아요 10개 누르기'},
  {'title': '관심은 곧 수익', 'description': '개별종목 코멘트 3개 작성'},
  {'title': '그 사람의 매력', 'description': '내가 쓴 글에 댓글 10개 이상'},
  {'title': '샵(#)의 유혹', 'description': '해쉬태그 1회 사용'},
  {'title': '마켓 팔로워 20', 'description': '오늘의 시장 글 20개 읽기'},
  {'title': '마켓 팔로워 60', 'description': '오늘의 시장 글 60개 읽기'},
  {'title': '노력하는 투자자', 'description': '요트매거진 5개 읽기'},
  {'title': '공부하는 투자자', 'description': '금융백과사전 20개 읽기'},
  {'title': '시즌 우승자', 'description': '월간리그 우승'},
  {'title': '예측의 달콤한 결실', 'description': '퀘스트를 통해 주식을 1주라도 수령'},
  {'title': '돈이 되는 친구', 'description': '주식을 1주라도 선물하기'},
  {'title': '고맙다 친구야', 'description': '주식을 1주라도 선물받기'},
  {'title': '노력의 숭고한 결실', 'description': '리워드 포인트로 주식을 교환'},
  {'title': '요트의 마케터', 'description': '퀘스트카드 친구에게 1회 공유하기'},
  {'title': '요트의 아나운서', 'description': '퀘스트카드 친구에게 3회 공유하기'},
  {'title': '요트의 아나운서', 'description': '퀘스트카드 친구에게 5회 공유하기'},
  {'title': '요트의 아나운서', 'description': '퀘스트카드 친구에게 10회 공유하기'},
  {'title': '포트폴리오 투자의 시작', 'description': '종목 즐겨찾기 5개'},
  {'title': '인증된 투자자', 'description': '증권계좌 인증'},
  {'title': '10명의 투자메이트', 'description': '팔로잉 10명'},
  {'title': '30명의 투자메이트', 'description': '팔로잉 30명'},
  {'title': '70명의 투자메이트', 'description': '팔로잉 70명'},
  {'title': '100명의 투자메이트', 'description': '팔로잉 100명'},
  {'title': '5명의 투자군단', 'description': '팔로워 5명'},
  {'title': '20명의 투자군단', 'description': '팔로워 20명'},
  {'title': '50명의 투자군단', 'description': '팔로워 50명'},
  {'title': '100명의 투자군단', 'description': '팔로워 100명'},
  {'title': '꾸욱의 서포터즈', 'description': '기존 꾸욱 유저'},
  {'title': '꾸욱의 우승자들', 'description': '꾸욱 우승자 출신'},
  {'title': '너 자신을 알라', 'description': '서베이 완료'},
];

class BadgesFullGridView extends StatelessWidget {
  final List<String> badges;

  BadgesFullGridView({required this.badges});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: white,
        toolbarHeight: 60.w,
        title: Text('획득한 뱃지', style: appBarTitle),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20.w,
          ),
          BadgesGridView(
            isFull: true,
            badges: badges,
          ),
        ],
      ),
    );
  }
}

class BadgesGridView extends StatelessWidget {
  final bool isFull;
  final List<String> badges;

  BadgesGridView({required this.isFull, required this.badges});

  @override
  Widget build(BuildContext context) {
    // isFull 이 아닐 경우 badges만으로 그리드를 생성해주므로, 사용자가 뱃지를 획득한 순서에 상관 없이 local badge순으로 맞춰주기 위해 아래 작업 진행
    List<String> tempBadges = [];
    for (int i = 0; i < localBadges.length; i++) {
      if (badges.contains(localBadges[i])) tempBadges.add(localBadges[i]);
    }
    if (badges.length != 0) {
      return Padding(
        padding: EdgeInsets.only(left: 14.w, right: 14.w),
        child: Container(
          width: double.infinity,
          decoration: yachtBoxDecoration,
          child: Padding(
            padding: EdgeInsets.only(
                left: 14.w, right: 14.w, top: 20.w, bottom: 20.w),
            child: Column(
              children: List.generate(
                  (((isFull
                                  ? (localBadges.length)
                                  : min(badges.length, maxNumOfBadges)) -
                              1) ~/
                          4 +
                      1), // 한 줄에 네 개씩 들어가므로~
                  (i) {
                return Column(
                  children: [
                    Row(
                        children: List.generate(4, (j) {
                      if (i * 4 + j <
                          (isFull
                              ? (localBadges.length)
                              : min(badges.length, maxNumOfBadges))) {
                        return Row(
                          children: [
                            isFull
                                ? GestureDetector(
                                    onTap: () {
                                      badgeDialog(context, i * 4 + j);
                                    },
                                    child: Container(
                                      height: 76.w,
                                      width: 76.w,
                                      child: Image.asset(badges
                                              .contains(localBadges[i * 4 + j])
                                          ? 'assets/badges/${localBadges[i * 4 + j]}.png'
                                          : 'assets/badges/${localBadges[i * 4 + j]}_none.png'),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      badgeDialog(
                                          context,
                                          localBadges.indexWhere((element) =>
                                              (element ==
                                                  tempBadges[i * 4 + j])));
                                    },
                                    child: Container(
                                      height: 76.w,
                                      width: 76.w,
                                      child: Image.asset(
                                          'assets/badges/${tempBadges[i * 4 + j]}.png'),
                                    ),
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
    } else {
      return Column(
        children: [
          SizedBox(
            height: 50.w,
          ),
          Container(
            width: 375.w,
            child: Stack(
              children: [
                Center(
                    child: Container(
                  width: 265.w,
                  height: 86.w,
                  child: Image.asset(
                      'assets/illusts/not_exists/no_general_words.png'),
                )),
                Positioned(
                  top: 21.w,
                  child: Container(
                    width: 375.w,
                    child: Center(
                      child: Text(
                        '아직 획득한 뱃지가 없어요.',
                        style: notExistsText,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          Center(
              child: Container(
            width: 71.w,
            height: 56.w,
            child:
                Image.asset('assets/illusts/not_exists/no_general_illust.png'),
          ))
        ],
      );
    }
  }
}

badgeDialog(BuildContext context, int indexOfLocalBadges) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: primaryBackgroundColor,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 376.w,
            width: 347.w,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    SizedBox(
                        height: 15.w,
                        width: 15.w,
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 24.w,
                        ),
                        Text('뱃지', style: yachtBadgesDialogTitle)
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 24.w,
                              ),
                              SizedBox(
                                  height: 15.w,
                                  width: 15.w,
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 39.w,
                            width: 21.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height:
                      correctHeight(26.w, yachtBadgesDialogTitle.fontSize, 0.w),
                ),
                Center(
                  child: Container(
                    height: 200.w,
                    width: 200.w,
                    child: Image.asset(
                        'assets/badges/${localBadges[indexOfLocalBadges]}.png'),
                  ),
                ),
                SizedBox(
                  height: correctHeight(
                      18.w, 0.w, yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Text(
                  '${localBadgesDescription[indexOfLocalBadges]['title']}',
                  style: yachtBadgesDescriptionDialogTitle,
                ),
                SizedBox(
                  height: correctHeight(
                      9.w,
                      yachtBadgesDescriptionDialogTitle.fontSize,
                      yachtBadgesDescriptionDialogContent.fontSize),
                ),
                Text(
                  '${localBadgesDescription[indexOfLocalBadges]['description']}',
                  style: yachtBadgesDescriptionDialogContent,
                ),
                SizedBox(
                  height: correctHeight(
                      40.w, yachtBadgesDescriptionDialogContent.fontSize, 0.w),
                ),
              ],
            ),
          ),
        );
      });
}
