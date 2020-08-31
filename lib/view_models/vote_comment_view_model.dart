import 'package:flutter/material.dart';
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

class VoteCommentViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  VoteCommentModel voteFeedModel;

  UserVoteModel _userVote;
  int subVoteIndex;

  UserModel _user;
  DatabaseAddressModel _address;
  VoteModel _vote;
  String uid;

  VoteCommentViewModel() {
    // _authService.signOut();

    uid = _authService.auth.currentUser.uid;
    // getUser();
  }

  Future<List<Object>> getAllModel(uid) async {
    List<Object> _allModel = [];

    _allModel.add(await getAddress());
    _allModel.add(await getUser(uid));
    _allModel.add(await getVote(_address));
    _allModel.add(await getUserVote(_address));

    print(_allModel);
    return _allModel;
  }

  Future<DatabaseAddressModel> getAddress() async {
    _address = await _databaseService.getAddress(uid);
    return _address;
  }

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

  Future<UserModel> getUser(String uid) async {
    _user = await _databaseService.getUser(uid);
    return _user;
  }

  Future<VoteModel> getVote(DatabaseAddressModel model) async {
    _vote = await _databaseService.getVotes(model);
    return _vote;
  }

  Future getUserVote(DatabaseAddressModel model) async {
    _userVote = await _databaseService.getUserVote(model);
    return _userVote;
  }
}
