import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import 'package:flutter/material.dart' hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yachtOne/screens/webview/temp_web_view.dart';
import 'package:yachtOne/yacht_design_system/yds_button.dart';
import 'package:yachtOne/yacht_design_system/yds_dialog.dart';
import 'package:yachtOne/yacht_design_system/yds_font.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/auth/auth_check_view.dart';
import 'package:yachtOne/screens/auth/auth_check_view_model.dart';
import 'package:yachtOne/screens/auth/kakao_firebase_auth_api.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';
import 'package:yachtOne/screens/notification/notification_view.dart';
import 'package:yachtOne/screens/notification/notification_view_model.dart';
import 'package:yachtOne/screens/profile/asset_view.dart';
import 'package:yachtOne/screens/profile/asset_view_model.dart';
import 'package:yachtOne/screens/stock_info/stock_info_new_view.dart';
import 'package:yachtOne/screens/subLeague/temp_home_view.dart';
import 'package:yachtOne/screens/yacht_store/yacht_store_view.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yachtOne/styles/yacht_design_system.dart';
import '../../locator.dart';

import '../../yacht_design_system/yds_color.dart';
import '../../yacht_design_system/yds_widget.dart';
import '../quest/yacht_quest_view.dart';
import '../stock_info/yacht_pick_old_view.dart';
import '../stock_info/yacht_pick_view.dart';

class NewHomeView extends StatelessWidget {
  HomeViewModel homeViewModel = Get.find<HomeViewModel>();
  NotificationViewModel notificationViewModel = Get.put(NotificationViewModel());

  final MixpanelService _mixpanelService = locator<MixpanelService>();

  RxDouble offset = 0.0.obs;

  final GlobalKey<FormState> userNameFormKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController(text: "");
  final RxBool isCheckingUserNameDuplicated = false.obs;
  final RxBool showSmallSnackBar = false.obs;
  final RxString smallSnackBarText = "".obs;

