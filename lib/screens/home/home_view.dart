import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/reading_content_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/auth/auth_check_view.dart';
import 'package:yachtOne/screens/auth/kakao_firebase_auth_api.dart';
import 'package:yachtOne/screens/auth/login_view.dart';
import 'package:yachtOne/screens/award/award_view.dart';
import 'package:yachtOne/screens/contents/dictionary/dictionary_view.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_view.dart';
import 'package:yachtOne/screens/contents/today_market/today_market_view.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/notification/notification_view.dart';
import 'package:yachtOne/screens/notification/notification_view_model.dart';
import 'package:yachtOne/screens/quest/live/live_quest_view.dart';
import 'package:yachtOne/screens/profile/asset_view.dart';
import 'package:yachtOne/screens/profile/asset_view_model.dart';
import 'package:yachtOne/screens/quest/result/quest_results_view.dart';
import 'package:yachtOne/screens/ranks/rank_share_view.dart';
import 'package:yachtOne/screens/settings/push_notification_view_model.dart';
import 'package:yachtOne/screens/subLeague/temp_home_view.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import '../../locator.dart';

import '../quest/quest_widget.dart';

class HomeView extends StatelessWidget {
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  NotificationViewModel notificationViewModel =
      Get.put(NotificationViewModel());

  final MixpanelService _mixpanelService = locator<MixpanelService>();
  ScrollController _scrollController = ScrollController();
  RxDouble offset = 0.0.obs;

