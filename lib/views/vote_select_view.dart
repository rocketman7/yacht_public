import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:preload_page_view/preload_page_view.dart';
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
  final String uid;
  VoteSelectView(this.uid);
  @override
  _VoteSelectViewState createState() => _VoteSelectViewState();
}

class _VoteSelectViewState extends State<VoteSelectView> {
  final NavigationService _navigationService = locator<NavigationService>();

  VoteSelectViewModel _model = VoteSelectViewModel();
  Future<dynamic> _userModelFuture;

  PreloadPageController _preloadPageController = PreloadPageController();
  // double leftContainer = 0;

  // Votes for Today 영역 위젯 관리
  List<Widget> _votesTodayShowing = [];
  List<Widget> _votesTodayNotShowing = [];

  // Votes Selected 영역 위젯 관리
  List<Widget> _votesSelectedShowing = [];
  List<Widget> _votesSelectedNotShowing = [];

  // 최종 선택한 주제 index
  List<int> selectedFinal = [];
  List<String> timeLeftArr = ["", "", ""]; // 시간, 분, 초 array

  // DB에서 가져온 데이터를 VoteModel에 넣은 Object
  // final VoteModel votes = voteToday;

  VoteModel _voteFromDB;

  DateTime _now;
  var stringDate = DateFormat("yyyyMMdd");
  var stringDateWithDash = DateFormat("yyyy-MM-dd");
  String _nowToStr;

  bool isVoteAvailable;

  Timer _everySecond;

  //애니메이션은 천천히 생각해보자.

  // voteData를 가져와 voteTodayCard에 넣어 위젯 리스트를 만드는 함수
  void getVoteTodayWidget(VoteModel votesToday) {
    List<Widget> listItems = [];
    for (var i = 0; i < votesToday.subVotes.length; i++) {
      // print(votesFromDB.subVotes.length);
      listItems.add(VoteCard(i, votesToday));
    }

    setState(() {
      _votesTodayShowing = listItems;
    });
  }

  void getVoteSelectedWidget(VoteModel votesToday) {
    List<Widget> listItems = [];
    for (var i = 0; i < votesToday.subVotes.length; i++) {
      listItems.add(VoteSelected(i, votesToday));
    }
    setState(() {
      _votesSelectedNotShowing = listItems;
    });
  }

  void getTimeLeft(VoteModel votesToday) {
    setState(() {
      DateTime endTime = votesToday.voteEndDateTime.toDate();
      Duration diff = endTime.difference(DateTime.now());
      String sDuration =
          "${diff.inHours}:${diff.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(diff.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
      print(sDuration);
      var diffFinal = sDuration.toString();
      timeLeftArr = diffFinal.split(":");
    });
  }

