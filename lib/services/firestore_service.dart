import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/models/stats_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreService => _firestoreService;

  CollectionReference get _tempCollectionReference =>
      _firestoreService.collection('temp');
  CollectionReference get tempCollectionReference => _tempCollectionReference;

  // 차트 그리기 위한 Historical Price
  Future<List<PriceChartModel>> getPrices() async {
    CollectionReference _samsungElectronic =
        _firestoreService.collection('stocksKR/005930/historicalPrices');
    CollectionReference _skBioPharm =
        _firestoreService.collection('stocksKR/326030/historicalPrices');
    List<PriceChartModel> _priceChartModelList = [];

    try {
      await _samsungElectronic
          .orderBy('dateTime', descending: true)
          .get()
          .then((querySnapshot) => querySnapshot.docs.forEach((doc) {
                // print(doc.id);  // document id 출력
                _priceChartModelList.add(PriceChartModel.fromMap(
                    doc.data() as Map<String, dynamic>));
              }));
      // print(_priceChartModelList);
      return _priceChartModelList;
    } catch (e) {
      throw e;
    }
  }

  Future<List<StatsModel>> getStats() async {
    CollectionReference _samsungElectronic =
        _firestoreService.collection('stocksKR/005930/stats');
    CollectionReference _skBioPharm =
        _firestoreService.collection('stocksKR/326030/stats');
    CollectionReference _abKo =
        _firestoreService.collection('stocksKR/129890/stats');
    List<StatsModel> _statstModelList = [];

    try {
      await _skBioPharm
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
}
