import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yachtOne/screens/profile/stocks_delivery_view.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../handlers/numbers_handler.dart';
import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';

import 'asset_view_model.dart';

// style constants text style
TextStyle assetViewTextStyle1 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle assetViewTextStyle2 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: 0.0,
  height: 1.4,
);
TextStyle assetViewTextStyle3 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle assetViewTextStyle4 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w500,
  letterSpacing: -0.1,
  height: 1.4,
);
TextStyle assetViewTextStyle5 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 14.w,
  fontWeight: FontWeight.w300,
  color: Color(0xFF879098), // yacht grey
  letterSpacing: 0.0,
  height: 1.4,
);

class AssetView extends StatelessWidget {
  final AssetViewModel assetViewModel = Get.put(AssetViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: primaryAppBar('보유자산'),
        body: ListView(children: [
          SizedBox(
            height: 30.w - reducePaddingOneSide(assetViewTextStyle1.fontSize!),
          ),
          Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Text(
              '나의 자산',
              style: assetViewTextStyle1,
            ),
          ),
          SizedBox(
            height: 20.w - reducePaddingOneSide(assetViewTextStyle1.fontSize!),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w, right: 15.w),
            child: Container(
              width: double.infinity,
              decoration:
                  primaryBoxDecoration.copyWith(boxShadow: [primaryBoxShadow], color: homeModuleBoxBackgroundColor),
              child: Column(
                children: [
                  SizedBox(
                    height: 14.w - reducePaddingOneSide(assetViewTextStyle2.fontSize!),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: Row(
                      children: [
                        Text(
                          '현재 찾아갈 수 있는 상금',
                          style: assetViewTextStyle2,
                        ),
                        Spacer(),
                        GetBuilder<AssetViewModel>(
                            id: 'holdingStocks',
                            builder: (controller) {
                              return Text(
                                '${toPriceKRW(controller.totalYachtPoint + controller.totalHoldingStocksValue)}',
                                style: assetViewTextStyle3,
                              );
                            }),
                        Text(
                          ' 원',
                          style: assetViewTextStyle3.copyWith(fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.w - reducePaddingOneSide(assetViewTextStyle2.fontSize!),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 26.w,
                      ),
                      Container(
                        width: 2.w,
                        height: 54.w, // 22+10+22
                        color: Color(0xFFE6EAF1) // yacht-line color 임
                        ,
                      ),
                      SizedBox(
                        width: 9.w,
                      ),
                      Column(
                        children: [
                          Container(
                            width: SizeConfig.screenWidth - 82.w, // 15, (26, 2, 9, 15), 15
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/won_circle.png',
                                  width: 22.w,
                                  height: 22.w,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  '주식 잔고',
                                  style: assetViewTextStyle2.copyWith(fontWeight: FontWeight.w300),
                                ),
                                Spacer(),
                                Text('132,200 원', style: assetViewTextStyle3.copyWith(fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Container(
                            width: SizeConfig.screenWidth - 82.w, // 15, (26, 2, 9, 15), 15
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/yacht_point_circle.png',
                                  width: 22.w,
                                  height: 22.w,
                                ),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  '요트 포인트',
                                  style: assetViewTextStyle2.copyWith(fontWeight: FontWeight.w300),
                                ),
                                Spacer(),
                                Text('743,121 원', style: assetViewTextStyle3.copyWith(fontWeight: FontWeight.w300)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.w - reducePaddingOneSide(assetViewTextStyle2.fontSize!),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: Row(
                      children: [
                        Text(
                          '출고 완료한 상금',
                          style: assetViewTextStyle2,
                        ),
                        Spacer(),
                        Text(
                          '1,422,021',
                          style: assetViewTextStyle3,
                        ),
                        // GetBuilder<AssetViewModel>(
                        //   id: 'holdingStocks',
                        //   builder: (controller) {
                        //     if (controller.isHoldingStocksFutureLoad) {
                        //       return Text(
                        //           '${assetViewModel.allHoldingStocks[0].currentPrice}');
                        //     } else {
                        //       return Text('');
                        //     }
                        //   },
                        // ),
                        Text(
                          ' 원',
                          style: assetViewTextStyle3.copyWith(fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14.w,
                  ),
                  Container(
                    height: 1.w,
                    color: Color(0xFFE6EAF1) // yacht-line color 임
                    ,
                  ),
                  SizedBox(
                    height: 14.w - reducePaddingOneSide(assetViewTextStyle2.fontSize!),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: Row(
                      children: [
                        Text(
                          '요트와 함께 획득한 총 상금',
                          style: assetViewTextStyle2,
                        ),
                        Spacer(),
                        Text(
                          '2,278,342',
                          style: assetViewTextStyle3,
                        ),
                        Text(
                          ' 원',
                          style: assetViewTextStyle3.copyWith(fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14.w - reducePaddingOneSide(assetViewTextStyle2.fontSize!),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          Row(
            children: [
              SizedBox(
                width: 14.w,
              ),
              Flexible(
                child: Container(
                  height: 40.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(70.0), color: Color(0xFFECF3FF)),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Get.to(() => StocksDeliveryView());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/won_circle.png',
                          width: 24.w,
                          height: 24.w,
                        ),
                        Text(
                          '주식 잔고 출고',
                          style: assetViewTextStyle4.copyWith(color: Color(0xFF4A99E2)),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 8.w,
              ),
              Flexible(
                child: Container(
                  height: 40.w,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(70.0), color: Color(0xFFE6F7F1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/yacht_point_circle.png',
                        width: 24.w,
                        height: 24.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          print(assetViewModel.totalHoldingStocksValue);
                        },
                        child: Text(
                          '요트 포인트 교환',
                          style: assetViewTextStyle4.copyWith(color: Color(0xFF61CCA6)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 14.w,
              ),
            ],
          ),
          SizedBox(
            height: 30.w,
          ),
          SizedBox(
            height: 14.w - reducePaddingOneSide(assetViewTextStyle1.fontSize!),
          ),
          Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Row(
              children: [
                Text(
                  '상금 히스토리',
                  style: assetViewTextStyle1,
                ),
                Spacer(),
                Text(
                  '더 보기',
                  style: assetViewTextStyle5,
                ),
                SizedBox(
                  width: 3.w,
                ),
                Image.asset(
                  'assets/icons/navigate_foward_arrow.png',
                  height: 10.w,
                  width: 5.w,
                  color: yachtGrey,
                )
              ],
            ),
          ),
        ]));
  }
}
