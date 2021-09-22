import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/profile/profile_my_view.dart';
import 'package:yachtOne/screens/settings/account_view.dart';
import 'package:yachtOne/screens/startup/startup_view.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../handlers/numbers_handler.dart';
import '../../styles/size_config.dart';
import '../../styles/style_constants.dart';

import 'asset_view.dart';
import 'asset_view_model.dart';

// style constants text style
TextStyle stocksDeliveryViewTextStyle1 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 18.w,
  fontWeight: FontWeight.w600,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle stocksDeliveryViewTextStyle2 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 10.w,
  fontWeight: FontWeight.w500,
  color: Color(0xFF879098), //yacht-grey 임
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle stocksDeliveryViewTextStyle3 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle stocksDeliveryViewTextStyle4 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w300,
  color: Color(0xFF879098), //yacht-grey 임
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle stocksDeliveryViewTextStyle5 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w500,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle stocksDeliveryViewTextStyle6 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w500,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle stocksDeliveryViewTextStyle7 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w600,
  color: yachtBlack,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle stocksDeliveryViewTextStyle8 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 12.w,
  fontWeight: FontWeight.w400,
  color: Color(0xFF879098), //yacht-grey 임,
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle stocksDeliveryViewTextStyle9 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 20.w,
  fontWeight: FontWeight.w500,
  color: Color(0xFFEFF2FA),
  letterSpacing: -1.0,
  height: 1.4,
);
TextStyle stocksDeliveryViewTextStyle10 = TextStyle(
  fontFamily: 'SCore',
  fontSize: 16.w,
  fontWeight: FontWeight.w300,
  color: yachtBlack,
  letterSpacing: 0.0,
  height: 1.4,
);

class StocksDeliveryView extends StatelessWidget {
  final AssetViewModel assetViewModel = Get.find<AssetViewModel>();
  // final AssetViewModel assetViewModel = Get.put(AssetViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: primaryAppBar('주식 잔고 출고'),
        body: ListView(children: [
          SizedBox(
            height: 30.w,
          ),
          Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: Container(
              width: double.infinity,
              decoration: primaryBoxDecoration.copyWith(
                  boxShadow: [primaryBoxShadow],
                  color: homeModuleBoxBackgroundColor),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 15.w,
                    right: 15.w,
                    top: 14.w -
                        reducePaddingOneSide(
                            stocksDeliveryViewTextStyle1.fontSize!)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '보유 주식 ',
                          style: stocksDeliveryViewTextStyle1,
                        ),
                        GetBuilder<AssetViewModel>(
                          id: 'holdingStocks',
                          builder: (controller) {
                            if (controller.isHoldingStocksFutureLoad) {
                              return Text(
                                '${controller.allHoldingStocks.length}',
                                style: stocksDeliveryViewTextStyle1.copyWith(
                                    color: yachtRed),
                              );
                            } else {
                              return Text('');
                            }
                          },
                        ),
                      ],
                    ),
                    GetBuilder<AssetViewModel>(
                      id: 'holdingStocks',
                      builder: (controller) {
                        if (controller.isHoldingStocksFutureLoad) {
                          return Column(
                              children: controller.allHoldingStocks
                                  .toList()
                                  .asMap()
                                  .map((i, element) => MapEntry(
                                      i,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 14.w,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 150.w,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        '${controller.allHoldingStocks[i].name}',
                                                        style:
                                                            stocksDeliveryViewTextStyle3),
                                                    Text(
                                                      '잔고 ${controller.allHoldingStocks[i].sharesNum}',
                                                      style:
                                                          stocksDeliveryViewTextStyle4,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: 80.w,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${toPriceKRW(controller.allHoldingStocks[i].currentPrice)}',
                                                      style:
                                                          stocksDeliveryViewTextStyle5,
                                                    ),
                                                    Text(
                                                      '${toPercentageChange((controller.allHoldingStocks[i].currentPrice - controller.allHoldingStocks[i].priceAtAward) / controller.allHoldingStocks[i].priceAtAward)}',
                                                      style: stocksDeliveryViewTextStyle6.copyWith(
                                                          color: (controller
                                                                      .allHoldingStocks[
                                                                          i]
                                                                      .currentPrice >
                                                                  controller
                                                                      .allHoldingStocks[
                                                                          i]
                                                                      .priceAtAward)
                                                              ? yachtRed
                                                              : seaBlue),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      controller
                                                          .tapMinusButton(i);
                                                    },
                                                    child: SizedBox(
                                                      height: 24.w,
                                                      width: 24.w,
                                                      child: Image.asset(
                                                        'assets/buttons/plus.png',
                                                      ),
                                                    ),
                                                  ),
                                                  //
                                                  Obx(() => SizedBox(
                                                        width: 24.w,
                                                        child: Center(
                                                          child: Text(
                                                            '${controller.stocksDeliveryNum[i]}',
                                                            style:
                                                                stocksDeliveryViewTextStyle7,
                                                          ),
                                                        ),
                                                      )),
                                                  GestureDetector(
                                                    onTap: () {
                                                      controller
                                                          .tapPlusButton(i);
                                                    },
                                                    child: SizedBox(
                                                      height: 24.w,
                                                      width: 24.w,
                                                      child: Image.asset(
                                                        'assets/buttons/minus.png',
                                                        height: 24.w,
                                                        width: 24.w,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 14.w,
                                          ),
                                          Container(
                                            height: 1.w,
                                            color: Color(0xFF94BDE0)
                                                .withOpacity(0.15),
                                          )
                                        ],
                                      )))
                                  .values
                                  .toList());
                        } else {
                          return Text('');
                        }
                      },
                    ),
                    SizedBox(
                      height: 14.w,
                    ),
                    Row(
                      children: [
                        Text(
                          '주식 가치 합계',
                          style: stocksDeliveryViewTextStyle5,
                        ),
                        Spacer(),
                        Obx(() => Text(
                              '${toPriceKRW(assetViewModel.totalDeliveryValue.value)}',
                              style: stocksDeliveryViewTextStyle5.copyWith(
                                  fontSize: 20.w, fontWeight: FontWeight.w500),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 14.w,
                    ),
                    Text(
                      '* 출고하신 주식은 최대 3영업일 후 오후 3시이내에 입고됩니다.\n* 오후 1시 이전 신청은 당일 3시 부근 입고됩니다.',
                      style: stocksDeliveryViewTextStyle8,
                    ),
                    SizedBox(
                      height: 9.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8.w,
          ),
          Padding(
            padding: EdgeInsets.only(left: 14.w, right: 14.w),
            child: GestureDetector(
              onTap: () {
                if (userModelRx.value!.account['accNumber'] == null)
                  notAccountDialog(context);
                else {
                  if (assetViewModel.stocksDeliveryNum
                      .any((element) => (element.value != 0)))
                    deliveryDialog(context);
                  else
                    noChoiceStocksDialog(context);
                }
              },
              child: Container(
                height: 50.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70.0),
                    color: Color(0xFF6073B4)),
                width: double.infinity,
                child: Center(
                  child: Text(
                    '나에게 보내기',
                    style: stocksDeliveryViewTextStyle9,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 8.w,
          ),
          Padding(
              padding: EdgeInsets.only(left: 14.w, right: 14.w),
              child: GestureDetector(
                onTap: () {
                  assetViewModel.deliveryToFRIEND();
                  notYetStocksToFriendsDialog(context);
                },
                child: Container(
                  height: 50.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70.0),
                      color: Color(0xFFEFF2FA)),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      '친구에게 선물하기',
                      style: stocksDeliveryViewTextStyle9.copyWith(
                          color: Color(0xFF6073B4)),
                    ),
                  ),
                ),
              )),
        ]));
  }
}

deliveryDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: primaryBackgroundColor,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 196.w,
            width: 347.w,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    SizedBox(
                        height: 15.w,
                        width: 15.w,
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.w,
                        ),
                        Text('알림', style: yachtDeliveryDialogTitle)
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 15.w,
                              ),
                              SizedBox(
                                  height: 15.w,
                                  width: 15.w,
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 24.w,
                            width: 21.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: correctHeight(35.w, yachtDeliveryDialogTitle.fontSize,
                      yachtDeliveryDialogText.fontSize),
                ),
                Text(
                  '정말 출고하시겠습니까?',
                  style: yachtDeliveryDialogText,
                ),
                Text(
                  '출고 후에는 취소가 불가능합니다.',
                  style: yachtDeliveryDialogText.copyWith(color: yachtRed),
                ),
                SizedBox(
                  height: correctHeight(
                      25.w, yachtDeliveryDialogText.fontSize, 0.w),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        await Get.find<AssetViewModel>().deliveryToME();
                        await Get.find<AssetViewModel>().reloadUserAsset();
                        Navigator.of(context).pop();
                        deliveryDoneDialog(context);
                      },
                      child: Container(
                        height: 44.w,
                        width: 154.5.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: yachtViolet,
                        ),
                        child: Center(
                          child: Text(
                            '예',
                            style: yachtDeliveryDialogButtonText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 44.w,
                        width: 154.5.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: buttonNormal,
                        ),
                        child: Center(
                          child: Text(
                            '아니오',
                            style: yachtDeliveryDialogButtonText.copyWith(
                                color: yachtViolet),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.w,
                ),
              ],
            ),
          ),
        );
      });
}

deliveryDoneDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: primaryBackgroundColor,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 167.w,
            width: 347.w,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    SizedBox(
                        height: 15.w,
                        width: 15.w,
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.w,
                        ),
                        Text('알림', style: yachtDeliveryDialogTitle)
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 15.w,
                              ),
                              SizedBox(
                                  height: 15.w,
                                  width: 15.w,
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 24.w,
                            width: 21.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: correctHeight(31.w, yachtDeliveryDialogTitle.fontSize,
                      yachtDeliveryDialogText2.fontSize),
                ),
                Text(
                  '출고가 완료되었습니다.',
                  style: yachtDeliveryDialogText2,
                ),
                SizedBox(
                  height: correctHeight(
                      25.w, yachtDeliveryDialogText2.fontSize, 0.w),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                        // // Get.off(() => AssetView());
                        // Get.offAll(StartupView());
                      },
                      child: Container(
                        height: 44.w,
                        width: 347.w - 28.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: yachtViolet,
                        ),
                        child: Center(
                          child: Text(
                            '확인',
                            style: yachtDeliveryDialogButtonText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.w,
                ),
              ],
            ),
          ),
        );
      });
}

notAccountDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: primaryBackgroundColor,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 196.w,
            width: 347.w,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    SizedBox(
                        height: 15.w,
                        width: 15.w,
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.w,
                        ),
                        Text('알림', style: yachtDeliveryDialogTitle)
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 15.w,
                              ),
                              SizedBox(
                                  height: 15.w,
                                  width: 15.w,
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 24.w,
                            width: 21.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: correctHeight(35.w, yachtDeliveryDialogTitle.fontSize,
                      yachtDeliveryDialogText.fontSize),
                ),
                Text(
                  '증권계좌를 연결하지 않은 사용자입니다.',
                  style: yachtDeliveryDialogText,
                ),
                Text(
                  '계좌를 연결해주세요.',
                  style: yachtDeliveryDialogText,
                ),
                SizedBox(
                  height: correctHeight(
                      25.w, yachtDeliveryDialogText.fontSize, 0.w),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                        Get.to(() => AccountView());
                      },
                      child: Container(
                        height: 44.w,
                        width: 154.5.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: yachtViolet,
                        ),
                        child: Center(
                          child: Text(
                            '연결하기',
                            style: yachtDeliveryDialogButtonText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 44.w,
                        width: 154.5.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: buttonNormal,
                        ),
                        child: Center(
                          child: Text(
                            '나중에 하기',
                            style: yachtDeliveryDialogButtonText.copyWith(
                                color: yachtViolet),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.w,
                ),
              ],
            ),
          ),
        );
      });
}

noChoiceStocksDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: primaryBackgroundColor,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 196.w,
            width: 347.w,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    SizedBox(
                        height: 15.w,
                        width: 15.w,
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.w,
                        ),
                        Text('알림', style: yachtDeliveryDialogTitle)
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 15.w,
                              ),
                              SizedBox(
                                  height: 15.w,
                                  width: 15.w,
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 24.w,
                            width: 21.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: correctHeight(35.w, yachtDeliveryDialogTitle.fontSize,
                      yachtDeliveryDialogText.fontSize),
                ),
                Text(
                  '출고할 주식이 선택되지 않았습니다.',
                  style: yachtDeliveryDialogText,
                ),
                Text(
                  '출고할 주식 수량을 선택해주세요.',
                  style: yachtDeliveryDialogText,
                ),
                SizedBox(
                  height: correctHeight(
                      25.w, yachtDeliveryDialogText.fontSize, 0.w),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 44.w,
                        width: 347.w - 28.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: yachtViolet,
                        ),
                        child: Center(
                          child: Text(
                            '확인',
                            style: yachtDeliveryDialogButtonText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.w,
                ),
              ],
            ),
          ),
        );
      });
}

notYetStocksToFriendsDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: primaryBackgroundColor,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 196.w,
            width: 347.w,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    SizedBox(
                        height: 15.w,
                        width: 15.w,
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.w,
                        ),
                        Text('알림', style: yachtDeliveryDialogTitle)
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 15.w,
                              ),
                              SizedBox(
                                  height: 15.w,
                                  width: 15.w,
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 24.w,
                            width: 21.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: correctHeight(35.w, yachtDeliveryDialogTitle.fontSize,
                      yachtDeliveryDialogText.fontSize),
                ),
                Text(
                  '아직 친구에게 주식을 줄 수 없어요.',
                  style: yachtDeliveryDialogText,
                ),
                Text(
                  '조금만 기다려주세요!',
                  style: yachtDeliveryDialogText,
                ),
                SizedBox(
                  height: correctHeight(
                      25.w, yachtDeliveryDialogText.fontSize, 0.w),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 44.w,
                        width: 347.w - 28.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: yachtViolet,
                        ),
                        child: Center(
                          child: Text(
                            '확인',
                            style: yachtDeliveryDialogButtonText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.w,
                ),
              ],
            ),
          ),
        );
      });
}
