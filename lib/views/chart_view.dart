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
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/view_models/chart_view_model.dart';
import 'package:quiver/iterables.dart' as quiver;
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:yachtOne/view_models/vote_select_view_model.dart';

import '../locator.dart';
import 'constants/holiday.dart';
import 'constants/size.dart';
import 'loading_view.dart';

class ChartView extends StatefulWidget {
  // final ScrollController controller;
  final StreamController scrollStreamCtrl;
  final List<bool> selected;
  final int idx;
  final int numSelected;
  final VoteModel vote;
  final SeasonModel seasonInfo;
  final DatabaseAddressModel address;
  final UserModel user;
  final Function selectUpdate;
  final Function showToast;

  ChartView(
    // this.controller,
    this.scrollStreamCtrl,
    this.selected,
    this.idx,
    this.numSelected,
    this.vote,
    this.seasonInfo,
    this.address,
    this.user,
    this.selectUpdate,
    this.showToast,
  );
  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  // DateTime temp = DateTime.now().add(duration);

  DatabaseAddressModel address;
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
  SeasonModel seasonInfo;
  UserModel user;
  int idx;
  int numSelected;
  String issueCode;
  int choice = 0;
  Function _showToast;

  double _lastValue = 0.0;

  // 실시간 가격 데이터 리스트
  List<PriceModel> realtimePriceDataSourceList;
  Stream<List<PriceModel>> tempStream;
  DatabaseService _databaseService = locator<DatabaseService>();
  DateTime liveToday;
  // 종목 정보 불러올 때 필요한 변수들

