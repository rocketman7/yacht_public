import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yachtOne/models/dictionary_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/stock_info_new_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/repositories/quest_repository.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/auth/email_verification_wating_view.dart';
import 'package:yachtOne/screens/award/award_view_model.dart';
import 'package:yachtOne/screens/ranks/rank_controller.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/services/push_notification_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../models/survey_model.dart';
import '../../services/adManager_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../locator.dart';
import '../stock_info/stock_info_new_controller.dart';

const int maxRewardedAds = 3; // 하루 최대 10개 광고 볼 수 있음. (나중에 DB로?)
const int maxFailedLoadAttempts = 10; // 광고로딩실패하면 10번까지는 계속 로딩 시도

class HomeViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService authService = locator<AuthService>();
  final FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  PushNotificationService pushNotificationService = locator<PushNotificationService>();
  QuestRepository _questRepository = QuestRepository();
  QuestModel? tempQuestModel;
  // 시즌 내에 모든 퀘스트 받아서 RxList에 저장
  final allQuests = <QuestModel>[].obs;

  final newQuests = <QuestModel>[].obs;
  final liveQuests = <QuestModel>[].obs;
  final resultQuests = <QuestModel>[].obs;

  late final String uid;
  Rxn<UserModel> userModel = Rxn<UserModel>();

  late String globalString;
  RxBool isLoading = true.obs;
  RxBool isQuestDataLoading = true.obs;
  RxBool checkIfFirstTime = false.obs;

  //rewardedAds 관련
  RewardedAd? _rewardedAd;
  RxBool isRewardedAdLoaded = false.obs;
  int _numRewardedLoadAttempts = 0;
  ScrollController scrollController = ScrollController();

  final GlobalKey<FormState> userNameFormKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController(text: "");
  final RxBool isCheckingUserNameDuplicated = false.obs;
  final RxBool noNeedShowUserNameDialog = true.obs;
  final RxBool showSmallSnackBar = false.obs;
  final RxString smallSnackBarText = "".obs;
  final RefreshController refreshController = RefreshController();

  final RankController rankController = Get.put(RankController());
  final AwardViewModel awardViewModel = Get.put(AwardViewModel());
  bool onceInit = false;
  final RxBool isGettingQuests = true.obs;
  RxList<StockInfoNewModel> stockInfoNewModels = <StockInfoNewModel>[].obs;
  // bool isModelLoaded = false;

  // Banner Ad
  AdManagerBannerAdListener? listener;
  AdManagerBannerAd? myBanner;
  RxBool isBannerAdLoaded = false.obs;
  RxString bannerAdPosition = "middle".obs;

  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  @override
  void onClose() {
    // TODO: implement onClose
    scrollController.dispose();
    refreshController.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    final appStartTime = DateTime.now();
    _mixpanelService.mixpanel.identify(userModelRx.value!.uid);
    _mixpanelService.mixpanel.flush();

    await remoteConfig.fetchAndActivate();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 10),
      minimumFetchInterval: Duration(seconds: 1),
    ));
    print("step1: ${DateTime.now().difference(appStartTime)}");
    // bannerAdPosition(remoteConfig.getString('banner_ad_position'));
    // print('bannerAdPosition: $bannerAdPosition');
    // TODO: implement onInit
    isLoading(true);
    stockInfoNewModels(await _firestoreService.getYachtPicks());
    // isModelLoaded = true;
    print("step2: ${DateTime.now().difference(appStartTime)}");
    isGettingQuests(true);
    await getAllQuests();
    print("step3: ${DateTime.now().difference(appStartTime)}");
    isGettingQuests(false);
    await _firestoreService.stampLastLogin();

    // print(_authService.auth.currentUser!.email);
    if (authService.auth.currentUser!.email != null) {
      // print(
      //     'email login method:${await authService.auth.fetchSignInMethodsForEmail(authService.auth.currentUser!.email!)}');
      List<String> methodList = await authService.auth.fetchSignInMethodsForEmail(authService.auth.currentUser!.email!);
      if (methodList.length > 0) {
        if (methodList.first == 'password' && !authService.auth.currentUser!.emailVerified) {
          Get.to(() => EmailVerificationWaitingView());
        }
      }
    }

    isLoading(false);
    _mixpanelService.mixpanel.track('Home');

    _createRewardedAd();

    instantiateBannerAd();

    if (userModelRx.value != null) {
      // print('usermodel name update' + userModelRx.value!.isNameUpdated.toString());
      noNeedShowUserNameDialog(userModelRx.value!.isNameUpdated ?? false);
      // print(noNeedShowUserNameDialog.value);
      noNeedShowUserNameDialog.refresh();
      // print(noNeedShowUserNameDialog.value);
    }

    super.onInit();
  }

  instantiateBannerAd() {
    listener = AdManagerBannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) {
        print('Ad loaded.');
        isBannerAdLoaded(true);
      },
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    );
    myBanner = AdManagerBannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      sizes: [AdSize.banner],
      request: AdManagerAdRequest(),
      listener: listener!,
    )..load();
    // myBanner.load();
  }

  Future<bool> isUserNameDuplicated(String userName) async {
    return await _firestoreService.isUserNameDuplicated(userName);
  }

  Future<String> getYachtPickDescription() async {
    return await _firestoreService.getYachtPickDescription();
  }

  Future updateUserName(userName) async {
    await _firestoreService.updateUserName(userName);
  }

  Future updateUserNameMethod(String userName, BuildContext context) async {
    isCheckingUserNameDuplicated(true);
    bool isUserNameDuplicatedVar = true;

    isUserNameDuplicatedVar = await isUserNameDuplicated(userName);
    print(isUserNameDuplicatedVar);
    if (!isUserNameDuplicatedVar) {
      await _firestoreService.updateUserName(userName);
      showSmallSnackBar(true);
      smallSnackBarText("닉네임이 저장되었어요");
      Future.delayed(Duration(seconds: 1)).then((value) {
        showSmallSnackBar(false);
        smallSnackBarText("");
      });
      Navigator.pop(context);

      // Get.rawSnackbar(
      //   messageText: Center(
      //     child: Text(
      //       "변경한 내용이 저장되었어요.",
      //       style: snackBarStyle,
      //     ),
      //   ),
      //   backgroundColor: yachtWhite.withOpacity(.5),
      //   barBlur: 8,
      //   duration: const Duration(seconds: 1, milliseconds: 100),
      // );
    } else {
      showSmallSnackBar(true);
      smallSnackBarText("중복된 닉네임이 있어요");
      Future.delayed(Duration(seconds: 1)).then((value) {
        showSmallSnackBar(false);
        smallSnackBarText("");
      });
      // userNameDuplicatedDialog();
    }

    isCheckingUserNameDuplicated(false);
  }

  // showUserNameDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => Dialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10.w),
  //       ),
  //       insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
  //       child: Container(
  //           constraints: BoxConstraints.loose(
  //             Size(double.infinity, 180.w),
  //           ),
  //           padding: defaultHorizontalPadding,
  //           child: Form(
  //             key: userNameFormKey,
  //             child: Stack(
  //               children: [
  //                 Column(
  //                   children: [
  //                     appBarWithoutCloseButton(title: "닉네임 설정"),
  //                     SizedBox(height: 8.w),
  //                     TextFormField(
  //                       controller: userNameController,
  //                       textAlignVertical: TextAlignVertical.bottom,
  //                       keyboardType: TextInputType.name,
  //                       decoration: InputDecoration(
  //                         isDense: true,
  //                         contentPadding: EdgeInsets.all(0.w),
  //                         focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
  //                         enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
  //                         hintText: '${userModelRx.value!.userName}',
  //                         hintStyle: profileChangeContentTextStyle.copyWith(color: yachtGrey),
  //                       ),
  //                       validator: (value) {
  //                         if (value != '') {
  //                           final nickValidator = RegExp(r'^[a-zA-Zㄱ-ㅎ|ㅏ-ㅣ|가-힣0-9]+$');
  //                           if (value!.length > 8 || !nickValidator.hasMatch(value) || value.contains(' ')) {
  //                             return "! 닉네임은 8자 이하의 한글,영문,숫자 조합만 가능합니다.";
  //                           } else {
  //                             return null;
  //                           }
  //                         }
  //                       },
  //                       onChanged: (value) {
  //                         if (userNameFormKey.currentState!.validate()) {
  //                           print('good');
  //                         } else {
  //                           print('bad');
  //                         }
  //                       },
  //                     ),
  //                     SizedBox(height: 16.w),
  //                     Align(
  //                       alignment: Alignment.bottomCenter,
  //                       child: GestureDetector(
  //                         behavior: HitTestBehavior.opaque,
  //                         onTap: () async {
  //                           // Get.dialog(Dialog(
  //                           //   child: Text("TTT"),
  //                           // ));
  //                           // print('tap');
  //                           if (userNameController.text == '') {
  //                             showSmallSnackBar(true);
  //                             smallSnackBarText("닉네임을 입력해주세요");
  //                             Future.delayed(Duration(seconds: 1)).then((value) {
  //                               showSmallSnackBar(false);
  //                               smallSnackBarText("");
  //                             });
  //                             // Get.rawSnackbar(
  //                             //   messageText: Center(
  //                             //     child: Text(
  //                             //       "변경한 내용이 없어요.",
  //                             //       style: snackBarStyle,
  //                             //     ),
  //                             //   ),
  //                             //   backgroundColor: yachtWhite.withOpacity(.5),
  //                             //   barBlur: 8,
  //                             //   duration: const Duration(seconds: 1, milliseconds: 100),
  //                             // );
  //                           } else if (userNameFormKey.currentState!.validate() &&
  //                               isCheckingUserNameDuplicated.value == false) {
  //                             if (userNameController.text != '') {
  //                               print(userNameController.text);
  //                               isCheckingUserNameDuplicated(true);
  //                               bool isUserNameDuplicatedVar = true;

  //                               isUserNameDuplicatedVar = await isUserNameDuplicated(userNameController.text);
  //                               print(isUserNameDuplicatedVar);
  //                               if (!isUserNameDuplicatedVar) {
  //                                 await _firestoreService.updateUserName(userNameController.text);
  //                                 showSmallSnackBar(true);
  //                                 smallSnackBarText("닉네임이 저장되었어요");
  //                                 Future.delayed(Duration(seconds: 1)).then((value) {
  //                                   showSmallSnackBar(false);
  //                                   smallSnackBarText("");
  //                                   Navigator.of(context).pop();
  //                                 });

  //                                 // Get.rawSnackbar(
  //                                 //   messageText: Center(
  //                                 //     child: Text(
  //                                 //       "변경한 내용이 저장되었어요.",
  //                                 //       style: snackBarStyle,
  //                                 //     ),
  //                                 //   ),
  //                                 //   backgroundColor: yachtWhite.withOpacity(.5),
  //                                 //   barBlur: 8,
  //                                 //   duration: const Duration(seconds: 1, milliseconds: 100),
  //                                 // );
  //                               } else {
  //                                 showSmallSnackBar(true);
  //                                 smallSnackBarText("중복된 닉네임이 있어요");
  //                                 Future.delayed(Duration(seconds: 1)).then((value) {
  //                                   showSmallSnackBar(false);
  //                                   smallSnackBarText("");
  //                                 });
  //                                 // userNameDuplicatedDialog();
  //                               }

  //                               isCheckingUserNameDuplicated(false);
  //                             }
  //                           }
  //                         },
  //                         child: Obx(() => Container(
  //                               height: 50.w,
  //                               width: double.infinity,
  //                               decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(70.0),
  //                                   color:
  //                                       isCheckingUserNameDuplicated.value == false ? yachtViolet : primaryButtonText),
  //                               child: Center(
  //                                 child: Text(
  //                                   isCheckingUserNameDuplicated.value == false ? '저장하기' : '닉네임 중복 검사 중',
  //                                   style: profileChangeButtonTextStyle.copyWith(
  //                                       color: isCheckingUserNameDuplicated.value == false
  //                                           ? primaryButtonText
  //                                           : primaryButtonBackground),
  //                                 ),
  //                               ),
  //                             )),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Obx(
  //                   () => showSmallSnackBar.value
  //                       ? Positioned(
  //                           top: 40.w,
  //                           child: Align(
  //                             alignment: Alignment(0, 0),
  //                             child: AnimatedContainer(
  //                               duration: Duration(milliseconds: 300),
  //                               constraints: BoxConstraints.loose(
  //                                 Size(double.infinity, 180.w),
  //                               ),
  //                               padding: EdgeInsets.all(12.w),
  //                               color: Colors.white.withOpacity(.8),
  //                               // height: 40.w,
  //                               // width: double.infinity,
  //                               child: Text(
  //                                 smallSnackBarText.value,
  //                                 style: TextStyle(
  //                                   fontSize: 16.w,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       : Container(),
  //                 )
  //               ],
  //             ),
  //           )),
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  // Future<String> getImageUrlFromStorage(String imageUrl) async {
  //   return await _firebaseStorageService.downloadImageURL(imageUrl);
  // }

  // Future getUser() async {
  //   uid = _authService.auth.currentUser!.uid;
  //   // Future.delayed(Duration(seconds: 10)).then((value) async {
  //   userModel(await _firestoreService.getUserModel(uid));
  //   // });
  // }

  // 이런 방식으로 처음 메뉴 들어왔을 때 필요한 데이터들을 받아서 global로 저장해놓고
  // 데이터가 있으면 로컬을, 없으면 서버에서 가져오는 방식
  // 기존에 Statemanagement와 비슷

  Future getTodayAwards() async {}

  // 현재 홈 뷰에 올려야 하는 퀘스트를 모두 가져온 뒤, 각 섹션에 맞게 분류
  Future getAllQuests() async {
    // print('getting all quests');
    allQuests.clear();
    newQuests.clear();
    liveQuests.clear();
    resultQuests.clear();
    allQuests.assignAll(await _questRepository.getQuestForHomeView());

    // allQuests.sort((a, b) => (a.questEndDateTime ?? Timestamp.fromDate(DateTime.now()))
    //     .compareTo(b.questEndDateTime ?? Timestamp.fromDate(DateTime.now())));
    // 분리작업
    DateTime now = DateTime.now();
    allQuests.forEach((element) {
      if (element.selectMode == 'tutorial') {
        newQuests.add(element);
      } else if (element.selectMode == 'survey') {
        newQuests.add(element);
      } else if (element.showHomeDateTime.toDate().isBefore(now) && element.liveStartDateTime.toDate().isAfter(now)) {
        // showHome ~ liveStart: 새로나온 퀘스트
        // print('newq');
        newQuests.add(element);
      } else if (element.liveStartDateTime.toDate().isBefore(now) && element.liveEndDateTime.toDate().isAfter(now)) {
        // liveStart ~ liveEnd: 퀘스트 생중계
        // print('liveq');
        liveQuests.add(element);
      } else if (element.resultDateTime.toDate().isBefore(now) && element.closeHomeDateTime.toDate().isAfter(now)) {
        // result ~ closeHome: 퀘스트 결과보기
        // print('result: ${element.results}');
        // print('result: ${element}');
        resultQuests.add(element);
      } else {}
    });

    // 서베이 테스트용
    // newQuests.add(userSurveyQuestTemplate);
    // print("포함 안 된 quest: $element");

    newQuests.sort((a, b) => (a.questEndDateTime ?? Timestamp.fromDate(DateTime.now()))
        .compareTo(b.questEndDateTime ?? Timestamp.fromDate(DateTime.now())));

    liveQuests.sort((a, b) => (a.liveEndDateTime ?? Timestamp.fromDate(DateTime.now()))
        .compareTo(b.liveEndDateTime ?? Timestamp.fromDate(DateTime.now())));

    resultQuests.sort((a, b) => (a.liveEndDateTime ?? Timestamp.fromDate(DateTime.now()))
        .compareTo(b.liveEndDateTime ?? Timestamp.fromDate(DateTime.now())));
    // print('triggered done');
    // update();

    // print('home view live');
    liveQuests.refresh();
    // print('liveQuests from homeViewModel $liveQuests');
  }

  // 약관, 개인정보처리방침 동의
  Future agreeTerm() async {
    await _firestoreService.stampTermAgree();
  }

  // 유저 광고모델보기 버튼 누르면?
  Future rewardedAdsButtonTap(BuildContext context) async {
    _showRewardedAd(context);
  }

  // rewarded ads
  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdManager.rewardedAdUnitId,
        request: AdRequest(), // 나중에 여기서 아래처럼 특정하여 리퀘스트할 수 있다
        /*
          AdRequest(
            keywords: <String>['foo', 'bar'],
            contentUrl: 'http://foo.com/bar.html',
            nonPersonalizedAds: true,
          );
        */
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('Rewarded Ads loaded.');
            isRewardedAdLoaded(true);
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd(BuildContext context) {
    int currentItem = userModelRx.value!.item.toInt();

    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      rewardedNotLoadDialog(context);
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();

        if (currentItem < userModelRx.value!.item.toInt()) doneAdsGetRawSnackbar();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    // _rewardedAd!.setImmersiveMode(true); // ??
    // _rewardedAd!.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) async {
    //   print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
    //   // 광고 정상적으로 잘 보면 ~
    //   // Navigator.of(context).pop();
    //   await _firestoreService.updateUserItem(1);
    //   await _firestoreService.updateUserRewardedCnt();
    //   // doneAdsGetRawSnackbar();
    //   // doneAdsDialog(tempContext);
    // });

    _rewardedAd!.show(onUserEarnedReward: (adWithoutView, reward) async {
      print('$adWithoutView with reward $RewardItem(${reward.amount}, ${reward.type}');
      await _firestoreService.updateUserItem(1);
      await _firestoreService.updateUserRewardedCnt();
    });
    _rewardedAd = null;
  }
}

