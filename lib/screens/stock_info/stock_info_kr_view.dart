import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/corporation_model.dart';

import 'package:yachtOne/screens/stock_info/chart/chart_view.dart';
import 'package:yachtOne/screens/stock_info/chart/chart_view_model.dart';
import 'package:yachtOne/screens/stock_info/news/news_view.dart';
import 'package:yachtOne/screens/stock_info/stats/stats_view.dart';
import 'package:yachtOne/screens/stock_info/stats/stats_view_model.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'description/description_view.dart';
import 'stock_info_kr_view_model.dart';

class StockInfoKRView extends StatelessWidget {
  StockAddressModel stockAddressModel;
  double bottomPadding;

  StockInfoKRView({
    Key? key,
    this.bottomPadding = 0.0,
    required this.stockAddressModel,
  }) : super(key: key);

  ScrollController _scrollController = ScrollController(initialScrollOffset: 0);
  RxDouble additionalHeight = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    final stockInfoViewModel =
        Get.put(StockInfoKRViewModel(stockAddressModel: stockAddressModel));
    ChartViewModel chartViewModel =
        Get.put(ChartViewModel(stockAddressModel: stockAddressModel));
    StatsViewModel statsViewModel =
        Get.put(StatsViewModel(stockAddressModel: stockAddressModel));
    print('new issueCode: ${stockAddressModel.issueCode}');
    // StreamController streamController = StockInfoKRView.streamController;
    // _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    _scrollController.addListener(() {
      // offset obs 값에 scroll controller offset 넣어주기
      stockInfoViewModel.offset(_scrollController.offset);
    });
    // SizeConfig().init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChartView(
          stockAddressModel: stockAddressModel,
          chartViewModel: chartViewModel,
        ),
        btwHomeModule,
        DescriptionView(stockAddressModel: stockAddressModel),
        btwHomeModule,
        NewsView(stockAddressModel: stockAddressModel),
        btwHomeModule,
        StatsView(
          stockAddressModel: stockAddressModel,
          statsViewModel: statsViewModel,
        ),
        // btwHomeModule
      ],
    );
  }
}
