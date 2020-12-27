import 'dart:async';
import 'dart:io';

import 'package:align_positioned/align_positioned.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/custom_target_position.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yachtOne/models/sharedPreferences_const.dart';
import 'package:yachtOne/services/amplitude_service.dart';
import 'package:yachtOne/services/connection_check_service.dart';
import 'package:yachtOne/services/sharedPreferences_service.dart';
import 'package:yachtOne/services/timezone_service.dart';
import 'package:yachtOne/view_models/top_container_view_model.dart';
import 'package:yachtOne/views/winner_view.dart';
import '../views/widgets/customized_circular_check_box/customized_circular_check_box.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:stacked/stacked.dart';
import 'package:bubble/bubble.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/price_model.dart';
import 'package:yachtOne/models/temp_address_constant.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/services/dialog_service.dart';
import 'package:yachtOne/views/mypage_main_view.dart';
import 'package:yachtOne/views/temp_not_voting_view.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../views/widgets/avatar_widget.dart';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/identify.dart';

import '../locator.dart';
import '../models/user_model.dart';
import '../models/vote_model.dart';
import '../services/navigation_service.dart';
import '../view_models/vote_select_view_model.dart';
import '../views/constants/size.dart';
import '../views/loading_view.dart';
import '../views/widgets/navigation_bars_widget.dart';
import '../views/widgets/vote_card_widget.dart';
import '../views/widgets/vote_selected_widget.dart';
import 'chart_view.dart';

import '../services/adManager_service.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:flutter/cupertino.dart';
import 'package:confetti/confetti.dart';

import 'constants/holiday.dart';

class VoteSelectV2View extends StatefulWidget {
  @override
  _VoteSelectV2ViewState createState() => _VoteSelectV2ViewState();
}

