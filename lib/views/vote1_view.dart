import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:yachtOne/locator.dart';
import 'package:yachtOne/models/user_vote_model.dart';
import 'package:yachtOne/models/vote_model.dart';
import 'package:yachtOne/services/auth_service.dart';
import 'package:yachtOne/services/database_service.dart';
import 'package:yachtOne/services/navigation_service.dart';
import 'package:yachtOne/view_models/vote_view_model.dart';
import 'package:yachtOne/views/widgets/vote_widget.dart';

class Vote1View extends StatefulWidget {
  final List<Object> votesToday;
  Vote1View(this.votesToday);

  @override
  _Vote1ViewState createState() => _Vote1ViewState();
}

class _Vote1ViewState extends State<Vote1View> {
  final NavigationService _navigationService = locator<NavigationService>();
  final AuthService _authService = locator<AuthService>();
  final DatabaseService _databaseService = locator<DatabaseService>();

  List<Object> votesToday;

  String uid;
  VoteModel voteModel;
  List<int> voteList;
  int voteIdx = 1;

  UserVoteModel userVote;

  @override
  Widget build(BuildContext context) {
    votesToday = widget.votesToday;
    print(votesToday);
    uid = votesToday[0];
    voteModel = votesToday[1];
    voteList = votesToday[2];
    userVote = votesToday[3];

    return ViewModelBuilder<VoteViewModel>.reactive(
      viewModelBuilder: () => VoteViewModel(),
      builder: (context, model, child) => MaterialApp(
        home: Scaffold(
          body: kkuuk(voteModel, voteIdx, voteList, userVote, uid,
              _navigationService, model),
        ),
      ),
    );
  }
}
