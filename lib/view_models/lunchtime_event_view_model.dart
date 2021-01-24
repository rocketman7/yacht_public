import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/lunchtime_vote_model.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/timezone_service.dart';
import 'package:timezone/timezone.dart' as tz;

class LunchtimeEventViewModel extends FutureViewModel {
  final lunchEventBaseDate;

  AuthService _authService = locator<AuthService>();
  DatabaseService _databaseService = locator<DatabaseService>();
  final TimezoneService _timezoneService = locator<TimezoneService>();

  String uid;
  String category;
  DatabaseAddressModel address;
  UserModel user;
  UserVoteModel userVote;
  LunchtimeVoteModel lunchtimeVoteModel;
  bool isEnabled = false;
  bool isEnded = false;
  bool checkingTimeFromServer = false;
  // List<LunchtimeSubVoteModel> lunchtimeVoteList;

  LunchtimeEventViewModel(this.lunchEventBaseDate) {
    uid = _authService.auth.currentUser.uid;
  }

  Future getAllModels() async {
    address = await _databaseService.getAddress(uid);
    address.date = lunchEventBaseDate;
    address.season = 'lunchEvent';
    user = await _databaseService.getUser(uid);
    print("LUNCHTIME" + address.season.toString());
    userVote = await _databaseService.getUserVote(address);

    lunchtimeVoteModel = await _databaseService.getLunchtimeVote(address);
    if (userVote.voteSelected == null && checkIfInVotingTime() == true) {
      isEnabled = true;
    }
    // print(lunchtimeVoteList);
  }

  Future addUserVote(String uid, UserVoteModel userVote) async {
    await _databaseService.addUserVote(address, userVote);
  }

  Future getLunchtimeVoteModel(address) async {
    checkingTimeFromServer = true;
    notifyListeners();
    lunchtimeVoteModel = await _databaseService.getLunchtimeVote(address);
    checkingTimeFromServer = false;
    notifyListeners();
  }

  Stream<PriceModel> getRealtimePrice(
    DatabaseAddressModel address,
    String issueCode,
  ) {
    print("Price Stream returns");
    return _databaseService.getRealtimeReturn(address, issueCode);
  }

  bool checkIfInVotingTime() {
    if (_timezoneService
            .koreaTime(DateTime.now())
            .isAfter(lunchtimeVoteModel.voteStartDateTime.toDate()) &&
        _timezoneService
            .koreaTime(DateTime.now())
            .isBefore(lunchtimeVoteModel.voteEndDateTime.toDate())) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future futureToRun() => getAllModels();
}
