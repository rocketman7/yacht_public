import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/corporation_model.dart';

import 'package:yachtOne/screens/stock_info/chart/chart_view.dart';
import 'package:yachtOne/screens/stock_info/chart/chart_view_model.dart';
import 'package:yachtOne/screens/stock_info/chart/tradingview_chart_view.dart';
import 'package:yachtOne/screens/stock_info/news/news_view.dart';
import 'package:yachtOne/screens/stock_info/stats/stats_view.dart';
import 'package:yachtOne/screens/stock_info/stats/stats_view_model.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'chart/new_chart_view.dart';
import 'description/description_view.dart';
import 'stock_info_kr_view_model.dart';

class StockInfoKRView extends StatelessWidget {
  InvestAddressModel investAddressModel;
  double bottomPadding;

  StockInfoKRView({
    Key? key,
    this.bottomPadding = 0.0,
    required this.investAddressModel,
  }) : super(key: key);

  ScrollController _scrollController = ScrollController(initialScrollOffset: 0);
  RxDouble additionalHeight = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    final stockInfoViewModel = Get.put(StockInfoKRViewModel(investAddressModel: investAddressModel));
    ChartViewModel chartViewModel = Get.put(ChartViewModel(investAddressModel: investAddressModel));
    StatsViewModel statsViewModel = Get.put(StatsViewModel(investAddressModel: investAddressModel));
    // StreamController streamController = StockInfoKRView.streamController;
    // _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    _scrollController.addListener(() {
      // offset obs 값에 scroll controller offset 넣어주기
      stockInfoViewModel.offset(_scrollController.offset);
    });
    // SizeConfig().init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        investAddressModel.country != "KR"
            ? NewChartView(
                investAddressModel: investAddressModel,
                chartViewModel: chartViewModel,
              )
            : TradingviewChartView(investAddressModel: investAddressModel),
        btwHomeModule,
        DescriptionView(investAddressModel: investAddressModel),
        btwHomeModule,
        NewsView(investAddressModel: investAddressModel),
        btwHomeModule,
        StatsView(
          investAddressModel: investAddressModel,
          statsViewModel: statsViewModel,
        ),
        // btwHomeModule
      ],
    );
  }
}
