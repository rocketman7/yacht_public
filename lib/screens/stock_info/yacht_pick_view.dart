import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/stock_info_new_model.dart';
import 'package:yachtOne/screens/quest/live/new_live_controller.dart';
import 'package:yachtOne/screens/stock_info/stock_info_new_controller.dart';
import 'package:yachtOne/screens/stock_info/stock_info_new_view.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_font.dart';

import '../../../locator.dart';
import '../../../services/firestore_service.dart';
import '../../handlers/date_time_handler.dart';
import '../../services/mixpanel_service.dart';

final yachtPickMainTextStyle = TextStyle(
  fontSize: 24.w,
  fontWeight: FontWeight.w500,
  fontFamily: 'AppleSDGothicNeo',
  color: Colors.white,
  letterSpacing: 0.0,
  height: 1.0,
);

class TempMainController extends GetxController {
  List<StockInfoNewModel> stockInfoNewModels = [];

  FirestoreService _firestoreService = locator<FirestoreService>();

  bool isModelLoaded = false;
  RxList<RxNum> todayCurrentPrices = <RxNum>[].obs;
  RxList<num> yesterdayClosePrices = <num>[].obs;
  @override
  void onInit() async {
    // stockInfoNewModels = await _firestoreService.getAllYachtPicks();
    stockInfoNewModels = await _firestoreService.getYachtPicks();
    todayCurrentPrices = List.generate(stockInfoNewModels.length, (index) => RxNum(0)).obs;
    yesterdayClosePrices = List.generate(stockInfoNewModels.length, (index) => 0).obs;

    isModelLoaded = true;

    print('stockInfoNewModels: ${stockInfoNewModels[0].toString()}');
    getLivePrice();
    print(stockInfoNewModels[0].name);
    print(stockInfoNewModels[0].yachtView);

    update();

    super.onInit();
  }

  getLivePrice() async {
    print('length: ${stockInfoNewModels.length}');
    for (int i = 0; i < stockInfoNewModels.length; i++) {
      yesterdayClosePrices[i] = await _firestoreService.getClosePrice(
        stockInfoNewModels[i].code,
        previousBusinessDay(
          DateTime.now(),
        ),
      );

      todayCurrentPrices[i].bindStream(
        _firestoreService.streamOneStockPrice(
          stockInfoNewModels[i].code,
        ),
      );
    }
    todayCurrentPrices.refresh();

    print('yesterdayClosePrices: $yesterdayClosePrices');
    print('todayCurrentPrices: $todayCurrentPrices');
  }

  Future<String> getTobeContinueDescription() async {
    return await _firestoreService.getTobeContinueDescription();
  }
}

class YachtPickView extends StatelessWidget {
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final double cardWholeHeight = 350.w; // card widget 을 수정해주는 경우에는 왼쪽 수치들도 수정해야함.
  final double cardWholeWidth = 210.w;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.w,
        ),
        GetBuilder<TempMainController>(
            init: TempMainController(),
            builder: (controller) {
              return controller.isModelLoaded
                  ? controller.stockInfoNewModels.length != 0
                      ? Container(
                          // color: Colors.red,
                          child: CarouselSlider.builder(
                              itemCount: controller.stockInfoNewModels.length,
                              itemBuilder: (context, index, _) {
                                return YachtPickCardForCarousel(
                                  cardWholeHeight: cardWholeHeight,
                                  cardWholeWidth: cardWholeWidth,
                                  stockInfoNewModel: controller.stockInfoNewModels[index],
                                  index: index,
                                  length: controller.stockInfoNewModels.length,
                                );
                              },
                              options: CarouselOptions(
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                enlargeCenterPage: true,
                                disableCenter: controller.stockInfoNewModels.length != 1 ? true : false,
                                aspectRatio:
                                    ScreenUtil().screenWidth / cardWholeHeight, // 스크린 width를 캐로셀 개별위젯의 높이로 나눠주면 됨
                                viewportFraction: (cardWholeWidth + 10.w) /
                                    ScreenUtil().screenWidth *
                                    1.1, // 캐로셀 개별위젯의 너비를 스크린 width로 나눠주고 원하는 비율을 곱해주면 됨. 단, enlargeCneterPage true와 함께 쓸 때는 내가 생각했던 비율보다 좀 작게 해줘야함
                              )),
                        )
                      : Container(
                          height: cardWholeHeight,
                        )
                  : Container(
                      height: cardWholeHeight,
                      // child: Center(child: YachtWebLoadingAnimation()),
                    );
            })
      ],
    );
  }
}

