import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yachtOne/models/price_chart_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreService => _firestoreService;

  CollectionReference get _tempCollectionReference =>
      _firestoreService.collection('temp');
  CollectionReference get tempCollectionReference => _tempCollectionReference;

  // 차트 그리기 위한 Historical Price
  Future<List<PriceChartModel>> getPrices() async {
    CollectionReference _samsungElectronic =
        _firestoreService.collection('temp/KR/005930');

    List<PriceChartModel> _priceChartModelList = [];
    print(_priceChartModelList);
    try {
      await _samsungElectronic.orderBy('date').get().then((querySnapshot) =>
          querySnapshot.docs.forEach((doc) {
            // print(doc.data());
            _priceChartModelList.add(
                PriceChartModel.fromMap(doc.data() as Map<String, dynamic>));
          }));
      // print(_priceChartModelList);
      return _priceChartModelList;
    } catch (e) {
      throw e;
    }
  }
}
