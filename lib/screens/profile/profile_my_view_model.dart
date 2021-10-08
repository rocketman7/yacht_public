import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

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
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  late List<FavoriteStockModel> favoriteStockModels;
  late List<FavoriteStockHistoricalPriceModel> favoriteStockHistoricalPriceModels;
  bool isUserModelLoaded = false;
  bool isFavoritesLoaded = false;

  RxInt avatarIndex = 0.obs;
  List<String> avatarImagesURLs = [];

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameChangeController = TextEditingController();
  final TextEditingController introChangeController = TextEditingController();

  RxBool isCheckingUserNameDuplicated = false.obs;

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

  @override
  void onClose() {
    nameChangeController.dispose();
    introChangeController.dispose();

    super.onClose();
  }

  Future<List<FavoriteStockModel>> loadFavoriteStocks() async {
    List<FavoriteStockModel> tempStockModels = [];
    if (userModelRx.value!.favoriteStocks != null) {
      for (int i = 0; i < min(maxNumOfFavoriteStocks, userModelRx.value!.favoriteStocks!.length); i++) {
        tempStockModels.add(await _firestoreService.getFavoriteStockModel('KR', userModelRx.value!.favoriteStocks![i]));
      }
    }
    return tempStockModels;
  }

  Future<List<FavoriteStockHistoricalPriceModel>> loadFavoriteStocksPrices() async {
    List<FavoriteStockHistoricalPriceModel> tempStockHistoricalPriceModels = [];
    if (userModelRx.value!.favoriteStocks != null) {
      for (int i = 0; i < min(maxNumOfFavoriteStocks, userModelRx.value!.favoriteStocks!.length); i++) {
        tempStockHistoricalPriceModels.add(
            await _firestoreService.getFavoriteStockHistoricalPriceModel('KR', userModelRx.value!.favoriteStocks![i]));
      }
    }
    return tempStockHistoricalPriceModels;
  }

  // Future<String> getImageUrlFromStorage(String imageUrl) async {
  //   return await _firebaseStorageService.downloadImageURL(imageUrl);
  // }

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

  Future<bool> isUserNameDuplicated(String userName) async {
    return await _firestoreService.isUserNameDuplicated(userName);
  }

  Future updateUserNameMethod(BuildContext context, String userName) async {
    print(userName);
    isCheckingUserNameDuplicated(true);
    bool isUserNameDuplicatedVar = true;

    isUserNameDuplicatedVar = await isUserNameDuplicated(userName);

    if (!isUserNameDuplicatedVar) {
      await _firestoreService.updateUserName(userName);
      Get.rawSnackbar(
        messageText: Center(
          child: Text(
            "변경한 내용이 저장되었어요.",
            style: snackBarStyle,
          ),
        ),
        backgroundColor: white.withOpacity(.5),
        barBlur: 8,
        duration: const Duration(seconds: 1, milliseconds: 100),
      );
    } else {
      userNameDuplicatedDialog(context);
    }

    isCheckingUserNameDuplicated(false);
  }

  Future updateUserIntroMethod(String intro) async {
    print(intro);

    await _firestoreService.updateUserIntro(intro);
    Get.rawSnackbar(
      messageText: Center(
        child: Text(
          "변경한 내용이 저장되었어요.",
          style: snackBarStyle,
        ),
      ),
      backgroundColor: white.withOpacity(.5),
      barBlur: 8,
      duration: const Duration(seconds: 1, milliseconds: 100),
    );
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

// 닉네임 겹침
userNameDuplicatedDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: primaryBackgroundColor,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            height: 196.w,
            width: 347.w,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 21.w,
                    ),
                    SizedBox(
                        height: 15.w,
                        width: 15.w,
                        child: Image.asset('assets/icons/exit.png', color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.w,
                        ),
                        Text('알림', style: yachtBadgesDialogTitle.copyWith(fontSize: 16.w))
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Row(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 15.w,
                              ),
                              SizedBox(
                                  height: 15.w,
                                  width: 15.w,
                                  child: Image.asset('assets/icons/exit.png', color: yachtBlack)),
                            ],
                          ),
                          SizedBox(
                            height: 30.w,
                            width: 21.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height:
                      correctHeight(48.w, yachtBadgesDialogTitle.fontSize, yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Text(
                  "이미 사용 중인 닉네임입니다!",
                  textAlign: TextAlign.center,
                  style: yachtBadgesDescriptionDialogTitle,
                ),
                SizedBox(
                  height: correctHeight(37.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 44.w,
                        width: 319.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: yachtViolet,
                        ),
                        child: Center(
                          child: Text(
                            '확인',
                            style: yachtDeliveryDialogButtonText,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 14.w,
                ),
              ],
            ),
          ),
        );
      });
}
