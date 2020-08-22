import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yachtOne/services/dialog_service.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../models/user_vote_model.dart';
import '../models/vote_comment_model.dart';
import '../models/vote_model.dart';
import '../services/database_service.dart';
import '../view_models/vote_comment_view_model.dart';
import '../views/constants/size.dart';
import 'package:stacked/stacked.dart';
import '../views/loading_view.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/vote_chart_model.dart';
import '../views/widgets/navigation_bars_widget.dart';

class VoteCommentView extends StatefulWidget {
  final String uid;
  VoteCommentView(this.uid);
  @override
  _VoteCommentViewState createState() => _VoteCommentViewState();
}

class _VoteCommentViewState extends State<VoteCommentView>
    with TickerProviderStateMixin {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final DialogService _dialogService = locator<DialogService>();

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
    // 주제 선택하는 좌우 스크롤 메뉴의 컨트롤러
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
                    bottom: false,
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
                                    model,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: gap_xs,
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
    VoteCommentViewModel model,
  ) {
    // 차트에 표시할 포맷
    var f = new NumberFormat("##.0%");

    // 각 투표수 가져오기
    var numVoted0 = voteModel.subVotes[subVoteIndex].numVoted0;
    var numVoted1 = voteModel.subVotes[subVoteIndex].numVoted1;

    // 투표수 -> 퍼센티지 변환
    double vote0Percentage = numVoted0 / (numVoted0 + numVoted1);
    double vote1Percentage = numVoted1 / (numVoted0 + numVoted1);

    // Bar 차트에 들어갈 데이터 오브젝트
    var data = [
      VoteChart(voteModel.subVotes[subVoteIndex].voteChoices[0],
          vote0Percentage, Colors.red),
      VoteChart(voteModel.subVotes[subVoteIndex].voteChoices[1],
          vote1Percentage, Colors.blue),
    ];

    // 차트에 들어갈 데이터, 레이블 요소들
    var series = [
      charts.Series(
          domainFn: (VoteChart numVotedData, _) => numVotedData.name,
          measureFn: (VoteChart numVotedData, _) => numVotedData.votePercentage,
          colorFn: (VoteChart numVotedData, _) => numVotedData.color,
          id: 'Now',
          data: data,
          labelAccessorFn: (VoteChart numVotedData, _) =>
              '${(f.format(numVotedData.votePercentage)).toString()}',
          // insideLabelStyleAccessorFn: (VoteChart numVotedData, _) {
          //   final color = charts.MaterialPalette.yellow.shadeDefault.darker;
          //   return new charts.TextStyleSpec(color: color);
          // },
          outsideLabelStyleAccessorFn: (VoteChart numVotedData, _) {
            final color = charts.MaterialPalette.yellow.shadeDefault.darker;
            return new charts.TextStyleSpec(color: color);
          }),
    ];

    // 차트 디스플레이 요소들
    var chart = charts.BarChart(
      series,
      animate: true,
      animationDuration: Duration(milliseconds: 800),
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      vertical: false,

      /// Assign a custom style for the domain axis.
      ///
      /// This is an OrdinalAxisSpec to match up with BarChart's default
      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
      /// other charts).
      domainAxis: new charts.OrdinalAxisSpec(
        showAxisLine: false,
        renderSpec: new charts.SmallTickRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
              fontSize: 14, // size in Pts.
              color: charts.MaterialPalette.white),

          // Change the line colors to match text color.
          lineStyle:
              new charts.LineStyleSpec(color: charts.MaterialPalette.white),
        ),
      ),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
        showAxisLine: false,
        renderSpec: new charts.GridlineRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
              fontSize: 14, // size in Pts.
              color: charts.MaterialPalette.white),

          // Change the line colors to match text color.
          lineStyle:
              new charts.LineStyleSpec(color: charts.MaterialPalette.white),
        ),
      ),
    );

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
              mainAxisAlignment: MainAxisAlignment.start,
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
                // space for chart
                SizedBox(
                  height: 95.0,
                  child: chart,
                ),
                SizedBox(
                  height: gap_xxs,
                ),
// 피드 섹션
                Expanded(
                  child: Container(
                    // width: 320,
                    height: 350,
                    child: ListView.builder(
                      itemCount: commentModelList.length,
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      itemBuilder: (context, index) => commentList(
                          subVoteIndex, commentModelList[index], model),
                    ),
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
  Widget commentList(
    int subVoteIndex,
    VoteCommentModel voteCommentModel,
    VoteCommentViewModel model,
  ) {
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
              width: 230,
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
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            direction: Axis.vertical,
            // spacing: 1,
            children: [
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
              voteCommentModel.uid == widget.uid
                  ? IconButton(
                      iconSize: 20,
                      onPressed: () {
                        model.deleteComment(
                            subVoteIndex, voteCommentModel.postDateTime);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.grey[500],
                      )
                      // Text(
                      //   "삭제",
                      //   textAlign: TextAlign.end,
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //     fontSize: 13,
                      //     fontFamily: 'AdventPro',
                      //   ),
                      // ),
                      )
                  : Text(
                      "",
                      textAlign: TextAlign.end,
                    ),
            ],
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
              postDateTime: Timestamp.fromDate(DateTime.now().toUtc()),

              // postDateTime: DateTime.now(),
            );
            print(voteCommentModel.postDateTime);
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
