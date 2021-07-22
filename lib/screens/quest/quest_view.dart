import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/corporation_model.dart';
import 'package:yachtOne/screens/stock_info/chart/chart_view.dart';
import 'package:yachtOne/screens/stock_info/chart/chart_view_model.dart';
import 'package:yachtOne/screens/home/quest_widget.dart';
import 'package:yachtOne/screens/quest/quest_view_model.dart';
import 'package:yachtOne/screens/stock_info/stats/stats_view_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view.dart';
import 'package:yachtOne/screens/stock_info/stock_info_kr_view_model.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../home/quest_widget.dart';
import 'package:yachtOne/styles/style_constants.dart';

import 'decision_container.dart';

// const double heightForSliverFlexibleSpace =
//     kToolbarHeight + 220.0; // 당연히 기기마다 달라져야함. SliverFlexibleSpace를 위한 height
// const double paddingForRewardText = 8.0; // 상금 주식 가치 텍스트 위의 패딩(마진)
// const Color sliverAppBarColor = Color(0xFFD9D9D9);
// const Color backgroundColor = Colors.white;

class QuestView extends StatelessWidget {
  // final QuestModel questModel;
  // QuestView({Key? key, required this.questModel}) : super(key: key);
  // const QuestView({Key? key}) : super(key: key);

  // final ScrollController _scrollController =
  //     ScrollController(initialScrollOffset: 0.0);

  QuestModel questModel = Get.arguments;

  double appBarHeight = 0;
  double bottomBarHeight = 0;
  double offset = 0.0;

