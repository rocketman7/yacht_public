import '../locator.dart';
import 'auth_service.dart';
import 'database_service.dart';

import '../models/stateManage_model.dart';

import '../models/database_address_model.dart';
import '../models/user_model.dart';
import '../models/user_vote_model.dart';
import '../models/season_model.dart';
import '../models/portfolio_model.dart';
import '../models/vote_model.dart';
import '../models/rank_model.dart';

abstract class StateManageService {
  StateManageModel get stateManageModel;

  DatabaseAddressModel get addressModel;
  UserModel get userModel;
  UserVoteModel get userVoteModel;
  SeasonModel get seasonModel;
  PortfolioModel get portfolioModel;
  VoteModel get voteModel;
  List<RankModel> get rankModel;

  String get myState;
  bool get appStart;

  Future<void> initStateManage({String initUid});
  Future<void> getAllModels();
  Future<bool> isNeededUpdate();

  Future<void> userModelUpdate();
  Future<void> userVoteModelUpdate();
  setMyState();
  setAppStart();
}

class StateManageServiceFirebase extends StateManageService {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final AuthService _authService = locator<AuthService>();

  String uid;

  StateManageModel _stateManageModel;

  //아래에 앱 내에서 쓰일 모든 모델들을 선언해주어야.
  DatabaseAddressModel _addressModel;
  UserModel _userModel;
  UserVoteModel _userVoteModel;
  SeasonModel _seasonModel;
  PortfolioModel _portfolioModel;
  VoteModel _voteModel;
  List<RankModel> _rankModel = [];

  //나의 로컬스테이트.
  String _myState;
  bool _appStart = true;

  // getter
  StateManageModel get stateManageModel => _stateManageModel;

  // total -> 7개
  DatabaseAddressModel get addressModel => _addressModel;
  UserModel get userModel => _userModel;
  UserVoteModel get userVoteModel => _userVoteModel;
  SeasonModel get seasonModel => _seasonModel;
  PortfolioModel get portfolioModel => _portfolioModel;
  VoteModel get voteModel => _voteModel;
  List<RankModel> get rankModel => _rankModel;

  String get myState => _myState;

  setMyState() {
    _myState = null;
  }

  setAppStart() {
    _appStart = true;
  }

  bool get appStart => _appStart;

  // method
  @override
  Future<void> initStateManage({String initUid}) async {
    uid = initUid ?? _authService.currentUser.uid;
    await getAllModels();
    _myState = _stateManageModel.state;

    _appStart = false;
  }

  @override
  Future<void> getAllModels() async {
    uid = _authService.auth.currentUser.uid;
    _stateManageModel = await _databaseService.getStateManage();

    // total -> 7개 불러와야
    print("ADDRESS GET START" + DateTime.now().toString());
    _addressModel = await _databaseService.getAddress(uid);
    print("ADDRESS GET DONE" + DateTime.now().toString());
    _userVoteModel = await _databaseService.getUserVote(_addressModel);
    _userModel = await _databaseService.getUser(uid);
    _seasonModel = await _databaseService.getSeasonInfo(_addressModel);
    _portfolioModel = await _databaseService.getPortfolio(addressModel);
    _voteModel = await _databaseService.getVotes(_addressModel);
    _rankModel = await _databaseService.getRankList(_addressModel);
  }

  @override
  Future<bool> isNeededUpdate() async {
    _stateManageModel = await _databaseService.getStateManage();

    return (_myState != _stateManageModel.state);
  }

  @override
  Future<void> userModelUpdate() async {
    // userModel 을 수정시킨 user단의 액션이 있을 때, 호출해준다
    _userModel = await _databaseService.getUser(uid);
  }

  @override
  Future<void> userVoteModelUpdate() async {
    // userVoteModel 을 수정시킨 user단의 액션이 있을 때, 호출해준다
    _userVoteModel = await _databaseService.getUserVote(_addressModel);
  }

  // setter

}
