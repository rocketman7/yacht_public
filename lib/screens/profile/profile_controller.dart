import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';

import '../../locator.dart';

// 쓰인 DB구조 및 복합색인 / 업데이트 시점 등 (컬렉션 단위)
// userModel
// stocksKR
// stocksKR->개별종목->historicalPrices ( 복합색인사용.where(cycle==D)&orderBy(dateTime desc)&limit(2) )
// userModel->uid->userReward
// userModel->uid->userVote

// 기술적인 부분들
// 내 프로필 페이지인 경우는 stream인 애들도 있을 것이고
// 남 프로필 페이지인 경우는 그냥 단순히 모두 future로 처리하는게 나을 수도 있고
// 반면 팔로워 팔로잉 수는 내,남 프로필 관계없이 스트림 해주면 재밌을 듯?
// 내 프로필이든 남 프로필이든 몇가지 요소를 제외하고는 UI가 완전 동일.
// 이럴땐 어떻게 코딩하는것이 깔끔할까?
// 그냥 무조건 uid를 넘겨주고, 그걸 내 uid랑 비교해서 나인지 아닌지 결정. 그 다음 ㄱㄱ 이런식?

// UserModel
// class UserModel {
//   String uid;
//   String userName;
//   String tier;
//   num exp;
//   String avatarURL;

//   num followersNum;
//   List<String> followers;
//   num followingNum;
//   List<String> followings;
//   String intro;
//   List<String> favoriteStocks;
//   List<String> badges;

//   UserModel({
//     required this.uid,
//     required this.userName,
//     required this.tier,
//     required this.exp,
//     required this.avatarURL,
//     required this.followersNum,
//     required this.followers,
//     required this.followingNum,
//     required this.followings,
//     required this.intro,
//     required this.favoriteStocks,
//     required this.badges,
//   });

//   factory UserModel.fromMap(Map<String, dynamic> map) {
//     return UserModel(
//       uid: map['zuid'],
//       userName: map['zuserName'],
//       tier: map['ztier'],
//       exp: map['zexp'],
//       avatarURL: map['zavatarURL'],
//       followersNum: map['zfollowersNum'],
//       followers: List<String>.from(map['zfollowers']),
//       followingNum: map['zfollowingNum'],
//       followings: List<String>.from(map['zfollowings']),
//       intro: map['zintro'],
//       favoriteStocks: List<String>.from(map['zfavoriteStocks']),
//       badges: List<String>.from(map['zbadges']),
//     );
//   }
// }

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

class ProfileController extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  //////////////////////// storage  service 부분 ////////////////////////
  Future<String> getLogoUrl(String url) async {
    final link = await FirebaseStorage.instance.ref().child('logo/').child('$url').getDownloadURL().catchError((e) {
      print('ERROR: $e');
      // return 'error';
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

    // await Future.delayed(Duration(milliseconds: 500), () {});
    // stockModel = StockModel(name: '삼성전자', logoUrl: 'samsung.png');

    return stockModel;
  }

// 39, 32, 6, 10, 26, 27
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

    // await Future.delayed(Duration(milliseconds: 500), () {});
    // stockHistoricalPriceModel =
    //     StockHistoricalPriceModel(close: 45210, prevClose: 44000);

    return stockHistoricalPriceModel;
  }

  ///////////////////////// 실제 Controller 부분 /////////////////////////
  static ProfileController get to => Get.find();
  int maxNumOfFavoriteStocks = 3; // 최초화면에서 즐겨찾기 종목이 최대 몇개 보일 것인지.

  String uid;
  bool isMe = false;

  ProfileController({required this.uid});

  late UserModel user;
  late List<StockModel> stockModels;
  late List<StockHistoricalPriceModel> stockHistoricalPriceModels;
  bool isUserModelLoaded = false;
  bool isFavoritesLoaded = false;

  @override
  void onInit() async {
    if (uid == userModelRx.value!.uid) {
      // 내 프로필이면
      print('its me');
      isMe = true;
      user = userModelRx.value!;
    } else {
      // 남의 프로필이면
      user = await getOtherUserModel(uid);
    }
    isUserModelLoaded = true;
    update(['profile']);

    stockModels = await loadFavoriteStocks();
    stockHistoricalPriceModels = await loadFavoriteStocksPrices();
    isFavoritesLoaded = true;
    update(['favorites']);

    // final var1 = await getLogoUrl('krx005930.png');
    // final var2 = await getLogoUrl('');
    print('in the profile page: user is $user');
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
}
