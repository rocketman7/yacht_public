// local state, db state 를 관리하여 DB에 접근할지, 로컬 값 그대로 쓸 지 관리해주는.
// global local model 들도 여기다 저장?

import 'package:yachtOne/models/user_vote_model.dart';

import '../locator.dart';
import 'auth_service.dart';
import 'database_service.dart';

import '../models/database_address_model.dart';
import '../models/stateManeger_model.dart';
import '../models/user_model.dart';
import '../models/season_model.dart';
import '../models/portfolio_model.dart';
import '../models/vote_model.dart';

// 아래에 local model 들을 선언해준다. 전역변수로 관리.
// 아래 local model 들은 사용자의 로컬 기기에서 check point 를 넘지 못하면 쭉 유지된다.
// 사용자의 로컬 기기에서 check point 를 넘어 local state가 변한다면,
// 실제 DB의 state 역시 변했는가 체크하고, local model 를 업데이트해준다.
DatabaseAddressModel localAddressModel;
StateManagerModel localStateManagerModel;
UserModel localUserModel;
SeasonModel localSeasonModel;
PortfolioModel localPortfolioModel;
VoteModel localVoteModel;
UserVoteModel localUserVoteModel;

String localMyState;

bool appStart = true;

abstract class StateManagerServiceService {
  Future<void> initStateManager();

  String calcState();
  void setLocalState(String viewState);
  bool hasLocalStateChange(String viewState);
  Future<bool> hasDBStateChange(String viewState);

  Future<void> reloadStateManager();

  Future<void> reloadAllDB();
  Future<void> reloadAddressModel();
  Future<void> reloadSeasonModel();
  Future<void> reloadPortfolioModel();
  Future<void> reloadUserModel();
  Future<void> reloadVoteModel();
  Future<void> reloadUserVoteModel();
}

class StateManagerServiceServiceFirebase extends StateManagerServiceService {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final AuthService _authService = locator<AuthService>();

  String uid;

  @override
  Future<void> initStateManager() async {
    uid = _authService.auth.currentUser.uid;

    await reloadAllDB();
    localMyState = calcState();
    // localMyState = '101801';

    appStart = false;
  }

  @override
  String calcState() {
    String myState;
    bool stateChange = false;
    DateTime nowKor = DateTime.now();
    myState = nowKor.month.toString() + nowKor.day.toString();

    for (int i = 0; i < localStateManagerModel.checkPoint.length; i++) {
      String tempDate = nowKor.year.toString() +
          nowKor.month.toString() +
          nowKor.day.toString() +
          'T' +
          localStateManagerModel.checkPoint[i].toString().substring(0, 2) +
          localStateManagerModel.checkPoint[i].toString().substring(2, 4) +
          '00';

      DateTime tempDateTime = DateTime.parse(tempDate).toUtc();
      if (tempDateTime.compareTo(nowKor) > 0) {
        stateChange = true;
        if (i < 10)
          myState = myState + '0' + i.toString();
        else
          myState = myState + i.toString();
      }
    }

    if (!stateChange) if (localStateManagerModel.checkPoint.length < 10)
      myState =
          myState + '0' + localStateManagerModel.checkPoint.length.toString();
    else
      myState = myState + localStateManagerModel.checkPoint.length.toString();

    print('myState is,,,,,,,,' + myState);

    return myState;
  }

  @override
  void setLocalState(String viewState) {
    // localMyState = viewState;
  }

  @override
  bool hasLocalStateChange(String viewState) {
    // if (viewState != localMyState) {
    //   print('localState($localMyState) change.. so update');
    //   return true;
    // } else {
    //   print('localState($localMyState) unchange.. so update X');
    //   return false;
    // }
    //일단 임시로 무조건 로딩되도록 true로
    return true;
  }

  @override
  Future<bool> hasDBStateChange(String viewState) async {
    // localStateManagerModel = await _databaseService.getStateManager();

    // // 위는 != 이고 얘는 == 인 이유는 DB는 상태가 맞게 바뀌어있을것이기 때문
    // if (viewState == localStateManagerModel.state) {
    //   print('DBState(${localStateManagerModel.state}) correct.. so update');
    //   //DB까지 통과해야 비로소 local 바꿔줘야
    //   // setLocalState(viewState);
    //   return true;
    // } else {
    //   print('DBState(${localStateManagerModel.state}) uncorrect.. so update X');
    //   return false;
    // }
    //일단 임시로 무조건 로딩되도록 true로
    return true;
  }

  @override
  Future<void> reloadStateManager() async {
    localStateManagerModel = await _databaseService.getStateManager();
  }

  @override
  Future<void> reloadAllDB() async {
    await reloadAddressModel();
    await reloadStateManager();
    await reloadUserModel();
    await reloadSeasonModel();
    await reloadPortfolioModel();
    await reloadVoteModel();
    await reloadUserVoteModel();
  }

  @override
  Future<void> reloadAddressModel() async {
    print('reloadAddressModel');
    localAddressModel = await _databaseService.getAddress(uid);
  }

  @override
  Future<void> reloadSeasonModel() async {
    print('reloadSeasonModel');
    localSeasonModel = await _databaseService.getSeasonInfo(localAddressModel);
  }

  @override
  Future<void> reloadPortfolioModel() async {
    print('reloadPortfolioModel');
    localPortfolioModel =
        await _databaseService.getPortfolio(localAddressModel);
  }

  @override
  Future<void> reloadUserModel() async {
    print('reloadUserModel');
    localUserModel = await _databaseService.getUser(uid);
  }

  @override
  Future<void> reloadVoteModel() async {
    print('reloadVoteModel');
    localVoteModel = await _databaseService.getVotes(localAddressModel);
  }

  @override
  Future<void> reloadUserVoteModel() async {
    print('reloadUserVoteModel');
    localUserVoteModel = await _databaseService.getUserVote(localAddressModel);
  }

  // getter들

}
