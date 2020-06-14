import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/models/vote_model.dart';

class DatabaseService {
  Firestore _databaseService = Firestore.instance;
  Firestore get databaseService => _databaseService;

  //  collection references
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users'); //_databaseService 사용 왜 불가한지?
  final CollectionReference _votesCollectionReference =
      Firestore.instance.collection('votes');
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
}
