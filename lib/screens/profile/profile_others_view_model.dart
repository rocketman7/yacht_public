import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../repositories/repository.dart';
import '../../services/storage_service.dart';
import '../../services/firestore_service.dart';
import '../../locator.dart';
import '../../models/users/user_model.dart';
import '../../models/profile_models.dart';
import '../../models/quest_model.dart';
import '../../models/users/user_quest_model.dart';
import 'profile_share_ui.dart';

class ProfileOthersViewModel extends GetxController {
  final String uid;
  ProfileOthersViewModel({required this.uid});

  FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  late UserModel user;
  late List<FavoriteStockModel> favoriteStockModels;
  late List<FavoriteStockHistoricalPriceModel> favoriteStockHistoricalPriceModels;
  bool isUserModelLoaded = false;
  bool isFavoritesLoaded = false;

  bool isFollowing = false;
  RxList<UserQuestModel> otherUserQuestModels = <UserQuestModel>[].obs;

  @override
  void onInit() async {
    if (userModelRx.value!.followings != null && userModelRx.value!.followings!.contains(uid)) isFollowing = true;

    user = await _firestoreService.getOtherUserModel(uid);
    await getUserQuestFuture(uid);
    isUserModelLoaded = true;
    update(['profile']);

    favoriteStockModels = await loadFavoriteStocks();
    favoriteStockHistoricalPriceModels = await loadFavoriteStocksPrices();
    isFavoritesLoaded = true;
    update(['favorites']);
    super.onInit();
  }

  Future<List<FavoriteStockModel>> loadFavoriteStocks() async {
    List<FavoriteStockModel> tempStockModels = [];
    if (user.favoriteStocks != null) {
      for (int i = 0; i < min(maxNumOfFavoriteStocks, user.favoriteStocks!.length); i++) {
        tempStockModels.add(await _firestoreService.getFavoriteStockModel('KR', user.favoriteStocks![i]));
      }
    }
    return tempStockModels;
  }

  Future<List<FavoriteStockHistoricalPriceModel>> loadFavoriteStocksPrices() async {
    List<FavoriteStockHistoricalPriceModel> tempStockHistoricalPriceModels = [];
    if (user.favoriteStocks != null) {
      for (int i = 0; i < min(maxNumOfFavoriteStocks, user.favoriteStocks!.length); i++) {
        tempStockHistoricalPriceModels
            .add(await _firestoreService.getFavoriteStockHistoricalPriceModel('KR', user.favoriteStocks![i]));
      }
    }
    return tempStockHistoricalPriceModels;
  }

  Future<String> getImageUrlFromStorage(String imageUrl) async {
    return await _firebaseStorageService.downloadImageURL(imageUrl);
  }

  Future followSomeoneMethod() async {
    isFollowing = true;
    update(['profile']);

    await _firestoreService.followSomeone(user.uid);

    getRawSnackbar('팔로우했어요!');
  }

  Future unFollowSomeoneMethod() async {
    isFollowing = false;
    update(['profile']);

    await _firestoreService.unFollowSomeone(user.uid);

    getRawSnackbar('팔로우를 취소했어요!');
  }

  Future reloadUserModel() async {
    user = await _firestoreService.getOtherUserModel(uid);

    update(['profile']);
  }

  // 퀘스트 참여기록 파트
  Future getUserQuestFuture(String uid) async {
    otherUserQuestModels.addAll(await _firestoreService.getUserQuestFuture(uid));
    // return await _firestoreService.getUserQuestFuture(uid);
    print('otherUserQuestModels: $otherUserQuestModels');
  }

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

void getRawSnackbar(String text) {
  Get.rawSnackbar(
    messageText: Center(
      child: Text(
        text,
        style: snackBarStyle,
      ),
    ),
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: white.withOpacity(.5),
    barBlur: 2,
    duration: const Duration(milliseconds: 1000),
  );
}
