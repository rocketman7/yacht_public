import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/chart_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';

import '../locator.dart';

class ChartViewModel extends FutureViewModel {
  AuthService _authService = locator<AuthService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  List<ChartModel> chartList;
  String uid;

  ChartViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getAllModel(uid) async {
    chartList = await _databaseService.getPriceForChart('005930');
  }

  @override
  Future futureToRun() => getAllModel(uid);
}
