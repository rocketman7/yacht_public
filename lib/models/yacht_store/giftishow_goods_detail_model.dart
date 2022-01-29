import 'dart:convert';

class GiftishowGoodsDetailModel {
  final String code; //	결과코드 (코드목록 참조)
  final String message; //	결과메시지 (코드목록 참조)
  final String goodsNo; //	상품 번호
  final String goodsCode; //	상품 아이디
  final String goodsName; //	상품명
  final String brandCode; //	브랜드 코드
  final String brandName; //	브랜드 명
  final String content; //	상품설명
  final String contentAddDesc; //	상품추가설명
  final String goodsTypeCd; //	상품유형코드
  final String goodstypeNm; //	상품유형명
  final String goodsImgS; //	상품이미지 소(250X250)
  final String goodsImgB; //	상품이미지 대(500X500)
  final String goodsDescImgWeb; //	상품 설명 이미지
  final String brandIconImg; //	브랜드 아이콘 이미지
  final String mmsGoodsImg; //	상품 MMS 이미지
  final String realPrice; //	실판매가격(등급별 할인율 적용금액)
  final String salePrice; //	판매가격
  final String categoryName1; //	전시카테고리명1
  final String rmIdBuyCntFlagCd; //	ID당구매가능수량설정코드
  final String discountRate; //	최종판매할인률
  final String goldPrice; //	골드가격
  final String saleDiscountPrice; //	판매가격
  final String discountPrice; //	최종판매가격(원단위절삭)
  final String vipPrice; //	VIP가격
  final String platinumPrice; //	플래티넘 가격
  final String vipDiscountRate; //	VIP 할인률
  final String platinumDiscountRate; //	플래티넘 할인률
  final String goldDiscountRate; //	골드 할인률
  final String saleDiscountRate; //	할인률
  final String goodsStateCd; //	상품상태코드 (판매중: SALE, 판매중지: SUS)
  final String sellDisCntCost; //	할인금액
  final String sellDisRate; //	공급할인
  final String rmCntFlag; //	총판매수량설정여부
  final String goodsTypeDtlNm; //	상세상품유형명
  final String saleDateFlagCd; //	판매일시 설정코드
  final String saleDateFlag; //	판매일시설정여부
  final String mmsReserveFlag; //	예약발송노출여부
  final String categorySeq1; //	전시카테고리1
  final String limitday; //	유효기간(일자)
  final String affiliate; //	교환처명
  GiftishowGoodsDetailModel({
    required this.code,
    required this.message,
    required this.goodsNo,
    required this.goodsCode,
    required this.goodsName,
    required this.brandCode,
    required this.brandName,
    required this.content,
    required this.contentAddDesc,
    required this.goodsTypeCd,
    required this.goodstypeNm,
    required this.goodsImgS,
    required this.goodsImgB,
    required this.goodsDescImgWeb,
    required this.brandIconImg,
    required this.mmsGoodsImg,
    required this.realPrice,
    required this.salePrice,
    required this.categoryName1,
    required this.rmIdBuyCntFlagCd,
    required this.discountRate,
    required this.goldPrice,
    required this.saleDiscountPrice,
    required this.discountPrice,
    required this.vipPrice,
    required this.platinumPrice,
    required this.vipDiscountRate,
    required this.platinumDiscountRate,
    required this.goldDiscountRate,
    required this.saleDiscountRate,
    required this.goodsStateCd,
    required this.sellDisCntCost,
    required this.sellDisRate,
    required this.rmCntFlag,
    required this.goodsTypeDtlNm,
    required this.saleDateFlagCd,
    required this.saleDateFlag,
    required this.mmsReserveFlag,
    required this.categorySeq1,
    required this.limitday,
    required this.affiliate,
  });

