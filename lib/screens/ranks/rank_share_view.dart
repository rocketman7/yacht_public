import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/profile/profile_my_view.dart';
import 'package:yachtOne/screens/profile/profile_others_view.dart';

import 'rank_controller.dart';
import '../../styles/style_constants.dart';
import '../../styles/yacht_design_system.dart';

class RankHomeWidget extends StatelessWidget {
  // 이미 스타트업뷰에서 put되어 있는 상태이므로 put X

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: primaryHorizontalPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(child: Text('랭킹', style: sectionTitle.copyWith(height: 1.0))),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    Get.to(() => AllRankerView(
                          leagueIndex: 0,
                        ));
                  },
                  child: Row(
                    children: [
                      Text(
                        '더 보기',
                        style: moreText,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      SizedBox(
                        height: 12.w,
                        width: 8.w,
                        child: Image.asset('assets/icons/right_arrow_grey.png'),
                      )
                    ],
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 20.w,
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 14.w),
          child: Container(
            width: double.infinity,
            decoration:
                primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow], color: homeModuleBoxBackgroundColor),
            child: GetBuilder<RankController>(
                id: 'ranks',
                builder: (controller) {
                  return controller.isMyRanksAndPointLoaded
                      ? RankShareView(leagueIndex: 0, isFullView: false)
                      : Container();
                }),
          ),
        ),
      ],
    );
  }
}

class AllRankerView extends StatelessWidget {
  final int leagueIndex;

  AllRankerView({required this.leagueIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: white,
        toolbarHeight: 60.w,
        title: Text('랭킹', style: appBarTitle),
      ),
      body: ListView(
        children: [
          Center(
            child: GetBuilder<RankController>(
                id: 'ranks',
                builder: (controller) {
                  return controller.isMyRanksAndPointLoaded
                      ? RankShareView(leagueIndex: leagueIndex, isFullView: true)
                      : Container();
                }),
          ),
        ],
      ),
    );
  }
}

class RankShareView extends StatelessWidget {
  final int leagueIndex;
  final bool isFullView;

  RankShareView({required this.leagueIndex, required this.isFullView});

  final RankController rankController = Get.find<RankController>();

  @override
  Widget build(BuildContext context) {
    if (rankController.allRanker[leagueIndex].length != 0) {
      return Container(
        width: 347.w,
        child: Column(
          children: [
            SizedBox(
              height: correctHeight(16.w, 0.w, rankMainBoldText.fontSize),
            ),
            Row(
              children: [
                SizedBox(
                  width: 14.w,
                ),
                Text(
                  '나의 랭킹 ',
                  style: rankMainText,
                ),
                Text(
                  rankController.myRanksAndPoint[leagueIndex]['todayRank']! != 0
                      ? '${rankController.myRanksAndPoint[leagueIndex]['todayRank']!}'
                      : '없음',
                  style: rankMainBoldText,
                ),
                Text(
                  rankController.myRanksAndPoint[leagueIndex]['todayRank']! != 0 ? '위' : '',
                  style: rankMainText,
                ),
                Spacer(),
                SizedBox(height: 22.w, width: 22.w, child: Image.asset('assets/icons/league_point_circle.png')),
                SizedBox(
                  width: 3.w,
                ),
                Text(
                  '${rankController.myRanksAndPoint[leagueIndex]['todayPoint']!}',
                  style: rankMainBoldText,
                ),
                Text(
                  '점',
                  style: rankMainText,
                ),
                SizedBox(
                  width: 14.w,
                ),
              ],
            ),
            SizedBox(
              height: correctHeight(12.w, rankMainBoldText.fontSize, 0.w),
            ),
            Container(
              width: double.infinity,
              height: 1.w,
              color: yachtLine,
            ),
            SizedBox(
              height: 8.w,
            ),
            //
            Column(
              children: rankController.allRanker[leagueIndex]
                  .toList()
                  .sublist(
                      0,
                      min(rankController.allRanker[leagueIndex].length,
                          isFullView ? rankController.allRanker[leagueIndex].length : maxNumAllRankerForTop))
                  .asMap()
                  .map((i, element) => MapEntry(
                      i,
                      Column(
                        children: [
                          SizedBox(
                            height: 12.w,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 14.w,
                              ),
                              Container(
                                width: 33.w,
                                child: Center(
                                  child: Text(
                                    '${rankController.allRanker[leagueIndex][i].todayRank}',
                                    style: rankMainBoldText,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 18.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (rankController.allRanker[leagueIndex][i].uid != userModelRx.value!.uid)
                                    Get.to(() => ProfileOthersView(uid: rankController.allRanker[leagueIndex][i].uid));
                                  else
                                    Get.to(() => ProfileMyView());
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 31.w,
                                      width: 31.w,
                                      child: FutureBuilder<String>(
                                        future: rankController.getImageUrlFromStorage('avatars/' +
                                            (rankController.allRanker[leagueIndex][i].avatarImage ?? 'avatar001') +
                                            '.png'),
                                        builder: (_, snapshot) {
                                          if (snapshot.hasData) {
                                            return Image.network(snapshot.data.toString());
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    Text(
                                      '${rankController.allRanker[leagueIndex][i].userName}',
                                      style: rankNameText,
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text(
                                '${rankController.allRanker[leagueIndex][i].todayPoint}',
                                style: rankMainBoldText,
                              ),
                              Text('점', style: rankMainText),
                              SizedBox(
                                width: 14.w,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 12.w,
                          ),
                        ],
                      )))
                  .values
                  .toList(),
            ),
            // GestureDetector(
            //     onTap: () {
            //       rankController.test();
            //     },
            //     child: Container(
            //       height: 50.w,
            //       width: 50.w,
            //       color: Colors.black,
            //     )),
            //
            SizedBox(
              height: 8.w,
            ),
            isFullView
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 1.w,
                        color: yachtLine,
                      ),
                      SizedBox(
                        height: correctHeight(14.w, 0.w, rankDescriptionBoldText.fontSize),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 14.w,
                          ),
                          SizedBox(
                              height: 22.w, width: 22.w, child: Image.asset('assets/icons/league_point_circle.png')),
                          SizedBox(
                            width: 7.w,
                          ),
                          Text(
                            '우승까지 필요한 승점',
                            style: rankDescriptionBoldText,
                          ),
                          Spacer(),
                          Text(
                            '${rankController.allRanker[leagueIndex][0].todayPoint - rankController.myRanksAndPoint[leagueIndex]['todayPoint']!}',
                            style: rankMainBoldText,
                          ),
                          Text(
                            '점',
                            style: rankMainText,
                          ),
                          SizedBox(
                            width: 14.w,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: correctHeight(16.w, rankDescriptionBoldText.fontSize, rankDescriptionMainText.fontSize),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 14.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '우승을 위한 추천 활동',
                                style: rankDescriptionMainText,
                              ),
                              SizedBox(
                                height: correctHeight(
                                    7.5.w, rankDescriptionMainText.fontSize, rankDescriptionContentText.fontSize),
                              ),
                              Text(
                                '! 퀘스트 참여하기',
                                style: rankDescriptionContentText,
                              ),
                              Text(
                                '! 커뮤니티 글 작성하기',
                                style: rankDescriptionContentText,
                              ),
                              Text(
                                '! 그 외 다양한 활동하기',
                                style: rankDescriptionContentText,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 14.w,
                      ),
                    ],
                  ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 14.w),
        child: Center(child: Text('아직 랭킹이 표시되지 않아요.', style: rankDescriptionMainText)),
      );
    }
  }
}
