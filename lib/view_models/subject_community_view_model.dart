import 'package:stacked/stacked.dart';
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

  DatabaseAddressModel address;
  UserModel user;
  VoteModel vote;
  UserVoteModel userVote;

  SubjectCommunityViewModel(this.idx) {
    uid = _authService.auth.currentUser.uid;
  }

  Future getAllModel(uid) async {
    setBusy(true);
    address = await _databaseService.getAddress(uid);
    address.subVote = idx.toString();
    print(address);
    user = await _databaseService.getUser(uid);
    vote = await _databaseService.getVotes(address);
    userVote = await _databaseService.getUserVote(address);
    setBusy(false);
  }

  Future postComments(
    DatabaseAddressModel address,
    VoteCommentModel voteCommentModel,
  ) async {
    print("Async Start");
    await _databaseService.postComment(address, voteCommentModel);
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

  @override
  Future futureToRun() => getAllModel(uid);

  Stream<List<VoteCommentModel>> getPost(DatabaseAddressModel address) {
    return _databaseService.getPostList(address);
  }
}
