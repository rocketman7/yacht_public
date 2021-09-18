import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachtOne/models/users/user_model.dart';

import '../../services/storage_service.dart';
import '../../services/firestore_service.dart';
import '../../locator.dart';
import '../../repositories/repository.dart';
import '../../models/profile_models.dart';
import '../../models/quest_model.dart';
import '../../models/users/user_quest_model.dart';
import 'profile_share_ui.dart';

class ProfileMyViewModel extends GetxController {
  FirestoreService _firestoreService = locator<FirestoreService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  late List<FavoriteStockModel> favoriteStockModels;
  late List<FavoriteStockHistoricalPriceModel>
      favoriteStockHistoricalPriceModels;
  bool isUserModelLoaded = false;
  bool isFavoritesLoaded = false;

  RxInt avatarIndex = 0.obs;
  List<String> avatarImagesURLs = [];

  final TextEditingController nameChangeController = TextEditingController();
  final TextEditingController introChangeController = TextEditingController();

  @override
  void onInit() async {
    if (userModelRx.value != null) {
      // 혹시 userModelRx가 안불러와져있을 경우를 대비한건데 올바르게 작동할건지 아직 테스트는 안해봄
      isUserModelLoaded = true;
      update(['profile']);
    }

    favoriteStockModels = await loadFavoriteStocks();
    favoriteStockHistoricalPriceModels = await loadFavoriteStocksPrices();
    isFavoritesLoaded = true;
    update(['favorites']);

    super.onInit();
  }

  Future<List<FavoriteStockModel>> loadFavoriteStocks() async {
    List<FavoriteStockModel> tempStockModels = [];
    if (userModelRx.value!.favoriteStocks != null) {
      for (int i = 0;
          i <
              min(maxNumOfFavoriteStocks,
                  userModelRx.value!.favoriteStocks!.length);
          i++) {
        tempStockModels.add(await _firestoreService.getFavoriteStockModel(
            'KR', userModelRx.value!.favoriteStocks![i]));
      }
    }
    return tempStockModels;
  }

  Future<List<FavoriteStockHistoricalPriceModel>>
      loadFavoriteStocksPrices() async {
    List<FavoriteStockHistoricalPriceModel> tempStockHistoricalPriceModels = [];
    if (userModelRx.value!.favoriteStocks != null) {
      for (int i = 0;
          i <
              min(maxNumOfFavoriteStocks,
                  userModelRx.value!.favoriteStocks!.length);
          i++) {
        tempStockHistoricalPriceModels.add(
            await _firestoreService.getFavoriteStockHistoricalPriceModel(
                'KR', userModelRx.value!.favoriteStocks![i]));
      }
    }
    return tempStockHistoricalPriceModels;
  }

  Future<String> getImageUrlFromStorage(String imageUrl) async {
    return await _firebaseStorageService.downloadImageURL(imageUrl);
  }

  Future<UserModel> getOtherUserModel(String uid) async {
    UserModel user;

    user = await _firestoreService.getUserModel(uid);

    return user;
  }

  Future<List<String>> getAvatarImagesURLs() async {
    return (await _firestoreService.getAdminStandards()).avatarImages;
  }

  Future updateAvatarImageMethod(String avatarImageURL) async {
    await _firestoreService.updateAvatarImage(avatarImageURL);
  }

  Future updateUserNameOrIntroMethod(String userName, String intro) async {
    print(userName);
    print(intro);

    await _firestoreService.updateUserNameOrIntro(userName, intro);
  }

  // 퀘스트 참여기록 파트
  // 유저가 참여한 퀘스트의 퀘스트 정보 가져오기
  Future<QuestModel> getEachQuestModel(UserQuestModel userQuest) async {
    return await _firestoreService.getEachQuest(
        userQuest.leagueId!, userQuest.questId!);
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
          i == selection.length - 1
              ? result += '${selection[i]}'
              : result += '${selection[i]}, ';
        }
        return result;
      }

      return makePickResult(userSelect);
    }
  }
}
