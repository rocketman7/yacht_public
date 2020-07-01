import 'package:flutter/material.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/models/vote_comment_model.dart';
import 'package:yachtOne/models/vote_comment_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/base_model.dart';

class VoteCommentViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  VoteCommentModel voteFeedModel;
  UserModel _user;
  VoteModel _votes;
  UserVoteModel _userVote;

  Future postComments({@required VoteCommentModel voteCommentModel}) async {
    await _databaseService.postComment(voteCommentModel);
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
