import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/models/users/user_quest_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/profile/asset_view_model.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';

import '../../locator.dart';

// StockModel
class StockModel {
  String name;
  String logoUrl;

  StockModel({
    required this.name,
    required this.logoUrl,
  });

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      name: map['name'],
      logoUrl: map['logoUrl'],
    );
  }
}

// StockHistoricalPriceModel
class StockHistoricalPriceModel {
  num close;
  num prevClose;

  StockHistoricalPriceModel({required this.close, required this.prevClose});
}

// 티어정보별로 색깔을 가지고 있는다.
Map<String, Color> tierColor = {
  'newbie': Color(0xFFFCE4A8),
  'intern': Color(0xFFCDE7AC),
  'amateur': Color(0xFFC2E7F2),
  'pro': Color(0xFFC3C2FF),
  'master': Color(0xFFE1BFFC),
  'grandmaster': Color(0xFFFEB8B8),
};

// 티어별 스토리지 주소를 갖고 있는다.
Map<String, String> tierJellyBeanURL = {
  'newbie': 'tier/newbie.png',
  'intern': 'tier/intern.png',
  'amateur': 'tier/amateur.png',
  'pro': 'tier/pro.png',
  'master': 'tier/master.png',
  'grandmaster': 'tier/grandmaster.png',
};

// 티어별 네임을 갖고 있는다. 경험지에 따른 레벨도 갖고 있는다. 위 색깔, 스토리지 주소, 아래는 모두 admin에 있는게 나을 듯?
Map<String, String> tierKRWName = {
  'newbie': '뉴비',
  'intern': '인턴',
  'amateur': '아마추어',
  'pro': '프로',
  'master': '마스터',
  'grandmaster': '그랜드마스터',
};

class ProfileController extends GetxController {
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  FirestoreService _firestoreService = locator<FirestoreService>();

  //////////////////////// storage  service 부분 ////////////////////////
  Future<String> getLogoUrl(String url) async {
    final link = await FirebaseStorage.instance.ref().child('logo/').child('$url').getDownloadURL().catchError((e) {
      print('ERROR: $e');
    });

    return link;
  }

  //////////////////////// database service 부분 ////////////////////////
  final FirebaseFirestore firestoreService = FirebaseFirestore.instance;

  Future<UserModel> getOtherUserModel(String uid) async {
    var userModel;

    await firestoreService.collection('users').doc(uid).get().then((value) {
      userModel = UserModel.fromMap(value.data()!);
    });

    return userModel;
  }

  Future<StockModel> getStockModel(String country, String issueCode) async {
    var stockModel;

    await firestoreService.collection('stocks' + country).doc(issueCode).get().then((value) {
      stockModel = StockModel.fromMap(value.data()!);
    });

    return stockModel;
  }

  Future<StockHistoricalPriceModel> getStockHistoricalPriceModel(String country, String issueCode) async {
    var stockHistoricalPriceModel;

    //
    await firestoreService
        .collection('stocks' + country)
        .doc(issueCode)
        .collection('historicalPrices')
        .where('cycle', isEqualTo: 'D')
        .orderBy('dateTime', descending: true)
        .limit(2)
        .get()
        .then((value) {
      stockHistoricalPriceModel = StockHistoricalPriceModel(
        close: value.docs[0].data()['close'],
        prevClose: value.docs[1].data()['close'],
      );
    });

    return stockHistoricalPriceModel;
  }

  Future updateAvatarImage(String avatarImageURL) async {
    userModelRx.update((val) {
      val!.avatarImage = avatarImageURL;
    });

    await firestoreService.collection('users').doc(userModelRx.value!.uid).update({'avatarImage': avatarImageURL});
  }

  Future updateUserNameOrIntro(String userName, String intro) async {
    userModelRx.update((val) {
      val!.userName = userName;
      val.intro = intro;
    });

    await firestoreService
        .collection('users')
        .doc(userModelRx.value!.uid)
        .update({'userName': userName, 'intro': intro});
  }

  //누군가를 팔로우하면 그 유저의 followers를 늘려주고 내 following도 늘려줘야함
  Future followSomeone(String otherUid) async {
    await firestoreService.collection('users').doc(otherUid).update({
      'followers': FieldValue.arrayUnion(['${userModelRx.value!.uid}'])
    });

    await firestoreService.collection('users').doc(userModelRx.value!.uid).update({
      'followings': FieldValue.arrayUnion(['$otherUid'])
    });
  }

  ///////////////////////// 실제 Controller 부분 /////////////////////////
  int maxNumOfFavoriteStocks = 3; // 최초화면에서 즐겨찾기 종목이 최대 몇개 보일 것인지.

