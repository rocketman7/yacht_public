import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:yachtOne/models/all_stock_list_model.dart';
import 'package:yachtOne/models/lunchtime_vote_model.dart';
import 'package:yachtOne/models/notification_list_model.dart';
import '../models/post_model.dart';
import 'package:yachtOne/models/user_reward_model.dart';
import 'package:yachtOne/views/lunchtime_event_view.dart';
import 'api/customized_ntp.dart';
import 'package:yachtOne/models/chart_model.dart';
import 'package:yachtOne/models/index_info_model.dart';
import 'package:yachtOne/models/news_model.dart';
import 'package:yachtOne/models/stateManage_model.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:yachtOne/models/stock_info_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import 'package:yachtOne/views/constants/holiday.dart';

import '../locator.dart';
import '../models/date_time_model.dart';
import '../models/faq_model.dart';
import '../models/notice_model.dart';
import '../models/oneOnOne_model.dart';
import '../models/price_model.dart';
import '../models/season_model.dart';
import '../models/user_post_model.dart';
import '../models/user_vote_stats_model.dart';
import '../models/sub_vote_model.dart';
import '../models/user_model.dart';
import '../models/user_vote_model.dart';
import '../models/vote_comment_model.dart';
import '../models/rank_model.dart';
import '../models/database_address_model.dart';
import '../models/vote_model.dart';
import '../models/portfolio_model.dart';
import '../models/stateManage_model.dart';

import 'dart:math';

class DatabaseService {
  FirebaseFirestore _databaseService = FirebaseFirestore.instance;
  FirebaseFirestore get databaseService => _databaseService;

  // final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  // final AuthService _authService = locator<AuthService>();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd_HH:mm:ss:SSS');

  CollectionReference get _usersCollectionReference =>
      _databaseService.collection('users');
  CollectionReference get _votesCollectionReference =>
      _databaseService.collection('votes');
  CollectionReference get _postsCollectionReference =>
      _databaseService.collection('posts');
  CollectionReference get _ranksCollectionReference =>
      _databaseService.collection('ranks');
  CollectionReference get _adminCollectionReference =>
      _databaseService.collection('admin');
  CollectionReference get _pricesCollectionReference =>
      _databaseService.collection('prices');
  CollectionReference get _hitsPricesCollectionReference =>
      _databaseService.collection('historicalPrice');

  CollectionReference get usersCollectionReference => _usersCollectionReference;
  CollectionReference get votesCollectionReference => _votesCollectionReference;
  CollectionReference get postsCollectionReference => _postsCollectionReference;
  CollectionReference get ranksCollectionReference => _ranksCollectionReference;
  CollectionReference get adminCollectionReference => _adminCollectionReference;
  CollectionReference get pricesCollectionReference =>
      _pricesCollectionReference;
  CollectionReference get hitsPricesCollectionReference =>
      _hitsPricesCollectionReference;
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

