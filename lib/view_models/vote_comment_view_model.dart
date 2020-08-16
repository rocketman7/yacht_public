import 'package:flutter/material.dart';
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

class VoteCommentViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  VoteCommentModel voteFeedModel;
  UserModel _user;
  VoteModel _votes;
  UserVoteModel _userVote;
  int subVoteIndex;

  Future postComments(
    subVoteIndex,
    VoteCommentModel voteCommentModel,
  ) async {
    await _databaseService.postComment(subVoteIndex, voteCommentModel);
  }

  Future deleteComment(
    subVoteIndex,
    postDateTime,
  ) async {
    print("Dialog shown");
    var dialogResult = await _dialogService.showDialog(
        title: "코멘트 삭제",
        description: "해당 코멘트를 정말 삭제하시겠습니까?",
        buttonTitle: "Yes",
        cancelTitle: "No");

    if (dialogResult.confirmed) {
      print("user Confirmed");
      await _databaseService.deleteComment(subVoteIndex, postDateTime);
    } else {
      print("user Not Confirmed");
    }
  }

  Future getUser(String uid) async {
    _user = await _databaseService.getUser(uid);
    return _user;
  }

  Future getVotes(String date) async {
    _votes = await _databaseService.getVotes(date);
    return _votes;
  }

  Future getUserVote(String uid, String date) async {
    _userVote = await _databaseService.getUserVote(uid, date);
    return _userVote;
  }
}
