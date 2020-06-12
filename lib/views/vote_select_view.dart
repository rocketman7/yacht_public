import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/fake_vote_data.dart';
import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/vote_select_view_model.dart';
import 'package:yachtOne/views/constants/size.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:yachtOne/views/widgets/vote_card_widget.dart';
import 'package:yachtOne/views/widgets/vote_selected_widget.dart';

class VoteSelectView extends StatefulWidget {
  @override
  _VoteSelectViewState createState() => _VoteSelectViewState();
}

class _VoteSelectViewState extends State<VoteSelectView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  PreloadPageController controller = PreloadPageController();
  double leftContainer = 0;

  // Votes for Today 영역 위젯 관리
  List<Widget> votesTodayShowing = [];
  List<Widget> votesTodayNotShowing = [];

  // Votes Selected 영역 위젯 관리
  List<Widget> votesSelectedShowing = [];
  List<Widget> votesSelectedNotShowing = [];

  final VoteModel votes = voteToday;

  // final VoteCard cards = VoteCard(0);
  // 각자 voteList <-> voteDeleted / voteSelectedList <-> voteSelectedDeleted 로 왔다갔다 하게 해야 함.
  // initState에 voteList와 voteSelectedDeleted를 Card위젯을 통해 생성하고 액션이 있을 때 같은 index를 서로 짝이 되는 List로 넘기고 넘겨받아야 할 듯.
  //애니메이션은 천천히 생각해보자.

  // voteData를 가져와 voteCard에 넣어 위젯 리스트를 만드는 함수
  // TODO: forEach 체크해서 각 인덱스별로 차례로 넣어서 다섯 개의 voteCard 위젯 만들어지도록 고쳐야함
  void getCardWidget() {
    List<Widget> listItems = [];
    for (var i = 0; i < votes.subVotes.length; i++) {
      listItems.add(VoteCard(i, votes));
    }
    setState(() {
      votesTodayShowing = listItems;
    });
  }

  void getSelectedWidget() {
    List<Widget> listItems = [];
    for (var i = 0; i < votes.subVotes.length; i++) {
      listItems.add(VoteSelected(i, votes));
    }
    setState(() {
      votesSelectedNotShowing = listItems;
    });
  }

  // getData()함수와 PageController의 리스터를 이니셜라이징
  // controller의 offset 수치를 listen하여 수식을 통해 value를 계산하고
  // setState로 반영하여 계속 리빌드 시킨다
  @override
  void initState() {
    super.initState();

    getCardWidget();
    getSelectedWidget();
    controller = PreloadPageController(
      initialPage: 0,
      viewportFraction: 0.61,
      keepPage: true,
    );
    controller.addListener(() {
      double value = controller.offset / 250;

      setState(() {
        leftContainer = value;
      });
    });
    print("initState Called");
  }

  // list의 데이터를 바꾸고 setState하면 아래 호출될 줄 알았는데 안 됨
  @override
  void didUpdateWidget(VoteSelectView oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget Called");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ViewModelBuilder<VoteSelectViewModel>.reactive(
      viewModelBuilder: () => VoteSelectViewModel(),
      builder: (context, model, child) => MaterialApp(
        home: Scaffold(
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
              child: Column(
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
                            Text(
                              'rocketman',
                              style: TextStyle(
                                fontFamily: 'AdventPro',
                                color: Colors.white,
                                fontSize: 26,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '24 Combo',
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
                    height: gap_xxxs,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: gap_l,
                    ),
                    child: Text(
                      '5 Votes for Today',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'AdventPro',
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: gap_m,
                  ),
                  Container(
                      height: size.height * .45,

                      // width: 200,
                      // width: 350 / 1.618,
                      // color: Colors.blueAccent,
                      // 리스트 빌더에 controller를 넣어 빌드.
                      // PageView.builder랑 똑같은데 preloadPageCount 만큼 미리 로드해놓는 것만 다름
                      child: PreloadPageView.builder(
                        preloadPagesCount: 5,
                        controller: controller,
                        scrollDirection: Axis.horizontal,
                        // physics: BouncingScrollPhysics(),
                        itemCount: votesTodayShowing.length,
                        itemBuilder: (context, index) {
                          // print('pageviewRebuilt');
                          return GestureDetector(
                              onDoubleTap: () {
                                print(index);
                                if (votesTodayNotShowing.length < 3) {
                                  setState(() {
                                    votesTodayNotShowing
                                        .add(votesTodayShowing[index]);
                                    votesTodayShowing.removeAt(index);
                                    votesSelectedShowing
                                        .add(votesSelectedNotShowing[index]);
                                    votesSelectedNotShowing.removeAt(index);
                                  });
                                } else
                                  return;
                              },
                              child: votesTodayShowing[index]);
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
                          'Votes Seleceted',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'AdventPro',
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: votesSelectedShowing.length == 0
                                  ? Color(0xFF531818)
                                  : Color(0xFFD72929),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: gap_m, horizontal: gap_xxl),
                            child: Text(
                              'GO VOTE',
                              style: TextStyle(
                                color: votesSelectedShowing.length == 0
                                    ? Color(0xFF605E5E)
                                    : Color(0xFFFFFFFF),
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'AdventPro',
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
                  Container(
                    height: size.height * .2,
                    // color: Colors.red,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: votesSelectedShowing.length,
                      itemBuilder: (context, index) {
                        print(votesSelectedShowing.length);
                        return GestureDetector(
                            onDoubleTap: () {
                              print(index);
                              setState(() {
                                votesSelectedNotShowing
                                    .add(votesSelectedShowing[index]);
                                votesSelectedShowing.removeAt(index);
                                votesTodayShowing
                                    .add(votesTodayNotShowing[index]);
                                votesTodayNotShowing.removeAt(index);
                              });
                            },
                            child: votesSelectedShowing[index]);
                      },
                    ),
                  ),
                  // FlatButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       votesTodayShowing.add(votesTodayNotShowing[
                  //           votesTodayNotShowing.length - 1]);
                  //       votesTodayNotShowing.removeLast();
                  //     });
                  //     print(votesTodayShowing.length);
                  //     print(votesTodayNotShowing.length);
                  //   },
                  //   child: Container(
                  //     height: 150,
                  //     width: 150 / 1.618,
                  //     color: Colors.blueAccent,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // Code:
        ),
      ),
    );
  }
}
