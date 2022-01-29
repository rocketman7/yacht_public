import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/models/yacht_store/giftishow_model.dart';
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
      body: SingleChildScrollView(
        padding: primaryAllPadding,
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: giftishowModel.goodsImgB,
              // width: 123.w,
              // height: 123.w,
              fit: BoxFit.fill,
              // color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
