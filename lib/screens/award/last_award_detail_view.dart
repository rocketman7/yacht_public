import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/last_subLeague_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/profile/profile_others_view.dart';
import 'package:yachtOne/screens/ranks/rank_share_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import 'dart:math' as math;

import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';
import '../../handlers/numbers_handler.dart' as NumbersHandler;

import 'award_detail_view.dart';
import 'award_view_model.dart';
import 'last_award_detail_view_model.dart';
import 'last_award_view.dart';

class LastAwardDetailView extends StatelessWidget {
  LastAwardDetailView({required this.lastSubLeague});

  final LastSubLeagueModel lastSubLeague;

  @override
  Widget build(BuildContext context) {
    final LastAwardDetailViewModel lastAwardDetailViewModel =
        Get.put(LastAwardDetailViewModel(lastSubLeague: lastSubLeague));

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: newPrimaryAppBar("지난 리그 자세히 보기"),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(14.0.w),
            child: GetBuilder<LastAwardDetailViewModel>(builder: (controller) {
              return Container(
                width: double.infinity,
                decoration: primaryBoxDecoration.copyWith(
                    // color: Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFCEC4DA).withOpacity(0.3),
                        blurRadius: 8.w,
                        spreadRadius: 1.w,
                        offset: Offset(0, 0),
                      ),
                    ], borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 347.w,
                          height: 185.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: buttonNormal,
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: yachtShadow,
                              //     blurRadius: 8.w,
                              //     spreadRadius: 1.w,
                              //   )
                              // ],
                              border: Border.all(
                                color: yachtViolet.withOpacity(0.05),
                                width: 1.w,
                              )),
                        ),
                        Positioned(
                          top: 6.w,
                          left: 8.w,
                          child: Container(
                              width: 331.w,
                              height: 173.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFFFDFEFF).withOpacity(0),
                                      Color(0xFFFDFEFF).withOpacity(1),
                                      Color(0xFFFDFEFF).withOpacity(0),
                                    ],
                                  ),
                                  color: Color(0xFFFDFEFF).withOpacity(.5))),
                        ),
                        Positioned(
                          top: 0.w,
                          left: 0.w,
                          child: Container(
                            width: 347.w,
                            height: 185.w,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 21.w + 1.w,
                                ),
                                Center(
                                  child: Container(
                                    child: Text(
                                      '${controller.lastSubLeague.name}',
                                      style: lastLeagueViewAwardTitleText,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.w - 2.w,
                                ),
                                Padding(
                                  // padding: EdgeInsets.only(left: 24.w, right: 24.w),
                                  padding:
                                      EdgeInsets.only(left: 8.w, right: 8.w),
                                  child: Container(
                                    height: 1.w,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFF798AE6).withOpacity(0),
                                            Color(0xFF798AE6).withOpacity(0.5),
                                            Color(0xFF798AE6).withOpacity(0),
                                          ],
                                        ),
                                        color:
                                            Color(0xFF798AE6).withOpacity(0.3)),
                                  ),
                                ),
                                SizedBox(
                                  height: 16.w - 6.w,
                                ),
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Spacer(),
                                      Container(
                                        // color: Colors.grey,
                                        child: Image.asset(
                                            'assets/icons/won_mark.png',
                                            height: 30.w,
                                            width: 36.w,
                                            color: yachtDarkGrey),
                                      ),
                                      SizedBox(width: 7.0.w),
                                      Container(
                                        // color: Colors.grey,
                                        child: Text(
                                          '${NumbersHandler.toPriceKRW(controller.lastSubLeague.totalValue!)}',
                                          style: lastLeagueViewAwardAmountText
                                              .copyWith(height: 1.05),
                                        ),
                                      ),
                                      Spacer(),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                    ]),
                                SizedBox(height: 8.w + 1.w + 1.w),
                                Container(
                                  // color: Colors.grey,
                                  child: Text(
                                      '상금 약 ${NumbersHandler.parseNumberKRWtoApproxiKorean(controller.lastSubLeague.totalValue!)}',
                                      style:
                                          lastLeagueViewAwardKoreanAmountText),
                                ),
                                SizedBox(height: 8.w - 2.w),
                                Padding(
                                  // padding: EdgeInsets.only(left: 24.w, right: 24.w),
                                  padding:
                                      EdgeInsets.only(left: 8.w, right: 8.w),
                                  child: Container(
                                    height: 1.w,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color(0xFF798AE6).withOpacity(0),
                                            Color(0xFF798AE6).withOpacity(0.5),
                                            Color(0xFF798AE6).withOpacity(0),
                                          ],
                                        ),
                                        color:
                                            Color(0xFF798AE6).withOpacity(0.3)),
                                  ),
                                ),
                                SizedBox(
                                  height: 11.w + 1.w,
                                ),
                                Container(
                                  // color: Colors.grey,
                                  child: Text(
                                    '${controller.lastSubLeague.leagueEndDateTime}',
                                    style: lastLeagueViewAwardDateText,
                                  ),
                                ),
                                SizedBox(
                                  height: 17.w - 2.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.w),
                    Padding(
                      padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${controller.lastSubLeague.description}'
                              .replaceAll('\\n', '\n'),
                          style: lastLeagueDetailViewAwardDescriptionText,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: correctHeight(
                            12.w,
                            lastLeagueDetailViewAwardDescriptionText.fontSize,
                            subLeagueAwardRulesStyle.fontSize)),
                    Padding(
                      padding: EdgeInsets.only(left: 15.5.w, right: 15.5.w),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: SubLeagueViewDetailRulesTextWidget(
                          rules: controller.lastSubLeague.rules,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: correctHeight(
                          50.w,
                          subLeagueAwardRulesStyle.fontSize,
                          lastLeagueDetailViewAwardRulesText.fontSize),
                    ),
                    LeagueAwardList(),
                    Padding(
                      padding: EdgeInsets.only(left: 14.0.w),
                      child: Text(
                        '상금 주식 포트폴리오',
                        style: lastLeagueDetailViewTitleText,
                      ),
                    ),
                    Portfolio(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class LeagueAwardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 14.0.w),
          child: Text(
            '리그 수상 내역',
            style: lastLeagueDetailViewTitleText,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 14.w, right: 13.w),
          child: Container(
            height: 200.w,
            width: 320.w,
            child: Stack(
              children: [
                Positioned(
                  top: 77.w,
                  left: 0.w,
                  child: Container(
                    width: 92.w,
                    height: 123.w,
                    decoration: primaryBoxDecoration.copyWith(boxShadow: [
                      BoxShadow(
                        color: Color(0xFFCEC4DA).withOpacity(0.3),
                        blurRadius: 8.w,
                        spreadRadius: 1.w,
                        offset: Offset(0, 0),
                      ),
                    ], borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Positioned(
                  top: 49.w,
                  left: 19.w,
                  child: GestureDetector(
                    onTap: () {
                      rankDialog(
                          context,
                          1,
                          Get.find<LastAwardDetailViewModel>()
                              .rankOrder[1]['rank']!
                              .toInt());
                    },
                    child: Image.asset(
                      'assets/icons/silver_medal.png',
                      height: 54.w,
                      width: 54.w,
                    ),
                  ),
                ),
                GetBuilder<LastAwardDetailViewModel>(builder: (controller) {
                  return controller.isLastSubLeaguesAllLoaded
                      ? Positioned(
                          top: 104.w,
                          left: 27.w,
                          child: CachedNetworkImage(
                            //2등들 중 대표의 아바타
                            imageUrl:
                                "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${controller.allFinalRanks[controller.rankOrder[1]['firstIndex']!.toInt()].avatarImage}.png",
                            height: 38.w,
                            width: 38.w,
                          ),
                        )
                      : Container();
                }),
                Positioned(
                    top: 168.w,
                    left: 8.w,
                    child: Container(
                        height: 24.w,
                        width: 76.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            color: Color(0xFFECF3FF)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 8.w,
                            ),
                            Image.asset(
                              'assets/icons/won_mark_two.png',
                              height: 11.79.w,
                              width: 15.w,
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            GetBuilder<LastAwardDetailViewModel>(
                                builder: (controller) {
                              return controller.isLastSubLeaguesAllLoaded
                                  ? Container(
                                      width: 40.w,
                                      child: AutoSizeText(
                                        //2등들 상금
                                        '${toPriceKRW(controller.getAwardPrice(controller.rankOrder[1]['firstIndex']!.toInt()))}',
                                        maxLines: 1,
                                        minFontSize: 5.w,
                                        style: lastLeagueDetailViewAmountText
                                            .copyWith(fontSize: 14.w),
                                      ),
                                    )
                                  : Container();
                            }),
                          ],
                        ))),
                Positioned(
                    top: 142.w + 4.w,
                    left: 8.w,
                    child: Container(
                      width: 76.w,
                      child: GetBuilder<LastAwardDetailViewModel>(
                          builder: (controller) {
                        return controller.isLastSubLeaguesAllLoaded
                            ? Center(
                                child: Text(
                                  //2등들 중 대표의 닉네임
                                  controller.rankOrder[1]['nums'] == 1
                                      ? '${controller.allFinalRanks[controller.rankOrder[1]['firstIndex']!.toInt()].userName}'
                                      : '총 ${controller.rankOrder[1]['nums']}명',
                                  style: lastLeagueDetailViewNickNameText
                                      .copyWith(fontSize: 14.w),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            : Container();
                      }),
                    )),
                Positioned(
                  top: 77.w,
                  left: 0.w,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      rankDialog(
                          context,
                          1,
                          Get.find<LastAwardDetailViewModel>()
                              .rankOrder[1]['rank']!
                              .toInt());
                    },
                    child: Container(
                      width: 92.w,
                      height: 123.w,
                    ),
                  ),
                ),
                Positioned(
                  top: 40.w,
                  left: 104.w,
                  child: Container(
                    width: 120.w,
                    height: 160.w,
                    decoration: primaryBoxDecoration.copyWith(boxShadow: [
                      BoxShadow(
                        color: Color(0xFFCEC4DA).withOpacity(0.3),
                        blurRadius: 8.w,
                        spreadRadius: 1.w,
                        offset: Offset(0, 0),
                      ),
                    ], borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Positioned(
                  top: 0.w,
                  left: 124.w,
                  child: GestureDetector(
                    onTap: () {
                      rankDialog(
                          context,
                          0,
                          Get.find<LastAwardDetailViewModel>()
                              .rankOrder[0]['rank']!
                              .toInt());
                    },
                    child: Image.asset(
                      'assets/icons/gold_medal.png',
                      height: 80.w,
                      width: 80.w,
                    ),
                  ),
                ),
                GetBuilder<LastAwardDetailViewModel>(builder: (controller) {
                  return controller.isLastSubLeaguesAllLoaded
                      ? Positioned(
                          top: 81.w,
                          left: 140.w,
                          child: CachedNetworkImage(
                            //1등들 중 대표의 아바타
                            imageUrl:
                                "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${controller.allFinalRanks[controller.rankOrder[0]['firstIndex']!.toInt()].avatarImage}.png",
                            height: 48.w,
                            width: 48.w,
                          ),
                        )
                      : Container();
                }),
                Positioned(
                    top: 162.w,
                    left: 114.w,
                    child: Container(
                        height: 30.w,
                        width: 101.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            color: Color(0xFFECF3FF)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 8.w,
                            ),
                            Image.asset(
                              'assets/icons/won_mark_two.png',
                              height: 12.82.w,
                              width: 17.w,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            GetBuilder<LastAwardDetailViewModel>(
                                builder: (controller) {
                              return controller.isLastSubLeaguesAllLoaded
                                  ? Container(
                                      width: 62.w,
                                      child: AutoSizeText(
                                        //1등들 상금
                                        '${toPriceKRW(controller.getAwardPrice(controller.rankOrder[0]['firstIndex']!.toInt()))}',
                                        maxLines: 1,
                                        minFontSize: 5.w,
                                        style: lastLeagueDetailViewAmountText
                                            .copyWith(fontSize: 16.w),
                                      ),
                                    )
                                  : Container();
                            }),
                          ],
                        ))),
                Positioned(
                    top: 130.w + 4.5.w,
                    left: 114.w,
                    child: Container(
                      width: 101.w,
                      child: GetBuilder<LastAwardDetailViewModel>(
                          builder: (controller) {
                        return controller.isLastSubLeaguesAllLoaded
                            ? Center(
                                child: Text(
                                  //1등들 중 대표의 닉네임
                                  controller.rankOrder[0]['nums'] == 1
                                      ? '${controller.allFinalRanks[controller.rankOrder[0]['firstIndex']!.toInt()].userName}'
                                      : '총 ${controller.rankOrder[0]['nums']}명',
                                  style: lastLeagueDetailViewNickNameText
                                      .copyWith(fontSize: 18.w),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            : Container();
                      }),
                    )),
                Positioned(
                  top: 40.w,
                  left: 104.w,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      rankDialog(
                          context,
                          0,
                          Get.find<LastAwardDetailViewModel>()
                              .rankOrder[0]['rank']!
                              .toInt());
                    },
                    child: Container(
                      width: 120.w,
                      height: 160.w,
                    ),
                  ),
                ),
                Positioned(
                  top: 88.w,
                  left: 236.w,
                  child: Container(
                    width: 84.w,
                    height: 112.w,
                    decoration: primaryBoxDecoration.copyWith(boxShadow: [
                      BoxShadow(
                        color: Color(0xFFCEC4DA).withOpacity(0.3),
                        blurRadius: 8.w,
                        spreadRadius: 1.w,
                        offset: Offset(0, 0),
                      ),
                    ], borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                Positioned(
                  top: 64.w,
                  left: 255.w,
                  child: GestureDetector(
                    onTap: () {
                      rankDialog(
                          context,
                          2,
                          Get.find<LastAwardDetailViewModel>()
                              .rankOrder[2]['rank']!
                              .toInt());
                    },
                    child: Image.asset(
                      'assets/icons/bronze_medal.png',
                      height: 45.w,
                      width: 45.w,
                    ),
                  ),
                ),
                GetBuilder<LastAwardDetailViewModel>(builder: (controller) {
                  return controller.isLastSubLeaguesAllLoaded
                      ? Positioned(
                          top: 110.w,
                          left: 261.w,
                          child: CachedNetworkImage(
                            //3등들 중 대표의 아바타
                            imageUrl:
                                "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${controller.allFinalRanks[controller.rankOrder[2]['firstIndex']!.toInt()].avatarImage}.png",
                            height: 33.w,
                            width: 33.w,
                          ),
                        )
                      : Container();
                }),
                Positioned(
                    top: 166.w,
                    left: 242.w,
                    child: Container(
                        height: 26.w,
                        width: 72.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(45),
                            color: Color(0xFFECF3FF)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 8.w,
                            ),
                            Image.asset(
                              'assets/icons/won_mark_two.png',
                              height: 9.81.w,
                              width: 13.w,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            GetBuilder<LastAwardDetailViewModel>(
                                builder: (controller) {
                              return controller.isLastSubLeaguesAllLoaded
                                  ? Container(
                                      width: 42.w,
                                      child: AutoSizeText(
                                        //3등들 상금
                                        '${toPriceKRW(controller.getAwardPrice(controller.rankOrder[2]['firstIndex']!.toInt()))}',
                                        maxLines: 1,
                                        minFontSize: 5.w,
                                        style: lastLeagueDetailViewAmountText
                                            .copyWith(fontSize: 16.w),
                                      ),
                                    )
                                  : Container();
                            }),
                          ],
                        ))),
                Positioned(
                    top: 143.w + 4.w,
                    left: 242.w,
                    child: Container(
                      width: 72.w,
                      child: GetBuilder<LastAwardDetailViewModel>(
                          builder: (controller) {
                        return controller.isLastSubLeaguesAllLoaded
                            ? Center(
                                child: Text(
                                  //3등들 중 대표의 닉네임
                                  controller.rankOrder[2]['nums'] == 1
                                      ? '${controller.allFinalRanks[controller.rankOrder[2]['firstIndex']!.toInt()].userName}'
                                      : '총 ${controller.rankOrder[2]['nums']}명',
                                  style: lastLeagueDetailViewNickNameText
                                      .copyWith(fontSize: 11.w),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )
                            : Container();
                      }),
                    )),
                Positioned(
                  top: 88.w,
                  left: 236.w,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      rankDialog(
                          context,
                          2,
                          Get.find<LastAwardDetailViewModel>()
                              .rankOrder[2]['rank']!
                              .toInt());
                    },
                    child: Container(
                      width: 84.w,
                      height: 112.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 6.w,
        ),
        ///////////////////////////
        GetBuilder<LastAwardDetailViewModel>(
          builder: (controller) {
            return controller.isLastSubLeaguesAllLoaded
                ? Column(
                    children: controller.rankOrder
                        .sublist(
                            3,
                            controller.moreRanks
                                ? controller.rankOrder.length
                                : 3 + 2)
                        .asMap()
                        .map((i, element) => MapEntry(
                              i,
                              Column(
                                children: [
                                  SizedBox(
                                    height: 8.w,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 14.w, right: 14.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        rankDialog(
                                            context,
                                            i + 3,
                                            controller.rankOrder[i + 3]['rank']!
                                                .toInt());
                                      },
                                      child: Container(
                                          width: 320.w,
                                          height: 52.w,
                                          decoration: primaryBoxDecoration
                                              .copyWith(
                                                  boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFFCEC4DA)
                                                      .withOpacity(0.3),
                                                  blurRadius: 8.w,
                                                  spreadRadius: 1.w,
                                                  offset: Offset(0, 0),
                                                ),
                                              ],
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 11.w, right: 8.w),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 320.w -
                                                        11.w -
                                                        8.w -
                                                        1.w,
                                                    height: 52.w,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                            height: 52.w,
                                                            width: 29.w,
                                                            child: Stack(
                                                              children: [
                                                                Positioned(
                                                                    left: 0.w,
                                                                    top: 13.w,
                                                                    child: Image
                                                                        .asset(
                                                                      controller.rankOrder[i + 3]['rank']! <=
                                                                              5
                                                                          ? 'assets/icons/medal.png'
                                                                          : 'assets/icons/no_medal.png',
                                                                      height:
                                                                          29.w,
                                                                      width:
                                                                          29.w,
                                                                    )),
                                                                Positioned(
                                                                    left: 0.w,
                                                                    top: 13.w,
                                                                    child: Container(
                                                                        height: 29.w,
                                                                        width: 29.w,
                                                                        child: Center(
                                                                          child:
                                                                              Text(
                                                                            '${controller.rankOrder[i + 3]['rank']}',
                                                                            style:
                                                                                lastLeagueDetailViewRankText.copyWith(fontSize: controller.rankOrder[i + 3]['rank']! <= 9 ? 20.w : 16.w),
                                                                          ),
                                                                        )))
                                                              ],
                                                            )),
                                                        SizedBox(
                                                          width: 14.w,
                                                        ),
                                                        CachedNetworkImage(
                                                          imageUrl:
                                                              "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${controller.allFinalRanks[controller.rankOrder[i + 3]['firstIndex']!.toInt()].avatarImage}.png",
                                                          height: 20.w,
                                                          width: 20.w,
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Text(
                                                          controller.rankOrder[
                                                                          i + 3]
                                                                      [
                                                                      'nums'] ==
                                                                  1
                                                              ? '${controller.allFinalRanks[controller.rankOrder[i + 3]['firstIndex']!.toInt()].userName}'
                                                              : '총 ${controller.rankOrder[i + 3]['nums']}명',
                                                          style:
                                                              lastLeagueDetailViewNickNameText
                                                                  .copyWith(
                                                                      fontSize:
                                                                          14.w),
                                                        ),
                                                        Spacer(),
                                                        Container(
                                                            height: 28.w,
                                                            width: 90.w,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            45),
                                                                color: Color(
                                                                    0xFFECF3FF)),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                SizedBox(
                                                                  width: 10.w,
                                                                ),
                                                                Image.asset(
                                                                  'assets/icons/won_mark_two.png',
                                                                  height:
                                                                      10.88.w,
                                                                  width:
                                                                      13.79.w,
                                                                ),
                                                                SizedBox(
                                                                  width: 2.21.w,
                                                                ),
                                                                Container(
                                                                  width: 63.w,
                                                                  child:
                                                                      AutoSizeText(
                                                                    //각 상금
                                                                    '${toPriceKRW(controller.getAwardPrice(controller.rankOrder[i + 3]['firstIndex']!.toInt()))}',
                                                                    maxLines: 1,
                                                                    minFontSize:
                                                                        5.w,
                                                                    style: lastLeagueDetailViewAmountText.copyWith(
                                                                        fontSize:
                                                                            14.w),
                                                                  ),
                                                                ),
                                                              ],
                                                            ))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ))),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .values
                        .toList(),
                  )
                : Container();
          },
        ),
        Get.find<LastAwardDetailViewModel>().rankNums.length > 5
            ? Column(
                children: [
                  SizedBox(
                    height: 8.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 14.w, right: 14.w),
                    child: GestureDetector(
                      onTap: () {
                        Get.find<LastAwardDetailViewModel>().moreRanksMethod();
                      },
                      child: Container(
                        width: 320.w,
                        height: 40.w,
                        decoration: primaryBoxDecoration.copyWith(boxShadow: [
                          BoxShadow(
                            color: Color(0xFFCEC4DA).withOpacity(0.3),
                            blurRadius: 8.w,
                            spreadRadius: 1.w,
                            offset: Offset(0, 0),
                          ),
                        ], borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Spacer(),
                            Text(
                                Get.find<LastAwardDetailViewModel>().moreRanks
                                    ? '수상 내역 줄이기'
                                    : '수상 내역 더보기',
                                style: lastLeagueDetailMoreText),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(),

        SizedBox(
          height: 50.w,
        ),
      ],
    );
  }
}

class Portfolio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LastAwardDetailViewModel>(builder: (controller) {
      return Column(
        children: [
          SizedBox(
              height:
                  correctHeight(20.w, awardModuleTitleTextStyle.fontSize, 0.w)),
          Padding(
            padding:
                EdgeInsets.only(left: 14.0.w, right: 14.0.w, bottom: 18.0.w),
            child: Container(
              height: SizeConfig.screenWidth - 14.0.w * 4,
              width: SizeConfig.screenWidth - 14.0.w * 4,
              color: Colors.white,
              child: PortfolioChartForLastSubLeagues(),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 14.0.w, right: 14.0.w),
              child: PortfolioLabelForLastSubLeagues()),
          SizedBox(
            height: 13.w,
          ),
        ],
      );
    });
  }
}

class PortfolioLabelForLastSubLeagues extends StatelessWidget {
  final LastAwardDetailViewModel _lastAwardDetailViewModel =
      Get.find<LastAwardDetailViewModel>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LastAwardDetailViewModel>(builder: (controller) {
      return controller.isLastSubLeaguesAllLoaded
          ? Column(
              children: [
                Container(
                  height: 1.w,
                  width: double.infinity,
                  color: yachtLightGrey,
                ),
                SizedBox(
                    height: correctHeight(9.w, 0.w,
                        subLeagueAwardLabelTotalValueTextStyleNew.fontSize)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('총 상금', style: subLeagueAwardLabelTotalTextStyleNew),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      '${NumbersHandler.toPriceKRW(_lastAwardDetailViewModel.totalCurrentValue)}원',
                      style: subLeagueAwardLabelTotalValueTextStyleNew,
                    ),
                    Spacer(),
                    Text(
                        '${plusOrminusSymbol(_lastAwardDetailViewModel.totalCurrentValue, _lastAwardDetailViewModel.totalValue)}${NumbersHandler.toPriceKRW(_lastAwardDetailViewModel.totalCurrentValue - _lastAwardDetailViewModel.totalValue)} (${NumbersHandler.toPercentageChange((_lastAwardDetailViewModel.totalCurrentValue - _lastAwardDetailViewModel.totalValue) / _lastAwardDetailViewModel.totalValue)})',
                        style: subLeagueAwardLabelPLTextStyleNew.copyWith(
                            color: plusOrminusColor(
                                _lastAwardDetailViewModel.totalCurrentValue,
                                _lastAwardDetailViewModel.totalValue))),
                  ],
                ),
                SizedBox(
                    height: correctHeight(
                        6.w,
                        subLeagueAwardLabelTotalValueTextStyleNew.fontSize,
                        0.w)),
                Container(
                  height: 1.w,
                  width: double.infinity,
                  color: yachtLightGrey,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _lastAwardDetailViewModel.lastSubLeague.stocks
                      .asMap()
                      .map((i, element) => MapEntry(
                          i,
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Get.to(() => Scaffold(
                                    appBar: primaryAppBar(
                                        _lastAwardDetailViewModel
                                            .lastSubLeague.stocks[i].name),
                                    body: SingleChildScrollView(
                                      child: Padding(
                                        padding: primaryHorizontalPadding,
                                        child: StockInfoKRView(
                                            investAddressModel:
                                                _lastAwardDetailViewModel
                                                    .lastSubLeague.stocks[i]
                                                    .toInvestAddressModel()),
                                      ),
                                    ),
                                  ));
                            },
                            child: Column(
                              children: [
                                SizedBox(
                                  height: correctHeight(
                                      9.w,
                                      0.w,
                                      subLeagueAwardLabelStockTextStyleNew
                                          .fontSize),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: (i < portfolioColors.length)
                                            ? portfolioColors[i]
                                            : portfolioColors[
                                                    portfolioColors.length - 1]
                                                .withOpacity(math.max(
                                                    1.0 -
                                                        0.4 *
                                                            (i -
                                                                portfolioColors
                                                                    .length +
                                                                1),
                                                    0.0)),
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                      height: 25.w,
                                      width: 25.w,
                                    ),
                                    SizedBox(
                                      width: textSizeGet('총 상금',
                                                  subLeagueAwardLabelTotalTextStyleNew)
                                              .width -
                                          25.w +
                                          4.w,
                                    ),
                                    Container(
                                      width: SizeConfig.screenWidth -
                                          14.w -
                                          14.w -
                                          textSizeGet('총 상금',
                                                  subLeagueAwardLabelTotalTextStyleNew)
                                              .width -
                                          4.w -
                                          14.w -
                                          14.w,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${_lastAwardDetailViewModel.lastSubLeague.stocks[i].name}',
                                                style:
                                                    subLeagueAwardLabelStockTextStyleNew,
                                              ),
                                              Spacer(),
                                              Text(
                                                '${_lastAwardDetailViewModel.lastSubLeague.stocks[i].sharesNum}주',
                                                style:
                                                    subLeagueAwardLabelStockTextStyleNew,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                '${NumbersHandler.toPriceKRW(_lastAwardDetailViewModel.getStockCurrentTotalValue(i))}원',
                                                style:
                                                    subLeagueAwardLabelStockPriceTextStyleNew,
                                              ),
                                              Spacer(),
                                              Text(
                                                '${plusOrminusSymbol(_lastAwardDetailViewModel.getStockCurrentTotalValue(i), _lastAwardDetailViewModel.getStockStandardTotalValue(i))}${NumbersHandler.toPriceKRW(_lastAwardDetailViewModel.getStockCurrentTotalValue(i) - _lastAwardDetailViewModel.getStockStandardTotalValue(i))} (${NumbersHandler.toPercentageChange((_lastAwardDetailViewModel.getStockCurrentTotalValue(i) - _lastAwardDetailViewModel.getStockStandardTotalValue(i)) / _lastAwardDetailViewModel.getStockStandardTotalValue(i))})',
                                                style: subLeagueAwardLabelPLTextStyleNew.copyWith(
                                                    color: plusOrminusColor(
                                                        _lastAwardDetailViewModel
                                                            .getStockCurrentTotalValue(
                                                                i),
                                                        _lastAwardDetailViewModel
                                                            .getStockStandardTotalValue(
                                                                i))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: correctHeight(
                                      6.w,
                                      subLeagueAwardLabelPLTextStyleNew
                                          .fontSize,
                                      0.w),
                                ),
                                Container(
                                  height: 1.w,
                                  width: double.infinity,
                                  color: yachtLightGrey,
                                ),
                              ],
                            ),
                          )))
                      .values
                      .toList(),
                ),
              ],
            )
          : Container();
    });
  }
}

