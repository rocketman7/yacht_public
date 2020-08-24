import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yachtOne/models/rank_model.dart';
import 'package:yachtOne/services/dialog_service.dart';
import '../locator.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import '../view_models/rank_view_model.dart';
import '../views/constants/size.dart';
import 'package:stacked/stacked.dart';
import '../views/loading_view.dart';
import '../views/widgets/navigation_bars_widget.dart';

class RankView extends StatefulWidget {
  final String uid;
  RankView(this.uid);

  @override
  _RankViewState createState() => _RankViewState();
}

class _RankViewState extends State<RankView> with TickerProviderStateMixin {
  final DatabaseService _databaseService = locator<DatabaseService>();
  final DialogService _dialogService = locator<DialogService>();

  RankModel rankModel;

  String uid;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double displayRatio = size.height / size.width;

    uid = widget.uid;

    return ViewModelBuilder<RankViewModel>.reactive(
      viewModelBuilder: () => RankViewModel(),
      builder: (context, model, child) => MaterialApp(
        home: FutureBuilder(
            future: Future.wait([
              model.getUser(uid),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserModel currentUserModel = snapshot.data[0];
                return Scaffold(
                  bottomNavigationBar: bottomNavigationBar(context),
                  backgroundColor: Color(0xFF363636),
                  body: SafeArea(
                    bottom: false,
                    child: Column(
                      children: <Widget>[
                        topBar(currentUserModel),
                        SizedBox(
                          height: displayRatio > 1.85 ? gap_l : gap_xs,
                        ),
                        Container(
                          height: 500,
                          child: rankListView(context),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return LoadingView();
              }
            }),
      ),
    );
  }

  Widget rankListView(
    BuildContext context,
  ) {
    return StreamBuilder(
        stream: _databaseService.getRankList(),
        builder: (context, snapshotStream) {
          List<RankModel> rankModelList = snapshotStream.data;
          if (snapshotStream.data == null) {
            return LoadingView();
          } else {
            return ListView.builder(
              itemCount: rankModelList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => rankList(rankModelList[index]),
            );
          }
        });
  }

  Widget rankList(
    RankModel rankModel,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            SizedBox(
              width: 5,
            ),
            Container(
              width: 300,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        rankModel.userName,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        rankModel.combo.toString(),
                      )
                    ],
                  ),
                  Text(rankModel.uid)
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
