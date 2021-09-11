import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/admin_standards_model.dart';
import 'package:yachtOne/models/community/comment_model.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/models/dictionary_model.dart';
import 'package:yachtOne/models/league_address_model.dart';
import 'package:yachtOne/models/news_model.dart';
import 'package:yachtOne/models/chart_price_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/reading_content_model.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:yachtOne/models/corporation_model.dart';
import 'package:yachtOne/models/live_quest_price_model.dart';
import 'package:yachtOne/models/today_market_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';

import '../models/subLeague_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreService => _firestoreService;

  CollectionReference get _tempCollectionReference =>
      _firestoreService.collection('temp');
  CollectionReference get tempCollectionReference => _tempCollectionReference;

  // CollectionReference userCollectionReference = _firestoreService.collection('users');
  @override
  void onInit() {
    print('firestore service initiated');
    super.onInit();
  }

  //// USER 정보
  // User Model 가져오기
  Future<UserModel> getUserModel(String uid) async {
    return await _firestoreService
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => UserModel.fromMap(value.data()!));
  }

  // User Model 스트림
  Stream<UserModel> getUserStream(String uid) {
    return _firestoreService
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      print(
          'user data stream changed, user model snapshot: ${snapshot.data()}');
      return UserModel.fromMap(snapshot.data()!);
    });
  }

  // User Quest Model 스트림
  Stream<List<UserQuestModel>> getUserQuestStream(
    String uid,
  ) {
    print('stream starting');
    return _firestoreService
        .collection('users')
        .doc(uid)
        .collection('userVote')
        .doc('202109')
        .collection('quests')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              print('user quest: ${doc.data()}');
              return UserQuestModel.fromMap(doc.id, doc.data());
            }).toList());
  }

  // user가 선택한 정답 UserQuest에 넣기
  Future updateUserQuest(
    // String uid,
    // LeagueAddressModel leagueAddressModel,
    QuestModel questModel,
    List answers,
  ) async {
    await _firestoreService
        .collection('users/${userModelRx.value!.uid}/userVote')
        .doc('202109')
        .collection('quests')
        .doc(questModel.questId)
        .set(
            {
          'selection': answers,
          'selectDateTime': FieldValue.serverTimestamp()
        },
            SetOptions(
              merge: true,
            ));
  }

  // 차트 그리기 위한 Historical Price
  Future<List<ChartPriceModel>> getPrices(
      InvestAddressModel investAddresses) async {
    CollectionReference _historicalPriceRef = _firestoreService
        .collection('stocksKR/${investAddresses.issueCode}/historicalPrices');
    List<ChartPriceModel> _priceChartModelList = [];

    try {
      await _historicalPriceRef
          .orderBy('dateTime', descending: true)
          .get()
          .then((querySnapshot) => querySnapshot.docs.forEach((doc) {
                // print(doc.id);  // document id 출력
                _priceChartModelList.add(ChartPriceModel.fromMap(
                    doc.data() as Map<String, dynamic>));
              }));
      // print(_priceChartModelList);
      return _priceChartModelList;
    } catch (e) {
      throw e;
    }
  }

  // Stat 가져오기
  Future<List<StatsModel>> getStats(InvestAddressModel investAddresses) async {
    // CollectionReference _samsungElectronic =
    //     _firestoreService.collection('stocksKR/005930/stats');
    // CollectionReference _skBioPharm =
    //     _firestoreService.collection('stocksKR/326030/stats');
    // CollectionReference _abKo =
    //     _firestoreService.collection('stocksKR/129890/stats');
    CollectionReference _statsRef = _firestoreService
        .collection('stocksKR/${investAddresses.issueCode}/stats');
    List<StatsModel> _statstModelList = [];

    try {
      await _statsRef
          .orderBy('dateTime', descending: true)
          .get()
          .then((querySnapshot) => querySnapshot.docs.forEach((doc) {
                // print(doc.id);  // document id 출력
                _statstModelList.add(
                    StatsModel.fromMap(doc.data() as Map<String, dynamic>));
              }));
      // print(_statstModelList);

      return _statstModelList;
    } catch (e) {
      throw e;
    }
  }

  Future countTest(int index) async {
    _firestoreService.collection('temp').doc('count').get().then((value) {
      var temp = value.data()!['count'];

      for (int i = 0; i < temp.length; i++) {
        if (index == i) {
          temp[i] = temp[i] + 1;
        }
        _firestoreService
            .collection('temp')
            .doc('count')
            .update({'count': temp});
      }
    });
    // await _firestoreService.collection('temp').doc('count').update({
    //   // 'count': [FieldValue.increment(1), FieldValue.increment(1)]
    //   // 'count': [7, 8]
    // });
    // print(temp.data()!['count']);
  }

  // 홈에서 띄울 모든 Quest 가져오기
  Future<List<QuestModel>> getAllQuests() async {
    final List<QuestModel> allQuests = [];
    List<InvestAddressModel> invetAddresses = [];
    await _firestoreService
        .collection('leagues')
        .doc('league001')
        .collection('quests')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        // print(element.data());
        // options 필드의 List of Object를 아래와 같이 처리
        element.data()['investAddresses'].toList().forEach((option) {
          invetAddresses.add(InvestAddressModel.fromMap(option));
        });

        // print('questmodel options from db: $options');
        allQuests.add(
            QuestModel.fromMap(element.id, element.data(), invetAddresses));
        invetAddresses = [];
      });
    });
    return allQuests;
  }

  //// User의 QuestModel
  // User QuestModel 가져오기
