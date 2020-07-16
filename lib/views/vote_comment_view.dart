import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/user_model.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/models/vote_comment_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/view_models/vote_comment_view_model.dart';
import 'package:yachtOne/views/constants/size.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/views/loading_view.dart';
import 'package:intl/intl.dart';

import 'package:yachtOne/views/widgets/navigation_bars_widget.dart';

class VoteCommentView extends StatefulWidget {
  final String uid;
  VoteCommentView(this.uid);
  @override
  _VoteCommentViewState createState() => _VoteCommentViewState();
}

class _VoteCommentViewState extends State<VoteCommentView>
    with TickerProviderStateMixin {
  final DatabaseService _databaseService = locator<DatabaseService>();
  TabController _tabController;

  String uid;

  VoteCommentModel voteCommentModel;
  VoteModel voteModel;
  UserVoteModel userVoteModel;

  int _currentIndex;
  // List<int> voteList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;
    final TextEditingController _commentTextController =
        TextEditingController();

    uid = widget.uid;
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd_HH:mm:ss:SSS');

    print(now);
    String nowString = dateFormat.format(now);
    print(nowString);

    return ViewModelBuilder<VoteCommentViewModel>.reactive(
      viewModelBuilder: () => VoteCommentViewModel(),
      builder: (context, model, child) => MaterialApp(
        home: FutureBuilder(
            future: Future.wait([
              model.getUser(uid),
              model.getVotes('20200901'),
              model.getUserVote(uid, '20200901'),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel currentUserModel = snapshot.data[0];
                VoteModel voteModel = snapshot.data[1];
                UserVoteModel userVoteModel = snapshot.data[2];
                return Scaffold(
                  bottomNavigationBar: bottomNavigationBar(context),
                  backgroundColor: Color(0xFF363636),
                  body: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: displayRatio > 1.85 ? gap_l : gap_xs,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            topBar(currentUserModel),
                            SizedBox(
                              height: displayRatio > 1.85 ? gap_l : gap_xs,
                            ),
// 피드 종목 선택 리스트뷰
                            TabBar(
                              controller: _tabController,
                              indicatorColor: Colors.red,
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.white,
                              isScrollable: true,
                              tabs: List.generate(
                                5,
                                (index) => subVoteList(
                                  voteModel.subVotes[index].title.toString(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: gap_xs,
                            ),
                            Container(
                              height: 570,
                              child: TabBarView(
                                controller: _tabController,
                                children: List.generate(
                                  5,
                                  (index) => commentTabBarView(
                                    index,
                                    context,
                                    voteModel,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: gap_l,
                            ),
                            commentInput(
                              _tabController.index,
                              _commentTextController,
                              currentUserModel,
                              model,
                              voteModel,
                              userVoteModel,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // backgroundColor: Color(0XFF051417),
                );
              } else {
                return LoadingView();
              }
            }),
      ),
    );
  }

  Widget commentTabBarView(
    int subVoteIndex,
    BuildContext context,
    VoteModel voteModel,
  ) {
    return StreamBuilder(
        //StreamProvider
        stream: _databaseService.getPostList(subVoteIndex),
        //create: _databaseService.getPostList(),
        builder: (context, snapshotStream) {
          //builder (context, child) {}
          List<VoteCommentModel> commentModelList = snapshotStream.data;
          // List commentsList = Provider.of<List<VoteCommentModel>>(context);
          if (snapshotStream.data == null) {
            // print(snapshot.data);
            return LoadingView();
          } else {
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 60.0),
                  child: Text(
                    voteModel.subVotes[subVoteIndex].voteChoices[0],
                    style: commentTitle(),
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
                    voteModel.subVotes[subVoteIndex].voteChoices[1],
                    style: commentTitle(),
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
                    itemCount: commentModelList.length,
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    itemBuilder: (context, index) =>
                        commentList(commentModelList[index]),
                  ),
                ),
              ],
            );
          }
        });
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

  TextStyle commentTitle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontFamily: 'AdventPro',
      fontWeight: FontWeight.bold,
    );
  }

// 댓글 리스트 위젯
  Widget commentList(VoteCommentModel voteCommentModel) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: gap_xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Image.asset(
              'assets/images/avatar.png',
              width: 30,
            ),
            SizedBox(
              width: gap_s,
            ),
            Container(
              width: 200,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        voteCommentModel.userName,
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
                        voteCommentModel.choice ?? '선택 안 함',
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      voteCommentModel.postText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'AdventPro',
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ]),
          Text(
            voteCommentModel.postDateTime == null
                ? 'null'
                : DateTime.now()
                        .difference(voteCommentModel.postDateTime.toDate())
                        .inMinutes
                        .toString() +
                    ' Mins ago',
            textAlign: TextAlign.end,
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

// 유저 댓글 입력창
  Widget commentInput(
    int subVoteIndex,
    TextEditingController controller,
    UserModel userModel,
    VoteCommentViewModel model,
    VoteModel voteModel,
    UserVoteModel userVoteModel,
  ) {
    print(subVoteIndex);
    // 유저 코멘트 넣는 창
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset(
          'assets/images/avatar.png',
          width: 30,
        ),
        Container(
          width: 300,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.top,
            style: TextStyle(
              color: Colors.white,
            ),
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
        GestureDetector(
          onTap: () {
            voteCommentModel = VoteCommentModel(
              uid: userModel.uid,
              userName: userModel.userName,
              postText: controller.text,
              choice: userVoteModel.voteSelected[subVoteIndex] == 0
                  ? null
                  : voteModel.subVotes[subVoteIndex].voteChoices[
                      userVoteModel.voteSelected[subVoteIndex] - 1],
              postDateTime: Timestamp.fromDate(DateTime.now()),

              // postDateTime: DateTime.now(),
            );

            model.postComments(
              subVoteIndex,
              voteCommentModel,
            );
            controller.text = '';
          },
          child: Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
