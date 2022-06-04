import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../locator.dart';
import '../../services/mixpanel_service.dart';
import '../../styles/yacht_design_system.dart';
import 'home_view_model.dart';

class NewHomeView extends StatelessWidget {
  final HomeViewModel homeViewModel = Get.find<HomeViewModel>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();

  NewHomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: yachtBlack,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: yachtBlack,
              height: 355.w,
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        // fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontFamily: 'NotoSansKR',
                        // fontWeight: FontWeight.w200,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "요트 퀘스트",
                      style: TextStyle(
                        color: white,
                        fontSize: 30,
                        fontFamily: 'NotoSansKR',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