  @override
  Widget build(BuildContext context) {
    print('quest view로 전달된 quest model: $questModel');
    // 뷰 모델에 퀘스트 데이터 모델 넣어주기
    final QuestViewModel questViewModel = Get.put(QuestViewModel(questModel));

    final stockInfoViewModel = Get.put(StockInfoKRViewModel(
        stockAddressModel:
            questModel.stockAddress[questViewModel.stockInfoIndex]));
    // questViewModel.init(questModel);
    // streamSubscription =
    //     StockInfoKRView.streamController.stream.listen((event) {
    //   offset = event;
    //   localStreamController.add(offset);
    // });

    print("quest view rebuilt");

    // StreamController controller = StockInfoKRView
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
    // ));

    return Scaffold(
      // ClipRect(
      //     child: BackdropFilter(
      //   filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      //   child: Opacity(
      //       opacity: 0.8,
      //       child: Container(
      //         // Don't wrap this in any SafeArea widgets, use padding instead
      //         // padding: EdgeInsets.only(top: safeAreaPadding.top),
      //         // height: maxExtent,
      //         color: primaryBackgroundColor,
      //         child: Padding(
      //           padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
      //           child: Center(
      //               child: Row(
      //             crossAxisAlignment: CrossAxisAlignment.end,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Container(
      //                 child: Text(
      //                   "장한나",
      //                   style: homeHeaderName,
      //                 ),
      //               ),
      //               Container(
      //                 // color: Colors.blue,
      //                 child: Text(" 님의 요트", style: homeHeaderAfterName),
      //               ),
      //             ],
      //           )),
      //         ),
      //         // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
      //         // child: Stack(
      //         //   clipBehavior: Clip.none,
      //         //   children: <Widget>[
      //         //     Positioned(
      //         //       bottom: 0,
      //         //       left: 0,
      //         //       right: 0,
      //         //       child: AppBar(
      //         //         primary: true,
      //         //         elevation: 0,
      //         //         backgroundColor: Colors.transparent,
      //         //         title: Text("Translucent App Bar"),
      //         //       ),
      //         //     )
      //         // ],
      //         // ),
      //       )),
      // )),

      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: primaryBackgroundColor,
                pinned: true,
                title: Text(
                  "퀘스트 참여하기",
                  style: homeHeaderAfterName,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: textTopPadding(homeModuleTitleTextStyle.fontSize!),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "퀘스트 정보",
                        style: homeModuleTitleTextStyle,
                      ),
                      btwHomeModuleTitleBox,
                      Container(
                          padding:
                              moduleBoxPadding(questTermTextStyle.fontSize!),
                          decoration: primaryBoxDecoration.copyWith(
                              boxShadow: [primaryBoxShadow],
                              color: homeModuleBoxBackgroundColor),
                          child: Column(
                            children: [
                              QuestCardHeader(
                                questModel: questModel,
                              ),
                              btwHomeModuleTitleBox,
                              QuestCardRewards(questModel: questModel),
                              Divider(color: primaryFontColor),
                              Text(
                                "대결 상세 description이 오는 자리입니다. 대결 상세 description이 오는 자리입니다. 대결 상세 description이 오는 자리입니다. 대결 상세 description이 오는 자리입니다. 대결 상세 description이 오는 자리입니다. 대결 상세 description이 오는 자리입니다.",
                                style: detailedContentTextStyle,
                              ) //temp
                            ],
                          )),
                      // btwHomeModule,
                    ],
                  ),
                ),
              ),
              // SliverPersistentHeader(
              //   delegate: SectionHeaderDelegate("Section B"),
              //   pinned: true,
              // ),

              SliverToBoxAdapter(
                  child: Container(
                padding: textTopPadding(homeModuleTitleTextStyle.fontSize!),
                child: Text(
                  "기업 정보",
                  style: homeModuleTitleTextStyle,
                ),
              )),
              // 스크롤 내리면 위에 붙을 퀘스트 선택지 기업 목록
              SliverPersistentHeader(
                delegate: SectionHeaderDelegate(
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(
                        questModel.stockAddress.length,
                        (index) => TextButton(
                            onPressed: () {
                              stockInfoViewModel.changeStockAddressModel(
                                  questModel.stockAddress[index]);
                            },
                            child: Text(questModel.stockAddress[index].name)),
                      )),
                ),
                pinned: true,
              ),
              SliverToBoxAdapter(
                child: btwHomeModuleTitleBox,
              ),
              SliverToBoxAdapter(
                  child: Container(
                padding: textTopPadding(homeModuleTitleTextStyle.fontSize!),
                child:
                    // 퀘스트 종목간 선택 row

                    Container(
                  // height: 1800, // temp
                  padding: moduleBoxPadding(questTermTextStyle.fontSize!),
                  decoration: primaryBoxDecoration.copyWith(
                      boxShadow: [primaryBoxShadow],
                      color: homeModuleBoxBackgroundColor),
                  child: GetBuilder<QuestViewModel>(
                    builder: (questViewModel) {
                      return StockInfoKRView(
                          stockAddressModel: questModel
                              .stockAddress[questViewModel.stockInfoIndex]);
                    },
                  ),
                ),
              )),
              SliverToBoxAdapter(
                  child: SizedBox(
                height: 88.w,
              )),
            ],
          ),
          // 선택 확정하기 눌렀을 때 배경 회색처리, 그 때 배경 아무데나 눌러도 원래 퀘스트뷰 화면으로 복귀
          Obx(() => questViewModel.isSelectingSheetShowing.value
              ? GestureDetector(
                  onTap: () {
                    questViewModel.isSelectingSheetShowing(false);
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: backgroundWhenPopup,
                  ),
                )
              : Container()),
          // 최종선택하기 위한 custom bottom sheet
          Obx(() => questViewModel.isSelectingSheetShowing.value
              ? Positioned(
                  left: 14.w,
                  right: 14.w,
                  bottom: 20.w + 60.w + 20.w,
                  child: Container(
                    // color: Colors.white,
                    width: double.infinity,
                    // height: 100,
                    padding: EdgeInsets.all(14.w),
                    decoration: (primaryBoxDecoration
                        .copyWith(boxShadow: [primaryBoxShadow])),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () =>
                                questViewModel.isSelectingSheetShowing(false),
                            child: Container(
                              alignment: Alignment.centerRight,
                              width: 50.w,
                              color: Colors.yellow.withOpacity(.2),
                              child: Icon(
                                Icons.close,
                                color: primaryFontColor,
                                size: 30.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: reducedPaddingWhenTextIsBelow(
                                8.w, questTitleTextStyle.fontSize!)),
                        Padding(
                          padding: EdgeInsets.all(16.0.w),
                          child: Text("마감기한까지 주가가 가장 많이 상승할 것 같은 기업을 골라주세요",
                              style: questTitleTextStyle,
                              textAlign: TextAlign.center),
                        ),
                        SizedBox(
                            height: reducedPaddingWhenTextIsBelow(
                                16.w, questTitleTextStyle.fontSize!)),
                        Divider(color: primaryFontColor.withOpacity(.4)),
                        Column(
                          children: List.generate(
                              questModel.stockAddress.length,
                              (index) => Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.0.w),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/buttons/radio_active.svg',
                                              width: 34.w,
                                              height: 34.w,
                                            ),
                                            SizedBox(width: 8.w),
                                            Text(
                                              questModel
                                                  .stockAddress[index].name,
                                              style: detailedContentTextStyle
                                                  .copyWith(fontSize: 18.w),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                          color:
                                              primaryFontColor.withOpacity(.4)),
                                    ],
                                  )),
                        ),
                        SizedBox(height: 12.w)
                      ],
                    ),
                  ))
              : Container()),
          Obx(
            () => Positioned(
                left: 14.w,
                right: 14.w,
                bottom: 20.w,
                child: GestureDetector(
                  onTap: () {
                    questViewModel.isSelectingSheetShowing(true);
                  },
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        height: 60.w,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.w),
                          color: activatedButtonColor.withOpacity(.85),
                        ),
                        child: Center(
                            child: Text(
                          questViewModel.isSelectingSheetShowing.value
                              ? "나의 예측 저장"
                              : "예측 확정하기",
                          style: buttonTextStyle.copyWith(fontSize: 24.w),
                        )),
                      ),
                    ),
                  ),
                )

                //  primaryButtonContainer(Text(
                //   "예측 확정하기",
                //   style: buttonTextStyle,
                // )),
                ),
          ),
        ],
      ),

      //  Column(
      //   children: [
      //     Obx(() {
      //       double offset = stockInfoViewModel.offset.value;
      //       double initialHeight = reactiveHeight(200);
      //       appBarHeight = initialHeight - offset < SizeConfig.safeAreaTop + 50
      //           ? SizeConfig.safeAreaTop + 50
      //           : initialHeight - offset;
      //       return Stack(
      //         children: [
      //           // 탑 바 배경
      //           Container(
      //             padding: EdgeInsets.only(top: kToolbarHeight),
      //             decoration: BoxDecoration(
      //                 gradient: LinearGradient(
      //                     begin: Alignment.topCenter,
      //                     end: Alignment.bottomCenter,
      //                     colors: [
      //                   Color(0xFF0099C2),
      //                   Color(0xFF01A1DF),
      //                   Color(0xFF01C8E5)
      //                 ])),
      //             // color: Colors.amber.withOpacity(.2),
      //             width: double.infinity,
      //             height: appBarHeight,
      //           ),
      //           // 스크롤 올렸을 때 상단에 뜨는 앱바
      //           Positioned.fill(
      //             // top: SizeConfig.safeAreaHeight,
      //             child: Align(
      //               alignment: Alignment(0, 0.5),
      //               child: Opacity(
      //                   opacity: offset < 0
      //                       ? 0
      //                       : offset < 100
      //                           ? offset / 100
      //                           : 1,
      //                   child: Container(
      //                       child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                     children: questViewModel.isLoading.value
      //                         ? List.generate(
      //                             1,
      //                             (index) => Container(
      //                                 height: textSizeGet("txt", headingStyle)
      //                                     .height))
      //                         : List.generate(questModel.stockAddress.length,
      //                             (index) {
      //                             return Container(
      //                               padding: EdgeInsets.symmetric(
      //                                   horizontal: 20, vertical: 8),
      //                               decoration: BoxDecoration(
      //                                   borderRadius: BorderRadius.circular(30),
      //                                   color: Color(0xff334361)),
      //                               child: Text(
      //                                 questModel.stockAddress[index].name
      //                                     .toString(),
      //                                 style: titleStyle.copyWith(
      //                                     color: Color(0xFFDBE9EE)),
      //                               ),
      //                             );
      //                           }),
      //                   ))),
      //             ),
      //           ),
      //           // 앱바 안에 Content
      //           Positioned.fill(
      //             top: -offset < -200 ? -200 : -offset,
      //             child: Opacity(
      //               opacity: (offset < 30) ? 1 : 30 / offset,
      //               child: Container(
      //                 padding: EdgeInsets.only(top: SizeConfig.safeAreaTop),
      //                 // color: Colors.red,
      //                 height: initialHeight,
      //                 width: SizeConfig.screenWidth,
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     // Text(
      //                     //   "리그 포인트 ${questModel.pointReward}점",
      //                     //   style: headingStyle,
      //                     // ),
      //                     // SizedBox(
      //                     //   child: Text(
      //                     //     "+",
      //                     //     style: subtitleStyle,
      //                     //   ),
      //                     //   // height: verticalSpaceSmall.height,
      //                     // ),
      //                     questViewModel.isLoading.value
      //                         ? Container(
      //                             width: double.infinity,
      //                             height: bigHeadingStyle.height,
      //                             color: Colors.blue,
      //                           )
      //                         : Row(
      //                             mainAxisAlignment: MainAxisAlignment.center,
      //                             children: [
      //                               SvgPicture.asset(
      //                                 'assets/icons/won_button.svg',
      //                                 width: 30,
      //                                 height: 30,
      //                               ),
      //                               SizedBox(width: 4),
      //                               Text(
      //                                 "${toPriceKRW(questModel.cashReward)}",
      //                                 style: bigHeadingStyle.copyWith(
      //                                     color: Color(0xFFDBE9EE)),
      //                               ),
      //                               horizontalSpaceMedium,
      //                               Container(
      //                                 width: 30,
      //                                 height: 30,
      //                                 decoration: BoxDecoration(
      //                                     color: Color(0xFF9E9E9E),
      //                                     borderRadius:
      //                                         BorderRadius.circular(5)),
      //                                 child: Center(
      //                                   child: Text("LP",
      //                                       style: subtitleStyle.copyWith(
      //                                           color: Colors.white)),
      //                                 ),
      //                               ),
      //                               // horizontalSpaceSmall,
      //                               SizedBox(width: 4),
      //                               Text(
      //                                 "${toPriceKRW(questModel.pointReward)}P",
      //                                 style: bigHeadingStyle.copyWith(
      //                                     color: Color(0xFFDBE9EE)),
      //                               ),
      //                               horizontalSpaceSmall,
      //                               Container(
      //                                 height: 20,
      //                                 width: 20,
      //                                 // padding: EdgeInsets.all(15),
      //                                 decoration: BoxDecoration(
      //                                   color: Colors.blueGrey[700],
      //                                   borderRadius: BorderRadius.circular(50),
      //                                 ),
      //                                 child: Center(
      //                                   child: Text(
      //                                     "?",
      //                                     style: contentStyle.copyWith(
      //                                         color: Colors.white),
      //                                   ),
      //                                 ),
      //                               )
      //                             ],
      //                           ),

      //                     verticalSpaceSmall,
      //                     questViewModel.isLoading.value
      //                         ? Container(
      //                             height: subtitleStyle.height,
      //                             color: Colors.blue,
      //                           )
      //                         : Obx(
      //                             () => Column(
      //                               children: [
      //                                 Row(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment.end,
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.center,
      //                                   children: [
      //                                     Icon(
      //                                       Icons.people,
      //                                       color: Color(0xFFDBE9EE),
      //                                     ),
      //                                     horizontalSpaceSmall,
      //                                     Text(
      //                                       "${questModel.counts![0] + questModel.counts![1]}명 참여",
      //                                       style: subtitleStyle.copyWith(
      //                                           color: Color(0xFFDBE9EE)),
      //                                     ),
      //                                   ],
      //                                 ),
      //                                 verticalSpaceMedium,
      //                                 Row(
      //                                   crossAxisAlignment:
      //                                       CrossAxisAlignment.end,
      //                                   mainAxisAlignment:
      //                                       MainAxisAlignment.center,
      //                                   children: [
      //                                     Text(
      //                                       "예측 마감까지",
      //                                       style: contentStyle.copyWith(
      //                                           color: Color(0xFFDBE9EE)),
      //                                     ),
      //                                     horizontalSpaceSmall,
      //                                     Text(
      //                                       "${questViewModel.timeToEnd.value}",
      //                                       style: subtitleStyle.copyWith(
      //                                           color: Color(0xFFDBE9EE)),
      //                                     ),
      //                                   ],
      //                                 ),
      //                               ],
      //                             ),
      //                           ),
      // Row(
      //   children: [
      //     TextButton(
      //         onPressed: () {
      //           // chartViewModel.getPrices(
      //           //     stockAddressModel.copyWith(issueCode: "005930"));
      //           stockInfoViewModel.changeStockAddressModel(
      //               questModel.stockAddress[0]);
      //           // chartViewModel.stockAddressModel =
      //           //     stockAddressModel.copyWith(issueCode: "005930");
      //           // chartViewModel
      //           //     .getPrices(chartViewModel.newStockAddress!.value);
      //         },
      //         child: Text("0번")),
      //     TextButton(
      //         onPressed: () {
      //           // chartViewModel.getPrices(
      //           //     stockAddressModel.copyWith(issueCode: "326030"));
      //           stockInfoViewModel.changeStockAddressModel(
      //               questModel.stockAddress[1]);
      //           // chartViewModel.stockAddressModel =
      //           // stockAddressModel.copyWith(issueCode: "326030");
      //           // chartViewModel
      //           //     .getPrices(chartViewModel.newStockAddress!.value);
      //         },
      //         child: Text("1번")),
      //   ],
      // ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       );
      //     }),
      //     // 종목 정보 화면
      //     Expanded(
      //         child: Stack(
      //       children: [
      //         Container(
      //           // color: Colors.amber.withOpacity(.2),
      //           child: ClipRRect(
      //             // borderRadius: BorderRadius.only(
      //             //     topLeft: Radius.circular(50),
      //             //     topRight: Radius.circular(50)),
      //             child: Column(
      //               children: [
      //                 Expanded(child: Container(
      //                   child: GetBuilder<QuestViewModel>(
      //                       builder: (questViewModel) {
      //                     return StockInfoKRView(
      //                       bottomPadding:
      //                           reactiveHeight(140) + SizeConfig.safeAreaBottom,
      //                       stockAddressModel: questModel
      //                           .stockAddress[questViewModel.stockInfoIndex],
      //                     );
      //                   }),
      //                 )),
      //                 // Container(
      //                 //   height: 100,
      //                 //   color: Colors.yellow,
      //                 // )
      //               ],
      //             ),
      //           ),
      //         ),
      //         Obx(() {
      //           double bottomPosition = 0.0;
      //           double offset = stockInfoViewModel.offset.value;

      //           bottomPosition =
      //               (-120 + (offset * 2.5)) > 25 ? 25 : -120 + (offset * 2.5);
      //           // print(offset);
      //           return Positioned(
      //             bottom: bottomPosition,
      //             left: 25,
      //             child: Align(
      //               alignment: Alignment.center,
      //               child: questViewModel.isLoading.value
      //                   ? Container(
      //                       width: SizeConfig.screenWidth - 50,
      //                       height: bigHeadingStyle.height,
      //                       color: Colors.blue,
      //                     )
      //                   : DecisionContainer(questViewModel),
      //             ),
      //           );
      //         }),
      //       ],
      //     )),
      //   ],
      // ),

      // () => CustomScrollView(
      //   controller: stockInfoViewModel.scrollController.value,
      //   slivers: [
      //     SliverAppBar(
      //       expandedHeight: 150, // kToolbarHeight 다음부터의 height을 말함.
      //       backgroundColor: sliverAppBarColor, // 해당 상금 주식의 테마 색이 되어야함.
      //       pinned: true,
      //       elevation: 2, // appBar의 깊이.
      //       // elevation: 0, // appBar의 깊이.
      //       centerTitle: true,
      //       title: Text(
      //         '10,128,400원 - 요트 점수 Top 3',
      //         style: TextStyle(
      //           fontFamily: 'AppleSDL',
      //           fontSize: 18,
      //           letterSpacing: -2.0,
      //           // color: Colors.white,
      //         ),
      //         textAlign: TextAlign.start,
      //       ),
      //       // flexibleSpace: Container(
      //       //   height: 200,
      //       //   color: Colors.blue,
      //       // ),

      //       // flexibleSpace: SafeArea(
      //       //   child: Stack(
      //       //     children: [
      //       //       /*Positioned(
      //       //     top: _calculatePositioned(),
      //       //     child: Container(
      //       //       height: 287.0,
      //       //       width: 300,
      //       //       color: Colors.red,
      //       //     ),
      //       //   ),*/
      //       //       Positioned(
      //       //         top: paddingForRewardText + kToolbarHeight,
      //       //         child: Container(
      //       //           // width: deviceWidth,
      //       //           alignment: Alignment.center,
      //       //           child: Column(
      //       //             children: [
      //       //               Text(
      //       //                 '10,128,400원',
      //       //                 style: TextStyle(
      //       //                     color: Colors.white,
      //       //                     fontSize: 40,
      //       //                     fontFamily: 'AppleSDB'),
      //       //               ),
      //       //               SizedBox(
      //       //                 height: 24.0,
      //       //               ),
      //       //               Container(
      //       //                 height: 50,
      //       //                 // width: deviceWidth,
      //       //                 color: sliverAppBarColor,
      //       //               ),
      //       //               Container(
      //       //                 height: heightForSliverFlexibleSpace -
      //       //                     kToolbarHeight, // 안전하게 이정도. 밑에 영역 크기를 정확히 계산할 수 없으므로 걍 넘겨버린다.
      //       //                 // width: deviceWidth,
      //       //                 color: backgroundColor,
      //       //               ),
      //       //             ],
      //       //           ),
      //       //         ),
      //       //       ),
      //       //       Positioned(
      //       //         top: paddingForRewardText + kToolbarHeight,
      //       //         child: Container(
      //       //           // width: deviceWidth,
      //       //           alignment: Alignment.center,
      //       //           child: Column(
      //       //             children: [
      //       //               Text(
      //       //                 '0,000,000원',
      //       //                 style: TextStyle(
      //       //                     color: Colors.transparent,
      //       //                     fontSize: 40,
      //       //                     fontFamily: 'AppleSDB'),
      //       //               ),
      //       //               SizedBox(
      //       //                 height: 24.0,
      //       //               ),
      //       //               // Container(
      //       //               //   height: 25,
      //       //               //   width: deviceWidth,
      //       //               // ),
      //       //               Row(children: [
      //       //                 SizedBox(
      //       //                   width: 16.0,
      //       //                 ),
      //       //                 Column(
      //       //                   children: [
      //       //                     Container(
      //       //                       height: 25,
      //       //                     ),
      //       //                     Container(
      //       //                       height: 50,
      //       //                       width: 50,
      //       //                       // color: Colors.black,
      //       //                       child: SvgPicture.asset(
      //       //                         'assets/icons/bottom_chat.svg',
      //       //                         width: 50,
      //       //                         height: 50,
      //       //                       ),
      //       //                     ),
      //       //                   ],
      //       //                 ),
      //       //                 Spacer(),
      //       //                 Container(
      //       //                   height: 80,
      //       //                   width: 80,
      //       //                   child: SvgPicture.asset(
      //       //                     'assets/icons/bottom_chat.svg',
      //       //                     width: 80,
      //       //                     height: 80,
      //       //                   ),
      //       //                 ),
      //       //                 Spacer(),
      //       //                 Column(
      //       //                   children: [
      //       //                     Container(
      //       //                       height: 25,
      //       //                     ),
      //       //                     Container(
      //       //                       height: 50,
      //       //                       width: 50,
      //       //                       // color: Colors.black,
      //       //                       child: SvgPicture.asset(
      //       //                         'assets/icons/bottom_chat.svg',
      //       //                         width: 50,
      //       //                         height: 50,
      //       //                       ),
      //       //                     ),
      //       //                   ],
      //       //                 ),
      //       //                 SizedBox(
      //       //                   width: 16.0,
      //       //                 ),
      //       //               ]),
      //       //               SizedBox(
      //       //                 height: 24.0,
      //       //               ),
      //       //               Container(
      //       //                 height: 9.0,
      //       //                 width: 9.0 * 4 + 14.0 * 3,
      //       //                 child: Stack(children: [
      //       //                   Positioned(
      //       //                     top: 0.0,
      //       //                     left: 0.0,
      //       //                     child: Container(
      //       //                       decoration: BoxDecoration(
      //       //                         shape: BoxShape.circle,
      //       //                         color: Color(0xFFC4C4C4),
      //       //                       ),
      //       //                       height: 9.0,
      //       //                       width: 9.0,
      //       //                     ),
      //       //                   ),
      //       //                   Positioned(
      //       //                     top: 0.0,
      //       //                     left: 9.0 * 1 + 14.0 * 1,
      //       //                     child: Container(
      //       //                       decoration: BoxDecoration(
      //       //                         shape: BoxShape.circle,
      //       //                         color: Colors.black,
      //       //                         // color: Color(0xFFC4C4C4),
      //       //                       ),
      //       //                       height: 9.0,
      //       //                       width: 9.0,
      //       //                     ),
      //       //                   ),
      //       //                   Positioned(
      //       //                     top: 0.0,
      //       //                     left: 9.0 * 2 + 14.0 * 2,
      //       //                     child: Container(
      //       //                       decoration: BoxDecoration(
      //       //                         shape: BoxShape.circle,
      //       //                         color: Colors.black,
      //       //                         // color: Color(0xFFC4C4C4),
      //       //                       ),
      //       //                       height: 9.0,
      //       //                       width: 9.0,
      //       //                     ),
      //       //                   ),
      //       //                   Positioned(
      //       //                     top: 0.0,
      //       //                     left: 9.0 * 3 + 14.0 * 3,
      //       //                     child: Container(
      //       //                       decoration: BoxDecoration(
      //       //                         shape: BoxShape.circle,
      //       //                         color: Color(0xFFC4C4C4),
      //       //                       ),
      //       //                       height: 9.0,
      //       //                       width: 9.0,
      //       //                     ),
      //       //                   ),
      //       //                   Positioned(
      //       //                     top: 0.0,
      //       //                     left: 9.0 * 1 + 14.0 * 1 + 4.5,
      //       //                     child: Container(
      //       //                       height: 9.0,
      //       //                       width: 23.0,
      //       //                       color: Colors.black,
      //       //                     ),
      //       //                   ),
      //       //                 ]),
      //       //               ),
      //       //             ],
      //       //           ),
      //       //         ),
      //       //       ),
      //       //       // 앱바를 가리지 않기 위해 덮어씌워주는.
      //       //       Positioned(
      //       //           top: 0.0,
      //       //           child: Opacity(
      //       //             opacity: 1.0,
      //       //             child: Container(
      //       //               height: kToolbarHeight,
      //       //               // width: deviceWidth,
      //       //               color: sliverAppBarColor,
      //       //             ),
      //       //           )),
      //       //       // Positioned(
      //       //       //     top: kToolbarHeight,
      //       //       //     child: Opacity(
      //       //       //         opacity: _calculateOpacity(),
      //       //       //         child: Container(
      //       //       //           height: 1,
      //       //       //           width: deviceWidth,
      //       //       //           color: Colors.black,
      //       //       //         ))),
      //       //       // Positioned(
      //       //       //   top: kToolbarHeight + _calculatePositioned(),
      //       //       //   child: Container(
      //       //       //     height: 32.0,
      //       //       //     width: 100,
      //       //       //     color: Colors.black,
      //       //       //   ),
      //       //       // )
      //       //     ],
      //       //   ),
      //       // ),
      //     ),
      //     // SliverAppBar(),
      //     SliverToBoxAdapter(
      //       child: Container(height: 1000, child: StockInfoKRView()),
      //     )
      //     // Container(
      //     //   height: 100,
      //     //   color: Colors.blueGrey.shade50,
      //     // ),
      //     // Container(height: 600, child: StockInfoKRView()),
      //   ],
      // ),
    );
  }
}

