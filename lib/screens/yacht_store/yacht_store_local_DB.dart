// 카테고리의 업데이트 주기는 빈도가 아주 적을 것으로 예상되므로 로컬 DB에서 관리

class YachtStoreCategory {
  final String categoryName;
  final String categoryImgDir;

  YachtStoreCategory(
      {required this.categoryName, required this.categoryImgDir});
}

final List<YachtStoreCategory> yachtStoreCategories = [
  YachtStoreCategory(
      categoryName: '주식',
      categoryImgDir: 'assets/icons/yachtStoreCategoryStock.png'),
  YachtStoreCategory(
      categoryName: '기프트카드',
      categoryImgDir: 'assets/icons/yachtStoreCategoryGiftCard.png'),
  YachtStoreCategory(
      categoryName: '기프티콘',
      categoryImgDir: 'assets/icons/yachtStoreCategoryGiftCon.png'),
];

// 아래는 실제 DB에서 구현해야 함. 지금은 UI 먼저 구현하기 위해 더미 데이터로 실험

class YachtStoreGoodsModel {
  final String categoryName; // yachtStoreCategory 상 categoryName
  final String goodsCategory; // 주식인 경우 한국주식 등, 기프티콘인 경우 스타벅스 등 브랜드명
  final String goodsName; // 상품 상세 네임 (주식인 경우 주식 이름 1주 머 이런식으로)
  final int yachtPointPrice; // 가격(요트포인트)
  final String imageUrlSmall; // 파이어스토어 상 제품이미지 유알엘 (작은버전)
  // 일단 여기까지가 요트포인트 스토어 메인화면에서 필요한 정보들. 상세페이지 정보를 위한 변수는 아직 없음

  YachtStoreGoodsModel({
    required this.categoryName,
    required this.goodsCategory,
    required this.goodsName,
    required this.yachtPointPrice,
    required this.imageUrlSmall,
  });
}

final List<YachtStoreGoodsModel> yachtStoreGoodsListFromDB = [
  YachtStoreGoodsModel(
    categoryName: '주식',
    goodsCategory: '한국주식',
    goodsName: '삼성전자 5주',
    yachtPointPrice: 450000,
    imageUrlSmall: '',
  ),
  YachtStoreGoodsModel(
    categoryName: '주식',
    goodsCategory: '한국주식',
    goodsName: '삼성전자 1주',
    yachtPointPrice: 90000,
    imageUrlSmall: '',
  ),
  YachtStoreGoodsModel(
    categoryName: '기프티콘',
    goodsCategory: '스타벅스',
    goodsName: '아메리카노 R',
    yachtPointPrice: 5000,
    imageUrlSmall: '',
  ),
  YachtStoreGoodsModel(
    categoryName: '기프트카드',
    goodsCategory: '현대백화점',
    goodsName: '상품권 10,000원',
    yachtPointPrice: 10000,
    imageUrlSmall: '',
  ),
  YachtStoreGoodsModel(
    categoryName: '주식',
    goodsCategory: '한국주식',
    goodsName: '삼성전자 3주',
    yachtPointPrice: 270000,
    imageUrlSmall: '',
  ),
  YachtStoreGoodsModel(
    categoryName: '주식',
    goodsCategory: '한국주식',
    goodsName: '삼성전자 4주',
    yachtPointPrice: 360000,
    imageUrlSmall: '',
  ),
  YachtStoreGoodsModel(
    categoryName: '기프트카드',
    goodsCategory: '신세계백화점',
    goodsName: '상품권 10,000원',
    yachtPointPrice: 10000,
    imageUrlSmall: '',
  ),
  YachtStoreGoodsModel(
    categoryName: '기프트카드',
    goodsCategory: '신세계백화점',
    goodsName: '상품권 20,000원',
    yachtPointPrice: 20000,
    imageUrlSmall: '',
  ),
  YachtStoreGoodsModel(
    categoryName: '기프티콘',
    goodsCategory: '스타벅스',
    goodsName: '아메리카노 R 커플세트(2잔)',
    yachtPointPrice: 10000,
    imageUrlSmall: '',
  ),
  YachtStoreGoodsModel(
    categoryName: '주식',
    goodsCategory: '한국주식',
    goodsName: '삼성전자 2주',
    yachtPointPrice: 180000,
    imageUrlSmall: '',
  ),
  YachtStoreGoodsModel(
    categoryName: '기프티콘',
    goodsCategory: '스타벅스',
    goodsName: '아메리카노 R',
    yachtPointPrice: 5000,
    imageUrlSmall: '',
  ),
];
