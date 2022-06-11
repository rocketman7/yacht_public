import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:yachtOne/screens/stock_info/stock_info_new_controller.dart';
import 'package:yachtOne/screens/stock_info/stock_info_new_view.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../../locator.dart';
import '../../../services/firestore_service.dart';

final yachtPickMainTextStyle = TextStyle(
  fontSize: 24.w,
  fontWeight: FontWeight.w500,
  fontFamily: 'AppleSDGothicNeo',
  color: Colors.white,
  letterSpacing: 0.0,
  height: 1.0,
);

class TempMainController extends GetxController {
  List<StockInfoNewModel>? stockInfoNewModels;

  FirestoreService _firestoreService = locator<FirestoreService>();

  bool isModelLoaded = false;

  @override
  void onInit() async {
    stockInfoNewModels = await _firestoreService.getYachtPicks();

    isModelLoaded = true;

    update();

    super.onInit();
  }
}

class TempMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TempMainController tempMainController = Get.put(TempMainController());

    return Column(
      children: [
        GetBuilder<TempMainController>(builder: (controller) {
          return controller.isModelLoaded
              ? controller.stockInfoNewModels!.length != 0
                  ? CarouselSlider.builder(
                      itemCount: controller.stockInfoNewModels!.length,
                      itemBuilder: (context, index, _) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => StockInfoNewView(
                                  stockInfoNewModel: controller.stockInfoNewModels![index],
                                ));
                          },
                          child: Container(
                            // height: 210.w + 20.w + textSizeGet('갈낡퉽', yachtPickMainTextStyle).height,
                            child: Column(
                              children: [
                                Container(
                                  height: 210.w,
                                  width: 210.w,
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                  clipBehavior: Clip.hardEdge,
                                  child: CachedNetworkImage(
                                      imageUrl: 'https://storage.googleapis.com/ggook-5fb08.appspot.com/' +
                                          controller.stockInfoNewModels![index].logoUrl),
                                ),
                                SizedBox(
                                  height: 20.w,
                                ),
                                Text(
                                  controller.stockInfoNewModels![index].name,
                                  style: yachtPickMainTextStyle,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                          initialPage: 0,
                          aspectRatio: ScreenUtil().screenWidth /
                              (210.w + 20.w + textSizeGet('갈낡퉽', yachtPickMainTextStyle).height),
                          disableCenter: true,
                          enableInfiniteScroll: false,
                          viewportFraction: (210.w + (20.w + textSizeGet('갈낡퉽', yachtPickMainTextStyle).height) / 2) /
                              ScreenUtil().screenWidth,
                          enlargeCenterPage: true))
                  : Container() // 현재 요트픽이 없을 때 보여질.
              : CarouselSlider.builder(
                  itemCount: 3,
                  itemBuilder: (context, index, _) {
                    return Container(
                      height: 210.w + 20.w + textSizeGet('갈낡퉽', yachtPickMainTextStyle).height,
                      child: Column(
                        children: [
                          Container(
                            height: 210.w,
                            width: 210.w,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black87),
                            clipBehavior: Clip.hardEdge,
                          ),
                          SizedBox(
                            height: 20.w,
                          ),
                          Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w), color: Colors.black87),
                            child: Text(
                              '                  ',
                              style: yachtPickMainTextStyle,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  options: CarouselOptions(
                      initialPage: 0,
                      aspectRatio:
                          ScreenUtil().screenWidth / (210.w + 20.w + textSizeGet('갈낡퉽', yachtPickMainTextStyle).height),
                      disableCenter: true,
                      enableInfiniteScroll: false,
                      viewportFraction: (210.w + (20.w + textSizeGet('갈낡퉽', yachtPickMainTextStyle).height) / 2) /
                          ScreenUtil().screenWidth,
                      enlargeCenterPage: true));
        }),
        // SizedBox(
        //   height: 60.w,
        // ),
        // YachtWebLoadingAnimation(),
      ],
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
