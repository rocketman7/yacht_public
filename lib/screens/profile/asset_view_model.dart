import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../locator.dart';

// XX * update 필요부분
// XX 자산의 종가가 나오면 (ex, 한국시장 15:30 종가), 모든 user 의 userAsset 콜렉션의
// XX 모든 다큐먼트들의 자산 가격들(currentPrice)을 업데이트
// ==> 어차피 다른 사람들의 잔고는 ???로 표시할 것이므로 그냥 update 하지 않고 하나하나 불러오자.

// assetCategory { Award, Delivery, YachtPoint, UseYachtPoint }
// Award: 주식으로 상금을 받았을 때
// Ing: 주식을 딜리버리 중일 때
// Delivery: 주식을 출고했을 때
// YachtPoint: 요트포인트 받았을 때
// UseYachtPoint: 요트포인트 사용했을 때
// ==>  나의 현재 주식 잔고 = 모든 Award - 모든 Delivery - 모든 Ing
// ==>  나의 현재 요트 포인트 = 모든 YachtPoint - 모든 UseYachtPoint
// ==>  현재 찾아갈 수 있는 상금 = 모든 Award + 모든 YachtPoint
// ==>  출고 완료한 상금 = 모든 Delivery + 모든 UseYachtPoint
// ==>  요트와 함께 획득한 총 상금 = 모든 Award + 모든 Delivery + 모든 Ing + 모든 YachtPoint + 모든 UseYachtPoint

class AssetModel {
  final String assetCategory;
  final Timestamp tradeDate;
  final String tradeTitle;
  List<AwardModel>? awards;
  String? phoneNumber;
  String? userRealName;
  num? yachtPoint;

  AssetModel({
    required this.assetCategory,
    required this.tradeDate,
    required this.tradeTitle,
    this.awards,
    this.yachtPoint,
    this.phoneNumber,
    this.userRealName,
  });

  factory AssetModel.fromMap(Map<String, dynamic> map) {
    if (map['assetCategory'] == "Award" || map['assetCategory'] == "Delivery" || map['assetCategory'] == "Ing")
      return AssetModel(
        assetCategory: map['assetCategory'],
        tradeDate: map['tradeDate'],
        tradeTitle: map['tradeTitle'],
        awards: List<AwardModel>.from(map['awards']?.map((x) => AwardModel.fromMap(x))),
      );
    else
      return AssetModel(
        assetCategory: map['assetCategory'],
        tradeDate: map['tradeDate'],
        tradeTitle: map['tradeTitle'],
        yachtPoint: map['yachtPoint'],
      );
  }

  Map<String, dynamic> toMapAwards() {
    return {
      'assetCategory': assetCategory,
      'tradeDate': tradeDate,
      'tradeTitle': tradeTitle,
      'awards': awards == null ? null : awards!.map((x) => x.toMap()).toList(),
      'yachtPoint': yachtPoint,
      'phoneNumber': phoneNumber,
      'userRealName': userRealName,
    };
  }
}

class AwardModel {
  final String issueCode;
  final String name;
  final num priceAtTrade;
  final num sharesNum;

  AwardModel({
    required this.issueCode,
    required this.name,
    required this.priceAtTrade,
    required this.sharesNum,
  });

  factory AwardModel.fromMap(Map<String, dynamic> map) {
    return AwardModel(
      issueCode: map['issueCode'],
      name: map['name'],
      priceAtTrade: map['priceAtTrade'],
      sharesNum: map['sharesNum'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'issueCode': issueCode,
      'name': name,
      'priceAtTrade': priceAtTrade,
      'sharesNum': sharesNum,
    };
  }
}

// 보유자산, 주식 잔고 출고 화면 등 공통적으로 쓰이는 view모델이고 아래 모델도
// 공통적으로 써야하기 때문에 매번 퓨쳐로 해주는거보다 이렇게 따로 빼는게 나은거 같음.
class HoldingAwardModel {
  final String issueCode;
  final String name;
  final double currentPrice;
  final double priceAtAward;
  final num sharesNum;

