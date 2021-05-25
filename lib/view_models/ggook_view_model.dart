import '../services/api/customized_ntp.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/date_time_model.dart';
import 'package:yachtOne/services/stateManage_service.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../models/user_vote_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import 'base_model.dart';

class GgookViewModel extends BaseViewModel {
  final DatabaseService? _databaseService = locator<DatabaseService>();
  final AuthService? _authService = locator<AuthService>();
  final StateManageService? _stateManageService = locator<StateManageService>();

  DatabaseAddressModel? _address;
  String? uid;

  GgookViewModel() {
    uid = _authService!.auth.currentUser!.uid;
  }

  Future addUserVoteDB(
    DatabaseAddressModel address,
    UserVoteModel userVote,
  ) async {
    await _databaseService!.addUserVote(address, userVote);
    await _stateManageService!.userVoteModelUpdate();
    print("FUTURE CALLED");
  }

  // Future updateUserItem(int newItem) async {
  //   await _databaseService.updateUserItem(uid, newItem);
  //   await _stateManageService.userModelUpdate();
  // }

  Future decreaseUserItem() async {
    await _databaseService!.decreaseUserItem(uid);
    await _stateManageService!.userModelUpdate();
  }

// subVote DB의 numVoted 업데이트
  Future counterUserVote(
    DatabaseAddressModel? address,
    List<int> voteSelected,
  ) async {
    await _databaseService!.countUserVote(address, voteSelected);
  }

  Future<DatabaseAddressModel?> getAddress() async {
    _address = await _databaseService!.getAddress(uid);
    return _address;
  }

  Future checkIfVotingTime(String? category) async {
    // DateTime now = await CustomizedNTP.now();
    DateTime now = DateTime.now();
    return DateTimeModel().isVoteAvailable(category, now);
  }
}