class PortfolioChartForLastSubLeagues extends StatelessWidget {
  final LastAwardDetailViewModel _lastAwardDetailViewModel =
      Get.find<LastAwardDetailViewModel>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LastAwardDetailViewModel>(builder: (controller) {
      return controller.isLastSubLeaguesAllLoaded
          ? Container(
              width: _lastAwardDetailViewModel.portfolioArcRadius,
              height: _lastAwardDetailViewModel.portfolioArcRadius,
              child: Stack(
                children: portfolioList(),
              ),
            )
          : Container();
    });
  }

  List<Widget> portfolioList() {
    List<Widget> result = [];

    for (int i = 0;
        i < _lastAwardDetailViewModel.lastSubLeague.stocks.length;
        i++) {
      result.add(
        GestureDetector(
          onTap: () {},
          child: CustomPaint(
            size: Size(_lastAwardDetailViewModel.portfolioArcRadius,
                _lastAwardDetailViewModel.portfolioArcRadius),
            painter: PortfolioArcChartPainter(
              center: Offset(_lastAwardDetailViewModel.portfolioArcRadius / 2,
                  _lastAwardDetailViewModel.portfolioArcRadius / 2),
              color: (i < portfolioColors.length)
                  ? portfolioColors[i]
                  : portfolioColors[portfolioColors.length - 1].withOpacity(math
                      .max(1.0 - 0.4 * (i - portfolioColors.length + 1), 0.0)),
              percentage1: _lastAwardDetailViewModel
                      .subLeaguePortfolioUIModels[i].startPercentage! *
                  100,
              percentage2: _lastAwardDetailViewModel
                      .subLeaguePortfolioUIModels[i].endPercentage! *
                  100,
            ),
          ),
        ),
      );
    }

    for (int i = 0;
        i < _lastAwardDetailViewModel.lastSubLeague.stocks.length;
        i++) {
      if (_lastAwardDetailViewModel
          .subLeaguePortfolioUIModels[i].legendVisible!)
        result.add(
          Positioned(
            left: _lastAwardDetailViewModel
                .subLeaguePortfolioUIModels[i].portionOffsetFromCenter!.dx,
            top: _lastAwardDetailViewModel
                .subLeaguePortfolioUIModels[i].portionOffsetFromCenter!.dy,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.to(() => Scaffold(
                      appBar: primaryAppBar(_lastAwardDetailViewModel
                          .lastSubLeague.stocks[i].name),
                      body: SingleChildScrollView(
                        child: Padding(
                          padding: primaryHorizontalPadding,
                          child: StockInfoKRView(
                              investAddressModel: _lastAwardDetailViewModel
                                  .lastSubLeague.stocks[i]
                                  .toInvestAddressModel()),
                        ),
                      ),
                    ));
                // 주식 세부페이지로 가는 네비게잇 필요
                // print(i);
              },
              child: Text(
                '${_lastAwardDetailViewModel.subLeaguePortfolioUIModels[i].roundPercentage}%',
                style: lastLeagueDetailViewPortfolioPercentage,
              ),
            ),
          ),
        );
      if (_lastAwardDetailViewModel
          .subLeaguePortfolioUIModels[i].legendVisible!)
        result.add(
          Positioned(
              left: _lastAwardDetailViewModel
                  .subLeaguePortfolioUIModels[i].stockNameOffsetFromCenter!.dx,
              top: _lastAwardDetailViewModel
                  .subLeaguePortfolioUIModels[i].stockNameOffsetFromCenter!.dy,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.to(() => Scaffold(
                        appBar: primaryAppBar(_lastAwardDetailViewModel
                            .lastSubLeague.stocks[i].name),
                        body: SingleChildScrollView(
                          child: Padding(
                            padding: primaryHorizontalPadding,
                            child: StockInfoKRView(
                                investAddressModel: _lastAwardDetailViewModel
                                    .lastSubLeague.stocks[i]
                                    .toInvestAddressModel()),
                          ),
                        ),
                      ));
                  // 주식 세부페이지로 가는 네비게잇 필요
                  // print(i);
                },
                child: Container(
                  child: Text(
                    _lastAwardDetailViewModel.lastSubLeague.stocks[i].name,
                    style: lastLeagueDetailViewPortfolioName,
                  ),
                ),
              )),
        );
    }

    return result;
  }
}

