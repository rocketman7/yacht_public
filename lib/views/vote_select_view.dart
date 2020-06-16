import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/vote_select_view_model.dart';
import 'package:yachtOne/views/constants/size.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:yachtOne/views/loading_view.dart';
import 'package:yachtOne/views/widgets/vote_card_widget.dart';
import 'package:yachtOne/views/widgets/vote_selected_widget.dart';

class VoteSelectView extends StatefulWidget {
  final String uid;
  VoteSelectView(this.uid);
  @override
  _VoteSelectViewState createState() => _VoteSelectViewState();
}

class _VoteSelectViewState extends State<VoteSelectView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  VoteSelectViewModel _model = VoteSelectViewModel();

  PreloadPageController controller = PreloadPageController();
  double leftContainer = 0;

  // Votes for Today 영역 위젯 관리
  List<Widget> _votesTodayShowing = [];
  List<Widget> _votesTodayNotShowing = [];
  // Votes Selected 영역 위젯 관리
  List<Widget> _votesSelectedShowing = [];
  List<Widget> _votesSelectedNotShowing = [];
  List<int> _passIdx = [];

  // DB에서 가져온 데이터를 VoteModel에 넣은 Object
  final VoteModel votes = voteToday;

  VoteModel votesFromDB;

  String diffHours;
  String diffMins;
  String diffSecs;

  String _now;
  Timer _everySecond;

  //애니메이션은 천천히 생각해보자.

  // voteData를 가져와 voteTodayCard에 넣어 위젯 리스트를 만드는 함수
  void getVoteTodayWidget(VoteModel votesToday) {
    List<Widget> listItems = [];
    for (var i = 0; i < votesToday.subVotes.length; i++) {
      // print(votesFromDB.subVotes.length);
      listItems.add(VoteCard(i, votesToday));
      print(VoteCard(i, votesToday).idx);
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

  void getTimeLeft() {
    // print(diff);
    setState(() {
      // TODO: subString 방법 말고 시간, 분, 초 각각 리턴해서 해야함
      var endTime = votes.voteEndDateTime;
      var diff = endTime.difference(DateTime.now());
      print(diff);
      diffHours = diff.toString().substring(0, 2);
      diffMins = diff.toString().substring(3, 5);
      diffSecs = diff.toString().substring(6, 8);
    });
  }

  // 위젯 생성 함수와 PageController의 리스터를 이니셜라이징
  // controller의 offset 수치를 listen하여 수식을 통해 value를 계산하고
  // setState로 반영하여 계속 리빌드 시킨다
  @override
  void initState() {
    super.initState();

    // 투표, 선택된 투표 위젯 만들기 위해 initState에 투표 데이터 db에서 불러옴
    print("Async start");
    _model.getVoteDB('20200901').then((value) {
      print("Async done");
      getVoteTodayWidget(value);
      getVoteSelectedWidget(value);
      votesFromDB = value;
      return votesFromDB;
    });
    // getVoteTodayWidget();
    // getVoteSelectedWidget();
    getTimeLeft();

    // sets first value
    // _now = DateTime.now().second.toString();
    // // defines a timer
    // _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   setState(() {
    //     getTimeLeft();
    //   });
    // });

    print("initState Called");
  }

  @override
  // initState 다음에 호출되는 함수. MediaQuery를 가져오기 위해 initState에 두지 않고 여기에 둠
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeCalled");

    final Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;

    controller = PreloadPageController(
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
    // 백 버튼에 호출아래를 호출하지 않으면 dispose 됐는데 setState한다고 오류뜸
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
          future: Future.wait([
            model.getUserDB(widget.uid),
            model.getVoteDB('20200901'),
          ]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print("rebuild");
              // getVoteTodayWidget(snapshot.data[1]);
              // getVoteSelectedWidget(snapshot.data[1]);

              return Scaffold(
                bottomNavigationBar: BottomNavigationBar(
                  onTap: (index) => {},
                  currentIndex: 0,
                  backgroundColor: Colors.black,
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.white,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text('Home'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.monetization_on),
                      title: Text('Vote'),
                    ),
                  ],
                ),
                // backgroundColor: Color(0XFF051417),
                body: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 1],
                      colors: <Color>[
                        const Color(0xFF0F2D3E),
                        const Color(0xFF02030C),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: ListView(children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: gap_l,
                              // vertical: gap_xl,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/avatar.png',
                                      width: 60,
                                    ),
                                    SizedBox(
                                      width: gap_xl,
                                    ),
                                    FlatButton(
                                      onPressed: () => model.signOut(),
                                      child: Text(
                                        snapshot.data[0].userName,
                                        style: TextStyle(
                                          fontFamily: 'AdventPro',
                                          color: Colors.white,
                                          fontSize: 26,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  snapshot.data[0].combo.toString() + ' Combo',
                                  style: TextStyle(
                                    fontFamily: 'AdventPro',
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: gap_l,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: gap_l,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '오늘의 투표: 5개',
                                  style: TextStyle(
                                      color: Colors.white,
                                      // fontFamily: 'AdventPro',
                                      fontSize: 22,
                                      textBaseline: TextBaseline.alphabetic),
                                ),
                                Text(
                                  // TODO: 간 숫자마다 같은 자리 차지하게 바꿔야함
                                  "투표 마감까지 " +
                                      (diffHours) +
                                      "시간 " +
                                      (diffMins) +
                                      "분 " +
                                      (diffSecs) +
                                      "초 ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      // fontFamily: 'AdventPro',
                                      fontSize: 14,
                                      textBaseline: TextBaseline.ideographic),
                                )
                              ],
                            ),
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
                                controller: controller,
                                scrollDirection: Axis.horizontal,
                                // physics: BouncingScrollPhysics(),
                                itemCount: _votesTodayShowing.length,
                                itemBuilder: (context, index) {
                                  // print('pageviewRebuilt');
                                  return GestureDetector(
                                      onDoubleTap: () {
                                        // 투표 선택 최대 수를 제한하고
                                        if (_votesTodayNotShowing.length < 3) {
                                          setState(() {
                                            // 더블 탭 하면 voteToday 섹션과 voteSelected 섹션에서
                                            // 보여줘야할 위젯과 보여주지 않는 위젯을 서로 교환하며 리스트에 저장한다.
                                            _votesTodayNotShowing
                                                .add(_votesTodayShowing[index]);
                                            _passIdx.add(index);
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
                              )),
                          SizedBox(
                            height: gap_m,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: gap_l,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '선택한 투표',
                                  style: TextStyle(
                                    color: Colors.white,
                                    // fontFamily: 'AdventPro',
                                    fontSize: 22,
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    List<int> selectedFinal = [];
                                    for (VoteSelected i
                                        in _votesSelectedShowing) {
                                      selectedFinal.add(i.idx);
                                    }
                                    selectedFinal.sort();

                                    _navigationService.navigateWithArgTo(
                                        'vote0', [
                                      widget.uid,
                                      votesFromDB,
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
                          ),
                          SizedBox(
                            height: gap_l,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: gap_m,
                            ),
                            child: Container(
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

                                          VoteSelected temp =
                                              _votesSelectedShowing[index];
                                          int id = temp.idx;

                                          List<int> indicesList = [];
                                          for (VoteCard i
                                              in _votesTodayShowing) {
                                            indicesList.add(i.idx);
                                          }
                                          indicesList.add(id);

                                          indicesList.sort();
                                          print(index);
                                          print(id);
                                          id = indicesList.indexOf(id);
                                          print(id);
                                          _votesSelectedNotShowing.insert(
                                              id, _votesSelectedShowing[index]);
                                          _votesSelectedShowing.removeAt(index);

                                          _votesTodayShowing.insert(
                                              id, _votesTodayNotShowing[index]);
                                          _votesTodayNotShowing.removeAt(index);
                                        });
                                      },
                                      child: _votesSelectedShowing[index]);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
                // Code:
              );
            } else
              return LoadingView();
          },
        ),
      ),
    );
  }
}