  int numOfChoices;
  int indexChosen = 0;
  String countryCode = "KR";
  String stockOrIndex;

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
      if (controller.offset < -140) {
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

    //차트 기간 설정 바꿀 때마다 Streambuilder가 리빌드 되면서 그 안에 model.stream 매번 다시 콜되고
    //그러면 데이터를 받아오면서 setState가 됨 -> 차트 애니메이션이 끊기게 됨.
    // 이를 방지하고자 initState에 stream을 설정해주고 아래 Live를 위한 StreamBuilder에서
    // 이 스트림을 불러옴. 이러면 스트림을 다시 콜하지 않음.
    // tempStream = _databaseService.getRealtimePriceForChart(issueCode);
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

  // void rebuildAllChildren(BuildContext context) {
  //   void rebuild(Element el) {
  //     el.markNeedsBuild();
  //     el.visitChildren(rebuild);
  //   }

  //   (context as Element).visitChildren(rebuild);
  // }
  // format 모음
  var formatPrice = NumberFormat("#,###");
  var formatIndex = NumberFormat("#,###.00");
  var formatPriceUpDown = NumberFormat("+#,###; -#,###");
  var formatIndexUpDown = NumberFormat("+#,###.00; -#,###.00");
  var formatPercent = NumberFormat("##.0%");
  var stringDateWithDay = DateFormat("yyyy.MM.dd EEE");
  var stringDate = DateFormat("yyyy.MM.dd");
  var formatReturnPct = new NumberFormat("+0.00%;-0.00%");
  String parseBigNumber(int bigNum) {
    // num n;
    bool isNegative = false;
    if (bigNum < 0) {
      isNegative = true;
    }
    // n = num.parse(n.toStringAsFixed(2));

    if (bigNum.abs() >= 1000000000000) {
      num mod = bigNum.abs() % 1000000000000;

      return (isNegative ? "-" : "") +
          formatPrice.format((bigNum.abs() / 1000000000000).round()) +
          "조 " +
          formatPrice.format((mod / 100000000).round()) +
          "억";
    } else if (bigNum.abs() >= 100000000) {
      return (isNegative ? "-" : "") +
          formatPrice.format((bigNum.abs() / 100000000).round()) +
          "억";
    } else if (bigNum.abs() >= 10000) {
      return (isNegative ? "-" : "") +
          formatPrice.format((bigNum.abs() / 10000).round()) +
          "만";
    } else {
      return (isNegative ? "-" : "") + formatPrice.format(bigNum.abs());
    }
  }

  @override
  Widget build(BuildContext context) {
    // rebuildAllChildren(context);

    print("NOW IDX IS " + indexChosen.toString());
    // controller = widget.controller;
    scrollStreamCtrl = widget.scrollStreamCtrl;
    selected = widget.selected;
    idx = widget.idx;
    numSelected = widget.numSelected;
    issueCode = widget.vote.subVotes[idx].issueCode[indexChosen];
    numOfChoices = widget.vote.subVotes[idx].issueCode.length;
    seasonInfo = widget.seasonInfo;
    address = widget.address;
    user = widget.user;
    stockOrIndex = widget.vote.subVotes[idx].indexOrStocks[indexChosen];

    print("ISSUECODE " + issueCode);

    _showToast = widget.showToast;

    TextStyle newsTitleStyle = TextStyle(
      fontFamily: 'AppleSDM',
      fontSize: 16,
    );

    return ViewModelBuilder.reactive(
      createNewModelOnInsert: true,
      viewModelBuilder: () => ChartViewModel(
        countryCode,
        stockOrIndex,
        issueCode,
        priceStreamCtrl,
        behaviorCtrl,
        dateTimeStreamCtrl,
        scrollStreamCtrl,
        address.isVoting,
      ),
      builder: (context, model, child) {
        if (model.isBusy) {
          return Scaffold(body: Container());
        } else {
          // behaviorCtrl.listen(print);

          // closeList = model.chartList.forEach((element) {
          //   return element.close;
          // });

          // 뷰모델에서 불러온 ChartModel을 차트의 dataSource로
          print("PRICE SUB LENGTH");
          priceSubLength = model.chartList.length;
          print(priceSubLength);
          priceDataSourceList = model.chartList.sublist(
              model.chartList.length - model.priceSubLength,
              model.chartList.length);

          // 뷰모델에서 불러온 종목 정보 모델에서 EPS를 dataSource로
          if (stockOrIndex == "stocks") {
            statsSubLength = model.stockInfoModel.stats.length;
            statsDataSourceList = model.stockInfoModel.stats;
            print(statsSubLength);
            // print(statsDataSourceList);
          }

          // print(priceDataSourceList.last.close);

          // print("REALTIME" + realtimePriceDataSourceList.toString());

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
                                  ? RaisedButton(
                                      onPressed: () {
                                        (address.isVoting == false)
                                            ? {}
                                            : setState(() {
                                                if (seasonInfo.maxDailyVote -
                                                        numSelected ==
                                                    0) {
                                                  _showToast(
                                                      "하루 최대 ${seasonInfo.maxDailyVote}개 주제를 예측할 수 있습니다.");
                                                } else if ((user.item ==
                                                        null) ||
                                                    (user.item - numSelected ==
                                                        0)) {
                                                  // 선택되면 안됨

                                                  _showToast(
                                                      "보유 중인 아이템이 부족합니다.");
                                                } else {
                                                  // selected[idx] = true;
                                                  // print(VoteSelectViewModel()
                                                  //     .selected
                                                  //     .toString());
                                                  widget.selectUpdate(
                                                      idx, true);
                                                  Navigator.of(context).pop();
                                                }
                                              });
                                      },
                                      color: (address.isVoting == false)
                                          ? Color(0xFFE4E4E4)
                                          : Color(0xFF1EC8CF),
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
                                                // fontWeight: FontWeight.w700,
                                              )),
                                        ],
                                      ),
                                    )
                                  : RaisedButton(
                                      onPressed: () {
                                        // setState(() {
                                        //   selected[idx] = false;
                                        // });
                                        widget.selectUpdate(idx, false);
                                        Navigator.of(context).pop();
                                      },
                                      color: Color(0xFF0F6669),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child:
                                          // (model.address.isVoting == false)
                                          //     ? SizedBox()
                                          //     :

                                          Text("해제하기",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'AppleSDM',
                                                // fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              )),
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                numOfChoices == 1
                                    ? widget.vote.subVotes[idx].title
                                    : widget.vote.subVotes[idx]
                                        .voteChoices[indexChosen],
                                // "삼성바이오로직스",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'AppleSDB',
                                ),
                                maxLines: 1,
                              ),
                              SizedBox(width: 20),
                              numOfChoices == 1
                                  ? Container()
                                  : Flexible(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            indexChosen == 0
                                                ? indexChosen = 1
                                                : indexChosen = 0;
                                            // model.issueCode = "000000";
                                            model.getAllModel(
                                              countryCode,
                                              stockOrIndex,
                                              widget.vote.subVotes[idx]
                                                  .issueCode[indexChosen],
                                            );
                                          });
                                        },
                                        child: Text(
                                          // "VS  삼성바이오로직스스스스",
                                          indexChosen == 0
                                              ? "VS   ${widget.vote.subVotes[idx].voteChoices[1]}"
                                              : "VS   ${widget.vote.subVotes[idx].voteChoices[0]}",
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Color(0xFF8A8A8A),
                                            fontFamily: 'AppleSDB',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          StreamBuilder<double>(
                              // 차트에 tap하는 곳의 가격 stream
                              stream: priceStreamCtrl.stream,
                              initialData:
                                  //  address.isVoting == false
                                  //     ? Future.delayed(
                                  //         Duration(seconds: 2),
                                  //         () => realtimePriceDataSourceList
                                  //             .first.price)
                                  //     :

                                  model.chartList.last.close,
                              builder: (context, snapshot) {
                                // print("ON TAP REALTIME " +
                                //     realtimePriceDataSourceList.first.price
                                //         .toString());

                                // prevPrice.onData((data) {
                                //   print(data);
                                // });

                                // print("PREV " + prevSnapshot.data.toString());
                                // print("NOW " + snapshot.data.toString());
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Countup(
                                    //   begin: snapshot.data,
                                    //   end: snapshot.data,
                                    //   duration: Duration(
                                    //     milliseconds: 800,
                                    //   ),
                                    //   // prefix: "₩",
                                    //   separator: ",",
                                    //   style: TextStyle(
                                    //     fontSize: 32,
                                    //     fontFamily: 'DmSans',
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
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
                                          model.isDurationSelected[0] == true
                                              ? stockOrIndex == "stocks"
                                                  ? formatPriceUpDown
                                                      .format((snapshot.data -
                                                          priceDataSourceList
                                                              .last.close))
                                                      .toString()
                                                  : formatIndexUpDown
                                                      .format((snapshot.data -
                                                          priceDataSourceList
                                                              .last.close))
                                                      .toString()
                                              : stockOrIndex == "stocks"
                                                  ? formatPriceUpDown
                                                      .format((snapshot.data -
                                                          priceDataSourceList
                                                              .first.close))
                                                      .toString()
                                                  : formatIndexUpDown
                                                      .format((snapshot.data -
                                                          priceDataSourceList
                                                              .first.close))
                                                      .toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: model.isDurationSelected[
                                                        0] ==
                                                    true
                                                ? (snapshot.data -
                                                            priceDataSourceList
                                                                .last.close) <
                                                        0
                                                    ? Colors.blue
                                                    : (snapshot.data -
                                                                priceDataSourceList
                                                                    .last
                                                                    .close) ==
                                                            0
                                                        ? Colors.black
                                                        : Colors.red
                                                : (snapshot.data -
                                                            priceDataSourceList
                                                                .first.close) <
                                                        0
                                                    ? Colors.blue
                                                    : (snapshot.data -
                                                                priceDataSourceList
                                                                    .first
                                                                    .close) ==
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
                                          model.isDurationSelected[0] == true
                                              ? "(" +
                                                  formatReturnPct
                                                      .format(((snapshot.data /
                                                              priceDataSourceList
                                                                  .last.close) -
                                                          1))
                                                      .toString() +
                                                  ")"
                                              : "(" +
                                                  formatReturnPct
                                                      .format(((snapshot.data /
                                                              priceDataSourceList
                                                                  .first
                                                                  .close) -
                                                          1))
                                                      .toString() +
                                                  ")",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: model.isDurationSelected[
                                                        0] ==
                                                    true
                                                ? (snapshot.data -
                                                            priceDataSourceList
                                                                .last.close) <
                                                        0
                                                    ? Colors.blue
                                                    : (snapshot.data -
                                                                priceDataSourceList
                                                                    .last
                                                                    .close) ==
                                                            0
                                                        ? Colors.black
                                                        : Colors.red
                                                : (snapshot.data -
                                                            priceDataSourceList
                                                                .first.close) <
                                                        0
                                                    ? Colors.blue
                                                    : (snapshot.data -
                                                                priceDataSourceList
                                                                    .first
                                                                    .close) ==
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
                                return Text(stringDateWithDay
                                    .format(snapshot.data)
                                    .toString());
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    model.isDurationSelected[0] == true
                        ? StreamBuilder<List<PriceModel>>(
                            stream: tempStream,
                            builder: (context, realtimeSnapshot) {
                              if (!realtimeSnapshot.hasData) {
                                return Container(
                                  height: deviceHeight * 0.23,
                                );
                              } else {
                                realtimePriceDataSourceList =
                                    realtimeSnapshot.data;
                                if (address.isVoting == false) {
                                  liveToday = realtimePriceDataSourceList
                                      .first.createdAt
                                      .toDate();
                                  priceStreamCtrl.add(
                                      realtimePriceDataSourceList.first.price);
                                  dateTimeStreamCtrl.add(
                                      realtimePriceDataSourceList
                                          .first.createdAt
                                          .toDate());
                                }
                                print(realtimeSnapshot.data.length);
                                return buildContainerForChart(model);
                              }
                            })
                        : buildContainerForChart(model),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            if (address.isVoting == true && index == 0) {
                              setState(() {});
                            } else {
                              model.changeDuration(index);
                            }
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
                                  color: (address.isVoting == true &&
                                          index == 0)
                                      ? Colors.grey
                                      : model.isDurationSelected[index] == true
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
            // height: 1,
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
                // height: 1,
              ),
            ),
            Text(
              // stringDate.format(model.indexInfoModel.updatedAt.toDate()) +
              //     " 기준"
              "",
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
              // height: 1,
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
                          // model.stockInfoModel.avrWorkingYears
                          //     .toString()
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
          height: deviceHeight * 0.23,
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            series: <ChartSeries>[
              ScatterSeries<StatsModel, String>(
                color: Color(0xFF99E99B),
                dataSource: statsDataSourceList,
                xValueMapper: (StatsModel stats, _) =>
                    stats.announcedAt.replaceAll("\\n", "\n"),
                yValueMapper: (StatsModel stats, _) => stats.expectedEps,
                markerSettings: MarkerSettings(
                  width: 16,
                  height: 16,
                ),
              ),
              ScatterSeries<StatsModel, String>(
                color: Color(0xFF00C802),
                dataSource: statsDataSourceList,
                xValueMapper: (StatsModel stats, _) =>
                    stats.announcedAt.replaceAll("\\n", "\n"),
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
              // minorGridLines: MinorGridLines(width: 0,),
              // isVisible: false,
            ),
            primaryYAxis: NumericAxis(
              labelAlignment: LabelAlignment.center,
              numberFormat: NumberFormat('#,###'),
              labelStyle: TextStyle(
                fontFamily: 'AppleSDM',
                color: Colors.black,
              ),
              // interval: 1000,
              // minimum: -7000,
              // maximum: 3000,
              axisLine: AxisLine(
                width: 0,
              ),
              majorTickLines: MajorTickLines(
                width: 0,
              ),
              majorGridLines: MajorGridLines(
                width: 0,
              ),

              // minimum: 2000, // null값 무시하고 min 구해야 함

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
                        shape: BoxShape.circle, color: Color(0xFF99E99B)),
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
                        shape: BoxShape.circle, color: Color(0xFF00C802)),
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
          activationMode: ActivationMode.singleTap,
          tooltipSettings: InteractiveTooltip(
              // Formatting trackball tooltip text
              format: ''),
        ),

        onTrackballPositionChanging: (TrackballArgs args) =>
            model.trackball(args),

        onChartTouchInteractionUp: (ChartTouchInteractionArgs args) =>
            model.isDurationSelected[0] == true
                ? model.whenTrackEndOnLive(
                    realtimePriceDataSourceList.first.price,
                    realtimePriceDataSourceList.first.createdAt.toDate())
                : model.whenTrackEnd(),
        // onChartTouchInteractionDown:
        //     (ChartTouchInteractionArgs args) =>
        //         model.whenTrackStart(args),
        series: <ChartSeries>[
          // LIVE 일 때,
          model.isDurationSelected[0] == true
              ? FastLineSeries<PriceModel, DateTime>(
                  animationDuration: 0,
                  dataSource: realtimePriceDataSourceList,
                  color: (realtimePriceDataSourceList.first.price -
                              realtimePriceDataSourceList.last.price) >
                          0
                      ? Colors.red
                      : (realtimePriceDataSourceList.first.price -
                                  realtimePriceDataSourceList.last.price) ==
                              0
                          ? Colors.black
                          : Colors.blue,

                  // animationDuration: 10000,
                  // splineType: SplineType.cardinal,
                  // cardinalSplineTension: 0.3,

                  enableTooltip: true,
                  // <ChartModel>[

                  xValueMapper: (PriceModel price, _) =>
                      price.createdAt.toDate(),
                  yValueMapper: (PriceModel price, _) => price.price,
                )
              : FastLineSeries<ChartModel, DateTime>(
                  dataSource: priceDataSourceList,
                  emptyPointSettings: EmptyPointSettings(
                    mode: EmptyPointMode.gap,
                  ),
                  color: (priceDataSourceList.last.close -
                              priceDataSourceList.first.close) >
                          0
                      ? Colors.red
                      : (priceDataSourceList.last.close -
                                  priceDataSourceList.first.close) ==
                              0
                          ? Colors.black
                          : Colors.blue,

                  // animationDuration: 10000,
                  // splineType: SplineType.cardinal,
                  // cardinalSplineTension: 0.3,

                  enableTooltip: true,
                  // <ChartModel>[

                  xValueMapper: (ChartModel chart, _) => strToDate(chart.date),
                  yValueMapper: (ChartModel chart, _) => chart.close,
                  // animationDuration: 1000,
                )
        ],
        primaryYAxis: NumericAxis(
          majorGridLines: MajorGridLines(
            width: 0,
          ),
          isVisible: false,
          minimum:
              // LIVE 일 때,
              model.isDurationSelected[0] == true
                  ? (quiver.min(
                        List.generate(realtimePriceDataSourceList.length,
                            (index) {
                          // print(model.chartList[index].close);
                          return realtimePriceDataSourceList[index].price;
                        }),
                      ) *
                      0.97)
                  : (quiver.min(
                        List.generate(priceDataSourceList.length, (index) {
                          // print(model.chartList[index].close);
                          return priceDataSourceList[index].close;
                        }),
                      ) *
                      0.97),
          maximum:

              // LIVE 일 때,
              model.isDurationSelected[0] == true
                  ? (quiver.max(
                        List.generate(realtimePriceDataSourceList.length,
                            (index) {
                          // print(model.chartList[index].close);
                          return realtimePriceDataSourceList[index].price;
                        }),
                      ) *
                      1.03)
                  : (quiver.max(List.generate(priceDataSourceList.length,
                          (index) => priceDataSourceList[index].close)) *
                      1.03),
        ),
        primaryXAxis: model.isDurationSelected[0] == true
            ? DateTimeAxis(
                majorGridLines: MajorGridLines(
                  width: 0,
                ),
                isVisible: false,
                maximum: DateTime(
                    liveToday.year, liveToday.month, liveToday.day, 15, 31, 00),
                minimum: DateTime(
                    liveToday.year, liveToday.month, liveToday.day, 08, 50, 00),
              )
            : CategoryAxis(
                majorGridLines: MajorGridLines(
                  width: 0,
                ),
                isVisible: false),

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
    );
  }
}
