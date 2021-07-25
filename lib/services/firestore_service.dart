import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/news_model.dart';
import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:yachtOne/models/corporation_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';

import '../models/subLeague_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreService => _firestoreService;

  CollectionReference get _tempCollectionReference =>
      _firestoreService.collection('temp');
  CollectionReference get tempCollectionReference => _tempCollectionReference;

  // CollectionReference userCollectionReference = _firestoreService.collection('users');

  // User Model 가져오기
  Future<UserModel> getUserModel(String uid) async {
    User _user;
    return await _firestoreService
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => UserModel.fromMap(value.data()!));
  }

  // 차트 그리기 위한 Historical Price
  Future<List<ChartPriceModel>> getPrices(
      StockAddressModel stockAddress) async {
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
  Future<List<StatsModel>> getStats(StockAddressModel stockAddress) async {
    // CollectionReference _samsungElectronic =
    //     _firestoreService.collection('stocksKR/005930/stats');
    // CollectionReference _skBioPharm =
    //     _firestoreService.collection('stocksKR/326030/stats');
    // CollectionReference _abKo =
    //     _firestoreService.collection('stocksKR/129890/stats');
    CollectionReference _statsRef = _firestoreService
        .collection('stocksKR/${stockAddress.issueCode}/stats');
    List<StatsModel> _statstModelList = [];

    try {
      await _statsRef
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

      for (int i = 0; i < temp.length; i++) {
        if (index == i) {
          temp[i] = temp[i] + 1;
        }
        _firestoreService
            .collection('temp')
            .doc('count')
            .update({'count': temp});
      }
    });
    // await _firestoreService.collection('temp').doc('count').update({
    //   // 'count': [FieldValue.increment(1), FieldValue.increment(1)]
    //   // 'count': [7, 8]
    // });
    // print(temp.data()!['count']);
  }

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
        allQuests.add(QuestModel.fromMap(element.id, element.data(), options));
        // print(allQuests);
      });
    });
    return allQuests;
  }

  //// User의 QuestModel
  // User QuestModel 가져오기
//     Future<UserQuestModel> getUserQuest(String uid) async {
// var userQuest = _firestoreService.collection('users').doc(uid).collection('userQuest').doc()
//     }

  // User QuestModel 업데이트

  // 기업 세부 정보 가져오기
  Future<CorporationModel> getCorporationInfo(
      StockAddressModel stockAddressModel) async {
    return await _firestoreService
        .collection('stocksKR')
        .doc('${stockAddressModel.issueCode}')
        .get()
        .then((value) => CorporationModel.fromMap(value.data()!));
  }

  Future<List<NewsModel>> getNews(StockAddressModel stockAddressModel) async {
    final List<NewsModel> allNews = [];
    await _firestoreService
        .collection('stocksKR')
        .doc('${stockAddressModel.issueCode}')
        .collection('news')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) => value.docs.forEach((element) {
              allNews.add(NewsModel.fromMap(element.data()));
            }));
    return allNews;
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