  GiftishowGoodsDetailModel copyWith({
    String? code,
    String? message,
    String? goodsNo,
    String? goodsCode,
    String? goodsName,
    String? brandCode,
    String? brandName,
    String? content,
    String? contentAddDesc,
    String? goodsTypeCd,
    String? goodstypeNm,
    String? goodsImgS,
    String? goodsImgB,
    String? goodsDescImgWeb,
    String? brandIconImg,
    String? mmsGoodsImg,
    String? realPrice,
    String? salePrice,
    String? categoryName1,
    String? rmIdBuyCntFlagCd,
    String? discountRate,
    String? goldPrice,
    String? saleDiscountPrice,
    String? discountPrice,
    String? vipPrice,
    String? platinumPrice,
    String? vipDiscountRate,
    String? platinumDiscountRate,
    String? goldDiscountRate,
    String? saleDiscountRate,
    String? goodsStateCd,
    String? sellDisCntCost,
    String? sellDisRate,
    String? rmCntFlag,
    String? goodsTypeDtlNm,
    String? saleDateFlagCd,
    String? saleDateFlag,
    String? mmsReserveFlag,
    String? categorySeq1,
    String? limitday,
    String? affiliate,
  }) {
    return GiftishowGoodsDetailModel(
      code: code ?? this.code,
      message: message ?? this.message,
      goodsNo: goodsNo ?? this.goodsNo,
      goodsCode: goodsCode ?? this.goodsCode,
      goodsName: goodsName ?? this.goodsName,
      brandCode: brandCode ?? this.brandCode,
      brandName: brandName ?? this.brandName,
      content: content ?? this.content,
      contentAddDesc: contentAddDesc ?? this.contentAddDesc,
      goodsTypeCd: goodsTypeCd ?? this.goodsTypeCd,
      goodstypeNm: goodstypeNm ?? this.goodstypeNm,
      goodsImgS: goodsImgS ?? this.goodsImgS,
      goodsImgB: goodsImgB ?? this.goodsImgB,
      goodsDescImgWeb: goodsDescImgWeb ?? this.goodsDescImgWeb,
      brandIconImg: brandIconImg ?? this.brandIconImg,
      mmsGoodsImg: mmsGoodsImg ?? this.mmsGoodsImg,
      realPrice: realPrice ?? this.realPrice,
      salePrice: salePrice ?? this.salePrice,
      categoryName1: categoryName1 ?? this.categoryName1,
      rmIdBuyCntFlagCd: rmIdBuyCntFlagCd ?? this.rmIdBuyCntFlagCd,
      discountRate: discountRate ?? this.discountRate,
      goldPrice: goldPrice ?? this.goldPrice,
      saleDiscountPrice: saleDiscountPrice ?? this.saleDiscountPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      vipPrice: vipPrice ?? this.vipPrice,
      platinumPrice: platinumPrice ?? this.platinumPrice,
      vipDiscountRate: vipDiscountRate ?? this.vipDiscountRate,
      platinumDiscountRate: platinumDiscountRate ?? this.platinumDiscountRate,
      goldDiscountRate: goldDiscountRate ?? this.goldDiscountRate,
      saleDiscountRate: saleDiscountRate ?? this.saleDiscountRate,
      goodsStateCd: goodsStateCd ?? this.goodsStateCd,
      sellDisCntCost: sellDisCntCost ?? this.sellDisCntCost,
      sellDisRate: sellDisRate ?? this.sellDisRate,
      rmCntFlag: rmCntFlag ?? this.rmCntFlag,
      goodsTypeDtlNm: goodsTypeDtlNm ?? this.goodsTypeDtlNm,
      saleDateFlagCd: saleDateFlagCd ?? this.saleDateFlagCd,
      saleDateFlag: saleDateFlag ?? this.saleDateFlag,
      mmsReserveFlag: mmsReserveFlag ?? this.mmsReserveFlag,
      categorySeq1: categorySeq1 ?? this.categorySeq1,
      limitday: limitday ?? this.limitday,
      affiliate: affiliate ?? this.affiliate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'goodsNo': goodsNo,
      'goodsCode': goodsCode,
      'goodsName': goodsName,
      'brandCode': brandCode,
      'brandName': brandName,
      'content': content,
      'contentAddDesc': contentAddDesc,
      'goodsTypeCd': goodsTypeCd,
      'goodstypeNm': goodstypeNm,
      'goodsImgS': goodsImgS,
      'goodsImgB': goodsImgB,
      'goodsDescImgWeb': goodsDescImgWeb,
      'brandIconImg': brandIconImg,
      'mmsGoodsImg': mmsGoodsImg,
      'realPrice': realPrice,
      'salePrice': salePrice,
      'categoryName1': categoryName1,
      'rmIdBuyCntFlagCd': rmIdBuyCntFlagCd,
      'discountRate': discountRate,
      'goldPrice': goldPrice,
      'saleDiscountPrice': saleDiscountPrice,
      'discountPrice': discountPrice,
      'vipPrice': vipPrice,
      'platinumPrice': platinumPrice,
      'vipDiscountRate': vipDiscountRate,
      'platinumDiscountRate': platinumDiscountRate,
      'goldDiscountRate': goldDiscountRate,
      'saleDiscountRate': saleDiscountRate,
      'goodsStateCd': goodsStateCd,
      'sellDisCntCost': sellDisCntCost,
      'sellDisRate': sellDisRate,
      'rmCntFlag': rmCntFlag,
      'goodsTypeDtlNm': goodsTypeDtlNm,
      'saleDateFlagCd': saleDateFlagCd,
      'saleDateFlag': saleDateFlag,
      'mmsReserveFlag': mmsReserveFlag,
      'categorySeq1': categorySeq1,
      'limitday': limitday,
      'affiliate': affiliate,
    };
  }

