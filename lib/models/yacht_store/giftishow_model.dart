import 'dart:convert';

class GiftishowModel {
  final String code; //	결과코드 (코드목록 참조)
  final String message; //	결과메시지 (코드목록 참조)
  final int listNum; //	리스트갯수회원번호
  final String goodsCode; //	상품 아이디
  final int goodsNo; //	상품 번호
  final String goodsName; //	상품명
  final String brandCode; //	브랜드 코드
  final String brandName; //	브랜드 명
  final String content; //	상품설명
  final String contentAddDesc; //	상품추가설명
  final double discountRate; //	최종판매할인률
  final String goodstypeNm; //	상품유형명
  final String goodsImgS; //	상품이미지 소(250X250)
  final String goodsImgB; //	상품이미지 대(500X500)
  final String goodsDescImgWeb; //	상품 설명 이미지
  final String brandIconImg; //	브랜드 아이콘 이미지
  final String mmsGoodsImg; //	상품 MMS 이미지
  final num discountPrice; //	최종판매가격
  final num realPrice; //	실판매가격(등급별 할인율 적용금액)
  final num salePrice; //	할인가
  final num saleDiscountPrice; //	판매가격
  final String srchKeyword; //	상품검색어
  final String validPrdTypeCd; //	유효기간 유형(01-일수//02-일자)
  final int limitday; //	유효기간(일자)
  final dynamic validPrdDay; //	유효기간(일수)
  final dynamic endDate; //	판매종료일
  final String goodsComId; //	상품공급사ID
  final String goodsComName; //	상품공급사명
  final String affiliateId; //	교환처ID
  final String affilate; //	교환처명
  final double saleDiscountRate; //	할인률
  final String exhGenderCd; //	전시성별코드
  final String exhAgeCd; //	전시연령코드
  final String mmsReserveFlag; //	예약발송노출여부
  final String goodsStateCd; //	상품상태코드 (판매중: SALE, 판매중지: SUS)
  final String mmsBarcdCreateYn; //	공급사 MMS 바코드 생성여부
  final int sellDisCntCost; //	할인금액
  final String rmCntFlag; //	총판매수량설정여부
  final String saleDateFlagCd; //	판매일시 설정코드
  final String goodsTypeDtlNm; //	상세상품유형명
  final int category1Seq; //	전시카테고리1
  final String saleDateFlag; //	판매일시설정여부
  final double sellDisRate; //	공급할인
  final String rmIdBuyCntFlagCd; //	ID당구매가능수량설정코드
  GiftishowModel({
    required this.code,
    required this.message,
    required this.listNum,
    required this.goodsCode,
    required this.goodsNo,
    required this.goodsName,
    required this.brandCode,
    required this.brandName,
    required this.content,
    required this.contentAddDesc,
    required this.discountRate,
    required this.goodstypeNm,
    required this.goodsImgS,
    required this.goodsImgB,
    required this.goodsDescImgWeb,
    required this.brandIconImg,
    required this.mmsGoodsImg,
    required this.discountPrice,
    required this.realPrice,
    required this.salePrice,
    required this.saleDiscountPrice,
    required this.srchKeyword,
    required this.validPrdTypeCd,
    required this.limitday,
    required this.validPrdDay,
    required this.endDate,
    required this.goodsComId,
    required this.goodsComName,
    required this.affiliateId,
    required this.affilate,
    required this.saleDiscountRate,
    required this.exhGenderCd,
    required this.exhAgeCd,
    required this.mmsReserveFlag,
    required this.goodsStateCd,
    required this.mmsBarcdCreateYn,
    required this.sellDisCntCost,
    required this.rmCntFlag,
    required this.saleDateFlagCd,
    required this.goodsTypeDtlNm,
    required this.category1Seq,
    required this.saleDateFlag,
    required this.sellDisRate,
    required this.rmIdBuyCntFlagCd,
  });

