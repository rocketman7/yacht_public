import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/services/dialog_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'constants/holiday.dart';
import 'widgets/customized_horizontal_calendar/customized_date_helper.dart';
import 'widgets/customized_horizontal_calendar/customized_horizontal_calendar.dart';

class VoteCommentView extends StatefulWidget {
  @override
  _VoteCommentViewState createState() => _VoteCommentViewState();
}

class _VoteCommentViewState extends State<VoteCommentView>
    with TickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final VoteCommentViewModel _viewModel = VoteCommentViewModel();
  final GlobalKey _globalKey = GlobalKey();
  ScrollController _calendarController = ScrollController();

  Future<List<Object>> _getAllModel;
  Future<UserModel> _userModel;
  Future<DatabaseAddressModel> _addressModel;
  Future<VoteModel> _voteModel;
  // Stream<List<VoteCommentModel>> _postStream;
  String uid;
  bool isDisposed = false;
  TabController _tabController;
  ScrollController _controller;

  VoteCommentModel voteCommentModel;
  VoteModel voteModel;
  UserVoteModel userVoteModel;

  int _currentIndex;
  // List<int> voteList;

  @override
  void initState() {
    super.initState();
    // 주제 선택하는 좌우 스크롤 메뉴의 컨트롤러

    // _tabController = TabController(length: 3, vsync: this);
    // _tabController.addListener(() {
    //   if (!isDisposed) {
    //     setState(() {
    //       _currentIndex = _tabController.index;
    //     });
    //   }
    // });
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // List<Object> allModel = await _getAllModel;
    // DatabaseAddressModel _address = allModel[0];
    // _postStream = _viewModel.getPost(_address);
  }

  @override
  void dispose() {
    super.dispose();
    // _tabController.dispose();
    // isDisposed = true;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
    // Size size = MediaQuery.of(context).size;
    double displayRatio = deviceHeight / deviceWidth;

    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('yyyy-MM-dd_HH:mm:ss:SSS');
    VoteModel newVote;
    print(now);
    String nowString = dateFormat.format(now);
    print(nowString);

    return ViewModelBuilder<VoteCommentViewModel>.reactive(
        viewModelBuilder: () => VoteCommentViewModel(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return Scaffold(
                body: model.isFirstLoading()
                    ? Container(
                        height: deviceHeight,
                        width: deviceWidth,
                        child: Stack(
                          children: [
                            Positioned(
                              top: deviceHeight / 2 - 100,
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
                          ],
                        ),
                      )
                    : Container());
          } else {
            return Scaffold(
              body: WillPopScope(
                onWillPop: () async {
                  _navigatorKey.currentState.maybePop();
                  return false;
                },
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "커뮤니티",
                          style: TextStyle(
                            fontFamily: 'AppleSDEB',
                            fontSize: 32.sp,
                            letterSpacing: -2.0,
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        buildHorizontalCalendar(model, newVote),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          "시즌 & 주제별 커뮤니티",
                          style: TextStyle(
                            fontFamily: 'AppleSDB',
                            fontSize: 20.sp,
                            // fontWeight: FontWeight.w800,
                            letterSpacing: -1.0,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          height: 0,
                          color: Colors.black,
                          thickness: 2,
                        ),
                        // SizedBox(
                        //   height: 16,
                        // ),
                        Flexible(
                          child: Container(
                            // height: 500,
                            child: buildListView(
                                model, model.newVote ?? model.vote),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  ListView buildListView(VoteCommentViewModel model, VoteModel vote) {
    print(vote.subVotes.length);
    return ListView.builder(
      itemCount: vote.subVotes.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              ListTile(
                onTap: () {
                  _navigationService.navigateTo('seasonComment');
                },
                // leading: Container(
                //     alignment: Alignment.center,
                //     width: 60,
                //     height: 60,
                //     padding: EdgeInsets.all(4),
                //     decoration: BoxDecoration(
                //         color: Color(0xFFFFC7C7),
                //         border: Border.all(color: Colors.black, width: 2)),
                //     child: Text(
                //       model.seasonInfo.seasonName,
                //       textAlign: TextAlign.center,
                //       style: TextStyle(
                //         fontFamily: 'DmSans',
                //         fontSize: 16.sp,
                //         // fontWeight: FontWeight.w700,
                //         letterSpacing: 0,
                //         textBaseline: TextBaseline.ideographic,
                //       ),
                //     )),
                title: Text("자유 게시판",
                    style: TextStyle(
                      fontSize: 18.sp,
                      // fontWeight: FontWeight.bold,
                      fontFamily: 'AppleSDB',
                    )),
                subtitle: Text("rocketman님 외에 50명 이야기중"),
                // subtitle: Text("rocketman님 외에 50명 이야기중"),
              ),
            ],
          );
        } else {
          return buildEachCommunity(
            vote,
            vote.subVotes[index - 1],
            index,
          );
        }
      },
    );
  }

  Widget buildHorizontalCalendar(VoteCommentViewModel model, VoteModel vote) {
    return HorizontalCalendar(
      padding: EdgeInsets.fromLTRB(0, 6.h, 0, 0),
      defaultDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: Color(
            0xFFE0E0E0,
          )),
      height: 86,
      isDateDisabled: (dateTime) {
        // dateTime을 넣고 휴일 여부를 bool로
        return dateTime.isAfter(strToDate(model.address.date));
      },
      disabledDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: Color(
            0xFFF8F8F8,
          )),
      disabledDateTextStyle: TextStyle(
        fontSize: 20.sp,
        color: Color(0xFFC2C2C2),
        fontWeight: FontWeight.w800,
      ),
      disabledWeekDayTextStyle: TextStyle(
        fontSize: 12.sp,
        color: Color(0xFFC2C2C2),
      ),
      dateWidth: 48.w,
      onDateSelected: (dateTime) {
        String newBaseDate = dateToStr(dateTime);
        print(newBaseDate);
        DatabaseAddressModel newAddress;
        newAddress = DatabaseAddressModel(
          uid: model.address.uid,
          date: newBaseDate,
          category: model.address.category,
          season: model.address.season,
          isVoting: model.address.isVoting,
        );

        model.getNewVote(newAddress);
      },
      scrollController: _calendarController,
      minSelectedDateCount: 1,
      initialSelectedDates: strToDate(model.address.date),
      labelOrder: [LabelType.date, LabelType.weekday],
      dateTextStyle: TextStyle(
        fontSize: 24.sp,
        fontFamily: 'DmSans',
        height: 1,
        letterSpacing: -1.5,
        fontWeight: FontWeight.w800,
      ),
      weekDayTextStyle: TextStyle(
        height: 1,
        fontSize: 12.sp,
        fontFamily: 'DmSans',
      ),
      firstDate: DateTime(
          int.parse(model.seasonInfo.startDate.substring(0, 4)),
          int.parse(model.seasonInfo.startDate.substring(4, 6)),
          int.parse(model.seasonInfo.startDate.substring(6))),
      lastDate: nextNthBusinessDay(strToDate(model.address.date), 3),
      selectedDateTextStyle: TextStyle(
        fontFamily: 'DmSans',
        fontSize: 24.sp,
        height: 1,
        letterSpacing: -1.5,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      selectedWeekDayTextStyle: TextStyle(
        height: 1,
        fontSize: 12.sp,
        color: Colors.white,
        fontFamily: 'AppleSDB',
        // fontWeight: FontWeight.bold,
      ),
      selectedDecoration: BoxDecoration(
        color: Color(0xFF1EC8CF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              blurRadius: 5,
              color: Colors.black.withOpacity(.2),
              offset: Offset(1, 4))
        ],
      ),
    );
  }

  Widget buildEachCommunity(
    VoteModel vote,
    SubVote subVote,
    int index,
  ) {
    Color hexToColor(String code) {
      return Color(int.parse(code, radix: 16) + 0xFF0000000);
    }

    return Column(
      children: [
        Divider(
          height: 0,
        ),
        ListTile(
          onTap: () {
            _navigationService
                .navigateWithArgTo('subjectComment', [vote, index - 1]);
          },
          // leading: subVote.issueCode.length == 1
          //     ? Container(
          //         height: 60,
          //         width: 60,
          //         decoration: BoxDecoration(
          //           border: Border.all(
          //             width: 2,
          //             color: Colors.black,
          //           ),
          //           borderRadius: BorderRadius.circular(subVote.shape == null
          //               ? 0
          //               : subVote.shape[0] == 'oval'
          //                   ? 30
          //                   : 0),
          //           color: hexToColor(
          //             subVote.colorCode[0],
          //           ),
          //         ),
          //         child: Padding(
          //           padding: const EdgeInsets.all(2.0),
          //           child: Center(
          //             child: Text(
          //               subVote.title,
          //               style: TextStyle(
          //                 fontSize: 16.sp,
          //                 // fontWeight: FontWeight.w700,
          //                 fontFamily: 'AppleSDB',
          //               ),
          //               textAlign: TextAlign.center,
          //               overflow: TextOverflow.clip,
          //               maxLines: 2,
          //             ),
          //           ),
          //         ),
          //       )
          //     : Container(
          //         height: 60,
          //         width: 60,
          //         child: Stack(
          //           children: <Widget>[
          //             Container(
          //               width: subVote.shape == null
          //                   ? 35
          //                   : subVote.shape[0] == 'oval'
          //                       ? 40
          //                       : 35,
          //               height: subVote.shape == null
          //                   ? 35
          //                   : subVote.shape[0] == 'oval'
          //                       ? 40
          //                       : 35,
          //               decoration: BoxDecoration(
          //                   border: Border.all(
          //                     width: 2,
          //                     color: Colors.black,
          //                   ),
          //                   borderRadius:
          //                       BorderRadius.circular(subVote.shape == null
          //                           ? 0
          //                           : subVote.shape[0] == 'oval'
          //                               ? 30
          //                               : 0),
          //                   color: hexToColor(
          //                     subVote.colorCode[0],
          //                   )),
          //             ),
          //             Positioned(
          //                 bottom: 0,
          //                 right: 0,
          //                 child: Container(
          //                   width: subVote.shape == null
          //                       ? 35
          //                       : subVote.shape[1] == 'oval'
          //                           ? 40
          //                           : 35,
          //                   height: subVote.shape == null
          //                       ? 35
          //                       : subVote.shape[1] == 'oval'
          //                           ? 40
          //                           : 35,
          //                   decoration: BoxDecoration(
          //                       border: Border.all(
          //                         width: 2,
          //                         color: Colors.black,
          //                       ),
          //                       borderRadius:
          //                           BorderRadius.circular(subVote.shape == null
          //                               ? 0
          //                               : subVote.shape[1] == 'oval'
          //                                   ? 30
          //                                   : 0),
          //                       color: hexToColor(
          //                         subVote.colorCode[1],
          //                       )),
          //                 )),
          //           ],
          //         ),
          //         // color: Colors.red,
          //       ),
          title: Text(subVote.title,
              style: TextStyle(
                fontSize: 18.sp,
                // fontWeight: FontWeight.bold,
                fontFamily: 'AppleSDB',
              )),
          subtitle: Text("rocketman님 외에 50명 이야기중"),
        ),
      ],
    );
  }

  TabBar buildTabBar(VoteModel vote) {
    return TabBar(
      controller: _tabController,
      indicatorColor: Colors.red,
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.black,
      isScrollable: true,
      tabs: List.generate(
        vote.subVotes.length,
        (index) => subVoteList(
          vote.subVotes[index].title.toString(),
        ),
      ),
    );
  }

  Widget commentTabBarView(
    int subVoteIndex,
    BuildContext context,
    DatabaseAddressModel address,
    VoteModel vote,
    VoteCommentViewModel viewModel,
  ) {
    address.subVote = subVoteIndex.toString();
    // print("address" + address.date);

    // 차트에 표시할 포맷
    var f = new NumberFormat("##.0%");

    // 각 투표수 가져오기
    var numVoted0 = vote.subVotes[subVoteIndex].numVoted0 ?? 0;
    var numVoted1 = vote.subVotes[subVoteIndex].numVoted1 ?? 0;

    // 투표수 -> 퍼센티지 변환

    double vote0Percentage =
        (numVoted0 + numVoted1) == 0 ? 0 : numVoted0 / (numVoted0 + numVoted1);
    double vote1Percentage =
        (numVoted0 + numVoted1) == 0 ? 0 : numVoted1 / (numVoted0 + numVoted1);

    // Bar 차트에 들어갈 데이터 오브젝트
    var data = [
      VoteChart(vote.subVotes[subVoteIndex].voteChoices[0], vote0Percentage,
          Colors.red),
      VoteChart(vote.subVotes[subVoteIndex].voteChoices[1], vote1Percentage,
          Colors.blue),
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
            final color = charts.MaterialPalette.blue.shadeDefault.darker;
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
              color: charts.MaterialPalette.black),

          // Change the line colors to match text color.
          lineStyle:
              new charts.LineStyleSpec(color: charts.MaterialPalette.black),
        ),
      ),

      /// Assign a custom style for the measure axis.
      primaryMeasureAxis: new charts.NumericAxisSpec(
        showAxisLine: false,
        renderSpec: new charts.GridlineRendererSpec(
          // Tick and Label styling here.
          labelStyle: new charts.TextStyleSpec(
              fontSize: 14, // size in Pts.
              color: charts.MaterialPalette.black),

          // Change the line colors to match text color.
          lineStyle:
              new charts.LineStyleSpec(color: charts.MaterialPalette.black),
        ),
      ),
    );
    return StreamBuilder(
        //StreamProvider
        stream: viewModel.getPost(address),
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
                    vote.subVotes[subVoteIndex].voteChoices[0],
                    style: commentTitle(),
                  ),
                ),
                Text(
                  "vs",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontFamily: 'AdventPro',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 60.0),
                  child: Text(
                    vote.subVotes[subVoteIndex].voteChoices[1],
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
                        key: UniqueKey(),
                        controller: _controller,
                        // addAutomaticKeepAlives: true,
                        itemCount: commentModelList.length,
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return commentList(
                            subVoteIndex,
                            address,
                            commentModelList[index],
                            viewModel,
                          );
                        }),
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
          color: Colors.black,
        ),
      ),
    );
  }

  TextStyle commentTitle() {
    return TextStyle(
      color: Colors.black,
      fontSize: 30,
      fontFamily: 'AdventPro',
      fontWeight: FontWeight.bold,
    );
  }

