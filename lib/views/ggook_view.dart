import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/user_model.dart';
import '../locator.dart';
import '../models/user_vote_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/ggook_view_model.dart';
import 'widgets/ggook_widget.dart';

class GgookView extends StatefulWidget {
  // votesToday Object를 voteSelectView로부터 받아온다.
  // 이 리스트에는 uid, voteModel(오늘의 vote 데이터 모델), voteList(해당 사용자가 선택한 투표 리스트)가 있음
  final List<Object> ggookArgs;
  GgookView(this.ggookArgs);

  @override
  _GgookViewState createState() => _GgookViewState();
}

class _GgookViewState extends State<GgookView> with TickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  List<Object> ggookArgs; // address, user, vote, listSelected, idx(= 0),
  DatabaseAddressModel _address;
  UserModel _user;
  VoteModel _vote;
  UserVoteModel _userVote;
  List<int> _listSelected;
  int _idx;

  // LongPressGestureRecognizer _longPressGestureRecognizer =
  //     LongPressGestureRecognizer(
  //   duration: Duration(milliseconds: 3000),
  // );

  TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  AnimationController _animationController;
  Animation _expandCircleAnimation;
  // final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
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

    checkDeadLine();
  }

  // 현재시간과 AddressModel의 date를 비교해서 투표 마감시간 체크 every second
  void checkDeadLine() {}

  @override
  Widget build(BuildContext context) {
    ggookArgs =
        widget.ggookArgs; // address, user, vote, listSelected, idx(= 0),
    print(ggookArgs);
    _address = ggookArgs[0];
    _user = ggookArgs[1];
    _vote = ggookArgs[2];
    _userVote = ggookArgs[3];
    _listSelected = ggookArgs[4];
    _idx = ggookArgs[5];

    return ViewModelBuilder<GgookViewModel>.reactive(
      viewModelBuilder: () => GgookViewModel(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          return Future(() => false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: GgookWidget(
            _address,
            _user,
            _vote,
            _listSelected,
            _idx,
            _userVote,
            model,
          ),
        ),
      ),
    );
  }
}
