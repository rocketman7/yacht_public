import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/yacht_store/giftishow_model.dart';
import 'package:yachtOne/screens/profile/asset_view.dart';
import 'package:yachtOne/screens/yacht_store/yacht_store_controller.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';
import 'package:yachtOne/yacht_design_system/yds_size.dart';

import 'yacht_store_goods_view.dart';

class GoodsExchangeView extends StatelessWidget {
  GoodsExchangeView({
    Key? key,
    required this.giftishowModel,
    required this.yachtStoreController,
  }) : super(key: key);
  final GiftishowModel giftishowModel;
  final YachtStoreController yachtStoreController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  RxBool isPhoneNumberReady = false.obs;
  RxBool isSendingSmsCode = false.obs;
  RxBool isSmsCodeSentSuccessfully = false.obs;
  RxBool isSmsCodeReady = false.obs;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: primaryAppBar("상품 교환하기"),
        body: Padding(
          padding: defaultPaddingAll,
          child: Column(
            children: [
              Padding(
                padding: defaultPaddingAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => yachtStoreController.isExchangeAllDone.value
                          ? Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/icons/check_circle.png',
                                    width: 60.w,
                                    height: 60.w,
                                  ),
                                  Text(
                                    "교환이 완료되었습니다.",
                                    style: TextStyle(
                                      fontSize: 18.w,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.w,
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    ),
                    Text(
                      "받으실 곳",
                      style: TextStyle(
                        fontSize: 14.w,
                        fontWeight: FontWeight.w400,
                        color: yachtBlack,
                      ),
                    ),
                    Divider(
                      height: 20,
                    ),
                    Container(
                      height: 40.w,
                      child: Row(
                        children: [
                          Text(
                            "성함",
                            style: yachtStoreTextStyle.copyWith(
                              // height: 1.4,
                              color: yachtLightGrey,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              controller: _nameController,
                              textAlign: TextAlign.end,
                              style: yachtStoreGoodsPriceDetail.copyWith(height: 1.4),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Container(
                      height: 40.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "휴대폰 번호",
                            style: yachtStoreTextStyle.copyWith(
                              color: yachtLightGrey,
                              // height: 1.4,
                            ),
                          ),
                          Expanded(
                            child: Obx(
                              () => TextFormField(
                                readOnly: yachtStoreController.isSmsCodeSentSuccessfully.value,
                                onChanged: (text) {
                                  if (text.length >= 10) {
                                    yachtStoreController.isPhoneNumberReady(true);
                                  } else {
                                    yachtStoreController.isPhoneNumberReady(false);
                                  }
                                },
                                textAlignVertical: TextAlignVertical.center,
                                controller: _phoneNumberController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.end,
                                style: yachtStoreGoodsPriceDetail.copyWith(height: 1.4),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    )),
                                validator: (value) {
                                  if ((value == null ? 0 : value.length) < 9) {
                                    return "올바른 휴대폰 번호를 입력해주세요.";
                                  } else
                                    return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate() && !isSmsCodeSentSuccessfully.value) {
                                  await yachtStoreController.send(
                                    "+82" + _phoneNumberController.text.replaceAll('-', '').trim().substring(1),
                                  );
                                }
                              },
                              child: Obx(() => conditionalButton(
                                    text: yachtStoreController.isSmsCodeSentSuccessfully.value
                                        ? "발송 완료"
                                        : yachtStoreController.isSendingSmsCode.value
                                            ? "발송 중"
                                            : "인증번호 발송",
                                    isEnable: yachtStoreController.isPhoneNumberReady.value &&
                                        !yachtStoreController.isSmsCodeSentSuccessfully.value,
                                    fontSize: 12.w,
                                    height: 30.w,
                                  ))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Obx(
                      () => yachtStoreController.isSmsCodeSentSuccessfully.value
                          ? Column(
                              children: [
                                Container(
                                  height: 40.w,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "인증번호",
                                        style: yachtStoreTextStyle.copyWith(
                                          height: 1.4,
                                          color: yachtLightGrey,
                                        ),
                                      ),
                                      Expanded(
                                        child: Obx(
                                          () => TextFormField(
                                            onChanged: (text) {
                                              if (text.length == 6) {
                                                yachtStoreController.isSmsCodeReady(true);
                                              } else {
                                                yachtStoreController.isSmsCodeReady(false);
                                              }
                                            },
                                            controller: _smsCodeController,
                                            keyboardType: TextInputType.number,
                                            readOnly: yachtStoreController.isVerificationComplete.value,
                                            textAlign: TextAlign.end,
                                            textAlignVertical: TextAlignVertical.center,
                                            style: yachtStoreGoodsPriceDetail,
                                            decoration: InputDecoration(
                                                // helperMaxLines: ,
                                                contentPadding: EdgeInsets.zero,
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          if (yachtStoreController.isSmsCodeReady.value) {
                                            if (yachtStoreController.matchCode(_smsCodeController.text.trim())) {
                                              yachtStoreController.isVerificationComplete(true);
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (context) => Dialog(
                                                  backgroundColor: primaryBackgroundColor,
                                                  insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                                                  clipBehavior: Clip.hardEdge,
                                                  shape:
                                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        padding: defaultHorizontalPadding,
                                                        // height: 210.w,
                                                        width: 347.w,
                                                        child: Column(
                                                          children: [
                                                            SizedBox(height: 14.w),
                                                            Text('알림',
                                                                style: yachtBadgesDialogTitle.copyWith(fontSize: 16.w)),
                                                            SizedBox(
                                                              height: correctHeight(
                                                                  20.w,
                                                                  yachtBadgesDialogTitle.fontSize,
                                                                  yachtBadgesDescriptionDialogTitle.fontSize),
                                                            ),
                                                            Center(
                                                              child: Text(
                                                                '잘못된 인증번호입니다. \n다시 확인 후 입력해주세요.',
                                                                textAlign: TextAlign.center,
                                                                style: yachtBadgesDescriptionDialogTitle,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: correctHeight(20.w,
                                                                  yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
                                                            ),
                                                            GestureDetector(
                                                              behavior: HitTestBehavior.opaque,
                                                              onTap: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Container(
                                                                height: 44.w,
                                                                // width: 154.5.w,
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
                                                              height: 14.w,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        child: Obx(() => conditionalButton(
                                              text: yachtStoreController.isVerificationComplete.value
                                                  ? "인증 완료"
                                                  : "인증번호 확인",
                                              isEnable: !yachtStoreController.isVerificationComplete.value &&
                                                  yachtStoreController.isSmsCodeReady.value,
                                              fontSize: 12.w,
                                              height: 30.w,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ),
                    SizedBox(
                      height: 30.w,
                    ),
                    GoodsInfoWidget(giftishowModel: giftishowModel),
                  ],
                ),
              ),
              SizedBox(
                height: 20.w,
              ),
              Obx(() => yachtStoreController.isExchangeAllDone.value
                  ? AfterExchangeButtonWidget() // 교환 모두 끝나면 Navigate하는 버튼
                  : GestureDetector(
                      onTap: () async {
                        if (!await yachtStoreController.checkIfYachtPointSufficient(giftishowModel)) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return InsufficientYachtPointAlertDialog();
                              });
                        } else if (yachtStoreController.isVerificationComplete.value &&
                            !yachtStoreController.isExchanging.value) {
                          showDialog(
                            context: context,
                            builder: (context) => ConfirmExchangeDialog(
                              yachtStoreController: yachtStoreController,
                              giftishowModel: giftishowModel,
                              phoneNumberController: _phoneNumberController,
                              nameController: _nameController,
                            ),
                          );
                        }
                      },
                      child: Obx(
                        () => conditionalButton(
                          text: yachtStoreController.isExchanging.value ? "잠시 기다려주세요" : "교환하기",
                          isEnable: yachtStoreController.isVerificationComplete.value,
                          // isDarkBackground: true,
                          height: 50.w,
                          fontSize: 16.w,
                        ),
                      ),
                    )),
              SizedBox(
                height: 14.w,
              ),
              Obx(() => (yachtStoreController.isSmsCodeSentSuccessfully.value &&
                      !yachtStoreController.isVerificationComplete.value)
                  ? Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            yachtStoreController.send(
                              "+82" + _phoneNumberController.text.replaceAll('-', '').trim().substring(1),
                            );
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                backgroundColor: primaryBackgroundColor,
                                insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
                                clipBehavior: Clip.hardEdge,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: defaultHorizontalPadding,
                                      // height: 210.w,
                                      width: 347.w,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 14.w),
                                          Text('알림', style: yachtBadgesDialogTitle.copyWith(fontSize: 16.w)),
                                          SizedBox(
                                            height: correctHeight(20.w, yachtBadgesDialogTitle.fontSize,
                                                yachtBadgesDescriptionDialogTitle.fontSize),
                                          ),
                                          Center(
                                            child: Column(
                                              children: [
                                                Text(
                                                  '인증번호 재발송 완료',
                                                  textAlign: TextAlign.center,
                                                  style: yachtBadgesDescriptionDialogTitle,
                                                ),
                                                SizedBox(
                                                  height: 4.w,
                                                ),
                                                Text(
                                                  '인증번호를 재발송했습니다. \n다시 발송된 인증번호를 입력해주세요.',
                                                  textAlign: TextAlign.center,
                                                  // style: yachtBadgesDescriptionDialogTitle,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                correctHeight(20.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
                                          ),
                                          GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              height: 44.w,
                                              // width: 154.5.w,
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
                                            height: 14.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text("혹시 인증번호가 오지 않았나요?",
                              style: TextStyle(
                                color: yachtViolet,
                                decoration: TextDecoration.underline,
                              )),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 240.w,
                          child: Text(
                            "재발송 이후에도 계속 오지 않으면\n약 10분 후에 다시 시도해주시기 바랍니다.",
                            style: TextStyle(
                              color: yachtGrey,
                              // decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : Container())
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmExchangeDialog extends StatelessWidget {
  const ConfirmExchangeDialog({
    Key? key,
    required this.yachtStoreController,
    required this.giftishowModel,
    required TextEditingController phoneNumberController,
    required TextEditingController nameController,
  })  : _phoneNumberController = phoneNumberController,
        _nameController = nameController,
        super(key: key);

  final YachtStoreController yachtStoreController;
  final GiftishowModel giftishowModel;
  final TextEditingController _phoneNumberController;
  final TextEditingController _nameController;

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
            padding: defaultHorizontalPadding,
            // height: 210.w,
            width: 347.w,
            child: Column(
              children: [
                SizedBox(height: 14.w),
                Text('알림', style: yachtBadgesDialogTitle.copyWith(fontSize: 16.w)),
                SizedBox(
                  height:
                      correctHeight(20.w, yachtBadgesDialogTitle.fontSize, yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '정말 교환하시겠어요?',
                        textAlign: TextAlign.center,
                        style: yachtBadgesDescriptionDialogTitle,
                      ),
                      SizedBox(
                        height: 4.w,
                      ),
                      Text(
                        '교환하기를 누르면 취소할 수 없습니다.\n교환 후 발송까지 시간이 소요될 수 있습니다.',
                        textAlign: TextAlign.center,
                        style: yachtBadgesDescriptionDialogContent,
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
                      Expanded(
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: conditionalButton(
                              height: 44.w,
                              text: '취소',
                              isEnable: false,
                            )
                            // style: yachtDeliveryDialogButtonText,

                            ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () async {
                              // print(yachtStoreController.isExchanging.value);
                              // isExchanging이 false일 때만 confirmExchange 함수
                              print('교환하기');
                              if (!yachtStoreController.isExchanging.value) {
                                yachtStoreController.isExchanging(true);
                                print('교환하기_최종');
                                await yachtStoreController
                                    .confirmExchange(
                                      giftishowModel,
                                      _phoneNumberController.text.replaceAll('-', '').trim(),
                                      _nameController.text,
                                    )
                                    .then((value) => Navigator.of(context).pop());
                              }
                            },
                            child: conditionalButton(
                              height: 44.w,
                              text: '교환하기',
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

class AfterExchangeButtonWidget extends StatelessWidget {
  const AfterExchangeButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.back();
              Get.back();
              Get.back();
              Get.to(() => AssetView());
            },
            child: conditionalButton(
              text: "교환 내역 보기",
              isEnable: true,
              isPrimary: false,
              height: 50.w,
              fontSize: 16.w,
            ),
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.back();
              Get.back();
              Get.back();
            },
            child: conditionalButton(
              text: "메인으로",
              isEnable: true,
              height: 50.w,
              fontSize: 16.w,
            ),
          ),
        ),
      ],
    );
  }
}

class GoodsInfoWidget extends StatelessWidget {
  const GoodsInfoWidget({
    Key? key,
    required this.giftishowModel,
  }) : super(key: key);

  final GiftishowModel giftishowModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "상품 목록",
          style: TextStyle(
            fontSize: 14.w,
            fontWeight: FontWeight.w400,
            color: yachtBlack,
          ),
        ),
        Divider(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: yachtStoreGoodsBoxDecoration,
                    child: CachedNetworkImage(
                      imageUrl: giftishowModel.goodsImgS,
                      width: 40.w,
                      height: 40.w,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          giftishowModel.brandName,
                          style: yachtStoreBrandMain,
                        ),
                        SizedBox(
                          height: 4.w,
                        ),
                        Text(
                          giftishowModel.goodsName,
                          style: yachtStoreGoodsNameMain,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
          ],
        )
      ],
    );
  }
}
