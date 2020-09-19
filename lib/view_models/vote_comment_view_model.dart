import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/services/dialog_service.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../models/user_vote_model.dart';
import '../models/vote_comment_model.dart';
import '../models/vote_comment_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

class VoteCommentViewModel extends FutureViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  VoteCommentModel voteFeedModel;

  int subVoteIndex;

  DatabaseAddressModel address;
  UserModel user;
  VoteModel vote;
  UserVoteModel userVote;
  String uid;

  VoteCommentViewModel() {
    // _authService.signOut();

    uid = _authService.auth.currentUser.uid;
    // getUser();
  }

  Future getAllModel(uid) async {
    setBusy(true);
    address = await _databaseService.getAddress(uid);
    user = await _databaseService.getUser(uid);
    vote = await _databaseService.getVotes(address);
    userVote = await _databaseService.getUserVote(address);
    setBusy(false);
  }

  Stream<List<VoteCommentModel>> getPost(DatabaseAddressModel address) {
    return _databaseService.getPostList(address);
  }

  Future postComments(
    DatabaseAddressModel address,
    VoteCommentModel voteCommentModel,
  ) async {
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
}
