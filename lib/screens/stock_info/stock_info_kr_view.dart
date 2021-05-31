import 'package:flutter/material.dart';
import 'package:yachtOne/screens/chart/chart_view.dart';
import 'package:yachtOne/styles/size_config.dart';
import 'package:yachtOne/styles/style_constants.dart';

class StockInfoKrView extends StatelessWidget {
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
              Padding(
                padding: kHorizontalPadding,
                child: Text(
                  "삼성전자",
                  style: headingStyle,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                // height: 250,
                // color: Colors.grey,
                child: Center(child: ChartView()),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: kHorizontalPadding,
                child: Text(
                  "삼성전자는?",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey,
                child: Center(child: Text("Space for Description")),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: kHorizontalPadding,
                child: Text(
                  "뉴스",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey,
                child: Center(child: Text("Space for News")),
              ),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: kHorizontalPadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "기업정보",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      "최근 사업보고서 기준",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey,
                child: Center(child: Text("Space for Stats1")),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey,
                child: Center(child: Text("Space for Stats1")),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey,
                child: Center(child: Text("Space for Stats1")),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey,
                child: Center(child: Text("Space for Stats1")),
              ),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 150,
                color: Colors.grey,
                child: Center(child: Text("Space for Stats1")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