  void onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1200));
    todayQuests = null;
    await homeViewModel.getAllQuests();
    homeViewModel.rankController.onInit();
    homeViewModel.awardViewModel.onInit();
    print('refreshed');
    // if failed,use refreshFailed()
    homeViewModel.refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> homeWidgets = [
      DialogReadyWidget(homeViewModel: homeViewModel),
      // MyAssets(),
      SizedBox(
        height: 30.w,
      ),
      // 이달의 상금 주식
      // AwardView(leagueName: leagueModel.value!.leagueName, leagueEndDateTime: leagueModel.value!.leagueEndDateTime),

      // 주간 요트 종목
      YachtPick(homeViewModel: homeViewModel),
      SizedBox(height: 50.w),
      YachtQuestView(homeViewModel: homeViewModel),
      SizedBox(
        height: 50.w,
      ),

      SizedBox(height: 100.w),
    ];

    // _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      homeViewModel.scrollController.addListener(() {
        // offset obs 값에 scroll controller offset 넣어주기
        homeViewModel.scrollController.offset < 0 ? offset(0) : offset(homeViewModel.scrollController.offset);
        // print(homeViewModel.scrollController.offset);
      });
    });

    // print(
    //     'screen width: ${ScreenUtil().screenWidth} / screen height: ${ScreenUtil().screenHeight} / ratio: ${(ScreenUtil().screenHeight / ScreenUtil().screenWidth)}');

    return Scaffold(
      // backgroundColor: yachtGrey,
      body: RefreshConfiguration(
        headerTriggerDistance: 80.w,
        // springDescription: SpringDescription(mass: 2.2, damping: 96, stiffness: 400),
        enableScrollWhenRefreshCompleted: true,
        child: SmartRefresher(
          enablePullDown: true,
          header: YachtCustomHeader(),
          controller: homeViewModel.refreshController,
          onRefresh: onRefresh,
          child: Stack(
            children: [
              CustomScrollView(
                controller: homeViewModel.scrollController,
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
                          homeViewModel,
                        )),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 14.w,
                    ),
                  ),
                  SliverList(
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
                ],
              ),
              // Obx(
              //   () => (homeViewModel.isBannerAdLoaded.value && homeViewModel.bannerAdPosition.value == 'bottom_fixed')
              //       ? Positioned(
              //           bottom: ScreenUtil().bottomBarHeight + 60.w,
              //           left: (ScreenUtil().screenWidth - homeViewModel.myBanner!.sizes[0].width.toDouble()) / 2,
              //           child: Center(
              //             child: Container(
              //               height: homeViewModel.myBanner!.sizes[0].height.toDouble(),
              //               width: homeViewModel.myBanner!.sizes[0].width.toDouble(),
              //               // width: ScreenUtil().screenWidth,
              //               child: AdWidget(ad: homeViewModel.myBanner!),
              //             ),
              //           ))
              //       : SizedBox.shrink(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class YachtPick extends StatelessWidget {
  YachtPick({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  final HomeViewModel homeViewModel;
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: defaultHorizontalPadding,
              child: Text(
                "오늘의 요트 Pick",
                style: TextStyle(
                  color: yachtWhite,
                  fontSize: 24.w,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // SizedBox(
            //   width: 4.w,
            // ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                showDialog(
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: FutureBuilder<String>(
                            future: homeViewModel.getYachtPickDescription(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? infoDialog(context,
                                      title: "요트 Pick?", info: snapshot.data!, textAlign: TextAlign.start)
                                  : infoDialog(context, title: "요트 Pick?");
                            },
                          )
                          // Dialog(
                          //   backgroundColor: Colors.transparent,
                          //   // shape: RoundedRectangleBorder(
                          //   //   borderRadius: BorderRadius.circular(12.w),
                          //   // ),
                          //   insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
                          //   child: Container(
                          //     padding: defaultPaddingAll.copyWith(top: 0),
                          //     decoration: BoxDecoration(
                          //       color: yachtDarkGrey,
                          //       borderRadius: BorderRadius.circular(12.w),
                          //     ),
                          //     child: Column(
                          //       mainAxisSize: MainAxisSize.min,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Container(
                          //           height: 60.w,
                          //           child: Center(
                          //             child: Text(
                          //               "요트 Pick?",
                          //               style: head3Style.copyWith(
                          //                 fontWeight: FontWeight.w700,
                          //               ),
                          //             ),
                          //           ),
                          //         ),
                          //         FutureBuilder<String>(
                          //             future: homeViewModel.getYachtPickDescription(),
                          //             builder: (_, snapshot) {
                          //               return snapshot.hasData
                          //                   ? Text(
                          //                       '${snapshot.data!}'.replaceAll('\\n', '\n'),
                          //                       style: body1Style.copyWith(height: 1.4.w),
                          //                     )
                          //                   : Text("");
                          //             }),
                          //         SizedBox(
                          //           height: 16.w,
                          //         ),
                          //         GestureDetector(
                          //             onTap: () {
                          //               Navigator.of(context).pop();
                          //             },
                          //             child: confirmDialogButton())
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          );
                    });
              },
              child: Container(
                width: 40.w,
                height: 30.w,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    'assets/icons/question_mark.svg',
                    width: 24.w,
                    // height: 26.w,
                    color: yachtLightGrey,
                  ),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                _mixpanelService.mixpanel.track('Old Yacht Pick');
                Get.to(() => YachtPickOldView());
              },
              child: Container(
                // height: 40.w,
                // width: 20.w,
                // color: Colors.red,
                decoration: BoxDecoration(color: yachtGrey, borderRadius: BorderRadius.circular(50.w)),
                child: Padding(
                  padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 8.w, bottom: 8.w),
                  child: Text(
                    "모든 요트 Pick",
                    style: TextStyle(
                      color: yachtWhite,
                      fontSize: 14.w,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 14.w,
            ),
          ],
        ),
        SizedBox(
          height: 20.w,
        ),
        Obx(() => homeViewModel.stockInfoNewModels.length > 0 ? YachtPickView() : SizedBox.shrink()),
      ],
    );
  }
}

class DialogReadyWidget extends StatefulWidget {
  final HomeViewModel homeViewModel;

  const DialogReadyWidget({Key? key, required this.homeViewModel}) : super(key: key);
  @override
  State<DialogReadyWidget> createState() => _DialogReadyWidgetState();
}

class _DialogReadyWidgetState extends State<DialogReadyWidget> {
  final GlobalKey<FormState> userNameFormKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController(text: "");
  final RxBool isCheckingUserNameDuplicated = false.obs;
  final RxBool noNeedShowUserNameDialog = true.obs;
  final RxBool showSmallSnackBar = false.obs;
  final RxString smallSnackBarText = "".obs;

  final box = GetStorage();
  bool iosTermAgree = true;
  bool newTermAgree = true;
  String termsOfUse = "";
  String privacyPolicy = "";
  RxBool checkTerm = false.obs;
  RxBool checkFourteen = false.obs;
  RxBool checkNewTerm = false.obs;

  ScrollController _termScrollController = ScrollController();
  ScrollController _privacyScrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initPlugin();