class _GlassmorphismAppBarDelegate extends SliverPersistentHeaderDelegate {
  final EdgeInsets safeAreaPadding;

  _GlassmorphismAppBarDelegate(this.safeAreaPadding);

  @override
  double get minExtent => 60.h + ScreenUtil().statusBarHeight;

  @override
  double get maxExtent => minExtent + kToolbarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Opacity(
          opacity: 0.8,
          child: Container(
            // Don't wrap this in any SafeArea widgets, use padding instead
            // padding: EdgeInsets.only(top: safeAreaPadding.top),
            height: maxExtent,
            color: primaryBackgroundColor,
            child: Padding(
              padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
              child: Center(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "장한나",
                      style: homeHeaderName,
                    ),
                  ),
                  Container(
                    // color: Colors.blue,
                    child: Text(" 님의 요트", style: homeHeaderAfterName),
                  ),
                ],
              )),
            ),
            // Use Stack and Positioned to create the toolbar slide up effect when scrolled up
            // child: Stack(
            //   clipBehavior: Clip.none,
            //   children: <Widget>[
            //     Positioned(
            //       bottom: 0,
            //       left: 0,
            //       right: 0,
            //       child: AppBar(
            //         primary: true,
            //         elevation: 0,
            //         backgroundColor: Colors.transparent,
            //         title: Text("Translucent App Bar"),
            //       ),
            //     )
            // ],
            // ),
          )),
    ));
  }

  @override
  bool shouldRebuild(_GlassmorphismAppBarDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return maxExtent != oldDelegate.maxExtent ||
        minExtent != oldDelegate.minExtent ||
        safeAreaPadding != oldDelegate.safeAreaPadding;
  }
}

class SectionHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SectionHeaderDelegate(this.child, [this.height = 50]);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: primaryBackgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