  // 위젯 생성 함수와 PageController의 리스터를 이니셜라이징
  // controller의 offset 수치를 listen하여 수식을 통해 value를 계산하고
  // setState로 반영하여 계속 리빌드 시킨다
  @override
  void initState() {
    super.initState();
    print("initState Called");
    // 현재 시간 한국 시간으로 변경
    _now = DateTime.now().toUtc().add(Duration(hours: 9));
    // _nowToStr = stringDate.format(_now);
    _nowToStr = "20200901"; //temp for test

    print(_now.toString() + " and " + _nowToStr);

    // 오늘의 주제, 선택된 주제 위젯 만들기 위해 initState에 vote 데이터 db에서 불러옴
    print("Async start");
    _model.getVote(_nowToStr).then((value) {
      print('voteData got');

      getVoteTodayWidget(value);
      getVoteSelectedWidget(value);
      getTimeLeft(value);
      _voteFromDB = value;

      return _voteFromDB;
    });

    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        getTimeLeft(_voteFromDB);
      });
    });

    //get this user's UserModel
    _userModelFuture = _model.getUser(widget.uid);
    print("initState Done");
  }

  @override
  // initState 다음에 호출되는 함수. MediaQuery를 가져오기 위해 initState에 두지 않고 여기에 둠
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeCalled");

    final Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;

    _preloadPageController = PreloadPageController(
      initialPage: 0,
      // 페이지뷰 하나의 크기
      viewportFraction: displayRatio > 1.85 ? 0.63 : 0.58,
      keepPage: true,
    );
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
    _everySecond.cancel();
  }

  // list의 데이터를 바꾸고 setState하면 아래 호출될 줄 알았는데 안 됨
  @override
  void didUpdateWidget(VoteSelectView oldWidget) {
    super.didUpdateWidget(oldWidget);

    print("didUpdateWidget Called");
  }

  @override
  Widget build(BuildContext context) {
    print("buildCalled");
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;

    return ViewModelBuilder<VoteSelectViewModel>.reactive(
      viewModelBuilder: () => VoteSelectViewModel(),
      builder: (context, model, child) => MaterialApp(
        home: FutureBuilder(
          // you shouldn't call the function directly inside the
          // FutureBuilder's future method. Instead, you should 1st run
          // your function in init state, and store the response
          // in a new variable. Only then assign variable to the
          // future of FutureBuilder.
          future: _userModelFuture,
          // Future.wait([
          // model.getVote('20200901'),
          // ]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("snapShotData Called");
              // getVoteTodayWidget(snapshot.data[1]);
              // getVoteSelectedWidget(snapshot.data[1]);
              UserModel currentUser = snapshot.data;
              print(currentUser);
              return Scaffold(
                backgroundColor: Color(0xFF363636),
                bottomNavigationBar: bottomNavigationBar(context),
                body: Container(
                  child: SafeArea(
                    child: ListView(children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: gap_l,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            topBar(currentUser),
                            SizedBox(
                              height: gap_l,
                            ),
                            Row(
                              //오늘의 주제, 남은 시간
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '오늘의 투표: 5개',
                                  style: TextStyle(
                                      color: Colors.black,
                                      // fontFamily: 'AdventPro',
                                      fontSize: 22,
                                      textBaseline: TextBaseline.alphabetic),
                                ),
                                Text(
                                  "투표 마감까지 " +
                                      (timeLeftArr[0]) +
                                      "시간 " +
                                      (timeLeftArr[1]) +
                                      "분 " +
                                      (timeLeftArr[2]) +
                                      "초 ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      // fontFamily: 'AdventPro',
                                      fontSize: 14,
                                      textBaseline: TextBaseline.ideographic),
                                )
                              ],
                            ),
                            SizedBox(
                              height: gap_m,
                            ),
                            Container(
                              height: displayRatio > 1.85
                                  ? size.height * .45
                                  : size.height * .50,

                              // PageView.builder랑 똑같은데 preloadPageCount 만큼 미리 로드해놓는 것만 다름
                              child: PreloadPageView.builder(
                                preloadPagesCount: 5,
                                controller: _preloadPageController,
                                scrollDirection: Axis.horizontal,
                                // physics: BouncingScrollPhysics(),
                                itemCount: _votesTodayShowing.length,
                                itemBuilder: (context, index) {
                                  // print('pageviewRebuilt');
                                  return GestureDetector(
                                      onDoubleTap: () {
                                        // 주제 선택 최대 수를 제한하고
                                        if (_votesTodayNotShowing.length < 3) {
                                          setState(() {
                                            // 더블 탭 하면 voteToday 섹션과 voteSelected 섹션에서
                                            // 보여줘야할 위젯과 보여주지 않는 위젯을 서로 교환하며 리스트에 저장한다.
                                            _votesTodayNotShowing
                                                .add(_votesTodayShowing[index]);
                                            _votesTodayShowing.removeAt(index);

                                            _votesSelectedShowing.add(
                                                _votesSelectedNotShowing[
                                                    index]);
                                            _votesSelectedNotShowing
                                                .removeAt(index);
                                          });
                                        } else
                                          return;
                                      },
                                      child: _votesTodayShowing[index]);
                                },
                              ),
                            ),
                            SizedBox(
                              height: gap_m,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '선택한 투표',
                                  style: TextStyle(
                                    color: Colors.black,
                                    // fontFamily: 'AdventPro',
                                    fontSize: 22,
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    for (VoteSelected i
                                        in _votesSelectedShowing) {
                                      selectedFinal.add(i.idx);
                                    }
                                    selectedFinal.sort();

                                    _navigationService.navigateWithArgTo(
                                        'vote0', [
                                      widget.uid,
                                      _voteFromDB,
                                      selectedFinal
                                    ]);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: _votesSelectedShowing.length == 0
                                            ? Color(0xFF531818)
                                            : Color(0xFFD72929),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: gap_m, horizontal: gap_xxl),
                                      child: Text(
                                        'GO VOTE',
                                        style: TextStyle(
                                          color:
                                              _votesSelectedShowing.length == 0
                                                  ? Color(0xFF605E5E)
                                                  : Color(0xFFFFFFFF),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'AdventPro',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: gap_l,
                            ),
                            Container(
                              height: size.height * .2,
                              // color: Colors.red,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _votesSelectedShowing.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onDoubleTap: () {
                                        setState(() {
                                          // Selected 더블탭 -> 거기서 id 추출
                                          // voteTodayShowing에서 자리찾기
                                          // insert

                                          // 선택한 주제들 중 더블탭한 선택 주제 위젯을 temp에 보관.
                                          VoteSelected temp =
                                              _votesSelectedShowing[index];
                                          // 더블탭한 주제의 subVote idx추출
                                          int subVoteIdx = temp.idx;

                                          List<int> indicesList = [];

                                          // 오늘의 주제에 떠있는 주제들의 subVoteIdx를 indicesList에 넣기
                                          for (VoteCard i
                                              in _votesTodayShowing) {
                                            indicesList.add(i.idx);
                                          }
                                          // 방금 더블탭한 subVoteIdx도 이 리스트에 추가
                                          indicesList.add(subVoteIdx);
                                          // 순서대로 sort
                                          indicesList.sort();

                                          // 이 리스트에서 더블탭한 것의 순서를 세고
                                          subVoteIdx =
                                              indicesList.indexOf(subVoteIdx);
                                          // 선택주제에서 not showing 리스트에 위에서 센 순서 자리에 넣고,
                                          // 선택 주제 showing에서 해당 위젯을 삭제
                                          _votesSelectedNotShowing.insert(
                                              subVoteIdx,
                                              _votesSelectedShowing[index]);
                                          _votesSelectedShowing.removeAt(index);

                                          // 오늘의 주제 showing에 다시 자리 찾아서 놓고
                                          // 오늘의 주제 not showing에서 제거
                                          _votesTodayShowing.insert(subVoteIdx,
                                              _votesTodayNotShowing[index]);
                                          _votesTodayNotShowing.removeAt(index);
                                        });
                                      },
                                      child: _votesSelectedShowing[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
                // Code:
              );
            } else {
              print("snapShotData notYet");
              return LoadingView();
            }
          },
        ),
      ),
    );
  }
}
