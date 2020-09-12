import 'package:stacked/stacked.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../models/rank_model.dart';
import '../models/database_address_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class RankViewModel extends FutureViewModel {
  // Services Setting
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  // 변수 Setting
  DatabaseAddressModel addressModel;
  List<RankModel> rankModel = [];
  UserModel user;
  String uid;

  RankViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  // method
  Future getUserAndRankList() async {
    addressModel = await _databaseService.getAddress(uid);
    rankModel = await _databaseService.getRankList(addressModel);
    user = await _databaseService.getUser(uid);

    notifyListeners();
  }

  Future<void> addRank() {
    _databaseService.addRank();

    notifyListeners();

    return null;
  }

  @override
  Future futureToRun() => getUserAndRankList();
}
