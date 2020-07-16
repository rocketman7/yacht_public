import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/models/vote_comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yachtOne/models/vote_model.dart';

class DatabaseService {
  Firestore _databaseService = Firestore.instance;
  Firestore get databaseService => _databaseService;

  DateFormat dateFormat = DateFormat('yyyy-MM-dd_HH:mm:ss:SSS');

  //  collection references
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users'); //_databaseService 사용 왜 불가한지?
  final CollectionReference _votesCollectionReference =
      Firestore.instance.collection('votes');
  final CollectionReference _postsCollectionReference =
      Firestore.instance.collection('posts');

  int i = 0;

  // Create: User정보 users collection에 넣기
  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference.document(user.uid).setData(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  // Read: User정보 users Collection으로부터 읽기
  Future getUser(String uid) async {
    try {
      // print('DB' + uid);
      var userData = await _usersCollectionReference.document(uid).get();
      // print(userData);
      return UserModel.fromData(userData.data);
    } catch (e) {
      print(e.toString());
    }
  }

  // Create: Vote 데이터 DB에 넣기 (관리자만 접근)
  Future addVotes(VoteModel vote, List<SubVote> subVote) async {
    try {
      await _votesCollectionReference
          .document(vote.voteDate.toString())
          .setData(vote.toJson());
      for (i = 0; i < vote.subVotes.length; i++) {
        await _votesCollectionReference
            .document(vote.voteDate.toString())
            .collection('subVotes')
            .document(i.toString())
            .setData(subVote[i].toJson());
      }
    } catch (e) {
      return e.message;
    }
  }

  // Create: User 투표완료하면 userVote Collection에 넣기
  Future addUserVote(UserVoteModel userVote) async {
    try {
      await _usersCollectionReference
          .document(userVote.uid)
          .collection('userVote')
          .document(userVote.voteDate)
          .setData(userVote.toJson());
      print("setDone");
    } catch (e) {
      return e.message;
    }
  }

  // Read: User의 Vote정보 가져오기
  Future getUserVote(String uid, String voteDate) async {
    try {
      var userVoteData = await _usersCollectionReference
          .document(uid)
          .collection('userVote')
          .document(voteDate)
          .get();

      // List<int> tempList = List<int>.from(userVoteData.data['voteSelected']);
      // print(tempList.runtimeType);
      // userVoteData.data['voteSelected'] = tempList;
      // print(userVoteData.data['voteSelected'].runtimeType);

      return UserVoteModel.fromData(userVoteData.data);
    } catch (e) {
      print("ERROR_getUserVote");
      print(e.toString());
    }
  }

  // Read: Vote 정보 Vote Collection으로부터 읽기
  Future getVotes(String voteDate) async {
    try {
      // print('DB' + uid);
      List<SubVote> subVoteList = [];
      var voteData = await _votesCollectionReference.document(voteDate).get();

      await _votesCollectionReference
          .document(voteDate)
          .collection('subVotes')
          .getDocuments()
          .then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          subVoteList.add(SubVote.fromData(result.data));
        });
      });
      // print(subVoteList[0].title);
      // print(subVotesList.length);
      // print(userData);
      return VoteModel.fromData(voteData.data, subVoteList);
    } catch (e) {
      print("ERROR22");
      print(e.toString());
    }
  }

  Future postComment(
      int subVoteIndex, VoteCommentModel voteCommentModel) async {
    try {
      await _postsCollectionReference
          .document('20200901')
          .collection('subVote00' + (subVoteIndex + 1).toString())
          .document('post_' +
              dateFormat.format(DateTime.now().toUtc().add(
                    Duration(hours: 9),
                  )))
          .setData(voteCommentModel.toJson());
    } catch (e) {}
  }

  Stream<List<VoteCommentModel>> getPostList(int index) {
    return _postsCollectionReference
        .document('20200901')
        .collection('subVote00' + (index + 1).toString())
        .snapshots()
        .map((snapshot) => snapshot.documents
            .map((document) => VoteCommentModel.fromData(document.data))
            .toList()
            .reversed
            .toList());
  }
}
