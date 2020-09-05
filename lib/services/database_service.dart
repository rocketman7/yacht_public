import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:yachtOne/models/rank_model.dart';
import '../models/sub_vote_model.dart';
import '../models/user_model.dart';
import '../models/user_vote_model.dart';
import '../models/vote_comment_model.dart';
import '../models/rank_model.dart';
import '../models/database_address_model.dart';
import '../models/vote_model.dart';

import '../models/temp_address_constant.dart';

import 'dart:math';

class DatabaseService {
  FirebaseFirestore _databaseService = FirebaseFirestore.instance;
  FirebaseFirestore get databaseService => _databaseService;

  DateFormat dateFormat = DateFormat('yyyy-MM-dd_HH:mm:ss:SSS');

  CollectionReference get _usersCollectionReference =>
      _databaseService.collection('users');
  CollectionReference get _votesCollectionReference =>
      _databaseService.collection('votes');
  CollectionReference get _postsCollectionReference =>
      _databaseService.collection('posts');
  CollectionReference get _ranksCollectionReference =>
      _databaseService.collection('ranks');

  CollectionReference get usersCollectionReference => _usersCollectionReference;
  CollectionReference get votesCollectionReference => _votesCollectionReference;
  CollectionReference get postsCollectionReference => _postsCollectionReference;
  CollectionReference get ranksCollectionReference => _ranksCollectionReference;

  //  collection references
  // final CollectionReference _usersCollectionReference =
  //     _databaseService.collection('users');
  // final CollectionReference _votesCollectionReference =
  //     FirebaseFirestore.instance.collection('votes');
  // final CollectionReference _postsCollectionReference =
  //     FirebaseFirestore.instance.collection('posts');

  int i = 0;

