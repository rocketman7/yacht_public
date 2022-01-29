import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:dio/dio.dart';
import 'package:yachtOne/models/yacht_store/giftishow_goods_detail_model.dart';
import 'package:yachtOne/models/yacht_store/giftishow_model.dart';

class GiftishowApiService extends GetxService {
  final String customAuthCode = 'REALf42cca844b9b4bf7a54825acbd8b84a8';
  final String customAuthToken = 'JMQUBA5aFkfxDXuWdOA9IA==';

  final String goodsApiAddress = 'https://bizapi.giftishow.com/bizApi/goods/';

  var dio = Dio();

  Future<List<GiftishowModel>> getGoodsList() async {
    List<GiftishowModel> giftishowList = [];
    var res = await dio.post(goodsApiAddress, queryParameters: {
      'api_code': '0101',
      'custom_auth_code': customAuthCode,
      'custom_auth_token': customAuthToken,
      'dev_yn': 'N'
    });
    // print('giftishow res: ${res.data['result']['goodsList']}');

    res.data['result']['goodsList'].forEach((a) {
      giftishowList.add(GiftishowModel.fromMap(a));
    });

    return giftishowList;
  }

  // Future<GiftishowGoodsDetailModel> getGoodsDetail(String goodsCode) async {
  //   var res = await dio.post('goodsApiAddress$goodsCode');
  //   // return GiftishowGoodsDetailModel();
  // }
}
