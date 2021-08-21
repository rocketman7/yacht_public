import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/community/comment_model.dart';
import 'package:yachtOne/models/community/post_model.dart';
import 'package:yachtOne/models/league_address_model.dart';
import 'package:yachtOne/models/news_model.dart';
import 'package:yachtOne/models/price_chart_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/reading_content_model.dart';
import 'package:yachtOne/models/stats_model.dart';
import 'package:yachtOne/models/corporation_model.dart';
import 'package:yachtOne/models/temp_realtime_model.dart';
import 'package:yachtOne/models/today_market_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';

import '../models/subLeague_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _firestoreService = FirebaseFirestore.instance;
  FirebaseFirestore get firestoreService => _firestoreService;

  CollectionReference get _tempCollectionReference => _firestoreService.collection('temp');
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
    return await _firestoreService.collection('users').doc(uid).get().then((value) => UserModel.fromMap(value.data()!));
  }

  // User Model 스트림
  Stream<UserModel> getUserStream(String uid) {
    return _firestoreService.collection('users').doc(uid).snapshots().map((snapshot) {
      print('user data stream changed');
      print('user model snapshot: ${snapshot.data()}');
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
        .collection('users/kakao:1513684681/userVote')
        .doc('202109')
        .collection('quests')
        .doc(questModel.questId)
        .update({'selection': answers});
  }

  // 차트 그리기 위한 Historical Price
  Future<List<ChartPriceModel>> getPrices(StockAddressModel stockAddress) async {
    CollectionReference _historicalPriceRef =
        _firestoreService.collection('stocksKR/${stockAddress.issueCode}/historicalPrices');
    List<ChartPriceModel> _priceChartModelList = [];

    try {
      await _historicalPriceRef
          .orderBy('dateTime', descending: true)
          .get()
          .then((querySnapshot) => querySnapshot.docs.forEach((doc) {
                // print(doc.id);  // document id 출력
                _priceChartModelList.add(ChartPriceModel.fromMap(doc.data() as Map<String, dynamic>));
              }));
      // print(_priceChartModelList);
      return _priceChartModelList;
    } catch (e) {
      throw e;
    }
  }

  // Stat 가져오기
  Future<List<StatsModel>> getStats(StockAddressModel stockAddress) async {
    // CollectionReference _samsungElectronic =
    //     _firestoreService.collection('stocksKR/005930/stats');
    // CollectionReference _skBioPharm =
    //     _firestoreService.collection('stocksKR/326030/stats');
    // CollectionReference _abKo =
    //     _firestoreService.collection('stocksKR/129890/stats');
    CollectionReference _statsRef = _firestoreService.collection('stocksKR/${stockAddress.issueCode}/stats');
    List<StatsModel> _statstModelList = [];

    try {
      await _statsRef
          .orderBy('dateTime', descending: true)
          .get()
          .then((querySnapshot) => querySnapshot.docs.forEach((doc) {
                // print(doc.id);  // document id 출력
                _statstModelList.add(StatsModel.fromMap(doc.data() as Map<String, dynamic>));
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
        _firestoreService.collection('temp').doc('count').update({'count': temp});
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
    final List<StockAddressModel> options = [];
    await _firestoreService.collection('leagues').doc('league001').collection('quests').get().then((value) {
      value.docs.forEach((element) {
        // options 필드의 List of Object를 아래와 같이 처리
        element.data()['options'].toList().forEach((option) {
          options.add(StockAddressModel.fromMap(option));
        });

        // print('questmodel options from db: $options');
        allQuests.add(QuestModel.fromMap(element.id, element.data(), options));
        // print(allQuests);
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
  Future<CorporationModel> getCorporationInfo(StockAddressModel stockAddressModel) async {
    return await _firestoreService
        .collection('stocksKR')
        .doc('${stockAddressModel.issueCode}')
        .get()
        .then((value) => CorporationModel.fromMap(value.data()!));
  }

  Future<List<NewsModel>> getNews(StockAddressModel stockAddressModel) async {
    final List<NewsModel> allNews = [];
    await _firestoreService
        .collection('stocksKR')
        .doc('${stockAddressModel.issueCode}')
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
  Stream<List<TempRealtimeModel>> getTempRealtimePrice() {
    return _firestoreService
        .collection('realtimePrice/KR/20210729')
        .where('issueCode', isEqualTo: '300720')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((element) {
        // print(element.data());
        return TempRealtimeModel.fromMap(element.data());
      }).toList();
    });
  }

  Stream<List<TempRealtimeModel>> getTempRealtimePrice0() {
    return _firestoreService
        .collection('realtimePrice/KR/20210729')
        .where('issueCode', isEqualTo: '196170')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((element) {
        // print(element.data());
        return TempRealtimeModel.fromMap(element.data());
      }).toList();
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

  // 포스트 받아오기
  Future getPosts() async {
    List<PostModel> posts = [];
    await _firestoreService.collection('posts').orderBy('writtenDateTime', descending: true).get().then((value) {
      value.docs.forEach((element) {
        posts.add(PostModel.fromMap(element.data()));
      });
    });
    return posts;
  }

  // 코멘트 올리기
  Future uploadNewComment(CommentModel newComment) async {
    String docUid =
        _firestoreService.collection('posts').doc(newComment.commentToPostId).collection('comments').doc().id;
    Timestamp timestampNow = Timestamp.fromDate(DateTime.now());
    print(docUid);

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

  // 컨텐츠 관련
  // 읽을 거리 가져오기
  Future<List<ReadingContentModel>> getReadingContents() async {
    List<ReadingContentModel> readingContents = [];
    await _firestoreService
        .collection('readingContents')
        .orderBy('updatedDateTime', descending: true)
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
              print(element.data());
              todayMarketModel.add(TodayMarketModel.fromMap(element.data()));
            }));
    return todayMarketModel;
  }
}
