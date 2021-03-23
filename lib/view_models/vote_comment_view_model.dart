import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/notice_model.dart';
import 'package:yachtOne/models/season_model.dart';
import 'package:yachtOne/models/sharedPreferences_const.dart';
import 'package:yachtOne/services/amplitude_service.dart';
import 'package:yachtOne/services/dialog_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import 'package:yachtOne/services/storage_service.dart';
import 'package:yachtOne/views/constants/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../services/stateManage_service.dart';

import 'package:yachtOne/views/constants/holiday.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../models/user_vote_model.dart';
import '../models/vote_comment_model.dart';
import '../models/vote_comment_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/base_model.dart';

import '../services/adManager_service.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';

class VoteCommentViewModel extends FutureViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DialogService _dialogService = locator<DialogService>();
  final DatabaseService _databaseService = locator<DatabaseService>();
  final StateManageService _stateManageService = locator<StateManageService>();
  final AmplitudeService _amplitudeService = AmplitudeService();
  final StorageService storageService =
      locator<StorageService>(); //for first survey
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  VoteCommentModel voteFeedModel;

  int subVoteIndex;

  DatabaseAddressModel address;
  UserModel user;
  VoteModel vote;
  UserVoteModel userVote;
  SeasonModel seasonInfo;
  String uid;

  VoteModel newVote;
