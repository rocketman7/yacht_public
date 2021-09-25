import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/size_config.dart';

import 'package:yachtOne/styles/yacht_design_system.dart';

class OneOnOneView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: white,
          toolbarHeight: 60.w,
          title: Text('1:1 문의하기', style: appBarTitle),
        ),
        // body: ListView(
        //   children: [
        //     SizedBox(
        //       height: 24.w,
        //     ),
        //     Stack(
        //       children: [
        //         Container(
        //           height: 33.w,
        //           width: 375.w,
        //           color: Colors.black,
        //         ),
        //         Positioned(
        //             top: 100.w,
        //             child: Container(
        //               height: 66.w,
        //               width: 375.w,
        //               color: Colors.blue,
        //             )),
        //       ],
        //     ),
        //   ],
        // ),
        body: Container(
          height: SizeConfig.screenHeight -
              SizeConfig.safeAreaBottom -
              SizeConfig.safeAreaTop,
          width: SizeConfig.screenWidth,
          color: Colors.black,
        ));
  }
}
