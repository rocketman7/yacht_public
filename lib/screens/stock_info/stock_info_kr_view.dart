import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/stock_model.dart';

import 'package:yachtOne/screens/chart/chart_view.dart';
import 'package:yachtOne/screens/stats/stats_view.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

import 'stock_info_kr_view_model.dart';

class StockInfoKRView extends StatelessWidget {
  final StockModel stockModel;
  final double bottomPadding;

  StockInfoKRView({
    Key? key,
    this.bottomPadding = 0.0,
    required this.stockModel,
  }) : super(key: key);
  // static StreamController<double> streamController =
  //     StreamController(onListen: () {
  //   print("Listening");
  // });
  // final ScrollController scrollController;
  // const StockInfoKRView(
  //   this.scrollController,
  //   // required this._issueCode,
  // );
  // static StreamController<double> streamController =
  //     StreamController.broadcast();

  final stockInfoViewModel = Get.put(StockInfoKRViewModel());
  ScrollController _scrollController = ScrollController();
  RxDouble additionalHeight = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    // StreamController streamController = StockInfoKRView.streamController;
    _scrollController = ScrollController(initialScrollOffset: 0);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
    _scrollController.addListener(() {
      // print(_scrollController.offset);
      // streamController.add(_scrollController.offset);
      stockInfoViewModel.offset(_scrollController.offset);

      // stockInfoViewModel.testOffset(_scrollController.offset);
      // stockInfoViewModel.streamController.add(_scrollController.offset);
    });

    // print(scrollController.offset);
    print("stock info view rebuilt");

    // String _issueCode = "005930";
    SizeConfig().init(context);
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
                  stockModel: stockModel,
                ),
              ),
              verticalSpaceExtraLarge,
              Padding(
                padding: kHorizontalPadding,
                child: Text(
                  "삼성전자는?",
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
                child: Center(child: Text("Space for Description")),
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
                child: StatsView(stockModel: stockModel),
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
