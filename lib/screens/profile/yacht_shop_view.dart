import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:yachtOne/styles/yacht_design_system.dart';

class YachtShopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: white,
        toolbarHeight: 60.w,
        title: Text('요트 포인트 스토어', style: appBarTitle),
      ),
      body: Container(
        width: 375.w,
        height: 635.w,
        child: Stack(
          children: [
            Container(
              width: 375.w,
              height: 635.w,
              child: Image.asset('assets/illusts/yacht_shop_temp.png'),
            ),
            Center(
              child: Container(
                width: 265.w,
                height: 185.w,
                child:
                    Image.asset('assets/illusts/not_exists/no_yachtshop.png'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