  final GlobalKey<FormState> userNameFormKey = GlobalKey<FormState>();
  final TextEditingController userNameController =
      TextEditingController(text: "");
  final RxBool isCheckingUserNameDuplicated = false.obs;
  final RxBool showSmallSnackBar = false.obs;
  final RxString smallSnackBarText = "".obs;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1200));
    todayQuests = null;
    await homeViewModel.getAllQuests();

    // 이런느낌으로 ? 근데 굳이 알림까지 새로고침할 필욘 없을듯해서 일단 주석처리
    // notificationViewModel.dispose();
    // notificationViewModel =
    //   Get.put(NotificationViewModel());

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
    //   print('triggered' + homeViewModel.noNeedShowUserNameDialog.value.toString());
    //   if (!homeViewModel.noNeedShowUserNameDialog.value) {
    //     print('triggered');
    //     await showChangeNameDialog(context);
    //   }
    // });

    List<Widget> homeWidgets = [
      DialogReadyWidget(homeViewModel: homeViewModel),
      MyAssets(),

      // 이달의 상금 주식
      AwardView(
          leagueName: leagueModel.value!.leagueName,
          leagueEndDateTime: leagueModel.value!.leagueEndDateTime),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      NewQuests(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      LiveQuestView(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      QuestResultsView(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      RankHomeWidget(),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      ReadingContentView(
          homeViewModel: homeViewModel), // showingHome 변수 구분해서 넣는 게
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      TodayMarketView(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(50.w, 0.0, sectionTitle.fontSize)),
      DictionaryView(homeViewModel: homeViewModel),
      SizedBox(height: correctHeight(90.w, 0.0, sectionTitle.fontSize)),

      // SliverToBoxAdapter(child: SizedBox(height: 100)),
      // OldLiveQuests(homeViewModel: homeViewModel),
      // SliverToBoxAdapter(child: Container(height: 200, color: Colors.grey)),
      // Admins(homeViewModel: homeViewModel),
    ];

    _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    _scrollController.addListener(() {
      // offset obs 값에 scroll controller offset 넣어주기
      _scrollController.offset < 0
          ? offset(0)
          : offset(_scrollController.offset);
      // print(_scrollController.offset);
    });

    // print(
    //     'screen width: ${ScreenUtil().screenWidth} / screen height: ${ScreenUtil().screenHeight} / ratio: ${(ScreenUtil().screenHeight / ScreenUtil().screenWidth)}');

    return Scaffold(
      body: RefreshConfiguration(
        enableScrollWhenRefreshCompleted: true,
        child: SmartRefresher(
          header: reloadHeader(true),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 앱바
              Obx(
                () => SliverPersistentHeader(
                    floating: false,
                    pinned: true,
                    // 홈 뷰 앱바 구현
                    delegate: _GlassmorphismAppBarDelegate(
                        MediaQuery.of(context).padding,
                        offset.value,
                        homeViewModel)),
              ),
              Obx(() => homeViewModel.isLoading.value
                      ? SliverToBoxAdapter()
                      : SliverList(
                          delegate: SliverChildListDelegate(
                            homeWidgets,
                            // addRepaintBoundaries: false,
                            // addAutomaticKeepAlives: true,
                          ),
                        )
                  // SliverList(
                  //     delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  //       return homeWidgets[index];
                  //     }, childCount: homeWidgets.length),
                  //   ),
                  ),

              // MyAssets(),
              // SliverToBoxAdapter(
              //     child: SizedBox(
              //         height: reducedPaddingWhenTextIsBelow(
              //             30.w, sectionTitle.fontSize!))),
              // // 이달의 상금 주식
              // Awards(),
              // SliverToBoxAdapter(child: btwHomeModule),
              // NewQuests(homeViewModel: homeViewModel),
              // SliverToBoxAdapter(child: btwHomeModule),
              // LiveQuests(),
              // SliverToBoxAdapter(child: SizedBox(height: 100)),
              // OldLiveQuests(homeViewModel: homeViewModel),
              // SliverToBoxAdapter(child: Container(height: 200, color: Colors.grey)),
              // Admins(homeViewModel: homeViewModel),
            ],
          ),
        ),
      ),
    );
  }

  showChangeNameDialog(BuildContext context) async {
    showDialog<Widget>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
            constraints: BoxConstraints.loose(
              Size(double.infinity, 180.w),
            ),
            padding: primaryHorizontalPadding,
            child: Form(
              key: userNameFormKey,
              child: Stack(
                children: [
                  Column(
                    children: [
                      appBarWithoutCloseButton(title: "닉네임 설정"),
                      SizedBox(height: 8.w),
                      TextFormField(
                        controller: userNameController,
                        textAlignVertical: TextAlignVertical.bottom,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(0.w),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: '${userModelRx.value!.userName}',
                          hintStyle: profileChangeContentTextStyle.copyWith(
                              color: yachtGrey),
                        ),
                        validator: (value) {
                          if (value != '') {
                            final nickValidator =
                                RegExp(r'^[a-zA-Zㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]+$');
                            if (value!.length > 8 ||
                                !nickValidator.hasMatch(value) ||
                                value.contains(' ')) {
                              return "! 닉네임은 8자 이하의 한글,영문,숫자 조합만 가능합니다.";
                            } else {
                              return null;
                            }
                          }
                        },
                        onChanged: (value) {
                          if (userNameFormKey.currentState!.validate()) {
                            print('good');
                          } else {
                            print('bad');
                          }
                        },
                      ),
                      SizedBox(height: 16.w),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            // Get.dialog(Dialog(
                            //   child: Text("TTT"),
                            // ));
                            // print('tap');
                            if (userNameController.text == '') {
                              showSmallSnackBar(true);
                              smallSnackBarText("닉네임을 입력해주세요");
                              Future.delayed(Duration(seconds: 1))
                                  .then((value) {
                                showSmallSnackBar(false);
                                smallSnackBarText("");
                              });
                              // Get.rawSnackbar(
                              //   messageText: Center(
                              //     child: Text(
                              //       "변경한 내용이 없어요.",
                              //       style: snackBarStyle,
                              //     ),
                              //   ),
                              //   backgroundColor: white.withOpacity(.5),
                              //   barBlur: 8,
                              //   duration: const Duration(seconds: 1, milliseconds: 100),
                              // );
                            } else if (userNameFormKey.currentState!
                                    .validate() &&
                                isCheckingUserNameDuplicated.value == false) {
                              if (userNameController.text != '') {
                                print(userNameController.text);
                                isCheckingUserNameDuplicated(true);
                                bool isUserNameDuplicatedVar = true;

                                isUserNameDuplicatedVar =
                                    await homeViewModel.isUserNameDuplicated(
                                        userNameController.text);
                                print(isUserNameDuplicatedVar);
                                if (!isUserNameDuplicatedVar) {
                                  await homeViewModel
                                      .updateUserName(userNameController.text);
                                  showSmallSnackBar(true);
                                  smallSnackBarText("닉네임이 저장되었어요");
                                  Future.delayed(Duration(seconds: 1))
                                      .then((value) {
                                    showSmallSnackBar(false);
                                    smallSnackBarText("");
                                    Navigator.of(context).pop();
                                  });

                                  // Get.rawSnackbar(
                                  //   messageText: Center(
                                  //     child: Text(
                                  //       "변경한 내용이 저장되었어요.",
                                  //       style: snackBarStyle,
                                  //     ),
                                  //   ),
                                  //   backgroundColor: white.withOpacity(.5),
                                  //   barBlur: 8,
                                  //   duration: const Duration(seconds: 1, milliseconds: 100),
                                  // );
                                } else {
                                  showSmallSnackBar(true);
                                  smallSnackBarText("중복된 닉네임이 있어요");
                                  Future.delayed(Duration(seconds: 1))
                                      .then((value) {
                                    showSmallSnackBar(false);
                                    smallSnackBarText("");
                                  });
                                  // userNameDuplicatedDialog();
                                }

                                isCheckingUserNameDuplicated(false);
                              }
                            }
                          },
                          child: Obx(() => Container(
                                height: 50.w,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70.0),
                                    color: isCheckingUserNameDuplicated.value ==
                                            false
                                        ? yachtViolet
                                        : primaryButtonText),
                                child: Center(
                                  child: Text(
                                    isCheckingUserNameDuplicated.value == false
                                        ? '저장하기'
                                        : '닉네임 중복 검사 중',
                                    style:
                                        profileChangeButtonTextStyle.copyWith(
                                            color: isCheckingUserNameDuplicated
                                                        .value ==
                                                    false
                                                ? primaryButtonText
                                                : primaryButtonBackground),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => showSmallSnackBar.value
                        ? Positioned(
                            top: 40.w,
                            child: Align(
                              alignment: Alignment(0, 0),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                constraints: BoxConstraints.loose(
                                  Size(double.infinity, 180.w),
                                ),
                                padding: EdgeInsets.all(12.w),
                                color: Colors.white.withOpacity(.8),
                                // height: 40.w,
                                // width: double.infinity,
                                child: Text(
                                  smallSnackBarText.value,
                                  style: TextStyle(
                                    fontSize: 16.w,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  )
                ],
              ),
            )),
      ),
      barrierDismissible: false,
    );
  }
}

class DialogReadyWidget extends StatefulWidget {
  final HomeViewModel homeViewModel;

  const DialogReadyWidget({Key? key, required this.homeViewModel})
      : super(key: key);
  @override
  State<DialogReadyWidget> createState() => _DialogReadyWidgetState();
}

class _DialogReadyWidgetState extends State<DialogReadyWidget> {
  final GlobalKey<FormState> userNameFormKey = GlobalKey<FormState>();
  final TextEditingController userNameController =
      TextEditingController(text: "");
  final RxBool isCheckingUserNameDuplicated = false.obs;
  final RxBool noNeedShowUserNameDialog = true.obs;
  final RxBool showSmallSnackBar = false.obs;
  final RxString smallSnackBarText = "".obs;

  final box = GetStorage();
  bool iosTermAgree = true;
  String iosTermSheet = "";

  @override
  void initState() {
    showChangeNameDialog(context);
    iosTermAgree = box.read('iosTermAgree') ?? false;
    if (Platform.isIOS && !iosTermAgree) {
      showTermDialog(context);
    }
    super.initState();
  }

  Future showTermDialog(BuildContext context) async {
    iosTermSheet =
        await rootBundle.loadString('assets/documents/termsOfUse.txt');
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "서비스를 이용하기 위해\n아래에 대한 동의가 필요합니다.";

        String btnLabel = "수락";
        String btnLabelCancel = "거부";

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: CupertinoAlertDialog(
                title: Text(title),
                content: Container(
                  height: 400,
                  width: 180,
                  child: SingleChildScrollView(
                      child: Text(
                    iosTermSheet,
                    textAlign: TextAlign.left,
                  )),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => exit(0),
                  ),
                  CupertinoDialogAction(
                    child: Text(btnLabel),
                    onPressed: () {
                      box.write('iosTermAgree', true);
                      Navigator.pop(context);
                    },
                  ),
                ],
              )),
        );
      },
    );
  }

  showChangeNameDialog(BuildContext context) async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (userModelRx.value!.isNameUpdated == null ||
          !userModelRx.value!.isNameUpdated!) {
        await showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(16.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Container(
                decoration: primaryBoxDecoration.copyWith(
                  color: white,
                ),
                // height: double.minPositive,

                padding: primaryAllPadding,
                child: Form(
                  key: userNameFormKey,
                  child: Container(
                    // height: double.minPositive,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            appBarWithoutCloseButton(title: "닉네임 설정하기"),
                            // SizedBox(height: 8.w),
                            Container(
                              child: Text("어떤 호칭으로 불러드릴까요?",
                                  style: TextStyle(
                                      fontSize: 18.w,
                                      letterSpacing: -1.0,
                                      height: 1.4,
                                      fontWeight: FontWeight.w600)),
                            ),
                            SizedBox(height: 14.w),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.w),
                                  boxShadow: [
                                    BoxShadow(
                                      color: yachtShadow,
                                      blurRadius: 8.w,
                                      spreadRadius: 1.w,
                                    )
                                  ]),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 12.w, top: 14.w, bottom: 11.w),
                                child: TextFormField(
                                  controller: userNameController,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(0.w),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    hintText: '${userModelRx.value!.userName}',
                                    hintStyle: profileChangeContentTextStyle
                                        .copyWith(color: yachtGrey),
                                  ),
                                  validator: (value) {
                                    if (value != '') {
                                      final nickValidator =
                                          RegExp(r'^[a-zA-Zㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]+$');
                                      if (value!.length > 8 ||
                                          !nickValidator.hasMatch(value) ||
                                          value.contains(' ')) {
                                        return "! 닉네임은 8자 이하의 한글,영문,숫자 조합만 가능합니다.";
                                      } else {
                                        return null;
                                      }
                                    }
                                  },
                                  onChanged: (value) {
                                    if (userNameFormKey.currentState!
                                        .validate()) {
                                      print('good');
                                    } else {
                                      print('bad');
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 16.w),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  // Get.dialog(Dialog(
                                  //   child: Text("TTT"),
                                  // ));
                                  // print('tap');
                                  if (userNameController.text == '') {
                                    showSmallSnackBar(true);
                                    smallSnackBarText("닉네임을 입력해주세요");
                                    Future.delayed(Duration(seconds: 1))
                                        .then((value) {
                                      showSmallSnackBar(false);
                                      smallSnackBarText("");
                                    });

                                    // Get.rawSnackbar(
                                    //   messageText: Center(
                                    //     child: Text(
                                    //       "변경한 내용이 없어요.",
                                    //       style: snackBarStyle,
                                    //     ),
                                    //   ),
                                    //   backgroundColor: white.withOpacity(.5),
                                    //   barBlur: 8,
                                    //   duration: const Duration(seconds: 1, milliseconds: 100),
                                    // );
                                  } else if (userNameFormKey.currentState!
                                          .validate() &&
                                      isCheckingUserNameDuplicated.value ==
                                          false) {
                                    if (userNameController.text != '') {
                                      print(userNameController.text);
                                      isCheckingUserNameDuplicated(true);
                                      bool isUserNameDuplicatedVar = true;

                                      isUserNameDuplicatedVar = await widget
                                          .homeViewModel
                                          .isUserNameDuplicated(
                                              userNameController.text);
                                      print(isUserNameDuplicatedVar);
                                      if (!isUserNameDuplicatedVar) {
                                        await widget.homeViewModel
                                            .updateUserName(
                                                userNameController.text);
                                        Navigator.of(context).pop();
                                        yachtSnackBar("닉네임이 저장되었어요");
                                        // showSmallSnackBar(true);
                                        // smallSnackBarText();
                                        // Future.delayed(Duration(seconds: 1)).then((value) {
                                        //   showSmallSnackBar(false);
                                        //   smallSnackBarText("");
                                        //   Navigator.of(context).pop();
                                        // });

                                        // Get.rawSnackbar(
                                        //   messageText: Center(
                                        //     child: Text(
                                        //       "변경한 내용이 저장되었어요.",
                                        //       style: snackBarStyle,
                                        //     ),
                                        //   ),
                                        //   backgroundColor: white.withOpacity(.5),
                                        //   barBlur: 8,
                                        //   duration: const Duration(seconds: 1, milliseconds: 100),
                                        // );
                                      } else {
                                        showSmallSnackBar(true);
                                        smallSnackBarText("중복된 닉네임이 있어요");
                                        Future.delayed(Duration(seconds: 1))
                                            .then((value) {
                                          showSmallSnackBar(false);
                                          smallSnackBarText("");
                                        });
                                        // userNameDuplicatedDialog();
                                      }

                                      isCheckingUserNameDuplicated(false);
                                    }
                                  }
                                },
                                child: Obx(() => Container(
                                      height: 50.w,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(70.0),
                                          color: isCheckingUserNameDuplicated
                                                      .value ==
                                                  false
                                              ? yachtViolet
                                              : primaryButtonText),
                                      child: Center(
                                        child: Text(
                                          isCheckingUserNameDuplicated.value ==
                                                  false
                                              ? '저장하기'
                                              : '닉네임 중복 검사 중',
                                          style: profileChangeButtonTextStyle
                                              .copyWith(
                                                  color: isCheckingUserNameDuplicated
                                                              .value ==
                                                          false
                                                      ? primaryButtonText
                                                      : primaryButtonBackground),
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Positioned.fill(
                            top: 48.w,
                            // left: 16.w,
                            child: Container(
                              height: 24.w,
                              child: Obx(
                                () => showSmallSnackBar.value
                                    ? AnimatedContainer(
                                        duration: Duration(milliseconds: 300),

                                        padding: EdgeInsets.all(12.w),
                                        color: Colors.white.withOpacity(.8),

                                        // width: double.infinity,
                                        child: Text(
                                          smallSnackBarText.value,
                                          style: TextStyle(
                                              fontSize: 16.w,
                                              fontWeight: FontWeight.w600,
                                              color: showSmallSnackBar.value
                                                  ? yachtBlack
                                                  : Colors.transparent),
                                        ),
                                      )
                                    : Container(),
                              ),
                            ))
                      ],
                    ),
                  ),
                )),
          ),
          barrierDismissible: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NewQuests extends StatelessWidget {
  final HomeViewModel homeViewModel;
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  NewQuests({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: primaryHorizontalPadding,
          // color: Colors.red,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  // color: Colors.blue,
                  child: Text("새로 나온 퀘스트",
                      style: sectionTitle.copyWith(height: 1.0))),
              Spacer(),
              GestureDetector(
                onTap: () {
                  _mixpanelService.mixpanel
                      .track('home-NewQuest-adsViewDialog');
                  if (userModelRx.value!.rewardedCnt! < maxRewardedAds) {
                    adsViewDialog(context);
                  } else {
                    maxRewardedAdsDialog(context);
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.w),
                      decoration: jogabiButtonBoxDecoration
                          .copyWith(boxShadow: [primaryBoxShadow]),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/jogabi.svg',
                            height: 18.w,
                            width: 18.w,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          Obx(() {
                            // print("item changed");
                            return Text(
                              userModelRx.value == null
                                  ? 0.toString()
                                  : userModelRx.value!.item.toString(),
                              style: questTermTextStyle.copyWith(
                                  color: Color(0xFF4D6A87),
                                  fontWeight: FontWeight.w600),
                            );
                          })
                        ],
                      ),
                    ),
                    Positioned(
                      right: -10.w,
                      top: -10.w,
                      child: Container(
                        padding: EdgeInsets.all(3.5.w),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        height: 20.w,
                        width: 20.w,
                        child: SvgPicture.asset(
                          'assets/buttons/add.svg',
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 10.w,
              )
            ],
          ),
        ),
        SizedBox(
          height: heightSectionTitleAndBox,
        ),
        // btwHomeModuleTitleSlider,
        Obx(() {
          return (homeViewModel.newQuests.length ==
                  0) // 로딩 중과 length 0인 걸 구분해야 함
              ? Container(
                  width: 232.w,
                  height: 344.w,
                  child: Image.asset('assets/illusts/not_exists/no_quest.png'),
                  // height: 340.w,
                )
              : SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: List.generate(
                          homeViewModel.newQuests.length,
                          (index) => Row(
                                children: [
                                  index == 0
                                      ? SizedBox(
                                          width: kHorizontalPadding.left,
                                        )
                                      : Container(),
                                  InkWell(
                                    onTap: () {
                                      _mixpanelService.mixpanel.track(
                                          'home-NewQuest-QuestView',
                                          properties: {
                                            'questId': homeViewModel
                                                .newQuests[index].questId,
                                            'questCategory': homeViewModel
                                                .newQuests[index].category
                                          });
                                      homeViewModel.newQuests[index]
                                                  .selectMode ==
                                              'survey'
                                          ? Get.toNamed('/survey',
                                              arguments: homeViewModel
                                                  .newQuests[index])
                                          : homeViewModel.newQuests[index]
                                                      .selectMode ==
                                                  'tutorial'
                                              ? Get.toNamed('/tutorial',
                                                  arguments: homeViewModel
                                                      .newQuests[index])
                                              : Get.toNamed('/quest',
                                                  arguments: homeViewModel
                                                      .newQuests[index]);
                                    },
                                    child: QuestWidget(
                                        questModel:
                                            homeViewModel.newQuests[index]),
                                  ),
                                  SizedBox(width: primaryPaddingSize),
                                ],
                              ))));
        })
      ],
    );
  }
}

