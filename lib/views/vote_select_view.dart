import 'dart:async';

import 'package:align_positioned/align_positioned.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:stacked/stacked.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/temp_address_constant.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/services/dialog_service.dart';
import 'package:yachtOne/views/temp_not_voting_view.dart';

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

class VoteSelectView extends StatefulWidget {
  @override
  _VoteSelectViewState createState() => _VoteSelectViewState();
}

class _VoteSelectViewState extends State<VoteSelectView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final VoteSelectViewModel _viewModel = VoteSelectViewModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Future<UserModel> _userModelFuture;
  Future<VoteModel> _getVoteModelFuture;

  Future<List<Object>> _getAllModel;
  Future<UserModel> _userModel;
  Future<DatabaseAddressModel> _addressModel;
  Future<VoteModel> _voteModel;
  String uid;

  PreloadPageController _preloadPageController = PreloadPageController();
  // double leftContainer = 0;

  // Votes for Today 영역 위젯 관리
  List<Widget> _votesTodayShowing = [];
  List<Widget> _votesTodayNotShowing = [];

  // Votes Selected 영역 위젯 관리
  List<Widget> _votesSelectedShowing = [];
  List<Widget> _votesSelectedNotShowing = [];

  // 최종 선택한 주제 index
  List<int> listSelected = [];
  List<String> timeLeftArr = ["", "", ""]; // 시간, 분, 초 array

  Timer _timer;

  DateTime _now;
  var stringDate = DateFormat("yyyyMMdd");
  var stringDateWithDash = DateFormat("yyyy-MM-dd");
  String _nowToStr;

  bool isDisposed = false;
  bool isVoteAvailable;

  List<bool> selected = List<bool>.filled(5, false, growable: true);
  int numSelected = 0;
  bool canSelect = true;
  //애니메이션은 천천히 생각해보자.

  // voteData를 가져와 voteTodayCard에 넣어 위젯 리스트를 만드는 함수
  void getVoteTodayWidget(VoteModel votesToday) {
    List<Widget> listItems = [];
    print("getVOteTodayWIdget making " + votesToday.subVotes[0].id.toString());
    for (var i = 0; i < votesToday.subVotes.length; i++) {
      // print(votesFromDB.subVotes.length);
      listItems.add(VoteCard(i, votesToday));
    }
    print("forloop done");
    if (!isDisposed) {
      if (this.mounted) {
        setState(() {
          print("setstate done");
          _votesTodayShowing = listItems;
        });
      }
    }
  }

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

  Duration getTimeLeft(VoteSelectViewModel model) {
    DateTime endTime = model.vote.voteEndDateTime.toDate();
    return endTime.difference(DateTime.now());
    // timeLeftArr = diffFinal.split(":");
    // return diffFinal;
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
                fontSize: 18,
                fontWeight: FontWeight.w600,
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
      toastDuration: Duration(seconds: 1, milliseconds: 550),
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
    super.initState();
    fToast = FToast();
    fToast.init(context);
    print("initState Called");

    // _getAllModel = _viewModel.getAllModel(_viewModel.uid);
    // 현재 시간 한국 시간으로 변경
    // _now = DateTime.now().toUtc().add(Duration(hours: 9));
    // _nowToStr = stringDate.format(_now);
    // _nowToStr = "20200901"; //temp for test

    // print(_now.toString() + " and " + _nowToStr);
    print(_getAllModel);
    // 오늘의 주제, 선택된 주제 위젯 만들기 위해 initState에 vote 데이터 db에서 불러옴
    // print("Async start");

    // defines a timer
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {});
    });

    //get this user's UserModel
    // _userModelFuture = _model.getUser(widget.uid);
    print("initState Done");
  }

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
    //   double value = controller.offset / 250;

    //   setState(() {
    //     leftContainer = value;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
    // dispose는 Navigator pushNamed에는 호출되지 않지만 백 버튼에는 호출됨.
    // 백 버튼에 아래를 호출하지 않으면 dispose 됐는데 setState한다고 오류뜸

    _timer.cancel();
    isDisposed = true;
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

  @override
  Widget build(BuildContext context) {
    // print("buildCalled");

    // print(numSelected);
    numSelected = selected.where((item) => item == true).length;

    // print(numSelected);
    return ViewModelBuilder<VoteSelectViewModel>.reactive(
      viewModelBuilder: () => VoteSelectViewModel(),
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        // selected = selected.sublist(0, model.vote.subVotes.length);
        // print(selected);
        // print(model.getNow());
        // print(uid + 'from FutureViewModel');
        if (model.isBusy) {
          return Scaffold(
            body: Center(
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
          );
        } else {
          Duration diff = getTimeLeft(model).inSeconds < 0
              ? Duration(hours: 0, minutes: 0, seconds: 0)
              : getTimeLeft(model);
          String strDurationHM =
              "${diff.inHours.toString().padLeft(2, '0')}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:";
          String strDurationSec =
              "${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
          return Scaffold(
            key: scaffoldKey,
            body: WillPopScope(
              onWillPop: () async {
                _navigatorKey.currentState.maybePop();
                return false;
              },
              child: Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        16,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            children: <Widget>[
                              Container(
                                // padding: EdgeInsets.only(bottom: 40),
                                // color: Colors.green[50],
                                width: double.infinity,
                                // height: deviceHeight * .12,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    RichText(
                                      text: TextSpan(
                                          text: strDurationHM.toString(),
                                          style: TextStyle(
                                            fontFamily: 'Akrhip',
                                            color: diff.inHours < 1
                                                ? Color(0xFFE41818)
                                                : Colors.black,
                                            fontSize: 32,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: -2,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: strDurationSec.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Akrhip',
                                                  color: diff.inHours < 1
                                                      ? Color(0xFFE41818)
                                                      : Color(0xFFC1C1C1),
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w800,
                                                  letterSpacing: -2,
                                                ))
                                          ]),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "예측마감까지 남은 시간",
                                          style: TextStyle(
                                            // fontFamily: 'Akrhip',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        Row(
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
                                                color: Color(0xFF1EC8CF),
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              (model.user.item - numSelected)
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                letterSpacing: -1.0,
                                                fontFamily: 'DmSans',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
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
                              SizedBox(
                                height: 16,
                              ),
                              Expanded(
                                  child: Container(
                                // color: Colors.black,
// child: SingleChildScrollView(
//                                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                                 physics: BouncingScrollPhysics(
//                                     // android에서도 스크롤 많이 했을 때 바운스 생기게
//                                     parent: AlwaysScrollableScrollPhysics()),
//                                 // physics: (),
//                                 child: Container(
                                // height: 550,
                                child: ListView.builder(
                                    // physics: NeverScrollableScrollPhysics(),
                                    itemCount: model.vote.voteCount,
                                    itemBuilder: (context, index) {
                                      return buildStack(
                                        model,
                                        index,
                                        context,
                                        numSelected,
                                        scaffoldKey,
                                        diff,
                                      );
                                    }),
                              )),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: ((numSelected == 0) ||
                                      (model.userVote == null
                                          ? false
                                          : (diff.inSeconds == 0 ||
                                              model.userVote.isVoted)))
                                  ? () {}
                                  : () {
                                      for (int i = 0;
                                          i < selected.length;
                                          i++) {
                                        selected[i] == true
                                            ? listSelected.add(i)
                                            : 0;
                                      }

                                      _navigationService
                                          .navigateWithArgTo('ggook', [
                                        model.address,
                                        model.user,
                                        model.vote,
                                        listSelected,
                                        0,
                                      ]);
                                    },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                height: 56,
                                decoration: BoxDecoration(
                                    color: (diff.inSeconds == 0 ||
                                            model.userVote.isVoted)
                                        ? Color(0xFFC1C1C1)
                                        : Colors.black,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.1),
                                        offset: new Offset(0, 4.0),
                                        blurRadius: 8.0,
                                      )
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(
                                      40,
                                    ))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "예측하러 가기",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFFFFFFFFF),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFF666666),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 48,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: (diff.inSeconds == 0 ||
                                        model.userVote.isVoted)
                                    ? Color(0xFFE41818)
                                    : numSelected == 0
                                        ? Color(0xFFFFDE34)
                                        : Color(0xFF1EC8CF),
                              ),
                              child: Text(
                                  diff.inSeconds == 0
                                      ? "오늘의 예측이 마감되었습니다."
                                      : model.userVote.isVoted
                                          ? "이미 오늘 예측에 참여하였습니다."
                                          : numSelected == 0
                                              ? "최대 3개의 주제를 선택하여 승점에 도전해보세요!"
                                              : "선택한 주제 $numSelected개, 승점 $numSelected점에 도전해보세요!",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'DmSans',
                                    fontWeight: FontWeight.w500,
                                    color: (diff.inSeconds == 0 ||
                                            model.userVote.isVoted)
                                        ? Colors.white
                                        : numSelected == 0
                                            ? Colors.black
                                            : Colors.white,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  model.voteSelectTutorial
                      ? Container()
                      : model.tutorialStatus != 0
                          ? tutorial(model)
                          : Container(),
                ],
              ),
            ),
          );
        }

        //  buildScaffold(model, displayRatio, size, userVote,
        //         address, user, vote);
      },
    );
  }

  Widget buildStack(
    VoteSelectViewModel model,
    int idx,
    BuildContext context,
    int numSelected,
    GlobalKey<ScaffoldState> scaffoldKey,
    Duration diff,
  ) {
    int numOfChoices = model.vote.subVotes[idx].issueCode.length;
    Color hexToColor(String code) {
      return Color(int.parse(code, radix: 16) + 0xFF0000000);
    }

    if (numOfChoices == 1) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
            0, 4, 0, idx == model.vote.voteCount - 1 ? 76 : 4),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: GestureDetector(
                onTap: () {
                  buildModalBottomSheet(
                      context, hexToColor, model, idx, numOfChoices, diff);
                },
                child: Container(
                  height: 100,

                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(10, 0, 6, 0),
                  decoration: BoxDecoration(
                    color: model.userVote.isVoted
                        ? model.userVote.voteSelected[idx] == 0
                            ? Colors.white
                            : model.userVote.voteSelected[idx] == 1
                                ? Color(0xFFFF3E3E)
                                : model.userVote.voteSelected[idx] == 2
                                    ? Color(0xFF3485FF)
                                    : Colors.white
                        : selected[idx]
                            ? hexToColor(
                                model.vote.subVotes[idx].colorCode[0],
                              )
                            : Colors.white,
                    borderRadius: BorderRadius.circular(
                        model.vote.subVotes[idx].shape[0] == 'oval' ? 50 : 0),
                    border: Border.all(
                      width: 4.0,
                      color: model.userVote.isVoted
                          ? model.userVote.voteSelected[idx] == 0
                              ? Color(0xFFC1C1C1)
                              : model.userVote.voteSelected[idx] == 1
                                  ? Colors.black
                                  : model.userVote.voteSelected[idx] == 2
                                      ? Colors.black
                                      : Color(0xFFC1C1C1)
                          : selected[idx]
                              ? Colors.black
                              : Color(0xFFC1C1C1),
                    ),
                    // borderRadius: BorderRadius.all(
                    //     Radius.circular(30)),
                  ),
                  // color: Colors.redAccent,
                  // child: Baseline(
                  //   baseline: 28,
                  //   baselineType: TextBaseline.ideographic,
                  child: Text(
                    model.vote.subVotes[idx].title,
                    style: TextStyle(
                      // textBaseline: TextBaseline.alphabetic,
                      color: model.userVote.isVoted
                          ? model.userVote.voteSelected[idx] == 0
                              ? Color(0xFFC1C1C1)
                              : model.userVote.voteSelected[idx] == 1
                                  ? Colors.black
                                  : model.userVote.voteSelected[idx] == 2
                                      ? Colors.black
                                      : Color(0xFFC1C1C1)
                          : selected[idx]
                              ? Colors.black
                              : Color(0xFFC1C1C1),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                ),
              ),
            ),
            Transform.scale(
              scale: 1.6,
              child: CircularCheckBox(
                  key: UniqueKey(),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  visualDensity: VisualDensity(horizontal: 2, vertical: 0),
                  value: selected[idx],
                  hoverColor: Colors.white,
                  activeColor: (diff.inSeconds == 0 || model.userVote.isVoted)
                      ? Color(0xFFC1C1C1)
                      : Color(0xFF1EC8CF),
                  inactiveColor: (diff.inSeconds == 0 || model.userVote.isVoted)
                      ? Color(0xFFC1C1C1)
                      : Color(0xFF1EC8CF),
                  // disabledColor: Colors.grey,
                  onChanged: (newValue) {
                    (diff.inSeconds == 0)
                        ? _showToast(
                            "오늘 예측이 마감되었습니다.\n커뮤니티에서 실시간 대결 상황을\n살펴보세요!")
                        : (model.userVote.isVoted)
                            ? _showToast("이미 오늘 예측에 참여하였습니다.")
                            : setState(() {
                                print(model.seasonInfo.maxDailyVote -
                                    numSelected);
                                if (model.seasonInfo.maxDailyVote -
                                        numSelected ==
                                    0) {
                                  if (newValue) {
                                    selected[idx] = selected[idx];
                                    _showToast(
                                        "하루 최대 ${model.seasonInfo.maxDailyVote}개 주제를 예측할 수 있습니다.");
                                  } else {
                                    selected[idx] = newValue;
                                  }
                                } else {
                                  if (model.user.item - numSelected == 0) {
                                    // 선택되면 안됨
                                    if (newValue) {
                                      selected[idx] = selected[idx];

                                      _showToast("보유 중인 아이템이 부족합니다.");
                                    } else {
                                      selected[idx] = newValue;
                                    }
                                  } else {
                                    selected[idx] = newValue;
                                  }
                                }
                              });
                  }),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.fromLTRB(
            0, 4, 0, idx == model.vote.voteCount - 1 ? 76 : 4),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: GestureDetector(
                onTap: () {
                  buildModalBottomSheet(
                      context, hexToColor, model, idx, numOfChoices, diff);
                },
                child: Container(
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(10, 0, 6, 0),
                              decoration: BoxDecoration(
                                color: model.userVote.isVoted
                                    ? model.userVote.voteSelected[idx] == 0
                                        ? Colors.white
                                        : model.userVote.voteSelected[idx] == 1
                                            ? hexToColor(model.vote
                                                .subVotes[idx].colorCode[0])
                                            : Colors.white
                                    : selected[idx]
                                        ? hexToColor(model
                                            .vote.subVotes[idx].colorCode[0])
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(
                                    model.vote.subVotes[idx].shape[0] == 'oval'
                                        ? 50
                                        : 0),
                                border: Border.all(
                                  width: 4.0,
                                  color: model.userVote.isVoted
                                      ? model.userVote.voteSelected[idx] == 0
                                          ? Color(0xFFC1C1C1)
                                          : model.userVote.voteSelected[idx] ==
                                                  1
                                              ? Colors.black
                                              : Color(0xFFC1C1C1)
                                      : selected[idx]
                                          ? Colors.black
                                          : Color(0xFFC1C1C1),
                                ),
                                // borderRadius: BorderRadius.all(
                                //     Radius.circular(30)),
                              ),
                              child: Text(
                                  model.vote.subVotes[idx].voteChoices[0],
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: model.vote.subVotes[idx]
                                                .voteChoices[0].length >
                                            5
                                        ? 22
                                        : 24,
                                    fontWeight: FontWeight.bold,
                                    color: model.userVote.isVoted
                                        ? model.userVote.voteSelected[idx] == 0
                                            ? Color(0xFFC1C1C1)
                                            : model.userVote
                                                        .voteSelected[idx] ==
                                                    1
                                                ? Colors.black
                                                : Color(0xFFC1C1C1)
                                        : selected[idx]
                                            ? Colors.black
                                            : Color(0xFFC1C1C1),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(10, 0, 6, 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    model.vote.subVotes[idx].shape[1] == 'oval'
                                        ? 50
                                        : 0),
                                color: model.userVote.isVoted
                                    ? model.userVote.voteSelected[idx] == 0
                                        ? Colors.white
                                        : model.userVote.voteSelected[idx] == 2
                                            ? hexToColor(model.vote
                                                .subVotes[idx].colorCode[1])
                                            : Colors.white
                                    : selected[idx]
                                        ? hexToColor(model
                                            .vote.subVotes[idx].colorCode[1])
                                        : Colors.white,
                                border: Border.all(
                                  width: 4.0,
                                  color: model.userVote.isVoted
                                      ? model.userVote.voteSelected[idx] == 0
                                          ? Color(0xFFC1C1C1)
                                          : model.userVote.voteSelected[idx] ==
                                                  2
                                              ? Colors.black
                                              : Color(0xFFC1C1C1)
                                      : selected[idx]
                                          ? Colors.black
                                          : Color(0xFFC1C1C1),
                                ),
                                // borderRadius: BorderRadius.all(
                                //     Radius.circular(30)),
                              ),
                              child: Text(
                                  model.vote.subVotes[idx].voteChoices[1],
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                    fontSize: model.vote.subVotes[idx]
                                                .voteChoices[1].length >
                                            5
                                        ? 22
                                        : 24,
                                    fontWeight: FontWeight.bold,
                                    color: model.userVote.isVoted
                                        ? model.userVote.voteSelected[idx] == 0
                                            ? Color(0xFFC1C1C1)
                                            : model.userVote
                                                        .voteSelected[idx] ==
                                                    2
                                                ? Colors.black
                                                : Color(0xFFC1C1C1)
                                        : selected[idx]
                                            ? Colors.black
                                            : Color(0xFFC1C1C1),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selected[idx]
                                ? Colors.black
                                : Color(0xFFC1C1C1),
                            width: 4.0,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            40,
                          ),
                        ),
                        child: Text("vs",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selected[idx]
                                  ? Colors.black
                                  : Color(0xFFC1C1C1),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              child: Transform.scale(
                scale: 1.6,
                child: CircularCheckBox(
                    key: UniqueKey(),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    visualDensity: VisualDensity(horizontal: 1, vertical: 0),
                    value: selected[idx],
                    checkColor: Colors.white,
                    activeColor: (diff.inSeconds == 0 || model.userVote.isVoted)
                        ? Color(0xFFC1C1C1)
                        : Color(0xFF1EC8CF),
                    inactiveColor:
                        (diff.inSeconds == 0 || model.userVote.isVoted)
                            ? Color(0xFFC1C1C1)
                            : Color(0xFF1EC8CF),
                    disabledColor: Colors.grey,
                    onChanged: (newValue) {
                      (diff.inSeconds == 0)
                          ? _showToast(
                              "오늘 예측이 마감되었습니다.\n커뮤니티에서 실시간 대결 상황을\n살펴보세요!")
                          : (model.userVote.isVoted)
                              ? _showToast("이미 오늘 예측에 참여하였습니다.")
                              : setState(() {
                                  print(model.seasonInfo.maxDailyVote -
                                      numSelected);
                                  if (model.seasonInfo.maxDailyVote -
                                          numSelected ==
                                      0) {
                                    if (newValue) {
                                      selected[idx] = selected[idx];
                                      _showToast(
                                          "하루 최대 ${model.seasonInfo.maxDailyVote}개 주제를 예측할 수 있습니다.");
                                    } else {
                                      selected[idx] = newValue;
                                    }
                                  } else {
                                    if (model.user.item - numSelected == 0) {
                                      // 선택되면 안됨
                                      if (newValue) {
                                        selected[idx] = selected[idx];
                                        _showToast("보유 중인 아이템이 부족합니다.");
                                      } else {
                                        selected[idx] = newValue;
                                      }
                                    } else {
                                      selected[idx] = newValue;
                                    }
                                  }
                                });
                    }),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future buildModalBottomSheet(
    BuildContext context,
    Color hexToColor(String code),
    VoteSelectViewModel model,
    int idx,
    int numOfChoices,
    Duration diff,
  ) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (
        context,
      ) =>
          Padding(
        padding: const EdgeInsets.fromLTRB(
          16.0,
          32,
          16,
          32,
        ),
        child: Container(
          color: Colors.white,
          // height: double.maxFinite,
          // constraints: BoxConstraints(
          //   // maxHeight: 400,
          // ),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
                child: Row(
                  children: [
                    numOfChoices == 1
                        ? Container(
                            constraints: BoxConstraints(
                              maxHeight: 48,
                              minWidth: 100,
                            ),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                            decoration: BoxDecoration(
                              color: hexToColor(
                                model.vote.subVotes[idx].colorCode[0],
                              ),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                width: 4.0,
                                color: Color(0xFF000000),
                              ),
                              // borderRadius: BorderRadius.all(
                              //     Radius.circular(30)),
                            ),
                            // color: Colors.redAccent,
                            child: Text(
                              model.vote.subVotes[idx].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                textBaseline: TextBaseline.ideographic,
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxHeight: 48,
                                  // minWidth: 100,
                                ),
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                decoration: BoxDecoration(
                                  color: hexToColor(
                                    model.vote.subVotes[idx].colorCode[0],
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    width: 4.0,
                                    color: Color(0xFF000000),
                                  ),
                                  // borderRadius: BorderRadius.all(
                                  //     Radius.circular(30)),
                                ),
                                // color: Colors.redAccent,
                                child: Text(
                                  model.vote.subVotes[idx].voteChoices[0],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    textBaseline: TextBaseline.ideographic,
                                    color: Colors.black,
                                    fontSize: model.vote.subVotes[idx]
                                                .voteChoices[0].length <
                                            6
                                        ? 22
                                        : 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Stack(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxHeight: 48,
                                      // minWidth: 100,
                                    ),
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    decoration: BoxDecoration(
                                      color: hexToColor(
                                        model.vote.subVotes[idx].colorCode[1],
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        width: 4.0,
                                        color: Color(0xFF000000),
                                      ),
                                      // borderRadius: BorderRadius.all(
                                      //     Radius.circular(30)),
                                    ),
                                    // color: Colors.redAccent,
                                    child: Text(
                                      model.vote.subVotes[idx].voteChoices[1],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        textBaseline: TextBaseline.ideographic,
                                        color: Colors.black,
                                        fontSize: model.vote.subVotes[idx]
                                                    .voteChoices[1].length <
                                                6
                                            ? 22
                                            : 18,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  AlignPositioned.expand(
                                    alignment: Alignment.centerLeft,
                                    dx: -4,
                                    moveByChildWidth: -0.5,
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 4.0,
                                          ),
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            40,
                                          )),
                                      child: Text("vs",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
              // Expanded(child: SizedBox()),

              Text(
                model.vote.subVotes[idx].selectDescription,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.0,
                ),
                maxLines: 2,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: Text(
                  "현재 ${model.vote.subVotes[idx].numVoted0 + model.vote.subVotes[idx].numVoted1}명이 이 주제를 예측하였습니다",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'DmSans',
                    color: Color(0xFF1EC8CF),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
                child: Wrap(
                  spacing: 6,
                  runSpacing: -5,
                  direction: Axis.horizontal,
                  children: buildChip(hexToColor, model, idx, numOfChoices),
                  // Container(
                  //   alignment: Alignment.center,
                  //   padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                  //   decoration: BoxDecoration(
                  //     color: hexToColor(
                  //       model.vote.subVotes[idx].colorCode[0],
                  //     ),
                  //     borderRadius: BorderRadius.circular(50),
                  //   ),
                  //   child: Text(
                  //     "시총 0.9조",
                  //     style: TextStyle(
                  //       fontSize: 16,
                  //       fontFamily: 'DmSans',
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  // ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: <Widget>[
                  (!selected[idx])
                      ? Container()
                      : Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                selected[idx] = false;
                              });
                              Navigator.of(context).pop();
                            },
                            color: Color(0xFF0F6669),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 14,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (model.userVote.isVoted || diff.inSeconds == 0)
                                    ? SizedBox()
                                    : Icon(
                                        Icons.cancel_outlined,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                SizedBox(width: 8),
                                Text("해제하기",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                  (selected[idx])
                      ? Container()
                      : Expanded(
                          child: RaisedButton(
                            onPressed: () {
                              (model.userVote.isVoted || diff.inSeconds == 0)
                                  ? {}
                                  : setState(() {
                                      if (model.seasonInfo.maxDailyVote -
                                              numSelected ==
                                          0) {
                                        _showToast(
                                            "하루 최대 ${model.seasonInfo.maxDailyVote}개 주제를 예측할 수 있습니다.");
                                      } else {
                                        if (model.user.item - numSelected ==
                                            0) {
                                          // 선택되면 안됨

                                          _showToast("보유 중인 아이템이 부족합니다.");
                                        } else {
                                          selected[idx] = true;
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    });
                            },
                            color:
                                (model.userVote.isVoted || diff.inSeconds == 0)
                                    ? Color(0xFFE4E4E4)
                                    : Color(0xFF1EC8CF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 14,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (model.userVote.isVoted || diff.inSeconds == 0)
                                    ? SizedBox()
                                    : SvgPicture.asset(
                                        'assets/icons/double_check_icon.svg',
                                        width: 20,
                                      ),
                                (model.userVote.isVoted || diff.inSeconds == 0)
                                    ? SizedBox()
                                    : SizedBox(width: 8),
                                Text(
                                    model.userVote.isVoted
                                        ? "이미 오늘 예측에 참여하였습니다."
                                        : diff.inSeconds == 0
                                            ? "오늘 예측이 마감되었습니다."
                                            : "선택하기",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: (model.userVote.isVoted ||
                                              diff.inSeconds == 0)
                                          ? Colors.black
                                          : Colors.white,
                                      fontFamily: 'DmSans',
                                      fontWeight: FontWeight.w700,
                                    )),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}

Widget tutorial(VoteSelectViewModel model) {
  return GestureDetector(
    onTap: () {
      model.tutorialStepProgress();
    },
    child: SafeArea(
      child: (model.tutorialStatus - model.tutorialTotalStep == 0)
          ? Stack(
              children: [
                Container(
                  width: deviceWidth,
                  height: deviceHeight,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.amber),
                      color: Colors.black38),
                ),
                Column(
                  children: [
                    Text('1A가',
                        style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'DmSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.transparent)),
                    Text('1A가',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'DmSans',
                            color: Colors.transparent)),
                    SizedBox(
                      height: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(
                            '예측하고 싶은 주제를 선택하는 화면이에요. \n작은 원을 눌러 최대 3개의 주제까지 선택가능해요!',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE81B1B),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset:
                                    Offset(1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                        Container(),
                      ],
                    ),
                  ],
                )
              ],
            )
          : Stack(
              children: [
                Container(
                  width: deviceWidth,
                  height: deviceHeight,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.amber),
                      color: Colors.black38),
                ),
                Column(
                  children: [
                    Text('1A가',
                        style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'DmSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.transparent)),
                    Text('1A가',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'DmSans',
                            color: Colors.transparent)),
                    SizedBox(
                      height: 130,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Text(
                            '종목을 눌러 주제에 대한 간단한 설명을 볼 수 있어요!',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE81B1B),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset:
                                    Offset(1, 1), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                        Container(),
                      ],
                    ),
                  ],
                )
              ],
            ),
    ),
  );
}
