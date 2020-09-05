import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/models/database_address_model.dart';
import 'package:yachtOne/models/vote_model.dart';
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
// import '../models/database_address_model.dart';
// import '../models/temp_address_constant.dart';
// import '../models/vote_model.dart';
// import '../models/sub_vote_model.dart';

class HomeView extends StatefulWidget {
  Function goToTab;
  HomeView(this.goToTab);
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final HomeViewModel _viewModel = HomeViewModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  // GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');
  // final BottomNavigationBar _navigationBar = navBarGlobalKey.currentWidget;

  Future<List<Object>> _getAllModel;
  Future<UserModel> _userModel;
  Future<DatabaseAddressModel> _addressModel;
  Future<VoteModel> _voteModel;
  // addVote 버튼때문에 임시로 만든 것
  // final VoteModel votesToday = voteToday;
  // final List<SubVote> subvotesToday = subVotes;
  // DatabaseAddressModel addressModel;

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
    _getAllModel = _viewModel.getAllModel(_viewModel.uid);
  }

  @override
  void didUpdateWidget(HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("oldWidgetUpdate");
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
    double displayRatio = size.height / size.width;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      // onModelReady: (model) => print("onModelReady" + model.uid),
      // StreamBuilder로 onAuthChanged를 듣다가 아래 if 조건이 만족하면 model.getUser()의 FutureBuilder를 return.
      builder: (context, model, child) {
        print("Start" + DateTime.now().toString());
        return FutureBuilder(
          future: _getAllModel, // address, user, vote 모델 순서대로
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.hasData) {
              print("End" + DateTime.now().toString());
              List<Object> _allModel = snapshot.data;
              DatabaseAddressModel address = _allModel[0];
              UserModel user = _allModel[1];
              VoteModel vote = _allModel[2];

              // UserModel userModel = model.getUser(_widgetAddress.uid);
              // WillPopScope: Back 버튼 막기
              return WillPopScope(
                onWillPop: () async {
                  _navigatorKey.currentState.maybePop();
                  return false;
                },
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: displayRatio > 1.85 ? gap_l : gap_xs,
                    ),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            //이미 snapshot에 data가 있는 상태이기 때문에 아래와 같이 입력하면 Text null에러가 나지 않는다.
                            // topBar(userModel),
                            SizedBox(height: 15),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40)),
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
                              onPressed: () {
                                _navigationService.navigateWithArgTo(
                                    'rank', model.uid.toString());
                              },
                              child: Text('rank 페이지 가기'),
                            ),
                            SizedBox(height: 20),
                            RaisedButton(
                              onPressed: () {
                                _navigationService
                                    .navigateWithArgTo(
                                        'mypage', model.uid.toString())
                                    .then((value) {
                                  // LoadingView(),
                                  return setState(() => {
                                        _getAllModel = _viewModel
                                            .getAllModel(_viewModel.uid)
                                      });
                                });
                              },
                              child: Text('mypage 페이지 가기'),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              vote.voteDate,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              user.userName,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              vote.subVotes[0].title.toString(),
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            )

                            // RaisedButton(
                            //   onPressed: () {
                            //     addressModel = DatabaseAddressModel(
                            //       uid: currentUserModel.uid,
                            //       date: date,
                            //       category: category,
                            //       season: season,
                            //     );

                            //     _databaseService.addVotes(
                            //       voteToday,
                            //       subvotesToday,
                            //       addressModel,
                            //     );
                            //   },
                            //   child: Text(
                            //     "Add Votes Test",
                            //     style: TextStyle(
                            //       fontSize: 20,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
              // snapshot의 데이터가 fetch될 동안 아래 화면 보여준다.
            } else {
              return LoadingView();
            }
          },
        );
      },
    );
  }
}