class _VoteSelectV2ViewState extends State<VoteSelectV2View>
    with SingleTickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final VoteSelectViewModel _viewModel = VoteSelectViewModel();
  final TimezoneService _timezoneService = locator<TimezoneService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String uid;

  // PreloadPageController _preloadPageController = PreloadPageController();
  ConfettiController _confettiController;
  // double leftContainer = 0;

  // 최종 선택한 주제 index
  List<int> listSelected = [];
  List<String> timeLeftArr = ["", "", ""]; // 시간, 분, 초 array

  Timer _timer;

  DateTime _now;
  var stringDate = DateFormat("yyyyMMdd");
  var stringDateWithDash = DateFormat("yyy기y-MM-dd");
  String _nowToStr;

  bool isDisposed = false;
  bool isVoteAvailable;

  int numSelected = 0;
  bool canSelect = true;

  bool showMyVote = false;
  //애니메이션은 천천히 생각해보자.

  //튜토리얼 관련된 애들
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targetsIsVoting = List();
  List<TargetFocus> targetsIsNotVoting = List();

  GlobalKey tutorialKey1 = GlobalKey();
  GlobalKey tutorialKey2 = GlobalKey();
  GlobalKey tutorialKey3 = GlobalKey();
  GlobalKey tutorialKey4 = GlobalKey();
  GlobalKey tutorialKey5 = GlobalKey();
  GlobalKey tutorialKey6 = GlobalKey();

  void initTutorialTargetsIsVoting() {
    // 여기서 튜토리얼 설명, ui 들을 설정
    targetsIsVoting.add(TargetFocus(
        identify: 'tutorial target 1',
        keyTarget: tutorialKey1,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('우승 달성까지 남은 점수는?',
                        style: TextStyle(
                            fontFamily: 'AppleSDB',
                            color: Colors.white,
                            fontSize: 28.0)),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            '가장 먼저 우승 승점에 도달하는 유저가 우승 상금을 차지합니다!\n경쟁자들을 제치고 우승에 도달하기 위해 남은 승점은 몇 점일까요?\n',
                            style: TextStyle(
                                fontFamily: 'AppleSDM',
                                color: Colors.white,
                                fontSize: 18.0))),
                  ],
                ),
              ))
        ],
        enableOverlayTab: true,
        color: Colors.purple,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        paddingFocus: 10.0));
    targetsIsVoting.add(TargetFocus(
        identify: 'tutorial target 2',
        keyTarget: tutorialKey2,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이번 시즌 우승 상금입니다!',
                        style: TextStyle(
                            fontFamily: 'AppleSDB',
                            color: Colors.white,
                            fontSize: 28.0)),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            '꾸욱의 우승 상금은 주식입니다! (중복 우승자가 나오면, 상금 주식을 나눠 갖습니다.)\n우승 상금을 눌러 이번 시즌 상금 포트폴리오를 확인하세요!',
                            style: TextStyle(
                                fontFamily: 'AppleSDM',
                                color: Colors.white,
                                fontSize: 18.0))),
                  ],
                ),
              ))
        ],
        enableOverlayTab: true,
        color: Colors.blue,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        paddingFocus: -5.0));
    targetsIsVoting.add(TargetFocus(
        identify: 'tutorial target 3',
        keyTarget: tutorialKey3,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('종목 이름을 눌러보세요!',
                        style: TextStyle(
                            fontFamily: 'AppleSDB',
                            color: Colors.white,
                            fontSize: 28.0)),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            '종목 이름을 누르면 차트와 함께 자세한 설명을 볼 수 있어요.\n매일 바뀌는 꾸욱 예측 주제를 통해 다양한 종목을 알아보세요! ',
                            style: TextStyle(
                                fontFamily: 'AppleSDM',
                                color: Colors.white,
                                fontSize: 18.0))),
                  ],
                ),
              ))
        ],
        enableOverlayTab: true,
        color: Colors.green,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        paddingFocus: 10.0));
    targetsIsVoting.add(TargetFocus(
        identify: 'tutorial target 4',
        keyTarget: tutorialKey4,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('주제를 선택하세요!',
                        style: TextStyle(
                            fontFamily: 'AppleSDB',
                            color: Colors.white,
                            fontSize: 28.0)),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            '오늘 예측할 주제를 선택하세요.\n하루 최대 3개의 주제를 선택할 수 있어요.\n(한 주제당 꾸욱 아이템 1개가 소모됩니다)',
                            style: TextStyle(
                                fontFamily: 'AppleSDM',
                                color: Colors.white,
                                fontSize: 18.0))),
                  ],
                ),
              )),
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('각 주제마다 예측에 성공하면 승점 +2점,\n실패하면 승점 -1점!',
                        style: TextStyle(
                            fontFamily: 'AppleSDM',
                            color: Colors.white,
                            fontSize: 18.0)),
                  ],
                ),
              ))
        ],
        enableOverlayTab: true,
        color: Colors.red,
        shape: ShapeLightFocus.Circle,
        radius: 5,
        paddingFocus: 5.0));
    targetsIsVoting.add(TargetFocus(
        identify: 'tutorial target 5',
        keyTarget: tutorialKey5,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('꾸욱 아이템',
                        style: TextStyle(
                            fontFamily: 'AppleSDB',
                            color: Colors.black,
                            fontSize: 28.0)),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            '예측에 필요한 꾸욱 아이템입니다.\n광고를 보면 하루에 최대 5개의 꾸욱 아이템을 얻을 수 있어요!',
                            style: TextStyle(
                                fontFamily: 'AppleSDM',
                                color: Colors.black,
                                fontSize: 18.0))),
                  ],
                ),
              ))
        ],
        enableOverlayTab: true,
        color: Colors.amber,
        shape: ShapeLightFocus.RRect,
        radius: 5,
        paddingFocus: 5.0));
    targetsIsVoting.add(TargetFocus(
        identify: 'tutorial target 6',
        keyTarget: tutorialKey6,
        contents: [
          ContentTarget(
              align: AlignContent.left,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('마이페이지',
                        style: TextStyle(
                            fontFamily: 'AppleSDB',
                            color: Colors.white,
                            fontSize: 28.0)),
                    Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            '마이페이지에서 친구에게 \'꾸욱\'을 추천하고 꾸욱 아이템을 받아가세요!\n또, 닉네임을 설정하거나 상금주식을 받기 위한 계좌 정보 등을 입력할 수 있어요.',
                            style: TextStyle(
                                fontFamily: 'AppleSDM',
                                color: Colors.white,
                                fontSize: 18.0))),
                  ],
                ),
              ))
        ],
        enableOverlayTab: true,
        color: Colors.black,
        shape: ShapeLightFocus.Circle,
        radius: 5,
        paddingFocus: 5.0));
  }

  void initTutorialTargetsIsNotVoting() {
    // 여기서 튜토리얼 설명, ui 들을 설정 (장 중일 때)
    targetsIsNotVoting.add(targetsIsVoting[0]);
    targetsIsNotVoting.add(targetsIsVoting[1]);
    targetsIsNotVoting.add(targetsIsVoting[2]);
    targetsIsNotVoting.add(targetsIsVoting[4]);
    targetsIsNotVoting.add(targetsIsVoting[5]);
  }

  void showTutorialIsVoting() {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targetsIsVoting,
        colorShadow: Colors.purple,
        textSkip: "도움말 종료하기",
        opacityShadow: 0.95, onFinish: () {
      print("finish");
      _sharedPreferencesService.setSharedPreferencesValue(
          voteSelectTutorialKey, true);
      renewTutorialKey();
    }, onClickSkip: () async {
      print("skip");
      _sharedPreferencesService.setSharedPreferencesValue(
          voteSelectTutorialKey, true);
      renewTutorialKey();
    })
      ..show();
  }

  void _afterLayoutIsVoting(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorialIsVoting();
    });
  }

  void showTutorialIsNotVoting() {
    tutorialCoachMark = TutorialCoachMark(context,
        targets: targetsIsNotVoting,
        textSkip: "도움말 종료하기",
        opacityShadow: 0.95, onFinish: () {
      print("finish");
      _sharedPreferencesService.setSharedPreferencesValue(
          voteSelectTutorialKey, true);
      renewTutorialKey();
    }, onClickSkip: () {
      print("skip");
      _sharedPreferencesService.setSharedPreferencesValue(
          voteSelectTutorialKey, true);
      renewTutorialKey();
    })
      ..show();
  }

  void _afterLayoutIsNotVoting(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorialIsNotVoting();
    });
  }

  bool tutorialKeyCheck = false;
  Future<void> renewTutorialKey() async {
    tutorialKeyCheck = await _sharedPreferencesService
        .getSharedPreferencesValue(voteSelectTutorialKey, bool);
  }
  // voteData를 가져와 voteTodayCard에 넣어 위젯 리스트를 만드는 함수
  // void getVoteTodayWidget(VoteModel votesToday) {
  //   List<Widget> listItems = [];
  //   print("getVOteTodayWIdget making " + votesToday.subVotes[0].id.toString());
  //   for (var i = 0; i < votesToday.subVotes.length; i++) {
  //     // print(votesFromDB.subVotes.length);
  //     listItems.add(VoteCard(i, votesToday));
  //   }
  //   print("forloop done");
  //   if (!isDisposed) {
  //     if (this.mounted) {
  //       setState(() {
  //         print("setstate done");
  //         _votesTodayShowing = listItems;
  //       });
  //     }
  //   }
  // }

  // void getVoteSelectedWidget(VoteModel votesToday) {
  //   List<Widget> listItems = [];
  //   for (var i = 0; i < votesToday.subVotes.length; i++) {
  //     listItems.add(VoteSelected(i, votesToday));
  //   }
  //   print("forloop2 done");
  //   setState(() {
  //     _votesSelectedNotShowing = listItems;
  //   });
  // }

  // Future<Duration> getTimeLeft(VoteSelectViewModel model) async {
  //   DateTime endTime = model.vote.voteEndDateTime.toDate();
  //   _now = await NTP.now();
  //   return endTime.difference(_now);
  //   // timeLeftArr = diffFinal.split(":");
  //   // return diffFinal;
  // }

  bool isVoting = true;
  void checkVoteTime() {
    print("THIS VOID CALLED");
    setState(() {
      bool isVoting = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  FToast fToast;

  _showToast(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 25,
            height: 25,
            padding: EdgeInsets.all(4),
            // decoration: BoxDecoration(
            //     borderRadius: BorderRadius.all(
            //         Radius.circular(100.0)),
            //     color: Color(0xFF1EC8CF),
            //     border: Border.all(
            //         color: Colors.white,
            //         width: 2)),
            child: SvgPicture.asset(
              'assets/icons/dog_foot.svg',
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 18.sp,
                fontFamily: 'AppleSDB',
                // fontWeight: FontWeight.w600,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(
        seconds: 1,
        milliseconds: 200,
      ),
    );

    // Custom Toast Position
    // fToast.showToast(
    //     child: toast,
    //     toastDuration: Duration(seconds: 2),
    //     positionedToastBuilder: (context, child) {
    //       return Positioned(
    //         child: child,
    //         top: 16.0,
    //         left: 16.0,
    //       );
    // });
  }

  // 위젯 생성 함수와 PageController의 리스터를 이니셜라이징
  // controller의 offset 수치를 listen하여 수식을 통해 value를 계산하고
  // setState로 반영하여 계속 리빌드 시킨다
  @override
  void initState() {
    initTutorialTargetsIsVoting();
    // WidgetsBinding.instance.addPostFrameCallback(_afterLayoutIsVoting);

    initTutorialTargetsIsNotVoting();
    // WidgetsBinding.instance.addPostFrameCallback(_afterLayoutIsNotVoting);
    renewTutorialKey();
    super.initState();
    // BackButtonInterceptor.add(myInterceptor);
    // _connectionCheckService.checkConnection(context);
    try {
      callRemoteConfig(context);
    } catch (e) {
      print(e);
    }
    try {
      if (Platform.isIOS) {
        checkIfAgreeTerms(context);
      }
    } catch (e) {
      print(e);
    }

    fToast = FToast();
    fToast.init(context);
    print("initState Called");

    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 3600),
    //   vsync: this,
    // );

    // animation =
    //     ColorTween(begin: Colors.blue, end: Colors.red).animate(_controller)
    //       ..addListener(() {
    //         setState(() {});
    //       });

    // _controller.repeat();

    // _getAllModel = _viewModel.getAllModel(_viewModel.uid);
    // 현재 시간 한국 시간으로 변경
    // _now = DateTime.now().toUtc().add(Duration(hours: 9));
    // _nowToStr = stringDate.format(_now);
    // _nowToStr = "20200901"; //temp for test

    // print(_now.toString() + " and " + _nowToStr);
    // print(_getAllModel);
    // 오늘의 주제, 선택된 주제 위젯 만들기 위해 initState에 vote 데이터 db에서 불러옴
    // print("Async start");

    // defines a timer
    // _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   setState(() {});
    // });

    //get this user's UserModel
    // _userModelFuture = _model.getUser(widget.uid);
    print("initState Done");
  }

  String app_store_url;
  String play_store_url;
  bool isSeasonStarted = true;
  bool isUrgentNotice = false;
  String urgentMessage = "";
  bool termsOfUse;
  String defaultMainText;
  bool isShowWinners = false;
  String newSeasonStart;

  checkIfAgreeTerms(context) async {
    termsOfUse = await _sharedPreferencesService.getSharedPreferencesValue(
        termsOfUseKey, bool);
    if (termsOfUse == false) {
      _showTermsDialog(context);
    }
  }

  _showTermsDialog(context) async {
    Future<String> _termsOfUseFuture() async {
      return await rootBundle.loadString('assets/documents/termsOfUse.txt');
    }

    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "서비스를 이용하기 위해\n아래에 대한 동의가 필요합니다.";
        String message = "꾸욱을 계속 이용하기 위해서 업데이트가 필요합니다. 감사합니다.";
        String btnLabel = "수락";
        String btnLabelCancel = "거부";
        String _termsOfUse;
        ;
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: WillPopScope(
              onWillPop: () {},
              child: CupertinoAlertDialog(
                title: Text(title),
                content: FutureBuilder(
                    future: _termsOfUseFuture(),
                    builder: (context, snapshot) {
                      _termsOfUse = snapshot.data;
                      if (snapshot.hasData) {
                        return Container(
                          height: 400,
                          width: 180,
                          child: SingleChildScrollView(
                              child: Text(
                            _termsOfUse,
                            textAlign: TextAlign.left,
                          )),
                        );
                      } else {
                        return Container(
                          height: 200,
                          width: 100,
                        );
                      }
                    }),
                actions: <Widget>[
                  FlatButton(
                    child: Text(btnLabelCancel),
                    onPressed: () => exit(0),
                  ),
                  CupertinoDialogAction(
                    child: Text(btnLabel),
                    onPressed: () {
                      _sharedPreferencesService.setSharedPreferencesValue(
                          termsOfUseKey, true);
                      Navigator.pop(context);
                    },
                  ),
                ],
              )),
        );
      },
    );
  }

  callRemoteConfig(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));
    print("CURRENT VERSION IS " + currentVersion.toString());

    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      // remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));

      app_store_url = remoteConfig.getString('app_store_url');
      play_store_url = remoteConfig.getString('play_store_url');

      newSeasonStart = remoteConfig.getString('new_season_start');
      // 주석 풀고 업데이트 //예측하러 가기 활성or비활성화
      // isSeasonStarted = remoteConfig.getBool('is_season_started');

      isUrgentNotice = remoteConfig.getBool('is_urgent_notice');
      urgentMessage = remoteConfig.getString('urgent_message');

      isShowWinners = remoteConfig.getBool('show_winners');
      // 홈 기본 텍스트 불러오기

      // defaultMainText = remoteConfig.getString('default_main_text');

      print("NEW VERSION IS" + newVersion.toString());
      print("APP STORE URL " + app_store_url);
      print("PLAY STORE URL " + play_store_url);
      print("IS SEASON STARTED " + isSeasonStarted.toString());

      // print("Main Text " + defaultMainText.toString());
      // if (true) {
      if (isUrgentNotice) {
        _showUrgentDialog(context);
      }

      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
      _confettiController =
          ConfettiController(duration: const Duration(milliseconds: 1200));

      // if (true) {
      if (isShowWinners) {
        showWinnerDialog(context);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  showWinnerDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          _confettiController.play();
          Future.delayed(Duration(milliseconds: 400))
              .then((value) => _confettiController.stop());
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                    height: 330,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: ConfettiWidget(
                                  confettiController: _confettiController,
                                  blastDirectionality: BlastDirectionality
                                      .explosive, // don't specify a direction, blast randomly
                                  emissionFrequency: 1,
                                  minimumSize: const Size(10, 10),
                                  maximumSize: const Size(30, 30),
                                  numberOfParticles: 12,
                                  gravity: .08,
                                  shouldLoop:
                                      true, // start again as soon as the animation is finished
                                  colors: const [
                                    Colors.green,
                                    Colors.blue,
                                    Colors.pink,
                                    Colors.orange,
                                    Colors.purple
                                  ], // manually specify the colors to be used
                                ),
                              ),
                              Text(
                                "꾸욱 시즌 1 우승자 탄생!",
                                style: TextStyle(
                                    fontSize: 24, fontFamily: 'AppleSDEB'),
                              ),
                              SizedBox(height: 8),
                              AutoSizeText(
                                "꾸욱 첫 시즌에 참여해주신 여러분,\n진심으로 감사합니다.\n치열했던 시즌 1의 최종 우승자와\n깜짝 특별상을 확인해보세요!",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'AppleSDM',
                                ),
                                maxLines: 4,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 16),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: newSeasonStart == null
                                        ? "시즌 1 종료일 다음날" + " 오후 4시"
                                        : newSeasonStart + "오후 4시",
                                    style: TextStyle(
                                      fontFamily: 'AppleSDM',
                                      color: Colors.red,
                                      fontSize: 17,
                                      //  fontFamily: 'AppleSDM',
                                      // fontWeight: FontWeight.bold,
                                      // letterSpacing: -.5,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "부터 더욱 커진 상금 주식과 함께",
                                          style: TextStyle(
                                            fontFamily: 'AppleSDM',
                                            color: Colors.black,
                                            fontSize: 17,
                                            //  fontFamily: 'AppleSDM',
                                            // fontWeight: FontWeight.bold,
                                            // letterSpacing: -.5,
                                          )),
                                      TextSpan(
                                        text: " 시즌 2",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: 'AppleSDM',
                                            color: Colors.deepPurple),
                                      ),
                                      TextSpan(
                                          text: "를 시작합니다!",
                                          style: TextStyle(
                                            fontFamily: 'AppleSDM',
                                            color: Colors.black,
                                            fontSize: 17,
                                            //  fontFamily: 'AppleSDM',
                                            // fontWeight: FontWeight.bold,
                                            // letterSpacing: -.5,
                                          )),
                                    ]),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              void popAndNavigate(_) {
                                Future.delayed(Duration(milliseconds: 100), () {
                                  Navigator.pop(context);
                                  _navigationService.navigateTo('winner');
                                });
                              }

                              WidgetsBinding.instance
                                  .addPostFrameCallback(popAndNavigate);
                              // Navigator.pop(context);
                              // _navigationService.navigateTo('winner');
                            },
                            child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                    color: Color(0xFFF43177),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    "시즌 1 결과 보러가기",
                                    style: TextStyle(
                                      fontFamily: 'AppleSDB',
                                      height: 1,
                                      color: Colors.white,
                                      letterSpacing: -1.0,
                                      fontSize: 18,
                                      //  fontFamily: 'AppleSDM',
                                      // fontWeight: FontWeight.bold,
                                      // letterSpacing: -.5,
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    )),
              ));
        });
  }

  Future _showUrgentDialog(context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          VoteSelectViewModel model;
          String title = "긴급점검 중입니다.";
          String content = urgentMessage;
          String okButton = "닫기";
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: WillPopScope(
              onWillPop: () {},
              child: Platform.isIOS
                  ? CupertinoAlertDialog(
                      title: Text(title),
                      content: Text(content),
                      actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text(okButton),
                            onPressed: () => exit(0),
                          ),
                        ])
                  : AlertDialog(
                      title: Text(title),
                      content: Text(content),
                      actions: <Widget>[
                          FlatButton(
                            child: Text(okButton),
                            onPressed: () => exit(0),
                          ),
                        ]),
            ),
          );
        });
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "새 버전이 출시되었습니다";
        String message = "꾸욱을 계속 이용하기 위해서 업데이트가 필요합니다. 감사합니다.";
        String btnLabel = "업데이트하기";
        String btnLabelCancel = "Later";
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: WillPopScope(
            onWillPop: () {},
            child: Platform.isIOS
                ? new CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text(btnLabel),
                        onPressed: () => _launchURL(app_store_url),
                      ),
                      // FlatButton(
                      //   child: Text(btnLabelCancel),
                      //   onPressed: () => Navigator.pop(context),
                      // ),
                    ],
                  )
                : new AlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      FlatButton(
                        child: Row(
                          children: [
                            Text(btnLabel),
                            SizedBox(width: 20),
                          ],
                        ),
                        onPressed: () => _launchURL(play_store_url),
                      ),
                      // FlatButton(
                      //   child: Text(btnLabelCancel),
                      //   onPressed: () => Navigator.pop(context),
                      // ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  AnimationController _controller;
  Animation<Color> animation;

  // final colors = <Tween<Color>>[
  //   ColorTween(begin: Colors.red, end: Colors.blue),

  // TweenSequenceItem(
  //   weight: 1.0,
  //   tween: ColorTween(begin: Colors.blue, end: Colors.green),
  // ),
  // TweenSequenceItem(
  //   weight: 1.0,
  //   tween: ColorTween(begin: Colors.green, end: Colors.yellow),
  // ),
  // TweenSequenceItem(
  //   weight: 1.0,
  //   tween: ColorTween(begin: Colors.yellow, end: Colors.red),
  // ),
  // ];
  @override
  // initState 다음에 호출되는 함수. MediaQuery를 가져오기 위해 initState에 두지 않고 여기에 둠
  void didChangeDependencies() async {
    super.didChangeDependencies();
    print("didChangeCalled");

    // List<Object> list = await _getAllModel;

    // DatabaseAddressModel tempAddress = list[0];
    // VoteModel tempVote = list[2];

    // getVoteTodayWidget(tempVote);
    // getVoteSelectedWidget(tempVote);
    // getTimeLeft(value);

    // final Size size = MediaQuery.of(context).size;
    // double displayRatio = deviceHeight / deviceWidth;

    // _preloadPageController = PreloadPageController(
    //   initialPage: 0,
    //   // 페이지뷰 하나의 크기
    //   viewportFraction: displayRatio > 1.85 ? 0.63 : 0.58,
    //   keepPage: true,
    // );
    // controller.addListener(() {
    //   double value = controller.offset / 250;감

    //   setState(() {
    //     leftContainer = value;
    //   });
    // });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    // _controller.dispose();
    // _connectionCheckService.listener.cancel();
    // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
    // dispose는 Navigator pushNamed에는 호출되지 않지만 백 버튼에는 호출됨.
    // 백 버튼에 아래를 호출하지 않으면 dispose 됐는데 setState한다고 오류뜸
  }

  // list의 데이터를 바꾸고 setState하면 아래 호출될 줄 알았는데 안 됨
  // @override
  // void didUpdateWidget(VoteSelectView oldWidget) {
  //   super.didUpdateWidget(oldWidget);

  //   print("didUpdateWidget Called");
  // }
  // void _settingModalBottomSheet(context, scaffoldKey) {
  //   return scaffoldKey.currentState.showBottomSheet((context) {
  //     return Column(children: [
  //       Text("TT"),
  //     ]);
  //   });
  // }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   print("BACK BUTTON!");
  //   // exit(0); // Do some stuff.
  //   // return true;
  // }

  SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  var formatKoreanDate = DateFormat('MM' + "월" + " " + "dd" + "일");
  DateTime currentBackPressTime;
  Future<bool> _onWillPop() async {
    if (currentBackPressTime == null ||
        DateTime.now().difference(currentBackPressTime) >
            Duration(seconds: 2)) {
      currentBackPressTime = DateTime.now();
      Fluttertoast.showToast(msg: "뒤로 가기를 다시 누르면 앱이 종료됩니다");
      return Future.value(false);
      // return null;
    } else {
      print("TURN OFF");
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("buildCalled");

    // print(numSelected);
    print("numSelected " + numSelected.toString());
    // print(numSelected);
    return ViewModelBuilder<VoteSelectViewModel>.reactive(
      viewModelBuilder: () => VoteSelectViewModel(),
      // initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        // selected = selected.sublist(0, model.vote.subVotes.length);
        // print(selected);
        // print(model.getNow());
        // print(uid + 'from FutureViewModel');
        if (model.isBusy) {
          return Scaffold(
              body: Container(
            height: deviceHeight,
            width: deviceWidth,
            // key: scaffoldKey,
            child: Stack(
              children: [
                Positioned(
                  top: deviceHeight / 2 - 100,
                  child: Container(
                    height: 100,
                    width: deviceWidth,
                    child: FlareActor(
                      'assets/images/Loading.flr',
                      animation: 'loading',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ));
        } else {
          numSelected = model.selected.where((item) => item == true).length;
          print("IS VOTING ?? " + isVoting.toString());

          // Duration diff = getTimeLeft(model).inSeconds < 0
          //     ? Duration(hours: 0, minutes: 0, seconds: 0)
          //     : getTimeLeft(model);
          // String strDurationHM =
          //     "${diff.inHours.toString().padLeft(2, '0')}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:";
          // String strDurationSec =
          //     "${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
          // bool check =  await _sharedPreferencesService
          // .getSharedPreferencesValue(voteSelectTutorialKey, bool);
          print('model.voteSelectTutorial is ...' +
              model.voteSelectTutorial.toString());
          // model.renewTutorialKey();
          // model.notifyListeners();
          print('model.voteSelectTutorial is ...' +
              model.voteSelectTutorial.toString());
          if (!model.voteSelectTutorial && !tutorialKeyCheck) {
            model.address.isVoting
                ? WidgetsBinding.instance
                    .addPostFrameCallback(_afterLayoutIsVoting)
                : WidgetsBinding.instance
                    .addPostFrameCallback(_afterLayoutIsNotVoting);
          }
          return Scaffold(
            backgroundColor:
                // model.address.isVoting ? Color(0xFF1EC8CF) : animation.value,
                model.address.isVoting ? Color(0xFF1EC8CF) : Color(0xFFB90FD0),

            key: _scaffoldKey,
            // endDrawer: myPage(model),
            body: WillPopScope(
              onWillPop: _onWillPop,
              // () async {
              //   // DateTime now = DateTime.now();
              //   print("Back tapped");
              //   onWillPop(context) async {
              //     if (currentBackPressTime == null ||
              //         DateTime.now().difference(currentBackPressTime) >
              //             Duration(seconds: 2)) {
              //       currentBackPressTime = DateTime.now();
              //       Fluttertoast.showToast(msg: "뒤로 가기를 한 번 더 누르면 앱이 종료됩니다");
              //       // return Future.value(false);
              //     } else {
              //       SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              //       return false;
              //     }
              //   }

              //   // _navigatorKey.currentState.maybePop();
              //   return onWillPop(context);
              // },
              child: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            16.w,
                            16.h,
                            16.w,
                            16.h,
                          ),
                          child: Container(
                            // padding: EdgeInsets.only(bottom: 40),
                            // color: Color(0xFF1EC8CF),
                            width: double.infinity,
                            // height: 180.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: [
                                    // 튜토리얼을 다시 불러오는 ? 버튼
                                    GestureDetector(
                                      onTap: () {
                                        // model.tutorialRestart();
                                        model.address.isVoting
                                            ? showTutorialIsVoting()
                                            : showTutorialIsNotVoting();
                                      },
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          // child: Icon(
                                          //   Icons.dehaze_rounded,
                                          //   color: model.address.isVoting
                                          //       ? Colors.black
                                          //       : Color(0xFFDEDEDE),
                                          //   size: 32.sp,
                                          // ),
                                          child: Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black38,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 9.0,
                                                          right: 8.0,
                                                          top: 8.0,
                                                          bottom: 8.0),
                                                  child: Center(
                                                    child: Text('?',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'AppleSDM')),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                // color: Colors.red,
                                                width: 20,
                                                height: 30,
                                              )
                                            ],
                                          )),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      key: tutorialKey6,
                                      onTap: () {
                                        // print('open drawer');
                                        // scaffoldKey.currentState
                                        //     .openEndDrawer();
                                        // Navigator.of(context)
                                        //     .push(_createRoute());
                                        // model.navigateToMypage();
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    MypageMainView()));
                                      },
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Icon(
                                          // Icons.settings_rounded,
                                          // key: keyButton1,
                                          Icons.dehaze_rounded,
                                          color: model.address.isVoting
                                              ? Colors.black.withOpacity(0.7)
                                              : Color(0xFFDEDEDE),
                                          size: 32.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // 트로피 있던 화면
                                // Column(
                                //   children: [
                                //     Container(
                                //       // color: Colors.yellow,
                                //       child: Row(
                                //         // crossAxisAlignment:
                                //         //     CrossAxisAlignment.stretch,
                                //         children: <Widget>[
                                //           Container(
                                //             // color: Colors.red,
                                //             child: Column(
                                //               children: [
                                //                 Image.asset(
                                //                   'assets/icons/trophy.png',
                                //                   // color: Colors.red,
                                //                   height: 70,
                                //                   width: 70,
                                //                 ),
                                //                 Text(
                                //                   "시즌 1",
                                //                   style: TextStyle(
                                //                       fontFamily:
                                //                           'AppleSDL',
                                //                       fontSize: 16,
                                //                       letterSpacing: -1.5),
                                //                 ),
                                //               ],
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             width: 16,
                                //           ),
                                //           Container(
                                //             // color: Colors.red,
                                //             child: Column(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment.start,
                                //               mainAxisSize:
                                //                   MainAxisSize.max,
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 Text(
                                //                   "지금 노릴 수 있는 우승 상금은?",
                                //                   style: TextStyle(
                                //                       fontFamily:
                                //                           'AppleSDL',
                                //                       fontSize: 16,
                                //                       letterSpacing: -1.5),
                                //                 ),
                                //                 SizedBox(height: 12),
                                //                 GestureDetector(
                                //                   onTap: () {
                                //                     _navigationService
                                //                         .navigateTo(
                                //                             'portfolio');
                                //                   },
                                //                   child: Row(
                                //                     children: [
                                //                       Text(
                                //                         '${model.getPortfolioValue()}',
                                //                         style: TextStyle(
                                //                           fontFamily:
                                //                               'DmSans',
                                //                           fontSize: 42,
                                //                           height: 1,
                                //                           fontWeight:
                                //                               FontWeight
                                //                                   .bold,
                                //                         ),
                                //                       ),
                                //                       Text(
                                //                         "원",
                                //                         style: TextStyle(
                                //                           fontFamily:
                                //                               'AppleSDM',
                                //                           fontSize: 24,
                                //                           height: 1,
                                //                           // fontWeight: FontWeight.bold,
                                //                         ),
                                //                       ),
                                //                       Icon(
                                //                         Icons
                                //                             .arrow_forward_ios,
                                //                         // color: Color(0xFFFFF5F5),
                                //                         size: 24.sp,
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //     Align(
                                //       alignment: Alignment.centerRight,
                                //       child: GestureDetector(
                                //         onTap: () {
                                //           _navigationService
                                //               .navigateTo('trackRecord');
                                //         },
                                //         child: Text("나의 예측 기록"),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       height: 28,
                                //     ),
                                //   ],
                                // )

                                SizedBox(
                                  height: 4.h,
                                ),
                                // 새 디자인
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFFDE34),
                                          ),
                                          child: Text(
                                            model.seasonInfo.seasonName,
                                            style: TextStyle(
                                              fontFamily: 'AppleSDB',
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          "지금 노릴 수 있는 우승 상금은?",
                                          // "현재 우승 상금",
                                          style: TextStyle(
                                            fontFamily: 'AppleSDB',
                                            fontSize: 18,
                                            color: model.address.isVoting
                                                ? Colors.black
                                                : Colors.white,
                                            letterSpacing: -.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    GestureDetector(
                                      key: tutorialKey2,
                                      onTap: () {
                                        _navigationService
                                            .navigateTo('portfolio');
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black.withOpacity(0),
                                            size: 30,
                                          ),
                                          Text(
                                            '${model.getPortfolioValue()}',
                                            style: TextStyle(
                                              fontFamily: 'DmSans',
                                              fontSize: 42.sp,
                                              color: model.address.isVoting
                                                  ? Colors.black
                                                  : Colors.white,
                                              // height: 1,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: -1.0,
                                            ),
                                          ),
                                          Text(
                                            "원",
                                            style: TextStyle(
                                              fontFamily: 'AppleSDB',
                                              fontSize: 42.sp,
                                              color: model.address.isVoting
                                                  ? Colors.black
                                                  : Colors.white,
                                              // height: 1,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: model.address.isVoting
                                                ? Colors.black.withOpacity(.7)
                                                : Color(0xFFDEDEDE),
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "우승까지 승점 ${(model.seasonInfo.winningPoint - (model.userVote.userVoteStats.currentWinPoint ?? 0)).toString()}점",
                                      key: tutorialKey1,
                                      style: TextStyle(
                                        fontFamily: 'AppleSDB',
                                        fontSize: 18,
                                        color: model.address.isVoting
                                            ? Colors.black.withOpacity(.6)
                                            : Color(0xFFDEDEDE),
                                        letterSpacing: -.5,
                                      ),
                                    ),
                                    model.seasonInfo.seasonName == "시즌 2"
                                        ? GestureDetector(
                                            onTap: () {
                                              _navigationService
                                                  .navigateTo('winner');
                                            },
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text("지난 시즌 결과",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'AppleSDM')),
                                            ))
                                        : Container(),
                                  ],
                                )

                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: <Widget>[
                                //     Text(
                                //       "상금 가치",
                                //       style: TextStyle(
                                //         fontSize: 20.sp,
                                //         fontFamily: 'AppleSDB',
                                //         letterSpacing: -1.0,
                                //       ),
                                //     ),
                                //     GestureDetector(
                                //       onTap: () {
                                //         _navigationService
                                //             .navigateTo('portfolio');
                                //       },
                                //       child: Row(
                                //         children: <Widget>[
                                //           // Bubble(
                                //           //   shadowColor: Colors.red,
                                //           //   margin: BubbleEdges.only(
                                //           //       top: 10),
                                //           //   nip: BubbleNip.rightTop,
                                //           //   nipWidth: 10,
                                //           //   color: Color(0xFF56A4FF),
                                //           //   child: Text(
                                //           //     "목표 승점에 먼저 도달하면,",
                                //           //     style: TextStyle(
                                //           //       fontSize: 12.sp,
                                //           //       color: Colors.white,
                                //           //       fontFamily:
                                //           //           'AppleSDM',
                                //           //       letterSpacing: -1.0,
                                //           //     ),
                                //           //   ),
                                //           // ),
                                //           // SizedBox(
                                //           //   width: 4.w,
                                //           // ),
                                //           Text(
                                //               '₩ ${model.getPortfolioValue()}',
                                //               style: TextStyle(
                                //                 fontSize: 20.sp,
                                //                 fontFamily: 'AppleSDB',
                                //                 letterSpacing: -1.0,
                                //               )),
                                //           SizedBox(
                                //             width: 8.sp,
                                //           ),
                                //           Icon(
                                //             Icons.arrow_forward_ios,
                                //             size: 16,
                                //           )
                                //         ],
                                //       ),
                                //     )
                                //   ],
                                // ),
                                // SizedBox(
                                //   height: 4.sp,
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     _navigationService.navigateWithArgTo(
                                //         'startup', 2);
                                //   },
                                //   child: Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     children: <Widget>[
                                //       Text(
                                //         "현재 / 목표 승점",
                                //         style: TextStyle(
                                //           fontSize: 20.sp,
                                //           fontFamily: 'AppleSDB',
                                //           letterSpacing: -1.0,
                                //         ),
                                //       ),
                                //       Row(
                                //         children: [
                                //           Text(
                                //             (model.userVote.userVoteStats
                                //                             .currentWinPoint ==
                                //                         null
                                //                     ? 0.toString()
                                //                     : model
                                //                         .userVote
                                //                         .userVoteStats
                                //                         .currentWinPoint
                                //                         .toString()) +
                                //                 "   /   " +
                                //                 (model.seasonInfo == null
                                //                     ? 0.toString()
                                //                     : model.seasonInfo
                                //                         .winningPoint
                                //                         .toString()),
                                //             style: TextStyle(
                                //               fontSize: 20.sp,
                                //               fontFamily: 'AppleSDB',
                                //               letterSpacing: -1.0,
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             width: 8.sp,
                                //           ),
                                //           Icon(
                                //             Icons.arrow_forward_ios,
                                //             size: 16.sp,
                                //           )
                                //         ],
                                //       )
                                //     ],
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: 4.sp,
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     _navigationService
                                //         .navigateTo('trackRecord');
                                //   },
                                //   child: Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     children: <Widget>[
                                //       Text(
                                //         "나의 예측 기록",
                                //         style: TextStyle(
                                //           fontSize: 20.sp,
                                //           fontFamily: 'AppleSDB',
                                //           letterSpacing: -1.0,
                                //         ),
                                //       ),
                                //       Row(
                                //         children: [
                                //           Text(
                                //             "                    ",
                                //             style: TextStyle(
                                //               fontSize: 20.sp,
                                //               fontFamily: 'AppleSDB',
                                //               letterSpacing: -1.0,
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             width: 8.sp,
                                //           ),
                                //           // ),
                                //           // GestureDetector(
                                //           //     onTap: () {
                                //           //       _navigationService
                                //           //           .navigateTo(
                                //           //               'trackRecord');
                                //           //     },
                                //           //     child: Container(
                                //           //         width: 100)),
                                //           Icon(
                                //             Icons.arrow_forward_ios,
                                //             size: 16.sp,
                                //           )
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                              24.w,
                              32.h,
                              24.w,
                              16.h,
                            ),
                            // color: Colors.white,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40)),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // color: Colors.red,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            // "11월 14일의 예측주제",
                                            model.address.isVoting
                                                ? formatKoreanDate.format(
                                                        strToDate(model
                                                            .vote.voteDate)) +
                                                    "의 예측 주제"
                                                : formatKoreanDate.format(
                                                    strToDate(
                                                        model.vote.voteDate)),
                                            style: TextStyle(
                                              fontFamily: 'AppleSDEB',
                                              fontSize: 22.sp,
                                              // height: 1,
                                              // letterSpacing: -.28,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          model.address.isVoting
                                              ? Container()
                                              : Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                      vertical: 4),
                                                  // decoration: BoxDecoration(
                                                  //     borderRadius:
                                                  //         BorderRadius.all(
                                                  //             Radius
                                                  //                 .circular(
                                                  //                     5)),
                                                  //     color: Color(
                                                  //         0xFFEF3571)),
                                                  child: Text("LIVE",
                                                      style: TextStyle(
                                                        fontFamily: 'DmSans',
                                                        fontSize: 22.sp,
                                                        // color: Colors.white,
                                                        // height: 1,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                        ],
                                      ),
                                      GestureDetector(
                                        key: tutorialKey5,
                                        // 광고 활성화 해야 함
                                        onTap: () {
                                          model.user.rewardedCnt < 5
                                              ? rewardedAdsLoaded
                                                  ? showAdsDialog(
                                                      context, model)
                                                  : showAdsNotLoadDialog(
                                                      context)
                                              : showAdsFullRewardedDialog(
                                                  context);
                                        },
                                        // onTap: null,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              padding: EdgeInsets.all(4),
                                              // decoration: BoxDecoration(
                                              //     borderRadius: BorderRadius.all(
                                              //         Radius.circular(100.0)),
                                              //     color: Color(0xFF1EC8CF),
                                              //     border: Border.all(
                                              //         color: Colors.white,
                                              //         width: 2)),
                                              child: SvgPicture.asset(
                                                'assets/icons/dog_foot.svg',
                                                color: Color(0xFF1EC8CF),
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              (model.user.item == null)
                                                  ? 0.toString()
                                                  : (model.user.item -
                                                          numSelected)
                                                      .toString(),
                                              style: TextStyle(
                                                fontSize: 26,
                                                letterSpacing: -1.0,
                                                fontFamily: 'AppleSDB',
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                // SizedBox(height: 12),
                                Container(
                                  // color: Colors.blue,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          model.address.isVoting
                                              ? Text(
                                                  "예측 마감까지",
                                                  style: TextStyle(
                                                    fontFamily: 'AppleSDM',
                                                    fontSize: 17.sp,
                                                    color: Color(0xFF3E3E3E),

                                                    // fontWeight: FontWeight.w500,
                                                    letterSpacing: -1,
                                                    height: 1,
                                                  ),
                                                )
                                              : Text(
                                                  "장 마감까지",
                                                  style: TextStyle(
                                                    fontFamily: 'AppleSDM',
                                                    fontSize: 17.sp,

                                                    // fontWeight: FontWeight.w500,
                                                    letterSpacing: -1,
                                                  ),
                                                ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          TopContainer(model, checkVoteTime),
                                        ],
                                      ),
                                      model.address.isVoting
                                          ? GestureDetector(
                                              onTap: () {
                                                model.user.rewardedCnt < 5
                                                    ? rewardedAdsLoaded
                                                        ? showAdsDialog(
                                                            context, model)
                                                        : showAdsNotLoadDialog(
                                                            context)
                                                    : showAdsFullRewardedDialog(
                                                        context);
                                              },
                                              child: Text(
                                                "꾸욱 얻으러 가기",
                                                style: TextStyle(
                                                  fontFamily: 'AppleSDM',
                                                  fontSize: 17.sp,
                                                  color: Color(0xFF3E3E3E),
                                                  // fontWeight: FontWeight.w500,
                                                  letterSpacing: -1,
                                                  height: 1,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  showMyVote = !showMyVote;
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 6),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    color: Color(0xFFFFDE34)),
                                                child: Text(
                                                  "오늘 나의 예측은?",
                                                  style: TextStyle(
                                                    fontFamily: 'AppleSDM',
                                                    fontSize: 16.sp,
                                                    color: Colors.black,
                                                    // fontWeight: FontWeight.w500,
                                                    letterSpacing: -1,
                                                    height: 1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     TopContainer(model, checkVoteTime),
                                //   ],
                                // ),
                                Expanded(
                                  child: Container(
                                    // height: 300,
                                    // color: Colors.black,
                                    // child: SingleChildScrollView(
                                    //                                 clipBehavior: Clip.antiAliasWithSaveLayer,
                                    //                                 physics: BouncingScrolrlPhysics(
                                    //                                     // android에서도 스크롤 많이 했을 때 바운스 생기게
                                    //                                     parent: AlwaysScrollableScrollPhysics()),
                                    //                                 // physics: (),
                                    //                                 child: Container(
                                    // height: 550,
                                    child: ListView.builder(
                                        // physics: NeverScrollableScrollPhysics(),
                                        itemCount: model.vote.voteCount,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              buildStack(
                                                model,
                                                index,
                                                context,
                                                numSelected,
                                                _scaffoldKey,
                                                // diff,
                                              ),
                                              index ==
                                                      (model.vote.voteCount - 1)
                                                  ? Container(
                                                      height: 110,
                                                    )
                                                  : Container(),
                                            ],
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Text(
                        //       "승점 ",
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         letterSpacing: -1.0,
                        //         fontFamily: 'DmSans',
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     Text(
                        //       numSelected.toString(),
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         letterSpacing: -1.0,
                        //         fontFamily: 'DmSans',
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //     Text(
                        //       "점 도전",
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         letterSpacing: -1.0,
                        //         fontFamily: 'DmSans',
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     )
                        //   ],
                        // ),

                        // Expanded(
                        //     child:
                        // )),
                      ],
                    ),
                    model.address.isVoting
                        ? Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: ((numSelected == 0) ||
                                      (model.userVote == null
                                          ? false
                                          : (model.address.isVoting == false)))
                                  ? () {}
                                  : () {
                                      listSelected = [];
                                      for (int i = 0;
                                          i < model.selected.length;
                                          i++) {
                                        model.selected[i] == true
                                            ? listSelected.add(i)
                                            : 0;
                                        model.userVote.voteSelected == null
                                            ? model.userVote.voteSelected =
                                                List.generate(
                                                    model.vote.voteCount,
                                                    (index) => 0)
                                            : model.userVote.voteSelected =
                                                model.userVote.voteSelected;
                                      }
                                      print("Has Voted? " +
                                          model.userVote.isVoted.toString());
                                      isSeasonStarted
                                          ? model.userVote.isVoted
                                              ? showGoToAdditionalGgookDialog(
                                                  context,
                                                  model,
                                                )
                                              : showGoToGgookDialog(
                                                  context,
                                                  model,
                                                )
                                          // _navigationService
                                          //     .navigateWithArgTo(
                                          //     'ggook',
                                          //     [
                                          //       model.address,
                                          //       model.user,
                                          //       model.vote,
                                          //       model.userVote,
                                          //       listSelected,
                                          //       0,
                                          //     ],
                                          //   )
                                          : {};
                                    },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24.w,
                                  vertical: 4,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 32.w,
                                  ),
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color:
                                          // (model.address.isVoting == false ||
                                          //         model.userVote.isVoted)
                                          // ? Color(0xFFC1C1C1)
                                          // : Colors.black,
                                          // Color(0xFF1EC8CF),
                                          (numSelected == 0 || !isSeasonStarted)
                                              ? Color(0xFF989898)
                                              : Colors.black,
                                      // gradient: model.address.isVoting == true
                                      //     ? LinearGradient(
                                      //         begin: Alignment.topLeft,
                                      //         end: Alignment.bottomRight,
                                      //         stops: [
                                      //           0,
                                      //           0.8,
                                      //         ],
                                      //         colors: [
                                      //           Color(0xFF00FF5B),
                                      //           Color(0xFF3E4CEE)
                                      //         ],
                                      //       )
                                      //     : LinearGradient(
                                      //         begin: Alignment.topLeft,
                                      //         end: Alignment.bottomRight,
                                      //         // stops: [
                                      //         //   0,
                                      //         //   0.8,
                                      //         // ],
                                      //         colors: [
                                      //           Colors.grey,
                                      //           Colors.grey,
                                      //         ],
                                      //       ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(.1),
                                          offset: Offset(0, 4.0),
                                          blurRadius: 8.0,
                                        )
                                      ],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(
                                        10,
                                      ))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "예측하러 가기",
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontFamily: 'AppleSDEB',
                                          height: 1,
                                          color: Color(0xFFFFF5F5),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xFFFFF5F5),
                                        size: 30.sp,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    model.address.isVoting
                        ? Positioned(
                            bottom: 55,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                color: (model.address.isVoting == false)
                                    ? Color(0xFFE41818)
                                    : numSelected == 0
                                        ? Color(0xFFFFDE34)
                                        : Color(0xFFFF5D02),
                              ),
                              child: FutureBuilder(
                                  future: model.getDefaultText(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data == null) {
                                      return Container();
                                    } else {
                                      defaultMainText = snapshot.data;
                                      return Text(
                                          model.address.isVoting == false
                                              ? "오늘의 예측이 마감되었습니다."
                                              : numSelected == 0
                                                  ? defaultMainText.replaceAll(
                                                          "\\n", "\n") ??
                                                      ""
                                                  : "선택한 주제 $numSelected개, 승점 ${numSelected * 2}점에 도전해보세요!",
                                          style: TextStyle(
                                            fontSize: numSelected == 0
                                                ? 14.sp
                                                : 16.sp,
                                            fontFamily: 'AppleSDB',
                                            // height: 1,
                                            // fontWeight: FontWeight.w500,
                                            color: (model.address.isVoting ==
                                                    false)
                                                ? Colors.white
                                                : numSelected == 0
                                                    ? Colors.black
                                                    : Color(0xFFFFF5F1),
                                          ));
                                    }
                                  }),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        }

        //  buildScaffold(model, displayRatio, size, userVote,
        //         address, user, vote);
      },
    );
  }

  Future showGoToAdditionalGgookDialog(
      BuildContext context, VoteSelectViewModel model) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          int alreadyVoted = 0;
          model.userVote.voteSelected.forEach((element) {
            if (element != 0) {
              alreadyVoted++;
            }
          });
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)), //this right here
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 200,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 12,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          // color:
                          // Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    "${listSelected.length}개의 주제를 추가로 선택하셨습니다.",
                                    style: TextStyle(
                                      fontFamily: 'AppleSDB',
                                      fontSize: 18,
                                    ),
                                    maxLines: 1,
                                  ),
                                  AutoSizeText(
                                    "(이미 예측한 주제 ${alreadyVoted.toString()}개)",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'AppleSDM',
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //     height: 4),

                              Column(
                                children: [
                                  AutoSizeText(
                                    "예측에 모두 성공하면 승점 +${(alreadyVoted + listSelected.length) * 2}점 획득! 🎊",
                                    style: TextStyle(
                                      fontFamily: 'AppleSDM',
                                      fontSize: 16,
                                      height: 1,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                  AutoSizeText(
                                    "모두 실패하면 ${-(alreadyVoted + listSelected.length)}점 😢",
                                    style: TextStyle(
                                      fontFamily: 'AppleSDM',
                                      fontSize: 16,
                                      height: 1,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ],
                              ),

                              // SizedBox(
                              //     height: 4),
                              Text(
                                "예측하러 갈까요?",
                                style: TextStyle(
                                  fontFamily: 'AppleSDB',
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          FlatButton(
                            minWidth: deviceWidth * .28,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "돌아가기",
                              style: TextStyle(
                                  fontFamily: 'AppleSDM', color: Colors.white),
                            ),
                            color: const Color(0xFF989898),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _navigationService.navigateWithArgTo(
                                  'ggook',
                                  [
                                    model.address,
                                    model.user,
                                    model.vote,
                                    model.userVote,
                                    listSelected,
                                    0,
                                  ],
                                );
                              },
                              child: Text(
                                "예측하러 가기",
                                style: TextStyle(
                                    fontFamily: 'AppleSDM',
                                    color: Colors.white),
                              ),
                              color: const Color(0xFF1EC8CF),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future showGoToGgookDialog(BuildContext context, VoteSelectViewModel model) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)), //this right here
              child: Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 14,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            "총 ${listSelected.length}개의 주제를 선택하셨습니다.",
                            style: TextStyle(
                              fontFamily: 'AppleSDB',
                              fontSize: 18.sp,
                            ),
                            maxLines: 1,
                          ),
                          SizedBox(height: 12),
                          AutoSizeText(
                            "예측에 모두 성공하면 승점 +${listSelected.length * 2}점 획득! 🎊\n모두 실패하면 ${-listSelected.length}점 😢",
                            style: TextStyle(
                              fontFamily: 'AppleSDM',
                              fontSize: 16.sp,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          SizedBox(height: 8),
                          AutoSizeText(
                            "예측하러 갈까요?",
                            style: TextStyle(
                              fontFamily: 'AppleSDB',
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          FlatButton(
                            minWidth: deviceWidth * .28,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "돌아가기",
                              style: TextStyle(
                                  fontFamily: 'AppleSDM', color: Colors.white),
                            ),
                            color: const Color(0xFF989898),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _navigationService.navigateWithArgTo(
                                  'ggook',
                                  [
                                    model.address,
                                    model.user,
                                    model.vote,
                                    model.userVote,
                                    listSelected,
                                    0,
                                  ],
                                );
                              },
                              child: Text(
                                "예측하러 가기",
                                style: TextStyle(
                                    fontFamily: 'AppleSDM',
                                    color: Colors.white),
                              ),
                              color: const Color(0xFF1EC8CF),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future showAdsDialog(BuildContext context, VoteSelectViewModel model) {
    // model.loadRewardedAds();
    return showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: CupertinoAlertDialog(
              content: Column(
                children: [
                  Text('광고 시청을 통해 하루 최대 5개의 꾸욱 아이템을 얻을 수 있어요.'),
                  Row(
                    children: [
                      Spacer(),
                      Text('오늘 얻은 꾸욱 아이템: '),
                      Text(
                        '${model.user.rewardedCnt}',
                        style: TextStyle(color: Colors.red),
                      ),
                      Text('/5'),
                      Spacer(),
                    ],
                  ),
                  Text('\n광고를 보고 꾸욱 아이템을 획득하시겠어요?\n(광고소리가 재생될 수 있습니다.)'),
                ],
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('아뇨'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: Text('좋아요'),
                  onPressed: rewardedAdsLoaded
                      ? () {
                          Navigator.pop(context);
                          model.showRewardedAds();
                        }
                      : null,
                )
              ],
            ),
          );
        } else {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              content: Column(
                children: [
                  Text('광고 시청을 통해 하루 최대 5개의 꾸욱 아이템을 얻을 수 있어요.'),
                  Row(
                    children: [
                      Spacer(),
                      Text('오늘 얻은 꾸욱 아이템: '),
                      Text(
                        '${model.user.rewardedCnt}',
                        style: TextStyle(color: Colors.red),
                      ),
                      Text('/5'),
                      Spacer(),
                    ],
                  ),
                  Text('\n광고를 보고 꾸욱 아이템을 획득하시겠어요?\n(광고소리가 재생될 수 있습니다.)'),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('아뇨'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('좋아요'),
                  onPressed: rewardedAdsLoaded
                      ? () {
                          Navigator.pop(context);
                          model.showRewardedAds();
                        }
                      : null,
                )
              ],
            ),
          );
        }
      },
    );
  }

  Future showAdsNotLoadDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: CupertinoAlertDialog(
              content: Text(
                  '아직 광고가 로드되지 않았습니다.\n잠시 후 다시 시도해주세요!\n불편을 드려 대단히 죄송합니다.'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        } else {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              content: Text(
                  '아직 광고가 로드되지 않았습니다.\n잠시 후 다시 시도해주세요!\n불편을 드려 대단히 죄송합니다.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future showAdsFullRewardedDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        if (Platform.isIOS) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: CupertinoAlertDialog(
              content:
                  Text('오늘 시청할 수 있는 5개의 광고를\n모두 보셨어요!\n광고는 00:00에 재로드됩니다.'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        } else {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              content:
                  Text('오늘 시청할 수 있는 5개의 광고를\n모두 보셨어요!\n광고는 00:00에 재로드됩니다.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget buildStack(
    VoteSelectViewModel model,
    int idx,
    BuildContext context,
    int numSelected,
    GlobalKey<ScaffoldState> scaffoldKey,
    // Duration diff,
  ) {
    var formatReturnPct = NumberFormat("0.00%");
    var formatPrice = NumberFormat("#,###");
    var formatIndex = NumberFormat("#,###.00");
    var formatPriceUpDown = NumberFormat("+#,###; -#,###");
    var formatIndexUpDown = NumberFormat("+#,###.00; -#,###.00");
    int numOfChoices = model.vote.subVotes[idx].issueCode.length;
    Color hexToColor(String code) {
      return Color(int.parse(code, radix: 16) + 0xFF0000000);
    }

    int choice = model.userVote.voteSelected == null
        ? 0
        : model.userVote.voteSelected[idx];

    TextStyle voteTitleStyle = TextStyle(
        color: Colors.black,
        fontFamily: 'AppleSDEB',
        fontSize: 24.sp,
        // height: 1,
        letterSpacing: -.2);

    TextStyle notVotedTitleStyle = TextStyle(
        color: Color(0xFFCCCCCC),
        fontFamily: 'AppleSDEB',
        fontSize: 24.sp,
        // height: 1,
        letterSpacing: -.2);

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0.0.w),
              child: Container(
                color: Colors.white.withOpacity(0),
                // color: (idx % 2 == 0) ? Colors.amber : Colors.yellow,
                height: 70,
                // decoration: BoxDecoration(border: Border.all(width: 0.3)),
                child: Padding(
                  padding: model.address.isVoting
                      ? EdgeInsets.only(left: 40)
                      : EdgeInsets.only(left: 0),
                  child: GestureDetector(
                    onTap: () {
                      // buildModalBottomSheet(
                      //     context, hexToColor, model, idx, numOfChoices, diff);
                      callNewModalBottomSheet(
                        context,
                        hexToColor,
                        model,
                        idx,
                        numOfChoices,
                        // diff,
                      );
                    },
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        numOfChoices == 1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(model.vote.subVotes[idx].title,
                                          style: (showMyVote &&
                                                  model.userVote.voteSelected !=
                                                      null)
                                              ? (model.userVote
                                                          .voteSelected[idx] ==
                                                      0)
                                                  ? notVotedTitleStyle
                                                  : voteTitleStyle
                                              : voteTitleStyle),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      (showMyVote &&
                                              model.userVote.voteSelected !=
                                                  null)
                                          ? (model.userVote.voteSelected[idx] ==
                                                  0)
                                              ? Container()
                                              : Text(
                                                  model.vote.subVotes[idx]
                                                      .voteChoices[model
                                                          .userVote
                                                          .voteSelected[idx] -
                                                      1],
                                                  style: TextStyle(
                                                      color: model.userVote
                                                                      .voteSelected[
                                                                  idx] ==
                                                              1
                                                          ? Color(0xFFFF3E3E)
                                                          : Color(0xFF3485FF),
                                                      fontFamily: 'AppleSDEB',
                                                      fontSize: 20.sp,
                                                      // height: 1,
                                                      letterSpacing: -.2),
                                                )
                                          : Container()
                                    ],
                                  ),
                                  model.address.isVoting
                                      ? choice == 0
                                          ? Container()
                                          : Text(
                                              model.vote.subVotes[idx]
                                                  .voteChoices[choice - 1],
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: choice == 1
                                                      ? Color(0xFFFF3E3E)
                                                      : Colors.blue),
                                            )
                                      : StreamBuilder(
                                          stream: model.getRealtimePrice(
                                              model.address,
                                              model.vote.subVotes[idx]
                                                  .issueCode[0]),
                                          builder: (context, snapshot) {
                                            bool isIndex = model
                                                    .vote
                                                    .subVotes[idx]
                                                    .indexOrStocks[0] ==
                                                "index";
                                            if (snapshot.data == null) {
                                              return Center(child: Container());
                                            } else {
                                              PriceModel price0;
                                              price0 = snapshot.data;
                                              return price0.pricePctChange < 0
                                                  ? Text(
                                                      isIndex
                                                          ? (formatIndex
                                                                  .format(price0
                                                                      .price)
                                                                  .toString()) +
                                                              " (" +
                                                              formatReturnPct
                                                                  .format(price0
                                                                      .pricePctChange)
                                                                  .toString() +
                                                              ")"
                                                          : (formatPrice
                                                                  .format(price0
                                                                      .price)
                                                                  .toString()) +
                                                              " (" +
                                                              formatReturnPct
                                                                  .format(price0
                                                                      .pricePctChange)
                                                                  .toString() +
                                                              ")",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF3485FF),
                                                        fontSize: 16,
                                                      ),
                                                    )
                                                  : Text(
                                                      isIndex
                                                          ? formatIndex
                                                                  .format(price0
                                                                      .price)
                                                                  .toString() +
                                                              " (+" +
                                                              formatReturnPct
                                                                  .format(price0
                                                                      .pricePctChange)
                                                                  .toString() +
                                                              ")"
                                                          : formatPrice
                                                                  .format(price0
                                                                      .price)
                                                                  .toString() +
                                                              " (+" +
                                                              formatReturnPct
                                                                  .format(price0
                                                                      .pricePctChange)
                                                                  .toString() +
                                                              ")",
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFFFF3E3E),
                                                        fontSize: 16,
                                                        height: 1,
                                                      ),
                                                    );
                                            }
                                          },
                                        )
                                ],
                              )
                            : Expanded(
                                child: Row(
                                  key: idx == 1 ? tutorialKey3 : null,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Text(
                                          model.vote.subVotes[idx]
                                              .voteChoices[0],
                                          style: (showMyVote &&
                                                  model.userVote.voteSelected !=
                                                      null)
                                              ? (model.userVote
                                                          .voteSelected[idx] ==
                                                      0)
                                                  ? notVotedTitleStyle
                                                  : model.userVote.voteSelected[
                                                              idx] ==
                                                          1
                                                      ? voteTitleStyle
                                                      : notVotedTitleStyle
                                              : voteTitleStyle,
                                        ),
                                        model.address.isVoting
                                            ? choice == 0
                                                ? Container()
                                                : Text(
                                                    model.vote.subVotes[idx]
                                                            .voteChoices[
                                                        choice - 1],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: choice == 1
                                                            ? Color(0xFFFF3E3E)
                                                            : Colors
                                                                .transparent),
                                                  )
                                            : StreamBuilder(
                                                stream: model.getRealtimePrice(
                                                    model.address,
                                                    model.vote.subVotes[idx]
                                                        .issueCode[0]),
                                                builder: (context, snapshot) {
                                                  if (snapshot.data == null) {
                                                    return Center(
                                                        child: Container());
                                                  } else {
                                                    PriceModel price0;
                                                    price0 = snapshot.data;
                                                    return price0
                                                                .pricePctChange <
                                                            0
                                                        ? Text(
                                                            formatPrice
                                                                    .format(price0
                                                                        .price)
                                                                    .toString() +
                                                                " (" +
                                                                formatReturnPct
                                                                    .format(price0
                                                                        .pricePctChange)
                                                                    .toString() +
                                                                ")",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF3485FF),
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        : Text(
                                                            formatPrice
                                                                    .format(price0
                                                                        .price)
                                                                    .toString() +
                                                                " (+" +
                                                                formatReturnPct
                                                                    .format(price0
                                                                        .pricePctChange)
                                                                    .toString() +
                                                                ")",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFFF3E3E),
                                                              fontSize: 16,
                                                            ),
                                                          );
                                                  }
                                                },
                                              )
                                      ],
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "VS",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'AppleSDB',
                                            fontSize: 18.sp,
                                            // height: 1,
                                          ),
                                        ),
                                        model.address.isVoting
                                            ? choice == 0
                                                ? Container()
                                                : Text(
                                                    " ",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      height: 1,
                                                    ),
                                                  )
                                            : Container()
                                      ],
                                    ),
                                    SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          model.vote.subVotes[idx]
                                              .voteChoices[1],
                                          style: (showMyVote &&
                                                  model.userVote.voteSelected !=
                                                      null)
                                              ? (model.userVote
                                                          .voteSelected[idx] ==
                                                      0)
                                                  ? notVotedTitleStyle
                                                  : model.userVote.voteSelected[
                                                              idx] ==
                                                          1
                                                      ? notVotedTitleStyle
                                                      : voteTitleStyle
                                              : voteTitleStyle,
                                        ),
                                        model.address.isVoting
                                            ? choice == 0
                                                ? Container()
                                                : Text(
                                                    model.vote.subVotes[idx]
                                                            .voteChoices[
                                                        choice - 1],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: choice == 2
                                                            ? Color(0xFFFF3E3E)
                                                            : Colors
                                                                .transparent),
                                                  )
                                            : StreamBuilder(
                                                stream: model.getRealtimePrice(
                                                    model.address,
                                                    model.vote.subVotes[idx]
                                                        .issueCode[1]),
                                                builder: (context, snapshot1) {
                                                  if (snapshot1.data == null) {
                                                    return Center(
                                                        child: Container());
                                                  } else {
                                                    PriceModel price1;
                                                    price1 = snapshot1.data;
                                                    return price1
                                                                .pricePctChange <
                                                            0
                                                        ? Text(
                                                            formatPrice
                                                                    .format(price1
                                                                        .price)
                                                                    .toString() +
                                                                " (" +
                                                                formatReturnPct
                                                                    .format(price1
                                                                        .pricePctChange)
                                                                    .toString() +
                                                                ")",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF3485FF),
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        : Text(
                                                            formatPrice
                                                                    .format(price1
                                                                        .price)
                                                                    .toString() +
                                                                " (+" +
                                                                formatReturnPct
                                                                    .format(price1
                                                                        .pricePctChange)
                                                                    .toString() +
                                                                ")",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFFF3E3E),
                                                              fontSize: 16,
                                                            ),
                                                          );
                                                  }
                                                },
                                              )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Padding(
        //   padding: EdgeInsets.only(
        //       // left: 13.5.w,
        //       ),
        //   child: Container(
        //     width: 27.w,
        //     height: 27.h,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(40),
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        // Text("AAA"),
        model.address.isVoting
            ? Container(
                // 이렇게 해야 튜토리얼에서 글로벌키를 인덱스가 0일때만 사용하기 때문에 같은 글로벌키를 여러 곳에서(목록이 3개니까) 사용해서 나는 오류가 없어진다.
                key: idx == 0 ? tutorialKey4 : null,
                // color: Colors.red,
                decoration: BoxDecoration(
                    color: Colors.white,
                    // gradient: LinearGradient(
                    //   colors: [
                    //     Color.fromRGBO(255, 143, 158, 1),
                    //     Color.fromRGBO(255, 188, 143, 1),
                    //   ],
                    //   begin: Alignment.centerLeft,
                    //   end: Alignment.centerRight,
                    // ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.4),
                        spreadRadius: 0,
                        blurRadius: 7,
                        offset: Offset(3, 3),
                      )
                    ]),
                child: CustomizedCircularCheckBox(
                    key: UniqueKey(),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    visualDensity: VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    value: model.userVote.voteSelected == null
                        ? model.selected[idx]
                        : model.userVote.voteSelected[idx] != 0
                            ? true
                            : model.selected[idx],
                    hoverColor: Colors.white,
                    activeColor: model.userVote.voteSelected == null
                        ? Color(0xFF1EC8CF)
                        : (model.address.isVoting == false ||
                                model.userVote.voteSelected[idx] != 0)
                            ? Color(0xFF989898)
                            : Color(0xFF1EC8CF),
                    inactiveColor: model.userVote.voteSelected == null
                        ? Color(0xFF1EC8CF)
                        : (model.address.isVoting == false)
                            ? Color(0xFFC1C1C1)
                            : Color(0xFF1EC8CF),
                    // disabledColor: Colors.grey,
                    onChanged: (newValue) async {
                      int setChoice;
                      setChoice = model.userVote.voteSelected == null
                          ? 0
                          : model.userVote.voteSelected[idx];

                      setChoice != 0
                          ? await showDialog(
                              context: _scaffoldKey.currentContext,
                              barrierDismissible: true,
                              builder: (context) {
                                String title = "예측을 초기화하시겠습니까?";
                                String message =
                                    "이미 소모된 꾸욱 아이템은 반환되지 않습니다. 초기화된 종목은 다시 예측이 가능하며,\n이 경우 꾸욱 아이템이 소모됩니다.";
                                String yesLabel = "초기화하기";
                                String noLabel = "돌아가기";
                                return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Platform.isIOS
                                      ? CupertinoAlertDialog(
                                          title: Text(
                                            title,
                                            style: TextStyle(
                                                // fontFamily: 'AppleSDB',
                                                ),
                                          ),
                                          content: Text(
                                            message,
                                            style: TextStyle(
                                              fontFamily: 'AppleSDM',
                                            ),
                                          ),
                                          actions: <Widget>[
                                            CupertinoDialogAction(
                                              child: Text(noLabel),
                                              textStyle: TextStyle(),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            CupertinoDialogAction(
                                                child: Text(yesLabel),
                                                textStyle: TextStyle(
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  model.initialiseOneVote(idx);
                                                }),
                                          ],
                                        )
                                      : AlertDialog(
                                          title: Text(
                                            title,
                                            style: TextStyle(
                                                // fontFamily: 'AppleSDB',
                                                ),
                                          ),
                                          content: Text(
                                            message,
                                            style: TextStyle(
                                              fontFamily: 'AppleSDM',
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(noLabel),
                                              // textStyle: TextStyle(),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                            ),
                                            FlatButton(
                                                child: Text(
                                                  yesLabel,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  model.initialiseOneVote(idx);
                                                  Navigator.pop(context);
                                                }),
                                          ],
                                        ),
                                );
                              })
                          : setState(() {
                              // print(
                              //     model.seasonInfo.maxDailyVote - numSelected);

                              if (model.seasonInfo.maxDailyVote - numSelected ==
                                  0) {
                                if (newValue) {
                                  model.selected[idx] = model.selected[idx];
                                  _showToast(
                                      "하루 최대 ${model.seasonInfo.maxDailyVote}개 주제를 예측할 수 있습니다.");
                                } else {
                                  model.selected[idx] = newValue;
                                }
                              } else {
                                if ((model.user.item == null
                                        ? 0
                                        : model.user.item - numSelected) <=
                                    0) {
                                  // 선택되면 안됨
                                  if (newValue) {
                                    model.selected[idx] = model.selected[idx];

                                    _showToast("보유 중인 아이템이 부족합니다.");
                                  } else {
                                    model.selected[idx] = newValue;
                                  }
                                } else {
                                  model.selected[idx] = newValue;
                                  print(model.selected);
                                  print(listSelected);
                                }
                              }
                            });
                    }),
              )
            : Container(),
      ],
    );
  }

  Future callNewModalBottomSheet(
    BuildContext context,
    Color hexToColor(String code),
    VoteSelectViewModel model,
    int idx, // subvote index
    int numOfChoices, // issueCode length
    // Duration diff,
  ) {
    ScrollController controller;
    StreamController scrollStreamCtrl = StreamController<double>();
    return showModalBottomSheet(
        // // barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.transparent,
        // backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (
          context,
        ) =>
            StreamBuilder<double>(
                stream: scrollStreamCtrl.stream,
                initialData: 0,
                builder: (context, snapshot) {
                  double offset = snapshot.data;

                  if (offset < -140) {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => Navigator.pop(context));
                  }

                  // Do everything you want here...

                  print(snapshot.data);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 30,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 55,
                              height: 8,
                              decoration: BoxDecoration(
                                // color: Colors.white70,
                                color: Color(0xFFEBEBEB),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              // child: SizedBox(),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Container(
                        height: offset < 0
                            ? (deviceHeight * .83) + offset
                            : deviceHeight * .83,
                        // height: 250 + offset * 1.4,
                        child: ChartView(
                            // controller,
                            scrollStreamCtrl,
                            model.selected,
                            idx,
                            numSelected,
                            model.vote,
                            model.seasonInfo,
                            model.address,
                            model.user,
                            model.selectUpdate,
                            _showToast,
                            model.userVote.voteSelected == null
                                ? false
                                : model.userVote.voteSelected[idx] == null
                                    ? false
                                    : model.userVote.voteSelected[idx] != 0),
                      ),
                    ],
                  );
                }));
  }

  // Future buildModalBottomSheet(
  //   BuildContext context,
  //   Color hexToColor(String code),
  //   VoteSelectViewModel model,
  //   int idx,
  //   int numOfChoices,
  //   Duration diff,
  // ) {
  //   return showModalBottomSheet(
  //     backgroundColor: Colors.white,
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (
  //       context,
  //     ) =>
  //         Padding(
  //       padding: const EdgeInsets.fromLTRB(
  //         16.0,
  //         32,
  //         16,
  //         32,
  //       ),
  //       child: Container(
  //         color: Colors.white,
  //         // height: double.maxFinite,
  //         // constraints: BoxConstraints(
  //         //   // maxHeight: 400,
  //         // ),
  //         child: Wrap(
  //           direction: Axis.horizontal,
  //           alignment: WrapAlignment.start,
  //           // crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
  //               child: Row(
  //                 children: [
  //                   numOfChoices == 1
  //                       ? Container(
  //                           constraints: BoxConstraints(
  //                             maxHeight: 48,
  //                             minWidth: 100,
  //                           ),
  //                           alignment: Alignment.centerLeft,
  //                           padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
  //                           decoration: BoxDecoration(
  //                             color: hexToColor(
  //                               model.vote.subVotes[idx].colorCode[0],
  //                             ),
  //                             borderRadius: BorderRadius.circular(50),
  //                             border: Border.all(
  //                               width: 4.0,
  //                               color: Color(0xFF000000),
  //                             ),
  //                             // borderRadius: BorderRadius.all(
  //                             //     Radius.circular(30)),
  //                           ),
  //                           // color: Colors.redAccent,
  //                           child: Text(
  //                             model.vote.subVotes[idx].title,
  //                             textAlign: TextAlign.center,
  //                             style: TextStyle(
  //                               textBaseline: TextBaseline.ideographic,
  //                               color: Colors.black,
  //                               fontSize: 28,
  //                               fontWeight: FontWeight.w700,
  //                             ),
  //                           ),
  //                         )
  //                       : Row(
  //                           children: [
  //                             Container(
  //                               constraints: BoxConstraints(
  //                                 maxHeight: 48,
  //                                 // minWidth: 100,
  //                               ),
  //                               alignment: Alignment.centerLeft,
  //                               padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
  //                               decoration: BoxDecoration(
  //                                 color: hexToColor(
  //                                   model.vote.subVotes[idx].colorCode[0],
  //                                 ),
  //                                 borderRadius: BorderRadius.circular(50),
  //                                 border: Border.all(
  //                                   width: 4.0,
  //                                   color: Color(0xFF000000),
  //                                 ),
  //                                 // borderRadius: BorderRadius.all(
  //                                 //     Radius.circular(30)),
  //                               ),
  //                               // color: Colors.redAccent,
  //                               child: Text(
  //                                 model.vote.subVotes[idx].voteChoices[0],
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(
  //                                   textBaseline: TextBaseline.ideographic,
  //                                   color: Colors.black,
  //                                   fontSize: model.vote.subVotes[idx]
  //                                               .voteChoices[0].length <
  //                                           6
  //                                       ? 22
  //                                       : 18,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                             ),
  //                             SizedBox(width: 8),
  //                             Stack(
  //                               children: [
  //                                 Container(
  //                                   constraints: BoxConstraints(
  //                                     maxHeight: 48,
  //                                     // minWidth: 100,
  //                                   ),
  //                                   alignment: Alignment.centerLeft,
  //                                   padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
  //                                   decoration: BoxDecoration(
  //                                     color: hexToColor(
  //                                       model.vote.subVotes[idx].colorCode[1],
  //                                     ),
  //                                     borderRadius: BorderRadius.circular(50),
  //                                     border: Border.all(
  //                                       width: 4.0,
  //                                       color: Color(0xFF000000),
  //                                     ),
  //                                     // borderRadius: BorderRadius.all(
  //                                     //     Radius.circular(30)),
  //                                   ),
  //                                   // color: Colors.redAccent,
  //                                   child: Text(
  //                                     model.vote.subVotes[idx].voteChoices[1],
  //                                     textAlign: TextAlign.center,
  //                                     style: TextStyle(
  //                                       textBaseline: TextBaseline.ideographic,
  //                                       color: Colors.black,
  //                                       fontSize: model.vote.subVotes[idx]
  //                                                   .voteChoices[1].length <
  //                                               6
  //                                           ? 22
  //                                           : 18,
  //                                       letterSpacing: 0,
  //                                       fontWeight: FontWeight.w700,
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 AlignPositioned.expand(
  //                                   alignment: Alignment.centerLeft,
  //                                   dx: -4,
  //                                   moveByChildWidth: -0.5,
  //                                   child: Container(
  //                                     alignment: Alignment.center,
  //                                     width: 40,
  //                                     height: 40,
  //                                     decoration: BoxDecoration(
  //                                         border: Border.all(
  //                                           color: Colors.black,
  //                                           width: 4.0,
  //                                         ),
  //                                         color: Colors.white,
  //                                         borderRadius: BorderRadius.circular(
  //                                           40,
  //                                         )),
  //                                     child: Text("vs",
  //                                         style: TextStyle(
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.bold,
  //                                         )),
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                   Expanded(child: SizedBox()),
  //                 ],
  //               ),
  //             ),
  //             // Expanded(child: SizedBox()),

  //             Text(
  //               model.vote.subVotes[idx].selectDescription,
  //               style: TextStyle(
  //                 fontSize: 28,
  //                 fontWeight: FontWeight.w700,
  //                 letterSpacing: -1.0,
  //               ),
  //               maxLines: 2,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
  //               child: Text(
  //                 "현재 ${model.vote.subVotes[idx].numVoted0 + model.vote.subVotes[idx].numVoted1}명이 이 주제를 예측하였습니다",
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontFamily: 'DmSans',
  //                   color: Color(0xFF1EC8CF),
  //                 ),
  //               ),
  //             ),

  //             Padding(
  //               padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
  //               child: Wrap(
  //                 spacing: 6,
  //                 runSpacing: -5,
  //                 direction: Axis.horizontal,
  //                 children: buildChip(hexToColor, model, idx, numOfChoices),
  //                 // Container(
  //                 //   alignment: Alignment.center,
  //                 //   padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
  //                 //   decoration: BoxDecoration(
  //                 //     color: hexToColor(
  //                 //       model.vote.subVotes[idx].colorCode[0],
  //                 //     ),
  //                 //     borderRadius: BorderRadius.circular(50),
  //                 //   ),
  //                 //   child: Text(
  //                 //     "시총 0.9조",
  //                 //     style: TextStyle(
  //                 //       fontSize: 16,
  //                 //       fontFamily: 'DmSans',
  //                 //       fontWeight: FontWeight.w700,
  //                 //     ),
  //                 //   ),
  //                 // ),
  //               ),
  //             ),
  //             SizedBox(
  //               height: 12,
  //             ),
  //             Row(
  //               children: <Widget>[
  //                 (!selected[idx])
  //                     ? Expanded(
  //                         child: RaisedButton(
  //                           onPressed: () {
  //                             (model.address.isVoting == false)
  //                                 ? {}
  //                                 : setState(() {
  //                                     if (model.seasonInfo.maxDailyVote -
  //                                             numSelected ==
  //                                         0) {
  //                                       _showToast(
  //                                           "하루 최대 ${model.seasonInfo.maxDailyVote}개 주제를 예측할 수 있습니다.");
  //                                     } else {
  //                                       if (model.user.item - numSelected ==
  //                                           0) {
  //                                         // 선택되면 안됨

  //                                         _showToast("보유 중인 아이템이 부족합니다.");
  //                                       } else {
  //                                         selected[idx] = true;
  //                                         Navigator.of(context).pop();
  //                                       }
  //                                     }
  //                                   });
  //                           },
  //                           color: (model.address.isVoting == false)
  //                               ? Color(0xFFE4E4E4)
  //                               : Color(0xFF1EC8CF),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(30),
  //                           ),
  //                           padding: EdgeInsets.symmetric(
  //                             horizontal: 10,
  //                             vertical: 14,
  //                           ),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               (model.address.isVoting == false)
  //                                   ? SizedBox()
  //                                   : SvgPicture.asset(
  //                                       'assets/icons/double_check_icon.svg',
  //                                       width: 20,
  //                                     ),
  //                               (model.address.isVoting == false)
  //                                   ? SizedBox()
  //                                   : SizedBox(width: 8),
  //                               Text(
  //                                   model.address.isVoting == false
  //                                       ? "오늘 예측이 마감되었습니다."
  //                                       : "선택하기",
  //                                   style: TextStyle(
  //                                     fontSize: 20,
  //                                     color: (model.address.isVoting == false)
  //                                         ? Colors.black
  //                                         : Colors.white,
  //                                     fontFamily: 'DmSans',
  //                                     fontWeight: FontWeight.w700,
  //                                   )),
  //                             ],
  //                           ),
  //                         ),
  //                       )
  //                     : Expanded(
  //                         child: RaisedButton(
  //                           onPressed: () {
  //                             setState(() {
  //                               selected[idx] = false;
  //                             });
  //                             Navigator.of(context).pop();
  //                           },
  //                           color: Color(0xFF0F6669),
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(30),
  //                           ),
  //                           padding: EdgeInsets.symmetric(
  //                             horizontal: 14,
  //                             vertical: 14,
  //                           ),
  //                           child: Row(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               (model.address.isVoting == false)
  //                                   ? SizedBox()
  //                                   : Icon(
  //                                       Icons.cancel_outlined,
  //                                       size: 28,
  //                                       color: Colors.white,
  //                                     ),
  //                               SizedBox(width: 8),
  //                               Text("해제하기",
  //                                   style: TextStyle(
  //                                     fontSize: 20,
  //                                     fontFamily: 'DmSans',
  //                                     fontWeight: FontWeight.w700,
  //                                     color: Colors.white,
  //                                   )),
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  List<Widget> buildChip(
    Color hexToColor(String code),
    VoteSelectViewModel model,
    int idx,
    int numOfChoices,
  ) {
    List<Widget> _widgets = [];

    int tag0Length = model.vote.subVotes[idx].tag0.length;
    int tag1Length = model.vote.subVotes[idx].tag1.length;
    print("TAGIS" + tag0Length.toString());
    for (int j = 0; j < numOfChoices; j++) {
      for (int i = 0; j == 0 ? i < tag0Length : i < tag1Length; i++) {
        _widgets.add(Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4.0, 0),
          child: Chip(
            padding: EdgeInsets.symmetric(
              horizontal: 3.0,
              vertical: 0,
            ),
            // labelPadding: EdgeInsets.symmetric(
            //   horizontal: 5.0,
            //   vertical: 0,
            // ),
            label: Text(
              j == 0
                  ? model.vote.subVotes[idx].tag0[i]
                  : model.vote.subVotes[idx].tag1[i],
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'DmSans',
                fontWeight: FontWeight.w700,
              ),
            ),
            backgroundColor: hexToColor(
              model.vote.subVotes[idx].colorCode[j],
            ),
          ),
        ));
      }
    }

    return _widgets;
  }

  // Scaffold buildScaffold(
  //     VoteSelectViewModel model,
  //     double displayRatio,
  //     Size size,
  //     UserVoteModel userVote,
  //     DatabaseAddressModel address,
  //     UserModel user,
  //     VoteModel vote) {
  //   return Scaffold(
  //     body: Container(
  //       child: SafeArea(
  //         child: ListView(children: <Widget>[
  //           Padding(
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: gap_l,
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 // topBar(user),
  //                 SizedBox(
  //                   height: gap_l,
  //                 ),
  //                 Row(
  //                   //오늘의 주제, 남은 시간
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   children: [
  //                     Text(
  //                       model.data,
  //                       style: TextStyle(
  //                           color: Colors.black,
  //                           // fontFamily: 'AdventPro',
  //                           fontSize: 22,
  //                           textBaseline: TextBaseline.alphabetic),
  //                     ),
  //                     // Text(
  //                     //   "투표 마감까지 " +
  //                     //       (timeLeftArr[0]) +
  //                     //       "시간 " +
  //                     //       (timeLeftArr[1]) +
  //                     //       "분 " +
  //                     //       (timeLeftArr[2]) +
  //                     //       "초 ",
  //                     //   style: TextStyle(
  //                     //       color: Colors.black,
  //                     //       // fontFamily: 'AdventPro',
  //                     //       fontSize: 14,
  //                     //       textBaseline: TextBaseline.ideographic),
  //                     // )
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: gap_m,
  //                 ),
  //                 Container(
  //                   height: displayRatio > 1.85
  //                       ? size.height * .45
  //                       : size.height * .50,

  //                   // PageView.builder랑 똑같은데 preloadPageCount 만큼 미리 로드해놓는 것만 다름
  //                   child: PreloadPageView.builder(
  //                     preloadPagesCount: 5,
  //                     controller: _preloadPageController,
  //                     scrollDirection: Axis.horizontal,
  //                     // physics: BouncingScrollPhysics(),
  //                     itemCount: _votesTodayShowing.length,
  //                     itemBuilder: (context, index) {
  //                       // print('pageviewRebuilt');
  //                       return GestureDetector(
  //                           onDoubleTap: () {
  //                             // 주제 선택 최대 수를 제한하고
  //                             if (_votesTodayNotShowing.length < 3) {
  //                               setState(() {
  //                                 // 더블 탭 하면 voteToday 섹션과 voteSelected 섹션에서
  //                                 // 보여줘야할 위젯과 보여주지 않는 위젯을 서로 교환하며 리스트에 저장한다.
  //                                 _votesTodayNotShowing
  //                                     .add(_votesTodayShowing[index]);
  //                                 _votesTodayShowing.removeAt(index);

  //                                 _votesSelectedShowing
  //                                     .add(_votesSelectedNotShowing[index]);
  //                                 _votesSelectedNotShowing.removeAt(index);
  //                               });
  //                             } else
  //                               return;
  //                           },
  //                           child: _votesTodayShowing[index]);
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: gap_m,
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   crossAxisAlignment: CrossAxisAlignment.end,
  //                   children: <Widget>[
  //                     Text(
  //                       '선택한 투표',
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         // fontFamily: 'AdventPro',
  //                         fontSize: 22,
  //                       ),
  //                     ),
  //                     FlatButton(
  //                       onPressed: ((_votesSelectedShowing.length == 0) ||
  //                               (userVote == null
  //                                   ? false
  //                                   : userVote.isVoted == true))
  //                           ? () {}
  //                           : () {
  //                               for (VoteSelected i in _votesSelectedShowing) {
  //                                 listSelected.add(i.idx);
  //                               }
  //                               listSelected.sort();

  //                               _navigationService.navigateWithArgTo('ggook', [
  //                                 address,
  //                                 user,
  //                                 vote,
  //                                 listSelected,
  //                                 0,
  //                               ]);
  //                             },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                             color: _votesSelectedShowing.length == 0
  //                                 ? Color(0xFF531818)
  //                                 : Color(0xFFD72929),
  //                             borderRadius: BorderRadius.circular(8)),
  //                         child: Padding(
  //                           padding: EdgeInsets.symmetric(
  //                               vertical: gap_m, horizontal: gap_xxl),
  //                           child: Text(
  //                             'GO VOTE',
  //                             style: TextStyle(
  //                               color: _votesSelectedShowing.length == 0
  //                                   ? Color(0xFF605E5E)
  //                                   : Color(0xFFFFFFFF),
  //                               fontSize: 22,
  //                               fontWeight: FontWeight.w700,
  //                               fontFamily: 'AdventPro',
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(
  //                   height: gap_l,
  //                 ),
  //                 Container(
  //                   height: size.height * .2,
  //                   // color: Colors.red,
  //                   child: ListView.builder(
  //                     scrollDirection: Axis.horizontal,
  //                     itemCount: _votesSelectedShowing.length,
  //                     itemBuilder: (context, index) {
  //                       return GestureDetector(
  //                           onDoubleTap: () {
  //                             setState(() {
  //                               // Selected 더블탭 -> 거기서 id 추출
  //                               // voteTodayShowing에서 자리찾기
  //                               // insert

  //                               // 선택한 주제들 중 더블탭한 선택 주제 위젯을 temp에 보관.
  //                               VoteSelected temp =
  //                                   _votesSelectedShowing[index];
  //                               // 더블탭한 주제의 subVote idx추출
  //                               int subVoteIdx = temp.idx;

  //                               List<int> indicesList = [];

  //                               // 오늘의 주제에 떠있는 주제들의 subVoteIdx를 indicesList에 넣기
  //                               for (VoteCard i in _votesTodayShowing) {
  //                                 indicesList.add(i.idx);
  //                               }
  //                               // 방금 더블탭한 subVoteIdx도 이 리스트에 추가
  //                               indicesList.add(subVoteIdx);
  //                               // 순서대로 sort
  //                               indicesList.sort();

  //                               // 이 리스트에서 더블탭한 것의 순서를 세고
  //                               subVoteIdx = indicesList.indexOf(subVoteIdx);
  //                               // 선택주제에서 not showing 리스트에 위에서 센 순서 자리에 넣고,
  //                               // 선택 주제 showing에서 해당 위젯을 삭제
  //                               _votesSelectedNotShowing.insert(
  //                                   subVoteIdx, _votesSelectedShowing[index]);
  //                               _votesSelectedShowing.removeAt(index);

  //                               // 오늘의 주제 showing에 다시 자리 찾아서 놓고
  //                               // 오늘의 주제 not showing에서 제거
  //                               _votesTodayShowing.insert(
  //                                   subVoteIdx, _votesTodayNotShowing[index]);
  //                               _votesTodayNotShowing.removeAt(index);
  //                             });
  //                           },
  //                           child: _votesSelectedShowing[index]);
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ]),
  //       ),
  //     ),
  //   );
  // }
  // Widget myPage() {
  //   return Container(
  //     // width: MediaQuery.of(context).size.width,
  //     width: deviceWidth,
  //     // height: MediaQuery.of(context).size.height,
  //     height: deviceHeight,
  //     color: Colors.white,
  //     child: ListView(
  //       children: [
  //         GestureDetector(
  //             onTap: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Container(height: 100, color: Colors.red)),
  //         GestureDetector(
  //           onTap: () {
  //             _navigationService.navigateTo('mypage_editprofile');
  //           },
  //           child: Container(
  //             height: 100,
  //             color: Colors.blue,
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
  Widget myPage(VoteSelectViewModel model) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: Column(
            children: [
              mypageMainTopBar(model),
              Expanded(
                child: ListView(
                  children: [
                    mypageMainAccPref(model),
                    // mypageMainAppPref(model),
                    mypageMainCSCenter(model),
                    mypageMainTermsOfUse(model),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mypageMainTopBar(VoteSelectViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        child: Row(
          children: [
            Container(
              // height: 200,
              width: deviceWidth - 36 - 72,
              child: Column(
                children: [
                  model.user.accNumber == null
                      ? Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xFFFFCA42),
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  )),
                              child: Row(
                                children: [
                                  Container(
                                    height: 16,
                                    child: SvgPicture.asset(
                                      'assets/icons/notification.svg',
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "증권계좌 미인증회원",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 3,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xFF1EC8CF),
                                  borderRadius: BorderRadius.circular(
                                    30,
                                  )),
                              child: Row(
                                children: [
                                  Container(
                                    height: 16,
                                    child: SvgPicture.asset(
                                      'assets/icons/check.svg',
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "증권계좌 인증회원",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          model.user.userName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: model.user.userName.length > 8
                                ? 32
                                : model.user.userName.length > 6
                                    ? 40
                                    : 48,
                            letterSpacing: -1.0,
                            fontFamily: 'AppleSDB',
                            // fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            avatarWidget(model.user.avatarImage, model.user.item ?? 0)
          ],
        ),
      ),
    );
  }

  Widget makeMypageMainComponent(
      VoteSelectViewModel model, String title, String navigateTo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (navigateTo != null) model.navigateToMypageToDown(navigateTo);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ),
        ),
        Container(
          height: 1,
          color: Color(0xFFE3E3E3),
        )
      ],
    );
  }

  Widget mypageMainAccPref(VoteSelectViewModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24,
          ),
          Text(
            '나의 계정설정',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            color: Colors.black,
          ),
          makeMypageMainComponent(model, '회원정보 수정', 'mypage_editprofile'),
          // makeMypageMainComponent(model, 'x내가 받은 상금 현황', null),
          // makeMypageMainComponent(model, 'x내 활동', null),
          makeMypageMainComponent(model, '계좌 정보', 'mypage_accoutverification'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  model.logout();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  child: Text(
                    '더블 탭하여 로그아웃',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Container(
                height: 1,
                color: Color(0xFFE3E3E3),
              )
            ],
          ),
          SizedBox(
            height: 42,
          )
        ],
      ),
    );
  }

  Widget mypageMainAppPref(VoteSelectViewModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '앱 사용 설정',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            color: Colors.black,
          ),
          makeMypageMainComponent(model, '푸쉬알림 설정', 'mypage_pushalarmsetting'),
          makeMypageMainComponent(model, '친구에게 추천하기', 'mypage_friendscode'),
          SizedBox(
            height: 42,
          )
        ],
      ),
    );
  }

  Widget mypageMainCSCenter(VoteSelectViewModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '고객 센터',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            color: Colors.black,
          ),
          makeMypageMainComponent(model, '1:1 문의', 'oneonone'),
          makeMypageMainComponent(model, '자주 묻는 질문(FAQ)', 'faq'),
          makeMypageMainComponent(model, '공지사항', 'notice'),
          SizedBox(
            height: 42,
          )
        ],
      ),
    );
  }

  Widget mypageMainTermsOfUse(VoteSelectViewModel model) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '약관 및 정보',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 2,
            color: Colors.black,
          ),
          makeMypageMainComponent(model, '이용약관', 'mypage_termsofuse'),
          makeMypageMainComponent(model, '개인정보취급방침', 'mypage_privacypolicy'),
          makeMypageMainComponent(model, '사업자정보', 'mypage_businessinformation'),
          // makeMypageMainComponent(model, '', null),
          // makeMypageMainComponent(model, '꾸욱 셀렉션 임시', 'mypage_tempggook'),
          SizedBox(
            height: 42,
          )
        ],
      ),
    );
  }
}

