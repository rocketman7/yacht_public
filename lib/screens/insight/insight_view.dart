import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:yachtOne/screens/contents/dictionary/dictionary_view.dart';
import 'package:yachtOne/screens/contents/reading_content/reading_content_view.dart';
import 'package:yachtOne/screens/contents/today_market/today_market_view.dart';
import 'package:yachtOne/screens/insight/insight_view_model.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../locator.dart';

class InsightView extends StatelessWidget {
  InsightView({Key? key}) : super(key: key);

  InsightViewModel insightViewModel = Get.find<InsightViewModel>();
  RxDouble offset = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      insightViewModel.scrollController.addListener(() {
        // offset obs 값에 scroll controller offset 넣어주기
        insightViewModel.scrollController.offset < 0 ? offset(0) : offset(insightViewModel.scrollController.offset);
        // print(_scrollController.offset);
      });
    });

    return Scaffold(
        body: CustomScrollView(
      controller: insightViewModel.scrollController,
      slivers: [
        Obx(
          () => SliverPersistentHeader(
            floating: false,
            pinned: true,
            delegate: YachtPrimaryAppBarDelegate(
              offset: offset.value,
              tabTitle: "요트 인사이트",
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            TodayMarketView(),
            SizedBox(height: 40.w),
            ReadingContentView(), // showingHome 변수 구분해서 넣는 게
            SizedBox(height: 40.w),
            DictionaryView(),
            SizedBox(height: 100.w),
          ]),
        )
      ],
    ));
  }
}
