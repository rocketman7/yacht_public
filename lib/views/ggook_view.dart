import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';
import '../models/user_vote_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/ggook_view_model.dart';
import 'widgets/vote_widget.dart';

class GgookView extends StatefulWidget {
  // votesToday Object를 voteSelectView로부터 받아온다.
  // 이 리스트에는 uid, voteModel(오늘의 vote 데이터 모델), voteList(해당 사용자가 선택한 투표 리스트)가 있음
  final List<Object> votesToday;
  GgookView(this.votesToday);

  @override
  _GgookViewState createState() => _GgookViewState();
}

class _GgookViewState extends State<GgookView> with TickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  List<Object> votesToday;
  String uid;
  VoteModel voteModel;
  List<int> voteList;
  UserVoteModel userVote;

  int voteIdx;
  // LongPressGestureRecognizer _longPressGestureRecognizer =
  //     LongPressGestureRecognizer(
  //   duration: Duration(milliseconds: 3000),
  // );

  TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  AnimationController _animationController;
  Animation _expandCircleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    )..addListener(() {
        setState(() {});
      });

    _expandCircleAnimation =
        Tween(begin: 1.0, end: 2.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
  }

  @override
  Widget build(BuildContext context) {
    votesToday = widget.votesToday;
    print(votesToday);
    uid = votesToday[0];
    voteModel = votesToday[1];
    voteList = votesToday[2];
    voteIdx = votesToday[3];
    userVote = UserVoteModel(
      uid: uid,
      voteDate: voteModel.voteDate,
      subVoteCount: voteModel.voteCount,
      voteSelected: List<int>.generate(voteModel.voteCount, (index) => 0),
      isVoted: false,
    );

    return ViewModelBuilder<GgookViewModel>.reactive(
      viewModelBuilder: () => GgookViewModel(),
      builder: (context, model, child) => MaterialApp(
        home: Scaffold(
          body: voteWidget(voteModel, voteIdx, voteList, userVote, uid, model),
        ),
      ),
    );
  }
}
