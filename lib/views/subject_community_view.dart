import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/vote_comment_model.dart';
import 'package:yachtOne/view_models/subject_community_view_model.dart';
import 'package:yachtOne/views/constants/size.dart';

import 'loading_view.dart';

class SubjectCommunityView extends StatefulWidget {
  final int idx;
  SubjectCommunityView(this.idx);
  @override
  _SubjectCommunityViewState createState() => _SubjectCommunityViewState();
}

final TextEditingController _commentInputController = TextEditingController();
final ScrollController _commentScrollController = ScrollController();
VoteCommentModel voteCommentModel;

class _SubjectCommunityViewState extends State<SubjectCommunityView> {
  int idx;
  @override
  Widget build(BuildContext context) {
    idx = widget.idx;
    print(deviceHeight);

    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SubjectCommunityViewModel(idx),
      builder: (context, model, child) {
        // print("BUILDING" + model.idx.toString());
        return model.isBusy
            ? LoadingView()
            : Scaffold(
                body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Icon(Icons.arrow_back_ios)),
                            Column(
                              children: <Widget>[
                                Text(model.vote.subVotes[idx].title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text("총 투표 10,422"),
                              ],
                            ),
                            Icon(Icons.share_rounded)
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 2.0,
                        ),
                        Stack(children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Stack(children: <Widget>[
                                  Container(
                                    // width: 150,
                                    height: deviceHeight * .17,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFCDE34),
                                      border: Border(
                                        left: BorderSide(
                                          //                   <--- left side
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                        top: BorderSide(
                                          //                    <--- top side
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                        right: BorderSide(
                                          //                    <--- top side
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                        bottom: BorderSide(
                                          //                    <--- top side
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    child: Text(
                                      model.vote.subVotes[idx].voteChoices[0] +
                                          " 43%",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    height: deviceHeight * .17,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 6, 9),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(
                                                  0xFFFCDE34), // 지고 있을 때 종목 컬러랑 같게하고 이기고 있을 때 색 변화주면 됨.
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30,
                                              )),
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  30,
                                                )),
                                            child: Text(
                                              "+3.79%",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                              Flexible(
                                flex: 1,
                                child: Stack(children: <Widget>[
                                  Container(
                                    // width: 150,
                                    height: deviceHeight * .17,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF8DFE34),
                                      border: Border(
                                        left: BorderSide(
                                          //                   <--- left side
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                        top: BorderSide(
                                          //                    <--- top side
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                        right: BorderSide(
                                          //                    <--- top side
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                        bottom: BorderSide(
                                          //                    <--- top side
                                          color: Colors.black,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 12, 0, 0),
                                    child: Text(
                                      model.vote.subVotes[idx].voteChoices[1] +
                                          " 57%",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    height: deviceHeight * .17,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 6, 9),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color(
                                                  0xFFFFE609), // 지고 있을 때 종목 컬러랑 같게하고 이기고 있을 때 색 변화주면 됨.
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30,
                                              )),
                                          child: Container(
                                            padding: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  30,
                                                )),
                                            child: Text(
                                              "+4.57%",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              )
                            ],
                          ),
                          Positioned(
                              left: (deviceWidth - 36) / 2 -
                                  20, //flex 수치랑 연동되도록 설정해야하고 device width감안한 최소/최대값 바운더리 설정해야함
                              top: (deviceHeight * .17 / 2) - 20,
                              child: Container(
                                alignment: Alignment.center,
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(
                                      40,
                                    )),
                                child: Text("vs",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                              )),
                        ]),
                        SizedBox(height: 8),
                        Expanded(
                          child: buildCommentList(
                            model,
                          ),
                        ),
                        Container(
                          height: 40,
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  40,
                                ),
                                child: Container(
                                  height: deviceHeight * .045,
                                  width: deviceHeight * .045,
                                  color: Colors.amber,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Stack(children: <Widget>[
                                Container(
                                  // height: 40,
                                  width: deviceWidth * .75,
                                  child: TextField(
                                    // scrollController: _commentScrollController,
                                    // scrollPhysics: ScrollPhysics(),
                                    controller: _commentInputController,
                                    textAlign: TextAlign.start,

                                    // textAlignVertical: TextAlignVertical.top,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    minLines: 1,
                                    maxLines: 3,
                                    // maxLength: 20,
                                    maxLengthEnforced: true,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.fromLTRB(15, 12, 40, 12),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide: BorderSide(
                                            color: Color(0xFFBDBDBD),
                                            width: 1.0,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide: BorderSide(
                                            color: Color(0xFFBDBDBD),
                                            width: 1.0,
                                          ),
                                        ),
                                        hintText: '주제에 관한 의견을 말해주세요',
                                        hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF828282),
                                        )),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      print(model.idx);
                                      voteCommentModel = VoteCommentModel(
                                        uid: model.user.uid,
                                        userName: model.user.userName,
                                        postText: _commentInputController.text,
                                        choice: (model.userVote.voteSelected[
                                                        model.idx] ==
                                                    0 ||
                                                model.userVote.voteSelected[
                                                        model.idx] ==
                                                    null)
                                            ? null
                                            : model.vote.subVotes[model.idx]
                                                .voteChoices[model.userVote
                                                    .voteSelected[model.idx] -
                                                1],
                                        postDateTime: Timestamp.fromDate(
                                            DateTime.now().toUtc()),

                                        // postDateTime: DateTime.now(),
                                      );
                                      print("TAP");
                                      print(voteCommentModel.uid);
                                      model.postComments(
                                        model.address,
                                        voteCommentModel,
                                      );
                                      _commentInputController.text = '';
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 8,
                                              color:
                                                  Colors.black.withOpacity(.2),
                                              spreadRadius: 0)
                                        ],
                                      ),
                                      child: Image.asset(
                                        'assets/icons/post_comment_button.png',
                                        // width: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              SizedBox(width: 8),
                              // Expanded(
                              //   child:
                              // ),
                            ],
                          ),
                        )
                      ],
                    )),
              ));
      },
    );
  }

  Widget buildCommentList(
    SubjectCommunityViewModel model,
  ) {
    return StreamBuilder<List<VoteCommentModel>>(
        stream: model.getPost(model.address),
        builder: (context, snapshot) {
          print(model.address);
          List<VoteCommentModel> commentList = snapshot.data;
          if (snapshot.data == null) {
            return LoadingView();
          } else {
            return Container(
                // height: deviceHeight * .55,
                child: ListView.builder(
                    key: UniqueKey(),
                    controller: _commentScrollController,
                    // addAutomaticKeepAlives: true,
                    itemCount: commentList.length,
                    scrollDirection: Axis.vertical,
                    reverse: true,
                    itemBuilder: (context, index) {
                      return buildColumn(
                        model,
                        commentList[index],
                      );
                    }));
          }
        });
  }

  Column buildColumn(
    SubjectCommunityViewModel model,
    VoteCommentModel voteComment,
  ) {
    return Column(
      children: <Widget>[
        Divider(
          thickness: 1.0,
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          // height: deviceHeight * .07,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      40,
                    ),
                    child: Container(
                      height: deviceHeight * .06,
                      width: deviceHeight * .06,
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(voteComment.userName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                          voteComment.postDateTime == null
                              ? 'null'
                              : DateTime.now()
                                      .difference(
                                          voteComment.postDateTime.toDate())
                                      .inMinutes
                                      .toString() +
                                  ' 분 전',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF999999),
                          )),
                    ],
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/icons/likes_fill.png',
                      width: 20,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text("55")
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              voteComment.postText,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
