import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/yacht_store/giftishow_model.dart';
import 'package:yachtOne/services/giftishow_api_service.dart';

import '../../locator.dart';
import 'yacht_store_local_DB.dart';

class YachtStoreController extends GetxController {
  final GiftishowApiService giftishowApiService = locator<GiftishowApiService>();
  // SliverPersistentHeader -> YachtStoreAppBarDelegate & YachtStoreSectionHeaderDelegate 앱바 스타일 쓰기 위한 변수
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  RxDouble offset = 0.0.obs;

  // select 된 (혹은 그 스크롤 위치가 그곳인) category의 index. 당연히 처음 시작은 0
  RxInt categoryIndex = 0.obs;

  // DB로부터 상품들을 모두 따온 후, 순서를 가공해준다. 또, YachtStoreCategory만큼 나누어져있어야 한다.
  late List<List<YachtStoreGoodsModel>> yachtStoreGoodsLists = [];
  RxList<GiftishowModel> giftishowList = <GiftishowModel>[].obs;
  @override
  void onInit() async {
    // TODO: implement onInit
    scrollController.addListener(() {
      scrollController.offset < 0 ? offset(0) : offset(scrollController.offset);
    });

    // DB로부터 모든 상품을 받아온다.

    // 그 후에 goods 순서를 가공해준다.
    orderGoods();
    await getGoodsList();

    print(yachtStoreGoodsLists[0]);
    print(yachtStoreGoodsLists[1]);
    print(yachtStoreGoodsLists[2]);

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    scrollController.dispose();

    super.onClose();
  }

  Future getGoodsList() async {
    giftishowList.addAll(await giftishowApiService.getGoodsList());
  }

  // Future getGoodsDetail(String goodsCode) async {
  //   return await giftishowApiService.getGoodsDetail(goodsCode);
  // }

  // 카테고리 클릭하면,
  void categorySelect(int index) {
    categoryIndex(index);
  }

  // goods 순서 가공
  void orderGoods() {
    //// 먼저 category 갯수만큼 yachtStoreGoodsLists의 1차원배열 갯수를 설정해준다.
    for (int n = 0; n < yachtStoreCategories.length; n++) {
      yachtStoreGoodsLists.add([]);
    }

    //// 그 후에 DB로부터 불러온 모든 상품들을 각각 맞는 카테고리에 넣어준다.
    for (int i = 0; i < yachtStoreGoodsListFromDB.length; i++) {
      for (int n = 0; n < yachtStoreCategories.length; n++) {
        if (yachtStoreGoodsListFromDB[i].categoryName == yachtStoreCategories[n].categoryName) {
          yachtStoreGoodsLists[n].add(yachtStoreGoodsListFromDB[i]);

          break;
        }
      }
    }
  }
}