//     Future<UserQuestModel> getUserQuest(String uid) async {
// var userQuest = _firestoreService.collection('users').doc(uid).collection('userQuest').doc()
//     }

  // User QuestModel 업데이트

  // 기업 세부 정보 가져오기
  Future<CorporationModel> getCorporationInfo(
      InvestAddressModel investAddressModel) async {
    return await _firestoreService
        .collection('stocksKR')
        .doc('${investAddressModel.issueCode}')
        .get()
        .then((value) {
      print('copr data: ${value.data()}');
      return CorporationModel.fromMap(value.data()!);
    });
  }

  Future<List<NewsModel>> getNews(InvestAddressModel investAddressModel) async {
    final List<NewsModel> allNews = [];
    await _firestoreService
        .collection('stocksKR')
        .doc('${investAddressModel.issueCode}')
        .collection('news')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) => value.docs.forEach((element) {
              allNews.add(NewsModel.fromMap(element.data()));
            }));
    return allNews;
  }

  // 홈 및 서브리그세부 페이지에서 쓸 현재의 모든 서브리그 가져오기.
  // 현재 league를 가져오는 경우도 있을것이고(ex. league001), 다음 달 리그의 모든 세부리그를 가져올 수도 있음.
  Future<List<SubLeagueModel>> getAllSubLeague() async {
    final List<SubLeagueModel> allSubLeagues = [];

    await _firestoreService
        .collection('leagues') // 변하지 않음
        .doc('league001') // 변함. 현재 리그를 가져올지, 다음 리그를 가져올지 등에 따라. 값 자체도 변수로 줘야
        .collection('subLeagues') // 변하지 않음
        .get()
        .then((value) {
      value.docs.forEach((element) {
        allSubLeagues.add(SubLeagueModel.fromMap(element.data()));
      });
    });

    return allSubLeagues;
  }

  // state stream test용
  Stream<String> getStateStream1() {
    return _firestoreService
        .collection('leagues')
        .doc('league001')
        .snapshots()
        .map((snapshot) => snapshot.data()!['stateStream1']);
  }

  // state stream test용
  Stream<String> getStateStream2() {
    return _firestoreService
        .collection('leagues')
        .doc('league001')
        .snapshots()
        .map((snapshot) => snapshot.data()!['stateStream2']);
  }

  // 라이브 스트림 가격차트 테스트용
  // Stream<List<RealtimePriceModel>> getTempRealtimePrice(InvestAddressModel investAddressModel) {
  //   return _firestoreService
  //       .collection('stocks${investAddressModel.country}/${investAddressModel.issueCode}/realtimePrices')
  //       .where('issueCode', isEqualTo: '300720')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((element) {
  //       // print(element.data());
  //       return RealtimePriceModel.fromMap(element.data());
  //     }).toList();
  //   });
  // }

  // Stream<List<RealtimePriceModel>> getTempRealtimePrice0() {
  //   return _firestoreService
  //       .collection('realtimePrice/KR/20210729')
  //       .where('issueCode', isEqualTo: '196170')
  //       .orderBy('createdAt', descending: true)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((element) {
  //
  //       return RealtimePriceModel.fromMap(element.data());
  //     }).toList();
  //   });
  // }

  // 라이브 스트림 가격차트
  Stream<List<LiveQuestPriceModel>> getLiveQuestPrices(
      List<InvestAddressModel> investAddressModels) {
    Stream<List<LiveQuestPriceModel>> realtimePrices;

    final snapshot = _firestoreService
        .collection('stocksKR/005930/historicalPrices')
        .where('dateTime', isGreaterThan: '20210901080000')
        .snapshots();

    var temp = investAddressModels.map((investAddress) {
      final snapshot = _firestoreService
          .collection('stocksKR/${investAddress.issueCode}/historicalPrices')
          .where('dateTime', isGreaterThan: '20210901080000')
          .snapshots();
      return snapshot.map((event) => event.docs.map((e) => e.data()).toList());
    });

    return snapshot.map((element) {
      //element는 다큐모음
      return element.docs.map((e) {
        // e는 하나의 다큐
        return LiveQuestPriceModel.fromMap(
            '005930',
            element.docs
                .map((t) => ChartPriceModel.fromMap(t.data()))
                .toList());
      }).toList();
    });

    // investAddressModels.forEach((element) {
    //   return _firestoreService
    //       // .collection('stocks${element.country}/${element.issueCode}/realtimePrices')
    //       // .where('date', isEqualTo: '20210827')
    //       .collection('stocksKR/005930/historicalPrices')
    //       .where('dateTime', isGreaterThan: '20210901080000')
    //       .snapshots()
    //       .forEach((snapshot) {
    //     // print(snapshot.size);
    //     {
    //       // var tempList = snapshot.docs.map((e) {
    //       //   // print('stream snapshot: ${e.data()}');
    //       //   return ChartPriceModel.fromMap(e.data());
    //       // }).toList();
    //       // print('tempLIst: $tempList');

    //       // var tempLivePrice = LiveQuestPriceModel.fromMap('${element.issueCode}', tempList);
    //       // // print('tempLive' + tempLivePrice.toString());
    //       // realtimePrices.add(tempLivePrice);

    //       return LiveQuestPriceModel.fromMap(
    //           '${element.issueCode}',
    //           snapshot.docs.map((e) {
    //             print('stream snapshot: $e');
    //             return ChartPriceModel.fromMap(e.data());
    //           }).toList());
    //       // print('real' + realtimePrices.toString());
    //     }
    //   });
    // }).toList();

    // print('real' + realtimePrices.toString());
  }

  Stream<LiveQuestPriceModel> getStreamLiveQuestPrice(
      InvestAddressModel investAddress) {
    return _firestoreService
        .collection('stocksKR/${investAddress.issueCode}/realtimePrices')
        .where('dateTime', isGreaterThan: '20210902080000')
        .snapshots()
        .map((element) {
      //element는 다큐모음
      // print('${investAddress.issueCode}');
      // print('snapshot: ${element.docs.last.data()}');
      return LiveQuestPriceModel.fromMap('${investAddress.issueCode}',
          element.docs.map((t) => ChartPriceModel.fromMap(t.data())).toList());
    });
  }

  //// 커뮤니티 관련
  // 포스트 올리기
  Future uploadNewPost(PostModel newPost) async {
    String docUid = _firestoreService.collection('posts').doc().id;
    Timestamp timestampNow = Timestamp.fromDate(DateTime.now());
    print(docUid);

    await _firestoreService.collection('posts').doc(docUid).set(newPost
        .copyWith(
          postId: docUid,
          writtenDateTime: timestampNow,
        )
        .toMap());
  }

  // 포스트 수정하기
  Future editMyPost(String postId, PostModel newPost) async {
    // String docUid = _firestoreService.collection('posts').doc().id;
    Timestamp timestampNow = Timestamp.fromDate(DateTime.now());
    // print(docUid);

    await _firestoreService
        .collection('posts')
        .doc(postId)
        .update({'content': newPost.content, 'editedDateTime': timestampNow});
  }

  // 포스트 수정하기
  Future deletePost(
    String postId,
  ) async {
    // String docUid = _firestoreService.collection('posts').doc().id;
    Timestamp timestampNow = Timestamp.fromDate(DateTime.now());
    // print(docUid);

    await _firestoreService
        .collection('posts')
        .doc(postId)
        .delete()
        .then((value) => print("user delete"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  // 포스트 받아오기
  Future getPosts() async {
    List<PostModel> posts = [];
    await _firestoreService
        .collection('posts')
        .orderBy('writtenDateTime', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        posts.add(PostModel.fromMap(element.data()));
      });
    });
    return posts;
  }

  // 한 포스트 다시 받아오기
  Future getThisPost(PostModel post) async {
    return await _firestoreService
        .collection('posts')
        .doc(post.postId)
        .get()
        .then((value) => PostModel.fromMap(value.data()!));
  }

  // 코멘트 올리기
  Future uploadNewComment(CommentModel newComment) async {
    String docUid = _firestoreService
        .collection('posts')
        .doc(newComment.commentToPostId)
        .collection('comments')
        .doc()
        .id;
    Timestamp timestampNow = Timestamp.fromDate(DateTime.now());

    await _firestoreService
        .collection('posts')
        .doc(newComment.commentToPostId)
        .collection('comments')
        .doc(docUid)
        .set(newComment
            .copyWith(
              commentId: docUid,
              writtenDateTime: timestampNow,
            )
            .toMap());

    await _firestoreService
        .collection('posts')
        .doc(newComment.commentToPostId)
        .update({
      'commentedBy': FieldValue.arrayUnion([docUid])
    });
  }

  // 코멘트 받아오기
  Future getComments(PostModel post) async {
    List<CommentModel> comments = [];
    await _firestoreService
        .collection('posts')
        .doc(post.postId)
        .collection('comments')
        .orderBy('writtenDateTime', descending: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        comments.add(CommentModel.fromMap(element.data()));
      });
    });
    return comments;
  }

  // 코멘트 삭제하기
  Future deleteComment(
    String postId,
    String commentId,
  ) async {
    // String docUid = _firestoreService.collection('posts').doc().id;
    Timestamp timestampNow = Timestamp.fromDate(DateTime.now());
    // print(docUid);

    await _firestoreService
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .delete()
        .then((value) => print("user delete"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  // 컨텐츠 관련
  // 읽을 거리 가져오기
  Future<List<ReadingContentModel>> getReadingContents() async {
    List<ReadingContentModel> readingContents = [];
    await _firestoreService
        .collection('readingContents')
        .orderBy('updateDateTime', descending: true)
        .get()
        .then((value) => value.docs.forEach((element) {
              readingContents.add(ReadingContentModel.fromMap(element.data()));
            }));
    return readingContents;
  }

  // 오늘의 시장 가져오기
  Future<List<TodayMarketModel>> getTodayMarkets() async {
    List<TodayMarketModel> todayMarketModel = [];
    await _firestoreService
        .collection('todayMarkets')
        .orderBy('dateTime', descending: true)
        .get()
        .then((value) => value.docs.forEach((element) {
              todayMarketModel.add(TodayMarketModel.fromMap(element.data()));
            }));
    return todayMarketModel;
  }

  // 금융백과사전 가져오기
  Future<List<DictionaryModel>> getDictionaries() async {
    List<DictionaryModel> dictionaries = [];
    await _firestoreService
        .collection('dictionaries')
        .orderBy('updateDateTime', descending: true)
        .get()
        .then((value) => value.docs.forEach((element) {
              dictionaries.add(DictionaryModel.fromMap(element.data()));
            }));
    return dictionaries;
  }

  // admin 에서 standards 가져오기
  Future<AdminStandardsModel> getAdminStandards() async {
    var adminStandardsModel;

    await _firestoreService
        .collection('admin')
        .doc('standards')
        .get()
        .then((value) {
      adminStandardsModel = AdminStandardsModel.fromMap(value.data()!);
    });

    return adminStandardsModel;
  }

  // 유저가 광고를 보면 아이템을 올려주거나, 퀘스트 참여시 아이템을 차감해준다.
  Future updateUserItem(int itemChange) async {
    if (userModelRx.value != null)
      await _firestoreService
          .collection('users')
          .doc('${userModelRx.value!.uid}')
          .update({'item': FieldValue.increment(itemChange)});
  }

  // 유저가 광고를 보면 오늘 본 광고갯수를 올려준다
  Future updateUserRewardedCnt() async {
    if (userModelRx.value != null)
      await _firestoreService
          .collection('users')
          .doc('${userModelRx.value!.uid}')
          .update({'rewardedCnt': FieldValue.increment(1)});
  }

  // fcm token이 없는 유저들(처음 들어온 유저들)은 토큰을 업데이트
  Future updateUserFCMToken(String token) async {
    await _firestoreService
        .collection('users')
        .doc('${userModelRx.value!.uid}')
        .update({'token': token});
  }

  // 유저 계좌정보 넣기
  Future setAccInformations(
      String accNumber, String accName, String secName, String uid) async {
    await _firestoreService.collection('users').doc(uid).update({
      'account.accNumber': accNumber,
      'account.accName': accName,
      'account.secName': secName,
    });
  }

  // 친구추천코드 관련
  // 프렌즈코드가 다른 유저들이랑 겹치는지 검사해준다.
  Future<bool> isFriendsCodeDuplicated(String friendsCode) async {
    var data;

    await _firestoreService
        .collection('users')
        .where('friendsCode', isEqualTo: friendsCode)
        .get()
        .then((value) => value.docs.forEach((element) {
              data = element.data();
            }));

    return (data != null);
  }

  // 유저가 입력한 프렌즈코드를 가진 유저를 찾아준다.
  Future<String> searchByFriendsCode(String friendsCode) async {
    var data;
    await _firestoreService
        .collection('users')
        .where('friendsCode', isEqualTo: friendsCode)
        .get()
        .then((value) => value.docs.forEach((element) {
              data = element.id;
            }));

    return data;
  }

  Future updateFriendsCode(String uid, String friendsCode) async {
    print("friendsCode IS" + friendsCode);
    await _firestoreService
        .collection('users')
        .doc(uid)
        .update({'friendsCode': friendsCode});
  }

  Future updateInsertedFriendsCode(
      String uid, String insertedFriendsCode) async {
    print("insertedFriendsCode IS" + insertedFriendsCode);
    await _firestoreService
        .collection('users')
        .doc(uid)
        .update({'insertedFriendsCode': insertedFriendsCode});
  }
}
