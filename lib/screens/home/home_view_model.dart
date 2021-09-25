import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:yachtOne/models/dictionary_model.dart';
import 'package:yachtOne/models/quest_model.dart';
import 'package:yachtOne/models/users/user_model.dart';
import 'package:yachtOne/repositories/quest_repository.dart';
import 'package:yachtOne/repositories/repository.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/firestore_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/styles/yacht_design_system.dart';

import '../../services/adManager_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../locator.dart';

const int maxRewardedAds = 10; // 하루 최대 10개 광고 볼 수 있음. (나중에 DB로?)
const int maxFailedLoadAttempts = 5; // 광고로딩실패하면 5번까지는 계속 로딩 시도

class HomeViewModel extends GetxController {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authService = locator<AuthService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  QuestRepository _questRepository = QuestRepository();
  QuestModel? tempQuestModel;
  // 시즌 내에 모든 퀘스트 받아서 RxList에 저장
  final allQuests = <QuestModel>[].obs;

  final newQuests = <QuestModel>[].obs;
  final liveQuests = <QuestModel>[].obs;
  final resultQuests = <QuestModel>[].obs;

  final dictionaries = <DictionaryModel>[].obs;

  late final String uid;
  Rxn<UserModel> userModel = Rxn<UserModel>();

  late String globalString;
  bool isLoading = true;
  RxBool isQuestDataLoading = true.obs;
  RxBool checkIfFirstTime = false.obs;

  //rewardedAds 관련
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  @override
  void onInit() async {
    // TODO: implement onInit

    await getAllQuests();
    await getDictionaries();

    isLoading = false;

    _createRewardedAd();

    super.onInit();
  }

  Future getDictionaries() async {
    dictionaries(await _firestoreService.getDictionaries());
  }

  Future<String> getImageUrlFromStorage(String imageUrl) async {
    return await _firebaseStorageService.downloadImageURL(imageUrl);
  }

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
    allQuests.assignAll(await _questRepository.getQuestForHomeView());
    // 분리작업
    DateTime now = DateTime.now();
    allQuests.forEach((element) {
      if (element.selectMode == 'survey') {
        newQuests.add(element);
      } else if (element.showHomeDateTime.toDate().isBefore(now) &&
          element.liveStartDateTime.toDate().isAfter(now)) {
        // showHome ~ liveStart: 새로나온 퀘스트
        newQuests.add(element);
      } else if (element.liveStartDateTime.toDate().isBefore(now) &&
          element.liveEndDateTime.toDate().isAfter(now)) {
        // liveStart ~ liveEnd: 퀘스트 생중계

        liveQuests.add(element);
      } else if (element.resultDateTime.toDate().isBefore(now) &&
          element.closeHomeDateTime.toDate().isAfter(now)) {
        // result ~ closeHome: 퀘스트 결과보기
        print('result: ${element.results}');
        print('result: ${element}');
        resultQuests.add(element);
      } else {
        print("포함 안 된 quest: $element");
      }
    });
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
      await _firestoreService.updateUserItem(1);
      await _firestoreService.updateUserRewardedCnt();
      doneAdsGetRawSnackbar();
      // Navigator.of(context).pop();
      // doneAdsDialog(context);
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
// doneAdsDialog(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: primaryBackgroundColor,
//           insetPadding: EdgeInsets.only(left: 14.w, right: 14.w),
//           clipBehavior: Clip.hardEdge,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
//           child: Container(
//             height: 196.w,
//             width: 347.w,
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 21.w,
//                     ),
//                     SizedBox(
//                         height: 15.w,
//                         width: 15.w,
//                         child: Image.asset('assets/icons/exit.png',
//                             color: Colors.transparent)),
//                     Spacer(),
//                     Column(
//                       children: [
//                         SizedBox(
//                           height: 15.w,
//                         ),
//                         Text('알림',
//                             style:
//                                 yachtBadgesDialogTitle.copyWith(fontSize: 16.w))
//                       ],
//                     ),
//                     Spacer(),
//                     GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Row(
//                         children: [
//                           Column(
//                             children: [
//                               SizedBox(
//                                 height: 15.w,
//                               ),
//                               SizedBox(
//                                   height: 15.w,
//                                   width: 15.w,
//                                   child: Image.asset('assets/icons/exit.png',
//                                       color: yachtBlack)),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 30.w,
//                             width: 21.w,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: correctHeight(48.w, yachtBadgesDialogTitle.fontSize,
//                       yachtBadgesDescriptionDialogTitle.fontSize),
//                 ),
//                 Text(
//                   "조가비 1개 획득 완료!",
//                   textAlign: TextAlign.center,
//                   style: yachtBadgesDescriptionDialogTitle,
//                 ),
//                 SizedBox(
//                   height: correctHeight(
//                       37.w, yachtBadgesDescriptionDialogTitle.fontSize, 0.w),
//                 ),
//                 Row(
//                   children: [
//                     SizedBox(
//                       width: 14.w,
//                     ),
//                     GestureDetector(
//                       behavior: HitTestBehavior.opaque,
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       },
//                       child: Container(
//                         height: 44.w,
//                         width: 319.w,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(70.0),
//                           color: yachtViolet,
//                         ),
//                         child: Center(
//                           child: Text(
//                             '확인',
//                             style: yachtDeliveryDialogButtonText,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 14.w,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 14.w,
//                 ),
//               ],
//             ),
//           ),
//         );
//       });
// }
