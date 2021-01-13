import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/lunchtime_vote_model.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';

class LunchtimeEventViewModel extends FutureViewModel {
  AuthService _authService = locator<AuthService>();
  DatabaseService _databaseService = locator<DatabaseService>();

  String uid;
  String category;
  DatabaseAddressModel address;
  UserModel user;
  UserVoteModel userVote;
  LunchtimeVoteModel lunchtimeVoteModel;
  // List<LunchtimeSubVoteModel> lunchtimeVoteList;

  LunchtimeEventViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getAllModels() async {
    address = await _databaseService.getAddress(uid);
    address.season = 'lunchEvent';
    user = await _databaseService.getUser(uid);
    print("LUNCHTIME" + address.season.toString());
    userVote = await _databaseService.getUserVote(address);
    lunchtimeVoteModel = await _databaseService.getLunchtimeVote(address);
    // print(lunchtimeVoteList);
  }

  Future addUserVote(String uid, UserVoteModel userVote) async {
    await _databaseService.addUserVote(address, userVote);
  }

  @override
  Future futureToRun() => getAllModels();
}
