import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/models/user_post_model.dart';
import '../models/vote_comment_model.dart';
import '../models/database_address_model.dart';
import '../models/user_model.dart';
import '../models/user_vote_model.dart';
import '../models/vote_model.dart';
import '../services/navigation_service.dart';
import '../services/auth_service.dart';
import '../services/dialog_service.dart';
import '../services/database_service.dart';

import '../locator.dart';

class SubjectCommunityViewModel extends FutureViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  String uid;
  final int idx;
  final String date;

  DatabaseAddressModel address;
  UserModel user;
  VoteModel vote;
  UserVoteModel userVote;
  DatabaseAddressModel newAddress;

  SubjectCommunityViewModel(this.date, this.idx) {
    uid = _authService.auth.currentUser.uid;
  }

  @override
  Future futureToRun() => getAllModel(uid);

  Future getAllModel(uid) async {
    // setBusy(true);
    address = await _databaseService.getAddress(uid);
    newAddress = DatabaseAddressModel(
      uid: uid,
      date: date,
      category: address.category,
      season: address.season,
      isVoting: address.isVoting,
    );
    newAddress.subVote = idx.toString();
    print(address);
    user = await _databaseService.getUser(uid);
    vote = await _databaseService.getVotes(newAddress);
    userVote = await _databaseService.getUserVote(newAddress);
    // setBusy(false);
    notifyListeners();
  }

  Future postComments(
    DatabaseAddressModel address,
    VoteCommentModel voteCommentModel,
  ) async {
    print("Async Start");

    UserPostModel userPostModel;
    userPostModel = UserPostModel(
      category: address.category,
      season: address.season,
      subVote: address.subVote,
      date: address.date,
      createdAt: voteCommentModel.postDateTime,
    );
    await _databaseService.postSubVoteComment(
      address,
      voteCommentModel,
      userPostModel,
    );
  }

  Future deleteComment(
    DatabaseAddressModel address,
    String postUid,
  ) async {
    print("Dialog shown");
    var dialogResult = await _dialogService.showDialog(
        title: "코멘트 삭제",
        description: "해당 코멘트를 정말 삭제하시겠습니까?",
        buttonTitle: "Yes",
        cancelTitle: "No");

    if (dialogResult.confirmed) {
      print("user Confirmed");
      await _databaseService.deleteComment(address, postUid);
    } else {
      print("user Not Confirmed");
    }
  }

  Stream<List<VoteCommentModel>> getPost(DatabaseAddressModel address) {
    return _databaseService.getSubVotePostList(address);
  }

  Stream<PriceModel> getRealtimePrice(
    DatabaseAddressModel address,
    String issueCode,
  ) {
    return _databaseService.getRealtimeReturn(address, issueCode);
  }

//   List<String> listIssueCode(int idx) {
//     List<String> issueCodes = [];
//     print("CALLED");
//     for (int i = 0; i < vote.subVotes[idx].issueCode.length; i++) {
//       issueCodes.add(vote.subVotes[idx].issueCode[i]);
//     }
//     return issueCodes;
//   }
}
