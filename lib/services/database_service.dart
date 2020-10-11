import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';

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

import 'dart:math';

class DatabaseService {
  FirebaseFirestore _databaseService = FirebaseFirestore.instance;
  FirebaseFirestore get databaseService => _databaseService;

  // final AuthService _authService = locator<AuthService>();
  final NavigationService _navigationService = locator<NavigationService>();
  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

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

  CollectionReference get usersCollectionReference => _usersCollectionReference;
  CollectionReference get votesCollectionReference => _votesCollectionReference;
  CollectionReference get postsCollectionReference => _postsCollectionReference;
  CollectionReference get ranksCollectionReference => _ranksCollectionReference;
  CollectionReference get adminCollectionReference => _adminCollectionReference;
  CollectionReference get pricesCollectionReference =>
      _pricesCollectionReference;
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
      _sharedPreferencesService.setSharedPreferencesValue("twoFactor", false);
      AuthService().auth.signOut();
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

  // 계좌인증이 완료된 유저의 계좌정보 넣기, 선택적으로 넣도록 수정?
  Future setAccInformation(UserModel user, String uid) async {
    await _usersCollectionReference.doc(uid).set(user.toJson());
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

        // userVoteData =
        //     await address.userVoteSeasonCollection().doc(address.date).get();
      }

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

      return SeasonModel.fromData(seasonInfoData.data());
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> getAvatar(uid) async {
    var user = await usersCollectionReference.doc(uid).get();
    return user.data()['avatarImage'];
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

  Future deleteComment(
    DatabaseAddressModel address,
    String postUid,
  ) async {
    try {
      await address.postsSubVoteCollection().doc(postUid).delete();
    } catch (e) {}
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
        .snapshots()
        .map((snapshot) {
      print(snapshot.toString());
      print("SNAP");
      print(snapshot.docs.toString() + "FIRSTDATA");
      // PriceModel temp = PriceModel.fromData(snapshot.docs.first.data());
      // print(temp.toString());
      // print(snapshot.docs.first.data()['issueCode']);
      if (snapshot.docs.isEmpty) {
        print("Price Snapshot  null");
        return PriceModel(issueCode, 0, 0);
      } else {
        print("Price Snapshot  exist");
        // return PriceModel(issueCode, 0, 0);
        return PriceModel.fromData(snapshot.docs.first.data());
      }
      // return list;
    });
  }

  // Read: ranks collection 정보 읽어오기. 배치될 때에만 바뀌는 정보이므로 Future로 처리
  Future<List<RankModel>> getRankList(
      DatabaseAddressModel databaseAddressModel) async {
    try {
      List<RankModel> rankList = [];

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
        .doc('koreaStockStandard')
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

    // 임시 데이터
    // String tempCategory = 'koreaStockStandard';
    // DateTime start = DateTime(2020, 09, 06, 08, 50, 00);
    // DateTime end = DateTime(2020, 09, 06, 16, 00, 00);
    // List<DateTime> tempTime = [start, end];

    String category = await DatabaseAddressModel().adminOpenSeason().get().then(
      (doc) {
        print(doc.data());
        return doc.data()['category'];
      },
    );

    String season = await DatabaseAddressModel().adminOpenSeason().get().then(
          (doc) => doc.data()['season'],
        );

    String baseDate = DateTimeModel().baseDate(category);

    bool isVoting = DateTimeModel().isVoteAvailable(category);
    // String baseDate = '20200901';
    // bool isVoteAvailable = DateTimeModel().isVoteAvailable(tempCategory);

    // print("VOTE IS AVAILABLE" + isVoteAvailable.toString());

    _databaseAddress = DatabaseAddressModel(
      uid: uid,
      date: baseDate,
      category: category,
      season: season,
      isVoting: isVoting,
    );

    print("TODAY DATA ADDRESS" + _databaseAddress.date.toString());

    return _databaseAddress;
  }
}