  GiftishowModel copyWith({
    String? code,
    String? message,
    int? listNum,
    String? goodsCode,
    int? goodsNo,
    String? goodsName,
    String? brandCode,
    String? brandName,
    String? content,
    String? contentAddDesc,
    double? discountRate,
    String? goodstypeNm,
    String? goodsImgS,
    String? goodsImgB,
    String? goodsDescImgWeb,
    String? brandIconImg,
    String? mmsGoodsImg,
    num? discountPrice,
    num? realPrice,
    num? salePrice,
    num? saleDiscountPrice,
    String? srchKeyword,
    String? validPrdTypeCd,
    int? limitday,
    dynamic? validPrdDay,
    dynamic? endDate,
    String? goodsComId,
    String? goodsComName,
    String? affiliateId,
    String? affilate,
    double? saleDiscountRate,
    String? exhGenderCd,
    String? exhAgeCd,
    String? mmsReserveFlag,
    String? goodsStateCd,
    String? mmsBarcdCreateYn,
    int? sellDisCntCost,
    String? rmCntFlag,
    String? saleDateFlagCd,
    String? goodsTypeDtlNm,
    int? category1Seq,
    String? saleDateFlag,
    double? sellDisRate,
    String? rmIdBuyCntFlagCd,
  }) {
    return GiftishowModel(
      code: code ?? this.code,
      message: message ?? this.message,
      listNum: listNum ?? this.listNum,
      goodsCode: goodsCode ?? this.goodsCode,
      goodsNo: goodsNo ?? this.goodsNo,
      goodsName: goodsName ?? this.goodsName,
      brandCode: brandCode ?? this.brandCode,
      brandName: brandName ?? this.brandName,
      content: content ?? this.content,
      contentAddDesc: contentAddDesc ?? this.contentAddDesc,
      discountRate: discountRate ?? this.discountRate,
      goodstypeNm: goodstypeNm ?? this.goodstypeNm,
      goodsImgS: goodsImgS ?? this.goodsImgS,
      goodsImgB: goodsImgB ?? this.goodsImgB,
      goodsDescImgWeb: goodsDescImgWeb ?? this.goodsDescImgWeb,
      brandIconImg: brandIconImg ?? this.brandIconImg,
      mmsGoodsImg: mmsGoodsImg ?? this.mmsGoodsImg,
      discountPrice: discountPrice ?? this.discountPrice,
      realPrice: realPrice ?? this.realPrice,
      salePrice: salePrice ?? this.salePrice,
      saleDiscountPrice: saleDiscountPrice ?? this.saleDiscountPrice,
      srchKeyword: srchKeyword ?? this.srchKeyword,
      validPrdTypeCd: validPrdTypeCd ?? this.validPrdTypeCd,
      limitday: limitday ?? this.limitday,
      validPrdDay: validPrdDay ?? this.validPrdDay,
      endDate: endDate ?? this.endDate,
      goodsComId: goodsComId ?? this.goodsComId,
      goodsComName: goodsComName ?? this.goodsComName,
      affiliateId: affiliateId ?? this.affiliateId,
      affilate: affilate ?? this.affilate,
      saleDiscountRate: saleDiscountRate ?? this.saleDiscountRate,
      exhGenderCd: exhGenderCd ?? this.exhGenderCd,
      exhAgeCd: exhAgeCd ?? this.exhAgeCd,
      mmsReserveFlag: mmsReserveFlag ?? this.mmsReserveFlag,
      goodsStateCd: goodsStateCd ?? this.goodsStateCd,
      mmsBarcdCreateYn: mmsBarcdCreateYn ?? this.mmsBarcdCreateYn,
      sellDisCntCost: sellDisCntCost ?? this.sellDisCntCost,
      rmCntFlag: rmCntFlag ?? this.rmCntFlag,
      saleDateFlagCd: saleDateFlagCd ?? this.saleDateFlagCd,
      goodsTypeDtlNm: goodsTypeDtlNm ?? this.goodsTypeDtlNm,
      category1Seq: category1Seq ?? this.category1Seq,
      saleDateFlag: saleDateFlag ?? this.saleDateFlag,
      sellDisRate: sellDisRate ?? this.sellDisRate,
      rmIdBuyCntFlagCd: rmIdBuyCntFlagCd ?? this.rmIdBuyCntFlagCd,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'listNum': listNum,
      'goodsCode': goodsCode,
      'goodsNo': goodsNo,
      'goodsName': goodsName,
      'brandCode': brandCode,
      'brandName': brandName,
      'content': content,
      'contentAddDesc': contentAddDesc,
      'discountRate': discountRate,
      'goodstypeNm': goodstypeNm,
      'goodsImgS': goodsImgS,
      'goodsImgB': goodsImgB,
      'goodsDescImgWeb': goodsDescImgWeb,
      'brandIconImg': brandIconImg,
      'mmsGoodsImg': mmsGoodsImg,
      'discountPrice': discountPrice,
      'realPrice': realPrice,
      'salePrice': salePrice,
      'saleDiscountPrice': saleDiscountPrice,
      'srchKeyword': srchKeyword,
      'validPrdTypeCd': validPrdTypeCd,
      'limitday': limitday,
      'validPrdDay': validPrdDay,
      'endDate': endDate,
      'goodsComId': goodsComId,
      'goodsComName': goodsComName,
      'affiliateId': affiliateId,
      'affilate': affilate,
      'saleDiscountRate': saleDiscountRate,
      'exhGenderCd': exhGenderCd,
      'exhAgeCd': exhAgeCd,
      'mmsReserveFlag': mmsReserveFlag,
      'goodsStateCd': goodsStateCd,
      'mmsBarcdCreateYn': mmsBarcdCreateYn,
      'sellDisCntCost': sellDisCntCost,
      'rmCntFlag': rmCntFlag,
      'saleDateFlagCd': saleDateFlagCd,
      'goodsTypeDtlNm': goodsTypeDtlNm,
      'category1Seq': category1Seq,
      'saleDateFlag': saleDateFlag,
      'sellDisRate': sellDisRate,
      'rmIdBuyCntFlagCd': rmIdBuyCntFlagCd,
    };
  }

