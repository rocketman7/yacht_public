import 'dart:async';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:yachtOne/models/chart_model.dart';
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
  // final Function showToast;

  ChartView(
    // this.controller,
    this.scrollStreamCtrl,
    this.selected,
    this.idx,
    this.numSelected,
    // this.showToast,
  );
  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  List<double> closeList;
  List<double> closeChartList;
  List<ChartModel> dataSourceList;
  int subLength;
  double displayPrice = 0.0;
  BehaviorSubject behaviorCtrl = BehaviorSubject<double>();
  StreamController priceStreamCtrl = StreamController<double>();
  StreamController dateTimeStreamCtrl = StreamController<DateTime>();
  ScrollController controller;
  StreamController scrollStreamCtrl = StreamController<double>();
  List<bool> selected;
  int idx;
  int numSelected;
  Function _showToast;

  double _lastValue = 0.0;

  // 종목 정보 불러올 때 필요한 변수들
  String issueCode = "005930";
  String countryCode = "KR";

  // 종목 대결일 때
  int numOfIssueCodes = 2;

  @override
  void initState() {
    controller = ScrollController(
      initialScrollOffset: 0,
    );

    controller.addListener(() {
      setState(() {
        // print(controller.offset);
        scrollStreamCtrl.add(controller.offset);
      });
    });

    // print(position);
    super.initState();
  }

  @override
  void dispose() {
    // displayPrice.close();
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
    // _showToast = widget.showToast;

    var formatPrice = NumberFormat("+#,###; -#,###");
    var stringDate = DateFormat("yyyy.MM.dd EEE");
    var formatReturnPct = new NumberFormat("+0.00%; -0.00%");

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
          closeList = model.chartList.forEach((element) {
            return element.close;
          });
          subLength = model.chartList.length;

          dataSourceList = model.chartList.sublist(
              model.chartList.length - model.subLength,
              model.chartList.length - 1);

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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.cancel_outlined,
                                size: 40,
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
                                        borderRadius: BorderRadius.circular(30),
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 26.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "영원한 라이벌 두 기업의\n오늘 수익률 대결은?",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'AppleSDM',
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "삼성전자",
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
                                                  dataSourceList.first.close))
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: (snapshot.data -
                                                        dataSourceList
                                                            .first.close) <
                                                    0
                                                ? Colors.blue
                                                : (snapshot.data -
                                                            dataSourceList
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
                                                          dataSourceList
                                                              .first.close) -
                                                      1))
                                                  .toString() +
                                              ")",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: (snapshot.data -
                                                        dataSourceList
                                                            .first.close) <
                                                    0
                                                ? Colors.blue
                                                : (snapshot.data -
                                                            dataSourceList
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
                      height: deviceHeight * 0.23,
                      child: SfCartesianChart(
                        plotAreaBorderWidth: 0,

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
                          FastLineSeries<ChartModel, DateTime>(
                            color: (dataSourceList.last.close -
                                        dataSourceList.first.close) >
                                    0
                                ? Colors.red
                                : (dataSourceList.last.close -
                                            dataSourceList.first.close) ==
                                        0
                                    ? Colors.black
                                    : Colors.blue,

                            // animationDuration: 10000,
                            // splineType: SplineType.cardinal,
                            // cardinalSplineTension: 0.3,

                            enableTooltip: true,
                            dataSource: dataSourceList,
                            // <ChartModel>[

                            xValueMapper: (ChartModel chart, _) =>
                                strToDate(chart.date),
                            yValueMapper: (ChartModel chart, _) => chart.close,
                            // animationDuration: 1000,
                          )
                        ],
                        primaryYAxis: NumericAxis(
                          majorGridLines: MajorGridLines(
                            width: 0,
                          ),
                          isVisible: false,
                          minimum: (quiver.min(
                                List.generate(dataSourceList.length, (index) {
                                  // print(model.chartList[index].close);
                                  return dataSourceList[index].close;
                                }),
                              ) *
                              0.97),
                          maximum: (quiver.max(List.generate(
                                  dataSourceList.length,
                                  (index) => dataSourceList[index].close)) *
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
                      children: [
                        FlatButton(
                          onPressed: () {
                            model.changeDuration(10, "");
                          },
                          child: Text("2주"),
                          minWidth: 20,
                        ),
                        FlatButton(
                          onPressed: () {
                            model.changeDuration(20, "지난 1개월");
                          },
                          child: Text("1개월"),
                          minWidth: 20,
                        ),
                        FlatButton(
                          onPressed: () {
                            model.changeDuration(60, "지난 3개월");
                          },
                          child: Text("3개월"),
                          minWidth: 20,
                        ),
                        FlatButton(
                          onPressed: () {
                            model.changeDuration(120, "지난 6개월");
                          },
                          child: Text("6개월"),
                          minWidth: 20,
                        ),
                        FlatButton(
                          onPressed: () {
                            model.changeDuration(200, "지난 1년");
                          },
                          child: Text("1년"),
                          minWidth: 20,
                        ),
                      ],
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
                            "시세정보",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'AppleSDB',
                            ),
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
                                            "거래량",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "20,424,749",
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
                                            "시가총액",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "342.6조 원",
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
                                            "EPS",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "3,198원",
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
                                            "PER",
                                            style: TextStyle(
                                              color: Color(0xFF8A8A8A),
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "18.87X",
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
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: Container(
                              //         padding:
                              //             EdgeInsets.symmetric(vertical: 16),
                              //         decoration: BoxDecoration(
                              //           border: Border(
                              //             bottom: BorderSide(
                              //                 width: 0.5,
                              //                 color: Color(0xFF8A8A8A)),
                              //           ),
                              //         ),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               "거래량",
                              //               style: TextStyle(
                              //                 color: Color(0xFF8A8A8A),
                              //                 fontSize: 14,
                              //               ),
                              //             ),
                              //             Text(
                              //               "20,424,749",
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 20,
                              //     ),
                              //     Expanded(
                              //       child: Container(
                              //         padding:
                              //             EdgeInsets.symmetric(vertical: 16),
                              //         decoration: BoxDecoration(
                              //           border: Border(
                              //             bottom: BorderSide(
                              //                 width: 0.5,
                              //                 color: Color(0xFF8A8A8A)),
                              //           ),
                              //         ),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Text(
                              //               "시가총액",
                              //               style: TextStyle(
                              //                 color: Color(0xFF8A8A8A),
                              //                 fontSize: 14,
                              //               ),
                              //             ),
                              //             Text(
                              //               "342.6조 원",
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                          SizedBox(
                            height: 36,
                          ),
                          Text(
                            "삼성전자는?",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'AppleSDB',
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "크게 반도체, LCD, 휴대폰, 가전 부문으로 사업부가 나뉘었으나 2008년부터 2009년까지 불어닥친 글로벌 경제 위기에 대응해 반도체와 LCD로 대표되는 부품 부문과 TV와 휴대폰, 냉장고로 대표되는 완제품 부문으로 사업부를 통합했다. 분야가 완전히 달랐던 삼성테크윈의 디지털 카메라 부문과 삼성SDI의 플래시 메모리, 낸드플래시도 통합되었고 그 외 삼성전기 LED 사업부도 통합되었다.",
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