class TopContainer extends StatefulWidget {
  final VoteSelectViewModel voteSelectViewModel;
  final Function checkVoteTime;
  TopContainer(
    this.voteSelectViewModel,
    this.checkVoteTime,
  );
  @override
  _TopContainerState createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {
  final TimezoneService _timezoneService = locator<TimezoneService>();
  Timer _timer;
  VoteSelectViewModel voteSelectViewModel;
  DateTime nowFromNetwork;
  TopContainerViewModel model = TopContainerViewModel();

  @override
  void dispose() {
    super.dispose();
    // dispose는 Navigator pushNamed에는 호출되지 않지만 백 버튼에는 호출됨.
    // 백 버튼에 아래를 호출하지 않으면 dispose 됐는데 setState한다고 오류뜸

    if (_timer.isActive) {
      _timer.cancel();
    }
    // isDisposed = true;
  }

  @override
  void initState() {
    super.initState();
    // Future getTimeFromNetwork() async {
    //   nowFromNetwork = await NTP.now();
    // }

    // defines a timer
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) async {
      // await model.renewTime();
      // // await model.renewTime();
      // nowFromNetwork = model.nowFromNetwork;
      // // getTimeFromNetwork();
      // // print("TIMER");
      // print("MODEL TIME" + model.nowFromNetwork.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (diff.inSeconds == 0 && model.address.isVoting == true) {
    //   _timer.cancel();
    //   model.getAllModel(model.uid);
    //   // widget.checkVoteTime();
    //   // model.isVoteAvailable();
    // }
    voteSelectViewModel = widget.voteSelectViewModel;
    return ViewModelBuilder<TopContainerViewModel>.reactive(
        viewModelBuilder: () => TopContainerViewModel(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return Container(
              width: 5,
              height: 4,
            );
          } else {
            // nowFromNetwork = nowFromNetwork;
            // print("AT MODEL DONE" + nowFromNetwork.toString());
            // model.renewTime();
            // _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
            //   // model.renewTime();

            //   print("TIMER");
            //   setState(() {});
            // });
            Duration getTimeLeft(VoteSelectViewModel voteSelectViewModel) {
              DateTime today = strToDate(voteSelectViewModel.address.date);
              DateTime seoulMarketEnd = tz.TZDateTime(_timezoneService.seoul,
                  today.year, today.month, today.day, 15, 30, 0);
              DateTime marketEnd = seoulMarketEnd;
              // tz.TZDateTime.from(seoulMarketEnd, _timezoneService.seoul);
              DateTime endTime = voteSelectViewModel.address.isVoting
                  ? voteSelectViewModel.vote.voteEndDateTime.toDate()
                  : marketEnd;

              // DateTime nowFromNetwork = model.now;
              // model.renewTimeFromNetwork();
              // DateTime temp = DateTime(2020, 11, 22, 15, 52, 20);
              return endTime
                  .difference(_timezoneService.koreaTime(DateTime.now()));
              // timeLeftArr = diffFinal.split(":");
              // return diffFinal;
            }

            Duration diff = getTimeLeft(voteSelectViewModel).inSeconds < 0
                ? Duration(hours: 0, minutes: 0, seconds: 0)
                : getTimeLeft(voteSelectViewModel);
            String strDurationHM =
                "${diff.inHours.toString().padLeft(2, '0')}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:";
            String strDurationSec =
                "${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
            var seoul = tz.getLocation('Asia/Seoul');

            return RichText(
              text: TextSpan(
                  text: strDurationHM.toString(),
                  style: TextStyle(
                    fontFamily: 'DmSans',
                    color: diff.inHours < 1
                        ? Color(0xFFE41818)
                        : Color(0xFF3E3E3E),
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: strDurationSec.toString(),
                        style: TextStyle(
                          fontFamily: 'DmSans',
                          color: diff.inHours < 1
                              ? Color(0xFFE41818)
                              : Color(0xFFC1C1C1),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -.5,
                        ))
                  ]),
            );
          }
        });
  }
}
