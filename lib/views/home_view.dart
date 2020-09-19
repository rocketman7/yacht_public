import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/views/temp_not_voting_view.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/home_view_model.dart';
import '../views/constants/size.dart';
import '../views/loading_view.dart';
import 'startup_view.dart';
import '../views/widgets/navigation_bars_widget.dart';

// vote temp data 넣을 때 필요한 파일들
import '../models/database_address_model.dart';
import '../models/temp_address_constant.dart';
import '../models/vote_model.dart';
import '../models/sub_vote_model.dart';

class HomeView extends StatefulWidget {
  final Function goToTab;
  HomeView(this.goToTab);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  // GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');
  // final BottomNavigationBar _navigationBar = navBarGlobalKey.currentWidget;

  //phone auth test

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    // _authUserState = _viewModel.authUserState;
    // _addressModel = _viewModel.getAddress();
    // _userModel = _viewModel.getUser(_viewModel.uid);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _getAllModel = _viewModel.getAllModel(_viewModel.uid);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final BottomNavigationBar navigationBar = navBarGlobalKey.currentWidget;
    print("homeViewBuild");
    Size size = MediaQuery.of(context).size;
    deviceHeight = size.height;
    deviceWidth = size.width;
    double displayRatio = deviceHeight / deviceWidth;
    return ViewModelBuilder.reactive(
        viewModelBuilder: () => HomeViewModel(),
        // onModelReady: (model) => print("onModelReady" + model.uid),
        // StreamBuilder로 onAuthChanged를 듣다가 아래 if 조건이 만족하면 model.getUser()의 FutureBuilder를 return.
        builder: (context, model, child) {
          print("Start" + DateTime.now().toString());

          // UserModel userModel = model.getUser(_widgetAddress.uid);
          // WillPopScope: Back 버튼 막기
          return model.isBusy
              ? LoadingView()
              : Scaffold(
                  body: WillPopScope(
                    onWillPop: () async {
                      _navigatorKey.currentState.maybePop();
                      return false;
                    },
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: 70,
                                      width: 70,
                                      color: Color(0xFF1EC8CF),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 3,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                30,
                                              )),
                                          child: Text(
                                            "SEASON 1",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Text(model.user.userName,
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontFamily: 'DmSans',
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "현재 상금가치",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("5,000,000",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "보유중인 꾸욱",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("7",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "현재 콤보",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text("11",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Divider(),
                                SizedBox(
                                  height: 14,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("오늘의 예측",
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(model.vote.subVotes.length.toString(),
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1EC8CF),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                buildRow(model, 0),
                                SizedBox(
                                  height: 8,
                                ),
                                buildRow(model, 1),
                                SizedBox(
                                  height: 8,
                                ),
                                buildRow(model, 2),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () => widget.goToTab(1),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 50,
                                    ),
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(
                                          40,
                                        ))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "꾸욱",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFFFFFFF),
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          color: Color(0xFF666666),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 14,
                                ),
                                Divider(),
                                SizedBox(
                                  height: 14,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text("시즌 상위",
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text("5",
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1EC8CF),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "10,345명의 참여자",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF9C9C9C),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );

          // snapshot의 데이터가 fetch될 동안 아래 화면 보여준다.
        });
  }

  Row buildRow(model, int idx) {
    // 선택지 수
    int numOfChoices = model.vote.subVotes[idx].issueCode.length;
    if (numOfChoices == 1) {
      return Row(
        // #1
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 4.0,
                color: Color(0xFFFF74D5),
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(model.vote.subVotes[idx].title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF74D5),
                )),
          ),
        ],
      );
    } else {
      return Row(
        // #1
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 4.0,
                color: Color(0xFFFF74D5),
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(model.vote.subVotes[idx].voteChoices[0],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF74D5),
                )),
          ),
          SizedBox(
            width: 6,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(width: 4),
                // color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(40))),
            child: Text(
              "vs",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            width: 6,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                width: 4.0,
                color: Color(0xFF71FF01),
              ),
              // borderRadius: BorderRadius.all(
              //     Radius.circular(30)),
            ),
            child: Text(model.vote.subVotes[idx].voteChoices[1],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF71FF01),
                )),
          ),
        ],
      );
    }
  }

  Column buildColumn(model, VoteModel vote, UserModel user) {
    return Column(
      children: <Widget>[
        //이미 snapshot에 data가 있는 상태이기 때문에 아래와 같이 입력하면 Text null에러가 나지 않는다.
        // topBar(userModel),
        // SizedBox(height: 15),
        Center(
          child: Container(
            // color: Colors.white,
            padding: EdgeInsets.all(8),
            // constraints: BoxConstraints.expand(),
            alignment: Alignment.center,
            width: 200,
            height: 50,
            // transform: Matrix4.rotationZ(.5),
            decoration: BoxDecoration(
              // color: Colors.blueGrey,
              border: Border.all(
                color: Colors.white,
                width: 0.5,
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 4.0,
                  spreadRadius: 2.0,
                  offset: Offset(4, 4),
                )
              ],
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blueGrey,
                ],
              ),
              // shape: BoxShape.circle,
            ),
            child: FlatButton(
              onPressed: () {
                model.signOut();
              },
              child: Text(
                "Sign Out",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        RaisedButton(
          onPressed: () => widget.goToTab(1),
          child: Text(
            "주제선택 페이지로 가기",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        // SizedBox(height: 20),
        SizedBox(height: 20),
        RaisedButton(
          onPressed: () => widget.goToTab(3),
          child: Text('rank 페이지 가기'),
        ),
        SizedBox(height: 20),
        RaisedButton(
          onPressed: () => widget.goToTab(4),
          // () {
          //   _navigationService
          //       .navigateWithArgTo(
          //           'mypage', model.uid.toString())
          //       .then((value) {
          //     // LoadingView(),
          //     return setState(() => {
          //           _getAllModel = _viewModel
          //               .getAllModel(_viewModel.uid)
          //         });
          //   });
          // },
          child: Text('mypage 페이지 가기'),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          vote.voteDate,
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          user.userName,
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          vote.subVotes[0].title.toString(),
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