// 광고 아직 로드 안됐을 때 다이얼로그
rewardedNotLoadDialog(BuildContext context) {
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
                      correctHeight(35.w, yachtBadgesDialogTitle.fontSize, yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Text(
                  "광고가 아직 로딩되지 않았어요.\n잠시 후 다시 시도해주세요!",
                  textAlign: TextAlign.center,
                  style: yachtBadgesDescriptionDialogTitle,
                ),
                SizedBox(
                  height: correctHeight(25.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
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

// 광고 최대 갯수만큼 봤을 때 다이얼로그
maxRewardedAdsDialog(BuildContext context) {
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
                      correctHeight(35.w, yachtBadgesDialogTitle.fontSize, yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Text(
                  "오늘은 $maxRewardedAds개의 광고를 모두 보셨어요!\n내일 다시 볼 수 있어요!",
                  textAlign: TextAlign.center,
                  style: yachtBadgesDescriptionDialogTitle,
                ),
                SizedBox(
                  height: correctHeight(25.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
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

// 광고 볼지말지 다이얼로그
adsViewDialog(BuildContext context) {
  final MixpanelService _mixpanelService = locator<MixpanelService>();
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: yachtDarkGrey,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            // height: 196.w,
            width: 347.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                                  child: Image.asset('assets/icons/exit.png', color: yachtWhite)),
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
                      correctHeight(35.w, yachtBadgesDialogTitle.fontSize, yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Center(
                  child: Text(
                    '조가비 하나를 얻을 수 있어요.\n광고를 보러갈까요?',
                    textAlign: TextAlign.center,
                    style: yachtBadgesDescriptionDialogTitle,
                  ),
                ),
                SizedBox(
                  height: correctHeight(25.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
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
                        width: 154.5.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: buttonNormal,
                        ),
                        child: Center(
                          child: Text(
                            '다음에 보기',
                            style: yachtDeliveryDialogButtonText.copyWith(color: yachtViolet),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _mixpanelService.mixpanel.track('Ad Watch');
                        Get.find<HomeViewModel>().rewardedAdsButtonTap(context);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 44.w,
                        width: 154.5.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70.0),
                          color: yachtViolet,
                        ),
                        child: Center(
                          child: Text(
                            '광고 보기',
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

doneAdsGetRawSnackbar() {
  Get.rawSnackbar(
    messageText: Center(
      child: Text(
        '조가비 1개 획득 완료!',
        style: snackBarStyle,
      ),
    ),
    snackPosition: SnackPosition.TOP,
    backgroundColor: yachtWhite.withOpacity(.5),
    barBlur: 2,
    duration: const Duration(milliseconds: 1000),
  );
}

// 광고 성공적으로 봤을 때 다이얼로그 -> 위에 스낵바로 수정
doneAdsDialog(BuildContext context) {
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
                  "조가비 1개 획득 완료!",
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
