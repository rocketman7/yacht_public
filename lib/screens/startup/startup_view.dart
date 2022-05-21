import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/community/community_view.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_view_model.dart';
import 'package:yachtOne/screens/home/home_view.dart';
import 'package:yachtOne/screens/home/home_view_model.dart';

import 'package:yachtOne/screens/home/performance_test_home_view.dart';
import 'package:yachtOne/screens/insight/insight_view.dart';
import 'package:yachtOne/screens/insight/insight_view_model.dart';
import 'package:yachtOne/screens/profile/asset_view_model.dart';
import 'package:yachtOne/screens/profile/profile_my_view.dart';
import 'package:yachtOne/screens/profile/profile_my_view_model.dart';
import 'package:yachtOne/screens/quest/live/live_quest_view_model.dart';
import 'package:yachtOne/screens/ranks/rank_controller.dart';
import 'package:yachtOne/screens/startup/startup_view_model.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class StartupView extends GetView<StartupViewModel> {
  // const StartupView({Key? key}) : super(key: key);
  FirebaseAuth _auth = FirebaseAuth.instance;
  HomeViewModel homeViewModel = Get.put(HomeViewModel());
  CommunityViewModel communityViewModel = Get.put(CommunityViewModel());
  InsightViewModel insightViewModel = Get.put(InsightViewModel());
  ProfileMyViewModel profileViewModel = Get.put(ProfileMyViewModel());
  ReadingContentViewModel readingContentViewModel = Get.put(ReadingContentViewModel());
  // LiveQuestViewModel liveQuestViewModel = Get.put(LiveQuestViewModel());

  final double iconSize = 38.w;
  final double unselectedOpacity = 1;
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  @override
  // TODO: implement controller
  get controller => Get.put(StartupViewModel());

  // DateTime currentBackPressTime = DateTime(2000, 1, 1, 0, 0);

  Future<bool> androidBackButtonAction() async {
    if (controller.selectedPage.value == 0) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Future.value(false);
    }
    //  else if (currentBackPressTime == DateTime(2000, 1, 1, 0, 0) ||
    //     DateTime.now().difference(currentBackPressTime) > Duration(seconds: 2)) {
    //   currentBackPressTime = DateTime.now();
    //   // yachtSnackBarFromBottom("뒤로 가기를 빠르게 한번 더 누르면 앱이 종료됩니다");
    //   return Future.value(false);
    //   // return null;
    // }
    else {
      controller.selectedPage(0);
      // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> mixpanelBottomBarTrackList = [
      "Home",
      "Yacht Insight",
      "Community",
      "My Page",
    ];
    RxList<Widget> pageList = [
      HomeView(),
      InsightView(),
      CommunityView(),
      // Container(color: Colors.red),
      // Container(color: yachtViolet),
      // ProfileView(uid: _auth.currentUser.uid) //, null value error
      // ProfileView(uid: userModelRx.value!.uid) //
      ProfileMyView(),
    ].obs;
    // print('startup rebuild');

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   // executes after build
    //   if (!controller.isNameUpdated) {
    //     Get.defaultDialog(content: Text("you need to update name"));
    //     print("need to update userName");
    //   }
    // });

    // 가장 상위에서 put 해줘야함
    Get.put(AssetViewModel());

    //leagueRx.value가 채워져있다는걸 보장받은 후에 rankController를 풋 하고 싶음.
    //rankController 내 ever 이벤트 트리거 활용하여 해결 완료?한 듯
    if (leagueRx.value != "") Get.put(RankController());

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: androidBackButtonAction,
        child: Obx(() => pageList[controller.selectedPage.value]
            //     IndexedStack(
            //   index: controller.selectedPage.value,
            //   children: pageList,
            // ),
            ),
      ),
      bottomNavigationBar: Obx(() {
        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: SizedBox(
              height: controller.isKeyboardShown.value ? 0 : null,
              child: BottomNavigationBar(
                selectedIconTheme: IconThemeData(size: 40),
                selectedFontSize: 0,
                unselectedFontSize: 0,
                // elevation: 8,
                type: BottomNavigationBarType.fixed,
                backgroundColor: primaryBackgroundColor.withOpacity(.65),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: controller.selectedPage.value,
                onTap: (index) async {
                  // if (controller.selectedPage.value != index) {
                  //   if (controller.selectedPage.value == 0) {
                  //     _mixpanelService.mixpanel.track('Home');
                  //     _mixpanelService.mixpanel.timeEvent('${tabPageName[index]}');
                  //     // _mixpanelService.mixpanel.timeEvent('${tabPageName[index]}-enter');
                  //   } else if (controller.selectedPage.value == 1) {
                  //     _mixpanelService.mixpanel.track('Community');
                  //     _mixpanelService.mixpanel.timeEvent('${tabPageName[index]}');
                  //     // _mixpanelService.mixpanel.timeEvent('${tabPageName[index]}-enter');
                  //   } else {
                  //     _mixpanelService.mixpanel.track('ProfileMy');
                  //     _mixpanelService.mixpanel.timeEvent('${tabPageName[index]}');
                  //     // _mixpanelService.mixpanel.timeEvent('${tabPageName[index]}-enter');
                  //   }
                  //   _mixpanelService.mixpanel.track('${tabPageName[index]}-enter');
                  // }
                  if (index == controller.selectedPage.value) {
                    switch (index) {
                      case 0:
                        homeViewModel.scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );

                        break;
                      case 1:
                        insightViewModel.scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        break;
                      case 2:
                        communityViewModel.scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        break;
                      case 3:
                        profileViewModel.scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        break;
                      default:
                    }

                    homeViewModel.scrollController.animateTo(
                      0,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    // HomeView().goToTop();
                  } else {
                    _mixpanelService.mixpanel.track(mixpanelBottomBarTrackList[index], properties: {
                      "Previous Bottom Tab": mixpanelBottomBarTrackList[controller.selectedPage.value],
                    });

                    switch (index) {
                      case 0:
                        HomeView().onRefresh();
                        // homeViewModel.onInit();
                        break;
                      case 1:
                        readingContentViewModel.onInit();
                        break;
                      case 2:
                        // communityViewModel.getNotice();
                        // communityViewModel.getPost();
                        break;
                      // case 3:
                      //   profileViewModel.scrollController.animateTo(
                      //     0,
                      //     duration: Duration(milliseconds: 300),
                      //     curve: Curves.easeInOut,
                      //   );
                      //   break;
                      default:
                    }
                    controller.selectedPage(index);
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Container(
                      // color: Colors.blue,
                      child: Image.asset(
                        'assets/icons/bottom_navigation/home_unselected.png',
                        width: iconSize,
                        height: iconSize,
                        color: yachtBlack.withOpacity(unselectedOpacity),
                      ),
                    ),
                    activeIcon: Container(
                      // color: Colors.blue,
                      child: Image.asset(
                        'assets/icons/bottom_navigation/home_selected.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                      icon: Container(
                        // color: Colors.blue,
                        child: Image.asset(
                          'assets/icons/bottom_navigation/insight_unselected.png',
                          width: iconSize,
                          height: iconSize,
                        ),
                      ),
                      activeIcon: Image.asset(
                        'assets/icons/bottom_navigation/insight_selected.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/bottom_navigation/community_unselected.png',
                        width: iconSize,
                        height: iconSize,
                        // color: yachtBlack.withOpacity(unselectedOpacity),
                      ),
                      activeIcon: Image.asset(
                        'assets/icons/bottom_navigation/community_selected.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                      label: ''),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/bottom_navigation/my_unselected.png',
                        width: iconSize,
                        height: iconSize,
                        color: yachtBlack.withOpacity(unselectedOpacity),
                      ),
                      activeIcon: Image.asset(
                        'assets/icons/bottom_navigation/my_selected.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                      label: '')
                ],
              ),
            ),
          ),
        );
      }),

      // Container(
      //   // height: _screenUtil.bottomBarHeight + 50,
      //   // color: Colors.blue,
      //   child:
      //       // BottomNavigationBar(onTap: (index) {

      //       // },)
      //       TabBar(
      //     indicatorPadding: EdgeInsets.zero,
      //     // indicatorSize:  0,
      //     // labelPadding: EdgeInsets.ze,
      //     labelColor: Colors.black,
      //     tabs: [
      //       Tab(
      //         // child: Container(
      //         //   color: Colors.red,
      //         // ),
      //         icon: Icon(Icons.home),
      //         // text: 'home',
      //       ),
      //       Tab(
      //         icon: Icon(Icons.chat),
      //         // text: 'chat',
      //       ),
      //       Tab(
      //         icon: Icon(Icons.people),
      //         // text: 'my',
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
