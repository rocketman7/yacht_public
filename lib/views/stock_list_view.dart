import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view_models/stock_list_view_model.dart';
import 'chart_forall_view.dart';
import 'constants/size.dart';

class StockListView extends StatefulWidget {
  @override
  _StockListViewState createState() => _StockListViewState();
}

class _StockListViewState extends State<StockListView> {
  // 오로지 검색 기능을 위하여 stateful widget이 되는 것.
  FocusNode _myFocusNode = FocusNode();
  Icon _searchIcon = Icon(
    Icons.search,
    color: Color(0xFF1EC8CF),
  );
  String _hintText = "종목명을 검색해주세요.";

  _StockListViewState() {
    _myFocusNode.addListener(() {
      if (_myFocusNode.hasFocus) {
        setState(() {
          _hintText = "";
          _searchIcon = Icon(
            Icons.clear,
            color: Color(0xFF1EC8CF),
          );
        });
      } else {
        setState(() {
          _hintText = "종목명을 검색해주세요.";
          _searchIcon = Icon(
            Icons.search,
            color: Color(0xFF1EC8CF),
          );
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StockListViewModel>.reactive(
      viewModelBuilder: () => StockListViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: model.hasError
              ? Container(
                  child: Text('error발생. 페이지를 벗어나신 후 다시 시도하세요.'),
                )
              : model.isBusy
                  ? Container()
                  : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "지난 종목 정보",
                              style: TextStyle(
                                fontFamily: 'AppleSDEB',
                                fontSize: 32.sp,
                                letterSpacing: -2.0,
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  child: _searchIcon,
                                  onTap: () {
                                    if (_searchIcon.icon == Icons.clear) {
                                      setState(() {
                                        model.searchingName = "";
                                        model.filter.text = "";
                                      });
                                      _myFocusNode.unfocus();
                                    } else {
                                      _myFocusNode.requestFocus();
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: model.filter,
                                    focusNode: _myFocusNode,
                                    keyboardType: TextInputType.text,
                                    style: TextStyle(
                                      color: Color(0xFF1EC8CF),
                                      fontSize: 16.sp,
                                      fontFamily: 'AppleSDEM',
                                    ),
                                    decoration: InputDecoration(
                                        hintText: _hintText,
                                        hintStyle: TextStyle(
                                          color: Color(0xFF1EC8CF),
                                          fontSize: 16.sp,
                                          fontFamily: 'AppleSDEM',
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.transparent))),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 8.h,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: model.searchingAllStockListModel
                                    .subStocks.length,
                                itemBuilder: (context, index) =>
                                    allStockListView(context, model, index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }

  allStockListView(BuildContext context, StockListViewModel model, int index) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print('${model.searchingAllStockListModel.subStocks[index].name}');
        _myFocusNode.unfocus();
        model.notifyListeners();

        callNewModalBottomSheet(context,
            model.searchingAllStockListModel.subStocks[index].issueCode);
      },
      child: Padding(
          padding: EdgeInsets.only(
            top: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model.searchingAllStockListModel.subStocks[index].name}',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'AppleSDEM',
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: Color(0xFFE3E3E3),
              ),
            ],
          )),
    );
  }

  Future callNewModalBottomSheet(BuildContext context, String issueCode) {
    ScrollController controller;
    StreamController scrollStreamCtrl = StreamController<double>();
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (
          context,
        ) =>
            StreamBuilder<double>(
                stream: scrollStreamCtrl.stream,
                initialData: 0,
                builder: (context, snapshot) {
                  double offset = snapshot.data;

                  if (offset < -140) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => Navigator.pop(context));
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 30,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 55,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Color(0xFFEBEBEB),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Container(
                        height: offset < 0
                            ? (deviceHeight * .83) + offset
                            : deviceHeight * .83,
                        child: ChartForAllView(scrollStreamCtrl, issueCode),
                      ),
                    ],
                  );
                }));
  }
}
