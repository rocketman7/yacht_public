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

import 'package:yachtOne/views/widgets/navigation_bars_widget.dart';

class VoteCommentView extends StatefulWidget {
  final String uid;
  VoteCommentView(this.uid);
  @override
  _VoteCommentViewState createState() => _VoteCommentViewState();
}

class _VoteCommentViewState extends State<VoteCommentView> {
  final DatabaseService _databaseService = locator<DatabaseService>();
  String uid;

  VoteCommentModel voteCommentModel;
  VoteModel voteModel;
  UserVoteModel userVoteModel;
  // List<int> voteList;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;
    final TextEditingController _commentController = TextEditingController();

    uid = widget.uid;

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
                return StreamBuilder(
                    //StreamProvider
                    stream: _databaseService.getPostList(),
                    //create: _databaseService.getPostList(),
                    builder: (context, snapshotStream) {
                      //builder (context, child) {}
                      List<VoteCommentModel> commentsList = snapshotStream.data;
                      // List commentsList = Provider.of<List<VoteCommentModel>>(context);
                      if (snapshotStream.data == null) {
                        // print(snapshot.data);
                        return LoadingView();
                      } else {
                        return Scaffold(
                          bottomNavigationBar: bottomNavigationBar(context),
                          backgroundColor: Color(0xFF363636),
                          body: SafeArea(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    displayRatio > 1.85 ? gap_l : gap_xs,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    topBar(currentUserModel),
                                    SizedBox(
                                      height:
                                          displayRatio > 1.85 ? gap_l : gap_xs,
                                    ),
// 피드 종목 선택 리스트뷰
                                    Container(
                                      height: displayRatio > 1.85 ? 30 : 20,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: <Widget>[
                                          subVoteList(voteModel
                                              .subVotes[0].title
                                              .toString()),
                                          subVoteList(voteModel
                                              .subVotes[1].title
                                              .toString()),
                                          subVoteList(voteModel
                                              .subVotes[2].title
                                              .toString()),
                                          subVoteList(voteModel
                                              .subVotes[3].title
                                              .toString()),
                                          subVoteList(voteModel
                                              .subVotes[4].title
                                              .toString()),
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
                                        "Netflix",
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
                                        itemCount: commentsList.length,
                                        scrollDirection: Axis.vertical,
                                        reverse: true,
                                        itemBuilder: (context, index) =>
                                            commentList(commentsList[index]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: gap_l,
                                    ),
                                    commentInput(
                                      _commentController,
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
                      }
                    });
              } else {
                return LoadingView();
              }
            }),
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
          SizedBox(
            width: gap_s,
          ),
          Text(
            "Just now",
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
    TextEditingController controller,
    UserModel userModel,
    VoteCommentViewModel model,
    VoteModel voteModel,
    UserVoteModel userVoteModel,
  ) {
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
                choice: userVoteModel.voteSelected[0] == 0
                    ? null
                    : voteModel.subVotes[0]
                        .voteChoices[userVoteModel.voteSelected[0] - 1]

                // postDateTime: DateTime.now(),
                );

            model.postComments(
              voteCommentModel: voteCommentModel,
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