class YachtPickCardForCarousel extends StatelessWidget {
  final double cardWholeHeight;
  final double cardWholeWidth;
  final StockInfoNewModel stockInfoNewModel;
  final int index;
  final int length;

  YachtPickCardForCarousel({
    required this.cardWholeHeight,
    required this.cardWholeWidth,
    required this.stockInfoNewModel,
    required this.index,
    required this.length,
  });
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    TempMainController tempMainController = Get.put(TempMainController());
    return Container(
      height: cardWholeHeight,
      width: cardWholeWidth + 10.w,
      // color: index % 2 == 0 ? Colors.amber : Colors.greenAccent,
      child: Center(
          child: Column(children: [
        SizedBox(
          height: 15.w,
        ),
        GestureDetector(
          onTap: () {
            if (stockInfoNewModel.isTobeContinue) {
              _mixpanelService.mixpanel
                  .track('Yacht Pick Not Open Yet', properties: {'Stock Name': stockInfoNewModel.name});
              HapticFeedback.lightImpact();
              showDialog(
                  context: context,
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Dialog(
                        backgroundColor: yachtDarkGrey,
                        child: Padding(
                          padding: primaryAllPadding,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "공개 예정 요트 Pick",
                                style: dialogTitle,
                              ),
                              SizedBox(
                                height: 12.w,
                              ),
                              FutureBuilder<String>(
                                  future: tempMainController.getTobeContinueDescription(),
                                  builder: (_, snapshot) {
                                    return snapshot.hasData
                                        ? Text(
                                            '${snapshot.data!}'.replaceAll('\\n', '\n'),
                                            style: TextStyle(
                                                color: white, fontSize: 16.w, fontWeight: FontWeight.w400, height: 1.4),
                                          )
                                        : Text("");
                                  })
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              _mixpanelService.mixpanel.track('Yacht Pick Detail', properties: {'Stock Name': stockInfoNewModel.name});
              Get.to(() => StockInfoNewView(
                    stockInfoNewModel: stockInfoNewModel,
                  ));
            }
          },
          child: Container(
            // color: Colors.grey.withOpacity(0.5),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: cardWholeWidth + 10.w,
                      width: cardWholeWidth + 10.w,
                      // color: yachtRed,
                      child: Center(
                          child: Container(
                        height: cardWholeWidth,
                        width: cardWholeWidth,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: CachedNetworkImage(
                            imageUrl:
                                'https://storage.googleapis.com/ggook-5fb08.appspot.com/' + stockInfoNewModel.logoUrl),
                      )),
                    ),
                    SizedBox(
                      height: 5.w,
                    ),
                    Text(
                      stockInfoNewModel.name,
                      style: TextStyle(
                          fontFamily: krFont, fontSize: 24.w, letterSpacing: 0.0, height: 1.0, color: Colors.white),
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Obx(
                      () => Text(
                        toPriceKRW(tempMainController.todayCurrentPrices[index].value),
                        style: TextStyle(
                            fontFamily: krFont,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.w,
                            letterSpacing: 0.0,
                            height: 1.0,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 2.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Text(
                            toPriceKRW(tempMainController.todayCurrentPrices[index].value -
                                tempMainController.yesterdayClosePrices[index]),
                            style: stockPriceTextStyle.copyWith(
                                fontSize: 14.w,
                                height: 1.0,
                                color: tempMainController.todayCurrentPrices[index].value -
                                            tempMainController.yesterdayClosePrices[index] >
                                        0
                                    ? yachtRed
                                    : tempMainController.todayCurrentPrices[index].value ==
                                            tempMainController.yesterdayClosePrices[index]
                                        ? white
                                        : yachtBlue),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Obx(
                          () => Text(
                            tempMainController.yesterdayClosePrices[index] == 0
                                ? '(0.00%)'
                                : '(${toPercentageChange((tempMainController.todayCurrentPrices[index].value / tempMainController.yesterdayClosePrices[index]) - 1)})',
                            style: stockPriceTextStyle.copyWith(
                                fontSize: 14.w,
                                height: 1.0,
                                color: tempMainController.todayCurrentPrices[index].value -
                                            tempMainController.yesterdayClosePrices[index] >
                                        0
                                    ? yachtRed
                                    : tempMainController.todayCurrentPrices[index].value ==
                                            tempMainController.yesterdayClosePrices[index]
                                        ? white
                                        : yachtBlue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        color: yachtDarkGrey,
                      ),
                      height: 30.w,
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      // width: 40.w,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "요트 View",
                            style: bodyP2Style,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          SvgPicture.asset(
                            'assets/icons/${stockInfoNewModel.yachtView.last.view}.svg',
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                stockInfoNewModel.isTobeContinue
                    ? Positioned(
                        left: 0.w,
                        child: Container(
                          height: cardWholeHeight - 15.w,
                          width: cardWholeWidth + 32.w,
                          color: yachtBlack.withOpacity(0.85),
                        ),
                      )
                    : Container(),
                stockInfoNewModel.isTobeContinue
                    ? Positioned(
                        width: cardWholeWidth,
                        height: cardWholeWidth,
                        top: 20.w -
                            textSizeGet(
                                        '공개 예정',
                                        TextStyle(
                                            fontFamily: krFont,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 24.w,
                                            letterSpacing: 0.0,
                                            height: 1.0,
                                            color: Colors.white))
                                    .height /
                                2,
                        left: length == 1 ? 5.w : 15.w,
                        child: Center(
                          child: Text(
                            '공개 예정',
                            style: TextStyle(
                                fontFamily: krFont,
                                fontWeight: FontWeight.w700,
                                fontSize: 24.w,
                                letterSpacing: 0.0,
                                height: 1.0,
                                color: Colors.white),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ])),
    );
  }
}

class YachtWebLoadingAnimation extends StatefulWidget {
  const YachtWebLoadingAnimation({Key? key}) : super(key: key);

  @override
  State<YachtWebLoadingAnimation> createState() => _YachtWebLoadingAnimationState();
}

class _YachtWebLoadingAnimationState extends State<YachtWebLoadingAnimation> with TickerProviderStateMixin {
  List<AnimationController>? _animationControllers;
  List<Animation<double>> _animations = [];
  int animationDuration = 300;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers!) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initAnimation() {
    _animationControllers = List.generate(
      3,
      (index) {
        return AnimationController(vsync: this, duration: Duration(milliseconds: animationDuration));
      },
    ).toList();

    for (int i = 0; i < 3; i++) {
      _animations.add(Tween<double>(begin: 10.w, end: -10.w).animate(_animationControllers![i]));
    }

    for (int i = 0; i < 3; i++) {
      _animationControllers![i].addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationControllers![i].reverse();

          if (i != 3 - 1) {
            _animationControllers![i + 1].forward();
          }
        }

        if (i == 3 - 1 && status == AnimationStatus.dismissed) {
          _animationControllers![0].forward();
        }
      });
    }

    _animationControllers!.first.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey,
      height: 30.w,
      width: ScreenUtil().screenWidth,
      child: Center(
          child: Container(
        width: 70.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _animationControllers![index],
              builder: (context, child) {
                return Container(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0.w : 20.w,
                  ),
                  child: Transform.translate(
                    offset: Offset(0, _animations[index].value),
                    child: Container(
                        height: 10.w,
                        width: 10.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _animationControllers![index].status == AnimationStatus.forward
                                ? Color(0xFFB8BABC)
                                : Color(0xFF545758))),
                  ),
                );
              },
            );
          }).toList(),
        ),
      )),
    );
  }
}
