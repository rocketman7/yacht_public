import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../models/rank_model.dart';
import '../models/season_model.dart';
import '../models/portfolio_model.dart';
import '../models/database_address_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';

class RankViewModel extends FutureViewModel {
  // Services Setting
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final NavigationService _navigationService = locator<NavigationService>();

  // 변수 Setting
  DatabaseAddressModel addressModel;
  SeasonModel seasonModel;
  PortfolioModel portfolioModel;
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
    portfolioModel = await _databaseService.getPortfolio(addressModel);
    user = await _databaseService.getUser(uid);
    seasonModel = await _databaseService.getSeasonInfo(addressModel);

    notifyListeners();
  }

  // 어드레스모델이 가리키는 날짜를 가져와서 xxxx.xx.xx 형식으로 변환
  String getDateFormChange() {
    return addressModel.date.substring(0, 4) +
        '.' +
        addressModel.date.substring(4, 6) +
        '.' +
        addressModel.date.substring(6, 8);
  }

  // 전일종가 기준 포트폴리오 총 가치를 계산하여 ###,###,### 형태로 반환
  String getPortfolioValue() {
    int totalValue = 0;

    for (int i = 0; i < portfolioModel.subPortfolio.length; i++) {
      totalValue += portfolioModel.subPortfolio[i].sharesNum *
          portfolioModel.subPortfolio[i].currentPrice;
    }

    var f = NumberFormat("#,###", "en_US");

    return f.format(totalValue);
  }

  // 시즌 몇 명 참여중인지 ###,###,### 형태로 변환하여 리턴해주는
  String getUsersNum() {
    var f = NumberFormat("#,###", "en_US");

    return f.format(rankModel.length);
  }

  // 포트폴리오화면으로 가는 버튼~
  void navigateToPortfolioPage() {
    _navigationService.navigateTo('portfolio');
  }

  // 남들 아바타이미지 불러오기
  Future<String> getOthersAvatar(String uid) async {
    var value = await _databaseService.getOthersInfo(uid, 'avatarImage');

    if (value == null) {
      return 'avatar';
    } else
      return value;
  }

  Future<void> addRank() {
    _databaseService.addRank();

    notifyListeners();

    return null;
  }

  @override
  Future futureToRun() => getUserAndRankList();
}
