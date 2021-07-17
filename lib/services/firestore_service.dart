import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:yachtOne/models/stock_model.dart';

import '../models/subLeague_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreService => _firestoreService;

  CollectionReference get _tempCollectionReference =>
      _firestoreService.collection('temp');
  CollectionReference get tempCollectionReference => _tempCollectionReference;

  // Stock Model 가져오기
  // Future<StockModel> getStockModel(String country, String issueCode) async {
  //   CollectionReference _stockRef;
  //   if (country == "KR") {
  //     _stockRef = _firestoreService.collection('stocksKR/$issueCode');
  //   }

  // }

  // 차트 그리기 위한 Historical Price
  Future<List<ChartPriceModel>> getPrices(
      StockAddressModel stockAddress) async {
    print('getting ${stockAddress.issueCode} prices');
    CollectionReference _samsungElectronic =
        _firestoreService.collection('stocksKR/005930/historicalPrices');
    CollectionReference _skBioPharm =
        _firestoreService.collection('stocksKR/326030/historicalPrices');
    CollectionReference _historicalPriceRef = _firestoreService
        .collection('stocksKR/${stockAddress.issueCode}/historicalPrices');
    List<ChartPriceModel> _priceChartModelList = [];

    try {
      await _historicalPriceRef
          .orderBy('dateTime', descending: true)
          .get()
          .then((querySnapshot) => querySnapshot.docs.forEach((doc) {
                // print(doc.id);  // document id 출력
                _priceChartModelList.add(ChartPriceModel.fromMap(
                    doc.data() as Map<String, dynamic>));
              }));
      // print(_priceChartModelList);
      return _priceChartModelList;
    } catch (e) {
      throw e;
    }
  }

  // Stat 가져오기
  Future<List<StatsModel>> getStats() async {
    CollectionReference _samsungElectronic =
        _firestoreService.collection('stocksKR/005930/stats');
    CollectionReference _skBioPharm =
        _firestoreService.collection('stocksKR/326030/stats');
    CollectionReference _abKo =
        _firestoreService.collection('stocksKR/129890/stats');
    List<StatsModel> _statstModelList = [];

    try {
      await _samsungElectronic
          .orderBy('dateTime', descending: true)
          .get()
          .then((querySnapshot) => querySnapshot.docs.forEach((doc) {
                // print(doc.id);  // document id 출력
                _statstModelList.add(
                    StatsModel.fromMap(doc.data() as Map<String, dynamic>));
              }));
      // print(_statstModelList);

      return _statstModelList;
    } catch (e) {
      throw e;
    }
  }

  Future countTest(int index) async {
    _firestoreService.collection('temp').doc('count').get().then((value) {
      var temp = value.data()!['count'];
      print(temp);

      for (int i = 0; i < temp.length; i++) {
        if (index == i) {
          temp[i] = temp[i] + 1;
        }
        _firestoreService
            .collection('temp')
            .doc('count')
            .update({'count': temp});
      }
      print(DateTime.now());
    });
    // await _firestoreService.collection('temp').doc('count').update({
    //   // 'count': [FieldValue.increment(1), FieldValue.increment(1)]
    //   // 'count': [7, 8]
    // });
    // print(temp.data()!['count']);
  }

  // Future<QuestModel> getQuest() async {
  //   // 1) get quest -> QuestModel 생성 : async step 1
  //   // 2) 여기에서 퀘스트의 자산 종류, 국가, 코드 get
  //   // 3) (KR이면) stocksKR collection 들어가서 get -> StockModel 생성 : async step n (퀘스트 종목 갯수)
  //   // 4) StockModel에서 logoURL -> Storage 접근, 이미지 get
  //   // 5) stocksKR -> stats -> StatsModel 생성 : async step n
  //   final QuestModel tempQuestModel = await _firestoreService
  //       .collection('leagues')
  //       .doc('league001')
  //       .collection('quests')
  //       .doc('quest001')
  //       .get()
  //       .then((value) {
  //     // print(value.data());
  //     return QuestModel.fromMap(value.data()!);
  //   });

  //   // final QuestModel tempQuestModel = QuestModel(
  //   //     category: "one",
  //   //     title: "7월 1일 수익률이 더 높을 종목은?",
  //   //     subtitle: "7월 1일 수익률 대결",
  //   //     country: "KR",
  //   //     pointReward: 3,
  //   //     cashReward: 50000,
  //   //     exp: 300,
  //   //     candidates: [
  //   //       {"stocks": "005930"},
  //   //       {"stocks": "326030"}
  //   //     ],
  //   //     counts: [300, 450],
  //   //     results: [1, 0],
  //   //     startDateTime: DateTime(2021, 6, 12, 08, 50, 00),
  //   //     endDateTime: DateTime(2021, 6, 20, 08, 50),
  //   //     resultDateTime: DateTime(2021, 6, 14, 16, 00));

  //   return tempQuestModel;
  // }

  // 홈에서 띄울 모든 Quest 가져오기
  Future<List<QuestModel>> getAllQuests() async {
    final List<QuestModel> allQuests = [];
    final List<StockAddressModel> options = [];
    await _firestoreService
        .collection('leagues')
        .doc('league001')
        .collection('quests')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        // options 필드의 List of Object를 아래와 같이 처리
        element.data()['options'].toList().forEach((option) {
          options.add(StockAddressModel.fromMap(option));
        });

        // print('questmodel options from db: $options');
        allQuests.add(QuestModel.fromMap(element.data(), options));
        // print(allQuests);
      });
    });

    return allQuests;
  }

  // 홈 및 서브리그세부 페이지에서 쓸 현재의 모든 서브리그 가져오기.
  // 현재 league를 가져오는 경우도 있을것이고(ex. league001), 다음 달 리그의 모든 세부리그를 가져올 수도 있음.
  Future<List<SubLeagueModel>> getAllSubLeague() async {
    final List<SubLeagueModel> allSubLeagues = [];

    await _firestoreService
        .collection('leagues') // 변하지 않음
        .doc('league001') // 변함. 현재 리그를 가져올지, 다음 리그를 가져올지 등에 따라. 값 자체도 변수로 줘야
        .collection('subLeagues') // 변하지 않음
        .get()
        .then((value) {
      value.docs.forEach((element) {
        allSubLeagues.add(SubLeagueModel.fromMap(element.data()));
      });
    });

    return allSubLeagues;
  }

  // state stream test용
  Stream<String> getStateStream1() {
    return _firestoreService
        .collection('leagues')
        .doc('league001')
        .snapshots()
        .map((snapshot) => snapshot.data()!['stateStream1']);
  }

  // state stream test용
  Stream<String> getStateStream2() {
    return _firestoreService
        .collection('leagues')
        .doc('league001')
        .snapshots()
        .map((snapshot) => snapshot.data()!['stateStream2']);
  }
}
