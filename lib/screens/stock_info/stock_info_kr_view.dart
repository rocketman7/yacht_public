import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/stock_model.dart';

import 'package:yachtOne/screens/chart/chart_view.dart';
import 'package:yachtOne/screens/chart/chart_view_model.dart';
import 'package:yachtOne/screens/stats/stats_view.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

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
    ChartViewModel chartViewModel =
        Get.put(ChartViewModel(stockAddressModel: stockAddressModel));
    print('new issueCode: ${stockAddressModel.issueCode}');
    final stockInfoViewModel =
        Get.put(StockInfoKRViewModel(stockAddressModel: stockAddressModel));
    // StreamController streamController = StockInfoKRView.streamController;
    // _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    _scrollController.addListener(() {
      // offset obs 값에 scroll controller offset 넣어주기
      stockInfoViewModel.offset(_scrollController.offset);
    });
    // SizeConfig().init(context);
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            // print(scrollNotification.metrics);
            // additionalHeight(100);
            // _scrollController
            //     .jumpTo(scrollNotification.metrics.maxScrollExtent);
          }
          return true;
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              // 차트 공간
              Container(
                width: double.infinity,
                // height: 250,
                // color: Colors.grey,
                child: ChartView(
                  stockAddressModel: stockAddressModel,
                  chartViewModel: chartViewModel,
                ),
              ),
              verticalSpaceExtraLarge,
              Padding(
                padding: kHorizontalPadding,
                child: Obx(
                  () => Text(
                    newStockAddress!.value.name,
                    style: subtitleStyle.copyWith(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              // Row(
              //   children: [
              //     TextButton(
              //         onPressed: () {
              //           // chartViewModel.getPrices(
              //           //     stockAddressModel.copyWith(issueCode: "005930"));
              //           stockInfoViewModel.changeStockAddressModel(
              //               stockAddressModel.copyWith(issueCode: "005930"));
              //           // chartViewModel.stockAddressModel =
              //           //     stockAddressModel.copyWith(issueCode: "005930");
              //           // chartViewModel
              //           //     .getPrices(chartViewModel.newStockAddress!.value);
              //         },
              //         child: Text("0번")),
              //     TextButton(
              //         onPressed: () {
              //           // chartViewModel.getPrices(
              //           //     stockAddressModel.copyWith(issueCode: "326030"));
              //           stockInfoViewModel.changeStockAddressModel(
              //               stockAddressModel.copyWith(issueCode: "326030"));
              //           // chartViewModel.stockAddressModel =
              //           // stockAddressModel.copyWith(issueCode: "326030");
              //           // chartViewModel
              //           //     .getPrices(chartViewModel.newStockAddress!.value);
              //         },
              //         child: Text("1번")),
              //   ],
              // ),
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey,
                child: Center(
                  child: Text("Space for Description"),
                ),
              ),
              verticalSpaceExtraLarge,
              Padding(
                padding: kHorizontalPadding,
                child: Text(
                  "뉴스",
                  style: subtitleStyle.copyWith(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                // color: Colors.grey,
                child: Center(child: Text("Space for News")),
              ),
              verticalSpaceExtraLarge,

              Container(
                width: double.infinity,
                // color: Colors.grey,
                child: StatsView(
                  stockAddressModel: stockAddressModel,
                ),
              ),
              Obx(
                () => Container(
                  height: additionalHeight.value,
                  color: Colors.red,
                ),
              ),
              Container(
                height: bottomPadding,
              )
            ],
          ),
        ),
      ),
    );
  }
}