  Future deleteUser() async {
    try {
      User user = AuthService().auth.currentUser;
      await _usersCollectionReference.doc(user.uid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future checkIfUserDBExists(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      print("CHECK INF USER" + userData.data().toString());
      return userData.data();
    } catch (e) {
      print(e);
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
      // _sharedPreferencesService.setSharedPreferencesValue("twoFactor", false);
      // AuthService().auth.signOut();
      print("getUSER ERROR");
      _navigationService.popAndNavigateWithArgTo('initial');
    }
  }

  // Read: 다른 유저들의 특정 필드값 읽기
  Future getOthersInfo(String uid, String field) async {
    try {
      var value = await _usersCollectionReference
          .doc(uid)
          .get()
          .then((querysnapshot) => {querysnapshot.data()['$field']});

      return value.toList()[0].toString();
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
      userVote.voteDate = address.date;
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

  Future initialiseOneVote(
    DatabaseAddressModel address,
    UserVoteModel userVote,
    int resetTarget,
  ) async {
    List<int> voteSelected = userVote.voteSelected;
    bool isVoted = true;
    int check = 0;
    print(voteSelected);
    voteSelected.replaceRange(resetTarget, resetTarget + 1, [0]);
    voteSelected.forEach((element) {
      check += element;
    });
    if (check == 0) {
      isVoted = false;
    }
    print(voteSelected);
    print(isVoted);
    try {
      await address.userVoteSeasonCollection().doc(address.date).update({
        "voteSelected": voteSelected,
        "isVoted": isVoted,
      });
    } catch (e) {}
  }

  // 계좌인증이 완료된 유저의 계좌정보 넣기, 선택적으로 넣도록 수정?
  // Future setAccInformation(UserModel user, String uid) async {
  //   await _usersCollectionReference.doc(uid).set(user.toJson());
  // }

  Future setAccInformations(
      String accNumber, String accName, String secName, String uid) async {
    await _usersCollectionReference.doc(uid).update({
      'account.accNumber': accNumber,
      'account.accName': accName,
      'account.secName': secName,
    });
  }

  // user콜렉션에서 아바타이미지 바꾸기
  Future setAvatarImage(String avatarImage, String uid) async {
    await _usersCollectionReference
        .doc(uid)
        .update({'avatarImage': avatarImage});
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

  Future getPriceForChart(
    String countryCode,
    String issueCode,
  ) async {
    print("GET CHART START");
    List<ChartModel> chartList = [];

    try {
      print("CHART FOR ISSUECODE " + issueCode.toString());
      // Historical Price DB에서 모든 docu를 get하고,
      // chartList에 추가.
      await _databaseService
          .collection('historicalPrice')
          .doc('KR')
          .collection(issueCode)
          .orderBy('date', descending: false)
          .get()
          .then((querySnapshot) {
        print("PRICEFORCHART QUERYSNAP" +
            querySnapshot.docs.first.data().toString());
        if (querySnapshot.docs != null) {
          querySnapshot.docs.forEach((doc) {
            chartList.add(ChartModel.fromData(doc.data()));
          });
        }
      });

      print(chartList);

      // 최종 DB location
      // var historicalPriceData = await _databaseService
      //     .collection('stocks')
      //     .doc(countryCode)
      //     .collection(issueCode)
      //     .orderBy('date', descending: false)
      //     .get();

      // print(priceData.docs.first.data());

      // return priceData.docs.map((e) => ChartModel.fromData(e.data())).toList();
      return chartList;
    } catch (e) {
      print(e.message);
    }
  }

  Future<List<SeasonModel>> getAllSeasonInfoList() async {
    try {
      List<SeasonModel> seasonModelList = [];
      var krVoteSnap =
          await _databaseService.collection('votes').doc('KR').get();
      List<dynamic> seasonList = krVoteSnap.data()['subCollectionIds'];
      print(seasonList);

      for (var doc in seasonList) {
        await _databaseService
            .collection('votes')
            .doc('KR')
            .collection(doc)
            .doc('seasonInfo')
            .get()
            .then((value) {
          var temp = SeasonModel.fromData(value.data(), doc);
          seasonModelList.add(temp);
        });
      }

      // return seasonModelList;

      // return seasonModelList;

      print("LENGTH second" + seasonModelList.length.toString());

      return seasonModelList;
    } catch (e) {
      print("ERROR CAUGHT" + e.toString());
      return e.message;
    }
  }

  Future getAllSeasonUserVote(DatabaseAddressModel address) async {
    try {
      print("GETALLSEASON START");
      List<UserVoteModel> allSeasonUserVoteList = [];
      UserVoteStatsModel userVoteStats;
      await address
          .userVoteSeasonCollection()
          .orderBy('voteDate', descending: true)
          .get()
          .then((colSnapshot) {
        print(colSnapshot.docs.first);
        colSnapshot.docs.forEach((result) {
          result.id == 'stats'
              ? userVoteStats = UserVoteStatsModel.fromData(result.data())
              : allSeasonUserVoteList
                  .add(UserVoteModel.fromData(result.data(), userVoteStats));
        });
      });

      print("USERVOTELIST" + allSeasonUserVoteList[0].voteDate.toString());
      // allSeasonUserVoteList.removeWhere((element) => element == null);
      return allSeasonUserVoteList;
    } catch (e) {
      print("ERROR_getAllUserVote");
      print(e.toString());
    }
  }

  // Read: User의 Vote정보 가져오기
  Future getUserVote(DatabaseAddressModel address) async {
    try {
      UserVoteStatsModel userVoteStats;
      // userVoteData get
      var userVoteData =
          await address.userVoteSeasonCollection().doc(address.date).get();

      // 오늘 예측참여 안 한 유저에게는 null model 넣어주기
      UserVoteModel tempUserVote = UserVoteModel(
        isVoted: false,
        uid: address.uid,
      );
      if (userVoteData.data() == null) {
        print("TEMP MODEL" + tempUserVote.isVoted.toString());
        await address
            .userVoteSeasonCollection()
            .doc(address.date)
            .set(tempUserVote.toJson());
        // updateUserItem(address.uid, 1);

        // userVoteData =
        //     await address.userVoteSeasonCollection().doc(address.date).get();
      }

      var userVoteStatsData =
          await address.userVoteSeasonStatsCollection().get();
      print("USERSTATS" + userVoteStatsData.data().toString());
      UserVoteStatsModel tempUserVoteStats = UserVoteStatsModel();
      if (userVoteStatsData.data() == null) {
        print("TEMP MODEL" + tempUserVoteStats.toString());

        await address
            .userVoteSeasonStatsCollection()
            .set(tempUserVoteStats.toJson());
        userVoteStats = tempUserVoteStats;
      } else {
        userVoteStats = UserVoteStatsModel.fromData(userVoteStatsData.data());
      }

      print("USERVOTE" + userVoteData.data().toString());

      return UserVoteModel.fromData(
          userVoteData.data() ?? tempUserVote.toJson(), userVoteStats);
    } catch (e) {
      print("ERROR_getUserVote");
      print(e.toString());
    }
  }

  // Read: User의 Vote/stat정보 가져오기
  Future getUserVoteStat(DatabaseAddressModel address) async {
    try {
      UserVoteStatsModel userVoteStats;

      var userVoteStatsData =
          await address.userVoteSeasonStatsCollection().get();

      UserVoteStatsModel tempUserVoteStats = UserVoteStatsModel();
      if (userVoteStatsData.data() == null) {
        print("TEMP MODEL" + tempUserVoteStats.toString());

        await address
            .userVoteSeasonStatsCollection()
            .set(tempUserVoteStats.toJson());
        userVoteStats = tempUserVoteStats;
      } else {
        userVoteStats = UserVoteStatsModel.fromData(userVoteStatsData.data());
      }

      return userVoteStats;
    } catch (e) {
      print("ERROR_getUserVoteStat");
      print(e.toString());
    }
  }

  Future<SeasonModel> getSeasonInfo(DatabaseAddressModel address) async {
    try {
      var seasonInfoData =
          await address.votesSeasonCollection().doc('seasonInfo').get();

      return SeasonModel.fromData(seasonInfoData.data(), address.season);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> getAvatar(uid) async {
    String data = await usersCollectionReference
        .doc(uid)
        .get()
        .then((value) => value['avatarImage']);
    print("GETAVATAR" + data);
    return data;
    // return user.data()['avatarImage'];
  }

  Future<String> getNickName(uid) async {
    String data = await usersCollectionReference
        .doc(uid)
        .get()
        .then((value) => value['userName']);
    return data;
  }

  Future getAllSeasonVote(DatabaseAddressModel address) async {
    try {
      List<VoteModel> voteList = [];
      List<SubVote> tempSubVoteList;
      List<String> dates = [];
      List<DateTime> allSeasonDate = [];
      String startDateStr;
      DateTime startDateTime;
      DateTime temp;

      // 시즌 info에서 시즌 시작일 불러오기
      startDateStr = await address
          .votesSeasonCollection()
          .doc('seasonInfo')
          .get()
          .then((value) => value.data()['startDate']);

      //시즌 시작일 datetime으로
      startDateTime = strToDate(startDateStr);

      String tempDate = startDateStr;

      print("TEMP DATE" + tempDate.toString());
      // print(address.date);
      // print(strToDate(tempDate)
      //     .isBefore(strToDate(address.date).add(Duration(days: 1))));
      while (strToDate(tempDate)
          .isBefore(strToDate(address.date).add(Duration(days: 1)))) {
        tempSubVoteList = [];
        var voteData =
            await address.votesSeasonCollection().doc(tempDate).get();
        await address
            .votesSeasonCollection()
            .doc(tempDate)
            .collection('subVote')
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            tempSubVoteList.add(SubVote.fromData(result.data()));
          });
        });
        // print("tempDate " + tempDate.toString());

        voteList.insert(
            0, VoteModel.fromData(voteData.data(), tempSubVoteList));
        // print(tempSubVoteList[1].toJson());
        print("TEMPDATE BEFORE" + tempDate.toString());
        tempDate = dateToStr(nextNthBusinessDay(strToDate(tempDate), 1));
        print("TEMPDATE AFTER" + tempDate.toString());
      }

      // while ( temp.isBefore())
      print("VOTELSIT = " + voteList.toString());
      return voteList;
      // List<int> voteResult;
      // print(voteData.data['voteResult']);

    } catch (e) {
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

  Future postSubVoteComment(
    DatabaseAddressModel address,
    VoteCommentModel voteCommentModel,
    UserPostModel userPostModel,
  ) async {
    try {
      String docUid;
      docUid = address.postsSubVoteCollection().doc().id;

      await address
          .postsSubVoteCollection()
          .doc(docUid)
          .set(voteCommentModel.toJson());

      await address
          .userPostCollection()
          .doc(docUid)
          .set(userPostModel.toJson());
    } catch (e) {}
  }

  Future postSeasonComment(
    DatabaseAddressModel address,
    VoteCommentModel voteCommentModel,
    UserPostModel userPostModel,
  ) async {
    try {
      String docUid;
      docUid = address.postsSeasonCollection().doc().id;

      await address
          .postsSeasonCollection()
          .doc(docUid)
          .set(voteCommentModel.toJson());

      await address
          .userPostCollection()
          .doc(docUid)
          .set(userPostModel.toJson());
    } catch (e) {}
  }

  Future likeSubVoteComment(
    DatabaseAddressModel address,
    VoteCommentModel voteComment,
    String uid,
  ) async {
    if (voteComment.likedBy.contains(uid)) {
      print("True Called");
      voteComment.likedBy.remove(uid);
      await address
          .postsSubVoteCollection()
          .doc(voteComment.postUid)
          .update({"likedBy": voteComment.likedBy});
    } else {
      print("false Called");
      voteComment.likedBy.add(uid);
      print(voteComment.likedBy);
      await address
          .postsSubVoteCollection()
          .doc(voteComment.postUid)
          .update({"likedBy": voteComment.likedBy});
    }
  }

  Future likeSeasonComment(
    DatabaseAddressModel address,
    VoteCommentModel voteComment,
    String uid,
  ) async {
    if (voteComment.likedBy.contains(uid)) {
      voteComment.likedBy.remove(uid);
      await address
          .postsSeasonCollection()
          .doc(voteComment.postUid)
          .update({"likedBy": voteComment.likedBy});
    } else {
      voteComment.likedBy.add(uid);
      // print(voteComment.likedBy);
      await address
          .postsSeasonCollection()
          .doc(voteComment.postUid)
          .update({"likedBy": voteComment.likedBy});
    }
  }

  Future deleteSeasonComment(
    DatabaseAddressModel address,
    String postUid,
  ) async {
    try {
      await address.postsSeasonCollection().doc(postUid).delete();
    } catch (e) {}
  }

  Future deleteSubjectComment(
    DatabaseAddressModel address,
    String postUid,
  ) async {
    try {
      await address.postsSubVoteCollection().doc(postUid).delete();
    } catch (e) {}
  }

  Future addBlockList(
    UserModel user,
    String blockUid,
  ) async {
    print(user.blockList);
    user.blockList.add(blockUid);
    print(user.blockList);
    await _usersCollectionReference
        .doc(user.uid)
        .update({"blockList": user.blockList});
    ;
  }

  Stream<List<VoteCommentModel>> getSubVotePostList(
      DatabaseAddressModel address) {
    print("CALLED");
    return address
        .postsSubVoteCollection()
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

  Stream<List<VoteCommentModel>> getSeasonPostList(
      DatabaseAddressModel address) {
    print("CALLED");
    return address
        .postsSeasonCollection()
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

  //new Post
  Stream<List<PostModel>> getPostList(String category, String issueCode) {
    return _postsCollectionReference
        .doc(category)
        .collection(issueCode)
        .where('parent', isNull: true)
        // .where('parent', isEqualTo: ' RiAtiMDNUQZQPMF4Uk35')
        .orderBy('postDateTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((document) {
              return PostModel.fromData(document.id, document.data());
            })
            .toList()
            .reversed
            .toList());
  }

  Stream<PriceModel> getRealtimeReturn(
    DatabaseAddressModel address,
    String issueCode,
  ) {
    // print(issueCode.length);

    print(address.date);
    // print(issueCode[i] + "in a loop");

    return pricesCollectionReference
        .doc(address.date)
        .collection(issueCode)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        // .take(1)
        .map((snapshot) {
      print(snapshot.toString());
      print("SNAP");
      // print(snapshot.docs.toString() + "FIRSTDATA");
      // PriceModel temp = PriceModel.fromData(snapshot.docs.first.data());
      // print(temp.toString());
      // print(snapshot.docs.first.data()['issueCode']);
      if (snapshot.docs.isEmpty) {
        print("Price Snapshot  null");
        return PriceModel(issueCode, 0, 0, null);
      } else {
        print("Price Snapshot  exist");
        // return PriceModel(issueCode, 0, 0);
        return PriceModel.fromData(snapshot.docs.first.data());
      }
      // return list;
    });
  }

  Stream<List<PriceModel>> getRealtimePriceForChart(
    DatabaseAddressModel address,
    String issueCode,
  ) {
    print("STREAM FROM " + issueCode.toString());

    // print(issueCode[i] + "in a loop");

    return _databaseService
        .collection('realtimePrice')
        .doc('KR')
        .collection(address.date)
        .where('issueCode', isEqualTo: issueCode)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      // print("SNAP");
      // print(snapshot.toString());
      // print(snapshot.docs.toString() + "FIRSTDATA");
      // PriceModel temp = PriceModel.fromData(snapshot.docs.first.data());
      // print(temp.toString());
      // print(snapshot.docs.first.data()['issueCode']);
      if (snapshot.docs.isEmpty) {
        print("Price Snapshot  null");
        return [PriceModel(issueCode, 0, 0, null)];
      } else {
        print("Price Snapshot  exist");

        return snapshot.docs.map((element) {
          // priceList.add(PriceModel.fromData(element.data()));
          // print(element.data());
          return PriceModel.fromData(element.data());
        }).toList();
        // print("AFTER STREAM " + priceList.toString());
        // print("LENGTH IS " + priceList.length.toString());
        // return priceList;
        // return PriceModel(issueCode, 0, 0);
        // return PriceModel.fromData(snapshot.docs.first.data());
      }
      // return list;
      // return priceList;
    });
  }

  // Stream<List<PriceModel>> getMultiRealtimePrice(
  //   DatabaseAddressModel address,
  //   List<String> issueCode,
  // ) {
  //   List<PriceModel> priceList = [];

  //   for (int i = 0; i < issueCode.length; i++) {
  //     pricesCollectionReference
  //         .doc(address.date)
  //         .collection(issueCode[i])
  //         .orderBy('createdAt', descending: true)
  //         .snapshots()
  //         .take(1)
  //         .map((snapshot) {
  //       if (snapshot.docs.isEmpty) {
  //         priceList.add(PriceModel(issueCode[0], 0, 0));
  //       } else {
  //         priceList.add(PriceModel.fromData(snapshot.docs.first.data()));
  //       }
  //     });
  //   }

  //   return priceList;

  //   print("CALLED");
  //   return address
  //       .postsSubVoteCollection()
  //       .orderBy('postDateTime')
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((document) {
  //             return VoteCommentModel.fromData(document.id, document.data());
  //           })
  //           .toList()
  //           .reversed
  //           .toList());
  // }

  // Read: ranks collection 정보 읽어오기. 배치될 때에만 바뀌는 정보이므로 Future로 처리
  Future<List<RankModel>> getOldSeasonRankList(
      DatabaseAddressModel databaseAddressModel) async {
    try {
      List<RankModel> rankList = [];

      await _ranksCollectionReference
          .doc(databaseAddressModel.category)
          .collection(databaseAddressModel.season)
          .doc(databaseAddressModel.date)
          .collection(databaseAddressModel.date)
          .orderBy('todayRank', descending: false)
          // .orderBy('userName')
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

  Future<List<RankModel>> getRankList(
      DatabaseAddressModel databaseAddressModel) async {
    try {
      List<RankModel> rankList = [];

      // await ranksCollectionReference
      //     .doc("KR")
      //     .collection("season002")
      //     .doc("20210113")
      //     .collection("20210113")
      //     .orderBy('todayRank', descending: false)
      //     // .orderBy('userName')
      //     .get()
      //     .then((querysnapshot) => querysnapshot.docs.forEach((element) {
      //           rankList.add(RankModel.fromData(element.data()));
      //         }));

      await databaseAddressModel
          .ranksSeasonDateCollection()
          .orderBy('todayRank', descending: false)
          // .orderBy('userName')
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

  // Read: ranks collection 정보 읽어오기. 배치될 때에만 바뀌는 정보이므로 Future로 처리. 시즌 상위 탑5만 불러온다(홈화면 위해)
  Future<List<RankModel>> getRankListTopFive(
      DatabaseAddressModel databaseAddressModel) async {
    try {
      List<RankModel> rankList = [];

      await databaseAddressModel
          .ranksSeasonDateCollection()
          .orderBy('todayRank', descending: false)
          // .orderBy('userName')
          .limit(5)
          .get()
          .then((querysnapshot) => querysnapshot.docs.forEach((element) {
                rankList.add(RankModel.fromData(element.data()));
              }));

      return rankList;
    } catch (e) {
      print('rankListTopFive load error: ${e.toString()}');

      return null;
    }
  }

  Future<void> addRank() {
    // for (i = 1; i < 11; i++) {
    Random rnd;
    rnd = new Random();
    int rndCombo = 0 + rnd.nextInt(19);

    ranksCollectionReference
        .doc('KR')
        .collection('season001')
        .doc('20201008')
        .collection('20201008')
        .add({
          'uid': 'm2UUvxsAwfdLFP4RB8q4SgkaNgr2',
          'userName': 'csejun',
          'combo': rndCombo,
          'avatarImage': 'avatar007'
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    // }

    return null;
  }

  // admin -> stateManager 불러오기
  Future<StateManageModel> getStateManage() async {
    try {
      var stateManageData =
          await adminCollectionReference.doc('stateManager').get();
      return StateManageModel.fromData(stateManageData.data());
    } catch (e) {
      print('error at stateManage get');
      print(e.toString());
      return null;
    }
  }

  // portfolio db 불러오기
  Future<PortfolioModel> getPortfolio(DatabaseAddressModel addressModel) async {
    try {
      List<SubPortfolio> subPortfolioList = [];

      await addressModel
          .votesSeasonAwardPortfolioCollection()
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          subPortfolioList.add(SubPortfolio.fromData(element.data()));
        });
      });

      return PortfolioModel.fromData(subPortfolioList);
    } catch (e) {
      print("error at portfoliomodel get");
      print(e.toString());
      return null;
    }
  }

  // allStockList(Stock->KR의 섭콜렉션) db 불러오기
  Future<AllStockListModel> getAllStockList() async {
    try {
      List<SubStockList> subStockList = [];

      await _databaseService
          .collection('stocks')
          //KR하드코딩
          .doc('KR')
          .collection('allStockList')
          .orderBy('name', descending: false)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          subStockList.add(SubStockList.fromData(element.data()));
        });
      });

      return AllStockListModel.fromData(subStockList);
    } catch (e) {
      print("error at allStockList get");
      print(e.toString());
      return null;
    }
  }

  // userReward db 불러오기
  Future<List<UserRewardModel>> getUserRewardList(String uid) async {
    try {
      List<UserRewardModel> userRewardList = [];
      List<RewardModel> rewardList;

      await _usersCollectionReference
          .doc(uid)
          .collection('userReward')
          .orderBy('awardDate', descending: true)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          rewardList = [];
          for (var a in element['awards'])
            rewardList.add(RewardModel.fromData(a));

          userRewardList.add(
              UserRewardModel.fromData(element.id, element.data(), rewardList));

          // print(element.id);
        });
      });

      return userRewardList;
    } catch (e) {
      print("error at userReward get");
      print(e.toString());
      return null;
    }
  }

  // userReward용 가격 불러오기 (from historicalPrice collection)
  Future<double> getHistoricalPriceForUserReward(String issueCode) {
    try {
      return _hitsPricesCollectionReference
          // 아래 코드는 카테고리가 모든 상금들에 대해 'KR'로 고정되어 있다고 가정한 코드임.
          // 만약 카테고리가 추가된다면, userReward -> docs -> awards 의 필드값에 카테고리도 각각 추가되어야함.
          // .doc(category)
          .doc('KR')
          .collection(issueCode)
          .orderBy('date', descending: true)
          .limit(1)
          .get()
          .then((querySnapshot) {
        print('==========================');
        print(querySnapshot.docs.first.data()['close'].toDouble());
        print('=========================');
        return querySnapshot.docs.first.data()['close'].toDouble();
      });
    } catch (e) {
      print("error at historicalPriceForUserReward get");
      print(e.toString());
      return null;
    }
  }

  //
  Future updateUserRewardDeliveryStatus(
      String uid, String id, int status) async {
    await _usersCollectionReference
        .doc(uid)
        .collection('userReward')
        .doc(id)
        .update({'deliveryStatus': status});
  }

  // Read: Faq List 불러오자
  Future<List<FaqModel>> getFaq() async {
    try {
      List<FaqModel> faqList = [];

      await adminCollectionReference
          .doc('adminPost')
          .collection('faq')
          .get()
          .then((querysnapshot) => querysnapshot.docs.forEach((element) {
                faqList.add(FaqModel.fromData(element.data()));
              }));

      return faqList;
    } catch (e) {
      print('faqList load error: ${e.toString()}');

      return null;
    }
  }

  // Read: Notice List 불러오자
  Future<List<NoticeModel>> getNotice() async {
    try {
      List<NoticeModel> noticeList = [];

      await adminCollectionReference
          .doc('adminPost')
          .collection('notice')
          .orderBy('noticeDateTime', descending: true)
          .get()
          .then((querysnapshot) => querysnapshot.docs.forEach((element) {
                print(element.data()['navigateArgu']);
                noticeList.add(NoticeModel.fromData(element.data()));
              }));

      return noticeList;
    } catch (e) {
      print('noticeList load error: ${e.toString()}');

      return null;
    }
  }

  // Read: Faq List 불러오자
  Future<List<OneOnOneModel>> getOneOnOne() async {
    try {
      List<OneOnOneModel> oneOnOneList = [];

      await adminCollectionReference
          .doc('adminPost')
          .collection('oneOnOne')
          .get()
          .then((querysnapshot) => querysnapshot.docs.forEach((element) {
                oneOnOneList.add(OneOnOneModel.fromData(element.data()));
              }));

      return oneOnOneList;
    } catch (e) {
      print('oneOnOneList load error: ${e.toString()}');

      return null;
    }
  }

  // Read: Notification List 불러오자
  Future<List<NotificationListModel>> getNotificationList() async {
    try {
      List<NotificationListModel> notificationList = [];

      await adminCollectionReference
          .doc('adminPost')
          .collection('notification')
          .orderBy('notificationTime', descending: true)
          .get()
          .then((querysnapshot) => querysnapshot.docs.forEach((element) {
                notificationList
                    .add(NotificationListModel.fromData(element.data()));
              }));

      return notificationList;
    } catch (e) {
      print('noticeficationList load error: ${e.toString()}');

      return null;
    }
  }

  // Read: Notification List 불러오자
  Future<Timestamp> getNotificationLatestTime() async {
    try {
      Timestamp notificationLatestTime;

      await adminCollectionReference
          .doc('adminPost')
          .collection('notification')
          .orderBy('notificationTime', descending: true)
          .limit(1)
          .get()
          .then((querysnapshot) => querysnapshot.docs.forEach((element) {
                notificationLatestTime = element.data()['notificationTime'];
              }));

      // print("================getNotificationLatestTime================");
      // print(notificationLatestTime);
      // print("================getNotificationLatestTime================");

      return notificationLatestTime;
    } catch (e) {
      print('noticeficationLatestTime load error: ${e.toString()}');

      return null;
    }
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

  Future<bool> isUserNameDuplicated(String userName) async {
    try {
      var data;
      await _usersCollectionReference
          .where('userName', isEqualTo: userName)
          .get()
          .then((value) => value.docs.forEach((element) {
                data = element.data();
                // return element.data();
              }));
      print(data);
      return (data != null);
    } catch (e) {
      print("error");
      return null;
    }
  }

  // 프렌즈코드가 다른 유저들이랑 겹치는지 검사해준다.
  Future<bool> isFriendsCodeDuplicated(String friendsCode) async {
    try {
      var data;

      await _usersCollectionReference
          .where('friendsCode', isEqualTo: friendsCode)
          .get()
          .then((value) => value.docs.forEach((element) {
                data = element.data();
              }));

      return (data != null);
    } catch (e) {
      print('error at isFriendsCodeDuplicated');
      return null;
    }
  }

  // 유저가 입력한 프렌즈코드를 가진 유저를 찾아준다.
  Future searchByFriendsCode(String friendsCode) async {
    try {
      var data;
      await _usersCollectionReference
          .where('friendsCode', isEqualTo: friendsCode)
          .get()
          .then((value) => value.docs.forEach((element) {
                data = element.id;
              }));

      return data;
    } catch (e) {
      print('error at searchByFriendsCode');
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

  Future updateUserItem(String uid, int reward) async {
    // print("NEW ITEM IS" + newItem.toString());
    await _usersCollectionReference
        .doc(uid)
        .update({'item': FieldValue.increment(reward)});
  }

  Future updateUserRewardedCnt(String uid, int reward) async {
    // print("NEW ITEM IS" + newItem.toString());
    await _usersCollectionReference
        .doc(uid)
        .update({'rewardedCnt': FieldValue.increment(reward)});
  }

  Future decreaseUserItem(
    String uid,
  ) async {
    await _usersCollectionReference
        .doc(uid)
        .update({'item': FieldValue.increment(-1)});
  }

  Future updateUserName(String uid, String newUserName) async {
    print("NEW USERNAME IS" + newUserName);
    await _usersCollectionReference.doc(uid).update({'userName': newUserName});
    await _usersCollectionReference.doc(uid).update({'isNameUpdated': true});
  }

  Future updateFriendsCode(String uid, String friendsCode) async {
    print("friendsCode IS" + friendsCode);
    await _usersCollectionReference
        .doc(uid)
        .update({'friendsCode': friendsCode});
  }

  Future updateInsertedFriendsCode(
      String uid, String insertedFriendsCode) async {
    print("insertedFriendsCode IS" + insertedFriendsCode);
    await _usersCollectionReference
        .doc(uid)
        .update({'insertedFriendsCode': insertedFriendsCode});
  }

  Future updateSurvey(String uid, Map<String, List> userSurvey) async {
    // print(userSurvey);
    await _usersCollectionReference
        .doc(uid)
        .collection('userSurvey')
        .doc('userSurvey')
        .update({'userSurvey': userSurvey});
    // .set({'userSurvey': userSurvey});
  }

  Future updateBubbleSurvey(
      String uid, List<Map<String, String>> userBubbleSurvey) async {
    // print(userSurvey);
    await _usersCollectionReference
        .doc(uid)
        .collection('userSurvey')
        .doc('userSurvey')
        .set({'userBubbleSurvey': userBubbleSurvey});
  }

  Future test() async {
    List<Map<String, dynamic>> a = [
      {"issueCode": "000080", "name": "하이트진로"},
      {"issueCode": "000120", "name": "CJ대한통운"},
    ];

    for (i = 0; i < a.length; i++) {
      await databaseService
          .collection("stocks")
          .doc("KR")
          .collection("allStockList")
          .add(a[i]);
    }
  }

  // 주식 종목정보 가져오기
  Future<StockInfoModel> getStockInfo(
    String countryCode,
    String issueCode,
  ) async {
    StockInfoModel stockDescription = StockInfoModel();
    List<StatsModel> statsList = [];
    List<NewsModel> newsList = [];
    var data;
    data = await _databaseService
        .collection("stocks")
        .doc(countryCode)
        .collection(issueCode)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.data().isNotEmpty) {
          switch (doc.id) {
            case 'description':
              print(doc.data());
              stockDescription =
                  stockDescription.addWith(StockInfoModel.fromData(doc.data()));
              // print(temp.toString());
              print("DESCRIPTION " + stockDescription.toString());
              break;
            case 'news':
              // news doc에서 새로 데이터를 가져와서 .news 에 넣기
              // print(doc.data()['0'].toString());
              doc.data().values.toList().forEach((element) {
                newsList.add(NewsModel.fromData(element));
              });

              stockDescription.news = newsList;
              // print("NEWS " + stockDescription.toString());
              break;
            case 'stats':
              // stockDescription.stats = StatsModel.fromData(doc.data());
              // stockDescription.stats.add(StatsModel.fromData(doc.data()));
              print("STATSSSS");
              print(doc.data());
              doc.data().values.toList().forEach((element) {
                print("ELEMENT" + element.toString());
                statsList.add(StatsModel.fromData(element));
              });
              print("LIST STATS" + statsList.toString());
              statsList.sort((b, a) => (b.uploadedAt).compareTo(a.uploadedAt));

              stockDescription.stats = statsList;
              print(stockDescription.stats.toString());
              // stockDescription = stockDescription
              //     .addWith(StockInfoModel.fromData(element.data()));
              // print("STATS " + stockDescription.toString());
              break;
          }
          print(" MODEL" + stockDescription.stats.toString());
          // return element.data();
        }
      });
      return stockDescription;
    });

    return data;
  }

  // 인덱스 정보 가져오기
  Future getIndexInfo(
    String countryCode,
    String issueCode,
  ) async {
    IndexInfoModel indexInfo = IndexInfoModel();
    List<ListedStockModel> listedList = [];
    return await _databaseService
        .collection("stocks")
        .doc(countryCode)
        .collection(issueCode)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.data().isNotEmpty) {
          switch (doc.id) {
            case 'description':
              indexInfo =
                  indexInfo.addWith(IndexInfoModel.fromData(doc.data()));
              // print(indexInfo);
              break;
            case 'listed':
              // stockDescription.stats = StatsModel.fromData(doc.data());
              // stockDescription.stats.add(StatsModel.fromData(doc.data()));
              // print(doc.data());
              doc.data().values.toList().forEach((element) {
                listedList.add(ListedStockModel.fromData(element));
              });

              // print(listedList.toString());
              listedList.sort((a, b) => (b.weight).compareTo(a.weight));

              indexInfo.topListed = listedList;
              // stockDescription = stockDescription
              //     .addWith(StockInfoModel.fromData(element.data()));
              break;
          }
          // print(" MODEL" + stockDescription.toString());
          // return element.data();
        }
      });
      return indexInfo;
    });
  }

  Future<String> getDefaultText() async {
    return await _adminCollectionReference
        .doc('adminPost')
        .get()
        .then((value) => value.data()['defaultMainText']);
  }

  Future<DatabaseAddressModel> getOldSeasonAddress(String uid) async {
    DatabaseAddressModel _databaseAddress;

    String category;
    String season;
    String baseDate;
    bool isVoting = true;

    await DatabaseAddressModel().adminClosedSeason().get().then((doc) {
      print(doc.data());
      category = doc.data()['category'];
      season = doc.data()['season'];
      baseDate = doc.data()['baseDate'];
    });

    _databaseAddress = DatabaseAddressModel(
      uid: uid,
      date: baseDate,
      category: category,
      season: season,
      isVoting: isVoting, //false면 장 중
    );

    return _databaseAddress;
  }

  Future getSpecialAwards(DatabaseAddressModel lastSeasonAddressModel) async {
    Map<String, String> specialAwardsMap = {};
    List specialAwardsName;
    List specialAwardsUserName;
    await DatabaseAddressModel()
        .adminClosedSeason()
        .collection(lastSeasonAddressModel.category)
        .doc(lastSeasonAddressModel.season)
        .get()
        .then((doc) {
      // doc.data();
      specialAwardsName = doc.data()['specialAwardsName'];
      specialAwardsUserName = doc.data()['specialAwardsUserName'];
    });

    for (int i = 0; i < specialAwardsName.length; i++) {
      specialAwardsMap[specialAwardsName[i]] = specialAwardsUserName[i];
    }

    return specialAwardsMap;
  }

  Future getSpecialAwardsDescription(
      DatabaseAddressModel lastSeasonAddressModel) async {
    String description;
    await DatabaseAddressModel()
        .adminClosedSeason()
        .collection(lastSeasonAddressModel.category)
        .doc(lastSeasonAddressModel.season)
        .get()
        .then((doc) {
      // doc.data();
      description = doc.data()['specialDescription'];
    });

    return description;
  }

  Stream<String> getLunchEvent() {
    return _databaseService
        .collection('admin')
        .doc('lunchEvent')
        .snapshots()
        .map((snapshot) {
      return snapshot.data()['baseDate'];
    });
  }

  // database 및 time정보로 Database Address 모델 만들기
  Future<DatabaseAddressModel> getAddress(String uid) async {
    print("AddressGetStart" + DateTime.now().toString());
    DatabaseAddressModel _databaseAddress;

    // 임시 데이터
    // String tempCategory = 'koreaStockStandard';
    // DateTime start = DateTime(2020, 09, 06, 08, 50, 00);
    // DateTime end = DateTime(2020, 09, 06, 16, 00, 00);
    // List<DateTime> tempTime = [start, end];

    String category;
    String season;
    String baseDate;
    bool isVoting = true;
    DateTime now;
    // now = await CustomizedNTP.now();
    now = DateTime.now();
    await DatabaseAddressModel().adminOpenSeason().get().then(
      (doc) async {
        print(doc.data());
        category = doc.data()['category'];
        season = doc.data()['season'];

        // 당일 포험 가장 가까운 영업일 가져오는 함수로 baseDate를 만들고,
        baseDate = await DateTimeModel().baseDate(category, now);
        print("BASEDATE" + baseDate.toString());
        // 그 baseDate에 해당하는 voteData가 있는지 체크,
        var voteData = await _votesCollectionReference
            .doc(category)
            .collection(season)
            .doc(baseDate)
            .get();
        print(voteData);
        // 없으면 admin collection에 있는 baseDate를 가져옴
        if (voteData.data() == null) {
          baseDate = doc.data()['baseDate'];
          isVoting = true;
        } else {
          isVoting = DateTimeModel().isVoteAvailable(category, now);
        }
      },
    );

    // baseDate = DateTimeModel().baseDate(category);

    // bool isVoting = DateTimeModel().isVoteAvailable(category);
    // String baseDate = '20200901';
    // bool isVoteAvailable = DateTimeModel().isVoteAvailable(tempCategory);

    // print("VOTE IS AVAILABLE" + isVoteAvailable.toString());

    _databaseAddress = DatabaseAddressModel(
      uid: uid,
      // date: '20210215',
      // date: "20201024",
      date: baseDate,
      category: category,
      // season: "season003",
      season: season,
      // isVoting: false,
      // isVoting: true,
      isVoting: isVoting, //false면 장 중
    );

    print("TODAY DATA ADDRESS" + _databaseAddress.isVoting.toString());
    print("AddressGetEnd" + DateTime.now().toString());
    print("RETURNED ADDRESS" + _databaseAddress.date.toString());
    return _databaseAddress;
  }

  Stream<String> getNameCheckResult(uid) {
    return _databaseService
        .collection('checkName')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      // print("GETNAME STREAM" + snapshot.data()['return'].toString());
      return snapshot.data()['return'];
    });
  }

  Future<String> checkNameUrl() async {
    return _databaseService
        .collection('admin')
        .doc('adminPost')
        .get()
        .then((value) => value.data()['checkNameUrl']);
  }

  Future getLunchtimeVote(DatabaseAddressModel address) async {
    // print("GetLunchModel");
    List<LunchtimeSubVoteModel> lunchtimeVoteList = [];

    var voteData = await _databaseService
        .collection('votes')
        .doc('KR')
        .collection(address.season)
        // .doc(address.date)
        .doc(address.date)
        .get();

    await _databaseService
        .collection('votes')
        .doc('KR')
        .collection(address.season)
        // .doc(address.date)
        .doc(address.date)
        .collection('subVote')
        .get()
        .then((value) {
      print(value.docs[0].id);
      value.docs.forEach((e) {
        // print(e);
        // print(e.data());
        lunchtimeVoteList.add(LunchtimeSubVoteModel.fromMap(e.data()));
      });
    });
    return LunchtimeVoteModel.fromData(voteData.data(), lunchtimeVoteList);
    // return lunchtimeVoteList;
  }
}