class PortfolioArcChartPainter extends CustomPainter {
  Offset? center;
  Color? color;
  double? percentage1 = 0.0;
  double? percentage2 = 0.0;

  PortfolioArcChartPainter(
      {this.center, this.color, this.percentage1, this.percentage2});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // ..color = color!
      ..shader = RadialGradient(
        colors: [
          color!,
          color!.withOpacity(0.5),
        ],
      ).createShader(Rect.fromCircle(
        center: center!,
        radius: size.width / 2,
      ))
      ..style = PaintingStyle.fill;

    double radius = size.width / 2;

    double arcAngle1 = 2 * math.pi * (percentage1! / 100) - math.pi / 2;
    double arcAngle2 = 2 * math.pi * (percentage2! / 100) - math.pi / 2;
    canvas.drawArc(Rect.fromCircle(center: center!, radius: radius), arcAngle1,
        arcAngle2 - arcAngle1, true, paint);
  }

  @override
  bool shouldRepaint(PortfolioArcChartPainter oldDelegate) {
    return false;
  }

  // @override
  // bool hitTest(Offset position) {
  //   return super.hitTest(position)!;
  //   //   return paint.contains(position);
  // }
}

String plusOrminusSymbol(double a, double b) {
  if (a > b)
    return '+';
  else if (a == b)
    return '';
  else
    return '';
}

