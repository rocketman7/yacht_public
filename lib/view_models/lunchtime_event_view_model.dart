import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/lunchtime_vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';

class LunchtimeEventViewModel extends FutureViewModel {
  AuthService _authService = locator<AuthService>();
  DatabaseService _databaseService = locator<DatabaseService>();

  String uid;
  String category;
  List<LunchtimeVoteModel> lunchtimeVoteList;

  LunchtimeEventViewModel() {
    uid = _authService.auth.currentUser.uid;
  }

  Future getAllModels() async {
    // print("GetVOteModel");
    lunchtimeVoteList = await _databaseService.getLunchtimeVote();
    // print(lunchtimeVoteList);
  }

  @override
  Future futureToRun() => getAllModels();
}
