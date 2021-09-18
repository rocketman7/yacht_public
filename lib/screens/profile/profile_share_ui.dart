import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../handlers/numbers_handler.dart';
import '../../models/profile_models.dart';
import '../../styles/yacht_design_system.dart';
import 'profile_my_view_model.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: favoriteStockModels
          .sublist(0, min(maxNumOfFavoriteStocks, favoriteStockModels.length))
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
                            future: Get.find<ProfileMyViewModel>()
                                .getImageUrlFromStorage(
                                    favoriteStockModels[i].logoUrl),
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
                              style:
                                  favoriteStockHistoricalPriceModels[i].close >=
                                          favoriteStockHistoricalPriceModels[i]
                                              .prevClose
                                      ? profileFavoritesNumberTextStyle
                                          .copyWith(color: yachtRed)
                                      : profileFavoritesNumberTextStyle
                                          .copyWith(color: seaBlue)),
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

class FollowersNFollowingsView extends StatelessWidget {
  final whichfollowersOrfollowings;
  final List<String> followersNFollowingsUid;

  FollowersNFollowingsView(
      {required this.whichfollowersOrfollowings,
      required this.followersNFollowingsUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: white,
          toolbarHeight: 60.w,
          title: Text('프로필', style: appBarTitle),
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
                      // child: Text('${followersNFollowingsUid[i]}'),
                      child: Column(
                        children: [
                          SizedBox(height: 14.w),
                          Row(
                            children: [
                              Container(
                                height: 36.w,
                                width: 36.w,
                                // child: FutureBuilder<String>(
                                //   future: Get.find<ProfileMyViewModel>().getImageUrlFromStorage(
                                //       profileController.stockModels[i].logoUrl),
                                //   builder: (_, snapshot) {
                                //     if (snapshot.hasData) {
                                //       return Image.network(snapshot.data.toString());
                                //     } else {
                                //       return Container();
                                //     }
                                //   },
                                // ),
                                color: Colors.grey,
                              ),
                              Text('${followersNFollowingsUid[i]}')
                            ],
                          ),
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
