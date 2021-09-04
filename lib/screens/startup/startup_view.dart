import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/community/community_view.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/screens/home/home_view.dart';

import 'package:yachtOne/screens/home/performance_test_home_view.dart';
import 'package:yachtOne/screens/profile/profile_view.dart';
import 'package:yachtOne/screens/startup/startup_view_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class StartupView extends GetView {
  // const StartupView({Key? key}) : super(key: key);

  List<Widget> pageList = [
    HomeView(),
    CommunityView(),
    // Container(color: Colors.red),
    // Container(color: yachtViolet),
    ProfileView(uid: 'kakao:1513684681')
    // ProfileView(uid: userModelRx.value!.uid)
  ];

  final double iconSize = 30.w;

  @override
  // TODO: implement controller
  get controller => Get.put(StartupViewModel());

  @override
  Widget build(BuildContext context) {
    print('startup rebuild');

    return Scaffold(
      extendBody: true,
      body: Obx(
        () => IndexedStack(
          index: controller.selectedPage.value,
          children: pageList,
        ),
      ),
      bottomNavigationBar: Obx(() => ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: BottomNavigationBar(
                // elevation: 8,
                backgroundColor: primaryBackgroundColor.withOpacity(.65),
                showSelectedLabels: false,
                showUnselectedLabels: false,

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
                      label: ''),
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
                currentIndex: controller.selectedPage.value,
                onTap: (index) {
                  controller.selectedPage(index);
                },
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
