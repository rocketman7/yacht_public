import 'dart:async';

import 'package:align_positioned/align_positioned.dart';
import 'package:circular_check_box/circular_check_box.dart';
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
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/price_model.dart';
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
import 'chart_view.dart';

class VoteSelectV2View extends StatefulWidget {
  @override
  _VoteSelectV2ViewState createState() => _VoteSelectV2ViewState();
}

class _VoteSelectV2ViewState extends State<VoteSelectV2View> {
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
    print("SELECTED " + selected.toString());
    // print("buildCalled");

    // print(numSelected);
    numSelected = selected.where((item) => item == true).length;
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
              body: model.isFirstLoading()
                  ? Container(
                      height: deviceHeight,
                      width: deviceWidth,
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
                    )
                  : Container());
        } else {
          print("IS VOTING ?? " + isVoting.toString());
          Duration diff = getTimeLeft(model).inSeconds < 0
              ? Duration(hours: 0, minutes: 0, seconds: 0)
              : getTimeLeft(model);
          String strDurationHM =
              "${diff.inHours.toString().padLeft(2, '0')}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:";
          String strDurationSec =
              "${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
          return Scaffold(
            backgroundColor: Color(0xFF1EC8CF),
            key: scaffoldKey,
            body: WillPopScope(
              onWillPop: () async {
                _navigatorKey.currentState.maybePop();
                return false;
              },
              child: Stack(
                children: [
                  SafeArea(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                16.w,
                                // 16.h,
                                0,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(
                                        Icons.dehaze_rounded,
                                        size: 32.sp,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          // color: Colors.yellow,
                                          child: Row(
                                            // crossAxisAlignment:
                                            //     CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Container(
                                                // color: Colors.red,
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      'assets/icons/trophy.png',
                                                      // color: Colors.red,
                                                      height: 70,
                                                      width: 70,
                                                    ),
                                                    Text(
                                                      "시즌 1",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'AppleSDL',
                                                          fontSize: 16,
                                                          letterSpacing: -1.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 16,
                                              ),
                                              Container(
                                                // color: Colors.red,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "지금 노릴 수 있는 우승 상금은?",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'AppleSDL',
                                                          fontSize: 16,
                                                          letterSpacing: -1.5),
                                                    ),
                                                    SizedBox(height: 12),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "2,921,300",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'DmSans',
                                                            fontSize: 42,
                                                            height: 1,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "원",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'AppleSDM',
                                                            fontSize: 24,
                                                            height: 1,
                                                            // fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          // color: Color(0xFFFFF5F5),
                                                          size: 24.sp,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 28,
                                        ),
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
                                    Text(
                                      "11월 14일 예측 주제",
                                      style: TextStyle(
                                        fontFamily: 'AppleSDB',
                                        fontSize: 24,
                                        height: 1,
                                        // fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "예측 마감까지",
                                          style: TextStyle(
                                            fontFamily: 'AppleSDM',
                                            fontSize: 16.sp,

                                            // fontWeight: FontWeight.w500,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        Text(
                                          "남은 예측 기회",
                                          style: TextStyle(
                                            fontFamily: 'AppleSDM',
                                            fontSize: 16.sp,

                                            // fontWeight: FontWeight.w500,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TopContainer(model, checkVoteTime),
                                        Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
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
                                              (model.user.item - numSelected)
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 26.sp,
                                                letterSpacing: -1.0,
                                                fontFamily: 'DmSans',
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        // height: 300,
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
                        Positioned(
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
                                    for (int i = 0; i < selected.length; i++) {
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
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 10,
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.w,
                                ),
                                height: 70.h,
                                decoration: BoxDecoration(
                                    color:
                                        // (model.address.isVoting == false ||
                                        //         model.userVote.isVoted)
                                        // ? Color(0xFFC1C1C1)
                                        // : Colors.black,
                                        Color(0xFF1EC8CF),
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
                                      40,
                                    ))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "예측하러 가기",
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontFamily: 'AppleSDEB',
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
                        ),
                        Positioned(
                          bottom: 60,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.h,
                              vertical: 4.w,
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
                            child: Text(
                                model.address.isVoting == false
                                    ? "오늘의 예측이 마감되었습니다."
                                    : numSelected == 0
                                        ? "최대 3개의 주제를 선택하여 승점에 도전해보세요!"
                                        : "선택한 주제 $numSelected개, 승점 ${numSelected * 2}점에 도전해보세요!",
                                style: TextStyle(
                                  fontSize: numSelected == 0 ? 14.sp : 16.sp,
                                  fontFamily: 'AppleSDB',
                                  height: 1.2.h,
                                  // fontWeight: FontWeight.w500,
                                  color: (model.address.isVoting == false)
                                      ? Colors.white
                                      : numSelected == 0
                                          ? Colors.black
                                          : Color(0xFFFFF5F1),
                                )),
                          ),
                        ),
                      ],
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
    var formatReturnPct = NumberFormat("0.00%");
    var formatPrice = NumberFormat("#,###");
    int numOfChoices = model.vote.subVotes[idx].issueCode.length;
    Color hexToColor(String code) {
      return Color(int.parse(code, radix: 16) + 0xFF0000000);
    }

    TextStyle voteTitle = TextStyle(
      color: Colors.black,
      fontFamily: 'AppleSDM',
      fontSize: 24.sp,
      height: 1,
    );

    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0.0.w),
              child: GestureDetector(
                onTap: () {
                  // buildModalBottomSheet(
                  //     context, hexToColor, model, idx, numOfChoices, diff);
                  callNewModalBottomSheet(
                      context, hexToColor, model, idx, numOfChoices, diff);
                },
                child: Container(
                  color: Colors.white.withOpacity(0),
                  // color: Colors.red,
                  height: 75,
                  // decoration: BoxDecoration(border: Border.all(width: 0.3)),
                  child: Padding(
                    padding: EdgeInsets.only(left: 50),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        numOfChoices == 1
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    model.vote.subVotes[idx].title,
                                    style: voteTitle,
                                  ),
                                  model.address.isVoting
                                      ? Container()
                                      : StreamBuilder(
                                          stream: model.getRealtimePrice(
                                              model.address,
                                              model.vote.subVotes[idx]
                                                  .issueCode[0]),
                                          builder: (context, snapshot) {
                                            if (snapshot.data == null) {
                                              return Center(child: Container());
                                            } else {
                                              PriceModel price0;
                                              price0 = snapshot.data;
                                              return price0.pricePctChange < 0
                                                  ? Text(
                                                      formatPrice
                                                              .format(
                                                                  price0.price)
                                                              .toString() +
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
                                                      formatPrice
                                                              .format(
                                                                  price0.price)
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
                                                      ),
                                                    );
                                            }
                                          },
                                        )
                                ],
                              )
                            : Expanded(
                                child: Row(
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
                                          style: voteTitle,
                                        ),
                                        model.address.isVoting
                                            ? Container()
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
                                    Text(
                                      "VS",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'AppleSDM',
                                        fontSize: 24.sp,
                                        height: 1,
                                      ),
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
                                          style: voteTitle,
                                        ),
                                        model.address.isVoting
                                            ? Container()
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
            Divider(
              thickness: 1.5,
              height: 0.2,
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
        Container(
          // color: Colors.red,
          child: Transform.scale(
            scale: 1.2.w,
            child: CircularCheckBox(
                key: UniqueKey(),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                visualDensity: VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
                value: selected[idx],
                hoverColor: Colors.white,
                activeColor: (model.address.isVoting == false)
                    ? Color(0xFFC1C1C1)
                    : Color(0xFF1EC8CF),
                inactiveColor: (model.address.isVoting == false)
                    ? Color(0xFFC1C1C1)
                    : Color(0xFF1EC8CF),
                // disabledColor: Colors.grey,
                onChanged: (newValue) {
                  (model.address.isVoting == false)
                      ? _showToast("오늘 예측이 마감되었습니다.\n커뮤니티에서 실시간 대결 상황을\n살펴보세요!")
                      : setState(() {
                          print(model.seasonInfo.maxDailyVote - numSelected);
                          if (model.seasonInfo.maxDailyVote - numSelected ==
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
    );
  }

  Future callNewModalBottomSheet(
    BuildContext context,
    Color hexToColor(String code),
    VoteSelectViewModel model,
    int idx,
    int numOfChoices,
    Duration diff,
  ) {
    ScrollController controller;
    StreamController scrollStreamCtrl = StreamController<double>();
    return showModalBottomSheet(
        backgroundColor: Colors.white,
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
                  if (offset < -10) {
                    // Navigator.pop(context);
                  }
                  print(snapshot.data);
                  return Container(
                    height: deviceHeight * .83,
                    // height: 250 + offset * 1.4,
                    child: ChartView(
                      // controller,
                      scrollStreamCtrl,
                    ),
                  );
                }));
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
                                (model.address.isVoting == false)
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
                              (model.address.isVoting == false)
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
                            color: (model.address.isVoting == false)
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
                                (model.address.isVoting == false)
                                    ? SizedBox()
                                    : SvgPicture.asset(
                                        'assets/icons/double_check_icon.svg',
                                        width: 20,
                                      ),
                                (model.address.isVoting == false)
                                    ? SizedBox()
                                    : SizedBox(width: 8),
                                Text(
                                    model.address.isVoting == false
                                        ? "오늘 예측이 마감되었습니다."
                                        : "선택하기",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: (model.address.isVoting == false)
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

class TopContainer extends StatefulWidget {
  final VoteSelectViewModel model;
  final Function checkVoteTime;
  TopContainer(
    this.model,
    this.checkVoteTime,
  );
  @override
  _TopContainerState createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {
  Timer _timer;
  VoteSelectViewModel model;

  Duration getTimeLeft(VoteSelectViewModel model) {
    DateTime endTime = model.vote.voteEndDateTime.toDate();
    return endTime.difference(DateTime.now());
    // timeLeftArr = diffFinal.split(":");
    // return diffFinal;
  }

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
    // defines a timer
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      // print("TIMER");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    model = widget.model;
    Duration diff = getTimeLeft(model).inSeconds < 0
        ? Duration(hours: 0, minutes: 0, seconds: 0)
        : getTimeLeft(model);
    String strDurationHM =
        "${diff.inHours.toString().padLeft(2, '0')}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:";
    String strDurationSec =
        "${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}";

    // if (diff.inSeconds == 0) {
    //   _timer.cancel();
    //   Future.delayed(Duration(seconds: 1));
    //   // widget.checkVoteTime();
    //   // model.isVoteAvailable();
    // }
    return RichText(
      text: TextSpan(
          text: strDurationHM.toString(),
          style: TextStyle(
            fontFamily: 'DmSans',
            color: diff.inHours < 1 ? Color(0xFFE41818) : Colors.black,
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -.5,
          ),
          children: <TextSpan>[
            TextSpan(
                text: strDurationSec.toString(),
                style: TextStyle(
                  fontFamily: 'DmSans',
                  color:
                      diff.inHours < 1 ? Color(0xFFE41818) : Color(0xFFC1C1C1),
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -.5,
                ))
          ]),
    );
  }
}
