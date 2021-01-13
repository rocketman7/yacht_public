import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stacked/stacked.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/winner_view_model.dart';

import '../locator.dart';
import 'constants/size.dart';
import '../models/rank_model.dart';
import '../views/widgets/avatar_widget.dart';
import 'last_season_rank_view.dart';

class WinnerView extends StatelessWidget {
  final dynamic oldSeasonInfo;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final NavigationService _navigationService = locator<NavigationService>();

  WinnerView(this.oldSeasonInfo);

  @override
  Widget build(BuildContext context) {
    print("ARGS" + this.oldSeasonInfo.toString());
    return ViewModelBuilder<WinnerViewModel>.reactive(
        viewModelBuilder: () => WinnerViewModel(oldSeasonInfo),
        builder: (context, model, child) {
          return Scaffold(
              body:
                  //  model.hasError
                  //     ? Container(
                  //         child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                  //       )
                  //     :
                  model.isBusy
                      ? Container(
                          height: deviceHeight,
                          width: deviceWidth,
                          child: Stack(
                            children: [
                              Positioned(
                                top: deviceHeight / 2 - 100,
                                child: Container(
                                  height: 100,
                                  width: deviceWidth,
                                  child: FlareActor(
                                    'assets/images/Loading.flr',
                                    animation: 'loading',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SafeArea(
                          child: SingleChildScrollView(
                            // reverse: true,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, right: 16.0, top: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(Icons.arrow_back_ios),
                                      ),
                                      Spacer(),
                                      Text(
                                        "",
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontFamily: 'AppleSDB',
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        // color: Colors.red,
                                        width: 30,
                                        // height: 30,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/winner_resize.svg',
                                        height: 80,
                                        // width: 80,
                                        // color: Colors.white,
                                      ),
                                      SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  20,
                                                )),
                                            child: Text(
                                              model.seasonModel.seasonName,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1,
                                                  letterSpacing: -1.0,
                                                  fontFamily: 'AppleSDM',
                                                  fontSize: 14),
                                            ),
                                          ),

                                          // Text(
                                          //   '${model.getPortfolioValue()}원',
                                          //   style: TextStyle(
                                          //       // color: Colors.white,
                                          //       // height: 1,
                                          //       letterSpacing: -1.0,
                                          //       fontFamily: 'AppleSDB',
                                          //       fontSize: 28),
                                          // ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _navigationService.navigateWithArgTo(
                                              'lastSeasonPortfolio', model);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '상금 주식 ${model.getLastSeasonPortfolioValue()}원',
                                              style: TextStyle(
                                                  // color: Colors.white,
                                                  // height: 1,
                                                  letterSpacing: -1.0,
                                                  fontFamily: 'AppleSDB',
                                                  fontSize: 30),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios,
                                              size: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '시즌 시작일',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        model.getDateFormChange(
                                          model.seasonModel.startDate,
                                        ),
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '우승 승점',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -1.0,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${model.seasonModel.winningPoint}점',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -1.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '참여자',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${model.getUsersNum()}명',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),

                                  GestureDetector(
                                    // behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      // _navigationService
                                      //     .navigateWithArgTo('lastSeasonRank', [
                                      //   model.seasonModel,
                                      //   model.userModel,
                                      //   model.rankModel,
                                      // ]);

                                      _navigationService.navigateWithArgTo(
                                        'lastSeasonRank',
                                        model,
                                      );
                                    },
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 6),
                                        // alignment: Alignment.center,
                                        // width: double.,
                                        decoration: BoxDecoration(
                                            color: Colors.blueGrey,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        height: 30,
                                        child: Text(
                                          model.seasonModel.seasonName
                                                  .toString() +
                                              " 전체 순위 보러 가기",
                                          // textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 16,
                                              height: 1,
                                              color: Colors.white,
                                              fontFamily: 'AppleSDM'),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       '최종 상금 주식',
                                  //       style: TextStyle(
                                  //         fontSize: 20.sp,
                                  //         height: 1,
                                  //         fontFamily: 'AppleSDM',
                                  //         letterSpacing: -0.5,
                                  //       ),
                                  //     ),
                                  //     Spacer(),
                                  //     GestureDetector(
                                  //       onTap: () {
                                  //         // model.navigateToPortfolioPage();
                                  //       },
                                  //       child: Text(
                                  //         '${model.getPortfolioValue()}원',
                                  //         style: TextStyle(
                                  //           fontSize: 20.sp,
                                  //           height: 1,
                                  //           fontFamily: 'AppleSDM',
                                  //           letterSpacing: -0.5,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     // GestureDetector(
                                  //     //   onTap: () {
                                  //     //     // model.navigateToPortfolioPage();
                                  //     //   },
                                  //     //   child: Icon(
                                  //     //     Icons.arrow_forward_ios,
                                  //     //     size: 16.sp,
                                  //     //   ),
                                  //     // )
                                  //   ],
                                  // ),

                                  // SizedBox(
                                  //   height: 16.h,
                                  // ),

                                  // Divider(),
                                  SizedBox(height: 16),
                                  Center(
                                    child: Text(
                                      '${model.seasonModel.seasonName} 우승자',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFFBD0E0E),
                                          fontSize: 28,
                                          letterSpacing: -1.0,
                                          fontFamily: 'AppleSDEB'),
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Column(
                                    children: List.generate(
                                        model.winners.length,
                                        (index) => buildWinnersListView(
                                              model,
                                              model.rankModel[index],
                                              index,
                                            )),
                                  ),

                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  // // Divider(),
                                  // SizedBox(
                                  //   height: 16.h,
                                  // ),

                                  Center(
                                    child: Text(
                                      '특별상',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xFF218C59),
                                          fontSize: 28,
                                          letterSpacing: -1.0,
                                          fontFamily: 'AppleSDEB'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  FutureBuilder(
                                      future: model.getSpecialAwardsMap(
                                          model.lastSeasonAddressModel),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container();
                                        } else {
                                          print(snapshot.data);
                                          Map<String, String> specialAwardMap;
                                          specialAwardMap = snapshot.data;
                                          List specialAwards = [];
                                          List<String> specialAwardsUserNames =
                                              [];
                                          specialAwardMap.forEach((key, value) {
                                            specialAwards.add(key);
                                            specialAwardsUserNames.add(value);
                                          });
                                          var randomInt = Random();
                                          return Column(
                                              children: List.generate(
                                            specialAwards.length,
                                            (index) => Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  specialAwards[index],
                                                  style: TextStyle(
                                                    fontFamily: 'AppleSDB',
                                                    fontSize: 20,
                                                    letterSpacing: -0.28,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                        specialAwardsUserNames[
                                                            index],
                                                        style: TextStyle(
                                                            fontSize: 24,
                                                            letterSpacing: -2.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    // SizedBox(
                                                    //   width: 4,
                                                    // ),
                                                    // Image(
                                                    //   image: AssetImage(
                                                    //     'assets/images/christmas_winner00${randomInt.nextInt(10)}.png',
                                                    //   ),
                                                    //   height: 24,
                                                    // ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ));
                                        }
                                      }),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  FutureBuilder<String>(
                                      future: model.getSpecialAwardsDescription(
                                          model.lastSeasonAddressModel),
                                      builder: (context, snapshot) {
                                        return snapshot.hasData
                                            ? Container(
                                                child: Center(
                                                  child: Text(
                                                    snapshot.data.toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'AppleSDM'),
                                                    textAlign: TextAlign.center,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                              )
                                            : Container();
                                      }),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    "상금주식 확인 및 출금신청은 홈 화면 우측 상단 마이페이지 -> 내가 받은 상금 현황에서 가능합니다",
                                    style: TextStyle(
                                        fontSize: 16, fontFamily: 'AppleSDM'),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Divider(
                                    thickness: 1.4,
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Center(
                                    child: Text(
                                      '다음 시즌 안내',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 28,
                                          letterSpacing: -1.0,
                                          fontFamily: 'AppleSDEB'),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${model.newSeasonModel.seasonName} 시작일',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        model.getDateFormChange(
                                            model.newSeasonModel.startDate),
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '목표 승점',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -1.0,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '${model.newSeasonModel.winningPoint}점',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -1.0,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '상금 주식',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          height: 1,
                                          fontFamily: 'AppleSDM',
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          _navigationService
                                              .navigateTo('portfolio');
                                        },
                                        child: Text(
                                          '${model.getPortfolioValue()}원',
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            height: 1,
                                            fontFamily: 'AppleSDM',
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _navigationService
                                              .navigateTo('portfolio');
                                        },
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16.sp,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 30),

                                  // Winners List
                                ],
                              ),
                            ),
                          ),
                        ));
        });
  }

  buildWinnersListView(WinnerViewModel model, RankModel ranksModel, int index) {
    // 나중에 몇만명 이렇게 늘어나면 고쳐야할듯?

    var randomInteger = Random();
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   height: 36,
            //   width: 36,
            //   child: CircleAvatar(
            //     maxRadius: 36,
            //     backgroundColor: Colors.transparent,
            //     backgroundImage:
            //         AssetImage('assets/images/${ranksModel.avatarImage}.png'),
            //   ),
            // ),
            // SizedBox(
            //   width: 18,
            // ),
            AutoSizeText(
              '${ranksModel.userName}',
              style: TextStyle(
                fontSize: 36,
                height: 1,
                fontFamily: 'AppleSDB',
                letterSpacing: -0.28,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            // SizedBox(width: 6),
            // Image(
            //   image: AssetImage(
            //     'assets/images/christmas_winner00${randomInteger.nextInt(10)}.png',
            //   ),
            //   height: 40,
            // )
          ],
        ));
  }
}
