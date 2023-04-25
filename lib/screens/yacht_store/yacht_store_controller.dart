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
    'G00001250938',
    'G00001250930',
    'G00001250927',
    'G00001401357',
    'G00001291512',
    'G00001301715',
    'G00001301788',
    'G00001301779',
    'G00001301775',
    'G00001291391',
    'G00001301427',
    'G00001301413',
    'G00001291383',
    'G00001403331',
    'G00001403318',
    'G00001403288',
    'G00001403273',
    'G00001311166',
    'G00001311164',
    'G00001304997',
    'G00001311139',
    'G00001404527',
    'G00001403843',
    'G00001330726',
    'G00001330720',
    'G00001330717',
    'G00001330774',
    'G00001291162',
    'G00001300954',
    'G00001300947',
    'G00000990701',
    'G00000263853',
    'G00001371332',
    'G00001371327',
    'G00001371312',
    'G00001371304',
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
  // Future getGoodsList() async {
  //   giftishowList.addAll(await giftishowApiService.getGoodsList(goodsCodeListToShow));
  // }

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
    // print('before: ${isExchanging.value}');
    isExchanging(true);
    // print('after: ${isExchanging.value}');
    // Future.delayed(Duration(seconds: 4)).then((_) async {
    //   print('after 4sec');
    //   print('after future: ${isExchanging.value}');
    //   await firestoreService.useYachtPointToGiftishow(
    //     giftishowModel,
    //     phoneNumber,
    //     userRealName,
    //   );
    //   isExchanging(false);
    // });
    // print('after future: ${isExchanging.value}');
    await giftishowApiService.requestToSendCoupon(giftishowModel, phoneNumber).then((value) async {
      if (value == '0000') {
        await firestoreService
            .useYachtPointToGiftishow(
          giftishowModel,
          phoneNumber,
          userRealName,
        )
            .then((value) {
          assetViewModel.reloadUserAsset();
          isExchanging(false);
          isExchangeAllDone(true);
        });
      }
    });

    // print('after function: ${isExchanging.value}');
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