  HoldingAwardModel(
      {required this.issueCode,
      required this.name,
      required this.currentPrice,
      required this.priceAtAward,
      required this.sharesNum});
}

class AssetViewModel extends GetxController {
  //////////////////////// database service 부분 ////////////////////////
  final FirebaseFirestore firestoreService = FirebaseFirestore.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  Future<List<AssetModel>> getAllAssets(String uid) async {
    final List<AssetModel> allAssets = [];

    await firestoreService
        .collection('users')
        .doc(uid)
        .collection('userAsset')
        .orderBy('tradeDate', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        // print(element.data());

        allAssets.add(AssetModel.fromMap(element.data()));
      });
    });

    return allAssets;
  }

  Future<double> getCurrentStocksPrice(String issueCode) async {
    late double currentStocksPrice;

    await firestoreService
        .collection('stocksKR')
        .doc(issueCode)
        .collection('historicalPrices')
        .where('cycle', isEqualTo: 'D')
        .orderBy('dateTime', descending: true)
        .limit(1)
        .get()
        .then((value) {
      currentStocksPrice = value.docs[0].data()['close'].toDouble();
    });

    return currentStocksPrice;
  }

  Future<bool> updateUserAsset(String uid, AssetModel ingAssetModel) async {
    try {
      await firestoreService.collection('users').doc(uid).collection('userAsset').add(
            ingAssetModel.toMapAwards(),
          );
    } catch (e) {
      return false;
    }

    return true;
  }

  ///////////////////////// 실제 Controller 부분 /////////////////////////
  static AssetViewModel get to => Get.find();

  late List<AssetModel> allAssets;
  //현재 잔고 보여주기 위한 변수들
  Map<String, String> stocksNameMap = {};
  Map<String, int> stocksSharesNumMap = {};
  Map<String, double> stocksAveragePriceAtAwardMap = {};
  //위 세 맵들을 모으자.
  late List<HoldingAwardModel> allHoldingStocks = [];
  bool isHoldingStocksFutureLoad = false;
  int totalYachtPoint = 0;

  int expiredYachtPoint = 0;
  int aliveYachtPoint = 0;
  int usedYachtPointBeforeStandard = 0;
  int usedYahctPointAfterStandard = 0;

  double totalHoldingStocksValue = 0.0;
  double totalDeliveriedValue = 0.0;
  //주식 잔고 출고 페이지에서 사용자가 값을 바꾸는 obs 변수들
  List<RxInt> stocksDeliveryNum = [0.obs];
  RxDouble totalDeliveryValue = 0.0.obs;
  //상금 히스토리 더보기 화면 전 최대 보여줄 갯수
  int maxHistoryVisibleNum = 3;
  String checkNameUrl = "";
  RxString checkNameExists = "0".obs;
  //
  RxBool isDeliveryIng = false.obs;
  Timestamp rewardExpireDate = Timestamp(0, 0);
  Timestamp myRecentYachtPointBeforeExpire = Timestamp(0, 0);

  @override
  void onInit() async {
    stocksNameMap = {};
    stocksSharesNumMap = {};
    stocksAveragePriceAtAwardMap = {};
    //위 세 맵들을 모으자.
    allHoldingStocks = [];
    isHoldingStocksFutureLoad = false;
    totalYachtPoint = 0;

    totalHoldingStocksValue = 0.0;
    totalDeliveriedValue = 0.0;
    //주식 잔고 출고 페이지에서 사용자가 값을 바꾸는 obs 변수들
    stocksDeliveryNum = [0.obs];
    totalDeliveryValue = 0.0.obs;
    // allAssets = await getAllAssets('kakao:1518231402');
    // allAssets = await getAllAssets('kakao:1513684681');
    allAssets = await getAllAssets(userModelRx.value!.uid);

    rewardExpireDate = await getRewardExpireDate();
    myRecentYachtPointBeforeExpire = await getMyRecentYachtPointBeforeExpire();

    checkNameUrl = await _firestoreService.checkNameUrl();
    checkNameExists.bindStream(_firestoreService.getNameCheckResult(userModelRx.value!.uid));
    update(['assets']);

    calcHoldingStocksAndYachtPoint();

    stocksDeliveryNum.clear();

    await calcAllHoldingStocks();
    print('totalHoldingStocksValue: $totalHoldingStocksValue');
    super.onInit();
  }

  Future<Timestamp> getRewardExpireDate() async {
    return _firestoreService.firestoreService.collection('admin').doc('adminPost').get().then((value) {
      print('rewardExpireDate: ${value['rewardExpireDate'].toDate()}');
      return value['rewardExpireDate'];
    });
  }

  Future<Timestamp> getMyRecentYachtPointBeforeExpire() async {
    return _firestoreService.firestoreService
        .collection('users/${userModelRx.value!.uid}/userAsset')
        .orderBy('tradeDate', descending: true)
        .where('tradeDate', isLessThan: rewardExpireDate)
        .get()
        .then((value) {
      print('myrecentYPbeforeExpire: ${value.docs.first['tradeDate'].toDate()}');
      return value.docs.first['tradeDate'];
    });
  }

  // 현재 보유 중인 주식을 계산해준다.
  // 만약 같은 주식을 n번에 걸쳐 받았다면 평단도 계산해줘야 함.
  // 그리고 0인 경우는 보유 주식이라고 볼 수 없음
  void calcHoldingStocksAndYachtPoint() {
    // Award - Delivery => 현재 보유 주식 계산, YachtPoint - UseYachtPoint => 현재 보유 요트 포인트 계산
    for (int i = 0; i < allAssets.length; i++) {
      if (allAssets[i].assetCategory == "Award") {
        for (int j = 0; j < allAssets[i].awards!.length; j++) {
          if (!stocksNameMap.containsKey('${allAssets[i].awards![j].issueCode}')) {
            stocksNameMap['${allAssets[i].awards![j].issueCode}'] = allAssets[i].awards![j].name;
          }

          if (stocksSharesNumMap.containsKey('${allAssets[i].awards![j].issueCode}')) {
            stocksSharesNumMap.update(
                '${allAssets[i].awards![j].issueCode}', (value) => (value + allAssets[i].awards![j].sharesNum.toInt()));
          } else {
            stocksSharesNumMap['${allAssets[i].awards![j].issueCode}'] = allAssets[i].awards![j].sharesNum.toInt();
          }
        }
      } else if (allAssets[i].assetCategory == "Delivery") {
        for (int j = 0; j < allAssets[i].awards!.length; j++) {
          if (!stocksNameMap.containsKey('${allAssets[i].awards![j].issueCode}')) {
            stocksNameMap['${allAssets[i].awards![j].issueCode}'] = allAssets[i].awards![j].name;
          }

          if (stocksSharesNumMap.containsKey('${allAssets[i].awards![j].issueCode}')) {
            stocksSharesNumMap.update(
                '${allAssets[i].awards![j].issueCode}', (value) => (value - allAssets[i].awards![j].sharesNum.toInt()));
          } else {
            stocksSharesNumMap['${allAssets[i].awards![j].issueCode}'] = -allAssets[i].awards![j].sharesNum.toInt();
          }

          totalDeliveriedValue += allAssets[i].awards![j].priceAtTrade * allAssets[i].awards![j].sharesNum;
        }
      } else if (allAssets[i].assetCategory == "Ing") {
        for (int j = 0; j < allAssets[i].awards!.length; j++) {
          if (!stocksNameMap.containsKey('${allAssets[i].awards![j].issueCode}')) {
            stocksNameMap['${allAssets[i].awards![j].issueCode}'] = allAssets[i].awards![j].name;
          }

          if (stocksSharesNumMap.containsKey('${allAssets[i].awards![j].issueCode}')) {
            stocksSharesNumMap.update(
                '${allAssets[i].awards![j].issueCode}', (value) => (value - allAssets[i].awards![j].sharesNum.toInt()));
          } else {
            stocksSharesNumMap['${allAssets[i].awards![j].issueCode}'] = -allAssets[i].awards![j].sharesNum.toInt();
          }

          totalDeliveriedValue += allAssets[i].awards![j].priceAtTrade * allAssets[i].awards![j].sharesNum;
        }
      } else if (allAssets[i].assetCategory == "YachtPoint" &&
          allAssets[i].tradeDate.compareTo(rewardExpireDate) >= 0) {
        aliveYachtPoint += allAssets[i].yachtPoint!.toInt();
      } else if (allAssets[i].assetCategory == "YachtPoint" && allAssets[i].tradeDate.compareTo(rewardExpireDate) < 0) {
        expiredYachtPoint += allAssets[i].yachtPoint!.toInt();
      } else if (allAssets[i].assetCategory == "UseYachtPoint") {
        if (allAssets[i].tradeDate.compareTo(Timestamp(
                myRecentYachtPointBeforeExpire.seconds + (31536000), myRecentYachtPointBeforeExpire.nanoseconds)) >=
            0) {
          usedYahctPointAfterStandard += allAssets[i].yachtPoint!.toInt();
        } else {
          usedYachtPointBeforeStandard += allAssets[i].yachtPoint!.toInt();
        }
      }

      //  else if (allAssets[i].assetCategory == "UseYachtPoint" &&
      //     allAssets[i].tradeDate.compareTo(Timestamp(
      //             myRecentYachtPointBeforeExpire.seconds + (31536000), myRecentYachtPointBeforeExpire.nanoseconds)) >=
      //         0) {
      //   print('use after expire: ${allAssets[i].yachtPoint}');
      //   totalYachtPoint -= allAssets[i].yachtPoint!.toInt();
      //   totalDeliveriedValue += allAssets[i].yachtPoint!;
      // }

      // } else if (allAssets[i].assetCategory == "YachtPoint") {
      //   totalYachtPoint += allAssets[i].yachtPoint!.toInt();
      // } else if (allAssets[i].assetCategory == "UseYachtPoint") {
      //   totalYachtPoint -= allAssets[i].yachtPoint!.toInt();
      //   totalDeliveriedValue += allAssets[i].yachtPoint!;
      // }
    }
    print(
        'point breakdown: $aliveYachtPoint $expiredYachtPoint $usedYachtPointBeforeStandard $usedYahctPointAfterStandard');

    if (expiredYachtPoint < usedYachtPointBeforeStandard) {
      totalYachtPoint =
          expiredYachtPoint + aliveYachtPoint - usedYachtPointBeforeStandard - usedYahctPointAfterStandard;
    } else {
      totalYachtPoint = aliveYachtPoint - usedYahctPointAfterStandard;
    }

    if (totalYachtPoint <= 0) totalYachtPoint = 0;
    print('totalYachtPoint: $totalYachtPoint');
    // Award 당시 평단 계산
    Map<String, double> stocksAccumPrice = {};
    Map<String, int> stocksSharesNum = {};
    stocksNameMap.forEach((key, value) {
      stocksAveragePriceAtAwardMap['$key'] = 0.0;
      stocksAccumPrice['$key'] = 0.0;
      stocksSharesNum['$key'] = 0;
    });
    for (int i = 0; i < allAssets.length; i++) {
      if (allAssets[i].assetCategory == "Award") {
        for (int j = 0; j < allAssets[i].awards!.length; j++) {
          stocksAccumPrice.update('${allAssets[i].awards![j].issueCode}',
              (value) => (value + allAssets[i].awards![j].priceAtTrade * allAssets[i].awards![j].sharesNum.toInt()));
          stocksSharesNum.update(
              '${allAssets[i].awards![j].issueCode}', (value) => (value + allAssets[i].awards![j].sharesNum.toInt()));
        }
      }
    }
    stocksAveragePriceAtAwardMap.forEach((key, value) {
      stocksAveragePriceAtAwardMap.update(key, (value) => (stocksAccumPrice[key]! / (stocksSharesNum[key]!.toInt())));
    });
  }

  Future<void> calcAllHoldingStocks() async {
    for (var key in stocksSharesNumMap.keys) {
      double currentPrice = await getCurrentStocksPrice(key);

      if (stocksSharesNumMap[key] != 0) {
        allHoldingStocks.add(HoldingAwardModel(
            issueCode: key,
            name: stocksNameMap[key]!,
            priceAtAward: stocksAveragePriceAtAwardMap[key]!,
            sharesNum: stocksSharesNumMap[key]!,
            currentPrice: currentPrice));

        stocksDeliveryNum.add(0.obs);

        totalHoldingStocksValue += currentPrice * stocksSharesNumMap[key]!;
      }
    }

    isHoldingStocksFutureLoad = true;
    update(['holdingStocks']);

    // print('total value ' + totalHoldingStocksValue.toString());
  }

  void tapPlusButton(int index) {
    stocksDeliveryNum[index](stocksDeliveryNum[index].value < allHoldingStocks[index].sharesNum
        ? stocksDeliveryNum[index].value + 1
        : stocksDeliveryNum[index].value);

    calcTotalDeliveryValue();
  }

  void tapMinusButton(int index) {
    stocksDeliveryNum[index](
        stocksDeliveryNum[index].value > 0 ? stocksDeliveryNum[index].value - 1 : stocksDeliveryNum[index].value);

    calcTotalDeliveryValue();
  }

  void calcTotalDeliveryValue() {
    totalDeliveryValue(0);

    for (int i = 0; i < allHoldingStocks.length; i++) {
      totalDeliveryValue(totalDeliveryValue.value + allHoldingStocks[i].currentPrice * stocksDeliveryNum[i].value);
    }
  }

  Future deliveryToME() async {
    // print('deliveryToME');

    if (!isDeliveryIng.value) {
      isDeliveryIng(true);

      for (int i = 0; i < allHoldingStocks.length; i++) {
        if (stocksDeliveryNum[i].value != 0) {
          AssetModel ingAssetModel = AssetModel(
              assetCategory: 'Ing',
              tradeDate: Timestamp.fromDate(DateTime.now()),
              tradeTitle: '${allHoldingStocks[i].name} ${stocksDeliveryNum[i].value}주 출고',
              awards: [
                AwardModel(
                  issueCode: '${allHoldingStocks[i].issueCode}',
                  name: '${allHoldingStocks[i].name}',
                  sharesNum: stocksDeliveryNum[i].value,
                  priceAtTrade: allHoldingStocks[i].currentPrice,
                )
              ]);

          await updateUserAsset(userModelRx.value!.uid, ingAssetModel);
        }
      }

      // isDeliveryIng(false);
    }
  }

  Future reloadUserAsset() async {
    // 하고 모든 유저애샛모델 재로드 (변수들 초기화 + onInit부분 복사)
    stocksNameMap = {};
    stocksSharesNumMap = {};
    stocksAveragePriceAtAwardMap = {};
    allHoldingStocks = [];
    isHoldingStocksFutureLoad = false;
    totalYachtPoint = 0;
    totalHoldingStocksValue = 0.0;
    totalDeliveriedValue = 0.0;
    stocksDeliveryNum.clear();
    totalDeliveryValue(0.0);

    allAssets = await getAllAssets(userModelRx.value!.uid);

    update(['assets']);

    calcHoldingStocksAndYachtPoint();

    await calcAllHoldingStocks();
  }

  void deliveryToFRIEND() {
    // print('deliveryToFRIEND');
  }

  // 출고대기중/완료/요트포인트 획득 등의 문자를 생성하여 리턴해준다
  String getStringTradeDetail(int index) {
    switch (allAssets[index].assetCategory) {
      case "Award":
        String temp = (allAssets[index].awards!.length > 1) ? " 외 ${allAssets[index].awards!.length - 1}건" : "";
        return "${allAssets[index].awards![0].name} ${allAssets[index].awards![0].sharesNum}주" + temp;
      case "Ing":
        return "출고 대기중";
      case "Delivery":
        return "출고 완료";
      case "YachtPoint":
        return "요트 포인트 획득";
      case "UseYachtPoint":
        return "요트 포인트 사용";
      case "YachtPointExpired":
        return "기한만료";
      default:
        return "";
    }
  }

  //
  String plusSymbolReturn(int index) {
    switch (allAssets[index].assetCategory) {
      case "Award":
        return "+";
      case "YachtPoint":
        return "+";
      default:
        return "";
    }
  }

  // 금액 문자를 생성하여 리턴해준다.
  num getNumTotalAwardsOrYachtPoint(int index) {
    switch (allAssets[index].assetCategory) {
      case "Award":
        double totalValue = 0.0;
        for (var items in allAssets[index].awards!) {
          totalValue += items.priceAtTrade * items.sharesNum;
        }
        return totalValue;
      case "Ing":
        double totalValue = 0.0;
        for (var items in allAssets[index].awards!) {
          totalValue -= items.priceAtTrade * items.sharesNum;
        }
        return totalValue;
      case "Delivery":
        double totalValue = 0.0;
        for (var items in allAssets[index].awards!) {
          totalValue -= items.priceAtTrade * items.sharesNum;
        }
        return totalValue;
      case "YachtPoint":
        return allAssets[index].yachtPoint!;
      case "UseYachtPoint":
        return -allAssets[index].yachtPoint!;
      default:
        return 0;
    }
  }

  // 색깔 결정
  Color getColorTotalAwardsOrYachtPointNum(int index) {
    switch (allAssets[index].assetCategory) {
      case "Award":
        return yachtRed;
      case "Ing":
        return yachtBlue;
      case "Delivery":
        return yachtBlue;
      case "YachtPoint":
        return yachtRed;
      case "UseYachtPoint":
        return yachtBlue;
      default:
        return yachtMidGrey;
    }
  }
}