      await Get.find<HomeViewModel>().pushNotificationService.initialise();
    });
    // print('DialogReadyWidget init called');
    // print('showingtermdial: ${widget.homeViewModel.onceInit}');
    if (!widget.homeViewModel.onceInit) {
      widget.homeViewModel.onceInit = true;
      print('after init: ${widget.homeViewModel.onceInit}');
      iosTermAgree = box.read('iosTermAgree${userModelRx.value!.uid}') ?? false;
      newTermAgree = box.read('newTermAgree${userModelRx.value!.uid}') ?? false;
      //  else {
      if (userModelRx.value!.isNameUpdated == null || !userModelRx.value!.isNameUpdated!) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showChangeNameDialog(context);
        });
      }
      // }

      // ios 약관 동의
      // if (!iosTermAgree) {
      // WidgetsBinding.instance.addPostFrameCallback((_) async {
      //   termsOfUse = await rootBundle.loadString('assets/documents/termsOfUse.txt');
      //   privacyPolicy = await rootBundle.loadString('assets/documents/privacyPolicy.txt');
      //   await showTermDialog(context, widget.homeViewModel);
      // });
      // }

      // WidgetsBinding.instance.addPostFrameCallback((_) async {
      //   await showNewTermDialog(context);
      // });

      // 상단 다이얼로그 테스트
      if (!newTermAgree) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                RxBool seeTerm = false.obs;
                return Dialog(
                  backgroundColor: Colors.transparent,
                  alignment: Alignment.topCenter,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  insetPadding: EdgeInsets.fromLTRB(14.w, 24.w, 14.w, 24.w),
                  child: Container(
                    padding: defaultPaddingAll.copyWith(top: 0),
                    decoration: BoxDecoration(
                      color: yachtDarkGrey,
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    // width: 200,
                    // height: 100,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60.w,
                            child: Center(
                              child: Text(
                                "알림",
                                style: head3Style.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "새롭게 변경된 이용약관에 동의해주세요",
                            style: head3Style.copyWith(height: 1.4.w),
                          ),
                          SizedBox(
                            height: 16.w,
                          ),
                          Obx(() => seeTerm.value
                              ? Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: WebView(
                                          backgroundColor: Color(0xFF101214),
                                          initialUrl:
                                              "https://brave-cinnamon-fa9.notion.site/2022-10-15-ef93f9fee66541f8a64e7feddf424dea",
                                          // gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                                          javascriptMode: JavascriptMode.unrestricted,
                                          zoomEnabled: false,
                                          onWebViewCreated: (_) {
                                            print('onWebViewCreated' + _.toString());
                                          },
                                          onPageStarted: (_) {
                                            print('onPageStarted' + _.toString());
                                          },
                                          onProgress: (_) {
                                            print('onProgress' + _.toString());
                                          },
                                          onPageFinished: (_) {
                                            print('onPageFinished' + _.toString());
                                            // setState(() {
                                            //   // isPageFinishied = true;
                                            // });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16.w,
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox.shrink()),
                          Container(
                              height: 48.w,
                              // width: 30,
                              // color: Colors.red,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      seeTerm(true);
                                      // Get.to(TempWebView(
                                      //     url:
                                      //         "https://brave-cinnamon-fa9.notion.site/2022-10-20-ef93f9fee66541f8a64e7feddf424dea"));
                                    },
                                    child: Container(
                                      // width: 120.w,
                                      child: bigTextContainerButton(text: "이용약관 확인", isDisabled: true),
                                    ),
                                  ),
                                  SizedBox(width: 14.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        await widget.homeViewModel.agreeTerm();
                                        box.write('newTermAgree${userModelRx.value!.uid}', true);
                                        Navigator.of(context).pop();
                                      },
                                      child: bigTextContainerButton(text: "동의하고 시작하기", isDisabled: false),
                                    ),
                                  ),
                                ],
                              )),
                        ]),
                  ),
                );
              });
        });
      }
    }
    super.initState();
  }

  RxString _authStatus = 'Unknown'.obs;
  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
      _authStatus(status.toString());
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        // Show a custom explainer dialog before the system dialog
        // if (await showCustomTrackingDialog(context)) {
        //   // Wait for dialog popping animation
        //   await Future.delayed(const Duration(milliseconds: 200));
        // Request system's tracking authorization dialog
        final TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();
        _authStatus(status.toString());
        // }
      }
    } on PlatformException {
      _authStatus('PlatformException was thrown');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  showNewTermDialog(BuildContext context) {
    showDialog(
        context: (context),
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            // backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.w),
            ),

            insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Container(
              color: yachtBlack,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 300.w,
                    child: WebView(
                      backgroundColor: Color(0xFF101214),
                      initialUrl: "https://brave-cinnamon-fa9.notion.site/2022-10-15-ef93f9fee66541f8a64e7feddf424dea",
                      // gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
                      javascriptMode: JavascriptMode.unrestricted,
                      zoomEnabled: false,
                      onWebViewCreated: (_) {
                        print('onWebViewCreated' + _.toString());
                      },
                      onPageStarted: (_) {
                        print('onPageStarted' + _.toString());
                      },
                      onProgress: (_) {
                        print('onProgress' + _.toString());
                      },
                      onPageFinished: (_) {
                        print('onPageFinished' + _.toString());
                        // setState(() {
                        //   // isPageFinishied = true;
                        // });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 14.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Obx(
                          () => Checkbox(
                              activeColor: yachtViolet,
                              side: BorderSide(width: 2.w, color: yachtWhite),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              value: checkNewTerm.value,
                              onChanged: (value) {
                                checkNewTerm(value);
                              }),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text("이용약관에 동의합니다.", style: body1Style),
                      Text(" (필수)", style: body1Style.copyWith(color: yachtRed)),
                    ],
                  ),
                  SizedBox(
                    height: 14.w,
                  ),
                  Container(
                      height: 48.w,
                      // width: 30,
                      // color: Colors.red,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                      backgroundColor: yachtDarkGrey,
                                      insetPadding: defaultHorizontalPadding,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.fromLTRB(14.w, 14.w, 14.w, 14.w),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text("알림", style: body1Style),
                                                  SizedBox(
                                                    height: 14.w,
                                                  ),
                                                  Text("이용약관에 동의하지 않으면 요트 서비스를 이용할 수 없습니다. ", style: head3Style),
                                                  SizedBox(
                                                    height: 14.w,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      " 동의를 거부하고 정말 탈퇴하시겠습니까?",
                                                      style: head3Style,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 14.w,
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      "탈퇴 시 모든 데이터가 삭제되며 되돌릴 수 없습니다.",
                                                      style: body2Style,
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 24.w,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                            onTap: () async {
                                                              // homeViewModel.authService.deleteAccount();

                                                              userModelRx(null);
                                                              userQuestModelRx.value = [];
                                                              leagueRx("");

                                                              // _kakaoApi.signOut();

                                                              Navigator.of(context).pop();
                                                              Navigator.of(context).pop();
                                                              await Get.offAll(() => AuthCheckView());
                                                              Get.find<AuthCheckViewModel>().onInit();
                                                            },
                                                            child: textContainerButtonWithOptions(
                                                              text: "예",
                                                              isDarkBackground: false,
                                                              height: 44.w,
                                                            )),
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      Expanded(
                                                        child: InkWell(
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                              // Get.back(closeOverlays: true);
                                                            },
                                                            child: textContainerButtonWithOptions(
                                                                text: "아니오", isDarkBackground: true, height: 44.w)),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )),
                                        ],
                                      )));
                            },
                            child: Container(
                              width: 80.w,
                              child: bigTextContainerButton(text: "취소", isDisabled: true),
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Obx(
                              () => GestureDetector(
                                onTap: () async {
                                  if (checkNewTerm.value) {
                                    if (userModelRx.value!.isNameUpdated == null ||
                                        !userModelRx.value!.isNameUpdated!) {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        showChangeNameDialog(context);
                                      });
                                    }
                                  } else {
                                    yachtSnackBar("새로운 이용약관에 동의한 후 시작할 수 있습니다.");
                                  }
                                },
                                child: bigTextContainerButton(text: "시작하기", isDisabled: !(checkNewTerm.value)),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          );
        });
  }

  showTermDialog(BuildContext termContext, HomeViewModel homeViewModel) {
    print('show term called');
    final KakaoFirebaseAuthApi _kakaoApi = KakaoFirebaseAuthApi();
    String title = "서비스를 이용하기 위해\n아래에 대한 동의가 필요합니다.";
    String btnLabel = "수락";
    String btnLabelCancel = "거부";

    showDialog(
      context: termContext,
      barrierDismissible: false,
      builder: (termContext) {
        print('show term showDialog called');
        return MediaQuery(
            data: MediaQuery.of(termContext).copyWith(textScaleFactor: 1.0),
            child: Dialog(
              backgroundColor: yachtDarkGrey,
              insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // padding: EdgeInsets.all(14.w),
                    Center(
                      child: Text(title,
                          textAlign: TextAlign.center,
                          style: body1Style.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                    SizedBox(
                      height: 14.w,
                    ),

                    Text("이용약관",
                        style: TextStyle(
                          color: yachtWhite,
                        )),
                    SizedBox(
                      height: 8.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: yachtMidGrey,
                        width: 0.5.w,
                      )),
                      height: ScreenUtil().screenHeight * .21,
                      // width: 240,
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: _termScrollController,
                        child: SingleChildScrollView(
                            controller: _termScrollController,
                            child: Padding(
                              padding: EdgeInsets.all(14.w),
                              child: Text(
                                termsOfUse,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: yachtWhite,
                                ),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 16.w,
                    ),
                    Text("개인정보처리방침",
                        style: TextStyle(
                          color: yachtWhite,
                        )),
                    SizedBox(
                      height: 8.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: yachtMidGrey,
                        width: 0.5.w,
                      )),

                      height: ScreenUtil().screenHeight * .21,
                      // width: 240,
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: _termScrollController,
                        child: SingleChildScrollView(
                            controller: _privacyScrollController,
                            child: Padding(
                              padding: EdgeInsets.all(14.w),
                              child: Text(
                                privacyPolicy,
                                style: TextStyle(
                                  color: yachtWhite,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 8.w,
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: () => checkTerm.value = !checkTerm.value,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                  activeColor: yachtViolet,
                                  side: BorderSide(width: 2.w, color: yachtWhite),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: checkTerm.value,
                                  onChanged: (value) {
                                    checkTerm(value);
                                  }),
                            ),
                            SizedBox(width: 4.w),
                            Text("이용약관 및 개인정보처리방침 동의",
                                style: TextStyle(
                                  color: yachtWhite,
                                )),
                            Text(" (필수)", style: TextStyle(color: yachtRed, fontFamily: 'Default')),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4.w,
                    ),
                    Obx(
                      () => GestureDetector(
                        onTap: () => checkFourteen.value = !checkFourteen.value,
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                  activeColor: yachtViolet,
                                  side: BorderSide(width: 2.w, color: yachtWhite),
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: checkFourteen.value,
                                  onChanged: (value) {
                                    checkFourteen(value);
                                  }),
                            ),
                            SizedBox(width: 4.w),
                            Text("만 14세 이상입니다. ",
                                style: TextStyle(
                                  color: yachtWhite,
                                )),
                            Text(" (필수)", style: TextStyle(color: yachtRed, fontFamily: 'Default')),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14.w,
                    ),
                    Container(
                        height: 48.w,
                        width: double.infinity,
                        // color: Colors.red,
                        child: Obx(() => Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                            backgroundColor: yachtDarkGrey,
                                            insetPadding: defaultHorizontalPadding,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.fromLTRB(14.w, 14.w, 14.w, 14.w),
                                                    decoration:
                                                        BoxDecoration(borderRadius: BorderRadius.circular(10.w)),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text("알림", style: body1Style),
                                                        SizedBox(
                                                          height: 14.w,
                                                        ),
                                                        Text("이용약관과 개인정보처리방침에 동의하지 않으면 요트 서비스를 이용할 수 없습니다. ",
                                                            style: head3Style),
                                                        SizedBox(
                                                          height: 14.w,
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            " 동의를 거부하고 정말 탈퇴하시겠습니까?",
                                                            style: head3Style,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 14.w,
                                                        ),
                                                        Center(
                                                          child: Text(
                                                            "탈퇴 시 모든 데이터가 삭제되며 되돌릴 수 없습니다.",
                                                            style: body2Style,
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 24.w,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: GestureDetector(
                                                                  onTap: () async {
                                                                    homeViewModel.authService.deleteAccount();

                                                                    userModelRx(null);
                                                                    userQuestModelRx.value = [];
                                                                    leagueRx("");

                                                                    _kakaoApi.signOut();

                                                                    Navigator.of(context).pop();
                                                                    Navigator.of(context).pop();
                                                                    await Get.offAll(() => AuthCheckView());
                                                                    Get.find<AuthCheckViewModel>().onInit();
                                                                  },
                                                                  child: textContainerButtonWithOptions(
                                                                    text: "예",
                                                                    isDarkBackground: false,
                                                                    height: 44.w,
                                                                  )),
                                                            ),
                                                            SizedBox(width: 8.w),
                                                            Expanded(
                                                              child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.of(context).pop();
                                                                    // Get.back(closeOverlays: true);
                                                                  },
                                                                  child: textContainerButtonWithOptions(
                                                                      text: "아니오",
                                                                      isDarkBackground: true,
                                                                      height: 44.w)),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                              ],
                                            )));
                                  },
                                  child: Container(
                                    width: 80.w,
                                    child: bigTextContainerButton(text: "취소", isDisabled: true),
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (checkTerm.value && checkFourteen.value) {
                                        await homeViewModel.agreeTerm();
                                        box.write('iosTermAgree${userModelRx.value!.uid}', true);
                                        Navigator.of(termContext).pop();

                                        // if (userModelRx.value!.isNameUpdated == null ||
                                        //     !userModelRx.value!.isNameUpdated!) {
                                        //   WidgetsBinding.instance.addPostFrameCallback((_) {
                                        //     showChangeNameDialog(context);
                                        //   });
                                        // }
                                      } else {
                                        yachtSnackBar("모두 동의한 후 시작할 수 있습니다.");
                                      }
                                    },
                                    child: bigTextContainerButton(
                                        text: "시작하기", isDisabled: !(checkFourteen.value && checkTerm.value)),
                                  ),
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
            ));
      },
    );
  }

  showChangeNameDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: yachtDarkGrey,
        insetPadding: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.w),
        ),
        child: Container(
            // decoration: primaryBoxDecoration.copyWith(
            //   // color: yachtWhite,
            // ),
            // height: double.minPositive,

            padding: defaultPaddingAll,
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
                                  color: yachtWhite,
                                  fontSize: 18.w,
                                  letterSpacing: -0.5,
                                  height: 1.4,
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(height: 14.w),
                        Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(left: 12.w, top: 14.w, bottom: 11.w),
                            child: TextFormField(
                              controller: userNameController,
                              style: TextStyle(
                                color: yachtWhite,
                              ),
                              textAlignVertical: TextAlignVertical.bottom,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: yachtMidGrey,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 6.w,
                                ),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                                hintText: '${userModelRx.value!.userName}',
                                hintStyle: body1Style.copyWith(color: yachtLightGrey),
                              ),
                              validator: (value) {
                                if (value != '') {
                                  final nickValidator = RegExp(r'^[a-zA-Zㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]+$');
                                  if (value!.length > 8 || !nickValidator.hasMatch(value) || value.contains(' ')) {
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
                                Future.delayed(Duration(seconds: 1)).then((value) {
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
                                //   backgroundColor: yachtWhite.withOpacity(.5),
                                //   barBlur: 8,
                                //   duration: const Duration(seconds: 1, milliseconds: 100),
                                // );
                              } else if (userNameFormKey.currentState!.validate() &&
                                  isCheckingUserNameDuplicated.value == false) {
                                if (userNameController.text != '') {
                                  print(userNameController.text);
                                  isCheckingUserNameDuplicated(true);
                                  bool isUserNameDuplicatedVar = true;

                                  isUserNameDuplicatedVar =
                                      await widget.homeViewModel.isUserNameDuplicated(userNameController.text);
                                  print(isUserNameDuplicatedVar);
                                  if (!isUserNameDuplicatedVar) {
                                    await widget.homeViewModel.updateUserName(userNameController.text);
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
                                    //   backgroundColor: yachtWhite.withOpacity(.5),
                                    //   barBlur: 8,
                                    //   duration: const Duration(seconds: 1, milliseconds: 100),
                                    // );
                                  } else {
                                    showSmallSnackBar(true);
                                    smallSnackBarText("중복된 닉네임이 있어요");
                                    Future.delayed(Duration(seconds: 1)).then((value) {
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
                                      borderRadius: BorderRadius.circular(12.w),
                                      color: isCheckingUserNameDuplicated.value == false
                                          ? yachtViolet
                                          : Color(0xFFEFF2FA)),
                                  child: Center(
                                    child: Text(
                                      isCheckingUserNameDuplicated.value == false ? '저장하기' : '닉네임 중복 검사 중',
                                      style: head3Style.copyWith(
                                          color: isCheckingUserNameDuplicated.value == false
                                              ? Color(0xFFEFF2FA)
                                              : yachtViolet),
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        top: 48.w,
                        // left: 16.w,
                        child: Obx(
                          () => showSmallSnackBar.value
                              ? AnimatedContainer(
                                  duration: Duration(milliseconds: 600),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.w),
                                    color: yachtLightGrey,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 12.w,
                                  ),
                                  // width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      smallSnackBarText.value,
                                      style: TextStyle(
                                          fontSize: 16.w,
                                          fontWeight: FontWeight.w600,
                                          color: showSmallSnackBar.value ? yachtBlack : Colors.transparent),
                                    ),
                                  ),
                                )
                              : Container(),
                        ))
                  ],
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// class MyAssets extends StatelessWidget {
//   final AssetViewModel _assetViewModel = Get.find<AssetViewModel>();
//   final MixpanelService _mixpanelService = locator<MixpanelService>();
//   // final AssetViewModel _assetViewModel = Get.put(AssetViewModel());

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // height: offset.w > 100.w ? 0 : 100.w - offset.w,
//       height: 100.w,
//       child: Row(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onTap: () {
//                 _mixpanelService.mixpanel.track(
//                   'My Asset',
//                   properties: {'My Asset Tap From': "주식 잔고"},
//                 );
//                 Get.to(() => AssetView());
//               },
//               child: Container(
//                 // color: Colors.blue,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/icons/won_circle.png',
//                           width: 20.w,
//                           height: 20.w,
//                         ),
//                         SizedBox(width: 4.w),
//                         Text(
//                           "주식 잔고",
//                           style: myAssetTitle,
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: reducedPaddingWhenTextIsBelow(14.w, detailedContentTextStyle.fontSize!)),
//                     GetBuilder<AssetViewModel>(
//                         id: 'holdingStocks',
//                         builder: (controller) {
//                           return RichText(
//                               text: TextSpan(
//                                   text: controller.isHoldingStocksFutureLoad
//                                       ? "${toPriceKRW(_assetViewModel.totalHoldingStocksValue)}"
//                                       : "0",
//                                   style: myAssetAmount,
//                                   children: [
//                                 TextSpan(text: " 원", style: myAssetAmount.copyWith(fontWeight: FontWeight.w300))
//                               ]));
//                         }),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           VerticalDivider(
//             color: primaryFontColor.withOpacity(.5),
//             indent: 16.w,
//             endIndent: 16.w,
//           ),
//           Expanded(
//               child: GestureDetector(
//             onTap: () {
//               _mixpanelService.mixpanel.track(
//                 'My Asset',
//                 properties: {'My Asset Tap From': "요트 포인트"},
//               );
//               Get.to(() => AssetView());
//             },
//             child: Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/icons/yacht_point_circle.png',
//                         width: 20.w,
//                         height: 20.w,
//                       ),
//                       SizedBox(width: 4.w),
//                       Text(
//                         "요트 포인트",
//                         style: myAssetTitle,
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: reducedPaddingWhenTextIsBelow(14.w, detailedContentTextStyle.fontSize!)),
//                   GetBuilder<AssetViewModel>(
//                       id: 'holdingStocks',
//                       builder: (controller) {
//                         return RichText(
//                             text: TextSpan(
//                                 text: controller.isHoldingStocksFutureLoad
//                                     ? "${toPriceKRW(_assetViewModel.totalYachtPoint)}"
//                                     : "0",
//                                 style: myAssetAmount,
//                                 children: [
//                               TextSpan(text: " 원", style: myAssetAmount.copyWith(fontWeight: FontWeight.w300))
//                             ]));
//                       }),
//                 ],
//               ),
//             ),
//           ))
//         ],
//       ),
//     );
//   }
// }

class _GlassmorphismAppBarDelegate extends SliverPersistentHeaderDelegate {
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  final EdgeInsets safeAreaPadding;
  final double offset;
  final HomeViewModel homeViewModel;

  _GlassmorphismAppBarDelegate(this.safeAreaPadding, this.offset, this.homeViewModel);

  @override
  double get minExtent => 52.w + ScreenUtil().statusBarHeight;

  @override
  double get maxExtent => minExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    double opacity = offset > 30.w ? 1 : offset / 30.w;
    // print(offset);
    return ClipRect(
        child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Container(
        // Don't wrap this in any SafeArea widgets, use padding instead
        // padding: EdgeInsets.only(top: safeAreaPadding.top),

        height: maxExtent,
        color: yachtBlack.withOpacity(.65),
        // color: Colors.blue.withOpacity(.65),

        child: Column(
          children: [
            SizedBox(height: safeAreaPadding.top),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    defaultPaddingSize,
                    0,
                    defaultPaddingSize,
                    0,
                  ),
                  child: Stack(
                    children: [
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         userModelRx.value == null ? "" : userModelRx.value!.userName,
                      //         style: appBarTitle.copyWith(
                      //             fontSize: 18.w,
                      //             fontWeight: FontWeight.w600,
                      //             color: appBarTitle.color!.withOpacity(
                      //               opacity,
                      //             )),
                      //       ),
                      //       Text(
                      //         " 님의 요트",
                      //         style: appBarTitle.copyWith(
                      //             fontSize: 18.w,
                      //             fontWeight: FontWeight.w400,
                      //             color: appBarTitle.color!.withOpacity(
                      //               opacity,
                      //             )),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Align(
                      //   alignment: Alignment.bottomLeft,
                      //   child: Row(
                      //     children: [
                      //       Obx(
                      //         () => Text(
                      //           userModelRx.value == null ? "" : userModelRx.value!.userName,
                      //           style: appBarTitle.copyWith(
                      //               fontWeight: FontWeight.w600,
                      //               color: appBarTitle.color!.withOpacity(
                      //                 1 - opacity,
                      //               )),
                      //         ),
                      //       ),
                      //       Text(
                      //         " 님의 요트",
                      //         style: appBarTitle.copyWith(
                      //             fontWeight: FontWeight.w400,
                      //             color: appBarTitle.color!.withOpacity(
                      //               1 - opacity,
                      //             )),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Positioned(
                        top: 12.w,
                        right: 0,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                _mixpanelService.mixpanel.track(
                                  'Jogabi Get',
                                  properties: {'Position': "AppBar"},
                                );
                                if (homeViewModel.isRewardedAdLoaded.value) {
                                  if (userModelRx.value!.rewardedCnt! < maxRewardedAds) {
                                    adsViewDialog(context);
                                  } else {
                                    maxRewardedAdsDialog(context);
                                  }
                                } else {
                                  print("not load");
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return infoDialog(context, info: "광고를 불러오는 중이에요.\n잠시 후에 시도해주세요.");
                                      });
                                }

                                // 여기서 트리거해주면 페이지전환 속도가 느려서.. 차라리 노티피케이션뷰를 스테이트풀 위젯으로 해주고 그 이닛스테이트에서 얘를 실행하자.
                                // Get.find<NotificationViewModel>()
                                //     .lastNotificationCheckTimeUpdate();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2.w,
                                          color: yachtWhite,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          8.w,
                                        )),

                                    height: 28.w,
                                    // width: 24.w,
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/jogabi_without_circle.svg',
                                          height: 24.w,
                                          width: 24.w,
                                        ),
                                        SvgPicture.asset(
                                          'assets/buttons/add.svg',
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 3.w,
                                        )
                                      ],
                                    ),
                                    // Image.asset('assets/icons/notification.png'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 14.w,
                            ),
                            InkWell(
                              onTap: () {
                                _mixpanelService.mixpanel.track(
                                  'Yacht Point Store',
                                  properties: {'Yacht Point Store': "홈"},
                                );
                                Get.to(() => YachtStoreView());

                                // 여기서 트리거해주면 페이지전환 속도가 느려서.. 차라리 노티피케이션뷰를 스테이트풀 위젯으로 해주고 그 이닛스테이트에서 얘를 실행하자.
                                // Get.find<NotificationViewModel>()
                                //     .lastNotificationCheckTimeUpdate();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                      height: 24.w,
                                      // width: 24.w,
                                      child: Image.asset(
                                        'assets/icons/yachtpointstore_darkmode.png',
                                        // color: yachtBlack,
                                      )
                                      // Image.asset('assets/icons/notification.png'),
                                      ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 14.w,
                            ),
                            InkWell(
                              onTap: () async {
                                _mixpanelService.mixpanel.track('Notification');
                                // 'NeedLoad' arg를 붙여서 보내면, 유저 정보에 noti 확인한 시간 stamp
                                if (userModelRx.value!.lastNotificationCheckDateTime == null) {
                                  Get.to(() => NotificationView(), arguments: 'NeedLoad');
                                } else {
                                  if (Get.find<NotificationViewModel>()
                                          .lastNotificationTimeForNavigate()
                                          .compareTo(userModelRx.value!.lastNotificationCheckDateTime) >
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                      height: 28.w,
                                      width: 28.w,
                                      child: GetBuilder<NotificationViewModel>(
                                        id: 'notificationList',
                                        builder: (controller) {
                                          if (controller.isNotificationListLoaded) {
                                            return Obx(() {
                                              if (userModelRx.value!.lastNotificationCheckDateTime != null) {
                                                if (controller
                                                        .lastNotificationTime()
                                                        .compareTo(userModelRx.value!.lastNotificationCheckDateTime) >
                                                    0) {
                                                  return Image.asset(
                                                      'assets/icons/notification_alarm_new_darkmode.png');
                                                } else {
                                                  return Image.asset('assets/icons/notification_alarm_darkmode.png');
                                                }
                                              } else {
                                                print('last모시기 null');
                                                return Image.asset('assets/icons/notification_alarm_new_darkmode.png');
                                              }
                                            });
                                          } else {
                                            return Container();
                                          }
                                        },
                                      )
                                      // Image.asset('assets/icons/notification.png'),
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                  // Center(
                  //     child: Row(
                  //   // crossAxisAlignment: CrossAxisAlignment.center,
                  //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Flexible(
                  //       flex: 1,
                  //       child: Container(),
                  //     ),
                  //     Center(
                  //       child: Row(
                  //         children: [
                  //           Obx(
                  //             () => Text(
                  //               userModelRx.value == null ? "" : userModelRx.value!.userName,
                  //               style: appBarTitle.copyWith(
                  //                 fontWeight: FontWeight.w500,
                  //               ),
                  //             ),
                  //           ),
                  //           Text(
                  //             " 님의 요트",
                  //             style: appBarTitle,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     // Spacer(),
                  //     Flexible(
                  //       flex: 1,
                  //       child:
                  // InkWell(
                  //         onTap: () async {
                  //
                  //           if (userModelRx.value!.lastNotificationCheckDateTime == null) {
                  //             Get.to(() => NotificationView(), arguments: 'NeedLoad');
                  //           } else {
                  //             if (Get.find<NotificationViewModel>()
                  //                     .lastNotificationTimeForNavigate()
                  //                     .compareTo(userModelRx.value!.lastNotificationCheckDateTime) >
                  //                 0) {
                  //               Get.to(() => NotificationView(), arguments: 'NeedLoad');
                  //             } else {
                  //               Get.to(() => NotificationView());
                  //             }
                  //           }
                  //           // 여기서 트리거해주면 페이지전환 속도가 느려서.. 차라리 노티피케이션뷰를 스테이트풀 위젯으로 해주고 그 이닛스테이트에서 얘를 실행하자.
                  //           // Get.find<NotificationViewModel>()
                  //           //     .lastNotificationCheckTimeUpdate();
                  //         },
                  //         child: Align(
                  //           alignment: Alignment.centerRight,
                  //           child: Row(
                  //             mainAxisAlignment: MainAxisAlignment.end,
                  //             children: [
                  //               SizedBox(
                  //                   height: 26.w,
                  //                   // width: 24.w,
                  //                   child: GetBuilder<NotificationViewModel>(
                  //                     id: 'notificationList',
                  //                     builder: (controller) {
                  //                       if (controller.isNotificationListLoaded) {
                  //                         return Obx(() {
                  //                           if (userModelRx.value!.lastNotificationCheckDateTime != null) {
                  //                             if (controller
                  //                                     .lastNotificationTime()
                  //                                     .compareTo(userModelRx.value!.lastNotificationCheckDateTime) >
                  //                                 0) {
                  //                               return Image.asset('assets/icons/notification_new.png');
                  //                             } else {
                  //                               return Image.asset('assets/icons/notification.png');
                  //                             }
                  //                           } else {
                  //                             print('last모시기 null');
                  //                             return Image.asset('assets/icons/notification_new.png');
                  //                           }
                  //                         });
                  //                       } else {
                  //                         return Container();
                  //                       }
                  //                     },
                  //                   )
                  //                   // Image.asset('assets/icons/notification.png'),
                  //                   ),
                  //               SizedBox(width: primaryPaddingSize)
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // )),
                  ),
            ),
          ],
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
