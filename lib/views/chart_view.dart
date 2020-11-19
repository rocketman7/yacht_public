import 'dart:async';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/models/chart_model.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/view_models/chart_view_model.dart';
import 'package:quiver/iterables.dart' as quiver;
import 'dart:math';
import 'package:rxdart/rxdart.dart';

import 'constants/holiday.dart';
import 'constants/size.dart';
import 'loading_view.dart';

class ChartView extends StatefulWidget {
  // final ScrollController controller;
  final StreamController scrollStreamCtrl;
  final List<bool> selected;
  final int idx;
  final int numSelected;
  VoteModel vote;
  // final Function showToast;

  ChartView(
    // this.controller,
    this.scrollStreamCtrl,
    this.selected,
    this.idx,
    this.numSelected,
    this.vote,
    // this.showToast,
  );
  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  List<double> closeList;
  List<double> closeChartList;
  List<ChartModel> priceDataSourceList;
  List<StatsModel> statsDataSourceList;
  int priceSubLength;
  int statsSubLength;
  double displayPrice = 0.0;
  BehaviorSubject behaviorCtrl = BehaviorSubject<double>();
  StreamController priceStreamCtrl = StreamController<double>();
  StreamController dateTimeStreamCtrl = StreamController<DateTime>();
  ScrollController controller;
  StreamController scrollStreamCtrl = StreamController<double>();
  List<bool> selected;
  int idx;
  int numSelected;
  String issueCode;
  int choice = 0;
  Function _showToast;

  double _lastValue = 0.0;

  // 종목 정보 불러올 때 필요한 변수들

  String countryCode = "KR";
  //  issueCode = '005930';
  // 종목 대결일 때
  int numOfIssueCodes = 2;