// 댓글 리스트 위젯
  Widget commentList(
    int subVoteIndex,
    DatabaseAddressModel address,
    VoteCommentModel voteComment,
    VoteCommentViewModel viewModel,
  ) {
    address.subVote = subVoteIndex.toString();

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
                        voteComment.userName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'AdventPro',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        voteComment.choice ?? '선택 안 함',
                        style: TextStyle(
                          color: Colors.black,
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
                      voteComment.postText,
                      style: TextStyle(
                        color: Colors.black,
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
                voteComment.postDateTime == null
                    ? 'null'
                    : DateTime.now()
                            .difference(voteComment.postDateTime.toDate())
                            .inMinutes
                            .toString() +
                        ' Mins ago',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'AdventPro',
                ),
              ),
              voteComment.uid == uid
                  ? IconButton(
                      iconSize: 20,
                      onPressed: () {
                        viewModel.deleteComment(address, voteComment.postUid);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.grey[500],
                      )
                      // Text(
                      //   "삭제",
                      //   textAlign: TextAlign.end,
                      //   style: TextStyle(
                      //     color: Colors.black,
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
  // Widget commentInput(
  //   int subVoteIndex,
  //   TextEditingController controller,
  //   DatabaseAddressModel address,
  //   UserModel userModel,
  //   VoteModel voteModel,
  //   UserVoteModel userVoteModel,
  //   VoteCommentViewModel viewModel,
  // ) {
  //   address.subVote = subVoteIndex.toString();
  //   // 유저 코멘트 넣는 창
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Image.asset(
  //         'assets/images/avatar.png',
  //         width: 30,
  //       ),
  //       Container(
  //         width: 300,
  //         child: TextField(
  //           controller: controller,
  //           textAlign: TextAlign.start,
  //           textAlignVertical: TextAlignVertical.top,
  //           style: TextStyle(
  //             color: Colors.black,
  //           ),
  //           maxLines: 3,
  //           decoration: InputDecoration(
  //               focusedBorder: OutlineInputBorder(
  //                 borderSide: BorderSide(
  //                   color: Color(0xFFBDBDBD),
  //                   width: 1.0,
  //                 ),
  //               ),
  //               enabledBorder: OutlineInputBorder(
  //                 borderSide: BorderSide(
  //                   color: Color(0xFFBDBDBD),
  //                   width: 1.0,
  //                 ),
  //               ),
  //               hintText: '주제에 관한 생각을 말해주세요',
  //               hintStyle: TextStyle(
  //                 fontSize: 12,
  //                 color: Color(0xFF828282),
  //               )),
  //         ),
  //       ),
  //       GestureDetector(
  //         onTap: () {
  //           voteCommentModel = VoteCommentModel(
  //             uid: userModel.uid,
  //             userName: userModel.userName,
  //             postText: controller.text,
  //             choice: userVoteModel.voteSelected[subVoteIndex] == 0
  //                 ? null
  //                 : voteModel.subVotes[subVoteIndex].voteChoices[
  //                     userVoteModel.voteSelected[subVoteIndex] - 1],
  //             postDateTime: Timestamp.fromDate(DateTime.now().toUtc()),

  //             // postDateTime: DateTime.now(),
  //           );

  //           viewModel.postComments(
  //             address,
  //             voteCommentModel,
  //           );
  //           controller.text = '';
  //         },
  //         child: Icon(
  //           Icons.check_circle,
  //           color: Colors.black,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
