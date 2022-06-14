import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/yacht_store/giftishow_model.dart';
import 'package:yachtOne/screens/yacht_store/goods_exchage_view.dart';
import 'package:yachtOne/screens/yacht_store/yacht_store_controller.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

class YachtStoreGoodsView extends StatelessWidget {
  const YachtStoreGoodsView({Key? key, required this.giftishowModel, required this.yachtStoreController})
      : super(key: key);
  final GiftishowModel giftishowModel;
  final YachtStoreController yachtStoreController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: primaryAppBar("상품 교환하기"),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: primaryAllPadding,
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: CachedNetworkImage(
                          imageUrl: giftishowModel.goodsImgB,
                          // width: 123.w,
                          // height: 123.w,
                          fit: BoxFit.fill,
                          // color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        height: 14.w,
                      ),
                      Text(
                        giftishowModel.brandName,
                        style: yachtStoreBrandDetail,
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        giftishowModel.goodsName,
                        style: yachtStoreGoodsNameDetail,
                      ),
                      SizedBox(
                        height: 8.w,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/yacht_point_circle.png',
                            height: 20.w,
                            width: 20.w,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Text(
                            toPriceKRW(giftishowModel.realPrice),
                            style: yachtStoreGoodsPriceDetail,
                          ),
                        ],
                      ),
                      Divider(
                        height: 20.w,
                        color: yachtLightGrey,
                      ),
                      // Text("상품 설명"),
                      Text(
                        giftishowModel.content,
                        style: yachtStoreGoodsDescription,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  // 요트 포인트 잔고 체크
                  if (await yachtStoreController.checkIfYachtPointSufficient(giftishowModel)) {
                    yachtStoreController.initializeValues();
                    Get.to(
                      () => GoodsExchangeView(
                        giftishowModel: giftishowModel,
                        yachtStoreController: yachtStoreController,
                      ),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return InsufficientYachtPointAlertDialog();
                        });
                  }
                },
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: primaryPaddingSize,
                    ),
                    child: textContainerButtonWithOptions(
                      text: "교환하기",
                      isDarkBackground: true,
                      height: 50.w,
                      fontSize: 16.w,
                    )),
              ),
              Container(
                height: ScreenUtil().bottomBarHeight + primaryPaddingSize,
              )
            ],
          )
        ],
      ),
    );
  }
}

class InsufficientYachtPointAlertDialog extends StatelessWidget {
  const InsufficientYachtPointAlertDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: primaryBackgroundColor,
      insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: primaryHorizontalPadding,
            // height: 210.w,
            width: 347.w,
            child: Column(
              children: [
                SizedBox(height: 14.w),
                Text('알림',
                    style: yachtBadgesDialogTitle.copyWith(
                      fontSize: 16.w,
                    )),
                SizedBox(
                  height:
                      correctHeight(20.w, yachtBadgesDialogTitle.fontSize, yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "요트 포인트가 부족합니다.",
                        textAlign: TextAlign.center,
                        style: yachtBadgesDescriptionDialogTitle,
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      Text(
                        "요트 포인트가 부족하여 교환할 수 없어요.",
                        textAlign: TextAlign.center,
                        style: yachtBadgesDescriptionDialogContent.copyWith(color: yachtLightGrey),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: correctHeight(20.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: primaryPaddingSize,
                  ),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: GestureDetector(
                      //       behavior: HitTestBehavior.opaque,
                      //       onTap: () {
                      //         Navigator.of(context).pop();
                      //       },
                      //       child: conditionalButton(
                      //         height: 44.w,
                      //         text: '취소',
                      //         isEnable: false,
                      //       )
                      //       // style: yachtDeliveryDialogButtonText,

                      //       ),
                      // ),
                      // SizedBox(
                      //   width: 10.w,
                      // ),
                      Expanded(
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: conditionalButton(
                              height: 44.w,
                              text: '확인',
                              isEnable: true,
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 14.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