  String uid;
  bool isMe = false;

  ProfileController({required this.uid});

  late UserModel user;
  late List<StockModel> stockModels;
  late List<StockHistoricalPriceModel> stockHistoricalPriceModels;
  bool isUserModelLoaded = false;
  bool isFavoritesLoaded = false;

  RxInt avatarIndex = 0.obs;
  List<String> avatarImagesURLs = [];

  final TextEditingController nameChangeController = TextEditingController();
  final TextEditingController introChangeController = TextEditingController();

  @override
  void onInit() async {
    if (uid == userModelRx.value!.uid) {
      // 내 프로필이면
      isMe = true;
      user = userModelRx.value!;
    } else {
      // 남의 프로필이면
      user = await getOtherUserModel(uid);
    }
    isUserModelLoaded = true;
    update(['profile']);

    if (isMe) {
      // 내 프로필 보는 거라면 잔고 불러와야 하니까 미리 풋 해놓는다.
      // 근데 홈에도 이미 불러와져있어야 하네 -> 수정 필요
      Get.put(AssetViewModel());
    }

    stockModels = await loadFavoriteStocks();
    stockHistoricalPriceModels = await loadFavoriteStocksPrices();
    isFavoritesLoaded = true;
    update(['favorites']);

    // final var1 = await getLogoUrl('krx005930.png');
    // final var2 = await getLogoUrl('');
    // print('in the profile page: user is $user');

    // final List<String> temp = await getAvatarImagesURLs();

    super.onInit();
  }

  Future<List<StockModel>> loadFavoriteStocks() async {
    List<StockModel> tempStockModels = [];
    if (user.favoriteStocks != null) {
      for (int i = 0; i < min(maxNumOfFavoriteStocks, user.favoriteStocks!.length); i++) {
        tempStockModels.add(await getStockModel('KR', user.favoriteStocks![i]));
      }
    }
    return tempStockModels;
  }

  Future<List<StockHistoricalPriceModel>> loadFavoriteStocksPrices() async {
    List<StockHistoricalPriceModel> tempStockHistoricalPriceModels = [];
    if (user.favoriteStocks != null) {
      for (int i = 0; i < min(maxNumOfFavoriteStocks, user.favoriteStocks!.length); i++) {
        tempStockHistoricalPriceModels.add(await getStockHistoricalPriceModel('KR', user.favoriteStocks![i]));
      }
    }
    return tempStockHistoricalPriceModels;
  }

  Future<String> getImageUrlFromStorage(String imageUrl) async {
    return await _firebaseStorageService.downloadImageURL(imageUrl);
  }

  Future<List<String>> getAvatarImagesURLs() async {
    return (await _firestoreService.getAdminStandards()).avatarImages;
  }

  Future updateAvatarImageMethod(String avatarImageURL) async {
    await updateAvatarImage(avatarImageURL);
  }

  Future updateUserNameOrIntroMethod(String userName, String intro) async {
    print(userName);
    print(intro);

    await updateUserNameOrIntro(userName, intro);
  }

  Future followSomeoneMethod() async {
    await followSomeone(user.uid);
  }

  // 퀘스트 참여기록 파트
  // 유저가 참여한 퀘스트의 퀘스트 정보 가져오기
  Future<QuestModel> getEachQuestModel(UserQuestModel userQuest) async {
    return await _firestoreService.getEachQuest(userQuest.leagueId!, userQuest.questId!);
    // update(['userQuestRecord']);
  }

  String getUserChioce(QuestModel questModel, UserQuestModel userQuest) {
    if (questModel.selectMode == "updown") {
      return userQuest.selection![0] == 0 ? "상승" : "하락";
    } else if (questModel.selectMode == "order") {
      List userSelect = [];

      for (int investAddressIndex in userQuest.selection!) {
        userSelect.add(questModel.investAddresses![investAddressIndex].name);
      }
      String makeOrderResult(List selection) {
        String result = "";
        for (int i = 0; i < selection.length; i++) {
          result += '${i + 1}. ${selection[i]} ';
        }
        return result;
      }

      return makeOrderResult(userSelect);
    } else {
      List userSelect = [];
      for (int investAddressIndex in userQuest.selection!) {
        userSelect.add(questModel.investAddresses![investAddressIndex].name);
      }
      String makePickResult(List selection) {
        String result = "";
        for (int i = 0; i < selection.length; i++) {
          i == selection.length - 1 ? result += '${selection[i]}' : result += '${selection[i]}, ';
        }
        return result;
      }

      return makePickResult(userSelect);
    }
  }
}
