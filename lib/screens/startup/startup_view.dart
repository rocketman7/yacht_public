import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/community/community_view.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/screens/home/home_view.dart';

import 'package:yachtOne/screens/home/performance_test_home_view.dart';
import 'package:yachtOne/screens/profile/asset_view_model.dart';
import 'package:yachtOne/screens/profile/profile_my_view.dart';
import 'package:yachtOne/screens/profile/profile_view.dart';
import 'package:yachtOne/screens/ranks/rank_controller.dart';
import 'package:yachtOne/screens/startup/startup_view_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class StartupView extends GetView<StartupViewModel> {
  // const StartupView({Key? key}) : super(key: key);
  FirebaseAuth _auth = FirebaseAuth.instance;

  final double iconSize = 30.w;

  @override
  // TODO: implement controller
  get controller => Get.put(StartupViewModel());

  @override
  Widget build(BuildContext context) {
    RxList<Widget> pageList = [
      HomeView(),
      // CommunityView(),
      // Container(color: Colors.red),
      // Container(color: yachtViolet),
      // ProfileView(uid: _auth.currentUser.uid) //, null value error
      // ProfileView(uid: userModelRx.value!.uid) //
      // ProfileMyView(),
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
      body: Obx(
        () => IndexedStack(
          index: controller.selectedPage.value,
          children: pageList,
        ),
      ),
      bottomNavigationBar: Obx(() => ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: BottomNavigationBar(
                // elevation: 8,
                backgroundColor: primaryBackgroundColor.withOpacity(.65),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: controller.selectedPage.value,
                onTap: (index) {
                  controller.selectedPage(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/icons/bottom_navigation/home_unselected.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                    activeIcon: Image.asset(
                      'assets/icons/bottom_navigation/home_selected.png',
                      width: iconSize,
                      height: iconSize,
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                      icon: Image.asset(
                        'assets/icons/bottom_navigation/community_unselected.png',
                        width: iconSize,
                        height: iconSize,
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
          )),

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
