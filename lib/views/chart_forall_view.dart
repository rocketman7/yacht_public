import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:quiver/iterables.dart' as quiver;

import '../models/chart_model.dart';
import '../models/price_model.dart';
import '../models/season_model.dart';
import '../models/stats_model.dart';
import '../services/timezone_service.dart';
import '../view_models/chart_forall_view_model.dart';

import '../locator.dart';
import 'constants/holiday.dart';
import 'constants/size.dart';

class ChartForAllView extends StatefulWidget {
  final StreamController scrollStreamCtrl;
  final String? issueCode;

  ChartForAllView(
    this.scrollStreamCtrl,
    this.issueCode,
  );
  @override
  _ChartForAllViewState createState() => _ChartForAllViewState();
}

class _ChartForAllViewState extends State<ChartForAllView> {
  List<double>? closeList;
  List<double>? closeChartList;
  List<ChartModel>? priceDataSourceList;
  List<StatsModel>? statsDataSourceList;
  int? priceSubLength;
  int? statsSubLength;
  double displayPrice = 0.0;
  StreamController priceStreamCtrl = StreamController<double>();
  StreamController dateTimeStreamCtrl = StreamController<DateTime>();
  ScrollController? controller;
  StreamController scrollStreamCtrl = StreamController<double>();
  SeasonModel? seasonInfo;
  String? issueCode;
  int choice = 0;

  // 종목 정보 불러올 때 필요한 변수들
  String countryCode = "KR";
  String stockOrIndex = "stocks";

