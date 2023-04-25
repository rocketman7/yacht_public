import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:dio/dio.dart';
import 'package:yachtOne/handlers/date_time_handler.dart';
import 'package:yachtOne/models/yacht_store/giftishow_goods_detail_model.dart';
import 'package:yachtOne/models/yacht_store/giftishow_model.dart';
import 'package:yachtOne/repositories/repository.dart';

class GiftishowApiService extends GetxService {
  final String customAuthCode = 'YOUR_API_KEY';
  final String customAuthToken = 'YOUR_API_KEY==';

  final String goodsAddress = 'https://bizapi.giftishow.com/bizApi/goods/';
  final String sendCouponAddress = 'https://bizapi.giftishow.com/bizApi/send/';
  var dio = Dio();

  Future<List<GiftishowModel>> getGoodsList(List<String> listToShow) async {
    List<GiftishowModel> giftishowList = [];
    var res = await dio.post(goodsAddress, queryParameters: {
      'api_code': '0101',
      'custom_auth_code': customAuthCode,
      'custom_auth_token': customAuthToken,
      'dev_yn': 'N',
      'size': '10000'
    });
    // print('giftishow res: ${res.data['result']['goodsList']}');

    res.data['result']['goodsList'].forEach((a) {
      // print('goodscode: ${a['goodsCode']}');
      if (a['goodsCode'] == 'G00001273449') {
        print(a['goodsName']);
      }
      if (listToShow.contains(a['goodsCode'])) {
        giftishowList.add(GiftishowModel.fromMap(a));
      }
    });

    return giftishowList;
  }

  Future<String> requestToSendCoupon(GiftishowModel giftishowModel, String phoneNumber) async {
    var res = await dio.post(sendCouponAddress, queryParameters: {
      'api_code': '0204', //	필수	파라미터	String	API 코드
      'custom_auth_code': customAuthCode, //	필수	파라미터	String	API 인증 키
      'custom_auth_token': customAuthToken, //	필수	파라미터	String	API 인증 토큰
      'dev_yn': 'N', //	필수	파라미터	String	테스트여부 설정 값		(‘N’ 으로만 설정)
      'goods_code': giftishowModel.goodsCode, //	필수	파라미터	String	상품코드
// 'order_no':,	//	옵션	파라미터	String	주문번호
      'mms_msg': '요트 포인트 스토어를 통해 아래 기프티쇼가 발급되었습니다.', //	필수	파라미터	String	MMS메시지
      'mms_title': '요트 포인트 스토어 상품 교환', //	필수	파라미터	String	MMS제목
      'callback_no': '01025867545', //	필수	파라미터	String	‘-‘를 제외한 발신번호
      'phone_no': phoneNumber, //	필수	파라미터	String	‘-‘를 제외한 수신번호
      'tr_id':
          '${dateTimeToString(DateTime.now(), 14)}_${phoneNumber.substring(3)}', //	필수	파라미터	String	거래아이디 (Unique한 ID)고객사와 기프티쇼비즈간 대사값(사용자생성 TR_ID)
// 'rev_info_yn':,	//	옵션	파라미터	String	예약발송여부 (Y:예약, N:실시간)
// 'rev_info_date':,	//	옵션	파라미터	String	예약일자 (yyyyMMdd)
// 'rev_info_time':,	//	옵션	파라미터	String	예약시간 (HHmm)
// 'template_id':,	//	옵션	파라미터	String	카드 아이디
// 'banner_id':,	//	옵션	파라미터	String	배너 아이디
      'user_id': 'official@team-yacht.com', //	필수	파라미터	String	회원 ID
// 'gubun':,	//	옵션	파라미터	String	MMS발송 구분자	- Y:핀번호수신		- N: MMS
    });
    print(res);
    print(res.data);
    return res.data['result']['code'];
  }

  // Future<GiftishowGoodsDetailModel> getGoodsDetail(String goodsCode) async {
  //   var res = await dio.post('goodsApiAddress$goodsCode');
  //   // return GiftishowGoodsDetailModel();
  // }
}