Color plusOrminusColor(double a, double b) {
  if (a > b)
    return yachtRed;
  else if (a == b)
    return yachtBlack;
  else
    return yachtBlue;
}

//순위다이얼로그
rankDialog(BuildContext context, int index, int rank) {
  final LastAwardDetailViewModel _lastAwardDetailViewModel =
      Get.find<LastAwardDetailViewModel>();

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
            height: 400.w,
            // height: 506.w,
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
                        Text('수상 내역 자세히 보기', style: yachtBadgesDialogTitle)
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
                  height: 20.w,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    Text('$rank등 주식 수령 내역',
                        style: lastLeagueDetailViewDialogTitle),
                    Spacer(),
                    Image.asset(
                      'assets/icons/won_mark_two.png',
                      height: 14.37.w,
                      width: 17.w,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      '${toPriceKRW(_lastAwardDetailViewModel.getAwardPrice(_lastAwardDetailViewModel.rankOrder[index]['firstIndex']!.toInt()))}',
                      style: lastLeagueDetailViewDialogTitle.copyWith(
                          color: yachtBlue,
                          fontSize: 18.w,
                          height: 1.79,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 3.w,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Container(height: 1, color: yachtLightGrey)),
                Column(
                  children: _lastAwardDetailViewModel
                      .allFinalRanks[_lastAwardDetailViewModel.rankOrder[index]
                              ['firstIndex']!
                          .toInt()]
                      .award
                      .asMap()
                      .map((i, element) => MapEntry(
                          i,
                          Column(
                            children: [
                              SizedBox(
                                height: 5.w,
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.w, right: 20.w),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 21.5.w,
                                        height: 18.w,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: (i < portfolioColors.length)
                                              ? portfolioColors[i]
                                              : portfolioColors[
                                                      portfolioColors.length -
                                                          1]
                                                  .withOpacity(math.max(
                                                      1.0 -
                                                          0.4 *
                                                              (i -
                                                                  portfolioColors
                                                                      .length +
                                                                  1),
                                                      0.0)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                          _lastAwardDetailViewModel
                                                  .allFinalRanks[
                                                      _lastAwardDetailViewModel
                                                          .rankOrder[index]
                                                              ['firstIndex']!
                                                          .toInt()]
                                                  .award[i]
                                                  .isStock
                                              ? '${_lastAwardDetailViewModel.lastSubLeague.stocks[_lastAwardDetailViewModel.allFinalRanks[_lastAwardDetailViewModel.rankOrder[index]['firstIndex']!.toInt()].award[i].stocksIndex!.toInt()].name}'
                                              : '요트포인트',
                                          style:
                                              lastLeagueDetailViewDialogContent),
                                      Spacer(),
                                      Text(
                                          _lastAwardDetailViewModel
                                                  .allFinalRanks[
                                                      _lastAwardDetailViewModel
                                                          .rankOrder[index]
                                                              ['firstIndex']!
                                                          .toInt()]
                                                  .award[i]
                                                  .isStock
                                              ? '${_lastAwardDetailViewModel.allFinalRanks[_lastAwardDetailViewModel.rankOrder[index]['firstIndex']!.toInt()].award[i].sharesNum}주'
                                              : '${NumbersHandler.toPriceKRW(_lastAwardDetailViewModel.allFinalRanks[_lastAwardDetailViewModel.rankOrder[index]['firstIndex']!.toInt()].award[i].yachtPoint!)}원',
                                          style:
                                              lastLeagueDetailViewDialogContent)
                                    ],
                                  )),
                              SizedBox(
                                height: 4.w,
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.w, right: 20.w),
                                  child: Container(
                                      height: 1, color: yachtLightGrey)),
                            ],
                          )))
                      .values
                      .toList(),
                ),
                SizedBox(
                  height: 20.w,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    Text('$rank등 수상자리스트',
                        style: lastLeagueDetailViewDialogTitle),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 10.w,
                ),
                Flexible(
                    child: Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Container(
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _lastAwardDetailViewModel
                              .getRanksModels(rank)
                              .asMap()
                              .map((i, element) => MapEntry(
                                    i,
                                    Column(
                                      children: [
                                        GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            if (element.uid !=
                                                userModelRx.value!.uid) {
                                              Navigator.of(context).pop();
                                              Get.to(() => ProfileOthersView(
                                                  uid: element.uid));
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl:
                                                    "https://storage.googleapis.com/ggook-5fb08.appspot.com/avatars/${element.avatarImage}.png",
                                                height: 30.w,
                                                width: 30.w,
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                '${element.userName}',
                                                style:
                                                    lastLeagueDetailViewDialogName,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.w,
                                        ),
                                      ],
                                    ),
                                  ))
                              .values
                              .toList(),
                        )
                      ],
                    ),
                  ),
                )),
                SizedBox(
                  height: 10.w,
                ),
              ],
            ),
          ),
        );
      });
}
