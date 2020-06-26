import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yachtOne/views/constants/size.dart';

class VoteFeed extends StatefulWidget {
  @override
  _VoteFeedState createState() => _VoteFeedState();
}

class _VoteFeedState extends State<VoteFeed> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF363636),
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: displayRatio > 1.85 ? gap_l : gap_xs,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
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
                            onPressed: () => {},
                            child: Text(
                              // snapshot.data[0].userName,
                              'rocketman',
                              style: TextStyle(
                                fontFamily: 'AdventPro',
                                color: Color(0xFFC4FEF3),
                                fontSize: 26,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        // snapshot.data[0].combo.toString() + ' Combo',
                        '17 Combo',
                        style: TextStyle(
                          fontFamily: 'AdventPro',
                          color: Color(0xFFC4FEF3),
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: displayRatio > 1.85 ? gap_l : gap_xs,
                  ),
// 피드 종목 선택 리스트뷰
                  Container(
                    height: displayRatio > 1.85 ? 30 : 20,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        subVoteList('subVote000'),
                        subVoteList('subVote001'),
                        subVoteList('subVote002'),
                        subVoteList('subVote003'),
                        subVoteList('subVote004'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: gap_xs,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 60.0),
                    child: Text(
                      "Disney",
                      style: feedTitle(),
                    ),
                  ),
                  Text(
                    "vs",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontFamily: 'AdventPro',
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 60.0),
                    child: Text(
                      "Netflix",
                      style: feedTitle(),
                    ),
                  ),
                  SizedBox(
                    height: gap_m,
                  ),
                  Container(
                    height: 95,
                    color: Color(0xFF164D59),
                  ),
                  SizedBox(
                    height: gap_xxs,
                  ),
// 피드 섹션
                  Container(
                    // width: 320,
                    height: 350,
                    child: ListView.builder(
                      itemCount: 15,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) => comment(),
                    ),
                  ),
                  SizedBox(
                    height: gap_l,
                  ),
// 유저 코멘트 넣는 창
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/avatar.png',
                          width: 30,
                        ),
                        Container(
                          width: 300,
                          child: TextFormField(
                            textAlign: TextAlign.start,
                            textAlignVertical: TextAlignVertical.top,
                            maxLines: 3,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFBDBDBD),
                                    width: 1.0,
                                  ),
                                ),
                                hintText: '주제에 관한 생각을 말해주세요',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF828282),
                                )),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ),
        // backgroundColor: Color(0XFF051417),
      ),
    );
  }

  Widget subVoteList(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: gap_xs,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }

  TextStyle feedTitle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontFamily: 'AdventPro',
      fontWeight: FontWeight.bold,
    );
  }

  Widget comment() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: gap_xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Image.asset(
            'assets/images/avatar.png',
            width: 30,
          ),
          SizedBox(
            width: gap_s,
          ),
          Container(
            width: 270,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "csejun",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'AdventPro',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      "Disney",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'AdventPro',
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: gap_xxs,
                ),
                Text(
                  "comments comments comments comments comments",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'AdventPro',
                  ),

                  maxLines: 3,
                  // overflow: TextOverflow.,
                ),
              ],
            ),
          ),
          SizedBox(
            width: gap_s,
          ),
          Text(
            "just now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: 'AdventPro',
            ),
          ),
          // Text("Just now"),
        ],
      ),
    );
  }
}
