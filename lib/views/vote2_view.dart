import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/vote_select_view_model.dart';
import 'package:yachtOne/view_models/vote_view_model.dart';
import 'package:yachtOne/views/constants/size.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:yachtOne/views/loading_view.dart';
import 'package:yachtOne/views/widgets/vote_card_widget.dart';
import 'package:yachtOne/views/widgets/vote_selected_widget.dart';
import 'package:flutter/material.dart';

class Vote2View extends StatefulWidget {
  final List<Object> votesToday;
  Vote2View(this.votesToday);

  @override
  _Vote2ViewState createState() => _Vote2ViewState();
}

class _Vote2ViewState extends State<Vote2View> {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  List<Object> votesToday;

  String uid;
  VoteModel voteModel;
  List<int> voteList;
  int voteIdx = 1;

  @override
  Widget build(BuildContext context) {
    votesToday = widget.votesToday;
    print(votesToday);
    uid = votesToday[0];
    voteModel = votesToday[1];
    voteList = votesToday[2];
    print(uid);
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
                    stops: [0, 1],
                    colors: <Color>[
                      const Color(0xFF7BE0C8),
                      const Color(0xFF53D3D8),
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
                      color: Colors.white,
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
                      color: Colors.white.withOpacity(.7),
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
                      color: Colors.white.withOpacity(.7),
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
                child: FlatButton(
                  onPressed: () {
                    print('pressed');
                  },

                  onLongPress: () {
                    print('longPressed');
                    if (voteIdx < voteList.length) {
                      _navigationService.navigateWithArgTo('vote2', [
                        uid,
                        voteModel,
                        voteList,
                      ]);
                    } else {
                      _navigationService.navigateWithArgTo('voteBoard', [
                        uid,
                        voteList,
                      ]);
                    }
                  },
                  hoverColor: Colors.white,
                  color: Color(0xFFBDEEEF),
                  // elevation: 2.0,
                  // fillColor: Color(0xFFBDEEEF),
                  // child: Icon(
                  //   Icons.pause,
                  // //   size: 35.0,
                  // ),
                  padding: EdgeInsets.all(40.0),
                  shape: CircleBorder(),
                  child: Text(
                    voteModel.subVotes[voteList[voteIdx]].voteChoices[0],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF1929F),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 240,
                right: 50,
                child: RawMaterialButton(
                  onPressed: () {},
                  onLongPress: () {},
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
          ),
        ),
      ),
    );
  }
}
