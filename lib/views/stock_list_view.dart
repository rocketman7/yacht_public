import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../view_models/stock_list_view_model.dart';

class StockListView extends StatelessWidget {
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
                              "지난 종목 리스트",
                              style: TextStyle(
                                fontFamily: 'AppleSDEB',
                                fontSize: 32.sp,
                                letterSpacing: -2.0,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                alignment: Alignment.centerRight,
                                height: 30,
                                width: 130,
                                color: Colors.red,
                                child: Text('dd'),
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Text('${model.allStockListModel.subStocks[4].name}')
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
