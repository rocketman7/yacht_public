import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/handlers/numbers_handler.dart';
import 'package:yachtOne/models/yacht_store/giftishow_model.dart';
import 'package:yachtOne/screens/profile/asset_view_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/giftishow_api_service.dart';
import '../../locator.dart';
import 'yacht_store_local_DB.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class YachtStoreController extends GetxController {
  final GiftishowApiService giftishowApiService = locator<GiftishowApiService>();
  final AuthService authService = locator<AuthService>();
  final FirestoreService firestoreService = locator<FirestoreService>();
  final AssetViewModel assetViewModel = Get.find<AssetViewModel>();
  // SliverPersistentHeader -> YachtStoreAppBarDelegate & YachtStoreSectionHeaderDelegate 앱바 스타일 쓰기 위한 변수
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);
  RxDouble offset = 0.0.obs;

  // select 된 (혹은 그 스크롤 위치가 그곳인) category의 index. 당연히 처음 시작은 0
  RxInt categoryIndex = 0.obs;

  // DB로부터 상품들을 모두 따온 후, 순서를 가공해준다. 또, YachtStoreCategory만큼 나누어져있어야 한다.
  // late List<List<YachtStoreGoodsModel>> yachtStoreGoodsLists = [];

  // // goods list 정렬되어 준비됐는가?
  // bool isOrderingList = false;

  RxList<GiftishowModel> giftishowList = <GiftishowModel>[].obs;
  List<String> goodsCodeListToShow = [
    'G00001284065',
    'G00001273450',
    'G00001273441',
    'G00001274315',
    'G00001274307',
    'G00000330882',
    'G00001171360',
    'G00001171341',
    'G00001171352',
    'G00000265837',
    'G00000265820',
    'G00001250930',
    'G00001250927',
    'G00001250931',
    'G00001250940',
    'G00001283133',
    'G00001283139',
    'G00001283134',
    'G00001283132',
    'G00001272878',
    'G00000440737',
    'G00000450714',
    'G00000450715',
    'G00000440738',
    'G00001273888',
    'G00001273892',
    'G00001273890',
    'G00001273889',
    'G00001284332',
  ];

  final TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'AC682579cfee31cc3eaf8576251bd898ac',
    authToken: '87e39d1157ee394797ee3b22d2bd21d0',
    twilioNumber: '+17853775118',
  );

  // 인증절차 관련한 것들
  RxString smsCode = "".obs;
  RxBool isPhoneNumberReady = false.obs;
  RxBool isSendingSmsCode = false.obs;
  RxBool isSmsCodeSentSuccessfully = false.obs;
  RxBool isSmsCodeReady = false.obs;
  RxBool isVerificationComplete = false.obs;
  RxBool isExchanging = false.obs;
  RxBool isExchangeAllDone = false.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    scrollController.addListener(() {
      scrollController.offset < 0 ? offset(0) : offset(scrollController.offset);
    });

    // await getGoodsList();
    // DB로부터 모든 상품을 받아온다.
    await getGoodsListFromFirestore();
    // 기프티쇼에서 받아오고 컬렉션에 넣고 indexing 하는 코드들
    // TODOS:  파이썬으로 옮겨야함s
    // giftishowList.forEach((element) {
    //   firestoreService.firestoreService.collection('yachtPointStore/yachtPointStore/giftishows').add(element.toMap());
    // });
    // var tem = await firestoreService.firestoreService.collection('yachtPointStore/yachtPointStore/giftishows').get();
    // tem.docs.forEach((doc) {
    //   doc.reference.update({'index': goodsCodeListToShow.indexOf(doc.data()['goodsCode'])});
    // });
    // isOrderingList = true;
    update();

    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    initializeValues();
    scrollController.dispose();

    super.onClose();
  }

  initializeValues() {
    smsCode("");
    isPhoneNumberReady(false);
    isSendingSmsCode(false);
    isSmsCodeSentSuccessfully(false);
    isSmsCodeReady(false);
    isVerificationComplete(false);
  }

  // api에서 가져오는 함수
  Future getGoodsList() async {
    giftishowList.addAll(await giftishowApiService.getGoodsList(goodsCodeListToShow));
  }

  // firestore에서 goodsList 가져오는 함수
  Future getGoodsListFromFirestore() async {
    giftishowList.addAll(await firestoreService.getGoodsList());
  }

  String _verificationId = '';
  Future send(String phoneNumber) async {
    print(phoneNumber);
    isSmsCodeSentSuccessfully(false);
    isSendingSmsCode(true);
    smsCode(randomSmsCode());
    await twilioFlutter
        .sendSMS(
      toNumber: phoneNumber,
      messageBody: '요트 포인트 스토어 휴대폰 번호 인증을 위한 확인코드는 [$smsCode] 입니다.',
    )
        .then((value) {
      if (value == 201) {
        isSmsCodeSentSuccessfully(true);
        print('isSmsCodeSentSuccessfully: $isSmsCodeSentSuccessfully');
      }
    });
    // authService.auth.verifyPhoneNumber(
    //     phoneNumber: '+821067993800',
    //     verificationCompleted: (_) {
    //       print(_);
    //     },
    //     verificationFailed: (e) => print(e.message),
    //     codeSent: (String verificationId, int? token) {
    //       print(verificationId);
    //       _verificationId = verificationId;
    //     },
    //     codeAutoRetrievalTimeout: (e) => print(e.characters),
    //     timeout: Duration(
    //       seconds: 120,
    //     ));
  }

  bool matchCode(
    String code,
  ) {
    print(code == smsCode.value);
    return code == smsCode.value;
  }

  Future<bool> checkIfYachtPointSufficient(GiftishowModel giftishowModel) async {
    return await firestoreService.calculateYachtPoint() >= giftishowModel.realPrice;
  }

  Future confirmExchange(
    GiftishowModel giftishowModel,
    String phoneNumber,
    String userRealName,
  ) async {
    isExchanging(true);
    await giftishowApiService.requestToSendCoupon(giftishowModel, phoneNumber).then((value) async {
      if (value == '0000') {
        await firestoreService.useYachtPointToGiftishow(
          giftishowModel,
          phoneNumber,
          userRealName,
        );
        assetViewModel.reloadUserAsset();
        isExchangeAllDone(true);
      }
    });
    isExchanging(false);
  }

  // Future getGoodsDetail(String goodsCode) async {
  //   return await giftishowApiService.getGoodsDetail(goodsCode);
  // }

  // 카테고리 클릭하면,
  void categorySelect(int index) {
    categoryIndex(index);
  }

  // goods 순서 가공
  // void orderGoods() {
  //   //// 먼저 category 갯수만큼 yachtStoreGoodsLists의 1차원배열 갯수를 설정해준다.
  //   for (int n = 0; n < yachtStoreCategories.length; n++) {
  //     yachtStoreGoodsLists.add([]);
  //   }

  //   //// 그 후에 DB로부터 불러온 모든 상품들을 각각 맞는 카테고리에 넣어준다.
  //   for (int i = 0; i < yachtStoreGoodsListFromDB.length; i++) {
  //     for (int n = 0; n < yachtStoreCategories.length; n++) {
  //       if (yachtStoreGoodsListFromDB[i].categoryName ==
  //           yachtStoreCategories[n].categoryName) {
  //         yachtStoreGoodsLists[n].add(yachtStoreGoodsListFromDB[i]);

  //         break;
  //       }
  //     }
  //   }

  //// 각 카테고리별로 정렬을 시작한다.
  //// 정렬기준이 추가되면 아래 for 문 안에서 추가해주면 됨
//     for (int n = 0; n < yachtStoreCategories.length; n++) {
//       // 1. yachtPointPrice 싼->비싼순 정렬
//       YachtStoreGoodsModel tempYachtStoreGoodsModel;
//       for (int i = 0; i < yachtStoreGoodsLists[n].length; i++) {
//         for (int j = i + 1; j < yachtStoreGoodsLists[n].length; j++) {
//           if (yachtStoreGoodsLists[n][i].yachtPointPrice >
//               yachtStoreGoodsLists[n][j].yachtPointPrice) {
//             tempYachtStoreGoodsModel = yachtStoreGoodsLists[n][i];
//             yachtStoreGoodsLists[n][i] = yachtStoreGoodsLists[n][j];
//             yachtStoreGoodsLists[n][j] = tempYachtStoreGoodsModel;
//           }
//         }
//       }
//     }
//   }
}
