import 'package:flutter/material.dart';
import 'package:yachtOne/screens/chart/chart_view.dart';
import 'package:yachtOne/screens/stats/revenue/revenue_view.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

class StockInfoKrView extends StatelessWidget {
  String _issueCode = "005930";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                child: Center(child: ChartView(issueCode: _issueCode)),
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
              Padding(
                padding: kHorizontalPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "기업정보",
                      style: subtitleStyle.copyWith(color: Colors.black),
                    ),
                    Text(
                      "최근 사업보고서 기준",
                      style: contentStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: kHorizontalPadding,
                child: Text("매출액"),
              ),
              Container(
                width: double.infinity,
                height: 150,
                // color: Colors.grey,
                child: RevenueView(),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                // color: Colors.grey,
                child: Center(child: Text("Space for ColumnChart2")),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                // color: Colors.grey,
                child: Center(child: Text("Space for ColumnChart3")),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                // color: Colors.grey,
                child: Center(child: Text("Space for ColumnChart4")),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                // color: Colors.grey,
                child: Center(child: Text("Space for ColumnChart5")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
