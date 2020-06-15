import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/sub_vote_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/home_view_model.dart';
import 'package:yachtOne/views/loading_view.dart';
// import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AuthService _authService = locator<AuthService>();
  NavigationService _navigationService = locator<NavigationService>();
  DatabaseService _databaseService = locator<DatabaseService>();

  final VoteModel votesToday = voteToday;
  final List<SubVote> subvotesToday = subVotes;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      // StreamBuilder로 onAuthChanged를 듣다가 아래 if 조건이 만족하면 model.getUser()의 FutureBuilder를 return.
      builder: (context, model, child) => StreamBuilder<Object>(
          stream: _authService.auth.onAuthStateChanged,
          builder: (context, snapshotStream) {
            if (snapshotStream.connectionState == ConnectionState.active &&
                snapshotStream.hasData) {
              return FutureBuilder(
                future: model.getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return WillPopScope(
                      onWillPop: () => Future.value(false),
                      child: Scaffold(
                        backgroundColor: Colors.red,
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //이미 snapshot에 data가 있는 상태이기 때문에 아래와 같이 입력하면 Text null에러가 나지 않는다.
                            Text(
                              snapshot.data.email,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Container(
                                // color: Colors.white,
                                padding: EdgeInsets.all(8),
                                // constraints: BoxConstraints.expand(),
                                alignment: Alignment.center,
                                width: 200,
                                height: 200,
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
                            SizedBox(height: 15),
                            Text(
                              snapshot.data.userName +
                                  '  ' +
                                  snapshot.data.combo.toString() +
                                  ' Combo',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              onPressed: () {
                                _navigationService.navigateWithArgTo(
                                    'voteSelect', snapshot.data.uid.toString());
                              },
                              child: Text(
                                "Go To Vote View",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RaisedButton(
                              onPressed: () {
                                _databaseService.addVotes(
                                    voteToday, subvotesToday);
                              },
                              child: Text(
                                "Add Votes Test",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
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
              ;
            }
          }),
    );
  }
}
