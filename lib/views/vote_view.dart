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

class VoteView extends StatefulWidget {
  final List<Object> votesToday;
  VoteView(this.votesToday);

  @override
  _VoteViewState createState() => _VoteViewState();
}

class _VoteViewState extends State<VoteView> {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  @override
  Widget build(BuildContext context) {
    print(widget.votesToday[1]);
    VoteModel voteModel = widget.votesToday[0];
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
              Positioned(
                top: 540,
                left: 250,
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
                    voteModel.subVotes[0].voteChoices[0],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue.withOpacity(.7),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 240,
                left: 50,
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
                    voteModel.subVotes[0].voteChoices[1],
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue.withOpacity(.7),
                    ),
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