//   UserVoteModel newUserVote;

  // 공지사항용
  List<NoticeModel> noticeModel = [];

  String surveyImageURL; //for first survey
  var theImage; //for first survey
  bool firstSurvey;

  Future getSurveyImage(BuildContext context) async {
    surveyImageURL = await storageService.downloadImageURL('firstSurvey.png');

    theImage = Image.network(surveyImageURL, fit: BoxFit.cover);

    context ?? precacheImage(theImage.image, context);
  }

  Future showEventModal(BuildContext context) {
    return showModalBottomSheet(
        // enableDrag: false,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        // ),
        isScrollControlled: true,
        context: context,
        builder: (context) => Container(
              height: deviceHeight - 100,
              child: Stack(
                // child: Column(
                children: [
                  // Container(
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //       color: Colors.red,
                  //       borderRadius:
                  //           BorderRadius.vertical(top: Radius.circular(25.0))),
                  // ),
                  Container(
                    height: deviceHeight - 100,
                    // height: deviceHeight - 100 - 60,
                    child: theImage,
                  ),
                  Positioned(
                    left: 16,
                    top: deviceHeight - 100 - 50 - 16,
                    child: GestureDetector(
                      onTap: () {
                        // 다시 열지 않기. 쉐어드프리퍼런스 firstSurveyKey 이용해서 true로 해주면됨.
                        _sharedPreferencesService.setSharedPreferencesValue(
                            firstSurveyKey, true);

                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50,
                        width: (deviceWidth - 48) / 2,
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        child: Center(
                          child: Text(
                            '다시 열지 않기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'AppleSDM',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: deviceWidth / 2 + 8,
                    top: deviceHeight - 100 - 50 - 16,
                    child: GestureDetector(
                      onTap: () {
                        // 서베이뷰로 가기.
                      },
                      child: Container(
                        height: 50,
                        width: (deviceWidth - 48) / 2,
                        decoration: BoxDecoration(
                            color: Color(0xFF1EC8CF),
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0))),
                        child: Center(
                          child: Text(
                            '설문하러 가기',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontFamily: 'AppleSDM',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  // 네이티브애즈용
  // static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  //     // testDevices: [""],
  //     // keywords: <String>['foo', 'bar'],
  //     // contentUrl: 'http://foo.com/bar.html',
  //     // childDirected: true,
  //     // nonPersonalizedAds: true,
  //     );

  // NativeAd nativeAd;

  // NativeAd createNativeAd() {
  //   return NativeAd(
  //     adUnitId: AdManager.nativeAdUnitId,
  //     // adUnitId: "ca-app-pub-3940256099942544/3986624511",
  //     factoryId: 'adFactoryExample',
  //     targetingInfo: targetingInfo,
  //     listener: (MobileAdEvent event) {
  //       print("$NativeAd event $event");
  //     },
  //   );
  // }

  VoteCommentViewModel(BuildContext context) {
    // _authService.signOut();

    uid = _authService.auth.currentUser.uid;
    // getUser();

    getSurveyImage(context);
  }

  Future getAllModel(uid) async {
    setBusy(true);
    await _amplitudeService.logCommunityMain(uid);
    if (_stateManageService.appStart) {
      print("App is newly started");
      await _stateManageService.initStateManage(initUid: uid);
    } else {
      print("Checking state from DB");
      if (await _stateManageService.isNeededUpdate()) {
        print("New state");
        await _stateManageService.initStateManage(initUid: uid);
      }
    }

    address = _stateManageService.addressModel;
    user = _stateManageService.userModel;
    // vote = _stateManageService.voteModel;
    userVote = _stateManageService.userVoteModel;
    seasonInfo = _stateManageService.seasonModel;
    // address = await _databaseService.getAddress(uid);
    // user = await _databaseService.getUser(uid);
    vote = await _databaseService.getVotes(address); //예측 참여 수 즉각 업뎃하기 위해
    // userVote = await _databaseService.getUserVote(address);
    // seasonInfo = await _databaseService.getSeasonInfo(address);

    firstSurvey = await _sharedPreferencesService.getSharedPreferencesValue(
        firstSurveyKey, bool);

    setBusy(false);
  }

  Future getNewVote(address) async {
    await _amplitudeService.logOtherDaysCommunity(uid);
    newVote = await _databaseService.getVotes(address);
    print("GETNEWVOTE CALLED");
    notifyListeners();
  }

  // Stream<List<VoteCommentModel>> getPost(DatabaseAddressModel address) {
  //   return _databaseService.getSubVotePostList(address);
  // }

  // Future postComments(
  //   DatabaseAddressModel address,
  //   VoteCommentModel voteCommentModel,
  // ) async {
  //   await _databaseService.postComment(address, voteCommentModel);
  // }

  // Future deleteComment(
  //   DatabaseAddressModel address,
  //   String postUid,
  // ) async {
  //   print("Dialog shown");
  //   var dialogResult = await _dialogService.showDialog(
  //       title: "코멘트 삭제",
  //       description: "해당 코멘트를 정말 삭제하시겠습니까?",
  //       buttonTitle: "Yes",
  //       cancelTitle: "No");

  //   if (dialogResult.confirmed) {
  //     print("user Confirmed");
  //     await _databaseService.deleteComment(address, postUid);
  //   } else {
  //     print("user Not Confirmed");
  //   }
  // }

  // 공지사항용: 퓨쳐
  Future<List<NoticeModel>> getNotice() async {
    // 공지사항용
    noticeModel = await _databaseService.getNotice();
    // print("ARG" + noticeModel[0].navigateArgu[1].toString());
    // noticeModel.add(NoticeModel(
    //   category: '시즌',
    //   textOrNavigateTo: 'winner',
    //   title: '시즌1 우승자가 탄생하였습니다!',
    //   navigateArgu: [],
    //   content: '',
    // ));

    // noticeModel.add(NoticeModel(
    //   category: '시즌',
    //   textOrNavigateTo: 'text',
    //   title:
    //       '시즌1 우승자가 탄생하였습니다!시즌1 우승자가 탄생하였습니다!시즌1 우승자가 탄생하였습니다!시즌1 우승자가 탄생하였습니다!시즌1 우승자가 탄생하였습니다!시즌1 우승자가 탄생하였습니다!',
    //   navigateArgu: [],
    //   content: '그렇습니다',
    // ));

    //isActived 가 true 인 애들만 돌려준다.
    List<NoticeModel> tempNoticeModel = [];

    for (int i = 0; i < noticeModel.length; i++) {
      if (noticeModel[i].isActived) {
        tempNoticeModel.add(noticeModel[i]);
      }
    }

    return tempNoticeModel;
  }

  @override
  Future futureToRun() => getAllModel(uid);
}
