import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/community/community_view.dart';
import 'package:yachtOne/screens/community/community_view_model.dart';
import 'package:yachtOne/screens/home/home_view.dart';
import 'package:yachtOne/screens/home/performance_test_home_view.dart';
import 'package:yachtOne/screens/startup/startup_view_model.dart';

class StartupView extends GetView {
  // const StartupView({Key? key}) : super(key: key);

  List<Widget> pageList = [
    HomeView(),
    CommunityView(),
    // Container(color: Colors.red),
    Container(color: Colors.red),
  ];

  @override
  // TODO: implement controller
  get controller => Get.put(StartupViewModel());

  @override
  Widget build(BuildContext context) {
    print('startup rebuild');

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedPage.value,
          children: pageList,
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: [BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'), BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'chat'), BottomNavigationBarItem(icon: Icon(Icons.people), label: 'my')],
            currentIndex: controller.selectedPage.value,
            onTap: (index) {
              controller.selectedPage(index);
            },
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
