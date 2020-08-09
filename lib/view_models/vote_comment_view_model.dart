import 'package:flutter/material.dart';
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