  factory GiftishowGoodsDetailModel.fromMap(Map<String, dynamic> map) {
    return GiftishowGoodsDetailModel(
      code: map['code'] ?? '',
      message: map['message'] ?? '',
      goodsNo: map['goodsNo'] ?? '',
      goodsCode: map['goodsCode'] ?? '',
      goodsName: map['goodsName'] ?? '',
      brandCode: map['brandCode'] ?? '',
      brandName: map['brandName'] ?? '',
      content: map['content'] ?? '',
      contentAddDesc: map['contentAddDesc'] ?? '',
      goodsTypeCd: map['goodsTypeCd'] ?? '',
      goodstypeNm: map['goodstypeNm'] ?? '',
      goodsImgS: map['goodsImgS'] ?? '',
      goodsImgB: map['goodsImgB'] ?? '',
      goodsDescImgWeb: map['goodsDescImgWeb'] ?? '',
      brandIconImg: map['brandIconImg'] ?? '',
      mmsGoodsImg: map['mmsGoodsImg'] ?? '',
      realPrice: map['realPrice'] ?? '',
      salePrice: map['salePrice'] ?? '',
      categoryName1: map['categoryName1'] ?? '',
      rmIdBuyCntFlagCd: map['rmIdBuyCntFlagCd'] ?? '',
      discountRate: map['discountRate'] ?? '',
      goldPrice: map['goldPrice'] ?? '',
      saleDiscountPrice: map['saleDiscountPrice'] ?? '',
      discountPrice: map['discountPrice'] ?? '',
      vipPrice: map['vipPrice'] ?? '',
      platinumPrice: map['platinumPrice'] ?? '',
      vipDiscountRate: map['vipDiscountRate'] ?? '',
      platinumDiscountRate: map['platinumDiscountRate'] ?? '',
      goldDiscountRate: map['goldDiscountRate'] ?? '',
      saleDiscountRate: map['saleDiscountRate'] ?? '',
      goodsStateCd: map['goodsStateCd'] ?? '',
      sellDisCntCost: map['sellDisCntCost'] ?? '',
      sellDisRate: map['sellDisRate'] ?? '',
      rmCntFlag: map['rmCntFlag'] ?? '',
      goodsTypeDtlNm: map['goodsTypeDtlNm'] ?? '',
      saleDateFlagCd: map['saleDateFlagCd'] ?? '',
      saleDateFlag: map['saleDateFlag'] ?? '',
      mmsReserveFlag: map['mmsReserveFlag'] ?? '',
      categorySeq1: map['categorySeq1'] ?? '',
      limitday: map['limitday'] ?? '',
      affiliate: map['affiliate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GiftishowGoodsDetailModel.fromJson(String source) => GiftishowGoodsDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GiftishowGoodsDetailModel(code: $code, message: $message, goodsNo: $goodsNo, goodsCode: $goodsCode, goodsName: $goodsName, brandCode: $brandCode, brandName: $brandName, content: $content, contentAddDesc: $contentAddDesc, goodsTypeCd: $goodsTypeCd, goodstypeNm: $goodstypeNm, goodsImgS: $goodsImgS, goodsImgB: $goodsImgB, goodsDescImgWeb: $goodsDescImgWeb, brandIconImg: $brandIconImg, mmsGoodsImg: $mmsGoodsImg, realPrice: $realPrice, salePrice: $salePrice, categoryName1: $categoryName1, rmIdBuyCntFlagCd: $rmIdBuyCntFlagCd, discountRate: $discountRate, goldPrice: $goldPrice, saleDiscountPrice: $saleDiscountPrice, discountPrice: $discountPrice, vipPrice: $vipPrice, platinumPrice: $platinumPrice, vipDiscountRate: $vipDiscountRate, platinumDiscountRate: $platinumDiscountRate, goldDiscountRate: $goldDiscountRate, saleDiscountRate: $saleDiscountRate, goodsStateCd: $goodsStateCd, sellDisCntCost: $sellDisCntCost, sellDisRate: $sellDisRate, rmCntFlag: $rmCntFlag, goodsTypeDtlNm: $goodsTypeDtlNm, saleDateFlagCd: $saleDateFlagCd, saleDateFlag: $saleDateFlag, mmsReserveFlag: $mmsReserveFlag, categorySeq1: $categorySeq1, limitday: $limitday, affiliate: $affiliate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GiftishowGoodsDetailModel &&
        other.code == code &&
        other.message == message &&
        other.goodsNo == goodsNo &&
        other.goodsCode == goodsCode &&
        other.goodsName == goodsName &&
        other.brandCode == brandCode &&
        other.brandName == brandName &&
        other.content == content &&
        other.contentAddDesc == contentAddDesc &&
        other.goodsTypeCd == goodsTypeCd &&
        other.goodstypeNm == goodstypeNm &&
        other.goodsImgS == goodsImgS &&
        other.goodsImgB == goodsImgB &&
        other.goodsDescImgWeb == goodsDescImgWeb &&
        other.brandIconImg == brandIconImg &&
        other.mmsGoodsImg == mmsGoodsImg &&
        other.realPrice == realPrice &&
        other.salePrice == salePrice &&
        other.categoryName1 == categoryName1 &&
        other.rmIdBuyCntFlagCd == rmIdBuyCntFlagCd &&
        other.discountRate == discountRate &&
        other.goldPrice == goldPrice &&
        other.saleDiscountPrice == saleDiscountPrice &&
        other.discountPrice == discountPrice &&
        other.vipPrice == vipPrice &&
        other.platinumPrice == platinumPrice &&
        other.vipDiscountRate == vipDiscountRate &&
        other.platinumDiscountRate == platinumDiscountRate &&
        other.goldDiscountRate == goldDiscountRate &&
        other.saleDiscountRate == saleDiscountRate &&
        other.goodsStateCd == goodsStateCd &&
        other.sellDisCntCost == sellDisCntCost &&
        other.sellDisRate == sellDisRate &&
        other.rmCntFlag == rmCntFlag &&
        other.goodsTypeDtlNm == goodsTypeDtlNm &&
        other.saleDateFlagCd == saleDateFlagCd &&
        other.saleDateFlag == saleDateFlag &&
        other.mmsReserveFlag == mmsReserveFlag &&
        other.categorySeq1 == categorySeq1 &&
        other.limitday == limitday &&
        other.affiliate == affiliate;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        message.hashCode ^
        goodsNo.hashCode ^
        goodsCode.hashCode ^
        goodsName.hashCode ^
        brandCode.hashCode ^
        brandName.hashCode ^
        content.hashCode ^
        contentAddDesc.hashCode ^
        goodsTypeCd.hashCode ^
        goodstypeNm.hashCode ^
        goodsImgS.hashCode ^
        goodsImgB.hashCode ^
        goodsDescImgWeb.hashCode ^
        brandIconImg.hashCode ^
        mmsGoodsImg.hashCode ^
        realPrice.hashCode ^
        salePrice.hashCode ^
        categoryName1.hashCode ^
        rmIdBuyCntFlagCd.hashCode ^
        discountRate.hashCode ^
        goldPrice.hashCode ^
        saleDiscountPrice.hashCode ^
        discountPrice.hashCode ^
        vipPrice.hashCode ^
        platinumPrice.hashCode ^
        vipDiscountRate.hashCode ^
        platinumDiscountRate.hashCode ^
        goldDiscountRate.hashCode ^
        saleDiscountRate.hashCode ^
        goodsStateCd.hashCode ^
        sellDisCntCost.hashCode ^
        sellDisRate.hashCode ^
        rmCntFlag.hashCode ^
        goodsTypeDtlNm.hashCode ^
        saleDateFlagCd.hashCode ^
        saleDateFlag.hashCode ^
        mmsReserveFlag.hashCode ^
        categorySeq1.hashCode ^
        limitday.hashCode ^
        affiliate.hashCode;
  }
}
