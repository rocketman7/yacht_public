import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../locator.dart';
import '../models/user_vote_model.dart';
import '../models/vote_model.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/navigation_service.dart';
import '../view_models/vote_view_model.dart';
import '../views/widgets/vote_widget.dart';

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
  int voteIdx = 2;

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
          body: voteWidget(voteModel, voteIdx, voteList, userVote, uid, model),
        ),
      ),
    );
  }
}