class MyAssets extends StatelessWidget {
  final AssetViewModel _assetViewModel = Get.find<AssetViewModel>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  // final AssetViewModel _assetViewModel = Get.put(AssetViewModel());

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: offset.w > 100.w ? 0 : 100.w - offset.w,
      height: 100.w,
      child: GestureDetector(
        onTap: () {
          _mixpanelService.mixpanel.track('home-Asset');
          Get.to(() => AssetView());
        },
        child: Row(
          children: [
            Expanded(
              child: Container(
                // color: Colors.blue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/won_circle.png',
                          width: 20.w,
                          height: 20.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "주식 잔고",
                          style: myAssetTitle,
                        ),
                      ],
                    ),
                    SizedBox(
                        height: reducedPaddingWhenTextIsBelow(
                            14.w, detailedContentTextStyle.fontSize!)),
                    GetBuilder<AssetViewModel>(
                        id: 'holdingStocks',
                        builder: (controller) {
                          return RichText(
                              text: TextSpan(
                                  text: controller.isHoldingStocksFutureLoad
                                      ? "${toPriceKRW(_assetViewModel.totalHoldingStocksValue)}"
                                      : "0",
                                  style: myAssetAmount,
                                  children: [
                                TextSpan(
                                    text: " 원",
                                    style: myAssetAmount.copyWith(
                                        fontWeight: FontWeight.w300))
                              ]));
                        }),
                  ],
                ),
              ),
            ),
            VerticalDivider(
              color: primaryFontColor.withOpacity(.5),
              indent: 16.w,
              endIndent: 16.w,
            ),
            Expanded(
                child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/yacht_point_circle.png',
                        width: 20.w,
                        height: 20.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "요트 포인트",
                        style: myAssetTitle,
                      ),
                    ],
                  ),
                  SizedBox(
                      height: reducedPaddingWhenTextIsBelow(
                          14.w, detailedContentTextStyle.fontSize!)),
                  GetBuilder<AssetViewModel>(
                      id: 'holdingStocks',
                      builder: (controller) {
                        return RichText(
                            text: TextSpan(
                                text: controller.isHoldingStocksFutureLoad
                                    ? "${toPriceKRW(_assetViewModel.totalYachtPoint)}"
                                    : "0",
                                style: myAssetAmount,
                                children: [
                              TextSpan(
                                  text: " 원",
                                  style: myAssetAmount.copyWith(
                                      fontWeight: FontWeight.w300))
                            ]));
                      }),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class _GlassmorphismAppBarDelegate extends SliverPersistentHeaderDelegate {
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final EdgeInsets safeAreaPadding;
  final double offset;
  final HomeViewModel homeViewModel;

  _GlassmorphismAppBarDelegate(
      this.safeAreaPadding, this.offset, this.homeViewModel);

  @override
  double get minExtent => 60.h + ScreenUtil().statusBarHeight;

  @override
  double get maxExtent => minExtent + kToolbarHeight - 40.h;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ClipRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        // Don't wrap this in any SafeArea widgets, use padding instead
        // padding: EdgeInsets.only(top: safeAreaPadding.top),
        height: maxExtent,
        color: primaryBackgroundColor.withOpacity(.65),
        child: Padding(
          padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
          child: Center(
              child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              Center(
                child: Row(
                  children: [
                    Obx(
                      () => Text(
                        userModelRx.value == null
                            ? ""
                            : userModelRx.value!.userName,
                        style: appBarTitle.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      " 님의 요트",
                      style: appBarTitle,
                    ),
                  ],
                ),
              ),
              // Spacer(),
              Flexible(
                flex: 1,
                child: InkWell(
                  onTap: () async {
                    _mixpanelService.mixpanel.track('home-notification');
                    if (userModelRx.value!.lastNotificationCheckDateTime ==
                        null) {
                      Get.to(() => NotificationView(), arguments: 'NeedLoad');
                    } else {
                      if (Get.find<NotificationViewModel>()
                              .lastNotificationTimeForNavigate()
                              .compareTo(userModelRx
                                  .value!.lastNotificationCheckDateTime) >
                          0) {
                        Get.to(() => NotificationView(), arguments: 'NeedLoad');
                      } else {
                        Get.to(() => NotificationView());
                      }
                    }
                    // 여기서 트리거해주면 페이지전환 속도가 느려서.. 차라리 노티피케이션뷰를 스테이트풀 위젯으로 해주고 그 이닛스테이트에서 얘를 실행하자.
                    // Get.find<NotificationViewModel>()
                    //     .lastNotificationCheckTimeUpdate();
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            height: 26.w,
                            // width: 24.w,
                            child: GetBuilder<NotificationViewModel>(
                              id: 'notificationList',
                              builder: (controller) {
                                if (controller.isNotificationListLoaded) {
                                  return Obx(() {
                                    if (userModelRx.value!
                                            .lastNotificationCheckDateTime !=
                                        null) {
                                      if (controller
                                              .lastNotificationTime()
                                              .compareTo(userModelRx.value!
                                                  .lastNotificationCheckDateTime) >
                                          0) {
                                        return Image.asset(
                                            'assets/icons/notification_new.png');
                                      } else {
                                        return Image.asset(
                                            'assets/icons/notification.png');
                                      }
                                    } else {
                                      print('last모시기 null');
                                      return Image.asset(
                                          'assets/icons/notification_new.png');
                                    }
                                  });
                                } else {
                                  return Container();
                                }
                              },
                            )
                            // Image.asset('assets/icons/notification.png'),
                            ),
                        SizedBox(width: primaryPaddingSize)
                      ],
                    ),
                  ),
                ),
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
      ),
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

class Admins extends StatelessWidget {
  const Admins({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    print("admin view built");
    return Container(
      height: 850,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("Go To Stock Info"),
            onPressed: () {
              Get.toNamed('stockInfo');
            },
          ),
          ElevatedButton(
            child: Text("Go To Design System"),
            onPressed: () {
              Get.toNamed('designSystem');
            },
          ),
          ElevatedButton(
            child: Text("Go To Quest View"),
            onPressed: () {
              Get.toNamed('quest', arguments: homeViewModel.allQuests[0]);
            },
          ),
          ElevatedButton(
            child: Text("Count Test"),
            onPressed: () {
              FirestoreService().countTest(0);
            },
          ),
          ElevatedButton(
            child: Text("Go To Award View (Old)"),
            onPressed: () {
              Get.toNamed('awardold');
            },
          ),
          // HomeAwardCardWidget(),
          ElevatedButton(
            child: Text("Go To Temp Home for Sub League View"),
            onPressed: () {
              // Get.toNamed('tempHome');
              Get.to(() => TempHomeView(
                    leagueName: '7월',
                  ));
            },
          ),
        ],
      ),
    );
  }
}
