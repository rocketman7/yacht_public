import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';
import '../models/user_vote_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/vote_view_model.dart';
import '../views/constants/size.dart';
import '../views/widgets/vote_widget.dart';

class Vote0View extends StatefulWidget {
  // votesToday Object를 voteSelectView로부터 받아온다.
  // 이 리스트에는 uid, voteModel(오늘의 vote 데이터 모델), voteList(해당 사용자가 선택한 투표 리스트)가 있음
  final List<Object> votesToday;
  Vote0View(this.votesToday);

  @override
  _Vote0ViewState createState() => _Vote0ViewState();
}

class _Vote0ViewState extends State<Vote0View> with TickerProviderStateMixin {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  List<Object> votesToday;
  String uid;
  VoteModel voteModel;
  List<int> voteList;
  UserVoteModel userVote;

  LongPressGestureRecognizer _longPressGestureRecognizer =
      LongPressGestureRecognizer(
    duration: Duration(milliseconds: 3000),
  );

  TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();
  int voteIdx = 0;

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
    userVote = UserVoteModel(
      uid: uid,
      voteDate: voteModel.voteDate,
      subVoteCount: voteModel.voteCount,
      voteSelected: List<int>.generate(voteModel.voteCount, (index) => 0),
      isVoted: false,
    );

    return ViewModelBuilder<VoteViewModel>.reactive(
      viewModelBuilder: () => VoteViewModel(),
      builder: (context, model, child) => MaterialApp(
        home: Scaffold(
            body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.5, 1],
                  colors: <Color>[
                    Colors.white,
                    Color(0xFFC4FEF3),
                    Colors.white,
                  ],
                ),
              ),
            ),
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  voteModel.subVotes[voteList[voteIdx]].title,
                  style: TextStyle(
                    color: Color(0xff5F5F5F),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: gap_m,
                ),
                Text(
                  voteModel.subVotes[voteList[voteIdx]].description,
                  style: TextStyle(
                    color: Color(0xff5F5F5F),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: gap_m,
                ),
                Text(
                  "꾸욱 눌러서 투표하기",
                  style: TextStyle(
                    color: Color(0xff5F5F5F),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
            Positioned(
              top: 240,
              left: 50,
              // child: RawMaterialButton
              child: RawGestureDetector(
                gestures: <Type, GestureRecognizerFactory>{
                  LongPressGestureRecognizer:
                      GestureRecognizerFactoryWithHandlers<
                          LongPressGestureRecognizer>(
                    () => _longPressGestureRecognizer,
                    (_longPressGestureRecognizer) {
                      _longPressGestureRecognizer
                        ..onLongPress = () {
                          setState(() {
                            _animationController.forward();
                          });

                          if (voteIdx + 1 < voteList.length) {
                            List<int> tempList = userVote.voteSelected;
                            tempList.fillRange(
                                voteList[voteIdx], voteList[voteIdx] + 1, 1);

                            userVote.voteSelected = tempList;
                            print(tempList);
                            model.addUserVoteDB(userVote);

                            _navigationService.navigateWithArgTo(
                                'vote' + (voteIdx + 1).toString(),
                                [uid, voteModel, voteList, userVote]);
                          } else {
                            // TODO: userVote 모델로 만들어서 넘겨야함.
                            List<int> tempList = userVote.voteSelected;
                            tempList.fillRange(
                                voteList[voteIdx], voteList[voteIdx] + 1, 1);

                            userVote.voteSelected = tempList;
                            userVote.isVoted = true;
                            print(tempList);
                            model.addUserVoteDB(userVote);

                            _navigationService.navigateWithArgTo(
                              'voteComment',
                              uid,
                            );
                          }
                        }
                        ..onLongPressEnd = (details) {
                          setState(() {
                            _animationController.reverse();
                          });
                        };
                    },
                  ),
                  // TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                  //         TapGestureRecognizer>(() => _tapGestureRecognizer,
                  //     (_tapGestureRecognizer) {
                  //   _tapGestureRecognizer
                  //     ..onTap = () {
                  //       setState(() {
                  //         _animationController.forward();
                  //       });
                  //     };
                  // })
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    color: Colors.blue,
                    width: 100 * _expandCircleAnimation.value,
                    height: 100 * _expandCircleAnimation.value,
                    alignment: Alignment.center,
                    // padding: EdgeInsets.all(40),
                    child: Text(
                      voteModel.subVotes[voteList[voteIdx]].voteChoices[0],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9EA6F1)),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 240,
              right: 50,
              child: RawMaterialButton(
                onPressed: () {},
                onLongPress: () {
                  print('longPressed');
                  print(voteIdx);
                  print(voteList.length);
                  print('vote' + (voteIdx + 2).toString());
                  if (voteIdx + 1 < voteList.length) {
                    List<int> tempList = userVote.voteSelected;
                    tempList.fillRange(
                        voteList[voteIdx], voteList[voteIdx] + 1, 2);

                    userVote.voteSelected = tempList;
                    print(tempList);
                    model.addUserVoteDB(userVote);

                    _navigationService.navigateWithArgTo(
                        'vote' + (voteIdx + 1).toString(),
                        [uid, voteModel, voteList, userVote]);
                  } else {
                    // TODO: userVote 모델로 만들어서 넘겨야함.
                    List<int> tempList = userVote.voteSelected;
                    tempList.fillRange(
                        voteList[voteIdx], voteList[voteIdx] + 1, 2);

                    userVote.voteSelected = tempList;
                    userVote.isVoted = true;
                    print(tempList);
                    model.addUserVoteDB(userVote);
                    _navigationService.navigateWithArgTo(
                      'voteComment',
                      uid,
                    );
                  }
                },
                elevation: 2.0,
                fillColor: Color(0xFFBDEEEF),
                // child: Icon(
                //   Icons.pause,
                // //   size: 35.0,
                // ),
                padding: EdgeInsets.all(40.0),
                shape: CircleBorder(),
                child: Text(
                  voteModel.subVotes[voteList[voteIdx]].voteChoices[1],
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9EA6F1)),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
