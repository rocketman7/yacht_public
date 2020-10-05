import 'dart:async';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:stacked/stacked.dart';

import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/temp_address_constant.dart';
import 'package:yachtOne/models/user_vote_model.dart';
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

  // 위젯 생성 함수와 PageController의 리스터를 이니셜라이징
  // controller의 offset 수치를 listen하여 수식을 통해 value를 계산하고
  // setState로 반영하여 계속 리빌드 시킨다
  @override
  void initState() {
    super.initState();
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
    print("buildCalled");
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;
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
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
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
                                      ? Colors.red
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
                                            ? Colors.red
                                            : Color(0xFFC1C1C1),
                                        fontSize: 32,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -2,
                                      ))
                                ]),
                          ),
                          Text(
                            "예측마감까지 남은 시간",
                            style: TextStyle(
                              // fontFamily: 'Akrhip',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 26,
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
                              scaffoldKey,
                            );
                          }),
                    )),
                    GestureDetector(
                      onTap: ((selected.where((item) => item == true).length ==
                                  0) ||
                              (model.userVote == null
                                  ? false
                                  : model.userVote.isVoted == true))
                          ? () {}
                          : () {
                              for (int i = 0; i < selected.length; i++) {
                                selected[i] == true ? listSelected.add(i) : 0;
                              }

                              _navigationService.navigateWithArgTo('ggook', [
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
                            color: Colors.black,
                            boxShadow: [
                              new BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                offset: new Offset(0, 4.0),
                                blurRadius: 8.0,
                              )
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(
                              40,
                            ))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget buildStack(
    VoteSelectViewModel model,
    int idx,
    BuildContext context,
    scaffoldKey,
  ) {
    int numOfChoices = model.vote.subVotes[idx].issueCode.length;
    Color hexToColor(String code) {
      return Color(int.parse(code, radix: 16) + 0xFF0000000);
    }

    if (numOfChoices == 1) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: GestureDetector(
                onTap: () {
                  buildModalBottomSheet(
                      context, hexToColor, model, idx, numOfChoices);
                },
                child: Container(
                  height: 100,

                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(10, 0, 6, 0),
                  decoration: BoxDecoration(
                    color: selected[idx]
                        ? hexToColor(
                            model.vote.subVotes[idx].colorCode[0],
                          )
                        : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 4.0,
                      color: selected[idx] ? Colors.black : Color(0xFFC1C1C1),
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
                      color: selected[idx] ? Colors.black : Color(0xFFC1C1C1),
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
                materialTapTargetSize: MaterialTapTargetSize.padded,
                visualDensity: VisualDensity(horizontal: 2, vertical: 0),
                value: selected[idx],
                hoverColor: Colors.white,
                activeColor: Color(0xFF1EC8CF),
                inactiveColor: Color(0xFF1EC8CF),
                disabledColor: Colors.grey,
                onChanged: (val) => this.setState(() {
                  this.selected[idx] = !this.selected[idx];
                }),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: GestureDetector(
                onTap: () {
                  buildModalBottomSheet(
                      context, hexToColor, model, idx, numOfChoices);
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
                                color: selected[idx]
                                    ? hexToColor(
                                        model.vote.subVotes[idx].colorCode[0],
                                      )
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  width: 4.0,
                                  color: selected[idx]
                                      ? Colors.black
                                      : Color(0xFFC1C1C1),
                                ),
                                // borderRadius: BorderRadius.all(
                                //     Radius.circular(30)),
                              ),
                              child:
                                  Text(model.vote.subVotes[idx].voteChoices[0],
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
                                        color: selected[idx]
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
                                color: selected[idx]
                                    ? hexToColor(
                                        model.vote.subVotes[idx].colorCode[1],
                                      )
                                    : Colors.white,
                                border: Border.all(
                                  width: 4.0,
                                  color: selected[idx]
                                      ? Colors.black
                                      : Color(0xFFC1C1C1),
                                ),
                                // borderRadius: BorderRadius.all(
                                //     Radius.circular(30)),
                              ),
                              child:
                                  Text(model.vote.subVotes[idx].voteChoices[1],
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
                                        color: selected[idx]
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
                  activeColor: Color(0xFF1EC8CF),
                  inactiveColor: Color(0xFF1EC8CF),
                  disabledColor: Colors.grey,
                  onChanged: (val) => this.setState(() {
                    this.selected[idx] = !this.selected[idx];
                  }),
                ),
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
                        : Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight: 48,
                                        minWidth: 100,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                                          textBaseline:
                                              TextBaseline.ideographic,
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
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight: 48,
                                        minWidth: 100,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                                          textBaseline:
                                              TextBaseline.ideographic,
                                          color: Colors.black,
                                          fontSize: model.vote.subVotes[idx]
                                                      .voteChoices[1].length <
                                                  6
                                              ? 22
                                              : 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  left: model.vote.subVotes[idx].voteChoices[0]
                                              .length <
                                          6
                                      ? model.vote.subVotes[idx].voteChoices[0]
                                                  .length *
                                              18.0 +
                                          16 +
                                          14
                                      : model.vote.subVotes[idx].voteChoices[0]
                                                  .length *
                                              15.0 +
                                          16 +
                                          14,
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
                              ]),
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
                  letterSpacing: -2.0,
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
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        selected[idx] = false;
                      });
                    },
                    color: Color(0xFFE4E4E4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    child: Text("해제",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'DmSans',
                          fontWeight: FontWeight.w700,
                        )),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          selected[idx] = true;
                        });
                      },
                      color: Color(0xFF1EC8CF),
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
                          SvgPicture.asset(
                            'assets/icons/double_check_icon.svg',
                            width: 20,
                          ),
                          SizedBox(width: 8),
                          Text("선택하기",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
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