  @override
  void initState() {
    // issueCode = widget.vote.subVotes[idx].issueCode[choice];
    super.initState();
    print(issueCode);
    controller = ScrollController(
      initialScrollOffset: 0,
    );
    // Duration timestamp = Duration(milliseconds: 400);
    controller.addListener(() {
      // setState(() {
      // print(controller.offset);
      scrollStreamCtrl.add(controller.offset);
      if (controller.offset < -170) {
        print("triggered");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          print("addPostFramecalled");
          // controller.removeListener(() {});
          controller.dispose();
          print("disposed");
        });
      }
      // });
    });

    // print(position);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // displayPrice.close();
    // controller.dispose();
    priceStreamCtrl.close();
    dateTimeStreamCtrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // controller = widget.controller;
    scrollStreamCtrl = widget.scrollStreamCtrl;
    selected = widget.selected;
    idx = widget.idx;
    numSelected = widget.numSelected;
    issueCode = widget.vote.subVotes[idx].issueCode[0];
    print("ISSUECODE " + issueCode);

    // _showToast = widget.showToast;

    var formatPrice = NumberFormat("+#,###; -#,###");
    var stringDate = DateFormat("yyyy.MM.dd EEE");
    var formatReturnPct = new NumberFormat("+0.00%;-0.00%");

    TextStyle newsTitleStyle = TextStyle(
      fontFamily: 'AppleSDM',
      fontSize: 18,
    );

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => ChartViewModel(
        countryCode,
        issueCode,
        priceStreamCtrl,
        behaviorCtrl,
        dateTimeStreamCtrl,
        scrollStreamCtrl,
      ),
      builder: (context, model, child) {
        if (model.isBusy) {
          return Scaffold(body: Container());
        } else {
          behaviorCtrl.listen(print);

          // closeList = model.chartList.forEach((element) {
          //   return element.close;
          // });

          // 뷰모델에서 불러온 ChartModel을 차트의 dataSource로
          priceSubLength = model.chartList.length;
          priceDataSourceList = model.chartList.sublist(
              model.chartList.length - model.priceSubLength,
              model.chartList.length - 1);

          // 뷰모델에서 불러온 종목 정보 모델에서 EPS를 dataSource로
          statsSubLength = model.stockInfoModel.stats.length;
          statsDataSourceList = model.stockInfoModel.stats;

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
                        // height: 40,
                        // color: Colors.amber,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Container(
                            //   width: 50,
                            //   height: 5,
                            //   decoration: BoxDecoration(
                            //     color: Colors.black,
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(10)),
                            //   ),
                            //   // child: SizedBox(),
                            // )

                            // GestureDetector(
                            //   onTap: () {
                            //     Navigator.pop(context);
                            //   },
                            //   child: Icon(
                            //     Icons.cancel_outlined,
                            //     size: 40,
                            //   ),
                            // ),
                          ],
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
                            children: [
                              Text(
                                widget.vote.subVotes[idx].selectDescription
                                    .replaceAll("\\n", "\n"),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'AppleSDM',
                                  color: Colors.grey[800],
                                ),
                              ),
                              (!selected[idx])
                                  ? Container()
                                  : Expanded(
                                      child: RaisedButton(
                                        onPressed: () {
                                          setState(() {
                                            selected[idx] = false;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        color: Color(0xFF0F6669),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 14,
                                        ),
                                        child:
                                            // (model.address.isVoting == false)
                                            //     ? SizedBox()
                                            //     :

                                            Text("해제하기",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: 'DmSans',
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                )),
                                      ),
                                    ),
                              (selected[idx])
                                  ? Container()
                                  : RaisedButton(
                                      onPressed: () {
                                        // (model.address.isVoting == false)
                                        //     ? {}
                                        //     : setState(() {
                                        //         if (model.seasonInfo
                                        //                     .maxDailyVote -
                                        //                 numSelected ==
                                        //             0) {
                                        //           _showToast(
                                        //               "하루 최대 ${model.seasonInfo.maxDailyVote}개 주제를 예측할 수 있습니다.");
                                        //         } else {
                                        //           if (model.user.item -
                                        //                   numSelected ==
                                        //               0) {
                                        //             // 선택되면 안됨

                                        //             _showToast(
                                        //                 "보유 중인 아이템이 부족합니다.");
                                        //           } else {
                                        //             selected[idx] = true;
                                        //             Navigator.of(context).pop();
                                        //           }
                                        //         }
                                        //       });
                                      },
                                      // color: (model.address.isVoting == false)
                                      //     ? Color(0xFFE4E4E4)
                                      //     : Color(0xFF1EC8CF),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        // vertical: 8,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // (model.address.isVoting == false)
                                          //     ? SizedBox()
                                          // :
                                          SvgPicture.asset(
                                            'assets/icons/double_check_icon.svg',
                                            width: 20,
                                          ),
                                          // (model.address.isVoting == false)
                                          //     ? SizedBox()
                                          // :
                                          SizedBox(width: 8),
                                          Text(
                                              // model.address.isVoting == false
                                              //     ? "오늘 예측이 마감되었습니다."
                                              // :
                                              "선택하기",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color:
                                                    // (model.address.isVoting ==
                                                    //         false)
                                                    //     ? Colors.black
                                                    // :
                                                    Colors.white,
                                                fontFamily: 'AppleSDM',
                                                height: 1,
                                                fontWeight: FontWeight.w700,
                                              )),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                model.stockInfoModel.name,
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'AppleSDB',
                                ),
                              ),
                              Text(
                                "VS   LG전자",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFF8A8A8A),
                                  fontFamily: 'AppleSDB',
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder<double>(
                              stream: priceStreamCtrl.stream,
                              initialData: model.chartList.last.close,
                              builder: (context, snapshot) {
                                var prevPrice = behaviorCtrl.listen((value) {
                                  return value;
                                });

                                prevPrice.onData((data) {
                                  print(data);
                                });

                                // print("PREV " + prevSnapshot.data.toString());
                                // print("NOW " + snapshot.data.toString());
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Countup(
                                      begin: snapshot.data,
                                      end: snapshot.data,
                                      duration: Duration(
                                        milliseconds: 300,
                                      ),
                                      // prefix: "₩",
                                      separator: ",",
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontFamily: 'DmSans',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          formatPrice
                                              .format((snapshot.data -
                                                  priceDataSourceList
                                                      .first.close))
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: (snapshot.data -
                                                        priceDataSourceList
                                                            .first.close) <
                                                    0
                                                ? Colors.blue
                                                : (snapshot.data -
                                                            priceDataSourceList
                                                                .first.close) ==
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
                                                  .format(((snapshot.data /
                                                          priceDataSourceList
                                                              .first.close) -
                                                      1))
                                                  .toString() +
                                              ")",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: (snapshot.data -
                                                        priceDataSourceList
                                                            .first.close) <
                                                    0
                                                ? Colors.blue
                                                : (snapshot.data -
                                                            priceDataSourceList
                                                                .first.close) ==
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

                                // Text(
                                //   snapshot.data == null
                                //       ? "₩" +
                                //           formatPrice
                                //               .format(model.chartList.last.close)
                                //               .toString()
                                //       : "₩" +
                                //           formatPrice
                                //               .format(snapshot.data)
                                //               .toString(),
                                //   style: TextStyle(
                                //     fontSize: 28,
                                //     fontFamily: 'AppleSDB',
                                //   ),
                                // );
                              }),
                          StreamBuilder<DateTime>(
                              stream: dateTimeStreamCtrl.stream,
                              initialData: strToDate(model.chartList.last.date),
                              builder: (context, snapshot) {
                                return Text(stringDate
                                    .format(snapshot.data)
                                    .toString());
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Container(
                      // color: Colors.red,
                      height: deviceHeight * 0.23,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        margin: EdgeInsets.all(0),
                        // primaryXAxis: CategoryAxis(),
                        // Chart title
                        // title: ChartTitle(
                        //     text: 'Tesla this week',
                        //     textStyle: TextStyle(
                        //       fontSize: 24,
                        //     )),
                        // Enable legend
                        legend: Legend(isVisible: false),
                        // Enable tooltip
                        // tooltipBehavior: TooltipBehavior(enable: true),
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          activationMode: ActivationMode.longPress,
                          tooltipSettings: InteractiveTooltip(
                              // Formatting trackball tooltip text
                              format: ''),
                        ),

                        onTrackballPositionChanging: (TrackballArgs args) =>
                            model.trackball(args),

                        onChartTouchInteractionUp:
                            (ChartTouchInteractionArgs args) =>
                                model.whenTrackEnd(args),

                        // onChartTouchInteractionDown:
                        //     (ChartTouchInteractionArgs args) =>
                        //         model.whenTrackStart(args),
                        series: <ChartSeries>[
                          // LIVE 일 때,
                          model.isDurationSelected[0] == true
                              ? FastLineSeries<ChartModel, DateTime>(
                                  dataSource: null,
                                  xValueMapper: null,
                                  yValueMapper: null)
                              : FastLineSeries<ChartModel, DateTime>(
                                  color: (priceDataSourceList.last.close -
                                              priceDataSourceList.first.close) >
                                          0
                                      ? Colors.red
                                      : (priceDataSourceList.last.close -
                                                  priceDataSourceList
                                                      .first.close) ==
                                              0
                                          ? Colors.black
                                          : Colors.blue,

                                  // animationDuration: 10000,
                                  // splineType: SplineType.cardinal,
                                  // cardinalSplineTension: 0.3,

                                  enableTooltip: true,
                                  dataSource: priceDataSourceList,
                                  // <ChartModel>[

                                  xValueMapper: (ChartModel chart, _) =>
                                      strToDate(chart.date),
                                  yValueMapper: (ChartModel chart, _) =>
                                      chart.close,
                                  // animationDuration: 1000,
                                )
                        ],
                        primaryYAxis: NumericAxis(
                          majorGridLines: MajorGridLines(
                            width: 0,
                          ),
                          isVisible: false,
                          minimum: (quiver.min(
                                List.generate(priceDataSourceList.length,
                                    (index) {
                                  // print(model.chartList[index].close);
                                  return priceDataSourceList[index].close;
                                }),
                              ) *
                              0.97),
                          maximum: (quiver.max(List.generate(
                                  priceDataSourceList.length,
                                  (index) =>
                                      priceDataSourceList[index].close)) *
                              1.03),
                        ),
                        primaryXAxis: DateTimeAxis(
                          majorGridLines: MajorGridLines(
                            width: 0,
                          ),
                          isVisible: false,
                          // minimum:
                          //     strToDate(model.chartList.last.date).add(Duration(
                          //   days: -90,
                          // )),
                          // maximum: strToDate(model.chartList.last.date),
                        ),
                        // 봉 차트
                        // series: <CandleSeries<ChartModel, String>>[
                        //   CandleSeries<ChartModel, String>(
                        //       bullColor: Colors.red,
                        //       bearColor: Colors.blue,
                        //       dataSource: List.generate(model.chartList.length,
                        //           (index) => model.chartList[index]),
                        //       // <ChartModel>[
                        //       //   // _SalesData(model.chartList[0].date, 445.74, 446.60,
                        //       //   //     428.93, 430.83),
                        //       //   model.chartList[0],
                        //       //   // _SalesData('10/21', 423.25, 432.90, 421.25, 422.64),
                        //       //   // _SalesData('10/22', 442.15, 444.74, 424.72, 431.59),
                        //       //   // _SalesData('10/23', 449.74, 465.75, 447.77, 461.30),
                        //       //   // _SalesData('10/24', 469.74, 490.75, 468.77, 480.30),
                        //       // ],
                        //       xValueMapper: (ChartModel chart, _) => chart.date,
                        //       lowValueMapper: (ChartModel chart, _) =>
                        //           chart.low,
                        //       highValueMapper: (ChartModel chart, _) =>
                        //           chart.high,
                        //       openValueMapper: (ChartModel chart, _) =>
                        //           chart.open,
                        //       closeValueMapper: (ChartModel chart, _) =>
                        //           chart.close,
                        //       enableSolidCandles: true,

                        //       // yValueMapper: (_SalesData sales, _) => sales.sales,
                        //       // Enable data label
                        //       dataLabelSettings:
                        //           DataLabelSettings(isVisible: false))
                        // ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            model.changeDuration(index);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            // color: Colors.amber,
                            width: (deviceWidth - 10) / 5,
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: model.isDurationSelected[index] == true
                                    ? (priceDataSourceList.last.close -
                                                priceDataSourceList
                                                    .first.close) >
                                            0
                                        ? Colors.red
                                        : (priceDataSourceList.last.close -
                                                    priceDataSourceList
                                                        .first.close) ==
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
                      })
                      // GestureDetector(
                      //   // color: Colors.black,
                      //   onTap: () {
                      //     model.changeDuration(0);
                      //   },
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     color: Colors.blue,
                      //     width: 60,
                      //     height: 40,
                      //     child: Text(
                      //       "2주",
                      //       style: TextStyle(

                      //           // color: Colors.white,
                      //           ),
                      //     ),
                      //   ),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     model.changeDuration(1);
                      //   },
                      //   child: Text("1개월"),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     model.changeDuration(2);
                      //   },
                      //   child: Text("3개월"),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     model.changeDuration(3);
                      //   },
                      //   child: Text("6개월"),
                      // ),
                      // GestureDetector(
                      //   onTap: () {
                      //     model.changeDuration(4);
                      //   },
                      //   child: Text("1년"),
                      // ),
                      ,
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
                            model.stockInfoModel.descriptionTitle,
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'AppleSDB',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            model.stockInfoModel.description,
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
                            height: 32,
                          ),
                          Text(
                            "EPS (주당 순이익)",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'AppleSDB',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: deviceHeight * 0.23,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,
                        series: <ChartSeries>[
                          ScatterSeries<StatsModel, String>(
                            color: Color(0xFf99E99B),
                            dataSource: statsDataSourceList,
                            xValueMapper: (StatsModel stats, _) =>
                                stats.announcedAt.replaceAll("\\n", "\n"),
                            yValueMapper: (StatsModel stats, _) =>
                                stats.expectedEps,
                            markerSettings: MarkerSettings(
                              width: 20,
                              height: 20,
                            ),
                          ),
                          ScatterSeries<StatsModel, String>(
                            color: Color(0xFF00C802),
                            dataSource: statsDataSourceList,
                            xValueMapper: (StatsModel stats, _) =>
                                stats.announcedAt.replaceAll("\\n", "\n"),
                            yValueMapper: (StatsModel stats, _) =>
                                stats.actualEps,
                            markerSettings: MarkerSettings(
                              width: 20,
                              height: 20,
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
                          // minorGridLines: MinorGridLines(width: 0,),
                          // isVisible: false,
                        ),
                        primaryYAxis: NumericAxis(
                          labelStyle: TextStyle(
                            fontFamily: 'AppleSDM',
                            color: Colors.black,
                          ),
                          interval: 1000,
                          axisLine: AxisLine(
                            width: 0,
                          ),
                          majorTickLines: MajorTickLines(
                            width: 0,
                          ),
                          majorGridLines: MajorGridLines(
                            width: 0,
                          ),

                          minimum: 2000, // null값 무시하고 min 구해야 함

                          // minimum: (quiver.min(
                          //       List.generate(statsDataSourceList.length,
                          //           (index) {
                          //         // print(model.chartList[index].close);
                          //         return min(
                          //             statsDataSourceList[index].actualEps,
                          //             statsDataSourceList[index].expectedEps);
                          //       }),
                          //     ) *
                          //     0.80),
                          // maximum: (quiver.max(
                          //       List.generate(statsDataSourceList.length,
                          //           (index) {
                          //         // print(model.chartList[index].close);
                          //         return max(
                          //             statsDataSourceList[index].actualEps,
                          //             statsDataSourceList[index].expectedEps);
                          //       }),
                          //     ) *
                          //     1.20),
                          // isVisible: false,
                        ),

                        // isVisible: false,
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "기업정보",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'AppleSDB',
                                  // height: 1,
                                ),
                              ),
                              Text(
                                "최근 사업보고서 기준",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'AppleSDM',
                                  // height: 1,
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "매출액",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            model.stockInfoModel.revenue
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "영업이익",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            model.stockInfoModel.operatingIncome
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "당기순이익",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            model.stockInfoModel.netIncome
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "EPS",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            model.stockInfoModel.latestEps
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "직원수",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            model.stockInfoModel.employees
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "평균 연봉",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            model.stockInfoModel.avrSalary
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "평균 근속년수",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            model.stockInfoModel.avrWorkingYears
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "설립연도",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            model.stockInfoModel.foundedIn
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
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 0.5,
                                              color: Color(0xFF8A8A8A)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            // model.stockInfoModel.avrWorkingYears
                                            //     .toString()
                                            "",
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
                            height: 36,
                          ),

                          Text(
                            "뉴스",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'AppleSDB',
                              // height: 1,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                              children: List.generate(2, (index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    String url =
                                        model.stockInfoModel.news[index].link;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  child: Text(
                                    model.stockInfoModel.news[index].title
                                        .toString(),
                                    style: newsTitleStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Divider(),
                              ],
                            );
                          })),

                          // Text(dateToStr(model
                          //         .stockInfoModel.stats[0].uploadedAt
                          //         .toDate())
                          //     .toString()),
                          // Text(DateTime.fromMillisecondsSinceEpoch(
                          //         model.stockInfoModel.stats[0].uploadedAt)
                          //     .toString()),
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
}