  factory GiftishowModel.fromMap(Map<String, dynamic> map) {
    return GiftishowModel(
      code: map['code'] ?? '',
      message: map['message'] ?? '',
      listNum: map['listNum']?.toInt() ?? 0,
      goodsCode: map['goodsCode'] ?? '',
      goodsNo: map['goodsNo']?.toInt() ?? 0,
      goodsName: map['goodsName'] ?? '',
      brandCode: map['brandCode'] ?? '',
      brandName: map['brandName'] ?? '',
      content: map['content'] ?? '',
      contentAddDesc: map['contentAddDesc'] ?? '',
      discountRate: map['discountRate']?.toDouble() ?? 0.0,
      goodstypeNm: map['goodstypeNm'] ?? '',
      goodsImgS: map['goodsImgS'] ?? '',
      goodsImgB: map['goodsImgB'] ?? '',
      goodsDescImgWeb: map['goodsDescImgWeb'] ?? '',
      brandIconImg: map['brandIconImg'] ?? '',
      mmsGoodsImg: map['mmsGoodsImg'] ?? '',
      discountPrice: map['discountPrice'] ?? 0,
      realPrice: map['realPrice'] ?? 0,
      salePrice: map['salePrice'] ?? 0,
      saleDiscountPrice: map['saleDiscountPrice'] ?? 0,
      srchKeyword: map['srchKeyword'] ?? '',
      validPrdTypeCd: map['validPrdTypeCd'] ?? '',
      limitday: map['limitday']?.toInt() ?? 0,
      validPrdDay: map['validPrdDay'] ?? null,
      endDate: map['endDate'] ?? null,
      goodsComId: map['goodsComId'] ?? '',
      goodsComName: map['goodsComName'] ?? '',
      affiliateId: map['affiliateId'] ?? '',
      affilate: map['affilate'] ?? '',
      saleDiscountRate: map['saleDiscountRate']?.toDouble() ?? 0.0,
      exhGenderCd: map['exhGenderCd'] ?? '',
      exhAgeCd: map['exhAgeCd'] ?? '',
      mmsReserveFlag: map['mmsReserveFlag'] ?? '',
      goodsStateCd: map['goodsStateCd'] ?? '',
      mmsBarcdCreateYn: map['mmsBarcdCreateYn'] ?? '',
      sellDisCntCost: map['sellDisCntCost']?.toInt() ?? 0,
      rmCntFlag: map['rmCntFlag'] ?? '',
      saleDateFlagCd: map['saleDateFlagCd'] ?? '',
      goodsTypeDtlNm: map['goodsTypeDtlNm'] ?? '',
      category1Seq: map['category1Seq']?.toInt() ?? 0,
      saleDateFlag: map['saleDateFlag'] ?? '',
      sellDisRate: map['sellDisRate']?.toDouble() ?? 0.0,
      rmIdBuyCntFlagCd: map['rmIdBuyCntFlagCd'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GiftishowModel.fromJson(String source) => GiftishowModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GiftishowModel(code: $code, message: $message, listNum: $listNum, goodsCode: $goodsCode, goodsNo: $goodsNo, goodsName: $goodsName, brandCode: $brandCode, brandName: $brandName, content: $content, contentAddDesc: $contentAddDesc, discountRate: $discountRate, goodstypeNm: $goodstypeNm, goodsImgS: $goodsImgS, goodsImgB: $goodsImgB, goodsDescImgWeb: $goodsDescImgWeb, brandIconImg: $brandIconImg, mmsGoodsImg: $mmsGoodsImg, discountPrice: $discountPrice, realPrice: $realPrice, salePrice: $salePrice, saleDiscountPrice: $saleDiscountPrice, srchKeyword: $srchKeyword, validPrdTypeCd: $validPrdTypeCd, limitday: $limitday, validPrdDay: $validPrdDay, endDate: $endDate, goodsComId: $goodsComId, goodsComName: $goodsComName, affiliateId: $affiliateId, affilate: $affilate, saleDiscountRate: $saleDiscountRate, exhGenderCd: $exhGenderCd, exhAgeCd: $exhAgeCd, mmsReserveFlag: $mmsReserveFlag, goodsStateCd: $goodsStateCd, mmsBarcdCreateYn: $mmsBarcdCreateYn, sellDisCntCost: $sellDisCntCost, rmCntFlag: $rmCntFlag, saleDateFlagCd: $saleDateFlagCd, goodsTypeDtlNm: $goodsTypeDtlNm, category1Seq: $category1Seq, saleDateFlag: $saleDateFlag, sellDisRate: $sellDisRate, rmIdBuyCntFlagCd: $rmIdBuyCntFlagCd)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GiftishowModel &&
        other.code == code &&
        other.message == message &&
        other.listNum == listNum &&
        other.goodsCode == goodsCode &&
        other.goodsNo == goodsNo &&
        other.goodsName == goodsName &&
        other.brandCode == brandCode &&
        other.brandName == brandName &&
        other.content == content &&
        other.contentAddDesc == contentAddDesc &&
        other.discountRate == discountRate &&
        other.goodstypeNm == goodstypeNm &&
        other.goodsImgS == goodsImgS &&
        other.goodsImgB == goodsImgB &&
        other.goodsDescImgWeb == goodsDescImgWeb &&
        other.brandIconImg == brandIconImg &&
        other.mmsGoodsImg == mmsGoodsImg &&
        other.discountPrice == discountPrice &&
        other.realPrice == realPrice &&
        other.salePrice == salePrice &&
        other.saleDiscountPrice == saleDiscountPrice &&
        other.srchKeyword == srchKeyword &&
        other.validPrdTypeCd == validPrdTypeCd &&
        other.limitday == limitday &&
        other.validPrdDay == validPrdDay &&
        other.endDate == endDate &&
        other.goodsComId == goodsComId &&
        other.goodsComName == goodsComName &&
        other.affiliateId == affiliateId &&
        other.affilate == affilate &&
        other.saleDiscountRate == saleDiscountRate &&
        other.exhGenderCd == exhGenderCd &&
        other.exhAgeCd == exhAgeCd &&
        other.mmsReserveFlag == mmsReserveFlag &&
        other.goodsStateCd == goodsStateCd &&
        other.mmsBarcdCreateYn == mmsBarcdCreateYn &&
        other.sellDisCntCost == sellDisCntCost &&
        other.rmCntFlag == rmCntFlag &&
        other.saleDateFlagCd == saleDateFlagCd &&
        other.goodsTypeDtlNm == goodsTypeDtlNm &&
        other.category1Seq == category1Seq &&
        other.saleDateFlag == saleDateFlag &&
        other.sellDisRate == sellDisRate &&
        other.rmIdBuyCntFlagCd == rmIdBuyCntFlagCd;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        message.hashCode ^
        listNum.hashCode ^
        goodsCode.hashCode ^
        goodsNo.hashCode ^
        goodsName.hashCode ^
        brandCode.hashCode ^
        brandName.hashCode ^
        content.hashCode ^
        contentAddDesc.hashCode ^
        discountRate.hashCode ^
        goodstypeNm.hashCode ^
        goodsImgS.hashCode ^
        goodsImgB.hashCode ^
        goodsDescImgWeb.hashCode ^
        brandIconImg.hashCode ^
        mmsGoodsImg.hashCode ^
        discountPrice.hashCode ^
        realPrice.hashCode ^
        salePrice.hashCode ^
        saleDiscountPrice.hashCode ^
        srchKeyword.hashCode ^
        validPrdTypeCd.hashCode ^
        limitday.hashCode ^
        validPrdDay.hashCode ^
        endDate.hashCode ^
        goodsComId.hashCode ^
        goodsComName.hashCode ^
        affiliateId.hashCode ^
        affilate.hashCode ^
        saleDiscountRate.hashCode ^
        exhGenderCd.hashCode ^
        exhAgeCd.hashCode ^
        mmsReserveFlag.hashCode ^
        goodsStateCd.hashCode ^
        mmsBarcdCreateYn.hashCode ^
        sellDisCntCost.hashCode ^
        rmCntFlag.hashCode ^
        saleDateFlagCd.hashCode ^
        goodsTypeDtlNm.hashCode ^
        category1Seq.hashCode ^
        saleDateFlag.hashCode ^
        sellDisRate.hashCode ^
        rmIdBuyCntFlagCd.hashCode;
  }
}