  // Create: User정보 users collection에 넣기
  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference.doc(user.uid).set(user.toJson());
    } catch (e) {
      return e.message;
    }
  }

  // Read: User정보 users Collection으로부터 읽기
  Future getUser(String uid) async {
    try {
      // users collection에서 해당 uid 다큐의 snapshot 가져오기 (return DocumentSnapshot)
      var userData = await _usersCollectionReference.doc(uid).get();
      return UserModel.fromData(userData.data());
    } catch (e) {
      print(e.toString());
    }
  }

  // Create: Vote 데이터 DB에 넣기 (관리자만 접근)
  Future addVotes(
    VoteModel vote,
    List<SubVote> subVote,
    DatabaseAddressModel addressModel,
  ) async {
    try {
      await addressModel
          .votesSeasonCollection()
          .doc(addressModel.date)
          .set(vote.toJson());
      for (i = 0; i < vote.subVotes.length; i++) {
        await addressModel
            .votesSeasonSubVoteCollection()
            .doc(i.toString())
            .set(subVote[i].toJson());
      }
    } catch (e) {
      return e.message;
    }
  }

  // Create: User 투표완료하면 userVote Collection에 넣기
  Future addUserVote(
    DatabaseAddressModel address,
    UserVoteModel userVote,
  ) async {
    try {
      await address
          .userVoteSeasonCollection()
          .doc(address.date)
          .set(userVote.toJson());

      // batch.setData(_usersCollectionReference
      //     .document(userVote.uid)
      //     .collection('userVote')
      //     .document(userVote.voteDate), userVote.toJson());

      print("setDone");
    } catch (e) {
      return e.message;
    }
  }

  // 유저 선택 리스트 받아서 각 subVote 문서에 numVoted increment
  Future countUserVote(
    DatabaseAddressModel address,
    List<int> voteSelected,
  ) async {
    try {
      var increment = FieldValue.increment(1);
      // voteSelected = [0, 1, 2, 0, 1]
      for (int i = 0; i < voteSelected.length; i++) {
        int vote = voteSelected[i];
        if (vote != 0) {
          if (vote == 1) {
            address
                .votesSeasonSubVoteCollection()
                .doc(i.toString())
                .update({'numVoted0': increment});
          } else if (vote == 2) {
            address
                .votesSeasonSubVoteCollection()
                .doc(i.toString())
                .update({'numVoted1': increment});
          }
        }
      }
    } catch (e) {
      return e.message;
    }
  }

  // Read: User의 Vote정보 가져오기
  Future getUserVote(DatabaseAddressModel addressModel) async {
    try {
      var userVoteData = await addressModel
          .userVoteSeasonCollection()
          .doc(addressModel.date)
          .get();

      // List<int> tempList = List<int>.from(userVoteData.data['voteSelected']);
      // print(tempList.runtimeType);
      // userVoteData.data['voteSelected'] = tempList;
      // print(userVoteData.data['voteSelected'].runtimeType);

      return UserVoteModel.fromData(userVoteData.data());
    } catch (e) {
      print("ERROR_getUserVote");
      print(e.toString());
    }
  }

  // Read: Vote 정보 Vote Collection으로부터 읽기
  Future<VoteModel> getVotes(DatabaseAddressModel addressModel) async {
    try {
      // print('DB' + uid);
      List<SubVote> subVoteList = [];
      var voteData = await addressModel
          .votesSeasonCollection()
          .doc(addressModel.date)
          .get();
      // List<int> voteResult;
      // print(voteData.data['voteResult']);

      await addressModel
          .votesSeasonSubVoteCollection()
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          subVoteList.add(SubVote.fromData(result.data()));
        });
      });
      print(subVoteList[0].title);
      print(subVoteList.length);
      print(voteData.data());
      // print(userData);
      return VoteModel.fromData(voteData.data(), subVoteList);
    } catch (e) {
      print("ERROR22");
      print(e.toString());
      return null;
    }
  }

  Future postComment(
      DatabaseAddressModel address, VoteCommentModel voteCommentModel) async {
    try {
      await address
          .postsSeasonSubVoteCollection()
          .doc()
          .set(voteCommentModel.toJson());
    } catch (e) {}
  }

  Future deleteComment(
    DatabaseAddressModel address,
    String postUid,
  ) async {
    try {
      await address.postsSeasonSubVoteCollection().doc(postUid).delete();
    } catch (e) {}
  }

  Stream<List<VoteCommentModel>> getPostList(DatabaseAddressModel address) {
    return address
        .postsSeasonSubVoteCollection()
        .orderBy('postDateTime')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) {
              return VoteCommentModel.fromData(document.id, document.data());
            })
            .toList()
            .reversed
            .toList());
  }

  // Read: ranks collection 정보 읽어오기. 배치될 때에만 바뀌는 정보이므로 Future로 처리
  Future<List<RankModel>> getRankList() async {
    try {
      List<RankModel> rankList = [];

      await ranksCollectionReference
          .doc('koreaStockStandard')
          .collection('season001')
          .doc('20200901')
          .collection('20200901')
          .orderBy('combo', descending: true)
          .get()
          .then((querysnapshot) => querysnapshot.docs.forEach((element) {
                rankList.add(RankModel.fromData(element.data()));
              }));

      return rankList;
    } catch (e) {
      print('rankList load error: ${e.toString()}');

      return null;
    }
  }

  Future<void> addRank() {
    //for (i = 1; i < 101; i++) {
    Random rnd;
    rnd = new Random();
    int rndCombo = 0 + rnd.nextInt(39);

    ranksCollectionReference
        .doc('koreaStockStandard')
        .collection('season001')
        .doc('20200901')
        .collection('20200901')
        .add({
          'uid': 'm2UUvxsAwfdLFP4RB8q4SgkaNgr2',
          'userName': 'csejun10',
          'combo': rndCombo
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    //}

    return null;
  }

  Future<List<dynamic>> getAllUserNameSnapshot() async {
    try {
      List<String> allUserName = [];

      var userDocuments = await _usersCollectionReference.get();
      print("user count" + userDocuments.docs.length.toString());
      // String temp = userDocuments.documents[0].data["userName"];
      // print(temp + " temp");
      // print(userDocuments.documents[0].data["userName"]);
      // print(userDocuments.documents[1].data["userName"]);
      // print(userDocuments.documents[2].data["userName"]);
      // userDocuments.documents.forEach((element) {
      //   print(element.data["userName"]);
      //   allUserName.add(element.data["userName"].toString());
      // });
      for (var i = 0; i < userDocuments.docs.length; i++) {
        allUserName.add(userDocuments.docs[i].data()["userName"]);
      }

      return allUserName;
    } catch (e) {
      print("error");
      return null;
    }
  }

  // Phone Number Duplicate Check
  Future duplicatePhoneNumberCheck(String phoneNumber) async {
    var duplicatePhoneNumber = await _usersCollectionReference
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get();

    // print('doc length is ' + duplicatePhoneNumber.docs.length.toString());
    // duplicatePhoneNumber.docs.forEach((element) {
    //   print(element.id);
    //   print(element.data());
    // });
    if (duplicatePhoneNumber.docs.length > 0) {
      return false;
    } else
      return true;
  }

  Future<List<String>> getAllUserPhoneSnapshot() async {
    try {
      List<String> allUserPhone = [];

      var userDocuments = await _usersCollectionReference.get();

      // String temp = userDocuments.documents[0].data["userName"];
      // print(temp + " temp");
      // print(userDocuments.documents[0].data["userName"]);
      // print(userDocuments.documents[1].data["userName"]);
      // print(userDocuments.documents[2].data["userName"]);
      // userDocuments.documents.forEach((element) {
      //   print(element.data["userName"]);
      //   allUserName.add(element.data["userName"].toString());
      // });
      for (var i = 0; i < userDocuments.docs.length; i++) {
        allUserPhone.add(userDocuments.docs[i].data()["phoneNumber"]);
      }

      return allUserPhone;
    } catch (e) {
      print("error");
      return null;
    }
  }

  // database 및 time정보로 Database Address 모델 만들기
  Future<DatabaseAddressModel> getAddress(String uid) async {
    DatabaseAddressModel _databaseAddress;

    _databaseAddress = DatabaseAddressModel(
      uid: uid,
      date: date,
      category: category,
      season: season,
    );

    return _databaseAddress;
  }
}
