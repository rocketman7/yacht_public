import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';
import '../models/sub_vote_model.dart';
import '../models/user_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/home_view_model.dart';
import '../views/constants/size.dart';
import '../views/loading_view.dart';

import '../views/widgets/navigation_bars_widget.dart';
// import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _phoneVerificationController =
      TextEditingController();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // addVote 버튼때문에 임시로 만든 것
  // final VoteModel votesToday = voteToday;
  // final List<SubVote> subvotesToday = subVotes;

  //phone auth test

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),

      // StreamBuilder로 onAuthChanged를 듣다가 아래 if 조건이 만족하면 model.getUser()의 FutureBuilder를 return.
      builder: (context, model, child) => StreamBuilder<Object>(
          stream: _authService.auth.authStateChanges(),
          builder: (context, snapshotStream) {
            if (snapshotStream.connectionState == ConnectionState.active &&
                snapshotStream.hasData) {
              return FutureBuilder(
                future: model.getUser(),
                builder: (context, snapshot) {
                  UserModel currentUserModel = snapshot.data;
                  if (snapshot.hasData) {
                    // WillPopScope: Back 버튼 막기
                    return WillPopScope(
                      onWillPop: () => Future.value(false),
                      child: Scaffold(
                        resizeToAvoidBottomPadding: true,
                        backgroundColor: Color(0xFF363636),
                        bottomNavigationBar: bottomNavigationBar(context),
                        body: SafeArea(
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
                                    topBar(currentUserModel),
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40)),
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
                                      onPressed: () {
                                        _navigationService.navigateWithArgTo(
                                            'voteSelect',
                                            currentUserModel.uid.toString());
                                      },
                                      child: Text(
                                        "Go To Vote View",
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    // SizedBox(height: 20),
                                  ],
                                ),
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
            } else {
              return LoadingView();
            }
          }),
    );
  }
}
