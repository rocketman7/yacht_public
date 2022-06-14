import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/screens/profile/stocks_delivery_view.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../handlers/numbers_handler.dart';
import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';
// import '../../widget/appbar_back_button.dart';

import 'asset_view_model.dart';

// style constants text style
TextStyle awardHistoryViewTextStyle1 = TextStyle(
  // fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w300,
  color: white,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle awardHistoryViewTextStyle2 = TextStyle(
  // fontFamily: 'SCore',
  fontSize: 30.w,
  fontWeight: FontWeight.w500,
  color: white,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle awardHistoryViewTextStyle3 = TextStyle(
  // fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w300,
  color: white,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle awardHistoryViewTextStyle4 = TextStyle(
  // fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w300,
  color: white,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle awardHistoryViewTextStyle5 = TextStyle(
  // fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: white, // yacht grey
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle awardHistoryViewTextStyle6 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w500,
  color: white,
  letterSpacing: -1.0,
  height: 1.4,
);

class AwardHistoryView extends StatelessWidget {
  final AssetViewModel assetViewModel = Get.find<AssetViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: primaryAppBar('상금 히스토리'),
        body: ListView(children: [
          SizedBox(
            height: 40.w - reducePaddingOneSide(awardHistoryViewTextStyle1.fontSize!),
          ),
          Center(
            child: Text(
              '현재 찾아갈 수 있는 상금',
              style: awardHistoryViewTextStyle1,
            ),
          ),
          SizedBox(
            height: 14.w -
                reducePaddingOneSide(awardHistoryViewTextStyle1.fontSize!) -
                reducePaddingOneSide(awardHistoryViewTextStyle2.fontSize!),
          ),
          Center(
            child: GetBuilder<AssetViewModel>(
              id: 'holdingStocks',
              builder: (controller) {
                if (controller.isHoldingStocksFutureLoad)
                  return Text(
                    '${toPriceKRW(controller.totalYachtPoint + controller.totalHoldingStocksValue)}원',
                    style: awardHistoryViewTextStyle2,
                  );
                else
                  return Text(
                    '',
                    style: awardHistoryViewTextStyle2,
                  );
              },
            ),
          ),
          SizedBox(
            height: 50.w - reducePaddingOneSide(awardHistoryViewTextStyle2.fontSize!),
          ),
          AwardHistoryColumnWidget(isFullHistory: true),
          SizedBox(
            height: 30.w,
          ),
        ]));
  }
}

class AwardHistoryColumnWidget extends StatelessWidget {
  final bool isFullHistory;
  AwardHistoryColumnWidget({required this.isFullHistory});

  final AssetViewModel assetViewModel = Get.find<AssetViewModel>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AssetViewModel>(
      id: 'holdingStocks',
      builder: (controller) {
        if (controller.isHoldingStocksFutureLoad)
          return Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Container(
              width: double.infinity,
              // height: 30,
              decoration: BoxDecoration(
                color: yachtDarkGrey,
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: controller.allAssets.length > 0
                  ?
                  // SizedBox(
                  //   height: 30.w,
                  // ),
                  // Container(
                  //   height: 1.w, width: double.infinity,
                  //   color: Color(0xFFE6EAF1), //yacht-line 색임
                  // )
                  Column(
                      children: controller.allAssets
                          .toList()
                          .asMap()
                          .map((i, element) => MapEntry(
                              i,
                              (isFullHistory || i < controller.maxHistoryVisibleNum)
                                  ? Padding(
                                      padding: EdgeInsets.only(left: 14.w, right: 14.w),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 14.w -
                                                          reducePaddingOneSide(awardHistoryViewTextStyle3.fontSize!),
                                                    ),
                                                    Text(
                                                      '${timeStampToString(controller.allAssets[i].tradeDate)}',
                                                      style: awardHistoryViewTextStyle3,
                                                    ),
                                                    SizedBox(
                                                        height: 4.w -
                                                            reducePaddingOneSide(awardHistoryViewTextStyle3.fontSize!)),
                                                    Text(
                                                      '${controller.allAssets[i].tradeTitle}',
                                                      style: awardHistoryViewTextStyle4,
                                                      // maxLines: 2,
                                                    ),
                                                    SizedBox(
                                                      height: 14.w -
                                                          reducePaddingOneSide(awardHistoryViewTextStyle4.fontSize!) -
                                                          reducePaddingOneSide(awardHistoryViewTextStyle5.fontSize!),
                                                    ),
                                                    Text(
                                                      '${controller.getStringTradeDetail(i)}',
                                                      style: awardHistoryViewTextStyle5,
                                                    ),
                                                    SizedBox(
                                                      height: 14.w -
                                                          reducePaddingOneSide(awardHistoryViewTextStyle5.fontSize!),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              Text(
                                                '${controller.plusSymbolReturn(i)}${toPriceKRW(controller.getNumTotalAwardsOrYachtPoint(i))}',
                                                style: awardHistoryViewTextStyle6.copyWith(
                                                    color: controller.getColorTotalAwardsOrYachtPointNum(i)),
                                              ),
                                            ],
                                          ),
                                          (isFullHistory && i == controller.allAssets.length - 1) ||
                                                  (!isFullHistory && i == controller.maxHistoryVisibleNum - 1)
                                              ? Container()
                                              : Container(
                                                  height: 1.w,
                                                  width: SizeConfig.screenWidth - 28.w - 30.w,
                                                  color: yachtMidGrey, //yacht-line 색임
                                                ),
                                        ],
                                      ),
                                    )
                                  : Container()))
                          .values
                          .toList(),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 14.w,
                        ),
                        Text(
                          '아직 상금 히스토리가 없어요',
                          style: awardHistoryViewTextStyle4,
                        ),
                        SizedBox(
                          height: 14.w,
                        ),
                      ],
                    ),
            ),
          );
        else
          return Container();
      },
    );
  }
}
