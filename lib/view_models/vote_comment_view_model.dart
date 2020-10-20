import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/services/dialog_service.dart';

import '../services/stateManager_service.dart';
import '../services/stateManager_service.dart' as global;

import 'package:yachtOne/views/constants/holiday.dart';
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
  final StateManagerServiceService _stateManagerService =
      locator<StateManagerServiceService>();

  VoteCommentModel voteFeedModel;

  int subVoteIndex;

  DatabaseAddressModel address;
  UserModel user;
  VoteModel vote;
  UserVoteModel userVote;
  SeasonModel seasonInfo;
  String uid;

  VoteModel newVote;
//   UserVoteModel newUserVote;

  VoteCommentViewModel() {
    // _authService.signOut();

    uid = _authService.auth.currentUser.uid;
    // getUser();
  }

  Future getAllModel(uid) async {
    setBusy(true);
    //=======================stateManagerService이용하여 뷰모델 시작=======================
    String myState = _stateManagerService.calcState();

    if (_stateManagerService.hasLocalStateChange(myState)) {
      if (await _stateManagerService.hasDBStateChange(myState)) {
        // update needed. local & db 모두 변했기 때문
        // 아래처럼 stateManagerService에서 각 모델들을 모두 리로드해주고, 그걸 뷰모델 내 모델변수에 재입력해준다.
        await _stateManagerService.initStateManager();
      }
    }
    address = global.localAddressModel;
    user = global.localUserModel;
    vote = global.localVoteModel;
    userVote = global.localUserVoteModel;
    seasonInfo = global.localSeasonModel;

    //=======================stateManagerService이용하여 뷰모델 시작=======================

    // address = await _databaseService.getAddress(uid);
    // user = await _databaseService.getUser(uid);
    // vote = await _databaseService.getVotes(address);
    // userVote = await _databaseService.getUserVote(address);
    // seasonInfo = await _databaseService.getSeasonInfo(address);

    setBusy(false);
  }

  Future getNewVote(address) async {
    newVote = await _databaseService.getVotes(address);
    print("GETNEWVOTE CALLED");
    notifyListeners();
  }

  Stream<List<VoteCommentModel>> getPost(DatabaseAddressModel address) {
    return _databaseService.getSubVotePostList(address);
  }

  // Future postComments(
  //   DatabaseAddressModel address,
  //   VoteCommentModel voteCommentModel,
  // ) async {
  //   await _databaseService.postComment(address, voteCommentModel);
  // }

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