  @override
  void initState() {
    super.initState();
    controller = ScrollController(
      initialScrollOffset: 0,
    );
    controller!.addListener(() {
      scrollStreamCtrl.add(controller!.offset);
      if (controller!.offset < -140) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          controller!.dispose();
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    priceStreamCtrl.close();
    dateTimeStreamCtrl.close();
    super.dispose();
  }

  // format 모음
  var formatPrice = NumberFormat("#,###");
  var formatIndex = NumberFormat("#,###.00");
  var formatPriceUpDown = NumberFormat("+#,###; -#,###");
  var formatIndexUpDown = NumberFormat("+#,##0.00; -#,##0.00");
  var formatPercent = NumberFormat("##.0%");
  var stringDateWithDay = DateFormat("yyyy.MM.dd EEE");
  var stringDate = DateFormat("yyyy.MM.dd");
  var formatReturnPct = new NumberFormat("+0.00%;-0.00%");
  String parseBigNumber(int bigNum) {
    bool isNegative = false;
    if (bigNum < 0) {
      isNegative = true;
    }

    if (bigNum.abs() >= 1000000000000) {
      num mod = bigNum.abs() % 1000000000000;

      return (isNegative ? "-" : "") +
          formatPrice.format((bigNum.abs() / 1000000000000).floor()) +
          "조 " +
          formatPrice.format((mod / 100000000).floor()) +
          "억";
    } else if (bigNum.abs() >= 100000000) {
      return (isNegative ? "-" : "") +
          formatPrice.format((bigNum.abs() / 100000000).floor()) +
          "억";
    } else if (bigNum.abs() >= 10000) {
      return (isNegative ? "-" : "") +
          formatPrice.format((bigNum.abs() / 10000).floor()) +
          "만";
    } else {
      return (isNegative ? "-" : "") + formatPrice.format(bigNum.abs());
    }
  }

  @override
  Widget build(BuildContext context) {
    scrollStreamCtrl = widget.scrollStreamCtrl;
    issueCode = widget.issueCode;

    TextStyle newsTitleStyle = TextStyle(
      fontFamily: 'AppleSDM',
      fontSize: 16,
    );

    return ViewModelBuilder.reactive(
      createNewModelOnInsert: true,
      viewModelBuilder: () => ChartForAllViewModel(
        countryCode,
        stockOrIndex,
        issueCode,
        priceStreamCtrl,
        dateTimeStreamCtrl,
        scrollStreamCtrl,
      ),
      builder: (context, dynamic model, child) {
        if (model.isBusy) {
          return Scaffold(body: Container());
        } else {
          // 뷰모델에서 불러온 ChartModel을 차트의 dataSource로
          priceSubLength = model.chartList.length;
          priceDataSourceList = model.chartList.sublist(
              model.chartList.length - model.priceSubLength,
              model.chartList.length);

          // 뷰모델에서 불러온 종목 정보 모델에서 EPS를 dataSource로
          if (stockOrIndex == "stocks") {
            statsSubLength = model.stockInfoModel.stats.length;
            statsDataSourceList = model.stockInfoModel.stats;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                controller: controller,
                reverse: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Text(widget.vote.subVotes[idx].title,
                              Text(
                                model.stockInfoModel.name,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'AppleSDB',
                                ),
                                maxLines: 1,
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                          StreamBuilder<double>(
                              // 차트에 tap하는 곳의 가격 stream
                              stream: priceStreamCtrl.stream as Stream<double>?,
                              initialData: model.chartList.last.close,
                              builder: (context, snapshot) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stockOrIndex == "stocks"
                                          ? formatPrice
                                              .format(snapshot.data)
                                              .toString()
                                          : formatIndex
                                              .format(snapshot.data)
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontFamily: 'DmSans',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          stockOrIndex == "stocks"
                                              ? formatPriceUpDown
                                                  .format((snapshot.data! -
                                                      priceDataSourceList!
                                                          .first.close!))
                                                  .toString()
                                              : formatIndexUpDown
                                                  .format((snapshot.data! -
                                                      priceDataSourceList!
                                                          .first.close!))
                                                  .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: (snapshot.data! -
                                                        priceDataSourceList!
                                                            .first.close!) <
                                                    0
                                                ? Colors.blue
                                                : (snapshot.data! -
                                                            priceDataSourceList!
                                                                .first.close!) ==
                                                        0
                                                    ? Colors.black
                                                    : Colors.red,
                                            fontFamily: 'AppleSDB',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          "(" +
                                              formatReturnPct
                                                  .format(((snapshot.data! /
                                                          priceDataSourceList!
                                                              .first.close!) -
                                                      1))
                                                  .toString() +
                                              ")",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: (snapshot.data! -
                                                        priceDataSourceList!
                                                            .first.close!) <
                                                    0
                                                ? Colors.blue
                                                : (snapshot.data! -
                                                            priceDataSourceList!
                                                                .first.close!) ==
                                                        0
                                                    ? Colors.black
                                                    : Colors.red,
                                            fontFamily: 'AppleSDB',
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          model.isDaysVisible
                                              ? model.lastDays
                                              : "",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'AppleSDL',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }),
                          StreamBuilder<DateTime>(
                              stream: dateTimeStreamCtrl.stream as Stream<DateTime>?,
                              initialData: strToDate(model.chartList.last.date),
                              builder: (context, snapshot) {
                                return Text(stringDateWithDay
                                    .format(snapshot.data!)
                                    .toString());
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    buildContainerForChart(model),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(4, (index) {
                        return GestureDetector(
                          onTap: () {
                            model.changeDuration(index);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: (deviceWidth! - 10) / 5,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: model.isDurationSelected[index] == true
                                    ? (priceDataSourceList!.last.close! -
                                                priceDataSourceList!
                                                    .first.close!) >
                                            0
                                        ? Colors.red
                                        : (priceDataSourceList!.last.close! -
                                                    priceDataSourceList!
                                                        .first.close!) ==
                                                0
                                            ? Colors.black
                                            : Colors.blue
                                    : Colors.white,
                              ),
                              alignment: Alignment.center,
                              width: 50,
                              height: 30,
                              child: Text(
                                model.durationChoiceString[index],
                                style: TextStyle(
                                  fontFamily: 'AppleSDM',
                                  fontSize: 14,
                                  // height: 1,
                                  textBaseline: TextBaseline.alphabetic,
                                  color: model.isDurationSelected[index] == true
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stockOrIndex == "stocks"
                                ? model.stockInfoModel.descriptionTitle
                                : model.indexInfoModel.descriptionTitle,
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'AppleSDB',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            stockOrIndex == "stocks"
                                ? model.stockInfoModel.description
                                : model.indexInfoModel.description,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'AppleSDM',
                            ),
                            maxLines: model.isSelected ? 100 : 3,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              model.selectDescriptionDetail();
                            },
                            child: Text(
                              model.isSelected ? "간략히" : "더보기",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'AppleSDB',
                                color: Color(0xFF1EC8CF),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 36,
                          ),
                          stockOrIndex == "stocks"
                              ? buildStockNewsTable(model, newsTitleStyle)
                              : buildIndexListedTable(model),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          stockOrIndex == "stocks"
                              ? buildStockInfoTable(model)
                              : buildIndexInfoTable(model),
                          SizedBox(
                            height: 36,
                          ),
                          stockOrIndex == "stocks"
                              ? buildEpsChart()
                              : Container(),
                          SizedBox(
                            height: 36,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Column buildIndexListedTable(model) {
    TextStyle columnTitle = TextStyle(
      color: Color(0xFF8A8A8A),
      fontFamily: 'AppleSDM',
      fontSize: 14,
    );

    TextStyle columnContent = TextStyle(
      color: Colors.black,
      fontFamily: 'AppleSDM',
      fontSize: 16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "지수 상위 10종목",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'AppleSDB',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Table(
          columnWidths: {
            0: FlexColumnWidth(5.5),
            1: FlexColumnWidth(4.0),
            2: FlexColumnWidth(2.0),
          },
          children: [
            TableRow(children: [
              Text(
                "종목명",
                style: columnTitle,
              ),
              Text(
                "시가총액",
                style: columnTitle,
              ),
              Text(
                "비중",
                style: columnTitle,
              ),
            ]),
            TableRow(children: [
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 12,
              )
            ]),
            TableRow(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  model.indexInfoModel.topListed.length,
                  (index) => Column(
                    children: [
                      Text(
                        model.indexInfoModel.topListed[index].name.toString(),
                        style: columnContent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  model.indexInfoModel.topListed.length,
                  (index) => Column(
                    children: [
                      Text(
                        parseBigNumber(
                            model.indexInfoModel.topListed[index].marketCap),
                        style: columnContent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  model.indexInfoModel.topListed.length,
                  (index) => Column(
                    children: [
                      Text(
                        formatPercent
                            .format(
                                model.indexInfoModel.topListed[index].weight)
                            .toString(),
                        style: columnContent,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ],
    );
  }

  Column buildIndexInfoTable(
    model,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "지수정보",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'AppleSDB',
              ),
            ),
            Text(
              "",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'AppleSDM',
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "기준일자",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontFamily: 'AppleSDM',
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          stringDate
                              .format(
                                  model.indexInfoModel.indexBaseDate.toDate())
                              .toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "기준지수",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          formatIndex
                              .format(model.indexInfoModel.indexBasePoint)
                              .toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "구성 주식수",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          formatPrice
                                  .format(model.indexInfoModel.numOfListed)
                                  .toString() +
                              " 개",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "산출방법",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          model.indexInfoModel.methodology.toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column buildStockNewsTable(model, TextStyle newsTitleStyle) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "뉴스",
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'AppleSDB',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
              children:
                  List.generate(model.stockInfoModel.news.length, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    String url = model.stockInfoModel.news[index].link;
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text(
                    model.stockInfoModel.news[index].title.toString(),
                    style: newsTitleStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Divider(),
              ],
            );
          })),
        ]);
  }

  Column buildStockInfoTable(model) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "기업정보",
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'AppleSDB',
              ),
            ),
            Text(
              "최근 사업보고서 기준",
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'AppleSDM',
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        // 직전년도 재무정보
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "매출액",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          parseBigNumber(model.stockInfoModel.revenue),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "영업이익",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          parseBigNumber(model.stockInfoModel.operatingIncome),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "당기순이익",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          parseBigNumber(model.stockInfoModel.netIncome),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "EPS",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          formatPrice.format(model.stockInfoModel.latestEps),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 32,
        ),
        // 각종 기업정보
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "CEO",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          model.stockInfoModel.ceo.toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "설립연도",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          model.stockInfoModel.foundedIn.toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "평균 연봉",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          parseBigNumber(model.stockInfoModel.avrSalary),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "평균 근속년수",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          model.stockInfoModel.avrWorkingYears.toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "직원수",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          formatPrice.format(model.stockInfoModel.employees) +
                              "명",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(width: 0.5, color: Color(0xFF8A8A8A)),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "신용등급",
                          style: TextStyle(
                            color: Color(0xFF8A8A8A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          model.stockInfoModel.credit,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column buildEpsChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Text(
          "EPS(주당 순이익)",
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'AppleSDB',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: deviceHeight! * 0.23,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            series: <ChartSeries>[
              ScatterSeries<StatsModel, String>(
                color: Color(0xFFFF5959).withOpacity(.3),
                dataSource: statsDataSourceList!,
                xValueMapper: (StatsModel stats, _) => stats.announcedAt == null
                    ? null
                    : stats.announcedAt!.replaceAll("\\n", "\n"),
                yValueMapper: (StatsModel stats, _) => stats.expectedEps,
                markerSettings: MarkerSettings(
                  width: 16,
                  height: 16,
                ),
              ),
              ScatterSeries<StatsModel, String>(
                color: Color(0xFFFF5959),
                dataSource: statsDataSourceList!,
                xValueMapper: (StatsModel stats, _) =>
                    stats.announcedAt!.replaceAll("\\n", "\n"),
                yValueMapper: (StatsModel stats, _) => stats.actualEps,
                markerSettings: MarkerSettings(
                  width: 16,
                  height: 16,
                ),
              ),
            ],
            primaryXAxis: CategoryAxis(
              labelStyle: TextStyle(
                fontFamily: 'AppleSDM',
                color: Colors.black,
              ),
              axisLine: AxisLine(
                width: 0,
              ),
              majorTickLines: MajorTickLines(
                width: 0,
              ),
              majorGridLines: MajorGridLines(
                width: 0,
              ),
            ),
            primaryYAxis: NumericAxis(
              labelAlignment: LabelAlignment.center,
              numberFormat: NumberFormat('#,###'),
              labelStyle: TextStyle(
                fontFamily: 'AppleSDM',
                color: Colors.black,
              ),
              axisLine: AxisLine(
                width: 0,
              ),
              majorTickLines: MajorTickLines(
                width: 0,
              ),
              majorGridLines: MajorGridLines(
                width: 0,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Text("추정 EPS"),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF5959).withOpacity(.3),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  Text("실제 EPS"),
                  SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF5959),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Container buildContainerForChart(model) {
    return Container(
      height: deviceHeight! * 0.23,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        margin: EdgeInsets.all(0),
        legend: Legend(isVisible: false),
        trackballBehavior: TrackballBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: InteractiveTooltip(format: ''),
        ),
        onTrackballPositionChanging: (TrackballArgs args) =>
            model.trackball(args),
        onChartTouchInteractionUp: (ChartTouchInteractionArgs args) =>
            model.whenTrackEnd(),
        series: <ChartSeries>[
          FastLineSeries<ChartModel, DateTime>(
            dataSource: priceDataSourceList!,
            emptyPointSettings: EmptyPointSettings(
              mode: EmptyPointMode.gap,
            ),
            color: (priceDataSourceList!.last.close! -
                        priceDataSourceList!.first.close!) >
                    0
                ? Colors.red
                : (priceDataSourceList!.last.close! -
                            priceDataSourceList!.first.close!) ==
                        0
                    ? Colors.black
                    : Colors.blue,
            enableTooltip: true,
            xValueMapper: (ChartModel chart, _) => strToDate(chart.date!),
            yValueMapper: (ChartModel chart, _) => chart.close,
          )
        ],
        primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(
            width: 0,
          ),
          isVisible: false,
          minimum: (quiver.min(
                List.generate(priceDataSourceList!.length, (index) {
                  return priceDataSourceList![index].close;
                }),
              )! *
              0.97),
          maximum: (quiver.max(List.generate(priceDataSourceList!.length,
                  (index) => priceDataSourceList![index].close))! *
              1.03),
        ),
        primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(
              width: 0,
            ),
            isVisible: false),
      ),
    );
  }
}
