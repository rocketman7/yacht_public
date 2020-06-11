import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/fake_vote_data.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/vote_select_view_model.dart';
import 'package:yachtOne/views/constants/size.dart';
import 'package:preload_page_view/preload_page_view.dart';

class VoteSelectTestView extends StatefulWidget {
  @override
  _VoteSelectTestViewState createState() => _VoteSelectTestViewState();
}

class _VoteSelectTestViewState extends State<VoteSelectTestView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  PreloadPageController controller = PreloadPageController();
  double leftContainer = 0;

  // subvote Card를 생성하는 위젯
  Widget voteCard(idx) {
    return Container(
      width: 250.0,
      height: 340.0,
      child: Card(
        child: Wrap(
          children: <Widget>[
            Image.network(VOTE_DATA[idx]['voteImg']),
            Text(VOTE_DATA[idx]['title']),
            Text(VOTE_DATA[idx]['voteChoices'].toString()),
          ],
        ),
      ),
    );
  }

  // 위젯들이 왔다갔다 하기 때문에 두 영역의 위젯이 같게 됨.
  List<Widget> itemsData = [];
  List<Widget> selectedData = [];

  // 각자 voteList <-> voteDeleted / voteSelectedList <-> voteSelectedDeleted 로 왔다갔다 하게 해야 함.
  // initState에 voteList와 voteSelectedDeleted를 Card위젯을 통해 생성하고 액션이 있을 때 같은 index를 서로 짝이 되는 List로 넘기고 넘겨받아야 할 듯.
  //애니메이션은 천천히 생각해보자.

  // voteData를 가져와 voteCard에 넣어 위젯 리스트를 만드는 함수
  // TODO: forEach 체크해서 각 인덱스별로 차례로 넣어서 다섯 개의 voteCard 위젯 만들어지도록 고쳐야함
  void getData() {
    List<Map<String, dynamic>> voteList = VOTE_DATA;
    List<Widget> listItems = [];
    for (var i = 0; i < voteList.length; i++) {
      listItems.add(voteCard(i));
    }
    setState(() {
      itemsData = listItems;
    });
  }

  // getData()함수와 PageController의 리스터를 이니셜라이징
  // controller의 offset 수치를 listen하여 수식을 통해 value를 계산하고
  // setState로 반영하여 계속 리빌드 시킨다
  @override
  void initState() {
    super.initState();

    getData();
    controller = PreloadPageController(
      initialPage: 0,
      viewportFraction: 0.6,
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
  void didUpdateWidget(VoteSelectTestView oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget Called");
  }

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width);
    return ViewModelBuilder<VoteSelectViewModel>.reactive(
      viewModelBuilder: () => VoteSelectViewModel(),
      builder: (context, model, child) => MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            elevation: 50.0,
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
                      vertical: gap_xl,
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
                    height: gap_l,
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
                    height: gap_l,
                  ),
                  Container(
                      height: 350,
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
                        itemCount: itemsData.length,
                        itemBuilder: (context, index) {
                          print('pageviewRebuilt');
                          return itemsData[index];
                        },
                      )),
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
                      children: <Widget>[
                        Text(
                          'Votes Seleceted',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'AdventPro',
                            fontSize: 18,
                          ),
                        ),
                        FlatButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            setState(() {
                              selectedData.add(itemsData[itemsData.length - 1]);
                              itemsData.removeLast();
                            });
                            print(itemsData.length);
                            print(selectedData.length);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xFF531818),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: gap_m, horizontal: gap_xxl),
                              child: Text(
                                'GO VOTE',
                                style: TextStyle(
                                  color: Color(0XFF605E5E),
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
                  FlatButton(
                    onPressed: () {
                      setState(() {
                        itemsData.add(selectedData[selectedData.length - 1]);
                        selectedData.removeLast();
                      });
                      print(itemsData.length);
                      print(selectedData.length);
                    },
                    child: Container(
                      height: 150,
                      width: 150 / 1.618,
                      color: Colors.blueAccent,
                    ),
                  ),
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
