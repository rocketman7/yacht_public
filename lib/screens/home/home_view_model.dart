import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/dictionary_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/repositories/quest_repository.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/screens/auth/email_verification_wating_view.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/mixpanel_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../services/adManager_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../locator.dart';

const int maxRewardedAds = 10; // 하루 최대 10개 광고 볼 수 있음. (나중에 DB로?)
const int maxFailedLoadAttempts = 10; // 광고로딩실패하면 10번까지는 계속 로딩 시도

class HomeViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService authService = locator<AuthService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();
  final MixpanelService _mixpanelService = locator<MixpanelService>();
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
  int _numRewardedLoadAttempts = 0;
  ScrollController scrollController = ScrollController(initialScrollOffset: 0);

  final GlobalKey<FormState> userNameFormKey = GlobalKey<FormState>();
  final TextEditingController userNameController =
      TextEditingController(text: "");
  final RxBool isCheckingUserNameDuplicated = false.obs;
  final RxBool noNeedShowUserNameDialog = true.obs;
  final RxBool showSmallSnackBar = false.obs;
  final RxString smallSnackBarText = "".obs;
  bool onceInit = false;

  @override
  void onInit() async {
    print('uid to identify: ${userModelRx.value!.uid}');
    _mixpanelService.mixpanel.identify(userModelRx.value!.uid);
    // print('home view model start');
    _mixpanelService.mixpanel.flush();
    // TODO: implement onInit
    isLoading(true);
    await getAllQuests();

    await _firestoreService.stampLastLogin();

    // print(_authService.auth.currentUser!.email);
    if (authService.auth.currentUser!.email != null) {
      print(
          'email login method:${await authService.auth.fetchSignInMethodsForEmail(authService.auth.currentUser!.email!)}');
      List<String> methodList = await authService.auth
          .fetchSignInMethodsForEmail(authService.auth.currentUser!.email!);
      if (methodList.length > 0) {
        if (methodList.first == 'password' &&
            !authService.auth.currentUser!.emailVerified) {
          Get.to(() => EmailVerificationWaitingView());
        }
      }
    }

    isLoading(false);

    _createRewardedAd();
    if (userModelRx.value != null) {
      // print('usermodel name update' + userModelRx.value!.isNameUpdated.toString());
      noNeedShowUserNameDialog(userModelRx.value!.isNameUpdated ?? false);
      // print(noNeedShowUserNameDialog.value);
      noNeedShowUserNameDialog.refresh();
      // print(noNeedShowUserNameDialog.value);
    }

    super.onInit();
  }

  Future<bool> isUserNameDuplicated(String userName) async {
    return await _firestoreService.isUserNameDuplicated(userName);
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
      //   backgroundColor: white.withOpacity(.5),
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
  //           padding: primaryHorizontalPadding,
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
  //                             //   backgroundColor: white.withOpacity(.5),
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
  //                                 //   backgroundColor: white.withOpacity(.5),
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
    allQuests.clear();
    newQuests.clear();
    liveQuests.clear();
    resultQuests.clear();
    allQuests.assignAll(await _questRepository.getQuestForHomeView());
    // 분리작업
    DateTime now = DateTime.now();
    allQuests.forEach((element) {
      if (element.selectMode == 'tutorial') {
        newQuests.add(element);
      } else if (element.selectMode == 'survey') {
        // print('surv');
        newQuests.add(element);
      } else if (element.showHomeDateTime.toDate().isBefore(now) &&
          element.liveStartDateTime.toDate().isAfter(now)) {
        // showHome ~ liveStart: 새로나온 퀘스트
        // print('newq');
        newQuests.add(element);
      } else if (element.liveStartDateTime.toDate().isBefore(now) &&
          element.liveEndDateTime.toDate().isAfter(now)) {
        // liveStart ~ liveEnd: 퀘스트 생중계
        // print('liveq');
        liveQuests.add(element);
      } else if (element.resultDateTime.toDate().isBefore(now) &&
          element.closeHomeDateTime.toDate().isAfter(now)) {
        // result ~ closeHome: 퀘스트 결과보기
        // print('result: ${element.results}');
        // print('result: ${element}');
        resultQuests.add(element);
      } else {
        // print("포함 안 된 quest: $element");
      }
    });
    // print('triggered done');
    update();
    // print('home view live');
    // print(liveQuests);
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
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
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
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();

        if (currentItem < userModelRx.value!.item.toInt())
          doneAdsGetRawSnackbar();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    // _rewardedAd!.setImmersiveMode(true); // ??
    _rewardedAd!.show(
        onUserEarnedReward: (RewardedAd ad, RewardItem reward) async {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
      // 광고 정상적으로 잘 보면 ~
      // Navigator.of(context).pop();
      await _firestoreService.updateUserItem(1);
      await _firestoreService.updateUserRewardedCnt();
      // doneAdsGetRawSnackbar();
      // doneAdsDialog(tempContext);
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.w,
                        ),
                        Text('알림',
                            style:
                                yachtBadgesDialogTitle.copyWith(fontSize: 16.w))
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
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
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
                  height: correctHeight(35.w, yachtBadgesDialogTitle.fontSize,
                      yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Text(
                  "광고가 아직 로딩되지 않았어요.\n잠시 후 다시 시도해주세요!",
                  textAlign: TextAlign.center,
                  style: yachtBadgesDescriptionDialogTitle,
                ),
                SizedBox(
                  height: correctHeight(
                      25.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.w,
                        ),
                        Text('알림',
                            style:
                                yachtBadgesDialogTitle.copyWith(fontSize: 16.w))
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
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
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
                  height: correctHeight(35.w, yachtBadgesDialogTitle.fontSize,
                      yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Text(
                  "오늘은 $maxRewardedAds개의 광고를 모두 보셨어요!\n내일 다시 볼 수 있어요!",
                  textAlign: TextAlign.center,
                  style: yachtBadgesDescriptionDialogTitle,
                ),
                SizedBox(
                  height: correctHeight(
                      25.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
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
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: primaryBackgroundColor,
          insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
          clipBehavior: Clip.hardEdge,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.w,
                        ),
                        Text('알림',
                            style:
                                yachtBadgesDialogTitle.copyWith(fontSize: 16.w))
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
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
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
                  height: correctHeight(35.w, yachtBadgesDialogTitle.fontSize,
                      yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Center(
                  child: Text(
                    '조가비 하나를 얻을 수 있어요.\n광고를 보러갈까요?',
                    textAlign: TextAlign.center,
                    style: yachtBadgesDescriptionDialogTitle,
                  ),
                ),
                SizedBox(
                  height: correctHeight(
                      25.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 14.w,
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
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
                      width: 10.w,
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
                            style: yachtDeliveryDialogButtonText.copyWith(
                                color: yachtViolet),
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
    backgroundColor: white.withOpacity(.5),
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
                        child: Image.asset('assets/icons/exit.png',
                            color: Colors.transparent)),
                    Spacer(),
                    Column(
                      children: [
                        SizedBox(
                          height: 15.w,
                        ),
                        Text('알림',
                            style:
                                yachtBadgesDialogTitle.copyWith(fontSize: 16.w))
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
                                  child: Image.asset('assets/icons/exit.png',
                                      color: yachtBlack)),
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
                  height: correctHeight(48.w, yachtBadgesDialogTitle.fontSize,
                      yachtBadgesDescriptionDialogTitle.fontSize),
                ),
                Text(
                  "조가비 1개 획득 완료!",
                  textAlign: TextAlign.center,
                  style: yachtBadgesDescriptionDialogTitle,
                ),
                SizedBox(
                  height: correctHeight(
                      37.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
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
